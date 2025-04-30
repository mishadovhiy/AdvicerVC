<div style="displey:flex">
  <img width="20%" src="https://mishadovhiy.com/imgs/monopoly/1.png">
<img width="20%" src="https://mishadovhiy.com/imgs/cvadvicer/2.png">
  <img width="20%" src="https://mishadovhiy.com/imgs/cvadvicer/3.png">
</div>

Advice generation with OpenAI request description.
OpenAI responds in XML format with following keys: cvCompletnessGrade, skillsGrade, skillImprovmentSuggestion, skillContentCompletnessGrade, skillGroupingMistakes, skillGropingSuggestions, advancedSkillImproveSuggestions, atsGrade, employmentDurationGrade, employmentDescriptionSuggestions, contentDescriptionsMistakes, advancedContentImprovingSuggestions, cvImprovment, generalAdvice (keys declared in client as enum and to OpenAI prompt I send description for each key). In openAI prompt I send retrived from CV: summary, working history, skills (keys declared as dictionary of Codable Enum and string value: retrived from CV text, example, for key summary i retrive summary section from the cv)

OpenAI prompt:
Keys declaration for the request: https://github.com/mishadovhiy/AdvicerVC/blob/main/AdvicerCV/Models/DataModel/NetworkDataModel/NetworkRequest.swift#L199
full prompt generation: https://github.com/mishadovhiy/AdvicerVC/blob/main/AdvicerCV/Models/DataModel/NetworkDataModel/NetworkRequest.swift#L81
