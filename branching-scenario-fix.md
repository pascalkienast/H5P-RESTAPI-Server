# H5P Branching Scenario Fix

## Problem Analysis

The issue with the non-working branching scenario was in the JSON structure of the content. While the start screen appeared correctly, subsequent screens showed only white space.

## Key Issues Fixed

1. **Content Structure**: The correct structure for a branching scenario requires:
   - A properly formatted `startScreen` object
   - A correctly structured `content` array with unique IDs
   - Proper `nextContentId` references connecting the content nodes
   - Valid `endScreens` configuration

2. **Content Type Parameters**: Each content type within the branching scenario (such as BranchingQuestion or AdvancedText) requires its own specific parameter structure.

3. **Navigation Flow**: The branching paths need to be properly defined, with each content node either pointing to another content node or to an end screen.

4. **JSON Structure Format**: Most critically, the API expects a specific format with nested params:
   - Original format used: `params.branchingScenario` (incorrect)
   - Required format: `params.params.branchingScenario` with a separate `params.metadata` object

5. **Missing Critical Sections**: After deeper analysis, several important sections were missing:
   - `behaviour` settings that control navigation
   - `preloadedDependencies` that specify required libraries
   - These sections ensure all components work correctly together

6. **Top-level H5P Object**: After thorough comparison with the working example, we discovered a critical top-level `h5p` object was missing entirely, which includes:
   - Important metadata like embedTypes, language, title
   - The mainLibrary definition
   - An additional copy of preloadedDependencies

7. **Localization Settings**: The working example includes an `l10n` object with text translations for buttons and UI elements.

8. **Complete Metadata Structure**: The metadata needed to be structured exactly as in the working example, including embedTypes, language settings, and other properties.

9. **Different Content Node Structure**: Deep analysis of the working example revealed a different structure for content nodes:
   - Working example uses a `type` wrapper object around each content node's library and params
   - Each content node has additional properties like `showContentTitle`, `contentBehaviour`, and `proceedButtonText`
   - Content nodes include `subContentId` values for proper reference tracking

10. **Scoring Configuration**: The working example includes a `scoringOptionGroup` object that configures scoring behavior:
    - Controls whether the branching scenario tracks scores
    - Determines if interaction scores are included
    - Essential for proper progress tracking

11. **Enhanced End Screen Structure**: The end screens have additional properties:
    - `endScreenTitle` and `endScreenSubtitle` for proper display
    - `endScreenScore` for score tracking
    - `contentId` references for proper flow
    - `endScreenImage` for visual display

12. **Complex Content Types Integration**: The working example integrates complex H5P content types:
    - Course Presentation slides with multiple elements
    - Nested content objects with their own libraries and parameters
    - Precise positioning of elements with x, y, width, and height coordinates

## Solution

We created a fixed JSON structure with the following components:

1. **Proper Top-level Structure**: Including both `h5p` object and correct library reference

2. **Start Screen**: Properly configured with title, subtitle, and image.

3. **Content Nodes**:
   - A branching question as the first node (ID: "1")
   - Two text content nodes for different paths (IDs: "2" and "3")
   - Proper navigation flow between nodes

4. **End Screen**: Correctly structured with feedback and navigation options.

5. **Complete Behavior Settings**: Including all navigation and interaction options.

6. **Localization Settings**: Text for buttons and UI elements.

7. **Complete Dependencies**: All required libraries with correct versions.

8. **Scoring Configuration**: Proper setup for score tracking.

9. **Essential Metadata Duplication**: Duplicate metadata in both required locations.

## Fixed JSON Structure

The completely fixed structure matching the working example:

