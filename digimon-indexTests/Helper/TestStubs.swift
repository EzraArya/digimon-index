//
//  TestStubs.swift
//  digimon-index
//
//  Created by Ezra Arya Wijaya on 12/04/26.
//

import Foundation
@testable import digimon_index

extension DigimonDetail {
    static func stub(
        id: Int = 1,
        name: String = "Agumon"
    ) -> DigimonDetail {
        DigimonDetail(
            id: id,
            name: name,
            xAntibody: false,
            images: [DigimonImage(href: "https://test.png", transparent: false)],
            levels: [DigimonLevel(id: 4, level: "Child")],
            types: [DigimonType(id: 1, type: "Reptile")],
            attributes: [DigimonAttribute(id: 4, attribute: "Vaccine")],
            fields: [DigimonField(id: 8, field: "Deep Savers", image: "https://test.png")],
            releaseDate: "1997",
            descriptions: [DigimonDescription(origin: "reference_book", language: "en_us", description: "A Reptile Digimon.")],
            skills: [DigimonSkill(id: 1, skill: "Baby Flame", translation: "", description: "Spits fire.")],
            priorEvolutions: [DigimonEvolution(id: 36, digimon: "Koromon", condition: "", image: "https://test.png", url: "https://test")],
            nextEvolutions: [DigimonEvolution(id: 34, digimon: "Greymon", condition: "", image: "https://test.png", url: "https://test")]
        )
    }
}
