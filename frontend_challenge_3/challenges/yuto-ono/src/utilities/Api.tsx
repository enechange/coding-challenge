/**
 * 郵便番号の最初の1桁とエリアのマッピング
 */
type zipAreaMappingType = {
  [key: string]: string
}

const zipAreaMapping: zipAreaMappingType = {
  "1": "東京電力エリア",
  "5": "関西電力エリア",
}

/**
 * API通信するクラス
 */
class Api {
  /**
   * 郵便番号を元にエリア名を返す
   * @param {string} zip - 郵便番号
   * @returns {Promise} - エリア名を返す
   */
  getAreaByZipCode (zip: string): Promise<string> {
    return new Promise((resolve, reject) => {
      // 後でこの中身をAPI通信に書き換える
      const firstLetter = zip.charAt(0)
      if (firstLetter in zipAreaMapping) {
        resolve(zipAreaMapping[firstLetter])
      }
      else {
        reject("サービスエリア対象外です。")
      }
    })
  }
}

export default Api