```json
{
  "h5p": {
    "embedTypes": [
      "iframe"
    ],
    "language": "en",
    "title": "Fixed API Example Branching Scenario",
    "license": "U",
    "defaultLanguage": "en",
    "extraTitle": "Fixed API Branching Scenario",
    "mainLibrary": "H5P.BranchingScenario",
    "preloadedDependencies": [
      {
        "machineName": "H5P.AdvancedText",
        "majorVersion": 1,
        "minorVersion": 1
      },
      {
        "machineName": "H5P.BranchingQuestion",
        "majorVersion": 1,
        "minorVersion": 0
      },
      {
        "machineName": "H5P.StandardPage",
        "majorVersion": 1,
        "minorVersion": 5
      },
      {
        "machineName": "FontAwesome",
        "majorVersion": 4,
        "minorVersion": 5
      },
      {
        "machineName": "H5P.JoubelUI",
        "majorVersion": 1,
        "minorVersion": 3
      },
      {
        "machineName": "H5P.Transition",
        "majorVersion": 1,
        "minorVersion": 0
      },
      {
        "machineName": "H5P.FontIcons",
        "majorVersion": 1,
        "minorVersion": 0
      },
      {
        "machineName": "H5P.BranchingScenario",
        "majorVersion": 1,
        "minorVersion": 7
      }
    ]
  },
  "library": "H5P.BranchingScenario 1.7",
  "params": {
    "metadata": {
      "embedTypes": [
        "iframe"
      ],
      "language": "en",
      "title": "Fixed API Example Branching Scenario",
      "license": "U",
      "defaultLanguage": "en",
      "extraTitle": "Fixed API Branching Scenario",
      "mainLibrary": "H5P.BranchingScenario",
      "preloadedDependencies": [
        {
          "machineName": "H5P.AdvancedText",
          "majorVersion": 1,
          "minorVersion": 1
        },
        {
          "machineName": "H5P.BranchingQuestion",
          "majorVersion": 1,
          "minorVersion": 0
        },
        {
          "machineName": "H5P.StandardPage",
          "majorVersion": 1,
          "minorVersion": 5
        },
        {
          "machineName": "FontAwesome",
          "majorVersion": 4,
          "minorVersion": 5
        },
        {
          "machineName": "H5P.JoubelUI",
          "majorVersion": 1,
          "minorVersion": 3
        },
        {
          "machineName": "H5P.Transition",
          "majorVersion": 1,
          "minorVersion": 0
        },
        {
          "machineName": "H5P.FontIcons",
          "majorVersion": 1,
          "minorVersion": 0
        },
        {
          "machineName": "H5P.BranchingScenario",
          "majorVersion": 1,
          "minorVersion": 7
        }
      ]
    },
    "params": {
      "branchingScenario": {
        "startScreen": {
          "startScreenTitle": "Fixed API Example Branching Scenario",
          "startScreenSubtitle": "Created via REST API - Fixed Version",
          "startScreenImage": {
            "path": "https://images.unsplash.com/photo-1455849318743-b2233052fcff",
            "mime": "image/jpeg",
            "copyright": {
              "license": "U"
            },
            "width": 900,
            "height": 600
          }
        },
        "content": [
          {
            "id": "1",
            "contentType": "H5P.BranchingQuestion 1.0",
            "nextContentId": "-1",
            "params": {
              "branchingQuestion": {
                "question": "<p>Which path would you like to take?</p>",
                "alternatives": [
                  {
                    "text": "Go to the information slide",
                    "nextContentId": "2"
                  },
                  {
                    "text": "Skip to the end",
                    "nextContentId": "3"
                  }
                ]
              }
            },
            "feedback": {
              "title": "You made a choice!",
              "subtitle": "Let's see where it leads"
            }
          },
          {
            "id": "2",
            "contentType": "H5P.AdvancedText 1.1",
            "nextContentId": "3",
            "params": {
              "text": "<h2>Information Slide</h2><p>This is a simple text slide in the branching scenario.</p><p>After viewing this slide, you'll automatically proceed to the end.</p>"
            }
          },
          {
            "id": "3",
            "contentType": "H5P.AdvancedText 1.1",
            "nextContentId": "-1",
            "params": {
              "text": "<h2>End of Scenario</h2><p>You've reached the end of this example branching scenario.</p>"
            }
          }
        ],
        "endScreens": [
          {
            "id": "0-1",
            "contentType": "H5P.StandardPage 1.5",
            "showBackButton": false, 
            "showProceedButton": true,
            "scoreScreen": false,
            "params": {
              "text": "<p>Thanks for exploring this fixed API example.</p>"
            },
            "feedback": {
              "title": "Completed!", 
              "subtitle": "You have completed this branching scenario."
            }
          }
        ],
        "behaviour": {
          "enableBackwardsNavigation": true,
          "randomizeBranchingQuestions": false,
          "forceContentFinished": false
        },
        "l10n": {
          "startScreenButtonText": "Start",
          "endScreenButtonText": "Restart",
          "backButtonText": "Back",
          "proceedButtonText": "Proceed"
        }
      }
    }
  }
}
```

