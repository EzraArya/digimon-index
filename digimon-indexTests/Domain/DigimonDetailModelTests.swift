//
//  DigimonDetailModelTests.swift
//  digimon-indexTests
//
//  Created by Ezra Arya Wijaya on 12/04/26.
//

import XCTest
@testable import digimon_index

final class DigimonDetailModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_digimonDetail_decodeFromJSON() throws {
        let json = """
            {
               "id": 1473,
               "name": "Cernumon",
               "xAntibody": false,
               "images": [
                  {
                     "href": "https://digi-api.com/images/digimon/w/Cernumon.png",
                     "transparent": false
                  }
               ],
               "levels": [
                  {
                     "id": 6,
                     "level": "Ultimate"
                  }
               ],
               "types": [
                  {
                     "id": 48,
                     "type": "Holy Beast"
                  }
               ],
               "attributes": [
                  {
                     "id": 1,
                     "attribute": "Data"
                  }
               ],
               "fields": [
                  {
                     "id": 7,
                     "field": "Wind Guardians",
                     "image": "https://digi-api.com/images/etc/fields/Wind_Guardians.png"
                  }
               ],
               "releaseDate": "2024",
               "descriptions": [
                  {
                     "origin": "reference_book",
                     "language": "jap",
                     "description": "古くからデジタルワールドの森林地帯各地で目撃されている聖獣型デジモン。頭部の巨大な角や腹部から生えたパイプは管楽器のような構造になっており、様々な音楽を奏でる。　普段はその巨大なツノに止まった鳥デジモン達と共に音楽を奏でて過ごす穏やかな性格だが、一方で森に踏み込み害を成そうとする外敵に対しては、森を守るために大きな警告音を鳴らしながら苛烈な制裁を行う。　ケルヌモンが奏でる音楽は、どんな荒れ地でも植物を一気に生長させ、豊穣の地へと変貌させる力を持っている。また、森の仲間であるデジモンが命を落とした時は、その者が無事にデジタマへと転生できるよう、音楽で祈りを捧げる。　そうして幾多の死を弔いながら森の再生を続ける、神聖なデジモンだ。　必殺技は、身体のホルン・パイプから大音量の高音を出し相手を行動不能に陥らせる『ケルティックバインド』と、尻尾を振り、舞い散る木の葉で敵を切り刻む『スキャッターゴームグラス』。"
                  },
                  {
                     "origin": "reference_book",
                     "language": "en_us",
                     "description": "A Holy Beast Digimon that has been sighted in the various forest regions of the Digital World since ancient times. The huge horns on its head and the pipes growing from its abdomen have a structure similar to wind instruments, allowing it to play a variety of music.    It usually has a calm disposition, spending its time playing music along with the bird Digimon that perch on its huge horns, but on the other hand, Cernumon will severely punish invading enemies that try to enter and cause harm to the forest while letting out a loud warning sound in order to protect it.    The music played by Cernumon has the power to make plants grow instantly in any wasteland, transforming it into a fertile land. Also, whenever a fellow forest Digimon loses their life, it prays for their safe reincarnation into a Digitama through its music.    As such, it is a sacred Digimon that keeps regenerating the forest as it mourns countless deaths.    Its Special Moves are emitting a very loud, high-pitched sound from its horns and the pipes on its body which renders the opponent incapacitated (Celtic Bind), and mincing the opponent with the leaves that fall as it swings its tail (Scatter Gorm Glas)."
                  }
               ],
               "skills": [
                  {
                     "id": 3786,
                     "skill": "Celtic Bind",
                     "translation": "",
                     "description": "Emits a very loud, high-pitched sound from its horns and pipes that incapacitates the opponent."
                  },
                  {
                     "id": 3787,
                     "skill": "Scatter Gorm Glas",
                     "translation": "",
                     "description": "Minces the opponent with the leaves that fall as it swings its tail."
                  }
               ],
               "priorEvolutions": [
                  {
                     "id": 241,
                     "digimon": "Griffomon",
                     "condition": "with Hydramon or Pinochimon",
                     "image": "https://digi-api.com/images/digimon/w/Griffomon.png",
                     "url": "https://digi-api.com/api/v1/digimon/241"
                  },
                  {
                     "id": 1396,
                     "digimon": "Hydramon",
                     "condition": "with Pinochimon or Griffomon",
                     "image": "https://digi-api.com/images/digimon/w/Hydramon.png",
                     "url": "https://digi-api.com/api/v1/digimon/1396"
                  },
                  {
                     "id": 219,
                     "digimon": "Pinochimon",
                     "condition": "with Hydramon or Griffomon",
                     "image": "https://digi-api.com/images/digimon/w/Pinochimon.png",
                     "url": "https://digi-api.com/api/v1/digimon/219"
                  }
               ],
               "nextEvolutions": [
                {
                    "id": 241,
                    "digimon": "Griffomon",
                    "condition": "with Hydramon or Pinochimon",
                    "image": "https://digi-api.com/images/digimon/w/Griffomon.png",
                    "url": "https://digi-api.com/api/v1/digimon/241"
                },
                ]
            }
            """.data(using: .utf8)!
        
        let detail = try JSONDecoder().decode(DigimonDetail.self, from: json)
        
        XCTAssertEqual(detail.id, 1473)
        XCTAssertEqual(detail.name, "Cernumon")
        XCTAssertEqual(detail.xAntibody, false)
        XCTAssertEqual(detail.images.first?.href, "https://digi-api.com/images/digimon/w/Cernumon.png")
        XCTAssertEqual(detail.levels.first?.level, "Ultimate")
        XCTAssertEqual(detail.types.first?.type, "Holy Beast")
        XCTAssertEqual(detail.attributes.first?.attribute, "Data")
        XCTAssertEqual(detail.fields.first?.field, "Wind Guardians")
        XCTAssertEqual(detail.releaseDate, "2024")
        XCTAssertEqual(detail.descriptions.first?.language, "jap")
        XCTAssertEqual(detail.skills.first?.skill, "Celtic Bind")
        XCTAssertEqual(detail.priorEvolutions.first?.digimon, "Griffomon")
        XCTAssertEqual(detail.nextEvolutions.first?.digimon, "Griffomon")
    }
}
