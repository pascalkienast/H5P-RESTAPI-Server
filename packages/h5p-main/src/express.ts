import 'dotenv/config';

import { dir, DirectoryResult } from 'tmp-promise';
import bodyParser from 'body-parser';
import express from 'express';
import fileUpload from 'express-fileupload';
import i18next from 'i18next';
import i18nextFsBackend from 'i18next-fs-backend';
import i18nextHttpMiddleware from 'i18next-http-middleware';
import path from 'path';
import fs from 'fs-extra';

import {
    h5pAjaxExpressRouter,
    libraryAdministrationExpressRouter,
    contentTypeCacheExpressRouter,
    IRequestWithUser
} from '@lumieducation/h5p-express';
import H5PHtmlExporter from '@lumieducation/h5p-html-exporter';
import * as H5P from '@lumieducation/h5p-server';

import startPageRenderer from './startPageRenderer';
import expressRoutes from './expressRoutes';
import User from './User';
import createH5PEditor from './createH5PEditor';
import { displayIps, clearTempFiles } from './utils';

let tmpDir: DirectoryResult;

// Determine the correct paths based on environment variables or defaults
const dataDir = process.env.DATA_DIR || path.join(__dirname, '../h5p'); // Default for local dev
const contentPath = path.join(dataDir, 'content');
const userDataPath = path.join(dataDir, 'user-data');
const librariesPath = path.join(__dirname, '../h5p/libraries'); // Libraries are part of the build, likely read-only access needed
const temporaryPath = '/tmp'; // Use Cloudron's writable /tmp for temporary files

// Ensure target directories exist within the writable data directory
// Note: This might be better placed in start.sh, but doing it here ensures it
// works if start.sh logic changes. fs-extra handles mkdirp.
fs.ensureDirSync(contentPath);
fs.ensureDirSync(userDataPath);

