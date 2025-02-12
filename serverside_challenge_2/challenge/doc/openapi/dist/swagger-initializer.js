window.onload = function() {
  //<editor-fold desc="Changeable Configuration Block">
  const apiSpec = {
    "openapi": "3.0.0",
    "info": {
      "title": "Electricity Charges Simulate API",
      "version": "1.0.0"
    },
    "paths": {
      "/api/v1/electricity_charges/simulate": {
        "get": {
          "summary": "電気料金のシミュレーションを行います",
          "parameters": [
            {
              "name": "ampere",
              "in": "query",
              "required": true,
              "schema": {
                "type": "integer",
                "enum": [
                  10,
                  15,
                  20,
                  30,
                  40,
                  50,
                  60
                ]
              },
              "description": "契約アンペア数"
            },
            {
              "name": "usage",
              "in": "query",
              "required": true,
              "schema": {
                "type": "integer",
                "minimum": 0
              },
              "description": "1ヶ月の使用量(kWh)"
            }
          ],
          "responses": {
            "200": {
              "description": "正常に料金シミュレーションが完了した場合のレスポンス",
              "content": {
                "application/json": {
                  "schema": {
                    "type": "object",
                    "properties": {
                      "results": {
                        "type": "array",
                        "items": {
                          "type": "object",
                          "properties": {
                            "status": {
                              "type": "string",
                              "enum": [
                                "success",
                                "error"
                              ]
                            },
                            "provider_name": {
                              "type": "string"
                            },
                            "plan_name": {
                              "type": "string"
                            },
                            "price": {
                              "type": "string",
                              "nullable": true
                            },
                            "message": {
                              "type": "string",
                              "nullable": true
                            }
                          }
                        }
                      }
                    }
                  },
                  "example": {
                    "results": [
                      {
                        "status": "success",
                        "provider_name": "プロバイダーA",
                        "plan_name": "プランA",
                        "price": "1000"
                      },
                      {
                        "status": "error",
                        "provider_name": "プロバイダーB",
                        "plan_name": "プランB",
                        "message": "データが見つかりません"
                      }
                    ]
                  }
                }
              }
            },
            "400": {
              "description": "パラメータが不足または無効な場合のエラー",
              "content": {
                "application/json": {
                  "schema": {
                    "type": "object",
                    "properties": {
                      "error": {
                        "type": "string"
                      }
                    }
                  },
                  "example": {
                    "error": "Bad Request"
                  }
                }
              }
            },
            "500": {
              "description": "サーバー内部エラー",
              "content": {
                "application/json": {
                  "schema": {
                    "type": "object",
                    "properties": {
                      "error": {
                        "type": "string"
                      }
                    }
                  },
                  "example": {
                    "error": "Internal Server Error"
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  // the following lines will be replaced by docker/configurator, when it runs in a docker-container
  window.ui = SwaggerUIBundle({
    //url: "https://petstore.swagger.io/v2/swagger.json",
    spec: apiSpec,
    dom_id: '#swagger-ui',
    deepLinking: true,
    presets: [
      SwaggerUIBundle.presets.apis,
      SwaggerUIStandalonePreset
    ],
    plugins: [
      SwaggerUIBundle.plugins.DownloadUrl
    ],
    layout: "StandaloneLayout"
  });

  //</editor-fold>
};
