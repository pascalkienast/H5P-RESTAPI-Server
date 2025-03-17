# H5P Branching Scenario: In-Depth Analysis of Working Structure

This document provides a comprehensive analysis of the working branching scenario JSON structure.

## 1. Top-Level Structure

The working branching scenario consists of these critical top-level elements:

```json
{
  "h5p": { ... },
  "library": "H5P.BranchingScenario 1.7",
  "params": { ... }
}
```

The top-level structure maintains:
- A separate `h5p` object for metadata
- An explicit library declaration
- A `params` object containing actual content

This dual-structure pattern is essential - the H5P framework expects both the top-level `h5p` object AND the nested metadata within `params.metadata`.

## 2. Dependencies Analysis

The working example includes these critical dependencies:

```json
"preloadedDependencies": [
  {"machineName": "H5P.AdvancedText", "majorVersion": 1, "minorVersion": 1},
  {"machineName": "H5P.BranchingQuestion", "majorVersion": 1, "minorVersion": 0},
  {"machineName": "FontAwesome", "majorVersion": 4, "minorVersion": 5},
  {"machineName": "H5P.CoursePresentation", "majorVersion": 1, "minorVersion": 24},
  {"machineName": "H5P.JoubelUI", "majorVersion": 1, "minorVersion": 3},
  {"machineName": "H5P.Transition", "majorVersion": 1, "minorVersion": 0},
  {"machineName": "H5P.FontIcons", "majorVersion": 1, "minorVersion": 0},
  {"machineName": "H5P.Link", "majorVersion": 1, "minorVersion": 3},
  {"machineName": "H5P.BranchingScenario", "majorVersion": 1, "minorVersion": 7}
]
```

Key observations:
- Dependencies appear in **both** the top-level `h5p` object AND the `params.metadata` section
- `H5P.CoursePresentation` (1.24) is included as it's used for certain content slides
- `H5P.Link` (1.3) is required for link elements
- UI-enhancing libraries (`H5P.JoubelUI`, `H5P.Transition`, `H5P.FontIcons`) are essential
- Exact version numbers are critical

## 3. Content Structure and Type Format

The content structure follows this specific pattern:

```json
"content": [
  {
    "type": {
      "library": "H5P.AdvancedText 1.1",
      "params": { ... },
      "subContentId": "22a7d04c-c94c-43dd-81c3-cf7b4b84efe5",
      "metadata": { ... }
    },
    "showContentTitle": false,
    "proceedButtonText": "WEITER",
    "forceContentFinished": "useBehavioural",
    "feedback": {"subtitle": ""},
    "contentBehaviour": "useBehavioural",
    "nextContentId": 1,
    "contentId": 0
  },
  // Additional content nodes...
]
```

Critical patterns:
- Each content node wraps its content in a `type` object
- The `type` object contains:
  - A `library` declaration with version
  - The content's `params`
  - A unique `subContentId` (UUID format)
  - A `metadata` object with content-specific details
- Content node IDs use numeric integers (not strings)
- Navigation references use these numeric IDs
- Button text and behaviors are specified at the content node level

## 4. Content Type Implementations

### 4.1 Text Content (H5P.AdvancedText)

```json
"type": {
  "library": "H5P.AdvancedText 1.1",
  "params": {
    "text": "<p>TEST</p>\n"
  },
  "subContentId": "22a7d04c-c94c-43dd-81c3-cf7b4b84efe5",
  "metadata": {
    "contentType": "Text",
    "license": "U",
    "title": "Untitled Text",
    "authors": [],
    "changes": [],
    "extraTitle": "Untitled Text"
  }
}
```

### 4.2 Branching Question (H5P.BranchingQuestion)

```json
"type": {
  "library": "H5P.BranchingQuestion 1.0",
  "params": {
    "branchingQuestion": {
      "alternatives": [
        {
          "nextContentId": 2,
          "feedback": {"title": "", "subtitle": ""},
          "text": "A"
        },
        {
          "nextContentId": 3,
          "feedback": {"title": "", "subtitle": ""},
          "text": "B"
        }
      ],
      "question": "<p>A oder B?</p>\n"
    },
    "proceedButtonText": "Proceed"
  },
  "subContentId": "e5e00618-26fc-4f4e-bdb3-dd39cdc1e144",
  "metadata": {
    "contentType": "Verzweigungsfrage",
    "license": "U",
    "title": "A oder B",
    "authors": [],
    "changes": [],
    "extraTitle": "A oder B"
  }
}
```

### 4.3 Course Presentation (H5P.CoursePresentation)

The working example includes complex Course Presentation slides with:
- Nested elements and actions
- Positioning information (x, y, width, height)
- Embedded content (texts, links)
- Comprehensive localization strings
- Detailed configuration override settings

## 5. Navigation and Flow Control

Navigation is controlled through:
- `nextContentId` properties (numeric values)
- Special value `-1` to indicate end of scenario
- Alternative paths in branching questions
- Each content node has a unique `contentId` (numeric)

## 6. Localization Structure

The working example includes extensive localization:

```json
"l10n": {
  "startScreenButtonText": "Start the course",
  "endScreenButtonText": "Restart the course",
  "backButtonText": "Back",
  "disableProceedButtonText": "Require to complete the current module",
  "replayButtonText": "Replay the video",
  "scoreText": "Your score:",
  "fullscreenAria": "Fullscreen"
}
```

Additional localization appears in content-specific areas.

## 7. End Screen Configuration

```json
"endScreens": [
  {
    "endScreenTitle": "<p>ENDE</p>\n",
    "endScreenSubtitle": "<p>ENDE</p>\n",
    "contentId": -1,
    "endScreenScore": 0
  }
]
```

## 8. Scoring Configuration

```json
"scoringOptionGroup": {
  "scoringOption": "no-score",
  "includeInteractionsScores": true
}
```

## 9. Start Screen Configuration

```json
"startScreen": {
  "startScreenTitle": "<p>A ODER B</p>\n",
  "startScreenSubtitle": "<p>A ODER B</p>\n"
}
```

## 10. Behavior Settings

```json
"behaviour": {
  "enableBackwardsNavigation": false,
  "forceContentFinished": false,
  "randomizeBranchingQuestions": false
}
```

## 11. Special Attributes

The working example includes:
- `preventXAPI: true` in the branching scenario params
- All content types retain their `subContentId` properties (UUIDs)
- Complex embedded objects maintain consistent structures

## 12. Critical Patterns for Working Implementation

1. **Dual metadata structure**: Both top-level and nested in params
2. **Type wrapper**: Content wrapped in a `type` object with library and metadata
3. **Content IDs**: Using numeric integers, not strings
4. **Full dependency tree**: Including all UI and interaction libraries
5. **Nested metadata**: Each content type maintains its own complete metadata
6. **SubContentIds**: Every content component has a unique UUID

## 13. Common Issues and Their Impacts

1. **Missing type wrapper**: Prevents proper content rendering
2. **String IDs vs. numeric IDs**: Can break navigation flow
3. **Missing dependencies**: Causes rendering failures for specific content types
4. **Missing subContentIds**: May prevent proper content association
5. **Incomplete localization**: Results in default or missing UI elements
6. **Improper behavior settings**: Can affect navigation functionality

## Conclusion

The working branching scenario follows a complex but consistent pattern with deeply nested structures. The most critical elements are:

1. Complete dual metadata structure (top-level and nested)
2. Type wrapper pattern for all content
3. Numeric content IDs with proper references
4. Complete dependency declarations in both locations
5. UUID subContentIds for all content elements

Any implementation must follow these patterns precisely to function correctly. 