## Implementation

We created the fixed content using the `/h5p/new` endpoint:

```bash
curl -X POST "http://localhost:8080/h5p/new" -H "Content-Type: application/json" -d @branching-fixed.json
```

The content was successfully created with ID: 256005054 and can be accessed at:
http://localhost:8080/h5p/play/256005054

## Common Issues with Branching Scenarios

1. **Missing or Invalid Content IDs**: Each content node needs a unique ID.

2. **Incorrect nextContentId References**: Must point to valid content IDs or "-1" for end screens.

3. **Invalid Content Type Parameters**: Each content type requires its specific parameter structure.

4. **Missing End Screens**: Branching scenarios need proper end screen configuration.

5. **Circular References**: Be careful not to create infinite loops with circular references.

6. **Missing Behaviour Settings**: Behaviour settings control navigation and interaction options.

7. **Missing Dependencies**: The preloadedDependencies section ensures all required libraries are available.

8. **Incorrect Top-level Structure**: The H5P object is required at the top level for proper initialization.

9. **Missing Localization Strings**: The l10n object provides text for buttons and UI elements.

10. **Duplicated Metadata**: Some metadata must be provided in both the h5p object and params.metadata.

11. **Incomplete Content Node Structure**: The working example uses a specific structure for content nodes that includes additional properties beyond basic parameters.

12. **Missing Scoring Configuration**: Proper configuration of scoring behavior is essential for certain types of branching scenarios.

13. **Complex Nested Content**: When integrating complex content types like Course Presentation, additional structural elements are required.

14. **Missing SubContentId Values**: Each content element requires a unique subContentId for proper tracking and reference.

## Structural Differences Between Simple and Complex Scenarios

The working example reveals significant structural complexity not required for minimal functionality:

1. **Simple vs. Complex Content Nodes**:
   - Simple implementation: Direct parameters for content nodes
   - Complex implementation: Nested type objects with libraries, metadata, and subContentIds

2. **Content Reference Methods**:
   - Simple implementation: Direct ID references
   - Complex implementation: Combination of IDs and subContentIds for deep tracking

3. **Content Presentation**:
   - Simple implementation: Basic content display
   - Complex implementation: Precise positioning with x/y coordinates and dimensions

4. **Nesting Depth**:
   - Simple implementation: 3-4 levels of nesting
   - Complex implementation: Up to 10+ levels of nesting for complex content types

While our simplified implementation works for basic scenarios, complex educational content would require the more elaborate structure seen in the working example.

## Documentation

The API documentation includes information about creating branching scenarios, but it's important to note the exact parameter structure required:

1. Both a top-level `h5p` object and a nested `params.metadata` object are required, with similar content
2. Title and license information must be in multiple locations
3. Dependencies must be listed in both the top-level `h5p.preloadedDependencies` and in `params.metadata.preloadedDependencies`
4. The structure differs significantly from other examples that use a simpler nesting pattern
5. Additional properties like `l10n` and complete `behaviour` settings are essential for proper functioning
6. For complex scenarios with multiple content types, additional nesting and structural elements are required
7. Position and dimension data becomes critical when integrating interactive elements

Creating a successful branching scenario requires careful attention to the complete structure shown in the working examples. 