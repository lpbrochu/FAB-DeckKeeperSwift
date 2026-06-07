import Foundation

struct HeroCatalog {
    static let deckFormats = ["CC", "Silver Age"]

    static let heroCatalog: [Hero] = [
    Hero(
        hero: "Arakni",
        className: "Assassin",
        talents: [],
        variants: [
            HeroVariant(format: "CC", fullName: "Arakni, Huntsman", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/DYN113.webp", notes: ""),
            HeroVariant(format: "CC", fullName: "Arakni, Marionette", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/HNT001.webp", notes: ""),
            HeroVariant(format: "Silver Age", fullName: "Arakni, Web of Deceit", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/WOD001-RF.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Azalea",
        className: "Ranger",
        talents: [],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Azalea", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/ARC039.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Aurora",
        className: "Runeblade",
        talents: ["Lightning"],
        variants: [
            HeroVariant(format: "CC", fullName: "Aurora, Legacy of Tempest", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/OMN047.webp", notes: ""),
            HeroVariant(format: "Silver Age", fullName: "Aurora, Emissary of Lightning", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/OMN048.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Betsy",
        className: "Guardian",
        talents: [],
        variants: [
            HeroVariant(format: "CC", fullName: "Betsy, Skin in the Game", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/HVY045.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Blaze",
        className: "Wizard",
        talents: [],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Blaze, Firemind", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/HER117-RF.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Boltyn",
        className: "Warrior",
        talents: ["Light"],
        variants: [
            HeroVariant(format: "CC", fullName: "Ser Boltyn, Breaker of Dawn", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/MON029.webp", notes: ""),
            HeroVariant(format: "Silver Age", fullName: "Boltyn", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/MON030.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Bravo",
        className: "Guardian",
        talents: [],
        variants: [
            HeroVariant(format: "CC", fullName: "Bravo, Showstopper", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/WTR038.webp", notes: ""),
            HeroVariant(format: "Silver Age", fullName: "Bravo, Flattering Showman", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/BDD001.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Briar",
        className: "Runeblade",
        talents: ["Elemental", "Earth", "Lightning"],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Briar", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/ELE063.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Chane",
        className: "Runeblade",
        talents: ["Shadow"],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Chane", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/MON002.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Cindra",
        className: "Ninja",
        talents: ["Draconic"],
        variants: [
            HeroVariant(format: "CC", fullName: "Cindra, Dracai of Retribution", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/HNT054.webp", notes: ""),
            HeroVariant(format: "Silver Age", fullName: "Cindra", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/HNT055.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Dash",
        className: "Mechanologist",
        talents: [],
        variants: [
            HeroVariant(format: "CC", fullName: "Dash I/O", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/EVO001.webp", notes: ""),
            HeroVariant(format: "Silver Age", fullName: "Dash, Database", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/EVO002.webp", notes: ""),
            HeroVariant(format: "Silver Age", fullName: "Dash", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/ARC002.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Dorinthea",
        className: "Warrior",
        talents: [],
        variants: [
            HeroVariant(format: "CC", fullName: "Dorinthea Ironsong", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/WTR113.webp", notes: ""),
            HeroVariant(format: "Silver Age", fullName: "Dorinthea", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/WTR114.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Emperor",
        className: "Wizard",
        talents: ["Draconic", "Royal"],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Emperor, Dracai of Aesir", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/DYN001-CF.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Fai",
        className: "Ninja",
        talents: ["Draconic"],
        variants: [
            HeroVariant(format: "CC", fullName: "Fai, Rising Rebellion", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/UPR044.webp", notes: ""),
            HeroVariant(format: "Silver Age", fullName: "Fai", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/UPR045.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Fang",
        className: "Ninja",
        talents: ["Draconic"],
        variants: [
            HeroVariant(format: "CC", fullName: "Fang, Dracai of Blades", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/HNT098.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Gravy Bones",
        className: "Pirate",
        talents: [],
        variants: [
            HeroVariant(format: "CC", fullName: "Gravy Bones, Shipwrecked Looter", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/FR_SEA043-MV.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Hala",
        className: "Warrior",
        talents: [],
        variants: [
            HeroVariant(format: "CC", fullName: "Hala, Bladesaint of the Vow", imageUrl: "https://d2wlb52bya4y8z.cloudfront.net/media/cards/small/AHA001-RF.webp", notes: "Armory Deck Origins: Hala preconstructed deck")
        ]
    ),
    Hero(
        hero: "Jarl Vetreidi",
        className: "Guardian",
        talents: ["Elemental", "Ice", "Earth"],
        variants: [
            HeroVariant(format: "CC", fullName: "Jarl Vetreiði", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/AJV001-RF.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Ira",
        className: "Ninja",
        talents: [],
        variants: [
            HeroVariant(format: "CC", fullName: "Ira, Scarlet Revenger", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/ASR002.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Kassai",
        className: "Warrior",
        talents: [],
        variants: [
            HeroVariant(format: "CC", fullName: "Kassai of the Golden Sand", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/HVY090.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Katsu",
        className: "Ninja",
        talents: [],
        variants: [
            HeroVariant(format: "CC", fullName: "Katsu, the Wanderer", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/WTR076.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Kayo",
        className: "Brute",
        talents: [],
        variants: [
            HeroVariant(format: "CC", fullName: "Kayo, Armed and Dangerous", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/HVY001.webp", notes: ""),
            HeroVariant(format: "Silver Age", fullName: "Kayo", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/HVY002.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Kayo",
        className: "Brute",
        talents: ["Reviled"],
        variants: [
            HeroVariant(format: "CC", fullName: "Kayo, Underhanded Cheat", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/SUP063.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Levia",
        className: "Brute",
        talents: ["Shadow"],
        variants: [
            HeroVariant(format: "CC", fullName: "Levia, Shadowborn Abomination", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/MON119.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Lexi",
        className: "Ranger",
        talents: ["Elemental", "Ice", "Lightning"],
        variants: [
            HeroVariant(format: "CC", fullName: "Lexi, Livewire", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/ELE031.webp", notes: ""),
            HeroVariant(format: "Silver Age", fullName: "Lexi", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/ELE032.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Lyath Goldmane",
        className: "Guardian",
        talents: ["Reviled"],
        variants: [
            HeroVariant(format: "CC", fullName: "Lyath Goldmane, Vile Savant", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/FR_SUP071.webp", notes: ""),
            HeroVariant(format: "Silver Age", fullName: "Lyath Goldmane", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/SLY001.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Marlynn",
        className: "Ranger",
        talents: ["Pirate"],
        variants: [
            HeroVariant(format: "CC", fullName: "Marlynn, Treasure Hunter", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/SEA082.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Maxx",
        className: "Mechanologist",
        talents: [],
        variants: [
            HeroVariant(format: "CC", fullName: "Maxx 'The Hype' Nitro", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/EVO004.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Nuu",
        className: "Assassin",
        talents: ["Mystic"],
        variants: [
            HeroVariant(format: "CC", fullName: "Nuu, Alluring Desire", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/DE_MST001.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Olympia",
        className: "Warrior",
        talents: [],
        variants: [
            HeroVariant(format: "CC", fullName: "Olympia, Prized Fighter", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/HVY092.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Oldhim",
        className: "Guardian",
        talents: ["Elemental", "Earth", "Ice"],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Oldhim", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/ELE002.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Oscilio",
        className: "Wizard",
        talents: ["Elemental", "Lightning"],
        variants: [
            HeroVariant(format: "CC", fullName: "Oscilio, Constella Intelligence", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/ROS019.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Oscilio",
        className: "Wizard",
        talents: ["Lightning"],
        variants: [
            HeroVariant(format: "CC", fullName: "Oscilio, Forked Continuum", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/OMN094.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Prism",
        className: "Illusionist",
        talents: ["Light"],
        variants: [
            HeroVariant(format: "CC", fullName: "Prism, Sculptor of Arc Light", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/MON001.webp", notes: ""),
            HeroVariant(format: "CC", fullName: "Prism, Awakener of Sol", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/HER086-CF.webp", notes: ""),
            HeroVariant(format: "Silver Age", fullName: "Prism", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/U-MON002.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Pleiades",
        className: "Guardian",
        talents: ["Revered"],
        variants: [
            HeroVariant(format: "CC", fullName: "Pleiades, Superstar", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/SUP009.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Puffin",
        className: "Mechanologist",
        talents: ["Pirate"],
        variants: [
            HeroVariant(format: "CC", fullName: "Puffin, Hightail", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/SEA001.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Rhinar",
        className: "Brute",
        talents: [],
        variants: [
            HeroVariant(format: "CC", fullName: "Rhinar, Reckless Rampage", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/WTR001.webp", notes: ""),
            HeroVariant(format: "Silver Age", fullName: "Rhinar", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/WTR002.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Riptide",
        className: "Ranger",
        talents: [],
        variants: [
            HeroVariant(format: "CC", fullName: "Riptide, Lurker of the Deep", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/HER078-CF.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Teklovossen",
        className: "Mechanologist",
        talents: [],
        variants: [
            HeroVariant(format: "CC", fullName: "Teklovossen, Esteemed Magnate", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/EVO007.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Uzuri",
        className: "Assassin",
        talents: [],
        variants: [
            HeroVariant(format: "CC", fullName: "Uzuri, Switchblade", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/HER077-CF.webp", notes: ""),
            HeroVariant(format: "Silver Age", fullName: "Uzuri", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/OUT002.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Valda",
        className: "Guardian",
        talents: [],
        variants: [
            HeroVariant(format: "CC", fullName: "Valda, Seismic Impact", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/MPG001.webp", notes: ""),
            HeroVariant(format: "Silver Age", fullName: "Valda Brightaxe", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/EVR019.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Verdance",
        className: "Wizard",
        talents: ["Elemental", "Earth"],
        variants: [
            HeroVariant(format: "CC", fullName: "Verdance, Thorn of the Rose", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/ROS013.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Victor Goldmane",
        className: "Guardian",
        talents: [],
        variants: [
            HeroVariant(format: "CC", fullName: "Victor Goldmane, High and Mighty", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/HVY047.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Viserai",
        className: "Runeblade",
        talents: [],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Viserai", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/ARC076.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Vynnset",
        className: "Runeblade",
        talents: ["Shadow"],
        variants: [
            HeroVariant(format: "CC", fullName: "Vynnset, Iron Maiden", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/HER087-CF.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Yoji",
        className: "Guardian",
        talents: [],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Yoji, Royal Protector", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/DYN025-RF.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Zyggy Starlight",
        className: "Illusionist",
        talents: ["Lightning"],
        variants: [
            HeroVariant(format: "CC", fullName: "Zyggy Starlight", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/OMN001.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Iyslander",
        className: "Wizard",
        talents: ["Elemental", "Ice"],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Iyslander", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/EVR120.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Enigma",
        className: "Illusionist",
        talents: ["Mystic"],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Enigma", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/ENG001-RF.webp", notes: "")
        ]
    )
    ]

    static let fabraryHeroAdditions: [Hero] = [
    Hero(
        hero: "Arakni",
        className: "Assassin",
        talents: ["Chaos"],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Arakni", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/ARK001.webp", notes: ""),
            HeroVariant(format: "CC", fullName: "Arakni, 5L!p3d 7hRu 7h3 cR4X", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/AAC001.webp", notes: ""),
            HeroVariant(format: "Silver Age", fullName: "Arakni, Solitary Confinement", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/HNT262-MV.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Aurora",
        className: "Runeblade",
        talents: ["Elemental"],
        variants: [
            HeroVariant(format: "CC", fullName: "Aurora, Shooting Star", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/ROS007.webp", notes: ""),
            HeroVariant(format: "Silver Age", fullName: "Aurora", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/ROS008.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Baalghor",
        className: "Unknown",
        talents: ["Shadow"],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Baalghor, Omen of the End", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/IAR159-MV.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Benji",
        className: "Ninja",
        talents: [],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Benji, the Piercing Wind", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/OUT047.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Betsy",
        className: "Guardian",
        talents: [],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Betsy", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/HVY046.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Bravo",
        className: "Guardian",
        talents: ["Elemental"],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Bravo", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/1HB001.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Data Doll MKII",
        className: "Mechanologist",
        talents: [],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Data Doll MKII", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/U-CRU099.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Dorinthea",
        className: "Warrior",
        talents: [],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Dorinthea, Quicksilver Prodigy", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/DDD001.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Dromai",
        className: "Illusionist",
        talents: ["Draconic"],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Dromai", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/UPR002.webp", notes: ""),
            HeroVariant(format: "CC", fullName: "Dromai, Ash Artist", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/UPR001.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Fang",
        className: "Warrior",
        talents: ["Royal", "Draconic"],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Fang", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/HNT099.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Florian",
        className: "Runeblade",
        talents: ["Elemental"],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Florian", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/ROS002.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Gravy Bones",
        className: "Pirate",
        talents: [],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Gravy Bones", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/SGB001.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Hala",
        className: "Warrior",
        talents: [],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Hala", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/MPW004-MV.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Ira",
        className: "Ninja",
        talents: [],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Ira, Crimson Haze", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/I-CRU046.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Kano",
        className: "Wizard",
        talents: [],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Kano", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/1HK001.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Kassai",
        className: "Warrior",
        talents: [],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Kassai", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/HVY091.webp", notes: ""),
            HeroVariant(format: "Silver Age", fullName: "Kassai, Cintari Sellsword", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/U-CRU077.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Katsu",
        className: "Ninja",
        talents: [],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Katsu", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/KAT001.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Kavdaen",
        className: "Merchant",
        talents: [],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Kavdaen, Trader of Skins", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/U-CRU118.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Kayo",
        className: "Brute",
        talents: ["Reviled"],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Kayo, Strong-arm", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/SUP064.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Levia",
        className: "Brute",
        talents: ["Shadow"],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Levia", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/DTD104.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Marlynn",
        className: "Pirate",
        talents: [],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Marlynn", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/SEA083.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Maxx Nitro",
        className: "Mechanologist",
        talents: [],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Maxx Nitro", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/EVO005.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Nuu",
        className: "Assassin",
        talents: ["Mystic"],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Nuu", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/MST002.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Olympia",
        className: "Warrior",
        talents: [],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Olympia", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/MPW006.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Oscilio",
        className: "Wizard",
        talents: ["Elemental", "Lightning"],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Oscilio", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/ROS020.webp", notes: ""),
            HeroVariant(format: "Silver Age", fullName: "Oscilio, Scion of the Third Age", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/OMN095.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Pleiades",
        className: "Guardian",
        talents: ["Revered"],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Pleiades", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/SUP010.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Puffin",
        className: "Pirate",
        talents: [],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Puffin", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/SEA002.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Riptide",
        className: "Ranger",
        talents: [],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Riptide", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/OUT092.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Scurv",
        className: "Pirate",
        talents: [],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Scurv, Stowaway", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/SEA123.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Teklovossen",
        className: "Mechanologist",
        talents: [],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Teklovossen", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/TCC001-RF.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Terra",
        className: "Guardian",
        talents: ["Elemental"],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Terra", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/TER001.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Tuffnut",
        className: "Brute",
        talents: ["Revered"],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Tuffnut", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/SUP002.webp", notes: ""),
            HeroVariant(format: "CC", fullName: "Tuffnut, Bumbling Hulkster", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/SUP001.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Verdance",
        className: "Wizard",
        talents: ["Elemental"],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Verdance", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/ROS014.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Victor Goldmane",
        className: "Guardian",
        talents: [],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Victor Goldmane", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/HVY048.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Viserai",
        className: "Runeblade",
        talents: [],
        variants: [
            HeroVariant(format: "CC", fullName: "Viserai, Rune Blood", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/AVS001.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Vynnset",
        className: "Runeblade",
        talents: ["Shadow"],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Vynnset", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/DTD134.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Zen",
        className: "Ninja",
        talents: ["Mystic"],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Zen", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/MST047.webp", notes: "")
        ]
    ),
    Hero(
        hero: "Zyggy",
        className: "Illusionist",
        talents: ["Lightning"],
        variants: [
            HeroVariant(format: "Silver Age", fullName: "Zyggy", imageUrl: "https://legendstory-production-s3-public.s3.amazonaws.com/media/cards/small/OMN002.webp", notes: "")
        ]
    )
    ]

    static let seededHeroCatalog: [Hero] = heroCatalog + fabraryHeroAdditions
}