const start = async (): Promise<void> => {
    const useTempUploads = process.env.TEMP_UPLOADS === 'true';
    if (useTempUploads && process.env.NODE_ENV !== 'production') { // Use tmp-promise only locally
        // In Cloudron, /tmp is already available and managed.
        tmpDir = await dir({ keep: false, unsafeCleanup: true });
    }
    const effectiveTempPath = useTempUploads && tmpDir ? tmpDir.path : temporaryPath;

    // We use i18next to localize messages sent to the user. You can use any
    // localization library you like.
    const translationFunction = await i18next
        .use(i18nextFsBackend)
        .use(i18nextHttpMiddleware.LanguageDetector) // This will add the
        // properties language and languages to the req object. See
        // https://github.com/i18next/i18next-http-middleware#adding-own-detection-functionality
        // how to detect language in your own fashion. You can also choose not
        // to add a detector if you only want to use one language.
        .init({
            backend: {
                loadPath: path.join(
                    __dirname,
                    '../node_modules/@lumieducation/h5p-server/build/assets/translations/{{ns}}/{{lng}}.json'
                )
            },
            debug: process.env.DEBUG && process.env.DEBUG.includes('i18n'),
            defaultNS: 'server',
            fallbackLng: 'en',
            ns: [
                'client',
                'copyright-semantics',
                'hub',
                'library-metadata',
                'metadata-semantics',
                'mongo-s3-content-storage',
                's3-temporary-storage',
                'server',
                'storage-file-implementations'
            ],
            preload: ['en', 'de'] // If you don't use a language detector of
            // i18next, you must preload all languages you want to use!
        });

    // Load the configuration file from the local file system
    const config = await new H5P.H5PConfig(
        new H5P.fsImplementations.JsonStorage(
            path.join(__dirname, '../config.json')
        )
    ).load();

    // The H5PEditor object is central to all operations of h5p-nodejs-library
    // if you want to user the editor component.
    //
    // To create the H5PEditor object, we call a helper function, which
    // uses implementations of the storage classes with a local filesystem
    // or a MongoDB/S3 backend, depending on the configuration values set
    // in the environment variables.
    // In your implementation, you will probably instantiate H5PEditor by
    // calling new H5P.H5PEditor(...) or by using the convenience function
    // H5P.fs(...).
    const h5pEditor: H5P.H5PEditor = await createH5PEditor(
        config,
        librariesPath, // Use the path determined above
        contentPath, // Use the path determined above (writable in Cloudron)
        effectiveTempPath, // Use the path determined above (writable in Cloudron)
        userDataPath, // Use the path determined above (writable in Cloudron)
        (key, language) => translationFunction(key, { lng: language })
    );

    // The H5PPlayer object is used to display H5P content.
    const h5pPlayer = new H5P.H5PPlayer(
        h5pEditor.libraryStorage,
        h5pEditor.contentStorage,
        config,
        undefined,
        undefined,
        (key, language) => translationFunction(key, { lng: language }),
        undefined,
        h5pEditor.contentUserDataStorage
    );

    // We now set up the Express server in the usual fashion.
    const server = express();

    server.use(bodyParser.json({ limit: '500mb' }));
    server.use(
        bodyParser.urlencoded({
            extended: true
        })
    );

    // Configure file uploads
    server.use(
        fileUpload({
            limits: { fileSize: h5pEditor.config.maxTotalSize },
            useTempFiles: useTempUploads,
            tempFileDir: effectiveTempPath // Use the determined temp path
        })
    );

    // delete temporary files left over from uploads
    if (useTempUploads && tmpDir) { // Only cleanup tmp-promise directory
        server.use((req: express.Request & { files: any }, res, next) => {
            res.on('finish', async () => clearTempFiles(req));
            next();
        });
    }

    // It is important that you inject a user object into the request object!
    // The Express adapter below (H5P.adapters.express) expects the user
    // object to be present in requests.
    // In your real implementation you would create the object using sessions,
    // JSON webtokens or some other means.
    server.use((req: IRequestWithUser, res, next) => {
        req.user = new User();
        next();
    });

    // The i18nextExpressMiddleware injects the function t(...) into the req
    // object. This function must be there for the Express adapter
    // (H5P.adapters.express) to function properly.
    server.use(i18nextHttpMiddleware.handle(i18next));

    // The Express adapter handles GET and POST requests to various H5P
    // endpoints. You can add an options object as a last parameter to configure
    // which endpoints you want to use. In this case we don't pass an options
    // object, which means we get all of them.
    server.use(
        h5pEditor.config.baseUrl,
        h5pAjaxExpressRouter(
            h5pEditor,
            path.resolve(path.join(__dirname, '../h5p/core')), // the path on the local disc where the
            // files of the JavaScript client of the player are stored
            path.resolve(path.join(__dirname, '../h5p/editor')), // the path on the local disc where the
            // files of the JavaScript client of the editor are stored
            undefined,
            'auto' // You can change the language of the editor here by setting
            // the language code you need here. 'auto' means the route will try
            // to use the language detected by the i18next language detector.
        )
    );

    // The expressRoutes are routes that create pages for these actions:
    // - Creating new content
    // - Editing content
    // - Saving content
    // - Deleting content
    server.use(
        h5pEditor.config.baseUrl,
        expressRoutes(
            h5pEditor,
            h5pPlayer,
            'auto' // You can change the language of the editor by setting
            // the language code you need here. 'auto' means the route will try
            // to use the language detected by the i18next language detector.
        )
    );

    // The LibraryAdministrationExpress routes are REST endpoints that offer
    // library management functionality.
    server.use(
        `${h5pEditor.config.baseUrl}/libraries`,
        libraryAdministrationExpressRouter(h5pEditor)
    );

    // The ContentTypeCacheExpress routes are REST endpoints that allow updating
    // the content type cache manually.
    server.use(
        `${h5pEditor.config.baseUrl}/content-type-cache`,
        contentTypeCacheExpressRouter(h5pEditor.contentTypeCache)
    );

    const htmlExporter = new H5PHtmlExporter(
        h5pEditor.libraryStorage,
        h5pEditor.contentStorage,
        h5pEditor.config,
        path.join(__dirname, '../h5p/core'),
        path.join(__dirname, '../h5p/editor')
    );

    server.get('/h5p/html/:contentId', async (req, res) => {
        const html = await htmlExporter.createSingleBundle(
            req.params.contentId,
            (req as any).user,
            {
                language: req.language ?? 'en',
                showLicenseButton: true
            }
        );
        res.setHeader(
            'Content-disposition',
            `attachment; filename=${req.params.contentId}.html`
        );
        res.status(200).send(html);
    });

    // The startPageRenderer displays a list of content objects and shows
    // buttons to display, edit, delete and download existing content.
    server.get('/', startPageRenderer(h5pEditor));

    server.use('/client', express.static(path.join(__dirname, 'client')));

    // We only include the whole node_modules directory for convenience. Don't
    // do this in a production app.
    server.use(
        '/node_modules',
        express.static(path.join(__dirname, '../node_modules'))
    );

    // Remove temporary directory on shutdown
    if (useTempUploads && tmpDir) { // Only cleanup tmp-promise directory
        [
            'beforeExit',
            'uncaughtException',
            'unhandledRejection',
            'SIGQUIT',
            'SIGABRT',
            'SIGSEGV',
            'SIGTERM'
        ].forEach((evt) =>
            process.on(evt, async () => {
                await tmpDir?.cleanup();
                tmpDir = null;
            })
        );
    }

    const port = process.env.PORT || '8080';

    // For developer convenience we display a list of IPs, the server is running
    // on. You can then simply click on it in the terminal.
    displayIps(port);

    server.listen(port);
};

// We can't use await outside a an async function, so we use the start()
// function as a workaround.

start();
