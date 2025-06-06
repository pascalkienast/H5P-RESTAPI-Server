# @lumieducation/h5p-mongo-s3

This package contains several storage classes that are meant to be used in a server using [@lumieducation/h5p-server](https://www.npmjs.com/package/@lumieducation/h5p-server):

- Mongo + S3 content storage
- S3 temporary file storage
- Mongo + S3 library storage
- pure Mongo library storage

**Check out the [GitBook documentation](https://docs.lumi.education/npm-packages/h5p-mongos3) for details
on how to use this package**.

## Additional related packages

@lumieducation/h5p-mongo-s3 is one of several packages by lumieducation that
work in conjunction to simplify creating H5P applications. They are all managed
in the [h5p-nodejs-library monorepo on
GitHub](https://github.com/lumieducation/h5p-nodejs-library) and are available
on NPM.

| Package name                      | Functionality                                                             | used in  |
|-----------------------------------|---------------------------------------------------------------------------|----------|
| [**@lumieducation/h5p-server**](https://www.npmjs.com/package/@lumieducation/h5p-server)         | the core package to run H5P in NodeJS                                     | backend  |
| [**@lumieducation/h5p-express**](https://www.npmjs.com/package/@lumieducation/h5p-express)        | routes and controllers for Express                                        | backend  |
| [**@lumieducation/h5p-webcomponents**](https://www.npmjs.com/package/@lumieducation/h5p-webcomponents)  | native web components to display the H5P player and editor in the browser | frontend |
| [**@lumieducation/h5p-react**](https://www.npmjs.com/package/@lumieducation/h5p-react)          | React components with the same functionality as the native web components | frontend |
| [**@lumieducation/h5p-mongos3**](https://www.npmjs.com/package/@lumieducation/h5p-mongos3)        | storage classes for MongoDB and S3                                        | backend  |
| [**@lumieducation/h5p-html-exporter**](https://www.npmjs.com/package/@lumieducation/h5p-html-exporter)  | an optional component that can create bundled HTML files for exporting    | backend  |

## Examples

There are two example implementations that illustrate how the packages can be
used:

| Example type | Tech stack | Location |
| :--- | :--- | :--- |
| server-side-rendering | server: Express with JS template rendering client: static HTML, some React for library management | [`/packages/h5p-main`](https://github.com/Lumieducation/H5P-Nodejs-library/tree/master/packages/h5p-main) |
| [Single Page Application](https://docs.lumi.education/development/rest) | server: Express with REST endpoints client: React | [`/packages/h5p-rest-example-server`](https://github.com/Lumieducation/H5P-Nodejs-library/tree/master/packages/h5p-rest-example-server) [`/packages/h5p-rest-example-client`](https://github.com/Lumieducation/H5P-Nodejs-library/tree/master/packages/h5p-rest-example-server) |

## Versioning

We use [SemVer](http://semver.org/) for versioning. The versions of all packages
of the monorepo are all increased at the same time, so you should always update
all packages at once. For the versions available, see the [tags on this
repository](https://github.com/Lumieducation/h5p-nodejs-library/tags).

## License

This project is licensed under the GNU GENERAL PUBLIC LICENSE v3 License - see
the [LICENSE](/LICENSE) file for details

## Support

This work obtained financial support for development from the German
BMBF-sponsored research project "CARO - Care Reflection Online" (FKN:
01PD15012).

Read more about them at the following websites:

* CARO - [https://blogs.uni-bremen.de/caroprojekt/](https://blogs.uni-bremen.de/caroprojekt/)
* University of Bremen - [https://www.uni-bremen.de/en.html](https://www.uni-bremen.de/en.html)
* BMBF - [https://www.bmbf.de/en/index.html](https://www.bmbf.de/en/index.html)
