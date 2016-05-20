defmodule MediaSample.Search.Definition do
  @indices %{
    "ja" => [
      settings: [
        index: [
          analysis: [
            filter: [
              pos_filter: [type: "kuromoji_part_of_speech", stoptags: ["助詞-格助詞-一般", "助詞-終助詞"]], 
              greek_lowercase_filter: [type: "lowercase", language: "greek"]
            ],
            analyzer: [
              kuromoji_analyzer: [
                type: "custom", tokenizer: "kuromoji_tokenizer", filter: ["kuromoji_baseform", "pos_filter", "greek_lowercase_filter", "cjk_width"]
              ]
            ] 
          ]
        ]
      ], 
      mappings: [
        entry: [
          _source: [enabled: true],
          _all: [enabled: true, analyzer: "kuromoji_analyzer"],
          properties: [
            id: [type: "integer", index: "not_analyzed"],
            title: [type: "string", index: "analyzed", analyzer: "kuromoji_analyzer"],
            content: [type: "string", index: "analyzed", analyzer: "kuromoji_analyzer"]
          ]
        ]
      ]
    ],
    "en" => [
      settings: [
        index: [
          analysis: [
            filter: [
              english_stop: [type: "stop", stopwords: "_english_"],
              english_stemmer: [type: "stemmer", language: "english"],
              english_possessive_stemmer: [type: "stemmer", language: "possessive_english"]
            ],
            analyzer: [
              english: [
                tokenizer: "standard", filter: ["english_possessive_stemmer", "lowercase", "english_stop", "english_stemmer"]
              ]
            ]
          ]
        ]
      ],
      mappings: [
        entry: [
          _source: [enabled: true],
          _all: [enabled: true, analyzer: "english"],
          properties: [
            id: [type: "integer", index: "not_analyzed"],
            title: [type: "string", index: "analyzed", analyzer: "english"],              
            content: [type: "string", index: "analyzed", analyzer: "english"]
          ]
        ]
      ]
    ]
  }

  def indices(locale) do
    @indices[locale]
  end
end
