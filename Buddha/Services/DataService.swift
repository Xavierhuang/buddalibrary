//
//  DataService.swift
//  Buddha
//
//  Created by Weijia Huang on 12/14/25.
//

import Foundation
import SwiftData

class DataService {
    static func loadSampleData(context: ModelContext) {
        // Check if data already exists
        let descriptor = FetchDescriptor<BuddhistText>()
        let existingTexts = (try? context.fetch(descriptor)) ?? []
        
        // Check which texts already exist
        let existingTitles = Set(existingTexts.map { $0.title })
        
        // Check if Samadhi Water Repentance exists but has incomplete data
        // Expected: 6 chapters with 466 total verses
        let waterRepentanceText = existingTexts.first { $0.title == "Samadhi Water Repentance" || $0.title == "Samadhi Water Repentance (慈悲三昧水懺科儀)" }
        var shouldReloadWaterRepentance = false
        if let text = waterRepentanceText {
            let totalVerses = text.chapters.reduce(0) { $0 + $1.verses.count }
            shouldReloadWaterRepentance = totalVerses < 400 // If less than 400 verses, reload it
        }
        
        // If we need to reload, delete the existing text first
        if shouldReloadWaterRepentance, let text = waterRepentanceText {
            context.delete(text)
            try? context.save()
        }
        
        // Delete old "Samadhi Water Repentance" if it exists without Chinese title, so it can be reloaded with Chinese title
        if let oldWaterRepentance = existingTexts.first(where: { $0.title == "Samadhi Water Repentance" }) {
            context.delete(oldWaterRepentance)
            try? context.save()
        }
        
        // Delete "The Noble Eightfold Path" if it exists (no longer needed)
        if let eightfoldPathText = existingTexts.first(where: { $0.title == "The Noble Eightfold Path" }) {
            context.delete(eightfoldPathText)
            try? context.save()
        }
        
        // Delete "The Four Noble Truths" if it exists (no longer needed)
        if let fourNobleTruthsText = existingTexts.first(where: { $0.title == "The Four Noble Truths" }) {
            context.delete(fourNobleTruthsText)
            try? context.save()
        }
        
        // Delete old "Heart Sutra" if it exists without Chinese title, so it can be reloaded with Chinese title
        if let oldHeartSutra = existingTexts.first(where: { $0.title == "Heart Sutra" }) {
            context.delete(oldHeartSutra)
            try? context.save()
        }
        
        // Only load texts that don't exist yet
        let shouldLoadHeartSutra = !existingTitles.contains("Heart Sutra (心經)")
        let shouldLoadDiamondSutra = !existingTitles.contains("Diamond Sutra") && !existingTitles.contains("Diamond Sutra (金剛般若波羅蜜經)")
        let shouldLoadWaterRepentance = (!existingTitles.contains("Samadhi Water Repentance (慈悲三昧水懺科儀)") && !existingTitles.contains("Samadhi Water Repentance")) || shouldReloadWaterRepentance
        // Delete old "Great Compassion Repentance" if it exists without Chinese title, so it can be reloaded with Chinese title
        if let oldGreatCompassionRepentance = existingTexts.first(where: { $0.title == "Great Compassion Repentance" }) {
            context.delete(oldGreatCompassionRepentance)
            try? context.save()
        }
        
        let shouldLoadGreatCompassionRepentance = !existingTitles.contains("Great Compassion Repentance (大悲咒)")
        let shouldLoadMedicineBuddhaSutra = !existingTitles.contains("Medicine Buddha Sutra") && !existingTitles.contains("Medicine Buddha Sutra (藥師琉璃光如來本願功德經)")
        // Check for old Universal Gate title and delete if exists
        if let oldUniversalGate = existingTexts.first(where: { $0.title == "The Lotus Sutra's Universal Gate Chapter" }) {
            context.delete(oldUniversalGate)
            try? context.save()
        }
        
        let shouldLoadLotusSutraUniversalGate = !existingTitles.contains("The Universal Gateway of Guanyin Bodhisattva (普門品)") && !existingTitles.contains("The Lotus Sutra's Universal Gate Chapter")
        let shouldLoadWhatBuddhaTaught = !existingTitles.contains("What the Buddha Taught")
        let shouldLoadLifeOfBuddha = !existingTitles.contains("The Life of the Buddha")
        let shouldLoadSiddhartha = !existingTitles.contains("流浪者之歌 (Siddhartha)")

        // If all texts exist, return early
        if !shouldLoadHeartSutra && !shouldLoadDiamondSutra && !shouldLoadWaterRepentance && !shouldLoadGreatCompassionRepentance && !shouldLoadMedicineBuddhaSutra && !shouldLoadLotusSutraUniversalGate && !shouldLoadWhatBuddhaTaught && !shouldLoadLifeOfBuddha && !shouldLoadSiddhartha {
            return
        }
        
        // Heart Sutra
        if shouldLoadHeartSutra {
        let heartSutra = BuddhistText(
            title: "Heart Sutra (心經)",
            author: "Buddha",
            textDescription: "The Heart of Perfect Wisdom Sutra",
            category: "Sutra",
            coverImageName: "HeartSutra"
        )
        
        let heartChapter1 = Chapter(number: 1, title: "The Heart of Perfect Wisdom")
        heartChapter1.text = heartSutra
        heartChapter1.verses = [
            Verse(
                number: 1,
                text: "Avalokiteshvara, the Bodhisattva of Compassion, meditating deeply on Perfection of Wisdom, saw clearly that the five aspects of human existence are empty, and so released himself from suffering.",
                pinyin: "guān zì zài pú sà xíng shēn bō rě bō luó mì duō shí zhào jiàn wǔ yùn jiē kōng dù yī qiè kǔ è",
                chinese: "觀自在菩薩，行深般若波羅蜜多時，照見五蘊皆空，度一切苦厄。"
            ),
            Verse(
                number: 2,
                text: "Answering the monk Sariputra, he said this:",
                pinyin: "shě lì zǐ sè bù yì kōng kōng bù yì sè",
                chinese: "舍利子，色不異空，空不異色，"
            ),
            Verse(
                number: 3,
                text: "Body is nothing more than emptiness, emptiness is nothing more than body. The body is exactly empty, and emptiness is exactly body.",
                pinyin: "sè jí shì kōng kōng jí shì sè shòu xiǎng xíng shí yì fù rú shì",
                chinese: "色即是空，空即是色。受想行識，亦復如是。"
            ),
            Verse(
                number: 4,
                text: "The other four aspects of human existence — feeling, thought, will, and consciousness — are likewise nothing more than emptiness, and emptiness nothing more than they.",
                pinyin: "shě lì zǐ shì zhū fǎ kōng xiàng bù shēng bù miè bù gòu bù jìng bù zēng bù jiǎn",
                chinese: "舍利子，是諸法空相，不生不滅，不垢不淨，不增不減。"
            ),
            Verse(
                number: 5,
                text: "All things are empty: Nothing is born, nothing dies, nothing is pure, nothing is stained, nothing increases and nothing decreases.",
                pinyin: "shì gù kōng zhōng wú sè wú shòu xiǎng xíng shí",
                chinese: "是故空中無色，無受想行識，"
            ),
            Verse(
                number: 6,
                text: "So, in emptiness, there is no body, no feeling, no thought, no will, no consciousness.",
                pinyin: "wú yǎn ěr bí shé shēn yì wú sè shēng xiāng wèi chù fǎ",
                chinese: "無眼耳鼻舌身意，無色聲香味觸法，"
            ),
            Verse(
                number: 7,
                text: "There are no eyes, no ears, no nose, no tongue, no body, no mind. There is no seeing, no hearing, no smelling, no tasting, no touching, no imagining.",
                pinyin: "wú yǎn jiè nǎi zhì wú yì shí jiè wú wú míng yì wú wú míng jìn",
                chinese: "無眼界，乃至無意識界，無無明，亦無無明盡，"
            ),
            Verse(
                number: 8,
                text: "There is nothing seen, nor heard, nor smelled, nor tasted, nor touched, nor imagined.",
                pinyin: "nǎi zhì wú lǎo sǐ yì wú lǎo sǐ jìn",
                chinese: "乃至無老死，亦無老死盡。"
            ),
            Verse(
                number: 9,
                text: "There is no ignorance, and no end to ignorance. There is no old age and death, and no end to old age and death.",
                pinyin: "wú kǔ jí miè dào wú zhì yì wú dé",
                chinese: "無苦集滅道，無智亦無得。"
            ),
            Verse(
                number: 10,
                text: "There is no suffering, no cause of suffering, no end to suffering, no path to follow.",
                pinyin: "yǐ wú suǒ dé gù pú tí sà duǒ yī bō rě bō luó mì duō gù xīn wú guà ài",
                chinese: "以無所得故，菩提薩埵，依般若波羅蜜多故，心無罣礙。"
            ),
            Verse(
                number: 11,
                text: "There is no attainment of wisdom, and no wisdom to attain.",
                pinyin: "wú guà ài gù wú yǒu kǒng bù yuǎn lí diān dǎo mèng xiǎng jiū jìng niè pán",
                chinese: "無罣礙故，無有恐怖，遠離顛倒夢想，究竟涅槃。"
            ),
            Verse(
                number: 12,
                text: "The Bodhisattvas rely on the Perfection of Wisdom, and so with no delusions, they feel no fear, and have Nirvana here and now.",
                pinyin: "sān shì zhū fó yī bō rě bō luó mì duō gù dé ā nuò duō luó sān miǎo sān pú tí",
                chinese: "三世諸佛，依般若波羅蜜多故，得阿耨多羅三藐三菩提。"
            ),
            Verse(
                number: 13,
                text: "All the Buddhas, past, present, and future, rely on the Perfection of Wisdom, and live in full enlightenment.",
                pinyin: "gù zhī bō rě bō luó mì duō shì dà shén zhòu shì dà míng zhòu shì wú shàng zhòu shì wú děng děng zhòu",
                chinese: "故知般若波羅蜜多，是大神咒，是大明咒，是無上咒，是無等等咒，"
            ),
            Verse(
                number: 14,
                text: "The Perfection of Wisdom is the greatest mantra. It is the clearest mantra, the highest mantra, the mantra that removes all suffering.",
                pinyin: "néng chú yī qiè kǔ zhēn shí bù xū",
                chinese: "能除一切苦，真實不虛。"
            ),
            Verse(
                number: 15,
                text: "This is truth that cannot be doubted. Say it so: Gate, gate, paragate, parasamgate, bodhi svaha! (Gone, gone, gone beyond, gone completely beyond, enlightenment, hail!)",
                pinyin: "gù shuō bō rě bō luó mì duō zhòu jí shuō zhòu yuē jiē dì jiē dì bō luó jiē dì bō luó sēng jiē dì pú tí sà pó hē",
                chinese: "故說般若波羅蜜多咒，即說咒曰：揭諦揭諦，波羅揭諦，波羅僧揭諦，菩提薩婆訶。"
            )
        ]
        for verse in heartChapter1.verses {
            verse.chapter = heartChapter1
        }
        heartSutra.chapters.append(heartChapter1)
        context.insert(heartSutra)
        }
        
        // Diamond Sutra
        if shouldLoadDiamondSutra {
        let diamondSutra = BuddhistText(
            title: "Diamond Sutra (金剛般若波羅蜜經)",
            author: "Buddha",
            textDescription: "The Diamond Cutter Sutra",
            category: "Sutra",
            coverImageName: "DiamondSutra"
        )
        
        let diamondChapter1 = Chapter(number: 1, title: "The Setting")
        diamondChapter1.text = diamondSutra
        diamondChapter1.verses = [
            Verse(
                number: 1,
                text: "Thus have I heard. Once the Buddha was staying in the monastery in Anathapindika's garden in the Jeta Grove near Shravasti with a community of 1,250 bhikkhus, fully ordained monks.",
                pinyin: "rú shì wǒ wén。yī shí fó zài shě wèi guó，qí shù jǐ gū dú yuán，yǔ dà bǐ qiū zhòng qiān èr bǎi wǔ shí rén jù。",
                chinese: "如是我聞。一時佛在舍衛國，祇樹給孤獨園，與大比丘眾千二百五十人俱。"
            ),
            Verse(
                number: 2,
                text: "That day, as evening approached, the Buddha put on his patched robe and, carrying his bowl, entered the capital of Shravasti to seek offerings of food.",
                pinyin: "ěr shí shì zūn shí shí，zhuó yī chí bō，rù shě wèi dà chéng qǐ shí。",
                chinese: "爾時世尊食時，著衣持缽，入舍衛大城乞食。"
            ),
            Verse(
                number: 3,
                text: "After going from house to house and receiving offerings, he returned to the Jeta Grove. When he had finished his meal, he put away his bowl and robe, bathed his feet, and sat with his legs crossed and his body upright upon the seat arranged for him, mindfully fixing his attention in front of him.",
                pinyin: "yú qí chéng zhōng，cì dì qǐ yǐ，hái zhì běn chù。fàn shí qì，shōu yī bō，xǐ zú yǐ，fū zuò ér zuò。",
                chinese: "於其城中，次第乞已，還至本處。飯食訖，收衣缽，洗足已，敷座而坐。"
            )
        ]
        for verse in diamondChapter1.verses {
            verse.chapter = diamondChapter1
        }
        
        let diamondChapter2 = Chapter(number: 2, title: "Subhuti's Request")
        diamondChapter2.text = diamondSutra
        diamondChapter2.verses = [
            Verse(
                number: 1,
                text: "At that time the elder Subhuti came forth from the assembly, bared his right shoulder, knelt upon his right knee, and, raising his hands with palms joined, respectfully addressed the Buddha:",
                pinyin: "shí zháng lǎo xū pú tí，zài dà zhòng zhōng，jí cóng zuò qǐ，piān tǎn yòu jiān，yòu xī zhuó dì，hé zhǎng gōng jìng，ér bái fó yán：",
                chinese: "時長老須菩提，在大眾中，即從座起，偏袒右肩，右膝著地，合掌恭敬，而白佛言："
            ),
            Verse(
                number: 2,
                text: "World-Honored One, it is rare how well the Tathagata teaches the bodhisattvas how to care for their minds.",
                pinyin: "xī yǒu shì zūn！rú lái shàn hù niàn zhū pú sà，shàn fù zhǔ zhū pú sà。",
                chinese: "希有世尊！如來善護念諸菩薩，善付囑諸菩薩。"
            ),
            Verse(
                number: 3,
                text: "World-Honored One, how should those who set forth on the bodhisattva path maintain their awareness, and how should they control their thoughts?",
                pinyin: "shì zūn！shàn nán zǐ、shàn nǚ rén，fā ā nòu duō luó sān miǎo sān pú tí xīn，yīng yún hé zhù？yún hé xiáng fú qí xīn？",
                chinese: "世尊！善男子、善女人，發阿耨多羅三藐三菩提心，應云何住？云何降伏其心？"
            )
        ]
        for verse in diamondChapter2.verses {
            verse.chapter = diamondChapter2
        }
        
        let diamondChapter3 = Chapter(number: 3, title: "The First Teaching")
        diamondChapter3.text = diamondSutra
        diamondChapter3.verses = [
            Verse(
                number: 1,
                text: "The Buddha said: 'Subhuti, those who would now set forth on the bodhisattva path should thus give birth to this thought:'",
                pinyin: "fó yán：'shàn zāi，shàn zāi！xū pú tí，rú rǔ suǒ shuō，rú lái shàn hù niàn zhū pú sà，shàn fù zhǔ zhū pú sà。rǔ jīn dì tīng，dāng wéi rǔ shuō：",
                chinese: "佛言：'善哉，善哉！須菩提，如汝所說，如來善護念諸菩薩，善付囑諸菩薩。汝今諦聽，當為汝說："
            ),
            Verse(
                number: 2,
                text: "'However many beings there are in whatever realms of being might exist, whether they are born from an egg or from a womb, from water or from air, whether they have form or no form, whether they have perception or no perception or neither perception nor no perception, I must lead them to the shore of liberation.'",
                pinyin: "shàn nán zǐ、shàn nǚ rén，fā ā nòu duō luó sān miǎo sān pú tí xīn，yīng rú shì zhù，rú shì xiáng fú qí xīn。'",
                chinese: "善男子、善女人，發阿耨多羅三藐三菩提心，應如是住，如是降伏其心。'"
            ),
            Verse(
                number: 3,
                text: "But after this innumerable, immeasurable, infinite number of beings has been liberated, in truth no being has been liberated. Why is this, Subhuti? It is because no bodhisattva who is a true bodhisattva cherishes the idea of an ego-entity, a personality, a being, or a separated individuality.",
                pinyin: "'wéi rán，shì zūn！yuàn lè yù wén。'",
                chinese: "'唯然，世尊！願樂欲聞。'"
            )
        ]
        for verse in diamondChapter3.verses {
            verse.chapter = diamondChapter3
        }
        
        let diamondChapter4 = Chapter(number: 4, title: "Wondrous Practice Without Abiding")
        diamondChapter4.text = diamondSutra
        diamondChapter4.verses = [
            Verse(
                number: 1,
                text: "The Buddha said to Subhuti: 'All bodhisattvas, great beings, should thus subdue their minds: Whatever forms of life there are, whether born from eggs, from wombs, from moisture, or spontaneously; whether with form or without form; whether with perception, without perception, or with neither perception nor non-perception—I must cause all of them to enter the final nirvana that leaves nothing behind and liberate them all.'",
                pinyin: "fó gào xū pú tí：'zhū pú sà mó hē sà，yīng rú shì xiáng fú qí xīn：suǒ yǒu yī qiè zhòng shēng zhī lèi，ruò luǎn shēng，ruò tāi shēng，ruò shī shēng，ruò huà shēng；ruò yǒu sè，ruò wú sè；ruò yǒu xiǎng，ruò wú xiǎng，ruò fēi yǒu xiǎng fēi wú xiǎng，wǒ jiē lìng rù wú yú niè pán ér miè dù zhī。",
                chinese: "佛告須菩提：'諸菩薩摩訶薩，應如是降伏其心：所有一切眾生之類，若卵生，若胎生，若濕生，若化生；若有色，若無色；若有想，若無想，若非有想非無想，我皆令入無餘涅槃而滅度之。"
            ),
            Verse(
                number: 2,
                text: "'But although immeasurable, innumerable, and unlimited numbers of beings have been liberated, in truth no being has been liberated. Why is this, Subhuti? It is because no bodhisattva who is a true bodhisattva cherishes the idea of an ego-entity, a personality, a being, or a separated individuality.'",
                pinyin: "rú shì miè dù wú liàng wú shù wú biān zhòng shēng，shí wú zhòng shēng dé miè dù zhě。hé yǐ gù？xū pú tí，ruò pú sà yǒu wǒ xiàng、rén xiàng、zhòng shēng xiàng、shòu zhě xiàng，jí fēi pú sà。",
                chinese: "如是滅度無量無數無邊眾生，實無眾生得滅度者。何以故？須菩提，若菩薩有我相、人相、眾生相、壽者相，即非菩薩。"
            )
        ]
        for verse in diamondChapter4.verses {
            verse.chapter = diamondChapter4
        }
        
        let diamondChapter5 = Chapter(number: 5, title: "The True Perception")
        diamondChapter5.text = diamondSutra
        diamondChapter5.verses = [
            Verse(
                number: 1,
                text: "'Moreover, Subhuti, a bodhisattva should practice charity without abiding in the idea of form. That is to say, he should practice charity without being dependent on sights, sounds, smells, tastes, tactile sensations, or any mental concepts.'",
                pinyin: "'fù cì，xū pú tí，pú sà yú fǎ，yīng wú suǒ zhù xíng yú bù shī，suǒ wèi bù zhù sè bù shī，bù zhù shēng xiāng wèi chù fǎ bù shī。",
                chinese: "'復次，須菩提，菩薩於法，應無所住行於布施，所謂不住色布施，不住聲香味觸法布施。"
            ),
            Verse(
                number: 2,
                text: "'Subhuti, a bodhisattva should practice charity in this way. And why? Because the merit of such charity is not conceivable.'",
                pinyin: "xū pú tí，pú sà yīng rú shì bù shī，bù zhù yú xiàng。hé yǐ gù？ruò pú sà bù zhù xiàng bù shī，qí fú dé bù kě sī liàng。",
                chinese: "須菩提，菩薩應如是布施，不住於相。何以故？若菩薩不住相布施，其福德不可思量。"
            )
        ]
        for verse in diamondChapter5.verses {
            verse.chapter = diamondChapter5
        }
        
        let diamondChapter6 = Chapter(number: 6, title: "Rare Is True Faith")
        diamondChapter6.text = diamondSutra
        diamondChapter6.verses = [
            Verse(
                number: 1,
                text: "'Subhuti, what do you think? Can the Tathagata be seen by means of his bodily form?' 'No, World-Honored One, the Tathagata cannot be seen by means of his bodily form. Why? Because when the Tathagata speaks of bodily form, it is not really bodily form.'",
                pinyin: "'xū pú tí，yú yì yún hé？kě yǐ shēn xiàng jiàn rú lái fǒu？' 'fǒu yě，shì zūn！bù kě yǐ shēn xiàng dé jiàn rú lái。hé yǐ gù？rú lái suǒ shuō shēn xiàng，jí fēi shēn xiàng。",
                chinese: "'須菩提，於意云何？可以身相見如來否？' '否也，世尊！不可以身相得見如來。何以故？如來所說身相，即非身相。"
            ),
            Verse(
                number: 2,
                text: "The Buddha said to Subhuti: 'All forms are unreal. When you see that all forms are unreal, then you will see the Tathagata.'",
                pinyin: "fó gào xū pú tí：'fán suǒ yǒu xiàng，jiē shì xū wàng。ruò jiàn zhū xiàng fēi xiàng，jí jiàn rú lái。",
                chinese: "佛告須菩提：'凡所有相，皆是虛妄。若見諸相非相，即見如來。"
            )
        ]
        for verse in diamondChapter6.verses {
            verse.chapter = diamondChapter6
        }
        
        let diamondChapter7 = Chapter(number: 7, title: "No Attainment, No Teaching")
        diamondChapter7.text = diamondSutra
        diamondChapter7.verses = [
            Verse(
                number: 1,
                text: "Subhuti said to the Buddha: 'World-Honored One, will there be any beings in the future who, when they hear this teaching, will believe it?' The Buddha said: 'Subhuti, they are neither beings nor non-beings. Why? Subhuti, \"beings,\" \"beings,\" the Tathagata says, are not really beings; they are just called \"beings.\"'",
                pinyin: "xū pú tí bái fó yán：'shì zūn，pō yǒu zhòng shēng，dé wén rú shì yán shuō zhāng jù，néng shēng xìn xīn fǒu？' fó gào xū pú tí：'mò zuò shì shuō。xū pú tí，rú lái miè hòu，hòu wǔ bǎi suì，yǒu chí jiè xiū fú zhě，yú cǐ zhāng jù，néng shēng xìn xīn，yǐ wéi shí。",
                chinese: "須菩提白佛言：'世尊，頗有眾生，得聞如是言說章句，生實信否？' 佛告須菩提：'莫作是說。須菩提，如來滅後，後五百歲，有持戒修福者，於此章句，能生信心，以此為實。"
            )
        ]
        for verse in diamondChapter7.verses {
            verse.chapter = diamondChapter7
        }
        
        let diamondChapter8 = Chapter(number: 8, title: "Equal and Unequal")
        diamondChapter8.text = diamondSutra
        diamondChapter8.verses = [
            Verse(
                number: 1,
                text: "'Subhuti, what do you think? If someone filled the three thousand great thousand worlds with the seven treasures and gave them all away in the practice of charity, would the merit obtained by that person be great?' Subhuti said: 'Yes, World-Honored One. Why? Because this merit is not of the nature of merit, the Tathagata says the merit is great.'",
                pinyin: "'xū pú tí，yú yì yún hé？ruò rén mǎn sān qiān dà qiān shì jiè qī bǎo，yǐ yòng bù shī，shì rén yǐ cǐ yīn yuán，dé fú duō fǒu？' 'rú shì，shì zūn！cǐ rén yǐ cǐ yīn yuán，dé fú shèn duō。",
                chinese: "'須菩提，於意云何？若人滿三千大千世界七寶，以用布施，是人以是因緣，得福多否？' '如是，世尊！此人以是因緣，得福甚多。"
            ),
            Verse(
                number: 2,
                text: "'If, on the other hand, a person receives and holds even only four lines of this teaching and teaches them to others, his merit will be even greater. Why? Because, Subhuti, all buddhas and their highest, most fulfilled, most awakened teachings issue from this teaching.'",
                pinyin: "'xū pú tí，ruò fú dé wén shì jīng，xìn xīn bù nì，qí fú shèng bǐ。hé yǐ gù？xū pú tí，zhū fó wú shàng zhèng děng zhèng jué，jiē cóng cǐ jīng chū。",
                chinese: "'須菩提，若復得聞是經，信心不逆，其福勝彼。何以故？須菩提，諸佛無上正等正覺，皆從此經出。"
            )
        ]
        for verse in diamondChapter8.verses {
            verse.chapter = diamondChapter8
        }
        
        let diamondChapter9 = Chapter(number: 9, title: "Real Designation Is Undesignate")
        diamondChapter9.text = diamondSutra
        diamondChapter9.verses = [
            Verse(
                number: 1,
                text: "'Subhuti, what do you think? Does a stream-enterer think, \"I have obtained the fruit of stream-entry\"?' Subhuti said: 'No, World-Honored One. Why? Because \"stream-entry\" is merely a name. There is no stream-entry. The stream-enterer does not enter streams, forms, sounds, smells, tastes, tactile sensations, or mind objects. That is why he is called a stream-enterer.'",
                pinyin: "'xū pú tí，yú yì yún hé？xū tuó huán néng zuò shì niàn：wǒ dé xū tuó huán guǒ fǒu？' xū pú tí yán：'fǒu yě，shì zūn！hé yǐ gù？xū tuó huán míng wéi rù liú，ér wú suǒ rù，bù rù sè shēng xiāng wèi chù fǎ，shì míng xū tuó huán。",
                chinese: "'須菩提，於意云何？須陀洹能作是念：我得須陀洹果否？' 須菩提言：'否也，世尊！何以故？須陀洹名為入流，而無所入，不入色聲香味觸法，是名須陀洹。"
            )
        ]
        for verse in diamondChapter9.verses {
            verse.chapter = diamondChapter9
        }
        
        let diamondChapter10 = Chapter(number: 10, title: "Setting Forth Pure Lands")
        diamondChapter10.text = diamondSutra
        diamondChapter10.verses = [
            Verse(
                number: 1,
                text: "'Subhuti, what do you think? When the Tathagata was with Burning Lamp Buddha, did he have any method of attaining highest, most fulfilled, awakened mind?' 'No, World-Honored One. As I understand the meaning of what the Buddha says, when the Tathagata was with Burning Lamp Buddha, he had no method of attaining highest, most fulfilled, awakened mind.'",
                pinyin: "'xū pú tí，yú yì yún hé？rú lái zài rán děng fó suǒ，yú fǎ yǒu suǒ dé fǒu？' 'fǒu yě，shì zūn！rú lái zài rán děng fó suǒ，yú fǎ shí wú suǒ dé。",
                chinese: "'須菩提，於意云何？如來在燃燈佛所，於法有所得否？' '否也，世尊！如來在燃燈佛所，於法實無所得。"
            ),
            Verse(
                number: 2,
                text: "The Buddha said: 'So it is, Subhuti. So it is. The Tathagata has no method of attaining highest, most fulfilled, awakened mind. Subhuti, if the Tathagata had had any method of attaining it, Burning Lamp Buddha would not have predicted, \"In your next life you will be a buddha named Shakyamuni.\"'",
                pinyin: "'xū pú tí，yú yì yún hé？pú sà zhuāng yán fó tǔ fǒu？' 'fǒu yě，shì zūn！hé yǐ gù？zhuāng yán fó tǔ zhě，jí fēi zhuāng yán，shì míng zhuāng yán。",
                chinese: "'須菩提，於意云何？菩薩莊嚴佛土否？' '否也，世尊！何以故？莊嚴佛土者，即非莊嚴，是名莊嚴。"
            )
        ]
        for verse in diamondChapter10.verses {
            verse.chapter = diamondChapter10
        }
        
        let diamondChapter11 = Chapter(number: 11, title: "The Superiority of Unformulated Truth")
        diamondChapter11.text = diamondSutra
        diamondChapter11.verses = [
            Verse(
                number: 1,
                text: "'Subhuti, if a bodhisattva thinks, \"I am liberating sentient beings,\" he is not worthy of being called a bodhisattva. Why? Subhuti, there is no independently existing individual soul called a bodhisattva. Therefore the Buddha says all dharmas are without self, without personality, without entity, and without separate individuality.'",
                pinyin: "'xū pú tí，rú pú sà yǒu wǒ xiàng、rén xiàng、zhòng shēng xiàng、shòu zhě xiàng，jí fēi pú sà。",
                chinese: "'須菩提，如菩薩有我相、人相、眾生相、壽者相，即非菩薩。"
            ),
            Verse(
                number: 2,
                text: "'Subhuti, what do you think? Does the Tathagata have the physical eye?' 'Yes, World-Honored One, the Tathagata has the physical eye.'",
                pinyin: "'suǒ yǐ zhě hé？xū pú tí，shí wú yǒu fǎ míng pú sà。",
                chinese: "'所以者何？須菩提，實無有法名菩薩。"
            )
        ]
        for verse in diamondChapter11.verses {
            verse.chapter = diamondChapter11
        }
        
        let diamondChapter12 = Chapter(number: 12, title: "Venerating the True Teaching")
        diamondChapter12.text = diamondSutra
        diamondChapter12.verses = [
            Verse(
                number: 1,
                text: "'Moreover, Subhuti, if there were as many Ganges rivers as the grains of sand in the great Ganges, and if there were as many buddha lands as grains of sand in all those Ganges rivers, would those buddha lands be many?' 'Very many, World-Honored One.'",
                pinyin: "'fù cì，xū pú tí，ruò rén yǐ cǐ jīng，yǔ sì zhòng děng shuō，qí fú zuì shèng。hé yǐ gù？xū pú tí，yī qiè zhū fó，jí zhū fó ā nòu duō luó sān miǎo sān pú tí fǎ，jiē cóng cǐ jīng chū。",
                chinese: "'復次，須菩提，若人以此經，與四眾等說，其福最勝。何以故？須菩提，一切諸佛，及諸佛阿耨多羅三藐三菩提法，皆從此經出。"
            ),
            Verse(
                number: 2,
                text: "The Buddha said: 'Subhuti, if a good man or good woman were to take from this teaching even only four lines and teach them to others, his or her merit would be greater than the merit of one who gave those buddha lands filled with the seven treasures. Why? Because, Subhuti, all buddhas and their highest, most fulfilled, most awakened teachings issue from this teaching.'",
                pinyin: "xū pú tí，suǒ wèi fó fǎ zhě，jí fēi fó fǎ，shì míng fó fǎ。",
                chinese: "須菩提，所謂佛法者，即非佛法，是名佛法。"
            )
        ]
        for verse in diamondChapter12.verses {
            verse.chapter = diamondChapter12
        }
        
        let diamondChapter13 = Chapter(number: 13, title: "The Way Is Made Plain")
        diamondChapter13.text = diamondSutra
        diamondChapter13.verses = [
            Verse(
                number: 1,
                text: "'Subhuti, what do you think? Does the Tathagata have the flesh eye?' 'Yes, World-Honored One, the Tathagata has the flesh eye.'",
                pinyin: "'xū pú tí，yú yì yún hé？rú lái yǒu ròu yǎn fǒu？' 'rú shì，shì zūn！rú lái yǒu ròu yǎn。",
                chinese: "'須菩提，於意云何？如來有肉眼否？' '如是，世尊！如來有肉眼。"
            ),
            Verse(
                number: 2,
                text: "'Subhuti, what do you think? Does the Tathagata have the heavenly eye?' 'Yes, World-Honored One, the Tathagata has the heavenly eye.'",
                pinyin: "'xū pú tí，yú yì yún hé？rú lái yǒu tiān yǎn fǒu？' 'rú shì，shì zūn！rú lái yǒu tiān yǎn。",
                chinese: "'須菩提，於意云何？如來有天眼否？' '如是，世尊！如來有天眼。"
            ),
            Verse(
                number: 3,
                text: "'Subhuti, what do you think? Does the Tathagata have the wisdom eye?' 'Yes, World-Honored One, the Tathagata has the wisdom eye.'",
                pinyin: "'xū pú tí，yú yì yún hé？rú lái yǒu huì yǎn fǒu？' 'rú shì，shì zūn！rú lái yǒu huì yǎn。",
                chinese: "'須菩提，於意云何？如來有慧眼否？' '如是，世尊！如來有慧眼。"
            ),
            Verse(
                number: 4,
                text: "'Subhuti, what do you think? Does the Tathagata have the dharma eye?' 'Yes, World-Honored One, the Tathagata has the dharma eye.'",
                pinyin: "'xū pú tí，yú yì yún hé？rú lái yǒu fǎ yǎn fǒu？' 'rú shì，shì zūn！rú lái yǒu fǎ yǎn。",
                chinese: "'須菩提，於意云何？如來有法眼否？' '如是，世尊！如來有法眼。"
            ),
            Verse(
                number: 5,
                text: "'Subhuti, what do you think? Does the Tathagata have the buddha eye?' 'Yes, World-Honored One, the Tathagata has the buddha eye.'",
                pinyin: "'xū pú tí，yú yì yún hé？rú lái yǒu fó yǎn fǒu？' 'rú shì，shì zūn！rú lái yǒu fó yǎn。",
                chinese: "'須菩提，於意云何？如來有佛眼否？' '如是，世尊！如來有佛眼。"
            )
        ]
        for verse in diamondChapter13.verses {
            verse.chapter = diamondChapter13
        }
        
        let diamondChapter14 = Chapter(number: 14, title: "Perfect Peace Lies in Freedom from Characteristic Distinctions")
        diamondChapter14.text = diamondSutra
        diamondChapter14.verses = [
            Verse(
                number: 1,
                text: "'Subhuti, what do you think? If there were as many Ganges rivers as the grains of sand in the great Ganges, would the grains of sand in all those Ganges rivers be many?' Subhuti said: 'Very many, World-Honored One. Just the Ganges rivers alone would be innumerable; how much more so would be their grains of sand.'",
                pinyin: "'xū pú tí，yú yì yún hé？héng hé zhōng suǒ yǒu shā，fó shuō shì shā fǒu？' 'rú shì，shì zūn！rú lái shuō shì shā。",
                chinese: "'須菩提，於意云何？恆河中所有沙，佛說是沙否？' '如是，世尊！如來說是沙。"
            ),
            Verse(
                number: 2,
                text: "'Subhuti, what do you think? If a good man or good woman ground the three thousand great thousand worlds to particles of dust, would those particles of dust be many?' 'Very many, World-Honored One.'",
                pinyin: "'xū pú tí，yú yì yún hé？yī héng hé shā shuō yī shā，rú shì héng hé níng wéi shā shù，níng wéi duō fǒu？' 'shèn duō，shì zūn！",
                chinese: "'須菩提，於意云何？一恆河沙說一沙，如是恆河寧為沙數，寧為多否？' '甚多，世尊！"
            )
        ]
        for verse in diamondChapter14.verses {
            verse.chapter = diamondChapter14
        }
        
        let diamondChapter15 = Chapter(number: 15, title: "The Incomparable Value of This Teaching")
        diamondChapter15.text = diamondSutra
        diamondChapter15.verses = [
            Verse(
                number: 1,
                text: "'Subhuti, if a good man or good woman were to take from this teaching even only four lines and teach them to others, his or her merit would be greater than the merit of one who gave those worlds filled with the seven treasures. Why? Because, Subhuti, all buddhas and their highest, most fulfilled, most awakened teachings issue from this teaching.'",
                pinyin: "'xū pú tí，wǒ jīn shí yán gào rǔ：ruò yǒu shàn nán zǐ、shàn nǚ rén，yǐ qī bǎo mǎn ěr suǒ héng hé shā shù sān qiān dà qiān shì jiè，yǐ yòng bù shī，dé fú duō fǒu？' 'shèn duō，shì zūn！",
                chinese: "'須菩提，我今實言告汝：若有善男子、善女人，以七寶滿爾所恆河沙數三千大千世界，以用布施，得福多否？' '甚多，世尊！"
            )
        ]
        for verse in diamondChapter15.verses {
            verse.chapter = diamondChapter15
        }
        
        let diamondChapter16 = Chapter(number: 16, title: "Purgation Through Suffering the Final Martyrdoms")
        diamondChapter16.text = diamondSutra
        diamondChapter16.verses = [
            Verse(
                number: 1,
                text: "'Subhuti, if a good man or good woman accepts and holds even only four lines of this teaching and teaches them to others, his or her merit will be greater than the merit of one who gave immeasurable, innumerable worlds filled with the seven treasures. Why? Because, Subhuti, all buddhas and their highest, most fulfilled, most awakened teachings issue from this teaching.'",
                pinyin: "'ruò fù yǒu rén，wén cǐ jīng diǎn，xìn xīn bù nì，qí fú shèng bǐ。hé kuàng shū xiě、shòu chí、dú sòng、wéi rén jiě shuō。",
                chinese: "'若復有人，聞此經典，信心不逆，其福勝彼。何況書寫、受持、讀誦、為人解說。"
            )
        ]
        for verse in diamondChapter16.verses {
            verse.chapter = diamondChapter16
        }
        
        let diamondChapter17 = Chapter(number: 17, title: "No One Attains Transcendental Wisdom")
        diamondChapter17.text = diamondSutra
        diamondChapter17.verses = [
            Verse(
                number: 1,
                text: "'At that time Subhuti said to the Buddha: 'World-Honored One, if good men and good women resolve their minds on highest, most fulfilled, awakened mind, how should they abide? How should they subdue their minds?'",
                pinyin: "'ěr shí，xū pú tí bái fó yán：'shì zūn！shàn nán zǐ、shàn nǚ rén，fā ā nòu duō luó sān miǎo sān pú tí xīn，yún hé yīng zhù？yún hé xiáng fú qí xīn？",
                chinese: "'爾時，須菩提白佛言：'世尊！善男子、善女人，發阿耨多羅三藐三菩提心，云何應住？云何降伏其心？"
            ),
            Verse(
                number: 2,
                text: "The Buddha said to Subhuti: 'Good men and good women who resolve their minds on highest, most fulfilled, awakened mind should thus resolve: \"I must liberate all sentient beings, yet when all sentient beings have been liberated, not a single sentient being has actually been liberated.\" Why? Subhuti, if a bodhisattva cherishes the idea of an ego-entity, a personality, a being, or a separated individuality, he is not a bodhisattva.'",
                pinyin: "fó gào xū pú tí：'shàn nán zǐ、shàn nǚ rén，fā ā nòu duō luó sān miǎo sān pú tí xīn zhě，dāng shēng rú shì xīn：wǒ yīng miè dù yī qiè zhòng shēng。miè dù yī qiè zhòng shēng yǐ，ér wú yǒu yī zhòng shēng shí miè dù zhě。",
                chinese: "佛告須菩提：'善男子、善女人，發阿耨多羅三藐三菩提心者，當生如是心：我應滅度一切眾生。滅度一切眾生已，而無有一眾生實滅度者。"
            )
        ]
        for verse in diamondChapter17.verses {
            verse.chapter = diamondChapter17
        }
        
        let diamondChapter18 = Chapter(number: 18, title: "All Modes of Mind Are Only Mind")
        diamondChapter18.text = diamondSutra
        diamondChapter18.verses = [
            Verse(
                number: 1,
                text: "'Subhuti, what do you think? Does the Tathagata have the flesh eye?' 'Yes, World-Honored One, the Tathagata has the flesh eye.'",
                pinyin: "'hé yǐ gù？ruò pú sà yǒu wǒ xiàng、rén xiàng、zhòng shēng xiàng、shòu zhě xiàng，zé fēi pú sà。",
                chinese: "'何以故？若菩薩有我相、人相、眾生相、壽者相，則非菩薩。"
            ),
            Verse(
                number: 2,
                text: "'So it is, Subhuti. So it is. If a bodhisattva cherishes the idea of an ego-entity, a personality, a being, or a separated individuality, he is not a bodhisattva. Why? Subhuti, there is no independently existing individual soul called a bodhisattva.'",
                pinyin: "'suǒ yǐ zhě hé？xū pú tí，shí wú yǒu fǎ fā ā nòu duō luó sān miǎo sān pú tí xīn zhě。",
                chinese: "'所以者何？須菩提，實無有法發阿耨多羅三藐三菩提心者。"
            )
        ]
        for verse in diamondChapter18.verses {
            verse.chapter = diamondChapter18
        }
        
        let diamondChapter19 = Chapter(number: 19, title: "Absolute Reality Is the Only Foundation")
        diamondChapter19.text = diamondSutra
        diamondChapter19.verses = [
            Verse(
                number: 1,
                text: "'Subhuti, what do you think? Does the Tathagata have the flesh eye?' 'Yes, World-Honored One, the Tathagata has the flesh eye.'",
                pinyin: "'xū pú tí，yú yì yún hé？rú lái yǒu ròu yǎn fǒu？' 'rú shì，shì zūn！rú lái yǒu ròu yǎn。",
                chinese: "'須菩提，於意云何？如來有肉眼否？' '如是，世尊！如來有肉眼。"
            ),
            Verse(
                number: 2,
                text: "'Subhuti, what do you think? Does the Tathagata have the heavenly eye?' 'Yes, World-Honored One, the Tathagata has the heavenly eye.'",
                pinyin: "'xū pú tí，yú yì yún hé？rú lái yǒu tiān yǎn fǒu？' 'rú shì，shì zūn！rú lái yǒu tiān yǎn。",
                chinese: "'須菩提，於意云何？如來有天眼否？' '如是，世尊！如來有天眼。"
            )
        ]
        for verse in diamondChapter19.verses {
            verse.chapter = diamondChapter19
        }
        
        let diamondChapter20 = Chapter(number: 20, title: "The Unreality of Phenomenal Distinctions")
        diamondChapter20.text = diamondSutra
        diamondChapter20.verses = [
            Verse(
                number: 1,
                text: "'Subhuti, what do you think? Can the Tathagata be seen by means of his bodily form?' 'No, World-Honored One, the Tathagata cannot be seen by means of his bodily form. Why? Because when the Tathagata speaks of bodily form, it is not really bodily form.'",
                pinyin: "'xū pú tí，yú yì yún hé？kě yǐ shēn xiàng jiàn rú lái fǒu？' 'fǒu yě，shì zūn！bù kě yǐ shēn xiàng dé jiàn rú lái。",
                chinese: "'須菩提，於意云何？可以身相見如來否？' '否也，世尊！不可以身相得見如來。"
            ),
            Verse(
                number: 2,
                text: "The Buddha said to Subhuti: 'All forms are unreal. When you see that all forms are unreal, then you will see the Tathagata.'",
                pinyin: "hé yǐ gù？rú lái suǒ shuō shēn xiàng，jí fēi shēn xiàng。",
                chinese: "何以故？如來所說身相，即非身相。"
            )
        ]
        for verse in diamondChapter20.verses {
            verse.chapter = diamondChapter20
        }
        
        let diamondChapter21 = Chapter(number: 21, title: "Spoken Truth Cannot Be Expressed")
        diamondChapter21.text = diamondSutra
        diamondChapter21.verses = [
            Verse(
                number: 1,
                text: "'Subhuti, do not say that the Tathagata thinks: \"I must liberate sentient beings.\" Subhuti, do not think that. Why? There are really no sentient beings for the Tathagata to liberate. If there were sentient beings for the Tathagata to liberate, the Tathagata would be cherishing the idea of an ego-entity, a personality, a being, or a separated individuality.'",
                pinyin: "'xū pú tí，rú lái bù yīng zuò shì niàn：wǒ dāng yǒu suǒ shuō fǎ。mò zuò shì niàn。hé yǐ gù？ruò rén yán rú lái yǒu suǒ shuō fǎ，jí wéi bàng fó，bù néng jiě wǒ suǒ shuō gù。",
                chinese: "'須菩提，如來不應作是念：我當有所說法。莫作是念。何以故？若人言如來有所說法，即為謗佛，不能解我所說故。"
            ),
            Verse(
                number: 2,
                text: "'Subhuti, when the Tathagata speaks of \"liberating sentient beings,\" there are really no sentient beings to be liberated. That is why the Tathagata says, \"All sentient beings are liberated.\"'",
                pinyin: "xū pú tí，shuō fǎ zhě，wú fǎ kě shuō，shì míng shuō fǎ。",
                chinese: "須菩提，說法者，無法可說，是名說法。"
            )
        ]
        for verse in diamondChapter21.verses {
            verse.chapter = diamondChapter21
        }
        
        let diamondChapter22 = Chapter(number: 22, title: "Nothing Can Be Explained")
        diamondChapter22.text = diamondSutra
        diamondChapter22.verses = [
            Verse(
                number: 1,
                text: "Then Subhuti said to the Buddha: 'World-Honored One, will there be any beings in the future who, when they hear this teaching, will believe it?' The Buddha said: 'Subhuti, they are neither beings nor non-beings. Why? Subhuti, \"beings,\" \"beings,\" the Tathagata says, are not really beings; they are just called \"beings.\"'",
                pinyin: "ěr shí huì lì，xū pú tí bái fó yán：'shì zūn！fó dé ā nòu duō luó sān miǎo sān pú tí，wéi wú suǒ dé yē？'",
                chinese: "爾時慧命，須菩提白佛言：'世尊！佛得阿耨多羅三藐三菩提，為無所得耶？"
            ),
            Verse(
                number: 2,
                text: "'So it is, Subhuti. So it is. I have not obtained the highest, most fulfilled, awakened mind. Subhuti, if I had obtained the highest, most fulfilled, awakened mind, Burning Lamp Buddha would not have predicted, \"In your next life you will be a buddha named Shakyamuni.\" Since there is no such thing as the highest, most fulfilled, awakened mind, Burning Lamp Buddha made that prediction about me.'",
                pinyin: "fó yán：'rú shì，rú shì！xū pú tí，wǒ yú ā nòu duō luó sān miǎo sān pú tí，nǎi zhì wú yǒu shǎo fǎ kě dé，shì míng ā nòu duō luó sān miǎo sān pú tí。",
                chinese: "佛言：'如是，如是！須菩提，我於阿耨多羅三藐三菩提，乃至無有少法可得，是名阿耨多羅三藐三菩提。"
            )
        ]
        for verse in diamondChapter22.verses {
            verse.chapter = diamondChapter22
        }
        
        let diamondChapter23 = Chapter(number: 23, title: "The Pure Heart Practices Goodness")
        diamondChapter23.text = diamondSutra
        diamondChapter23.verses = [
            Verse(
                number: 1,
                text: "'Moreover, Subhuti, this is equal everywhere, without differentiation. It is called highest, most fulfilled, awakened mind. It is free from ego-entity, free from personality, free from being, and free from separated individuality. All wholesome dharmas are included in this teaching.'",
                pinyin: "'fù cì，xū pú tí，shì fǎ píng děng，wú yǒu gāo xià，shì míng ā nòu duō luó sān miǎo sān pú tí。yǐ wú wǒ、wú rén、wú zhòng shēng、wú shòu zhě，xiū yī qiè shàn fǎ，jí dé ā nòu duō luó sān miǎo sān pú tí。",
                chinese: "'復次，須菩提，是法平等，無有高下，是名阿耨多羅三藐三菩提。以無我、無人、無眾生、無壽者，修一切善法，即得阿耨多羅三藐三菩提。"
            ),
            Verse(
                number: 2,
                text: "'Subhuti, what are called \"wholesome dharmas\"? The Tathagata says they are not wholesome dharmas; they are just called \"wholesome dharmas.\"'",
                pinyin: "xū pú tí，suǒ yán shàn fǎ zhě，rú lái shuō jí fēi shàn fǎ，shì míng shàn fǎ。",
                chinese: "須菩提，所言善法者，如來說即非善法，是名善法。"
            )
        ]
        for verse in diamondChapter23.verses {
            verse.chapter = diamondChapter23
        }
        
        let diamondChapter24 = Chapter(number: 24, title: "The Incomparable Merit of This Teaching")
        diamondChapter24.text = diamondSutra
        diamondChapter24.verses = [
            Verse(
                number: 1,
                text: "'Subhuti, if there were as many Ganges rivers as the grains of sand in the great Ganges, and if there were as many buddha lands as grains of sand in all those Ganges rivers, and if someone filled all those buddha lands with the seven treasures and gave them all away in the practice of charity, and if a good man or good woman were to take from this teaching even only four lines and teach them to others, his or her merit would be greater than the merit of the one who gave those buddha lands filled with the seven treasures.'",
                pinyin: "'xū pú tí，ruò sān qiān dà qiān shì jiè zhōng suǒ yǒu zhū xū mí shān wáng，rú shì dé qī bǎo mǎn ěr suǒ shù liàng，yǒu rén chí yòng bù shī。ruò rén yǐ cǐ jīng，nǎi zhì sì jù jì dé，shòu chí dú sòng，wéi tā rén shuō，yú qián fú dé，bǎi fēn bù jí yī，bǎi qiān wàn yì fēn，nǎi zhì suàn shù bǐ yù suǒ bù néng jí。",
                chinese: "'須菩提，若三千大千世界中所有諸須彌山王，如是等七寶聚，有人持用布施。若人以此經，乃至四句偈等，受持讀誦，為他人說，於前福德，百分不及一，百千萬億分，乃至算數譬喻所不能及。"
            )
        ]
        for verse in diamondChapter24.verses {
            verse.chapter = diamondChapter24
        }
        
        let diamondChapter25 = Chapter(number: 25, title: "The Illusion of Ego")
        diamondChapter25.text = diamondSutra
        diamondChapter25.verses = [
            Verse(
                number: 1,
                text: "'Subhuti, what do you think? You should not think that the Tathagata thinks: \"I must liberate sentient beings.\" Subhuti, do not think that. Why? There are really no sentient beings for the Tathagata to liberate. If there were sentient beings for the Tathagata to liberate, the Tathagata would be cherishing the idea of an ego-entity, a personality, a being, or a separated individuality.'",
                pinyin: "'xū pú tí，yú yì yún hé？rǔ děng wù wèi rú lái zuò shì niàn：wǒ dāng dù zhòng shēng。xū pú tí，mò zuò shì niàn。",
                chinese: "'須菩提，於意云何？汝等勿謂如來作是念：我當度眾生。須菩提，莫作是念。"
            ),
            Verse(
                number: 2,
                text: "'Subhuti, when the Tathagata speaks of an \"ego-entity,\" there is really no ego-entity. The common people, however, think there is one. Subhuti, when the Tathagata speaks of \"common people,\" the Tathagata says they are not really common people; they are just called \"common people.\"'",
                pinyin: "hé yǐ gù？shí wú yǒu zhòng shēng rú lái dù zhě。ruò yǒu zhòng shēng rú lái dù zhě，rú lái jí yǒu wǒ、rén、zhòng shēng、shòu zhě。",
                chinese: "何以故？實無有眾生如來度者。若有眾生如來度者，如來即有我、人、眾生、壽者。"
            )
        ]
        for verse in diamondChapter25.verses {
            verse.chapter = diamondChapter25
        }
        
        let diamondChapter26 = Chapter(number: 26, title: "The Body of Truth Has No Marks")
        diamondChapter26.text = diamondSutra
        diamondChapter26.verses = [
            Verse(
                number: 1,
                text: "'Subhuti, what do you think? Can the Tathagata be seen by means of his thirty-two marks?' Subhuti said: 'Yes, World-Honored One, the Tathagata can be seen by means of his thirty-two marks.'",
                pinyin: "'xū pú tí，rú lái shuō wǒ jiàn、rén jiàn、zhòng shēng jiàn、shòu zhě jiàn，jí fēi wǒ jiàn、rén jiàn、zhòng shēng jiàn、shòu zhě jiàn，shì míng wǒ jiàn、rén jiàn、zhòng shēng jiàn、shòu zhě jiàn。",
                chinese: "'須菩提，如來說我見、人見、眾生見、壽者見，即非我見、人見、眾生見、壽者見，是名我見、人見、眾生見、壽者見。"
            ),
            Verse(
                number: 2,
                text: "The Buddha said: 'Subhuti, if the Tathagata could be seen by means of his thirty-two marks, a universal monarch would be a Tathagata.'",
                pinyin: "'xū pú tí，fā ā nòu duō luó sān miǎo sān pú tí xīn zhě，yú yī qiè fǎ，yīng rú shì zhī，rú shì jiàn，rú shì xìn jiě，bù shēng fǎ xiàng。",
                chinese: "'須菩提，發阿耨多羅三藐三菩提心者，於一切法，應如是知，如是見，如是信解，不生法相。"
            )
        ]
        for verse in diamondChapter26.verses {
            verse.chapter = diamondChapter26
        }
        
        let diamondChapter27 = Chapter(number: 27, title: "No Truth to Teach")
        diamondChapter27.text = diamondSutra
        diamondChapter27.verses = [
            Verse(
                number: 1,
                text: "'Subhuti, if someone says the Tathagata comes or goes, sits or lies down, that person does not understand the meaning of my teaching. Why? The Tathagata has no place to come from and no place to go to. That is why he is called the Tathagata.'",
                pinyin: "xū pú tí，suǒ yán fǎ xiàng zhě，jí fēi fǎ xiàng，shì míng fǎ xiàng。",
                chinese: "須菩提，所言法相者，即非法相，是名法相。"
            )
        ]
        for verse in diamondChapter27.verses {
            verse.chapter = diamondChapter27
        }
        
        let diamondChapter28 = Chapter(number: 28, title: "No One Is Liberated")
        diamondChapter28.text = diamondSutra
        diamondChapter28.verses = [
            Verse(
                number: 1,
                text: "'Subhuti, if a bodhisattva were to fill immeasurable, innumerable worlds with the seven treasures and give them all away in the practice of charity, and if a good man or good woman were to take from this teaching even only four lines and teach them to others, the merit of the good man or good woman would be greater than the merit of the bodhisattva. Why? Subhuti, all buddhas and their highest, most fulfilled, most awakened teachings issue from this teaching.'",
                pinyin: "'xū pú tí，ruò pú sà yǐ mǎn héng hé shā déng shì jiè qī bǎo chí yòng bù shī。ruò fù yǒu rén，zhī yī qiè fǎ wú wǒ，dé chéng yú rěn，cǐ pú sà shèng qián pú sà suǒ dé gōng dé。",
                chinese: "'須菩提，若菩薩以滿恆河沙等世界七寶持用布施。若復有人，知一切法無我，得成於忍，此菩薩勝前菩薩所得功德。"
            ),
            Verse(
                number: 2,
                text: "'Subhuti, why? Because bodhisattvas do not receive merit.' Subhuti said: 'World-Honored One, how do bodhisattvas not receive merit?'",
                pinyin: "'hé yǐ gù？xū pú tí，yǐ zhū pú sà bù shòu fú dé gù。' xū pú tí bái fó yán：'shì zūn！yún hé pú sà bù shòu fú dé？",
                chinese: "'何以故？須菩提，以諸菩薩不受福德故。' 須菩提白佛言：'世尊！云何菩薩不受福德？"
            )
        ]
        for verse in diamondChapter28.verses {
            verse.chapter = diamondChapter28
        }
        
        let diamondChapter29 = Chapter(number: 29, title: "The Illusion of Appearance")
        diamondChapter29.text = diamondSutra
        diamondChapter29.verses = [
            Verse(
                number: 1,
                text: "'Subhuti, if someone says the Tathagata comes or goes, sits or lies down, that person does not understand the meaning of my teaching. Why? The Tathagata has no place to come from and no place to go to. That is why he is called the Tathagata.'",
                pinyin: "'xū pú tí，ruò yǒu rén yán：rú lái ruò lái ruò qù，ruò zuò ruò wò，shì rén bù jiě wǒ suǒ shuō yì。",
                chinese: "'須菩提，若有人言：如來若來若去，若坐若臥，是人不解我所說義。"
            ),
            Verse(
                number: 2,
                text: "'Subhuti, what is called the Tathagata? The Tathagata is the suchness of all dharmas. If someone says the Tathagata comes or goes, that person does not understand the meaning of my teaching.'",
                pinyin: "hé yǐ gù？rú lái zhě，wú suǒ cóng lái，yì wú suǒ qù，gù míng rú lái。",
                chinese: "何以故？如來者，無所從來，亦無所去，故名如來。"
            )
        ]
        for verse in diamondChapter29.verses {
            verse.chapter = diamondChapter29
        }
        
        let diamondChapter30 = Chapter(number: 30, title: "The Integral Principle")
        diamondChapter30.text = diamondSutra
        diamondChapter30.verses = [
            Verse(
                number: 1,
                text: "'Subhuti, if a good man or good woman were to take from this teaching even only four lines and teach them to others, his or her merit would be greater than the merit of one who gave immeasurable, innumerable worlds filled with the seven treasures. Why? Because, Subhuti, all buddhas and their highest, most fulfilled, most awakened teachings issue from this teaching.'",
                pinyin: "'xū pú tí，ruò shàn nán zǐ、shàn nǚ rén，yǐ sān qiān dà qiān shì jiè suì wéi wēi chén，yú yì yún hé？shì wēi chén duō fǒu？'",
                chinese: "'須菩提，若善男子、善女人，以三千大千世界碎為微塵，於意云何？是微塵多否？"
            ),
            Verse(
                number: 2,
                text: "'Subhuti said: 'Very many, World-Honored One. Why? If those particles of dust really existed, the Buddha would not have called them particles of dust. The Buddha says particles of dust are not really particles of dust; they are just called particles of dust.'",
                pinyin: "'shèn duō，shì zūn！hé yǐ gù？ruò shì wēi chén jí shí yǒu zhě，fó jí bù shuō shì wēi chén。",
                chinese: "'甚多，世尊！何以故？若是微塵實有者，佛即不說微塵。"
            )
        ]
        for verse in diamondChapter30.verses {
            verse.chapter = diamondChapter30
        }
        
        let diamondChapter31 = Chapter(number: 31, title: "No Conceptualizing Truth")
        diamondChapter31.text = diamondSutra
        diamondChapter31.verses = [
            Verse(
                number: 1,
                text: "'Subhuti, if someone says the Buddha speaks of the view of a self, the view of a person, the view of beings, or the view of a life, Subhuti, does that person understand the meaning of my teaching?'",
                pinyin: "'xū pú tí，ruò rén yán：fó shuō wǒ jiàn、rén jiàn、zhòng shēng jiàn、shòu zhě jiàn。xū pú tí，yú yì yún hé？shì rén jiě wǒ suǒ shuō yì fǒu？",
                chinese: "'須菩提，若人言：佛說我見、人見、眾生見、壽者見。須菩提，於意云何？是人解我所說義否？"
            ),
            Verse(
                number: 2,
                text: "'No, World-Honored One, that person does not understand the meaning of the Tathagata's teaching. Why? When the Buddha speaks of the view of a self, the view of a person, the view of beings, or the view of a life, the Tathagata is not speaking of the view of a self, the view of a person, the view of beings, or the view of a life. They are just called the view of a self, the view of a person, the view of beings, and the view of a life.'",
                pinyin: "'fǒu yě，shì zūn！shì rén bù jiě rú lái suǒ shuō yì。",
                chinese: "'否也，世尊！是人不解如來所說義。"
            )
        ]
        for verse in diamondChapter31.verses {
            verse.chapter = diamondChapter31
        }
        
        let diamondChapter32 = Chapter(number: 32, title: "The Delusion of Appearances")
        diamondChapter32.text = diamondSutra
        diamondChapter32.verses = [
            Verse(
                number: 1,
                text: "'Subhuti, if someone were to fill immeasurable, innumerable worlds with the seven treasures and give them all away in the practice of charity, and if a good man or good woman were to resolve their mind on highest, most fulfilled, awakened mind and take from this teaching even only four lines, memorize them, accept them, hold them, recite them, and explain them to others, his or her merit would be immeasurably, infinitely greater.'",
                pinyin: "'xū pú tí，ruò yǒu rén yǐ mǎn wú liàng ā sēng qí shì jiè qī bǎo chí yòng bù shī。ruò fù yǒu shàn nán zǐ、shàn nǚ rén，fā pú tí xīn zhě，chí yú cǐ jīng，nǎi zhì sì jù jì dé，shòu chí dú sòng，wéi rén guǎng shuō，cǐ rén fú dé，shèng qián fú dé。",
                chinese: "'須菩提，若有人以滿無量阿僧祇世界七寶持用布施。若復有善男子、善女人，發菩提心者，持於此經，乃至四句偈等，受持讀誦，為人廣說，此人福德，勝前福德。"
            ),
            Verse(
                number: 2,
                text: "'In what way should they explain them? By not grasping at appearances, abiding serenely. Why? All conditioned dharmas are like dreams, like illusions, like bubbles, like shadows, like dewdrops, like lightning. You should contemplate them thus.'",
                pinyin: "'hé yǐ gù？xū pú tí，yī qiè yǒu wéi fǎ，rú mèng huàn pào yǐng，rú lù yì rú diàn，yīng zuò rú shì guān。",
                chinese: "'何以故？須菩提，一切有為法，如夢幻泡影，如露亦如電，應作如是觀。"
            ),
            Verse(
                number: 3,
                text: "When the Buddha finished speaking this sutra, the elder Subhuti, together with the bhikkhus, bhikkhunis, laymen, laywomen, and all the heavenly beings, humans, and asuras who had listened to his teaching, were filled with joy and faithfully accepted it.",
                pinyin: "fó shuō shì jīng yǐ，zháng lǎo xū pú tí，jí zhū bǐ qiū、bǐ qiū ní、yōu pó sāi、yōu pó yí，yī qiè shì jiān、tiān、rén、ā xiū luó，wén fó suǒ shuō，jiē dà huān xǐ，xìn shòu fèng xíng。",
                chinese: "佛說是經已，長老須菩提，及諸比丘、比丘尼、優婆塞、優婆夷，一切世間、天、人、阿修羅，聞佛所說，皆大歡喜，信受奉行。"
            )
        ]
        for verse in diamondChapter32.verses {
            verse.chapter = diamondChapter32
        }
        
        diamondSutra.chapters.append(contentsOf: [diamondChapter1, diamondChapter2, diamondChapter3, diamondChapter4, diamondChapter5, diamondChapter6, diamondChapter7, diamondChapter8, diamondChapter9, diamondChapter10, diamondChapter11, diamondChapter12, diamondChapter13, diamondChapter14, diamondChapter15, diamondChapter16, diamondChapter17, diamondChapter18, diamondChapter19, diamondChapter20, diamondChapter21, diamondChapter22, diamondChapter23, diamondChapter24, diamondChapter25, diamondChapter26, diamondChapter27, diamondChapter28, diamondChapter29, diamondChapter30, diamondChapter31, diamondChapter32])
        context.insert(diamondSutra)
        }
        
        // Samadhi Water Repentance of Kindness and Compassion
        if shouldLoadWaterRepentance {
        let waterRepentance = BuddhistText(
            title: "Samadhi Water Repentance (慈悲三昧水懺科儀)",
            author: "Master Wuda",
            textDescription: "Liturgy of the Samadhi Water Repentance of Kindness and Compassion - Scroll One",
            category: "Liturgy",
            coverImageName: "SamadhiWaterRepentance"
        )
        
        let waterChapter1 = Chapter(number: 1, title: "True Incense of Precepts and Concentration")
        waterChapter1.text = waterRepentance
        waterChapter1.verses = [
            Verse(
                number: 0,
                text: "LITURGY OF THE SAMADHI WATER REPENTANCE OF KINDNESS AND COMPASSION - SCROLL ONE",
                pinyin: "cí bēi sān mèi shuǐ chàn kē yí ‧ juàn shàng",
                chinese: "【慈 悲 三 昧 水 懺 科 儀 ‧ 卷 上】"
            ),
            Verse(
                number: 1,
                text: "[Bow + Venerate the Buddha with Three Prostrations + Bow]",
                pinyin: "wèn xùn lǐ fó sān bài wèn xùn",
                chinese: "問 訊 禮 佛 三 拜 問 訊"
            ),
            Verse(
                number: 2,
                text: "[True Incense of Precepts and Concentration Praise]",
                pinyin: "jiè dìng zhēn xiāng zàn",
                chinese: "戒 定 真 香 讚"
            ),
            Verse(
                number: 3,
                text: "True incense of precepts and meditative concentration burns, rushing to the heavens above.",
                pinyin: "● jiè dìng zhēn xiāng fén qǐ chōng tiān shàng",
                chinese: "戒 定 真 香 焚 起 衝 天 上"
            ),
            Verse(
                number: 4,
                text: "Disciples devout and sincere, burn it in a golden censer.",
                pinyin: "zhòng děng qián chéng rè zài jīn lú fàng",
                chinese: "眾 等 虔 誠 爇 在 金 爐 放"
            ),
            Verse(
                number: 5,
                text: "Instantaneously it spreads, permeating the ten directions.",
                pinyin: "qǐng kè yīn yūn jí piàn mǎn shí fāng",
                chinese: "頃 刻 氤 氳 即 徧 滿 十 方"
            ),
            Verse(
                number: 6,
                text: "All peoples, past and present, avert calamities and eradicate obstructions!",
                pinyin: "gǔ jīn rén mín miǎn nàn xiāo zāi zhàng",
                chinese: "古 今 人 民 免 難 消 災 障"
            ),
            Verse(
                number: 7,
                text: "Homage to the Incense Cloud Canopy Bodhisattva-Mahāsattvas!",
                pinyin: "▲ ná mó xiāng yún gài pú sà mó hē sà (3x)",
                chinese: "南 無 香 雲 蓋 菩 薩 摩 訶 薩"
            )
        ]
        for verse in waterChapter1.verses {
            verse.chapter = waterChapter1
        }
        
        let waterChapter2 = Chapter(number: 2, title: "Prologue and Background")
        waterChapter2.text = waterRepentance
        waterChapter2.verses = [
            Verse(
                number: 1,
                text: "Respectfully listen! The Tathāgata manifests to respond to and universally benefit all beings; the Honored One practiced kindness and reverently record this.",
                pinyin: "● gōng wén rú lái yìng huà pǔ lì qún jī zūn zhě xīng cí xián zūn",
                chinese: "恭 聞 ‧ 如 來 應 化 ‧ 普 利 羣 機 ‧ 尊 者 興 慈 ‧ 咸 尊"
            ),
            Verse(
                number: 2,
                text: "Just as how the moon is reflected in the water of a pure river, the kāmalā disease manifested as an illusory ailment.",
                pinyin: "hòu jì jiāng chéng yuè yìng jiā mó luó jí ér jiǎ shì huàn yí",
                chinese: "後 記 。 江 澄 月 映 ‧ 迦 摩 羅 疾 而 假 示 幻 儀"
            ),
            Verse(
                number: 3,
                text: "A moral downfall and deep attachment arose when the king favored [Master Wuda] and bestowed a precious throne upon him.",
                pinyin: "dé sǔn ēn nóng chà dì lì chǒng ér róng yīng bǎo zuò",
                chinese: "德 損 恩 濃 ‧ 剎 帝 利 寵 而 榮 膺 寶 座"
            ),
            Verse(
                number: 4,
                text: "Yao Cuo had harbored a grudge ever since the [Battle of the] Eastern City and searched far and wide; Yuan Yang, who had formed the enmity during the Western Han, was faced with inevitable retribution—it was only a matter of time.",
                pinyin: "yáo cuò hán dōng shì zhī hèn sì xì xún shēn yuán yàng jié xī hàn zhī chóu",
                chinese: "晁 錯 含 東 市 之 恨 ‧ 伺 隙 尋 伸 ‧ 袁 盎 結 西 漢 之 讎"
            ),
            Verse(
                number: 5,
                text: "Thus, cause and effect were not in vain. From the Han to the Tang dynasty, [the grudge] was pulled throughout time.",
                pinyin: "chéng shí huò bào yóu shì guǒ yīn wú shuǎng lì hàn táng ér yǐn mǎn zhāo rán",
                chinese: "乘 時 獲 報 。 由 是 果 因 無 爽 ‧ 歷 漢 唐 而 引 滿 昭 然"
            ),
            Verse(
                number: 6,
                text: "However, upon violating the precepts, demonic enmity appeared, and thus [Master Wuda was afflicted] by an ulcer which grew a human face.",
                pinyin: "zhēn sú xiāng wéi chí jiè lǜ ér mó yuān wǎn ěr suǒ yǐ chuāng shēng rén miàn",
                chinese: "眞 俗 相 違 ‧ 弛 戒 律 而 魔 冤 宛 爾 。 所 以 瘡 生 人 面"
            ),
            Verse(
                number: 7,
                text: "It was impossible to stop the pain and suffering that came from this ulcer.",
                pinyin: "qǐ jū zhī tòng kǔ nán jīn",
                chinese: "起 居 之 痛 苦 難 禁"
            ),
            Verse(
                number: 8,
                text: "By encountering and befriending a sacred being, he accepted instructions and believed in them.",
                pinyin: "yǒu yù shèng liú shòu shòu zhī méng yán kān xìn",
                chinese: "友 遇 聖 流 ‧ 授 受 之 盟 言 堪 信"
            ),
            Verse(
                number: 9,
                text: "He traveled deep into a dark forest of fragrant grasses and wandered in search for a thousand miles.",
                pinyin: "yì lù bì nì fāng cǎo hé wò yě qiān lǐ zhī zhuī xún",
                chinese: "驛 路 睤 睨 芳 草 合 ‧ 沃 野 千 里 之 追 尋"
            ),
            Verse(
                number: 10,
                text: "Encountering a mountain pass where white clouds soared in the skies above, he passed through land after land and peak after peak.",
                pinyin: "guān shān tiáo dì bái yún fēi jǐn guó céng fēng zhī rù wàng",
                chinese: "關 山 迢 遞 白 雲 飛 ‧ 錦 國 層 峰 之 入 望"
            ),
            Verse(
                number: 11,
                text: "With earnest sincerity, his toil was effortless; with profound hope, his vows would lead him to his destination.",
                pinyin: "chéng zhòng láo qīng qiú shēn yuàn dá",
                chinese: "誠 重 勞 輕 ‧ 求 深 願 達"
            ),
            Verse(
                number: 12,
                text: "Twin pines formed a canopy over the entrance, and upon glimpsing it, his sorrows disappeared.",
                pinyin: "shuāng sōng zhāng gài hán xié zhào ér yǎng zhǐ chóu xiāo",
                chinese: "雙 松 張 蓋 ‧ 含 斜 照 而 仰 止 愁 消"
            ),
            Verse(
                number: 13,
                text: "The Nine Peaks soared into the sky, the lonely sound of a bell dispelled the darkness and the peaks and valleys filled with light.",
                pinyin: "jiǔ lǒng líng zhōng sàn shǔ zhòng yán wàn hè liú guāng",
                chinese: "九 隴 凌 鐘 散 曙 ‧ 重 巖 萬 壑 流 光"
            ),
            Verse(
                number: 14,
                text: "Honored Kanaka taught him to wash [his ulcer] with the Dharma water of samādhi, revealing a monastery which shone with a brilliant golden radiance.",
                pinyin: "zūn zhě jiā nuò dào kōng xiǎn fàn chà ér jīn guāng huī yào",
                chinese: "尊 者 迦 諾 ‧ 道 空 顯 梵 剎 而 金 光 輝 耀"
            ),
            Verse(
                number: 15,
                text: "Upon being welcomed, he announced that he wished to quickly cure his illness.",
                pinyin: "féng yíng qǐ gào yuàn jué jí zhī zǎo liào",
                chinese: "逢 迎 啓 告 ‧ 願 厥 疾 之 早 瘳"
            ),
            Verse(
                number: 16,
                text: "Comforting him, [the monk] explained that he could be free [of the illness] by bathing in a spring of sweet water.",
                pinyin: "ān wèi tián yí yù gān quán zhī kě tuō",
                chinese: "安 慰 恬 怡 ‧ 浴 甘 泉 之 可 脫"
            ),
            Verse(
                number: 17,
                text: "At the last part of the night, he washed with the Dharma water of samādhi.",
                pinyin: "hòu yè gū xǐ sān mèi zhī fǎ shuǐ",
                chinese: "後 夜 孤 洗 三 昧 之 法 水"
            ),
            Verse(
                number: 18,
                text: "National Master Wuda eradicated his afflictions from past lifetimes.",
                pinyin: "guó shī wù dá juān chú lěi shì zhī qiān yóu",
                chinese: "國 師 悟 達 ‧ 蠲 除 累 世 之 愆 尤"
            ),
            Verse(
                number: 19,
                text: "Although the event happened just once, its Dharma circulates perpetually.",
                pinyin: "shì qǐ yì shí fǎ liú qiān gǔ",
                chinese: "事 啓 一 時 ‧ 法 流 千 古"
            ),
            Verse(
                number: 20,
                text: "It was compiled as a liturgy in three scrolls—as such, humans and devas venerate it.",
                pinyin: "zhuàn wéi shàng zhòng xià sān juàn zhī yí wén rén tiān jìng yǎng",
                chinese: "撰 為 上 中 下 三 卷 之 儀 文 ‧ 人 天 敬 仰"
            ),
            Verse(
                number: 21,
                text: "It is used to repent for the transgressions of the ten unwholesome deeds which arise from one's body, speech, and mind—as such, sacred and ordinary beings seek refuge in it.",
                pinyin: "chàn mó shēn kǒu yì shí è zhī zuì yè fán shèng guī chóng",
                chinese: "懺 摩 身 口 意 十 惡 之 罪 業 ‧ 凡 聖 皈 崇"
            ),
            Verse(
                number: 22,
                text: "Proclaiming its teachings, one directs the compassionate ferry to transcend the ocean of fear.",
                pinyin: "yí xùn xiá xuān jià cí háng ér zhí chāo bù hǎi",
                chinese: "遺 訓 遐 宣 ‧ 駕 慈 航 而 直 超 怖 海"
            ),
            Verse(
                number: 23,
                text: "Venerating its profound names, one walks the path to awakening to forever leave the wheel of suffering.",
                pinyin: "hóng míng dǐng lǐ yóu jué lù ér yǒng tuō kǔ lún",
                chinese: "洪 名 頂 禮 ‧ 由 覺 路 而 永 脫 苦 輪"
            ),
            Verse(
                number: 24,
                text: "Leaving our defiled home of the five degenerations; we are born together in the pure land of nine grades of lotuses.",
                pinyin: "jiǒng chū chén láo wǔ zhuó zhī xiāng gòng shēng jìng yù jiǔ lián zhī guǒ",
                chinese: "迥 出 塵 勞 五 濁 之 鄕 ‧ 共 生 淨 域 九 蓮 之 果"
            ),
            Verse(
                number: 25,
                text: "[This text] benefits both our friends and foes; its virtues reach both the living and the deceased.",
                pinyin: "yuān qīn pǔ lì cún mò zhān ēn",
                chinese: "冤 親 普 利 ‧ 存 沒 沾 恩"
            ),
            Verse(
                number: 26,
                text: "Thus, as the repentance text is about to begin, we prostrate to Samantabhadra, King of Vows,",
                pinyin: "zī zhě chàn wén zhào qǐ yǎng kòu pǔ xián",
                chinese: "茲 者 懺 文 肇 啓 ‧ 仰 叩 普 賢"
            ),
            Verse(
                number: 27,
                text: "and visualize incense and flowers as an offering to the Tamers of the ten directions. Wishing for",
                pinyin: "yuàn wáng yùn xiǎng xiāng huā gòng yǎng shí fāng tiáo yù yù yán",
                chinese: "願 王 ‧ 運 想 香 花 供 養 十 方 調 御 。 欲 嚴"
            ),
            Verse(
                number: 28,
                text: "a solemn and pure repentance altar, we first recite secret verses; praying for wholesome fruits to ripen, we must first cause the flowers of transgression to wilt. Prostrating to the Great Compassionate One, may he manifest a great spiritual response!",
                pinyin: "dà zhāng líng yìng qīng jìng zhī chàn tán xiān sòng mì mì zhī zhāng jù yào qí shàn guǒ yǐ zhōu lóng bì shǐ zuì huā ér diāo xiè yǎng kòu hóng cí",
                chinese: "大 彰 靈 應 清 淨 之 懺 壇 ‧ 先 誦 秘 密 之 章 句 。 要 祈 善 果 以 週 隆 ‧ 必 使 罪 花 而 彫 謝 。 仰 叩 洪 慈"
            )
        ]
        for verse in waterChapter2.verses {
            verse.chapter = waterChapter2
        }
        
        let waterChapter3 = Chapter(number: 3, title: "Entering Repentance")
        waterChapter3.text = waterRepentance
        waterChapter3.verses = [
            Verse(
                number: 1,
                text: "Respectfully listen! When one Buddha appears in the world, he opens the eighty-four thousand Dharma gates.",
                pinyin: "gōng wén yì fó chū shì kāi bā wàn sì qiān zhī fǎ mén",
                chinese: "恭 聞 ‧ 一 佛 出 世 ‧ 開 八 萬 四 千 之 法 門"
            ),
            Verse(
                number: 2,
                text: "When one moon abides in the sky, it dispels the darkness of the nine obscurities which cover the land.",
                pinyin: "yí yuè zài tiān pò dà dì jiǔ yōu zhī hūn àn",
                chinese: "一 月 在 天 ‧ 破 大 地 九 幽 之 昏 暗"
            ),
            Verse(
                number: 3,
                text: "Expanding the wondrous path of the One Vehicle and repenting all transgressions, we rely on and proclaim to the Seven Buddhas, World-Honored Ones.",
                pinyin: "kuò yí chèng zhī miào dào chàn yí qiè zhī qiān yóu yǎng qǐ qī fó shì zūn",
                chinese: "廓 一 乘 之 妙 道 ‧ 懺 一 切 之 愆 尤 。 仰 啓 七 佛 世 尊"
            ),
            Verse(
                number: 4,
                text: "Within this sanctuary, we and our fellow practitioners have burned incense, scattered flowers, kneeled, and joined our palms.",
                pinyin: "wǒ zhū xíng rén yú qí tán nèi shāo xiāng sàn huā hú guì hé zhǎng",
                chinese: "我 諸 行 人 ‧ 於 其 壇 內 ‧ 燒 香 散 花 ‧ 胡 跪 合 掌"
            ),
            Verse(
                number: 5,
                text: "We venerate the Triple Gem of the ten directions, seek refuge in the Golden Sage of Great Awakening, and sincerely confess [our transgressions].",
                pinyin: "dǐng lǐ shí fāng sān bǎo guī yī dà jué jīn xiān kěn qiè tóu chéng",
                chinese: "頂 禮 十 方 三 寶 ‧ 皈 依 大 覺 金 仙 。 懇 切 投 誠"
            ),
            Verse(
                number: 6,
                text: "We have purified our three karmas, and we are single-mindedly concentrated as we burn incense, scatter flowers, and repent and reform.",
                pinyin: "sān yè qīng jìng yì niàn jīng zhuān fā lù chàn huǐ",
                chinese: "三 業 清 淨 ‧ 一 念 精 專 。 發 露 懺 悔"
            ),
            Verse(
                number: 7,
                text: "We humbly think of how this assembly of your disciples was deluded to the one nature and thus drowned in the four kinds of birth.",
                pinyin: "fú niàn mǒu děng yí xìng chén mí gǔ mò yú sì shēng zhī nèi",
                chinese: "伏 念 某 等 ‧ 一 性 沈 迷 ‧ 汩 沒 於 四 生 之 內"
            ),
            Verse(
                number: 8,
                text: "Not realizing the one truth, we transmigrated in the six realms.",
                pinyin: "yì zhēn hūn mèi lún zhuǎn yú liù qù zhī zhōng",
                chinese: "一 眞 昏 昧 ‧ 輪 轉 於 六 趣 之 中"
            ),
            Verse(
                number: 9,
                text: "Through our body, speech, and mind, we were bound by desire, anger, and ignorance, thus committing various unwholesome deeds and creating limitless karmic obstacles.",
                pinyin: "yóu shì zì shēn kǒu yì zòng tān chēn chī miù zuò wàng wéi zào wú biān zhī yè zhàng",
                chinese: "由 是 恣 身 口 意 ‧ 縱 貪 瞋 癡 。 謬 作 妄 為 ‧ 造 無 邊 之 業 障"
            ),
            Verse(
                number: 10,
                text: "We followed falsity and evil, giving rise to many kinds of transgressions.",
                pinyin: "suí xié zhú è qǐ duō zhǒng zhī qiān yóu",
                chinese: "隨 邪 逐 惡 ‧ 起 多 種 之 愆 尤"
            ),
            Verse(
                number: 11,
                text: "Above and below the heavens, none resemble the Buddha; Throughout the ten directions, there are none who can compare.",
                pinyin: "tiān shàng tiān xià wú rú fó shí fāng shì jiè yì wú bǐ",
                chinese: "天 上 天 下 無 如 佛 ‧ 十 方 世 界 亦 無 比"
            ),
            Verse(
                number: 12,
                text: "In all that I have seen throughout the worlds, There is nobody who resembles the Buddha.",
                pinyin: "shì jiān suǒ yǒu wǒ jìn jiàn yí qiè wú yǒu rú fó zhě",
                chinese: "世 間 所 有 我 盡 見 ‧ 一 切 無 有 如 佛 者"
            ),
            Verse(
                number: 13,
                text: "Initiating and employing the Repentance-Dharma of the Kind and Compassionate Sanctuary of Awakening, single-mindedly, we seek refuge in the myriad buddhas of the three time periods!",
                pinyin: "qǐ yùn cí bēi dào chǎng chàn fǎ yì xīn guī mìng sān shì zhū fó",
                chinese: "啓 運 慈 悲 道 場 懺 法 ‧ 一 心 皈 命 三 世 諸 佛"
            ),
            Verse(
                number: 14,
                text: "Homage to the past Vipaśyin Buddha, Śikhin Buddha, Viśvabhū Buddha, Krakucchanda Buddha, Kanakamuni Buddha, Kāśyapa Buddha, our teacher Śākyamuni Buddha, and future descending-birth, honored Maitreya Buddha.",
                pinyin: "ná mó guò qù pí pó shī fó ná mó shī qì fó ná mó pí shě fú fó ná mó jū liú sūn fó ná mó jū nà hán móu ní fó ná mó jiā shè fó ná mó běn shī shì jiā móu ní fó ná mó dāng lái mí lè zūn fó",
                chinese: "南 無 過 去 毗 婆 尸 佛 南 無 尸 棄 佛 南 無 毗 舍 浮 佛 南 無 拘 留 孫 佛 南 無 拘 那 含 牟 尼 佛 南 無 迦 葉 佛 南 無 本 師 釋 迦 牟 尼 佛 南 無 當 來 彌 勒 尊 佛"
            ),
            Verse(
                number: 15,
                text: "Homage to Samantabhadra Bodhisattva-Mahāsattva!",
                pinyin: "▲ ná mó pǔ xián wáng pú sà mó hē sà (3x)",
                chinese: "南 無 普 賢 王 菩 薩 摩 訶 薩"
            ),
            Verse(
                number: 16,
                text: "There is a bodhisattva who sits in full lotus. His name is Samantabhadra,",
                pinyin: "yǒu yī pú sà jié jiā fū zuò míng yuē pǔ xián",
                chinese: "有 一 菩 薩 結 跏 趺 坐 名 曰 普 賢"
            ),
            Verse(
                number: 17,
                text: "and his body is the color of white jade. He emits fifty kinds of lights—lights in fifty colors—",
                pinyin: "shēn bái yù sè wǔ shí zhǒng guāng wǔ shí zhǒng sè",
                chinese: "身 白 玉 色 五 十 種 光 五 十 種 色"
            ),
            Verse(
                number: 18,
                text: "as an aura around his neck.",
                pinyin: "yǐ wéi xiàng guāng",
                chinese: "以 為 項 光"
            ),
            Verse(
                number: 19,
                text: "The pores on his body emit golden light.",
                pinyin: "shēn zhū máo kǒng liú chū jīn guāng",
                chinese: "身 諸 毛 孔 流 出 金 光"
            ),
            Verse(
                number: 20,
                text: "Within the rays of golden light are infinite manifested buddhas and manifested bodhisattvas",
                pinyin: "qí jīn guāng duān wú liàng huà fó zhū huà pú sà",
                chinese: "其 金 光 端 無 量 化 佛 諸 化 菩 薩"
            ),
            Verse(
                number: 21,
                text: "who form his retinue.",
                pinyin: "yǐ wéi juàn shǔ",
                chinese: "以 為 眷 屬"
            ),
            Verse(
                number: 22,
                text: "Walking with graceful and peaceful steps, large jeweled blossoms rain down",
                pinyin: "ān xiáng xú bù yǔ dà bǎo huā",
                chinese: "安 庠 徐 步 雨 大 寶 花"
            ),
            Verse(
                number: 23,
                text: "as he approaches the practitioner. His elephant opens its mouth, and atop the elephant's tusks",
                pinyin: "zhì xíng zhě qián qí xiàng kāi kǒu yú xiàng yá shàng",
                chinese: "至 行 者 前 其 象 開 口 於 象 牙 上"
            ),
            Verse(
                number: 24,
                text: "are ponds with jade goddesses drumming, dancing, strumming, and singing. The sounds [of the music] are subtle and wondrous.",
                pinyin: "zhū chí yù nǚ gǔ yuè xián gē qí shēng wéi miào",
                chinese: "諸 池 玉 女 鼓 樂 絃 歌 其 聲 微 妙"
            ),
            Verse(
                number: 25,
                text: "They praise the Mahāyāna, the Path of One Reality.",
                pinyin: "zàn tàn dà chèng yī shí zhī dào",
                chinese: "讚 嘆 大 乘 一 實 之 道"
            ),
            Verse(
                number: 26,
                text: "After the practitioner sees this, he is delighted and respectfully prostrates.",
                pinyin: "xíng zhě jiàn yǐ huān xǐ jìng lǐ",
                chinese: "行 者 見 已 歡 喜 敬 禮"
            ),
            Verse(
                number: 27,
                text: "Then, he recites the profound sūtras,",
                pinyin: "fù gèng dú sòng shèn shēn jīng diǎn",
                chinese: "復 更 讀 誦 甚 深 經 典"
            ),
            Verse(
                number: 28,
                text: "universally venerates the infinite manifested buddhas in the ten directions,",
                pinyin: "piàn lǐ shí fāng wú liàng zhū fó",
                chinese: "徧 禮 十 方 無 量 諸 佛"
            ),
            Verse(
                number: 29,
                text: "venerates Prabhūtaratna Buddha's stupa",
                pinyin: "lǐ duō bǎo fó tǎ",
                chinese: "禮 多 寶 佛 塔"
            ),
            Verse(
                number: 30,
                text: "and Śākyamuni [Buddha], as well as Samantabhadra. All great bodhisattvas",
                pinyin: "jí shì jiā móu ní bìng lǐ pǔ xián zhū dà pú sà",
                chinese: "及 釋 迦 牟 尼 并 禮 普 賢 諸 大 菩 薩"
            ),
            Verse(
                number: 31,
                text: "make this vow: If my past merits allow me to see Samantabhadra,",
                pinyin: "fā shì shì yuàn ruò wǒ sù fú yīng jiàn pǔ xián",
                chinese: "發 是 誓 願 若 我 宿 福 應 見 普 賢"
            ),
            Verse(
                number: 32,
                text: "then may the Honored Universal Auspiciousness manifest to me in a physical form!",
                pinyin: "yuàn zūn zhě piàn jí shì wǒ sè shēn",
                chinese: "願 尊 者 徧 吉 示 我 色 身"
            ),
            Verse(
                number: 33,
                text: "Homage to Samantabhadra Bodhisattva-Mahāsattva!",
                pinyin: "▲ ná mó pǔ xián wáng pú sà mó hē sà (3x)",
                chinese: "南 無 普 賢 王 菩 薩 摩 訶 薩"
            ),
            Verse(
                number: 34,
                text: "All be reverent and solemn!",
                pinyin: "● yí qiè gōng jìng",
                chinese: "一 切 恭 敬"
            ),
            Verse(
                number: 35,
                text: "Single-mindedly prostrate to the Eternally Abiding Buddhas in the Dharma realms of the ten directions!",
                pinyin: "● yì xīn dǐng lǐ shí fāng fǎ jiè cháng zhù fó",
                chinese: "一 心 頂 禮 ‧ 十 方 法 界 常 住 佛"
            ),
            Verse(
                number: 36,
                text: "Single-mindedly prostrate to the Eternally Abiding Dharma in the Dharma realms of the ten directions!",
                pinyin: "yì xīn dǐng lǐ shí fāng fǎ jiè cháng zhù fǎ",
                chinese: "一 心 頂 禮 ‧ 十 方 法 界 常 住 法"
            ),
            Verse(
                number: 37,
                text: "Single-mindedly prostrate to the Eternally Abiding Sangha in the Dharma realms of the ten directions!",
                pinyin: "yì xīn dǐng lǐ shí fāng fǎ jiè cháng zhù sēng",
                chinese: "一 心 頂 禮 ‧ 十 方 法 界 常 住 僧"
            ),
            Verse(
                number: 38,
                text: "Each in the assembly, all kneel down. Solemnly hold the incense and flowers and offer them in accordance with the Dharma.",
                pinyin: "● shì zhū zhòng děng gè gè hú guì yán chí xiāng huā rú fǎ gòng yǎng",
                chinese: "是 諸 衆 等 各 各 胡 跪 嚴 持 香 花 如 法 供 養"
            ),
            Verse(
                number: 39,
                text: "May these incense and flowers pervade the ten directions and become a subtle and wondrous platform of light;",
                pinyin: "● yuàn cǐ xiāng huā piàn shí fāng yǐ wéi wéi miào guāng míng tái",
                chinese: "願 此 香 花 徧 十 方 以 為 微 妙 光 明 臺"
            ),
            Verse(
                number: 40,
                text: "various kinds of celestial music, and precious celestial incenses;",
                pinyin: "zhū tiān yīn yuè tiān bǎo xiāng",
                chinese: "諸 天 音 樂 天 寶 香"
            ),
            Verse(
                number: 41,
                text: "various celestial delicacies, and precious celestial robes;",
                pinyin: "zhū tiān yáo shàn tiān bǎo yī",
                chinese: "諸 天 餚 饍 天 寶 衣"
            ),
            Verse(
                number: 42,
                text: "and inconceivable and wondrous dharma sense objects.",
                pinyin: "bù kě sī yì miào fǎ chén",
                chinese: "不 可 思 議 妙 法 塵"
            ),
            Verse(
                number: 43,
                text: "Each of these [six sense] objects manifests all sense objects;",
                pinyin: "yī yī chén chū yí qiè chén",
                chinese: "一 一 塵 出 一 切 塵"
            ),
            Verse(
                number: 44,
                text: "each of these [six sense] objects manifests all phenomena.",
                pinyin: "yī yī chén chū yí qiè fǎ",
                chinese: "一 一 塵 出 一 切 法"
            ),
            Verse(
                number: 45,
                text: "[These offerings] spin and adorn each other without obstruction, spreading and arriving before the Triple Gem of the ten directions.",
                pinyin: "xuán zhuǎn wú ài hù zhuāng yán piàn zhì shí fāng sān bǎo qián",
                chinese: "旋 轉 無 礙 互 莊 嚴 徧 至 十 方 三 寶 前"
            ),
            Verse(
                number: 46,
                text: "And before all of the Triple Gem in the Dharma Realms of the ten directions,",
                pinyin: "shí fāng fǎ jiè sān bǎo qián",
                chinese: "十 方 法 界 三 寶 前"
            ),
            Verse(
                number: 47,
                text: "my own body is making this offering, with each of my bodies appearing throughout Dharma realms.",
                pinyin: "xī yǒu wǒ shēn xiū gòng yǎng yī yī jiē xī piàn fǎ jiè",
                chinese: "悉 有 我 身 修 供 養 一 一 皆 悉 徧 法 界"
            ),
            Verse(
                number: 48,
                text: "[These offerings] do not interfere or obstruct each other, and until the limits of the future, they conduct the Buddha's work;",
                pinyin: "bǐ bǐ wú zá wú zhàng ài jǐn wèi lái jì zuò fó shì",
                chinese: "彼 彼 無 雜 無 障 礙 盡 未 來 際 作 佛 事"
            ),
            Verse(
                number: 49,
                text: "[their fragrance] universally permeates all sentient beings in the Dharma Realm,",
                pinyin: "pǔ xūn fǎ jiè zhū zhòng shēng",
                chinese: "普 熏 法 界 諸 衆 生"
            ),
            Verse(
                number: 50,
                text: "and those who are permeated [by its fragrance] all give rise to the bodhi mind and together enter the state of non-arising, awakening to the Buddha's wisdom!",
                pinyin: "méng xūn jiē fā pú tí xīn tóng rù wú shēng zhèng fó zhì",
                chinese: "蒙 熏 皆 發 菩 提 心 同 入 無 生 證 佛 智"
            ),
            Verse(
                number: 51,
                text: "May this cloud of incense and flowers fill the realms in the ten directions",
                pinyin: "● yuàn cǐ xiāng huā yún piàn mǎn shí fāng jiè",
                chinese: "願 此 香 花 雲 徧 滿 十 方 界"
            ),
            Verse(
                number: 52,
                text: "as an offering to all buddhas, the honored Dharma, all bodhisattvas,",
                pinyin: "gòng yǎng yí qiè fó zūn fǎ zhū pú sà",
                chinese: "供 養 一 切 佛 尊 法 諸 菩 薩"
            ),
            Verse(
                number: 53,
                text: "the assembly of pratyekabuddhas and śrāvakas, and to all heavenly sages.",
                pinyin: "wú biān shēng wén zhòng jí yí qiè tiān xiān",
                chinese: "無 邊 聲 聞 衆 及 一 切 天 仙"
            ),
            Verse(
                number: 54,
                text: "It establishes a platform of light which is larger than the boundless realms,",
                pinyin: "yǐ qǐ guāng míng tái guò yú wú biān jiè",
                chinese: "以 起 光 明 臺 過 於 無 邊 界"
            ),
            Verse(
                number: 55,
                text: "and in the boundless buddha-lands, it is accepted and used for the Buddha's work,",
                pinyin: "wú biān fó tǔ zhōng shòu yong zuò fó shì",
                chinese: "無 邊 佛 土 中 受 用 作 佛 事"
            ),
            Verse(
                number: 56,
                text: "universally permeating sentient beings so that all give rise to the bodhi mind.",
                pinyin: "pǔ xūn zhū zhòng shēng jiē fā pú tí xīn",
                chinese: "普 熏 諸 衆 生 皆 發 菩 提 心"
            ),
            Verse(
                number: 57,
                text: "His face and appearance are truly wondrous; his radiance illuminates the ten directions.",
                pinyin: "● róng yán shèn qí miào guāng míng zhào shí fāng",
                chinese: "容 顏 甚 奇 妙 光 明 照 十 方"
            ),
            Verse(
                number: 58,
                text: "We have made such offerings before, and now draw near again.",
                pinyin: "wǒ shì céng gòng yǎng jīn fù huán qīn jìn",
                chinese: "我 適 曾 供 養 今 復 還 親 近"
            ),
            Verse(
                number: 59,
                text: "To the sacred lord, king among gods, whose voice resembles that of a kalaviṅka,",
                pinyin: "shèng zhǔ tiān zhōng wáng jiā líng pín qié shēng",
                chinese: "聖 主 天 中 王 迦 陵 頻 伽 聲"
            ),
            Verse(
                number: 60,
                text: "who empathizes with sentient beings, we now respectfully prostrate!",
                pinyin: "āi mǐn zhòng shēng zhě wǒ děng jīn jìng lǐ",
                chinese: "哀 愍 衆 生 者 我 等 今 敬 禮"
            ),
            Verse(
                number: 61,
                text: "Homage to Precious Uḍumbara Blossom Bodhisattva-Mahāsattva!",
                pinyin: "▲ ná mó bǎo tán huá pú sà mó hē sà (3x)",
                chinese: "南 無 寶 曇 華 菩 薩 摩 訶 薩"
            ),
            Verse(
                number: 62,
                text: "Prayer of Entering Repentance, Scroll One",
                pinyin: "● rù chàn wén",
                chinese: "入 懺 文"
            ),
            Verse(
                number: 63,
                text: "Respectfully listen! When one Buddha appears in the world, he opens the eighty-four thousand Dharma gates;",
                pinyin: "gōng wén yì fó chū shì kāi bā wàn sì qiān zhī fǎ mén",
                chinese: "恭 聞 ‧ 一 佛 出 世 ‧ 開 八 萬 四 千 之 法 門"
            ),
            Verse(
                number: 64,
                text: "when one moon abides in the sky, it dispels the darkness of the nine obscurities which cover the land.",
                pinyin: "yí yuè zài tiān pò dà dì jiǔ yōu zhī hūn àn",
                chinese: "一 月 在 天 ‧ 破 大 地 九 幽 之 昏 暗"
            ),
            Verse(
                number: 65,
                text: "Expanding the wondrous path of the One Vehicle and repenting all transgressions,",
                pinyin: "kuò yí chèng zhī miào dào chàn yí qiè zhī qiān yóu",
                chinese: "廓 一 乘 之 妙 道 ‧ 懺 一 切 之 愆 尤"
            ),
            Verse(
                number: 66,
                text: "we rely on and proclaim to the Seven Buddhas, World-Honored Ones: may the compassionate fathers of the ten directions who possess serene marks, characteristics, and radiance, witness our sincerity!",
                pinyin: "yǎng qǐ qī fó shì zūn shí fāng cí fù shū háo xiàng guāng jiàn zī qián kěn",
                chinese: "仰 啓 七 佛 世 尊 ‧ 十 方 慈 父 ‧ 舒 毫 相 光 ‧ 鑑 茲 虔 懇"
            ),
            Verse(
                number: 67,
                text: "Now, on behalf of this assembly of your disciples who seek repentance, we respectfully face the base of your golden lotus throne and practice the Water Repentance Dharma Gate.",
                pinyin: "jīn zé fèng wéi qiú chàn mǒu děng gōng duì jīn lián zuò xià xūn xiū shuǐ chàn fǎ mén",
                chinese: "今 則 奉 為 求 懺 某 等 ‧ 恭 對 金 蓮 座 下 ‧ 熏 修 水 懺 法 門"
            ),
            Verse(
                number: 68,
                text: "Now, we begin the first scroll by entering the sanctuary.",
                pinyin: "jīn dāng dì yī juàn rù tán yuán qǐ",
                chinese: "今 當 第 一 卷 ‧ 入 壇 緣 起"
            ),
            Verse(
                number: 69,
                text: "Within this sanctuary, we and our fellow practitioners have burned incense, scattered flowers, kneeled, and joined our palms.",
                pinyin: "wǒ zhū xíng rén yú qí tán nèi shāo xiāng sàn huā hú guì hé zhǎng",
                chinese: "我 諸 行 人 ‧ 於 其 壇 內 ‧ 燒 香 散 花 ‧ 胡 跪 合 掌"
            ),
            Verse(
                number: 70,
                text: "We venerate the Triple Gem of the ten directions, seek refuge in the Golden Sage of Great Awakening, and sincerely confess [our transgressions].",
                pinyin: "dǐng lǐ shí fāng sān bǎo guī yī dà jué jīn xiān kěn qiè tóu chéng fā lù chàn huǐ",
                chinese: "頂 禮 十 方 三 寶 ‧ 皈 依 大 覺 金 仙 。 懇 切 投 誠 ‧ 發 露 懺 悔"
            ),
            Verse(
                number: 71,
                text: "We humbly think of how this assembly of your disciples was deluded to the one nature and thus drowned in the four kinds of birth.",
                pinyin: "fú niàn mǒu děng yí xìng chén mí gǔ mò yú sì shēng zhī nèi",
                chinese: "伏 念 某 等 ‧ 一 性 沈 迷 ‧ 汩 沒 於 四 生 之 內"
            ),
            Verse(
                number: 72,
                text: "Not realizing the one truth, we transmigrated in the six realms.",
                pinyin: "yì zhēn hūn mèi lún zhuǎn yú liù qù zhī zhōng",
                chinese: "一 眞 昏 昧 ‧ 輪 轉 於 六 趣 之 中"
            ),
            Verse(
                number: 73,
                text: "Through our body, speech, and mind, we were bound by desire, anger, and ignorance, thus committing various unwholesome deeds and creating limitless karmic obstacles.",
                pinyin: "yóu shì zì shēn kǒu yì zòng tān chēn chī miù zuò wàng wéi zào wú biān zhī yè zhàng",
                chinese: "由 是 恣 身 口 意 ‧ 縱 貪 瞋 癡 。 謬 作 妄 為 ‧ 造 無 邊 之 業 障"
            ),
            Verse(
                number: 74,
                text: "We followed falsity and evil, giving rise to many kinds of transgressions.",
                pinyin: "suí xié zhú è qǐ duō zhǒng zhī qiān yóu",
                chinese: "隨 邪 逐 惡 ‧ 起 多 種 之 愆 尤"
            ),
            Verse(
                number: 75,
                text: "Thus, the Tathāgata proclaimed a teaching of expedient means. We now sincerely repent and reform by relying on the pure assembly and reciting this efficacious text to cleanse our transgressions and adorn ourselves with pure precepts.",
                pinyin: "gù rú lái qǐ fāng biàn zhī jiào mén rán wǒ děng tóu chéng ér chàn huǐ yǎng píng qīng zhòng pī sòng líng wén xǐ dí qiān yóu zī yán jìng jiè",
                chinese: "故 如 來 啓 方 便 之 教 門 ‧ 然 我 等 投 誠 而 懺 悔 。 仰 憑 清 衆 ‧ 披 誦 靈 文 ‧ 洗 滌 愆 尤 ‧ 資 嚴 淨 戒"
            ),
            Verse(
                number: 76,
                text: "These are our vows and the Buddha will surely empathize with us. We sincerely prostrate to the One of Great Compassion, invisibly imbuing us with supportive aid!",
                pinyin: "wǒ yuàn rú sī fó bì āi lián kěn kòu hóng cí míng xūn jiā bèi",
                chinese: "我 願 如 斯 ‧ 佛 必 哀 憐 ‧ 懇 叩 洪 慈 ‧ 冥 熏 加 被"
            ),
            Verse(
                number: 77,
                text: "Homage to our teacher, Śākyamuni Buddha!",
                pinyin: "▲ ná mó běn shī shì jiā móu ní fó (3x)",
                chinese: "南 無 本 師 釋 迦 牟 尼 佛"
            ),
            Verse(
                number: 78,
                text: "The unsurpassed, profound, and subtly wondrous Dharma, Is difficult to encounter in hundreds of thousands of myriad kalpas.",
                pinyin: "wú shàng shèn shēn wéi miào fǎ bǎi qiān wàn jié nán zāo yù",
                chinese: "無 上 甚 深 微 妙 法 ‧ 百 千 萬 劫 難 遭 遇"
            ),
            Verse(
                number: 79,
                text: "Today we see, hear, receive, and uphold it, Vowing to understand the Tathāgata's true meaning!",
                pinyin: "wǒ jīn jiàn wén dé shòu chí yuàn jiě rú lái zhēn shí yì",
                chinese: "我 今 見 聞 得 受 持 ‧ 願 解 如 來 眞 實 義"
            ),
            Verse(
                number: 80,
                text: "Water Repentance of Kindness and Compassion – Scroll One",
                pinyin: "● cí bēi shuǐ chàn fǎ juàn shàng",
                chinese: "慈 悲 水 懺 法 卷 上"
            ),
            Verse(
                number: 81,
                text: "All buddhas are compassionately mindful of sentient beings and teach the Compiled Method of the Water Repentance Sanctuary of Awakening on our behalf.",
                pinyin: "yí qiè zhū fó mǐn niàn zhòng shēng wèi shuō shuǐ chàn dào chǎng zǒng fǎ",
                chinese: "一 切 諸 佛 ‧ 愍 念 衆 生 ‧ 為 說 水 懺 道 場 總 法"
            ),
            Verse(
                number: 82,
                text: "Because the defilements of sentient beings are heavy, who is without transgression? Who is without affliction?",
                pinyin: "liáng yǐ zhòng shēng gòu zhòng hé rén wú zuì hé zhě wú qiān",
                chinese: "良 以 衆 生 垢 重 ‧ 何 人 無 罪 ‧ 何 者 無 愆"
            ),
            Verse(
                number: 83,
                text: "The ignorant practices of us unenlightened beings are concealed by our own lack of wisdom.",
                pinyin: "fán fū yú xíng wú míng àn fù",
                chinese: "凡 夫 愚 行 ‧ 無 明 闇 覆"
            ),
            Verse(
                number: 84,
                text: "We associated with evil friends, our minds were afflicted and disturbed,",
                pinyin: "qīn jìn è yǒu fán nǎo luàn xīn",
                chinese: "親 近 惡 友 ‧ 煩 惱 亂 心"
            ),
            Verse(
                number: 85,
                text: "we gave rise to [self-]nature without knowing, and we were lax and arrogant.",
                pinyin: "lì xìng wú zhī zì xīn zì shì",
                chinese: "立 性 無 知 ‧ 恣 心 自 恃"
            ),
            Verse(
                number: 86,
                text: "We did not have faith in the buddhas of the ten directions, nor did we have faith in the honored Dharma or the sacred Sangha.",
                pinyin: "bù xìn shí fāng zhū fó bù xìn zūn fǎ shèng sēng",
                chinese: "不 信 十 方 諸 佛 ‧ 不 信 尊 法 聖 僧"
            ),
            Verse(
                number: 87,
                text: "We were not filial to our parents and six kinds of relatives.",
                pinyin: "bù xiào fù mǔ liù qīn juàn shǔ",
                chinese: "不 孝 父 母 ‧ 六 親 眷 屬"
            ),
            Verse(
                number: 88,
                text: "At the prime of our lives, we were lax and arrogant.",
                pinyin: "shèng nián fang yì yǐ zì jiāo jù",
                chinese: "盛 年 放 逸 ‧ 以 自 憍 倨"
            ),
            Verse(
                number: 89,
                text: "We desired all wealth and treasures, desired all musical entertainment, and desired all sexual pleasures.",
                pinyin: "yú yí qiè cái bǎo yí qiè gē yuè yí qiè nǚ sè",
                chinese: "於 一 切 財 寶 ‧ 一 切 歌 樂 ‧ 一 切 女 色"
            ),
            Verse(
                number: 90,
                text: "Our minds gave rise to desire, and our thoughts gave rise to afflictions.",
                pinyin: "xīn shēng tān liàn yì qǐ fán nǎo",
                chinese: "心 生 貪 戀 ‧ 意 起 煩 惱"
            ),
            Verse(
                number: 91,
                text: "We associated with unvirtuous people and lusted for evil friends without knowing to repent and reform.",
                pinyin: "qīn jìn fēi shèng xiè xiá è yǒu bù zhī quān gé",
                chinese: "親 近 非 聖 ‧ 媟 狎 惡 友 ‧ 不 知 悛 革"
            ),
            Verse(
                number: 92,
                text: "Or, we killed all sentient beings,",
                pinyin: "huò fù shā hài yí qiè zhòng shēng",
                chinese: "或 復 殺 害 一 切 衆 生"
            ),
            Verse(
                number: 93,
                text: "or we consumed intoxicants and became deluded.",
                pinyin: "huò yǐn jiǔ hūn mí",
                chinese: "或 飲 酒 昏 迷"
            ),
            Verse(
                number: 94,
                text: "Lacking a mind of wisdom, we always opposed sentient beings and violated the precepts.",
                pinyin: "wú zhì huì xīn héng yǔ zhòng shēng zào nì pò jiè",
                chinese: "無 智 慧 心 。 恆 與 衆 生 ‧ 造 逆 破 戒"
            ),
            Verse(
                number: 95,
                text: "Today, we sincerely repent and reform for each and every one of these past offenses as well as the evils we are currently conducting.",
                pinyin: "guò qù zhū zuì xian zài zhòng è jīn rì zhì chéng xī jiē chàn huǐ",
                chinese: "過 去 諸 罪 ‧ 現 在 衆 惡 ‧ 今 日 至 誠 ‧ 悉 皆 懺 悔"
            ),
            Verse(
                number: 96,
                text: "Today, we sincerely repent and reform for all of these, not daring to commit any future transgressions.",
                pinyin: "wèi zuò zhī zuì bù gǎn gèng zuò",
                chinese: "未 作 之 罪 ‧ 不 敢 更 作"
            ),
            Verse(
                number: 97,
                text: "Today, your disciples in the assembly sincerely seek refuge in all buddhas of the ten directions, throughout the realms of empty space;",
                pinyin: "shì gù jīn rì zhì xīn guī yī shí fāng jǐn xū kōng jiè yí qiè zhū fó",
                chinese: "是 故 今 日 ‧ 至 心 皈 依 ‧ 十 方 盡 虛 空 界 ‧ 一 切 諸 佛"
            ),
            Verse(
                number: 98,
                text: "the great bodhisattvas, pratyekabuddhas, arhats, and those of the Four Fruitions and Four Progressions;",
                pinyin: "zhū dà pú sà pì zhī luó hàn",
                chinese: "諸 大 菩 薩 ‧ 辟 支 羅 漢"
            ),
            Verse(
                number: 99,
                text: "King Brāhma and Emperor Śakra; the Eightfold Division of Devas and Nagas; and the entirety of the sacred assembly, praying for their presence and witness!",
                pinyin: "fàn wáng dì shì tiān lóng bā bù yí qiè shèng zhòng yuàn chuí zhèng jiàn",
                chinese: "梵 王 帝 釋 ‧ 天 龍 八 部 ‧ 一 切 聖 衆 ‧ 願 垂 證 鑑"
            ),
            Verse(
                number: 100,
                text: "Homage to Vairocana Buddha",
                pinyin: "ná mó pí lú zhē nà fó",
                chinese: "南 無 毗 盧 遮 那 佛"
            ),
            Verse(
                number: 101,
                text: "Homage to our teacher Śākyamuni Buddha",
                pinyin: "ná mó běn shī shì jiā móu ní fó",
                chinese: "南 無 本 師 釋 迦 牟 尼 佛"
            ),
            Verse(
                number: 102,
                text: "Homage to Amitābha Buddha",
                pinyin: "ná mó ē mí tuó fó",
                chinese: "南 無 阿 彌 陀 佛"
            ),
            Verse(
                number: 103,
                text: "Homage to Maitreya Buddha",
                pinyin: "ná mó mí lè fó",
                chinese: "南 無 彌 勒 佛"
            ),
            Verse(
                number: 104,
                text: "Homage to Nāgagotrodārajñānarāja Buddha",
                pinyin: "ná mó lóng zhǒng shàng zūn wáng fó",
                chinese: "南 無 龍 種 上 尊 王 佛"
            ),
            Verse(
                number: 105,
                text: "Homage to Nāgeśvararāja Buddha",
                pinyin: "ná mó lóng zì zài wáng fó",
                chinese: "南 無 龍 自 在 王 佛"
            ),
            Verse(
                number: 106,
                text: "Homage to Prabhūtaratna Buddha",
                pinyin: "ná mó bǎo shèng fó",
                chinese: "南 無 寶 勝 佛"
            ),
            Verse(
                number: 107,
                text: "Homage to Buddhapuṇḍarīkadhyaneśvararāja Buddha",
                pinyin: "ná mó jué huá dìng zì zài wáng fó",
                chinese: "南 無 覺 華 定 自 在 王 佛"
            ),
            Verse(
                number: 108,
                text: "Homage to Kasayadhvaja Buddha",
                pinyin: "ná mó jiā shā chuáng fó",
                chinese: "南 無 袈 裟 幢 佛"
            ),
            Verse(
                number: 109,
                text: "Homage to Siṃhanāda Buddha",
                pinyin: "ná mó shī zi hǒu fó",
                chinese: "南 無 師 子 吼 佛"
            ),
            Verse(
                number: 110,
                text: "Homage to Mañjuśrī Bodhisattva",
                pinyin: "ná mó wén shū shī lì pú sà",
                chinese: "南 無 文 殊 師 利 菩 薩"
            ),
            Verse(
                number: 111,
                text: "Homage to Samantabhadra Bodhisattva",
                pinyin: "ná mó pǔ xián pú sà",
                chinese: "南 無 普 賢 菩 薩"
            ),
            Verse(
                number: 112,
                text: "Homage to Mahāsthāmaprāpta Bodhisattva",
                pinyin: "ná mó dà shì zhì pú sà",
                chinese: "南 無 大 勢 至 菩 薩"
            ),
            Verse(
                number: 113,
                text: "Homage to Kṣitigarbha Bodhisattva",
                pinyin: "ná mó dì zàng pú sà",
                chinese: "南 無 地 藏 菩 薩"
            ),
            Verse(
                number: 114,
                text: "Homage to Mahāvyūha Bodhisattva",
                pinyin: "ná mó dà zhuāng yán pú sà",
                chinese: "南 無 大 莊 嚴 菩 薩"
            ),
            Verse(
                number: 115,
                text: "Homage to Avalokiteśvara Bodhisattva",
                pinyin: "ná mó guān zì zài pú sà",
                chinese: "南 無 觀 自 在 菩 薩"
            ),
            Verse(
                number: 116,
                text: "Having prostrated to the buddhas, again, repent and reform.",
                pinyin: "● lǐ zhū fó yǐ cì fù chàn huǐ",
                chinese: "禮 諸 佛 已 ‧ 次 復 懺 悔"
            ),
            Verse(
                number: 117,
                text: "When one wishes to repent, it is necessary to first venerate the Triple Gem.",
                pinyin: "fú yù lǐ chàn bì xū xiān jìng sān bǎo",
                chinese: "夫 欲 禮 懺 ‧ 必 須 先 敬 三 寶"
            ),
            Verse(
                number: 118,
                text: "This is because the Triple Gem is a virtuous friend and field of merit for all sentient beings.",
                pinyin: "suǒ yǐ rán zhě sān bǎo jí shì yí qiè zhòng shēng liáng yǒu fú tián",
                chinese: "所 以 然 者 。 三 寶 卽 是 一 切 衆 生 ‧ 良 友 福 田"
            ),
            Verse(
                number: 119,
                text: "If one can seek refuge in it, then one can eradicate limitless transgressions and gain limitless blessings.",
                pinyin: "ruò néng guī xiàng zhě zé miè wú liàng zuì zhǎng wú liàng fú",
                chinese: "若 能 歸 向 者 ‧ 則 滅 無 量 罪 ‧ 長 無 量 福"
            ),
            Verse(
                number: 120,
                text: "It can cause the practitioner to be free from the suffering of birth and death and obtain the joy of liberation.",
                pinyin: "néng lìng xíng zhě lí shēng sǐ kǔ dé jiě tuō lè",
                chinese: "能 令 行 者 ‧ 離 生 死 苦 ‧ 得 解 脫 樂"
            ),
            Verse(
                number: 121,
                text: "Thus, your disciples in the assembly seek refuge in all Buddhas of the ten directions, throughout the realms of empty space;",
                pinyin: "shì gù guī yī shí fāng jìn xū kōng jiè yí qiè zhū fó",
                chinese: "是 故 皈 依 十 方 盡 虛 空 界 ‧ 一 切 諸 佛"
            ),
            Verse(
                number: 122,
                text: "seek refuge in all honored Dharmas of the ten directions, throughout the realms of empty space;",
                pinyin: "guī yī shí fāng jìn xū kōng jiè yí qiè zūn fǎ",
                chinese: "皈 依 十 方 盡 虛 空 界 ‧ 一 切 尊 法"
            ),
            Verse(
                number: 123,
                text: "and seek refuge in all sacred Sanghas of the ten directions, throughout the realms of empty space!",
                pinyin: "guī yī shí fāng jìn xū kōng jiè yí qiè shèng sēng",
                chinese: "皈 依 十 方 盡 虛 空 界 ‧ 一 切 聖 僧"
            )
        ]
        for verse in waterChapter3.verses {
            verse.chapter = waterChapter3
        }
        
        let waterChapter4 = Chapter(number: 4, title: "The Seven Kinds of Mind")
        waterChapter4.text = waterRepentance
        waterChapter4.verses = [
            Verse(
                number: 1,
                text: "Today, we, your disciples, are repenting and reforming precisely because since beginningless time, we have been at the stage of ordinary beings.",
                pinyin: "zhòng děng jīn rì suǒ yǐ chàn huǐ zhě zhèng wéi wú shǐ yǐ lái zài fán fū dì",
                chinese: "某 等 今 日 所 以 懺 悔 者 ‧ 正 為 無 始 以 來 ‧ 在 凡 夫 地"
            ),
            Verse(
                number: 2,
                text: "Regardless of class and status, our offenses are limitless.",
                pinyin: "mò wèn guì jiàn zuì xiàng wú liàng",
                chinese: "莫 問 貴 賤 ‧ 罪 相 無 量"
            ),
            Verse(
                number: 3,
                text: "Whether these offenses were born from our Three Karmas or rose from our Six Faculties;",
                pinyin: "huò yīn sān yè ér shēng zuì huò cóng liù gēn ér qǐ guò",
                chinese: "或 因 三 業 而 生 罪 ‧ 或 從 六 根 而 起 過"
            ),
            Verse(
                number: 4,
                text: "whether these were internal—born of our deviant thoughts, or external—created from various defilements;",
                pinyin: "huò yǐ nèi xīn zì xié sī wéi huò jiè wài jìng qǐ zhū rǎn zhuó",
                chinese: "或 以 內 心 自 邪 思 惟 ‧ 或 藉 外 境 ‧ 起 諸 染 著"
            ),
            Verse(
                number: 5,
                text: "the Ten Unwholesome Deeds grew in this way to become the Eighty-Four Thousand Gates of Affliction.",
                pinyin: "rú shì nǎi zhì shí è zēng zhǎng bā wàn sì qiān zhū chén láo mén",
                chinese: "如 是 乃 至 十 惡 ‧ 增 長 八 萬 四 千 諸 塵 勞 門"
            ),
            Verse(
                number: 6,
                text: "Though these offenses are limitless, described in general, they fall under three categories without exception.",
                pinyin: "rán qí zuì xiàng suī fù wú liàng dà ér wéi yǔ bù chū yǒu sān",
                chinese: "然 其 罪 相 ‧ 雖 復 無 量 ‧ 大 而 為 語 ‧ 不 出 有 三"
            ),
            Verse(
                number: 7,
                text: "First are afflictions, second is karma, and third is result.",
                pinyin: "yī zhě fán nǎo èr zhě shì yè sān zhě guǒ bào",
                chinese: "一 者 煩 惱 ‧ 二 者 是 業 ‧ 三 者 果 報"
            ),
            Verse(
                number: 8,
                text: "These three phenomena can obstruct the sagely path and the wondrous affairs among humans and devas.",
                pinyin: "cǐ sān zhǒng fǎ néng zhàng shèng dào jí yǐ rén tiān shèng miào hǎo shì",
                chinese: "此 三 種 法 ‧ 能 障 聖 道 ‧ 及 以 人 天 勝 妙 好 事"
            ),
            Verse(
                number: 9,
                text: "Therefore, the sūtras catalog these as the Three Obstructions.",
                pinyin: "shì gù jīng zhōng mù wèi sān zhàng",
                chinese: "是 故 經 中 ‧ 目 為 三 障"
            ),
            Verse(
                number: 10,
                text: "Thus, the buddhas and bodhisattvas teach the expedient means of repentance and reformation",
                pinyin: "suǒ yǐ zhū fó pú sà jiào zuò fāng biàn chàn huǐ chú miè",
                chinese: "所 以 諸 佛 菩 薩 ‧ 教 作 方 便 ‧ 懺 悔 除 滅"
            ),
            Verse(
                number: 11,
                text: "to eradicate these Three Obstructions and cause the Six Faculties, Ten Unwholesome Deeds, and even the Eighty-Four Thousand Gates of Affliction to all be pure.",
                pinyin: "cǐ sān zhàng miè zé liù gēn shí è nǎi zhì bā wàn sì qiān zhū chén láo mén jiē xī qīng jìng",
                chinese: "此 三 障 滅 ‧ 則 六 根 十 惡 ‧ 乃 至 八 萬 四 千 諸 塵 勞 門 ‧ 皆 悉 清 淨"
            ),
            Verse(
                number: 12,
                text: "Therefore, your disciples in the assembly repent and reform for the Three Obstructions today with the supreme mind of improvement.",
                pinyin: "shì gù zhòng děng jīn rì yùn cǐ zēng shàng shèng xīn chàn huǐ sān zhàng",
                chinese: "是 故 某 等 ‧ 今 日 運 此 增 上 勝 心 ‧ 懺 悔 三 障"
            ),
            Verse(
                number: 13,
                text: "For those who wish to eradicate the Three Obstructions, what kind of mindset should one use that can cause these obstructions to be eradicated?",
                pinyin: "yù miè sān zhàng zhě dāng yòng hé děng xīn kě lìng cǐ zhàng miè chú",
                chinese: "欲 滅 三 障 者 ‧ 當 用 何 等 心 ‧ 可 令 此 障 滅 除"
            ),
            Verse(
                number: 14,
                text: "First, one should give rise to the Seven Kinds of Mind as expedient means.",
                pinyin: "xiān dāng xīng qī zhǒng xīn yǐ wéi fāng biàn",
                chinese: "先 當 興 七 種 心 ‧ 以 為 方 便"
            ),
            Verse(
                number: 15,
                text: "Then these obstructions can be eradicated.",
                pinyin: "rán hòu cǐ zhàng nǎi kě dé miè",
                chinese: "然 後 此 障 ‧ 乃 可 得 滅"
            ),
            Verse(
                number: 16,
                text: "What are these seven?",
                pinyin: "hé děng wéi qī",
                chinese: "何 等 為 七"
            ),
            Verse(
                number: 17,
                text: "First is remorse and shame, second is fear, third is dispassion, fourth is to give rise to the bodhi mind, fifth is seeing friends and foes as equal, six is be mindful of and repay the Buddha's kindness, and seventh is contemplating the empty nature of transgressions.",
                pinyin: "yī zhě cán kuì èr zhě kǒng bù sān zhě yàn lí sì zhě fā pú tí xīn wǔ zhě yuàn qīn píng děng liù zhě niàn bào fó ēn qī zhě guān zuì xìng kōng",
                chinese: "一 者 慚 愧 ‧ 二 者 恐 怖 ‧ 三 者 厭 離 ‧ 四 者 發 菩 提 心 ‧ 五 者 怨 親 平 等 ‧ 六 者 念 報 佛 恩 ‧ 七 者 觀 罪 性 空"
            ),
            Verse(
                number: 18,
                text: "Regarding the first mind of remorse and shame, one should think: Śākyamuṇi Tathāgata and I were both originally ordinary beings,",
                pinyin: "dì yī cán kuì zhě zì wéi wǒ yǔ shì jiā rú lái tóng wèi fán fū",
                chinese: "第 一 慚 愧 者 。 自 惟 我 與 釋 迦 如 來 同 為 凡 夫"
            ),
            Verse(
                number: 19,
                text: "but the World-Honored One has attained awakening for innumerable kalpas numbering grains of dust and sand",
                pinyin: "ér jīn shì zūn chéng dào yǐ lái yǐ jīng ěr suǒ chén shā jié shù",
                chinese: "而 今 世 尊 成 道 以 來 ‧ 已 經 爾 所 塵 沙 劫 數"
            ),
            Verse(
                number: 20,
                text: "while we still indulge in the defilements of the Six Dusts and eternally tumble in the cycle of birth and death without any end in sight.",
                pinyin: "ér wǒ děng xiāng yǔ dān rǎn liù chén yǒng wú lún zhuǎn shēng sǐ wú chū qí",
                chinese: "而 我 等 相 與 耽 染 六 塵 ‧ 輪 轉 生 死 ‧ 永 無 出 期"
            ),
            Verse(
                number: 21,
                text: "This is truly a matter in this world which is remorseful, shameful, embarrassing, and disgraceful.",
                pinyin: "cǐ shí tiān xià kě cán kě kuì kě xiū kě chǐ",
                chinese: "此 實 天 下 ‧ 可 慚 可 愧 ‧ 可 羞 可 恥"
            ),
            Verse(
                number: 22,
                text: "Regarding the second mind of fear, the physical, verbal, and mental karma of ordinary beings is always resonating with offenses.",
                pinyin: "dì èr kǒng bù zhě jì shì fán fū shēn kǒu yì yè cháng yǔ zuì xiāng yìng",
                chinese: "第 二 恐 怖 者 。 既 是 凡 夫 ‧ 身 口 意 業 ‧ 常 與 罪 相 應"
            ),
            Verse(
                number: 23,
                text: "Through these causes and conditions, at the end of our lives, we should descend into the realms of hell, animals, and hungry ghosts to endure limitless suffering.",
                pinyin: "yǐ shì yīn yuán mìng zhōng zhī hòu yīng duò dì yù chù shēng è guǐ shòu wú liàng kǔ",
                chinese: "以 是 因 緣 ‧ 命 終 之 後 ‧ 應 墮 地 獄 ‧ 畜 生 餓 鬼 ‧ 受 無 量 苦"
            ),
            Verse(
                number: 24,
                text: "This is truly startling, frightening, terrifying, and fearsome.",
                pinyin: "rú cǐ shí wèi kě jīng kě kǒng kě bù kě jù",
                chinese: "如 此 實 為 可 驚 可 恐 ‧ 可 怖 可 懼"
            ),
            Verse(
                number: 25,
                text: "Regarding the third mind of dispassion, we should always observe that within birth and death, there is only impermanence, suffering, emptiness, non-self, impurities, and false forms which resemble bubbles in the water—suddenly appearing and suddenly disappearing.",
                pinyin: "dì sān yàn lí zhě xiāng yǔ cháng guān shēng sǐ zhī zhōng wéi yǒu wú cháng kǔ kōng wú wǒ bú jìng xū jiǎ rú shuǐ shàng pào sù qǐ sù miè",
                chinese: "第 三 厭 離 者 。 相 與 常 觀 ‧ 生 死 之 中 惟 有 無 常 苦 空 無 我 ‧ 不 淨 虛 假 。 如 水 上 泡 ‧ 速 起 速 滅"
            ),
            Verse(
                number: 26,
                text: "Since the distant past, we have cycled through [birth and death] like a cart's wheel, undergoing birth, old age, sickness, and death and the burns of the Eight Sufferings without any moment of pause.",
                pinyin: "wǎng lái liú zhuǎn yóu rú chē lún shēng lǎo bìng sǐ bā kǔ jiāo jiān wú shí zàn xí",
                chinese: "往 來 流 轉 ‧ 猶 如 車 輪 。 生 老 病 死 ‧ 八 苦 交 煎 ‧ 無 時 暫 息"
            ),
            Verse(
                number: 27,
                text: "We, the assembly, only see our bodies—from head to toe—as only having thirty-six parts:",
                pinyin: "zhòng děng xiāng yǔ dàn guān zì shēn cóng tóu zhì zú qí zhōng dàn yǒu sān shí liù wù",
                chinese: "衆 等 相 與 ‧ 但 觀 自 身 ‧ 從 頭 至 足 ‧ 其 中 但 有 三 十 六 物"
            ),
            Verse(
                number: 28,
                text: "head hair, body hair, nails, teeth, eye crust, tears, saliva, filth, sweat, urine, feces, skin, tissue, blood, flesh, tendons, veins & arteries, bone, marrow, fat, grease, brain, membrane, kidneys, heart, lung, liver, large intestine, small intestine, red phlegm, white phlegm, stomach, and bowels.",
                pinyin: "fǎ máo zhuǎ chǐ chī lèi tì tuò gòu hàn èr biàn pí fū xiě ròu jīn mài gǔ suǐ fáng gāo nǎo mó pí shèn xīn fèi gān dǎn cháng wèi chì bái tán yìn shēng shú èr zàng",
                chinese: "髮 毛 爪 齒 ‧ 眵 淚 涕 唾 ‧ 垢 汗 二 便 ‧ 皮 膚 血 肉 ‧ 筋 脈 骨 髓 ‧ 肪 膏 腦 膜 ‧ 脾 腎 心 肺 ‧ 肝 膽 腸 胃 ‧ 赤 白 痰 癊 ‧ 生 熟 二 臟"
            ),
            Verse(
                number: 29,
                text: "In this way, the Nine Orifices constantly flow.",
                pinyin: "rú shì jiǔ kǒng cháng liú",
                chinese: "如 是 九 孔 常 流"
            ),
            Verse(
                number: 30,
                text: "Thus, the sūtras state that this body is formed through a collection of sufferings and all of it is impure.",
                pinyin: "shì gù jīng yán cǐ shēn zhòng kǔ suǒ jí yí qiè jiē shì bú jìng",
                chinese: "是 故 經 言 ‧ 此 身 衆 苦 所 集 ‧ 一 切 皆 是 不 淨"
            ),
            Verse(
                number: 31,
                text: "How could there be a wise person who relishes this body?",
                pinyin: "hé yǒu zhì huì zhě ér dāng yào cǐ shēn",
                chinese: "何 有 智 慧 者 ‧ 而 當 樂 此 身"
            ),
            Verse(
                number: 32,
                text: "Birth and death are comprised of such unwholesome phenomena and should be regarded with loathing and dispassion.",
                pinyin: "shēng sǐ jì yǒu rú cǐ zhǒng zhǒng è fǎ shén kě huàn yàn",
                chinese: "生 死 既 有 如 此 種 種 惡 法 ‧ 甚 可 患 厭"
            ),
            Verse(
                number: 33,
                text: "Regarding the fourth mind of giving rise to the bodhi mind, the sūtras state that one should seek the Buddha's body, which is the Dharma body.",
                pinyin: "dì sì fā pú tí xīn zhě jīng yán dāng yào fó shēn fó shēn zhě jí fǎ shēn yě",
                chinese: "第 四 發 菩 提 心 者 。 經 言 ‧ 當 樂 佛 身 。 佛 身 者 ‧ 卽 法 身 也"
            ),
            Verse(
                number: 34,
                text: "It is born through limitless merits and virtues as well as wisdom.",
                pinyin: "cóng wú liàng gōng dé zhì huì shēng",
                chinese: "從 無 量 功 德 智 慧 生"
            ),
            Verse(
                number: 35,
                text: "It is born through the Six Pāramitās.",
                pinyin: "cóng liù bō luó mì shēng",
                chinese: "從 六 波 羅 蜜 生"
            ),
            Verse(
                number: 36,
                text: "It is born through kindness, compassion, joy, and equanimity.",
                pinyin: "cóng cí bēi xǐ shě shēng",
                chinese: "從 慈 悲 喜 捨 生"
            ),
            Verse(
                number: 37,
                text: "It is born through the Thirty-Seven Factors of Awakening.",
                pinyin: "cóng sān shí qī zhù pú tí fǎ shēng",
                chinese: "從 三 十 七 助 菩 提 法 生"
            ),
            Verse(
                number: 38,
                text: "The tathāgata's body is born through all of these merits and virtues as well as wisdom.",
                pinyin: "cóng rú shì děng zhǒng zhǒng gōng dé zhì huì shēng rú lái shēn",
                chinese: "從 如 是 等 ‧ 種 種 功 德 智 慧 生 如 來 身"
            ),
            Verse(
                number: 39,
                text: "One who wishes to obtain this body should give rise to the bodhi mind and seek omniscience;",
                pinyin: "yù dé cǐ shēn zhě dāng fā pú tí xīn qiú yí qiè zhǒng zhì",
                chinese: "欲 得 此 身 者 ‧ 當 發 菩 提 心 ‧ 求 一 切 種 智"
            ),
            Verse(
                number: 40,
                text: "permanence, bliss, self-nature, and purity; the fruit of sarvajña;",
                pinyin: "cháng lè wǒ jìng sà pó ruò guǒ",
                chinese: "常 樂 我 淨 ‧ 薩 婆 若 果"
            ),
            Verse(
                number: 41,
                text: "purify the buddha's land; assist sentient beings; and not be attached to one's body, life, and possessions.",
                pinyin: "jìng fó guó tǔ chéng jiù zhòng shēng yú shēn mìng cái wú suǒ lìn xí",
                chinese: "淨 佛 國 土 ‧ 成 就 衆 生 。 於 身 命 財 ‧ 無 所 吝 惜"
            ),
            Verse(
                number: 42,
                text: "Regarding the fifth mind of seeing friends and foes as equal, one should give rise to a mind of compassion towards all sentient beings without differentiating between self and other.",
                pinyin: "dì wǔ yuàn qīn píng děng zhě yú yí qiè zhòng shēng qǐ cí bēi xīn wú bǐ wǒ xiàng",
                chinese: "第 五 怨 親 平 等 者 。 於 一 切 衆 生 ‧ 起 慈 悲 心 ‧ 無 彼 我 相"
            ),
            Verse(
                number: 43,
                text: "Why is this? If one sees friends different from foes, then that is discriminating.",
                pinyin: "hé yǐ gù ěr ruò jiàn yuàn yì yú qīn jí shì fēn bié",
                chinese: "何 以 故 爾 。 若 見 怨 異 於 親 ‧ 卽 是 分 別"
            ),
            Verse(
                number: 44,
                text: "Because of this discrimination, attachment to form arises.",
                pinyin: "yǐ fēn bié gù qǐ zhū xiàng zhuó",
                chinese: "以 分 別 故 ‧ 起 諸 相 著"
            ),
            Verse(
                number: 45,
                text: "This attachment to form leads to the causes and conditions for afflictions to arise.",
                pinyin: "xiàng zhuó yīn yuán shēng zhū fán nǎo",
                chinese: "相 著 因 緣 ‧ 生 諸 煩 惱"
            ),
            Verse(
                number: 46,
                text: "Afflictions are the causes and conditions for unwholesome karma,",
                pinyin: "fán nǎo yīn yuán zào zhū è yè",
                chinese: "煩 惱 因 緣 ‧ 造 諸 惡 業"
            ),
            Verse(
                number: 47,
                text: "and unwholesome karma forms the causes and conditions for the fruition of suffering.",
                pinyin: "è yè yīn yuán gù dé kǔ guǒ",
                chinese: "惡 業 因 緣 ‧ 故 得 苦 果"
            ),
            Verse(
                number: 48,
                text: "Regarding the sixth mind of repaying the buddha's kindness, in limitless kalpas past, the Tathāgata offered his head, eyes, marrow, brain, limbs, hands, and feet;",
                pinyin: "dì liù niàn bào fó ēn zhě rú lái wǎng xí wú liàng jié zhōng shě tóu mù suǐ nǎo zhī jié shǒu zú",
                chinese: "第 六 念 報 佛 恩 者 。 如 來 往 昔 無 量 劫 中 ‧ 捨 頭 目 髓 腦 ‧ 支 節 手 足"
            ),
            Verse(
                number: 49,
                text: "his nation and kingdom; his wife and children; his elephant, steed, and Seven Treasures.",
                pinyin: "guó chéng qī zǐ xiàng mǎ qī zhēn",
                chinese: "國 城 妻 子 ‧ 象 馬 七 珍"
            ),
            Verse(
                number: 50,
                text: "On our behalf, he practiced austerities. This kindness and virtue is truly difficult to repay.",
                pinyin: "wèi wǒ děng gù xiū zhū kǔ hèng cǐ ēn cǐ dé shí nán chóu bào",
                chinese: "為 我 等 故 ‧ 修 諸 苦 行 。 此 恩 此 德 ‧ 實 難 酬 報"
            ),
            Verse(
                number: 51,
                text: "Thus, the sūtra states, 'Even if one were to bear him on one's head and shoulders out of deep respect, for as many kalpas as there are grains of sand in the Ganges River, one could not repay him.'",
                pinyin: "shì gù jīng yán ruò yǐ dǐng dài liǎng jiān hé fù yú héng shā jié yì bù néng bào",
                chinese: "是 故 經 言 ‧ 若 以 頂 戴 ‧ 兩 肩 荷 負 ‧ 於 恆 沙 劫 ‧ 亦 不 能 報"
            ),
            Verse(
                number: 52,
                text: "We, who wish to repay this kindness, should be courageous and diligent in this lifetime;",
                pinyin: "wǒ děng yù bào rú lái ēn zhě dāng yú cǐ shì yǒng měng jīng jìn",
                chinese: "我 等 欲 報 如 來 恩 者 ‧ 當 於 此 世 ‧ 勇 猛 精 進"
            ),
            Verse(
                number: 53,
                text: "work hard and endure suffering, unconcerned with our body and life;",
                pinyin: "hàn láo rěn kǔ bù xí shēn mìng",
                chinese: "捍 勞 忍 苦 ‧ 不 惜 身 命"
            ),
            Verse(
                number: 54,
                text: "establish the Triple Gem and propagate the Mahāyāna;",
                pinyin: "jiàn lì sān bǎo hóng tōng dà chèng",
                chinese: "建 立 三 寶 ‧ 弘 通 大 乘"
            ),
            Verse(
                number: 55,
                text: "and transform sentient beings so that all attain Proper Awakening.",
                pinyin: "guǎng huà zhòng shēng tóng rù zhèng jué",
                chinese: "廣 化 衆 生 ‧ 同 入 正 覺"
            ),
            Verse(
                number: 56,
                text: "Regarding the seventh mind of contemplating the empty nature of transgressions, transgressions lack an inherent nature and lack the characteristics of reality.",
                pinyin: "dì qī guān zuì xìng kōng zhě zuì wú zì xìng wú yǒu shí xiàng",
                chinese: "第 七 觀 罪 性 空 者 。 罪 無 自 性 ‧ 無 有 實 相"
            ),
            Verse(
                number: 57,
                text: "They arise through causes and conditions. They exist through distortions.",
                pinyin: "cóng yīn yuán shēng diān dǎo ér yǒu",
                chinese: "從 因 緣 生 ‧ 顚 倒 而 有"
            ),
            Verse(
                number: 58,
                text: "Since they arise through causes and conditions, they also cease through causes and conditions.",
                pinyin: "jì cóng yīn yuán ér shēng yì cóng yīn yuán ér miè",
                chinese: "既 從 因 緣 而 生 ‧ 亦 從 因 緣 而 滅"
            ),
            Verse(
                number: 59,
                text: "They arise through causes and conditions such as lusting to be with evil friends and behaving improperly.",
                pinyin: "cóng yīn yuán ér shēng zhě xiá jìn è yǒu zào zuò wú duān",
                chinese: "從 因 緣 而 生 者 ‧ 狎 近 惡 友 ‧ 造 作 無 端"
            ),
            Verse(
                number: 60,
                text: "They cease through causes and conditions such as the repentance and reformation today, which cleanses our minds.",
                pinyin: "cóng yīn yuán ér miè zhě jí shì jīn rì xǐ xīn chàn huǐ",
                chinese: "從 因 緣 而 滅 者 ‧ 卽 是 今 日 洗 心 懺 悔"
            ),
            Verse(
                number: 61,
                text: "Therefore, the sūtras state that the nature of transgression is not internal, not external, and not in between.",
                pinyin: "shì gù jīng yán cǐ zuì xìng bù zài nèi bù zài wài bù zài zhōng jiān",
                chinese: "是 故 經 言 ‧ 此 罪 性 ‧ 不 在 內 ‧ 不 在 外 ‧ 不 在 中 間"
            ),
            Verse(
                number: 62,
                text: "Thus, we know that the transgressions are originally empty [in nature].",
                pinyin: "gù zhī cǐ zuì cóng běn shì kōng",
                chinese: "故 知 此 罪 ‧ 從 本 是 空"
            ),
            Verse(
                number: 63,
                text: "Having given rise to these Seven Kinds of Mind, next we contemplate the buddhas and worthy sages of the ten directions",
                pinyin: "shēng rú shì děng qī zhǒng xīn yǐ yuán xiǎng shí fāng zhū fó xián shèng",
                chinese: "生 如 是 等 ‧ 七 種 心 已 ‧ 緣 想 十 方 ‧ 諸 佛 賢 聖"
            ),
            Verse(
                number: 64,
                text: "and join our palms while admitting our [faults]. Filled with remorse and shame, we vow to change.",
                pinyin: "qíng quán hé zhǎng pī chén zhì dǎo cán kuì gǎi gé",
                chinese: "擎 拳 合 掌 ‧ 披 陳 致 禱 ‧ 慚 愧 改 革"
            ),
            Verse(
                number: 65,
                text: "Purifying our hearts and cleansing our insides, through this repentance and reformation, what offenses can remain unabolished? What merits are not born?",
                pinyin: "shū lì xīn gān xǐ dàng cháng wèi rú cǐ chàn huǐ hé zuì bú miè hé fú bù shēng",
                chinese: "舒 瀝 心 肝 ‧ 洗 蕩 腸 胃 。 如 此 懺 悔 ‧ 何 罪 不 滅 ‧ 何 福 不 生"
            ),
            Verse(
                number: 66,
                text: "If this is not the case, then one is either lax and unconcerned, or giving rise to agitated thoughts and emotions.",
                pinyin: "ruò fù bù ěr yōu yōu huǎn zòng qíng lǜ zào dòng",
                chinese: "若 復 不 爾 ‧ 悠 悠 緩 縱 ‧ 情 慮 躁 動"
            ),
            Verse(
                number: 67,
                text: "This is merely exhausting one's body. What benefit could there possibly be?",
                pinyin: "tú zì láo xíng yú shì hé yì",
                chinese: "徒 自 勞 形 ‧ 於 事 何 益"
            ),
            Verse(
                number: 68,
                text: "Furthermore, one's life is impermanent like a candle. If just one breath is missed, then one is the same as ashes and dust.",
                pinyin: "qiě fù rén mìng wú cháng yù rú zhuǎn zhú yì xí bù huán biàn tong huī rǎng",
                chinese: "且 復 人 命 無 常 ‧ 諭 如 轉 燭 ‧ 一 息 不 還 ‧ 便 同 灰 壤"
            ),
            Verse(
                number: 69,
                text: "The retribution of suffering in the Three Lower Realms are instantly on one's body, and no amount of money, treasure, or material possessions can provide an escape.",
                pinyin: "sān tú kǔ bào jí shēn yīng shòu bù kě yǐ qián cái bǎo huò zhǔ tuō qiú tuō",
                chinese: "三 塗 苦 報 ‧ 卽 身 應 受 。 不 可 以 錢 財 寶 貨 ‧ 囑 託 求 脫"
            ),
            Verse(
                number: 70,
                text: "Somber and dark, there is no benevolent pardon, nor anybody to undergo these sufferings on one's behalf.",
                pinyin: "yǎo yǎo míng míng ēn shè wú qī dú yīng cǐ kǔ wú dài shòu zhě",
                chinese: "窈 窈 冥 冥 ‧ 恩 赦 無 期 。 獨 嬰 此 苦 ‧ 無 代 受 者"
            ),
            Verse(
                number: 71,
                text: "Do not say, 'I have not committed these transgressions in this life, and so I cannot sincerely repent and reform.'",
                pinyin: "mò yán wǒ jīn shēng zhōng wú yǒu cǐ zuì suǒ yǐ bù néng kěn dǎo chàn huǐ",
                chinese: "莫 言 我 今 生 中 ‧ 無 有 此 罪 ‧ 所 以 不 能 懇 禱 懺 悔"
            ),
            Verse(
                number: 72,
                text: "The sūtras state that when ordinary beings even raise their foot and take a step, are all transgressions.",
                pinyin: "jīng zhōng wèi yán fán fū zhī rén jǔ zú dòng bù wú fēi shì zuì",
                chinese: "經 中 謂 言 ‧ 凡 夫 之 人 ‧ 舉 足 動 步 ‧ 無 非 是 罪"
            ),
            Verse(
                number: 73,
                text: "Furthermore, in past lives, we have all committed limitless unwholesome deeds which follow us like a shadow and its form.",
                pinyin: "yòu fù guò qù shēng zhōng jiē xī chéng jiù wú liàng è yè zhuī zhú xíng zhě rú yǐng suí xíng",
                chinese: "又 復 過 去 生 中 ‧ 皆 悉 成 就 無 量 惡 業 ‧ 追 逐 行 者 如 影 隨 形"
            ),
            Verse(
                number: 74,
                text: "If we do not repent and reform, these transgressions and evils will increase day by day.",
                pinyin: "ruò bú chàn huǐ zuì è rì shēn",
                chinese: "若 不 懺 悔 ‧ 罪 惡 日 深"
            ),
            Verse(
                number: 75,
                text: "Thus, know that the Buddha did not permit concealing one's flaws. Instead, confess one's past transgressions as the Vimalakirti Sūtra teaches.",
                pinyin: "gù zhī bāo cáng xiá cǐ fó bù xǔ kě shuō huǐ xiān zuì jìng míng suǒ shàng",
                chinese: "故 知 包 藏 瑕 玼 ‧ 佛 不 許 可 。 說 悔 先 罪 ‧ 淨 名 所 尚"
            ),
            Verse(
                number: 76,
                text: "Therefore, drifting in the Sea of Suffering is precisely because of concealing [one's transgressions].",
                pinyin: "gù shǐ cháng lún kǔ hǎi shí yǒu yǐn fù",
                chinese: "故 使 長 淪 苦 海 ‧ 實 有 隱 覆"
            ),
            Verse(
                number: 77,
                text: "Thus, we, your disciples, confess as well as repent and reform for all transgressions today without concealing them any further.",
                pinyin: "shì gù zhòng děng jīn rì fā lù chàn huǐ bú fù fù cáng",
                chinese: "是 故 某 等 今 日 發 露 懺 悔 ‧ 不 復 覆 藏"
            )
        ]
        for verse in waterChapter4.verses {
            verse.chapter = waterChapter4
        }
        
        let waterChapter5 = Chapter(number: 5, title: "Repentance of Afflictions")
        waterChapter5.text = waterRepentance
        waterChapter5.verses = [
            Verse(
                number: 1,
                text: "Of the Three Obstructions, the first is affliction, the second is karma, and the third is result.",
                pinyin: "suǒ yán sān zhàng zhě yī yuē fán nǎo èr míng wèi yè sān shì guǒ bào",
                chinese: "所 言 三 障 者 。 一 曰 煩 惱 ‧ 二 名 為 業 ‧ 三 是 果 報"
            ),
            Verse(
                number: 2,
                text: "These three phenomena mutually lead to each other.",
                pinyin: "cǐ sān zhǒng fǎ gèng xiāng yóu jiè",
                chinese: "此 三 種 法 ‧ 更 相 由 藉"
            ),
            Verse(
                number: 3,
                text: "Because of afflictions, unwholesome karma arises.",
                pinyin: "yīn fán nǎo gù suǒ yǐ qǐ zhū è yè",
                chinese: "因 煩 惱 故 ‧ 所 以 起 諸 惡 業"
            ),
            Verse(
                number: 4,
                text: "Because of unwholesome karma, one obtains suffering as a result.",
                pinyin: "è yè yīn yuán gù dé kǔ guǒ",
                chinese: "惡 業 因 緣 ‧ 故 得 苦 果"
            ),
            Verse(
                number: 5,
                text: "Thus, your disciples in the assembly sincerely repent and reform today.",
                pinyin: "shì gù zhòng děng jīn rì zhì xīn chàn huǐ",
                chinese: "是 故 某 等 今 日 ‧ 至 心 懺 悔"
            ),
            Verse(
                number: 6,
                text: "First, we should repent and reform for the Obstruction of Afflictions.",
                pinyin: "dì yī xiān yīng chàn huǐ fán nǎo zhàng",
                chinese: "第 一 先 應 懺 悔 煩 惱 障"
            ),
            Verse(
                number: 7,
                text: "These afflictions arise from the mind.",
                pinyin: "ér cǐ fán nǎo jiē cóng yì qǐ",
                chinese: "而 此 煩 惱 ‧ 皆 從 意 起"
            ),
            Verse(
                number: 8,
                text: "How does this happen? Due to mental karma, body and speech follow in action.",
                pinyin: "suǒ yǐ zhě hé yì yè qǐ gù zé shēn yǔ kǒu suí zhī ér dòng",
                chinese: "所 以 者 何 。 意 業 起 故 ‧ 則 身 與 口 ‧ 隨 之 而 動"
            ),
            Verse(
                number: 9,
                text: "There are three kinds of mental karma. First is greed and desire, second is anger and aversion, third is ignorance.",
                pinyin: "yì yè yǒu sān yī zhě qiān tān èr zhě chēn huì sān zhě chī àn",
                chinese: "意 業 有 三 。 一 者 慳 貪 ‧ 二 者 瞋 恚 ‧ 三 者 癡 闇"
            ),
            Verse(
                number: 10,
                text: "Because of ignorance, wrong view arises and one commits unwholesome acts.",
                pinyin: "yóu chī àn gù qǐ zhū xié jiàn zào zhū bú shàn",
                chinese: "由 癡 闇 故 ‧ 起 諸 邪 見 ‧ 造 諸 不 善"
            ),
            Verse(
                number: 11,
                text: "Thus, the sūtra states that actions of desire, aversion, and ignorance can cause sentient beings to fall into the realms of hell, hungry ghosts, and animals, where they experience suffering.",
                pinyin: "shì gù jīng yán tān chēn chī yè néng lìng zhòng shēng duò yú dì yù è guǐ chù shēng shòu kǔ",
                chinese: "是 故 經 言 ‧ 貪 瞋 癡 業 ‧ 能 令 衆 生 ‧ 墮 於 地 獄 、 餓 鬼 、 畜 生 受 苦"
            ),
            Verse(
                number: 12,
                text: "If they are born as humans, then they will be poor, destitute, lonely, homeless, vicious, spiteful, stubborn, and dull.",
                pinyin: "ruò shēng rén zhōng dé pín qióng gū lù xiōng hěn wán dùn yú mí wú zhī",
                chinese: "若 生 人 中 ‧ 得 貧 窮 孤 露 ‧ 兇 狠 頑 鈍 ‧ 愚 迷 無 知"
            ),
            Verse(
                number: 13,
                text: "In their delusion, they do not know that these afflictions are retributions and that mental karma causes these terrible results.",
                pinyin: "zhū fán nǎo bào yì yè jì yǒu rú cǐ è guǒ",
                chinese: "諸 煩 惱 報 。 意 業 既 有 如 此 惡 果"
            ),
            Verse(
                number: 14,
                text: "Thus, today, we sincerely return our lives in refuge to the buddhas and request empathy in repenting and reforming.",
                pinyin: "shì gù zhòng děng jīn rì zhì xīn guī mìng zhū fú qiú āi chàn huǐ",
                chinese: "是 故 某 等 ‧ 今 日 至 心 皈 命 諸 佛 ‧ 求 哀 懺 悔"
            ),
            Verse(
                number: 15,
                text: "These afflictions are subject to all sorts of blame by the buddhas, bodhisattvas, and sages who grasp reality.",
                pinyin: "fú cǐ fán nǎo zhū fó pú sà rù lǐ shèng rén zhǒng zhǒng hē zé",
                chinese: "夫 此 煩 惱 ‧ 諸 佛 菩 薩 ‧ 入 理 聖 人 ‧ 種 種 呵 責"
            ),
            Verse(
                number: 16,
                text: "They also call these afflictions enemies.",
                pinyin: "yì míng cǐ fán nǎo yǐ wéi yuàn jiā",
                chinese: "亦 名 此 煩 惱 以 為 怨 家"
            ),
            Verse(
                number: 17,
                text: "Why is this? Because these afflictions are able to sever the root of the wisdom life of sentient beings.",
                pinyin: "hé yǐ gù néng duàn zhòng shēng huì mìng gēn gù",
                chinese: "何 以 故 。 能 斷 眾 生 ‧ 慧 命 根 故"
            ),
            Verse(
                number: 18,
                text: "They also call these afflictions thieves.",
                pinyin: "yì míng cǐ fán nǎo yǐ zhī wèi zéi",
                chinese: "亦 名 此 煩 惱 以 之 為 賊"
            ),
            Verse(
                number: 19,
                text: "Because these afflictions are able to steal the virtuous Dharmas of sentient beings.",
                pinyin: "néng jié zhòng shēng zhū shàn fǎ gù",
                chinese: "能 劫 衆 生 諸 善 法 故"
            ),
            Verse(
                number: 20,
                text: "They also call these afflictions turbulent rivers because these afflictions are able to sweep sentient beings into the Great Sea of Suffering of birth and death.",
                pinyin: "yì míng cǐ fán nǎo yǐ wèi pù hé néng piào zhòng shēng rù yú shēng sǐ dà kǔ hǎi gù",
                chinese: "亦 名 此 煩 惱 以 為 瀑 河 ‧ 能 漂 衆 生 入 於 生 死 大 苦 海 故"
            ),
            Verse(
                number: 21,
                text: "They also call these afflictions shackles because these afflictions can lock sentient beings in the prison of birth and death without any way out.",
                pinyin: "yì míng cǐ fán nǎo yǐ wèi jī suǒ néng xì zhòng zhòng yú shēng sǐ yù bù néng dé chū gù",
                chinese: "亦 名 此 煩 惱 以 為 覉 鎖 ‧ 能 繫 衆 生 於 生 死 獄 ‧ 不 能 得 出 故"
            ),
            Verse(
                number: 22,
                text: "This is why the Six Realms continue, and the Four Forms of Existence do not end;",
                pinyin: "suǒ yǐ liù dào qiān lián sì shēng bù jué",
                chinese: "所 以 六 道 牽 連 ‧ 四 生 不 絕"
            ),
            Verse(
                number: 23,
                text: "unwholesome deeds are limitless, and the fruits of suffering do not cease.",
                pinyin: "è yè wú qióng kǔ guǒ bù xī",
                chinese: "惡 業 無 窮 ‧ 苦 果 不 息"
            ),
            Verse(
                number: 24,
                text: "One should know that these are all faults of afflictions.",
                pinyin: "dāng zhī jiē shì fán nǎo guò huàn",
                chinese: "當 知 皆 是 煩 惱 過 患"
            ),
            Verse(
                number: 25,
                text: "Thus, today, we give rise to this virtuous mind of improvement and request empathy in repenting and reforming.",
                pinyin: "shì gù jīn rì yùn cǐ zēng shàng shàn xīn qiú āi chàn huǐ",
                chinese: "是 故 今 日 ‧ 運 此 增 上 善 心 ‧ 求 哀 懺 悔"
            ),
            Verse(
                number: 26,
                text: "Since beginningless time until today, we, the assembly, whether as human, celestial, or other beings within the Six Realms, have filled our hearts and consciousnesses with ignorance",
                pinyin: "zhòng děng zì cóng wú shǐ yǐ lái zhì yú jīn rì huò zài rén tiān liù dào shòu bào yǒu cǐ xīn shí cháng huái yú huò fán mǎn xiōng jīn",
                chinese: "某 等 自 從 無 始 以 來 ‧ 至 于 今 日 ‧ 或 在 人 天 ‧ 六 道 受 報 ‧ 有 此 心 識 ‧ 常 懷 愚 惑 ‧ 繁 滿 胸 襟"
            ),
            Verse(
                number: 27,
                text: "and disturbed and harmed all sentient beings in the Six Realms and Four Forms of Existence, whether committing all transgressions because of the Three Poisons,",
                pinyin: "huò yīn sān dú gēn zào yí qiè zuì",
                chinese: "或 因 三 毒 根 ‧ 造 一 切 罪"
            ),
            Verse(
                number: 28,
                text: "whether committing all transgressions because of the Three Outflows.",
                pinyin: "huò yīn sān lòu zào yí qiè zuì",
                chinese: "或 因 三 漏 ‧ 造 一 切 罪"
            ),
            Verse(
                number: 29,
                text: "Whether committing all transgressions because of the Three Sufferings,",
                pinyin: "huò yīn sān kǔ zào yí qiè zuì",
                chinese: "或 因 三 苦 ‧ 造 一 切 罪"
            ),
            Verse(
                number: 30,
                text: "whether committing all transgressions because of the Three Delusions,",
                pinyin: "huò yuán sān dǎo zào yí qiè zuì",
                chinese: "或 緣 三 倒 ‧ 造 一 切 罪"
            ),
            Verse(
                number: 31,
                text: "or whether committing all transgressions because of attachment towards the Three Realms,",
                pinyin: "huò tān sān yǒu zào yí qiè zuì",
                chinese: "或 貪 三 有 ‧ 造 一 切 罪"
            ),
            Verse(
                number: 32,
                text: "these transgressions are limitless and boundless.",
                pinyin: "rú shì děng zuì wú liàng wú biān",
                chinese: "如 是 等 罪 ‧ 無 量 無 邊"
            ),
            Verse(
                number: 33,
                text: "Today, we are remorseful and shameful as we repent and reform for all of these.",
                pinyin: "nǎo luàn yí qiè liù dào sì shēng jīn rì cán kuì jiē xī chàn huǐ",
                chinese: "惱 亂 一 切 六 道 四 生 ‧ 今 日 慚 愧 ‧ 皆 悉 懺 悔"
            ),
            Verse(
                number: 34,
                text: "Furthermore, since beginningless time until today, we, the assembly, disturbed and harmed all sentient beings in the Six Realms,",
                pinyin: "yòu fù zhòng děng zì cóng wú shǐ yǐ lái zhì yú jīn rì",
                chinese: "又 復 某 等 ‧ 自 從 無 始 以 來 ‧ 至 于 今 日"
            ),
            Verse(
                number: 35,
                text: "whether committing all transgressions because of the Four [Attachments of] Consciousness,",
                pinyin: "huò yīn sì zhù zào yí qiè zuì",
                chinese: "或 因 四 住 ‧ 造 一 切 罪"
            ),
            Verse(
                number: 36,
                text: "whether committing all transgressions because of the Four Flows,",
                pinyin: "huò yīn sì liú zào yí qiè zuì",
                chinese: "或 因 四 流 ‧ 造 一 切 罪"
            ),
            Verse(
                number: 37,
                text: "whether committing all transgressions because of the Four Graspings,",
                pinyin: "huò yīn sì qǔ zào yí qiè zuì",
                chinese: "或 因 四 取 ‧ 造 一 切 罪"
            ),
            Verse(
                number: 38,
                text: "whether committing all transgressions because of the Four Attachments.",
                pinyin: "huò yīn sì zhí zào yí qiè zuì",
                chinese: "或 因 四 執 ‧ 造 一 切 罪"
            ),
            Verse(
                number: 39,
                text: "Whether committing all transgressions because of the Four Conditions,",
                pinyin: "huò yīn sì yuán zào yí qiè zuì",
                chinese: "或 因 四 緣 ‧ 造 一 切 罪"
            ),
            Verse(
                number: 40,
                text: "whether committing all transgressions because of attachment towards the Four Elements,",
                pinyin: "huò yīn sì dà zào yí qiè zuì",
                chinese: "或 因 四 大 ‧ 造 一 切 罪"
            ),
            Verse(
                number: 41,
                text: "whether committing all transgressions because of attachment towards the Four Bindings,",
                pinyin: "huò yīn sì fù zào yí qiè zuì",
                chinese: "或 因 四 縛 ‧ 造 一 切 罪"
            ),
            Verse(
                number: 42,
                text: "whether committing all transgressions because of attachment towards the Four Desires,",
                pinyin: "huò yīn sì tān zào yí qiè zuì",
                chinese: "或 因 四 貪 ‧ 造 一 切 罪"
            ),
            Verse(
                number: 43,
                text: "or whether committing all transgressions because of the Four Forms of Existence,",
                pinyin: "huò yīn sì shēng zào yí qiè zuì",
                chinese: "或 因 四 生 ‧ 造 一 切 罪"
            ),
            Verse(
                number: 44,
                text: "these transgressions are limitless and boundless.",
                pinyin: "rú shì děng zuì wú liàng wú biān",
                chinese: "如 是 等 罪 ‧ 無 量 無 邊"
            ),
            Verse(
                number: 45,
                text: "Today, we are remorseful and shameful as we repent and reform for all of these.",
                pinyin: "nǎo luàn liù dào yí qiè zhòng shēng jīn rì cán kuì jiē xī chàn huǐ",
                chinese: "惱 亂 六 道 一 切 衆 生 。 今 日 慚 愧 ‧ 皆 悉 懺 悔"
            ),
            Verse(
                number: 46,
                text: "Furthermore, since beginningless time until today, we, the assembly, disturbed and harmed all sentient beings in the Six Realms,",
                pinyin: "yòu fù zhòng děng zì cóng wú shǐ yǐ lái zhì yú jīn rì",
                chinese: "又 復 某 等 ‧ 自 從 無 始 以 來 ‧ 至 于 今 日"
            ),
            Verse(
                number: 47,
                text: "whether committing all transgressions because of the Five Stages [of Misconceptions],",
                pinyin: "huò yīn wǔ zhù zào yí qiè zuì",
                chinese: "或 因 五 住 ‧ 造 一 切 罪"
            ),
            Verse(
                number: 48,
                text: "whether committing all transgressions because of the Five Coverings,",
                pinyin: "huò yīn wǔ gài zào yí qiè zuì",
                chinese: "或 因 五 蓋 ‧ 造 一 切 罪"
            ),
            Verse(
                number: 49,
                text: "whether committing all transgressions because of the Five Forms of Stinginess,",
                pinyin: "huò yīn wǔ qiān zào yí qiè zuì",
                chinese: "或 因 五 慳 ‧ 造 一 切 罪"
            ),
            Verse(
                number: 50,
                text: "whether committing all transgressions because of the Five Views,",
                pinyin: "huò yīn wǔ jiàn zào yí qiè zuì",
                chinese: "或 因 五 見 ‧ 造 一 切 罪"
            ),
            Verse(
                number: 51,
                text: "or whether committing all transgressions because of the Five Minds,",
                pinyin: "huò yīn wǔ xīn zào yí qiè zuì",
                chinese: "或 因 五 心 ‧ 造 一 切 罪"
            ),
            Verse(
                number: 52,
                text: "these transgressions are limitless and boundless.",
                pinyin: "rú shì děng fán nǎo wú liàng wú biān",
                chinese: "如 是 等 煩 惱 ‧ 無 量 無 邊"
            ),
            Verse(
                number: 53,
                text: "Today, we confess as well as repent and reform for all of these.",
                pinyin: "nǎo luàn liù dào yí qiè zhòng shēng jīn rì fā lù jiē xī chàn huǐ",
                chinese: "惱 亂 六 道 一 切 衆 生 。 今 日 發 露 ‧ 皆 悉 懺 悔"
            ),
            Verse(
                number: 54,
                text: "Furthermore, since beginningless time until today, we, the assembly, have disturbed and harmed all sentient beings in the Six Realms,",
                pinyin: "yòu fù zhòng děng zì cóng wú shǐ yǐ lái zhì yú jīn rì",
                chinese: "又 復 某 等 ‧ 自 從 無 始 以 來 ‧ 至 于 今 日"
            ),
            Verse(
                number: 55,
                text: "whether committing all transgressions because of the Six Emotions,",
                pinyin: "huò yīn liù gēn zào yí qiè zuì",
                chinese: "或 因 六 根 ‧ 造 一 切 罪"
            ),
            Verse(
                number: 56,
                text: "whether committing all transgressions because of the Six Consciousnesses,",
                pinyin: "huò yīn liù shì zào yí qiè zuì",
                chinese: "或 因 六 識 ‧ 造 一 切 罪"
            ),
            Verse(
                number: 57,
                text: "whether committing all transgressions because of the Six Perceptions,",
                pinyin: "huò yīn liù xiǎng zào yí qiè zuì",
                chinese: "或 因 六 想 ‧ 造 一 切 罪"
            ),
            Verse(
                number: 58,
                text: "whether committing all transgressions because of the Six Sensations.",
                pinyin: "huò yīn liù shòu zào yí qiè zuì",
                chinese: "或 因 六 受 ‧ 造 一 切 罪"
            ),
            Verse(
                number: 59,
                text: "Whether committing all transgressions because of the Six Volitions,",
                pinyin: "huò yīn liù xíng zào yí qiè zuì",
                chinese: "或 因 六 行 ‧ 造 一 切 罪"
            ),
            Verse(
                number: 60,
                text: "whether committing all transgressions because of the Six Passions,",
                pinyin: "huò yīn liù ài zào yí qiè zuì",
                chinese: "或 因 六 愛 ‧ 造 一 切 罪"
            ),
            Verse(
                number: 61,
                text: "or whether committing all transgressions because of the Six Doubts,",
                pinyin: "huò yīn liù yí zào yí qiè zuì",
                chinese: "或 因 六 疑 ‧ 造 一 切 罪"
            ),
            Verse(
                number: 62,
                text: "these transgressions are limitless and boundless.",
                pinyin: "rú shì děng fán nǎo wú liàng wú biān",
                chinese: "如 是 等 煩 惱 ‧ 無 量 無 邊"
            ),
            Verse(
                number: 63,
                text: "Today, we are remorseful and shameful as we repent and reform for all of these.",
                pinyin: "nǎo luàn liù dào yí qiè zhòng shēng jīn rì cán kuì fā lù jiē xī chàn huǐ",
                chinese: "惱 亂 六 道 一 切 衆 生 。 今 日 慚 愧 發 露 ‧ 皆 悉 懺 悔"
            ),
            Verse(
                number: 64,
                text: "Furthermore, since beginningless time until today, we, the assembly, disturbed and harmed all sentient beings in the Six Realms,",
                pinyin: "yòu fù zhòng děng zì cóng wú shǐ yǐ lái zhì yú jīn rì",
                chinese: "又 復 某 等 ‧ 自 從 無 始 以 來 ‧ 至 于 今 日"
            ),
            Verse(
                number: 65,
                text: "whether committing all transgressions because of the Seven Outflows,",
                pinyin: "huò yīn qī lòu zào yí qiè zuì",
                chinese: "或 因 七 漏 ‧ 造 一 切 罪"
            ),
            Verse(
                number: 66,
                text: "whether committing all transgressions because of the Seven Tendencies,",
                pinyin: "huò yīn qī shǐ zào yí qiè zuì",
                chinese: "或 因 七 使 ‧ 造 一 切 罪"
            ),
            Verse(
                number: 67,
                text: "whether committing all transgressions because of the Eight Delusions,",
                pinyin: "huò yīn bā dǎo zào yí qiè zuì",
                chinese: "或 因 八 倒 ‧ 造 一 切 罪"
            ),
            Verse(
                number: 68,
                text: "whether committing all transgressions because of the Eight Defilements,",
                pinyin: "huò yīn bā gòu zào yí qiè zuì",
                chinese: "或 因 八 垢 ‧ 造 一 切 罪"
            ),
            Verse(
                number: 69,
                text: "or whether committing all transgressions because of the Eight Sufferings,",
                pinyin: "huò yīn bā kǔ zào yí qiè zuì",
                chinese: "或 因 八 苦 ‧ 造 一 切 罪"
            ),
            Verse(
                number: 70,
                text: "these transgressions are limitless and boundless.",
                pinyin: "rú shì děng fán nǎo wú liàng wú biān",
                chinese: "如 是 等 煩 惱 ‧ 無 量 無 邊"
            ),
            Verse(
                number: 71,
                text: "Today, we confess as well as repent and reform for all of these.",
                pinyin: "nǎo luàn liù dào yí qiè zhòng shēng jīn rì fā lù jiē xī chàn huǐ",
                chinese: "惱 亂 六 道 一 切 衆 生 。 今 日 發 露 ‧ 皆 悉 懺 悔"
            ),
            Verse(
                number: 72,
                text: "Furthermore, since beginningless time until today, we, the assembly, burn ablaze from day to night and open the gates of outflow,",
                pinyin: "yòu fù zhòng děng zì cóng wú shǐ yǐ lái zhì yú jīn rì",
                chinese: "又 復 某 等 ‧ 自 從 無 始 以 來 ‧ 至 于 今 日"
            ),
            Verse(
                number: 73,
                text: "whether committing all transgressions because of the Nine Difficulties,",
                pinyin: "huò yīn jiǔ nǎo zào yí qiè zuì",
                chinese: "或 因 九 惱 ‧ 造 一 切 罪"
            ),
            Verse(
                number: 74,
                text: "whether committing all transgressions because of the Nine Fetters,",
                pinyin: "huò yīn jiǔ jié zào yí qiè zuì",
                chinese: "或 因 九 結 ‧ 造 一 切 罪"
            ),
            Verse(
                number: 75,
                text: "whether committing all transgressions because of the Nine Conditions,",
                pinyin: "huò yīn jiǔ yuán zào yí qiè zuì",
                chinese: "或 因 九 緣 ‧ 造 一 切 罪"
            ),
            Verse(
                number: 76,
                text: "whether committing all transgressions because of the Ten Afflictions.",
                pinyin: "huò yīn shí fán nǎo zào yí qiè zuì",
                chinese: "或 因 十 煩 惱 ‧ 造 一 切 罪"
            ),
            Verse(
                number: 77,
                text: "Whether committing all transgressions because of the Ten Bonds,",
                pinyin: "huò yīn shí chán zào yí qiè zuì",
                chinese: "或 因 十 纏 ‧ 造 一 切 罪"
            ),
            Verse(
                number: 78,
                text: "whether committing all transgressions because of the Eleven Biases,",
                pinyin: "huò yīn shí yī piàn shǐ zào yí qiè zuì",
                chinese: "或 因 十 一 徧 使 ‧ 造 一 切 罪"
            ),
            Verse(
                number: 79,
                text: "whether committing all transgressions because of the Twelve Contacts,",
                pinyin: "huò yīn shí èr rù zào yí qiè zuì",
                chinese: "或 因 十 二 入 ‧ 造 一 切 罪"
            ),
            Verse(
                number: 80,
                text: "whether committing all transgressions because of the Sixteen Understandings and Views,",
                pinyin: "huò yīn shí liù zhī jiàn zào yí qiè zuì",
                chinese: "或 因 十 六 知 見 ‧ 造 一 切 罪"
            ),
            Verse(
                number: 81,
                text: "whether committing all transgressions because of the Eighteen Realms,",
                pinyin: "huò yīn shí bā jiè zào yí qiè zuì",
                chinese: "或 因 十 八 界 ‧ 造 一 切 罪"
            ),
            Verse(
                number: 82,
                text: "whether committing all transgressions because of the Twenty-Five Aspects of Self,",
                pinyin: "huò yīn èr shí wǔ wǒ zào yí qiè zuì",
                chinese: "或 因 二 十 五 我 ‧ 造 一 切 罪"
            ),
            Verse(
                number: 83,
                text: "whether committing all transgressions because of the Sixty-Two Views.",
                pinyin: "huò yīn liù shí èr jiàn zào yí qiè zuì",
                chinese: "或 因 六 十 二 見 ‧ 造 一 切 罪"
            ),
            Verse(
                number: 84,
                text: "Or whether committing all transgressions because of thoughts after seeing the truth, the Ninety-Eight Afflictions, or the One Hundred and Eight Afflictions,",
                pinyin: "huò yīn jiàn dì sī wéi jiǔ shí bā shǐ bǎi bā fán nǎo zhòu yè chì rán kāi zhū lòu mén zào yí qiè zuì",
                chinese: "或 因 見 諦 思 惟 九 十 八 使 ‧ 百 八 煩 惱 ‧ 晝 夜 熾 然 ‧ 開 諸 漏 門 ‧ 造 一 切 罪"
            ),
            Verse(
                number: 85,
                text: "these transgressions harm and disturb the worthy sages and the Four Forms of Existence,",
                pinyin: "nǎo luàn xian shèng jí yǐ sì shēng",
                chinese: "惱 亂 賢 聖 ‧ 及 以 四 生"
            ),
            Verse(
                number: 86,
                text: "fill the Three Realms and extend throughout the Six Realms without any place to escape.",
                pinyin: "piàn mǎn sān jiè mí gèn liù dào wú chù kě bì",
                chinese: "徧 滿 三 界 ‧ 彌 亘 六 道 ‧ 無 處 可 避"
            ),
            Verse(
                number: 87,
                text: "Today, we sincerely pray to the Buddhas, honored Dharma, and sacred Sangha of the ten directions.",
                pinyin: "jīn rì zhì dǎo xiàng shí fāng fó zūn fǎ shèng zhòng",
                chinese: "今 日 致 禱 ‧ 向 十 方 佛 、 尊 法 、 聖 衆"
            ),
            Verse(
                number: 88,
                text: "We are remorseful and shameful as we repent and reform for all of these.",
                pinyin: "cán kuì fā lù jiē xī chàn huǐ",
                chinese: "慚 愧 發 露 ‧ 皆 悉 懺 悔"
            ),
            Verse(
                number: 89,
                text: "Through the merits and virtues born from repenting and reforming for all of the afflictions of the Three Poisons,",
                pinyin: "yuàn zhòng děng chéng shì chàn huǐ sān dú yí qiè fán nǎo suǒ shēng gōng dé",
                chinese: "願 某 等 承 是 懺 悔 ‧ 三 毒 一 切 煩 惱 ‧ 所 生 功 德"
            ),
            Verse(
                number: 90,
                text: "may we in the assembly illuminate the Three Wisdoms, grasp the Three Understandings, eradicate the Three Sufferings, and fulfill the Three Vows, birth after birth, lifetime after lifetime.",
                pinyin: "shēng shēng shì shì sān huì míng sān dá lǎng sān kǔ miè sān yuàn mǎn",
                chinese: "生 生 世 世 ‧ 三 慧 明 ‧ 三 達 朗 ‧ 三 苦 滅 ‧ 三 願 滿"
            ),
            Verse(
                number: 91,
                text: "Through the merits and virtues born from repenting and reforming for all of the afflictions of the Four Consciousnesses,",
                pinyin: "yuàn chéng shì chàn huǐ sì shí děng yí qiè fán nǎo suǒ shēng gōng dé",
                chinese: "願 承 是 懺 悔 ‧ 四 識 等 一 切 煩 惱 ‧ 所 生 功 德"
            ),
            Verse(
                number: 92,
                text: "may we in the assembly expand the Four Kinds of Mind, establish the Four Faiths, eradicate the Four Lower Realms, and obtain the Four Kinds of Fearlessness, birth after birth, lifetime after lifetime.",
                pinyin: "shēng shēng shì shì guǎng sì děng xīn lì sì xìn yè miè sì è qù dé sì wú wèi",
                chinese: "生 生 世 世 ‧ 廣 四 等 心 ‧ 立 四 信 業 ‧ 滅 四 惡 趣 ‧ 得 四 無 畏"
            ),
            Verse(
                number: 93,
                text: "Through the merits and virtues born from repenting and reforming for all of the afflictions of the Five Coverings,",
                pinyin: "yuàn chéng shì chàn huǐ wǔ gài děng zhū fán nǎo suǒ shēng gōng dé",
                chinese: "願 承 是 懺 悔 ‧ 五 蓋 等 諸 煩 惱 ‧ 所 生 功 德"
            ),
            Verse(
                number: 94,
                text: "may we in the assembly liberate the Five Realms, establish the Five Faculties, purify the Five Eyes, and complete the Five Parts [of the Dhama Body].",
                pinyin: "dù wǔ dào shù wǔ gēn jìng wǔ yǎn chéng wǔ fēn",
                chinese: "度 五 道 ‧ 豎 五 根 ‧ 淨 五 眼 ‧ 成 五 分"
            ),
            Verse(
                number: 95,
                text: "Through the merits and virtues born from repenting and reforming for all of the afflictions of the Six Sensations,",
                pinyin: "yuàn chéng shì chàn huǐ liù shòu děng zhū fán nǎo suǒ shēng gōng dé",
                chinese: "願 承 是 懺 悔 ‧ 六 受 等 諸 煩 惱 ‧ 所 生 功 德"
            ),
            Verse(
                number: 96,
                text: "may we in the assembly obtain the Six Spiritual Powers, perfect actions of the Six Pāramitās, not be misled by the Six Dusts, and always practice the Six Wondrous [Gates], birth after birth, lifetime after lifetime.",
                pinyin: "shēng shēng shì shì jù zú liù shén tōng mǎn zú liù dù yè bú wèi liù chén huò cháng xíng liù miào hèng",
                chinese: "生 生 世 世 ‧ 具 足 六 神 通 ‧ 滿 足 六 度 業 ‧ 不 為 六 塵 惑 ‧ 常 行 六 妙 行"
            ),
            Verse(
                number: 97,
                text: "Through the merits and virtues born from repenting and reforming for all of the afflictions of the Seven Outflows, Eight Defilements, Nine Fetters, and Ten Bonds,",
                pinyin: "yòu yuàn chéng shì chàn huǐ qī lòu bā gòu jiǔ jié shí chán děng yí qiè zhū fán nǎo suǒ shēng gōng dé",
                chinese: "又 願 承 是 懺 悔 、 七 漏 、 八 垢 、 九 結 、 十 纏 等 ‧ 一 切 諸 煩 惱 ‧ 所 生 功 德"
            ),
            Verse(
                number: 98,
                text: "may we, the assembly, sit on the Lotus of Seven Purities, wash ourselves with the Water of Eight Liberations, accumulate the Nine Severing Wisdoms, and complete the practices of the Ten Grounds, birth after birth, lifetime after lifetime.",
                pinyin: "shēng shēng shì shì zuò qī jìng huá xǐ bā jiě shuǐ jù jiǔ duàn zhì chéng shí dì hèng",
                chinese: "生 生 世 世 ‧ 坐 七 淨 華 ‧ 洗 八 解 水 ‧ 具 九 斷 智 ‧ 成 十 地 行"
            ),
            Verse(
                number: 99,
                text: "Through the merits and virtues born from repenting and reforming for all of the afflictions of the Eleven Biases, Twelve Contacts, and Eighteen Realms,",
                pinyin: "yuàn yǐ chàn huǐ shí yī piàn shǐ jí shí èr rù shí bā jiè děng yí qiè zhū fán nǎo suǒ shēng gōng dé",
                chinese: "願 以 懺 悔 ‧ 十 一 徧 使 ‧ 及 十 二 入 ‧ 十 八 界 等 ‧ 一 切 諸 煩 惱 ‧ 所 生 功 德"
            ),
            Verse(
                number: 100,
                text: "may we, the assembly, be able to understand the Eleven Kinds of Emptiness and always rest the mind in ease,",
                pinyin: "yuàn shí yī kōng néng jiě cháng yòng qī xīn zì zài",
                chinese: "願 十 一 空 能 解 ‧ 常 用 栖 心 自 在"
            ),
            Verse(
                number: 101,
                text: "be able to turn the Dharma Wheel of Twelve Aspects,",
                pinyin: "néng zhuǎn shí èr hè n fǎ lún",
                chinese: "能 轉 十 二 行 法 輪"
            ),
            Verse(
                number: 102,
                text: "obtain the Eighteen Distinct Traits, and perfect all limitless merits and virtues.",
                pinyin: "jù zú shí bā bú gòng zhī fǎ wú liàng gōng dé yí qiè yuán mǎn",
                chinese: "具 足 十 八 不 共 之 法 ‧ 無 量 功 德 ‧ 一 切 圓 滿"
            ),
            Verse(
                number: 103,
                text: "Having made vows, we return our lives in refuge and venerate the buddhas!",
                pinyin: "fā yuàn yǐ guī mìng lǐ zhū fó",
                chinese: "發 願 已 ‧ 皈 命 禮 諸 佛"
            ),
            Verse(
                number: 104,
                text: "Homage to Vairocana Buddha, Homage to our teacher Śākyamuni Buddha, Homage to Amitābha Buddha, Homage to Maitreya Buddha, Homage to Nāgagotrodārajñānarāja Buddha, Homage to Nāgeśvararāja Buddha, Homage to Prabhūtaratna Buddha, Homage to Buddhapuṇḍarīkadhyaneśvararāja Buddha, Homage to Kasayadhvaja Buddha, Homage to Siṃhanāda Buddha",
                pinyin: "ná mó pí lú zhē nà fó ná mó běn shī shì jiā móu ní fó ná mó ē mí tuó fó ná mó mí lè fó ná mó lóng zhǒng shàng zūn wáng fó ná mó lóng zì zài wáng fó ná mó bǎo shèng fó ná mó jué huá dìng zì zài wáng fó ná mó jiā shā chuáng fó ná mó shī zi hǒu fó",
                chinese: "南 無 毗 盧 遮 那 佛 南 無 本 師 釋 迦 牟 尼 佛 南 無 阿 彌 陀 佛 南 無 彌 勒 佛 南 無 龍 種 上 尊 王 佛 南 無 龍 自 在 王 佛 南 無 寶 勝 佛 南 無 覺 華 定 自 在 王 佛 南 無 袈 裟 幢 佛 南 無 師 子 吼 佛"
            ),
            Verse(
                number: 105,
                text: "Homage to Mañjuśrī Bodhisattva, Homage to Samantabhadra Bodhisattva, Homage to Mahāsthāmaprāpta Bodhisattva, Homage to Kṣitigarbha Bodhisattva, Homage to Mahāvyūha Bodhisattva, Homage to Avalokiteśvara Bodhisattva",
                pinyin: "ná mó wén shū shī lì pú sà ná mó pǔ xián pú sà ná mó dà shì zhì pú sà ná mó dì zàng pú sà ná mó dà zhuāng yán pú sà ná mó guān zì zài pú sà",
                chinese: "南 無 文 殊 師 利 菩 薩 南 無 普 賢 菩 薩 南 無 大 勢 至 菩 薩 南 無 地 藏 菩 薩 南 無 大 莊 嚴 菩 薩 南 無 觀 自 在 菩 薩"
            ),
            Verse(
                number: 106,
                text: "Having prostrated to the buddhas, again, repent and reform.",
                pinyin: "● lǐ zhū fó yǐ cì fù chàn huǐ",
                chinese: "禮 諸 佛 已 ‧ 次 復 懺 悔"
            ),
            Verse(
                number: 107,
                text: "In explaining repentance and reformation, fundamentally, it is rectifying the past and cultivating for the future; eradicating evils and giving rise to virtues.",
                pinyin: "fū lùn chàn huǐ zhě běn shì gǎi wǎng xiū lái miè è xīng shàn",
                chinese: "夫 論 懺 悔 者 ‧ 本 是 改 往 修 來 ‧ 滅 惡 興 善"
            ),
            Verse(
                number: 108,
                text: "Of the humans in this world, who has not made any mistakes?",
                pinyin: "rén zhī jū shì shuí néng wú guò",
                chinese: "人 之 居 世 ‧ 誰 能 無 過"
            ),
            Verse(
                number: 109,
                text: "Because those who are learning lose their mindfulness, afflictions arise.",
                pinyin: "xué rén shī niàn shàng qǐ fán nǎo",
                chinese: "學 人 失 念 ‧ 尚 起 煩 惱"
            ),
            Verse(
                number: 110,
                text: "Even an arhat forms habits and creates [karma] through their body, speech, and mind.",
                pinyin: "luó hàn jié xí dòng shēn kǒu yè",
                chinese: "羅 漢 結 習 ‧ 動 身 口 業"
            ),
            Verse(
                number: 111,
                text: "How much more so for unawakened beings who believe they are faultless?",
                pinyin: "qǐ kuàng fán fū ér dāng wú guò",
                chinese: "豈 況 凡 夫 ‧ 而 當 無 過"
            ),
            Verse(
                number: 112,
                text: "However, the wise realize this quickly and are able to change,",
                pinyin: "dàn zhì zhě xiān jué biàn néng gǎi huǐ",
                chinese: "但 智 者 先 覺 ‧ 便 能 改 悔"
            ),
            Verse(
                number: 113,
                text: "whereas the ignorant conceal [their mistakes] and cause them to grow.",
                pinyin: "yú zhě fù cáng suì shǐ zī màn",
                chinese: "愚 者 覆 藏 ‧ 遂 使 滋 蔓"
            ),
            Verse(
                number: 114,
                text: "Thus, one accumulates habits in the eternal night without any expectation of dawn or awakening.",
                pinyin: "suǒ yǐ cháng yè jī xí xiǎo wù wú qī",
                chinese: "所 以 長 夜 積 習 ‧ 曉 悟 無 期"
            ),
            Verse(
                number: 115,
                text: "If one is able to confess as well as repent and reform with remorse and shame, then how could one merely eradicate offenses?",
                pinyin: "ruò néng cán kuì fā lù chàn huǐ zhě qǐ wéi zhǐ shì miè zuì",
                chinese: "若 能 慚 愧 ‧ 發 露 懺 悔 者 ‧ 豈 惟 止 是 滅 罪"
            ),
            Verse(
                number: 116,
                text: "One would also gain limitless merits and virtues as well as establish the wondrous result of the Tathāgata's nirvāṇa.",
                pinyin: "yì fù zēng zhǎng wú liàng gōng dé shù lì rú lái niè pán miào guǒ",
                chinese: "亦 復 增 長 無 量 功 德 ‧ 豎 立 如 來 涅 槃 妙 果"
            ),
            Verse(
                number: 117,
                text: "If one wishes to practice this method, then externally, one should first tidy one's appearance, be solemn in behavior, and venerate an honored image;",
                pinyin: "ruò yù xíng cǐ fǎ zhě xiān dāng wài sù xíng yí zhān fèng zūn xiàng",
                chinese: "若 欲 行 此 法 者 ‧ 先 當 外 肅 形 儀 ‧ 瞻 奉 尊 像"
            ),
            Verse(
                number: 118,
                text: "internally, one should give rise to reverence, be immersed in the method of visualization, and sincerely give rise to the Two Kinds of Mind.",
                pinyin: "nèi qǐ jìng yì yuán yú xiǎng fǎ kěn qiè zhì dǎo shēng èr zhǒng xīn",
                chinese: "內 起 敬 意 ‧ 緣 於 想 法 。 懇 切 至 禱 ‧ 生 二 種 心"
            ),
            Verse(
                number: 119,
                text: "What are these two?",
                pinyin: "hé děng wéi èr",
                chinese: "何 等 為 二"
            ),
            Verse(
                number: 120,
                text: "First, think to oneself, my life and body is impossible to preserve forever.",
                pinyin: "yī zhě zì niàn wǒ cǐ xíng mìng nán kě cháng bǎo",
                chinese: "一 者 自 念 ‧ 我 此 形 命 ‧ 難 可 常 保"
            ),
            Verse(
                number: 121,
                text: "One morning, it will decay and disperse without knowing when this body will return.",
                pinyin: "yì zhāo sàn huài bù zhī cǐ shēn hé shí kě fù",
                chinese: "一 朝 散 壞 ‧ 不 知 此 身 ‧ 何 時 可 復"
            ),
            Verse(
                number: 122,
                text: "If I continue to not value the buddhas and worthy sages, then I will surely meet evil friends and create plenty of unwholesome karma.",
                pinyin: "ruò fù bù zhí zhū fó xián shèng hū féng è yǒu zào zhòng zuì yè",
                chinese: "若 復 不 值 諸 佛 賢 聖 ‧ 忽 逢 惡 友 ‧ 造 衆 罪 業"
            ),
            Verse(
                number: 123,
                text: "Then, I will fall into the abyss of the dangerous realms.",
                pinyin: "fù yīng duò luò shēn kēng xiǎn qù",
                chinese: "復 應 墮 落 深 坑 險 趣"
            ),
            Verse(
                number: 124,
                text: "Second, think to oneself, although I have been able to encounter the Tathāgata's proper Dharma in this life,",
                pinyin: "èr zhě zì niàn wǒ cǐ shēng zhōng suī dé zhí yù rú lái zhèng fǎ",
                chinese: "二 者 自 念 ‧ 我 此 生 中 ‧ 雖 得 值 遇 ‧ 如 來 正 法"
            ),
            Verse(
                number: 125,
                text: "I do not work to propagate the sacred seeds of the Buddhadharma; purify my body, speech, and mind; and abide in virtuous Dharmas.",
                pinyin: "bú wèi fó fǎ shào jì shèng zhǒng jìng shēn kǒu yì shàn fǎ zì jū",
                chinese: "不 為 佛 法 紹 繼 聖 種 ‧ 淨 身 口 意 ‧ 善 法 自 居"
            ),
            Verse(
                number: 126,
                text: "Up until now, we behaved unwholesomely in private and concealed these actions, saying that others will not know and that nobody saw it.",
                pinyin: "ér jīn wǒ děng sī zì zuò è ér fù fù cáng yán tā bù zhī wèi bǐ bú jiàn",
                chinese: "而 今 我 等 ‧ 私 自 作 惡 ‧ 而 復 覆 藏 。 言 他 不 知 ‧ 謂 彼 不 見"
            ),
            Verse(
                number: 127,
                text: "We hid these in our minds and were arrogant and shameless.",
                pinyin: "yǐn tè zài xīn ào rán wú kuì",
                chinese: "隱 慝 在 心 ‧ 傲 然 無 愧"
            ),
            Verse(
                number: 128,
                text: "This is a truly ignorant mistake indeed.",
                pinyin: "cǐ shí tiān xià yú huò zhī shèn",
                chinese: "此 實 天 下 ‧ 愚 惑 之 甚"
            ),
            Verse(
                number: 129,
                text: "Now, the buddhas of the ten directions, great bodhisattvas, celestial beings, deities, and sages have manifested.",
                pinyin: "jí jīn xiàn yǒu shí fāng zhū fó zhū dà pú sà zhū tiān shén xiān",
                chinese: "卽 今 現 有 十 方 諸 佛 、 諸 大 菩 薩 、 諸 天 神 仙"
            ),
            Verse(
                number: 130,
                text: "When have they not used their pure celestial eyes to see the evil transgressions that we committed?",
                pinyin: "hé céng bù yǐ qīng jìng tiān yǎn jiàn yú wǒ děng suǒ zuò zuì è",
                chinese: "何 曾 不 以 清 淨 天 眼 ‧ 見 於 我 等 ‧ 所 作 罪 惡"
            ),
            Verse(
                number: 131,
                text: "Furthermore, there are visible and invisible spirits that record offenses and merits without a hair of error.",
                pinyin: "yòu fù yōu xiǎn líng qí zhù jì zuì fú xiān háo wú chā",
                chinese: "又 復 幽 顯 靈 祇 ‧ 注 記 罪 福 ‧ 纖 毫 無 差"
            ),
            Verse(
                number: 132,
                text: "Regarding a person who has committed transgressions, at the end of their life, the Ox-Headed Wardens of Hell record their essence and spirit, debating and investigating their rights and wrongs before King Yāma.",
                pinyin: "fú lùn zuò zuì zhī rén mìng zhōng zhī hòu niú tóu yù zú lù qí jīng shén zài yán luó wang suǒ biàn hé shì fēi",
                chinese: "夫 論 作 罪 之 人 ‧ 命 終 之 後 ‧ 牛 頭 獄 卒 ‧ 錄 其 精 神 ‧ 在 閻 羅 王 所 ‧ 辯 覈 是 非"
            ),
            Verse(
                number: 133,
                text: "At this time, all of their enemies come to testify, each saying, 'You mutilated my body, then fried, boiled, steamed, and roasted it,'",
                pinyin: "dāng ěr zhī shí yí qiè yuàn duì jiē lái zhèng jù gè yán rǔ xiān tú lù wǒ shēn pào zhǔ zhēng zhì",
                chinese: "當 爾 之 時 ‧ 一 切 怨 對 ‧ 皆 來 證 據 。 各 言 汝 先 屠 戮 我 身 ‧ 炮 煮 蒸 炙"
            ),
            Verse(
                number: 134,
                text: "or, 'You first robbed me of all of my wealth and possessions, then separated me from my family. Today, I finally get to take advantage of you.'",
                pinyin: "huò xiān bō duó yú wǒ yí qiè cái bǎo lí wǒ juàn shǔ wǒ yú jīn rì shǐ dé rǔ biàn",
                chinese: "或 先 剝 奪 於 我 ‧ 一 切 財 寶 ‧ 離 我 眷 屬 。 我 於 今 日 ‧ 始 得 汝 便"
            ),
            Verse(
                number: 135,
                text: "When they appear and testify, how could anybody dare deny [their testimonies]?",
                pinyin: "yú shí xiàn qián zhèng jù hé dé gǎn huì",
                chinese: "於 時 現 前 證 據 。 何 得 敢 諱"
            ),
            Verse(
                number: 136,
                text: "One can only accept the retribution of past calamities willingly.",
                pinyin: "wéi yīng gān xīn fēn shòu sù yāng",
                chinese: "惟 應 甘 心 分 受 宿 殃"
            ),
            Verse(
                number: 137,
                text: "As the sūtras explain, the hells do not punish people unjustly.",
                pinyin: "rú jīng suǒ míng dì yù zhī zhōng bù wǎng zhì rén",
                chinese: "如 經 所 明 ‧ 地 獄 之 中 ‧ 不 枉 治 人"
            ),
            Verse(
                number: 138,
                text: "If someone forgets the many transgressions they habitually committed, then at the end of their life, then the locations where they committed the offense and all of the forms appear before them.",
                pinyin: "ruò qí ping sù suǒ zuò zhòng zuì xīn zì wàng shī zhě lín mìng zhōng shí zào è zhī chù yí qiè zhū xiāng jiē xiàn zài qián",
                chinese: "若 其 平 素 所 作 衆 罪 ‧ 心 自 忘 失 者 ‧ 臨 命 終 時 ‧ 造 惡 之 處 ‧ 一 切 諸 相 ‧ 皆 現 在 前"
            ),
            Verse(
                number: 139,
                text: "Each of them say, 'In the past, you did such and such a deed to me. How could you deny this now?'",
                pinyin: "gè yán rǔ xī zài yú wǒ biān zuò rú shì zuì jīn hé dé huì",
                chinese: "各 言 汝 昔 ‧ 在 於 我 邊 ‧ 作 如 是 罪 ‧ 今 何 得 諱"
            ),
            Verse(
                number: 140,
                text: "At this time, the transgressor has nowhere to conceal [the offenses].",
                pinyin: "shì shí zuò zuì zhī rén wú cáng yǐn chù",
                chinese: "是 時 作 罪 之 人 ‧ 無 藏 隱 處"
            ),
            Verse(
                number: 141,
                text: "Thus, King Yāma clenches his teeth, sentencing them to hell.",
                pinyin: "yú shì yán luó wang qiè chǐ hē zé jiāng fù dì yù",
                chinese: "於 是 閻 羅 王 ‧ 切 齒 呵 責 ‧ 將 付 地 獄"
            ),
            Verse(
                number: 142,
                text: "Even after limitless kalpas, they are unable to seek an escape.",
                pinyin: "lì wú liàng jié qiú chū mò yóu",
                chinese: "歷 無 量 劫 ‧ 求 出 莫 由"
            ),
            Verse(
                number: 143,
                text: "This matter is not distant, nor does it concern others.",
                pinyin: "cǐ shì bù yuǎn bù guān tā rén",
                chinese: "此 事 不 遠 。 不 關 他 人"
            ),
            Verse(
                number: 144,
                text: "It is on our bodies—we committed the deeds ourselves and we will undergo the retribution ourselves.",
                pinyin: "zhèng shì wǒ shēn zì zuò zì shòu",
                chinese: "正 是 我 身 ‧ 自 作 自 受"
            ),
            Verse(
                number: 145,
                text: "Although the closest relationship is between father and son, once we face the end, there is nobody who can undergo the retribution on another's behalf.",
                pinyin: "suī fù zi zhì qīn yí dàn duì zhì wú dài shòu zhě",
                chinese: "雖 父 子 至 親 ‧ 一 旦 對 至 ‧ 無 代 受 者"
            ),
            Verse(
                number: 146,
                text: "We have all obtained this human body, which is not infected with various illnesses.",
                pinyin: "wǒ děng xiāng yǔ dé cǐ rén shēn tǐ wú zhòng jí",
                chinese: "我 等 相 與 得 此 人 身 ‧ 體 無 衆 疾"
            ),
            Verse(
                number: 147,
                text: "We should each be diligent and work urgently, greatly fearing that when the end arrives, it will be too late to reform.",
                pinyin: "gè zì nǔ lì yǔ xìng mìng jìng dà bù zhì shí huǐ wú suǒ jí",
                chinese: "各 自 努 力 ‧ 與 性 命 競 ‧ 大 怖 至 時 ‧ 悔 無 所 及"
            ),
            Verse(
                number: 148,
                text: "Because of this, we sincerely request compassion through repenting and reforming.",
                pinyin: "shì gù zhì xīn qiú āi chàn huǐ",
                chinese: "是 故 至 心 ‧ 求 哀 懺 悔"
            ),
            Verse(
                number: 149,
                text: "From beginningless time until today, we have accumulated ignorance which obstructs our mind's eye,",
                pinyin: "zhòng děng zì cóng wú shǐ yǐ lái zhì yú jīn rì jī jù wú míng zhàng bì xīn mù",
                chinese: "某 等 自 從 無 始 以 來 ‧ 至 于 今 日 ‧ 積 聚 無 明 ‧ 障 蔽 心 目"
            ),
            Verse(
                number: 150,
                text: "went along with the nature of afflictions and committed transgressions in the Three Periods.",
                pinyin: "suí fán nǎo xìng zào sān shì shì",
                chinese: "隨 煩 惱 性 ‧ 造 三 世 罪"
            ),
            Verse(
                number: 151,
                text: "Today, we sincerely repent and reform for all afflictions, up to and including the Four Foundations [of Afflictions] since beginningless time.",
                pinyin: "huò dān rǎn ài zhuó qǐ tān yù fán nǎo",
                chinese: "或 耽 染 愛 著 ‧ 起 貪 欲 煩 惱"
            ),
            Verse(
                number: 152,
                text: "Attachments and other conditioned afflictions, whether they be from indulging in passion and attachments, giving rise the afflictions of desire;",
                pinyin: "huò chēn huì fèn nù huái hài fán nǎo",
                chinese: "或 瞋 恚 忿 怒 ‧ 懷 害 煩 惱"
            ),
            Verse(
                number: 153,
                text: "or harboring the afflictions of violence through aversion and anger;",
                pinyin: "huò xīn kuì hūn méng bù liǎo fán nǎo",
                chinese: "或 心 憒 惛 懵 ‧ 不 了 煩 惱"
            ),
            Verse(
                number: 154,
                text: "or being unable to end our afflictions due to mental delusions;",
                pinyin: "huò wǒ màn zì gāo qīng ào fán nǎo",
                chinese: "或 我 慢 自 高 ‧ 輕 傲 煩 惱"
            ),
            Verse(
                number: 155,
                text: "or underestimating afflictions due to arrogance;",
                pinyin: "yóu yù fán nǎo",
                chinese: "猶 豫 煩 惱"
            ),
            Verse(
                number: 156,
                text: "or the afflictions of hesitation due to doubts regarding the Noble Path.",
                pinyin: "bàng wú yīn guǒ",
                chinese: "謗 無 因 果"
            ),
            Verse(
                number: 157,
                text: "Or the afflictions of wrong view due to falsely claiming that there is no cause and effect;",
                pinyin: "xié jiàn fán nǎo",
                chinese: "邪 見 煩 惱"
            ),
            Verse(
                number: 158,
                text: "or the afflictions of attachment to self due to not understanding conditioned existence;",
                pinyin: "bù shì yuán jiǎ zhuó wǒ fán nǎo",
                chinese: "不 識 緣 假 ‧ 著 我 煩 惱"
            ),
            Verse(
                number: 159,
                text: "or clinging to the afflictions of eternalism and nihilism due to not understanding the Three Periods;",
                pinyin: "mí yú sān shì zhí duàn cháng fán nǎo",
                chinese: "迷 於 三 世 ‧ 執 斷 常 煩 惱"
            ),
            Verse(
                number: 160,
                text: "or giving rise to the afflictions of attachment to views due to becoming familiar with evil teachings;",
                pinyin: "péng xiá è fǎ qǐ jiàn qǔ fán nǎo",
                chinese: "朋 狎 惡 法 ‧ 起 見 取 煩 惱"
            ),
            Verse(
                number: 161,
                text: "or creating the afflictions of attachment to precepts (rites and rituals) due to apprenticing under deviant teachers.",
                pinyin: "pì bǐng xié shī zào jiè qǔ fán nǎo",
                chinese: "僻 稟 邪 師 ‧ 造 戒 取 煩 惱"
            ),
            Verse(
                number: 162,
                text: "Today, we sincerely repent and reform for all of these.",
                pinyin: "nǎi zhì yí qiè sì zhí héng jì fán nǎo jīn rì zhì chéng xī jiē chàn huǐ",
                chinese: "乃 至 一 切 四 執 ‧ 橫 計 煩 惱 。 今 日 至 誠 ‧ 悉 皆 懺 悔"
            ),
            Verse(
                number: 163,
                text: "Furthermore, since beginningless time until today, we disturbed and harmed all worthy sages and sentient beings in the Six Realms and Four Forms of Existence",
                pinyin: "yòu fù wú shǐ yǐ lái zhì yú jīn rì",
                chinese: "又 復 無 始 以 來 ‧ 至 于 今 日"
            ),
            Verse(
                number: 164,
                text: "through giving rise to limitless and boundless afflictions such as the afflictions of stinginess due to attachments to protecting and cherishing our property.",
                pinyin: "shǒu xí jiān zhuó qǐ qiān lìn fán nǎo",
                chinese: "守 惜 堅 著 ‧ 起 慳 吝 煩 惱"
            ),
            Verse(
                number: 165,
                text: "The afflictions of creation due to not restraining the Six Emotions;",
                pinyin: "bú shè liù qíng shē dàn fán nǎo",
                chinese: "不 攝 六 情 ‧ 奢 誕 煩 惱"
            ),
            Verse(
                number: 166,
                text: "the afflictions of intolerance due to harmful thoughts;",
                pinyin: "xīn xíng bì è bù rěn fán nǎo",
                chinese: "心 行 弊 惡 ‧ 不 忍 煩 惱"
            ),
            Verse(
                number: 167,
                text: "the afflictions of laxity due to being lazy and indulgent;",
                pinyin: "dài duò huǎn zòng bù qín fán nǎo",
                chinese: "怠 惰 緩 縱 ‧ 不 勤 煩 惱"
            ),
            Verse(
                number: 168,
                text: "the afflictions of gross and nuanced discrimination due to doubts and restlessness;",
                pinyin: "yí lǜ zào dòng jué guān fán nǎo",
                chinese: "疑 慮 躁 動 ‧ 覺 觀 煩 惱"
            ),
            Verse(
                number: 169,
                text: "the afflictions of not knowing and not understanding due to delusional interaction with one's environment;",
                pinyin: "chù jìng mí huò wú zhī jiě fán nǎo",
                chinese: "觸 境 迷 惑 ‧ 無 知 解 煩 惱"
            ),
            Verse(
                number: 170,
                text: "giving rise to the afflictions of self and other due to according with the Eight Worldly Winds.",
                pinyin: "suí shì bā fēng shēng bǐ wǒ fán nǎo",
                chinese: "隨 世 八 風 ‧ 生 彼 我 煩 惱"
            ),
            Verse(
                number: 171,
                text: "The afflictions of insincerity due to cajolery and flattery;",
                pinyin: "chǎn qū miàn yù bù zhí xīn fán nǎo",
                chinese: "諂 曲 面 譽 ‧ 不 直 心 煩 惱"
            ),
            Verse(
                number: 172,
                text: "the afflictions of discord due to being fiercely violent and unapproachable;",
                pinyin: "qiáng bù tiáo hé fán nǎo",
                chinese: "強 獷 難 觸 ‧ 不 調 和 煩 惱"
            ),
            Verse(
                number: 173,
                text: "the afflictions of harboring resentment due to irritability and fussiness;",
                pinyin: "duō hán hèn fán nǎo",
                chinese: "易 忿 難 悅 ‧ 多 含 恨 煩 惱"
            ),
            Verse(
                number: 174,
                text: "the afflictions of ruthlessness due to piercing envy;",
                pinyin: "jí dù jī cì hěn lì fán nǎo",
                chinese: "嫉 妬 擊 刺 ‧ 狠 戾 煩 惱"
            ),
            Verse(
                number: 175,
                text: "the afflictions of maliciousness due to being vicious and violent;",
                pinyin: "xiōng xiǎn bào hài cǎn dú fán nǎo",
                chinese: "凶 險 暴 害 ‧ 慘 毒 煩 惱"
            ),
            Verse(
                number: 176,
                text: "the afflictions of attaching to forms due to denying the Noble Truths.",
                pinyin: "guāi bèi shèng dì zhí xiàng fán nǎo",
                chinese: "乖 背 聖 諦 ‧ 執 相 煩 惱"
            ),
            Verse(
                number: 177,
                text: "Gave rise the afflictions of delusion through [misunderstanding] suffering, its origin, its cessation, and the path to its cessation;",
                pinyin: "yú kǔ jí miè dào shēng diān dǎo fán nǎo",
                chinese: "於 苦 集 滅 道 ‧ 生 顚 倒 煩 惱"
            ),
            Verse(
                number: 178,
                text: "the afflictions of cyclic existence due to following birth and death as well as the Twelve Links of Dependent Origination;",
                pinyin: "suí cóng shēng sǐ shí èr yīn yuán lún zhuǎn fán nǎo",
                chinese: "隨 從 生 死 ‧ 十 二 因 緣 ‧ 輪 轉 煩 惱"
            ),
            Verse(
                number: 179,
                text: "up to and including as many afflictions as the grains of sand in the Ganges River due to ignorance and the Foundations [of Afflictions] since beginningless time.",
                pinyin: "nǎi zhì wú shǐ wú míng zhù dì héng shā fán nǎo",
                chinese: "乃 至 無 始 無 明 住 地 ‧ 恆 沙 煩 惱"
            ),
            Verse(
                number: 180,
                text: "And giving rise to the afflictions of the suffering of the Three Realms through establishing the Four Foundations [of Afflictions].",
                pinyin: "qǐ sì zhù dì gòu yú sān jiè kǔ guǒ fán nǎo wú liàng wú biān",
                chinese: "起 四 住 地 ‧ 構 於 三 界 ‧ 苦 果 煩 惱 ‧ 無 量 無 邊"
            ),
            Verse(
                number: 181,
                text: "Today, we confess these to the Buddhas, honored Dharma, and sacred Sangha of the ten directions to repent and reform for them all.",
                pinyin: "nǎo luàn xián shèng liù dào sì shēng jīn rì fā lù xiàng shí fāng fó zūn fǎ shèng zhòng jiē xī chàn huǐ",
                chinese: "惱 亂 賢 聖 ‧ 六 道 四 生 。 今 日 發 露 ‧ 向 十 方 佛 、 尊 法 、 聖 眾 ‧ 皆 悉 懺 悔"
            ),
            Verse(
                number: 182,
                text: "Through the merits and virtues born from repenting and reforming all afflictions born of mental karma such as desire, aversion, and ignorance.",
                pinyin: "yuàn zhòng děng chéng shì chàn huǐ yì yè suǒ qǐ tān chēn chī děng yí qiè fán nǎo",
                chinese: "願 某 等 承 是 懺 悔 ‧ 意 業 所 起 ‧ 貪 瞋 癡 等 ‧ 一 切 煩 惱"
            ),
            Verse(
                number: 183,
                text: "We vow that for birth after birth, lifetime after lifetime, we will remove the banner of arrogance;",
                pinyin: "suǒ shēng gōng dé shēng shēng shì shì zhé jiāo màn chuáng",
                chinese: "所 生 功 德 ‧ 生 生 世 世 ‧ 折 憍 慢 幢"
            ),
            Verse(
                number: 184,
                text: "remove the roots of doubt;",
                pinyin: "jié ài yù shuǐ",
                chinese: "竭 愛 欲 水"
            ),
            Verse(
                number: 185,
                text: "cut through the net of wrong views;",
                pinyin: "miè chēn huì huǒ pò yú chī àn bá duàn yí gēn liè zhū jiàn wǎng",
                chinese: "滅 瞋 恚 火 ‧ 破 愚 癡 闇 ‧ 拔 斷 疑 根 ‧ 裂 諸 見 網"
            ),
            Verse(
                number: 186,
                text: "truly understand the Three Realms as a prison, the Four Elements as venomous snakes, the Five Aggregates as bandits, the Six Senses as a formation of emptiness, and passion as an imposter trying to seem friendly and virtuous.",
                pinyin: "shēn shí sān jiè yóu rú láo yù sì dà dú shé wǔ yīn yuàn zéi liù rù kōng jù ài zhà qīn shàn",
                chinese: "深 識 三 界 ‧ 猶 如 牢 獄 。 四 大 毒 蛇 ‧ 五 陰 怨 賊 ‧ 六 入 空 聚 ‧ 愛 詐 親 善"
            ),
            Verse(
                number: 187,
                text: "Dry the river of passion and desires;",
                pinyin: "xiū bā shèng dào duàn wú míng yuán",
                chinese: "修 八 聖 道 ‧ 斷 無 明 源"
            ),
            Verse(
                number: 188,
                text: "extinguish the flames of aversion and anger;",
                pinyin: "zhèng xiàng niè pán bù xiū bù xī",
                chinese: "正 向 涅 槃 ‧ 不 休 不 息"
            ),
            Verse(
                number: 189,
                text: "dispel the darkness of ignorance and delusion;",
                pinyin: "sān shí qī pǐn xīn xīn xiāng xù",
                chinese: "三 十 七 品 ‧ 心 心 相 續"
            ),
            Verse(
                number: 190,
                text: "practice the Noble Eightfold Path and sever the source of ignorance; progress towards nirvana without resting or ceasing; maintain the Thirty-Seven Factors of Awakening in every thought; and always be able to manifest the Ten Pāramitās.",
                pinyin: "shí bō luó mì cháng dé xiàn qián",
                chinese: "十 波 羅 蜜 ‧ 常 得 現 前"
            ),
            Verse(
                number: 191,
                text: "Having repented and reformed, sincerely and faithfully venerate the eternally abiding Triple Gem!",
                pinyin: "chàn huǐ fā yuàn yǐ zhì xīn xìn lǐ cháng zhù sān bǎo",
                chinese: "懺 悔 發 願 已 ‧ 至 心 信 禮 常 住 三 寶"
            )
        ]
        for verse in waterChapter5.verses {
            verse.chapter = waterChapter5
        }
        
        let waterChapter6 = Chapter(number: 6, title: "Closing and Dedication")
        waterChapter6.text = waterRepentance
        waterChapter6.verses = [
            Verse(
                number: 1,
                text: "How many past transgressions were there for the ulcer to resemble a human face?",
                pinyin: "chuāng rú rén miàn sù hàn hé duō",
                chinese: "瘡 如 人 面 ‧ 宿 憾 何 多"
            ),
            Verse(
                number: 2,
                text: "With one handful of [water from] the pure spring, it disappeared entirely.",
                pinyin: "qīng quán yì jū jí xiāo mó",
                chinese: "清 泉 一 掬 卽 消 磨"
            ),
            Verse(
                number: 3,
                text: "Giving rise to empathy for himself and then for others, [Master Wuda] expounded on this as a method of repentance;",
                pinyin: "mǐn jǐ fù lián tuó shù wèi chàn mó",
                chinese: "愍 己 復 憐 佗 。 述 為 懺 摩"
            ),
            Verse(
                number: 4,
                text: "its waves of benevolence cleanse perpetually!",
                pinyin: "wàn gǔ mù ēn bō",
                chinese: "萬 古 沐 恩 波"
            ),
            Verse(
                number: 5,
                text: "Homage to the Equal Awakening Stage Bodhisattva-Mahāsattvas!",
                pinyin: "▲ ná mó děng jué dì pú sà mó hē sà (3x)",
                chinese: "南 無 等 覺 地 菩 薩 摩 訶 薩"
            ),
            Verse(
                number: 6,
                text: "Prayer of Exiting Repentance, Scroll One",
                pinyin: "● chū chàn wén",
                chinese: "出 懺 文"
            ),
            Verse(
                number: 7,
                text: "Respectfully listen! [The Buddha's] wondrous, purple-gold appearance accords with conditions to descend amidst a shower of blossoms in the forest.",
                pinyin: "gōng wén zǐ jīn miào xiāng suí yuán fù gǎn yú huá yǔ cóng zhōng",
                chinese: "恭 聞 ‧ 紫 金 妙 相 ‧ 隨 緣 赴 感 於 華 雨 叢 中"
            ),
            Verse(
                number: 8,
                text: "Your kind countenance, which resembles the full moon, empathizes with beings and shines radiantly from within the clouds of incense smoke.",
                pinyin: "mǎn yuè cí róng mǐn wù chuí guāng yú xiāng yān yún lǐ",
                chinese: "滿 月 慈 容 ‧ 愍 物 垂 光 於 香 烟 雲 裡"
            ),
            Verse(
                number: 9,
                text: "Seated upon the lion throne, you expound with a subtle and wondrous voice.",
                pinyin: "zuò shī zi zuò yǎn wēi miào yīn",
                chinese: "坐 獅 子 座 ‧ 演 微 妙 音"
            ),
            Verse(
                number: 10,
                text: "May you radiate with the brilliance of a thousand suns and witness us in our momentary dedication of merits.",
                pinyin: "yuàn shū qiān rì zhī guāng míng jiàn wǒ yī shí zhī huí xiàng",
                chinese: "願 舒 千 日 之 光 明 ‧ 鑑 我 一 時 之 回 向"
            ),
            Verse(
                number: 11,
                text: "On behalf of this assembly of your disciples, we have gathered the present pure assembly to practice the efficacious text of samādhi.",
                pinyin: "shàng lái fèng wèi qiú chàn mǒu děng pǔ jí xiàn xiàn qīng zhòng xūn xiū sān mèi ling wén",
                chinese: "上 來 奉 為 求 懺 某 等 ‧ 普 集 現 前 清 眾 ‧ 熏 修 三 昧 靈 文"
            ),
            Verse(
                number: 12,
                text: "We have now completed the merits and fruitions of the first scroll.",
                pinyin: "jīn dāng dì yī juàn gōng guǒ kè xié",
                chinese: "今 當 第 一 卷 ‧ 功 果 克 諧"
            ),
            Verse(
                number: 13,
                text: "Within the sanctuary, we and our fellow practitioners have burned incense, scattered flowers, kneeled, and joined our palms",
                pinyin: "wǒ zhū xíng rén yú qí tán nèi shāo xiāng sàn huā hú guì hé zhǎng",
                chinese: "我 諸 行 人 ‧ 於 其 壇 內 ‧ 燒 香 散 花 ‧ 胡 跪 合 掌"
            ),
            Verse(
                number: 14,
                text: "to repent for past transgressions through relying on the text, walked and circumambulated, as well as invoked and sung the [Buddha's] profound names.",
                pinyin: "yī wén chàn guò xíng dào rào xuán chēng chàng hóng míng",
                chinese: "依 文 懺 過 ‧ 行 道 遶 旋 ‧ 稱 唱 洪 名"
            ),
            Verse(
                number: 15,
                text: "May all of the merits and virtues accumulated [through these practices] be first extended in dedication to the eternally abiding Triple Gem of True Compassion;",
                pinyin: "suǒ jí gōng dé xiān shēn huí xiàng cháng zhù zhēn cí sān bǎo",
                chinese: "所 集 功 德 ‧ 先 伸 回 向 常 住 真 慈 ‧ 三 寶"
            ),
            Verse(
                number: 16,
                text: "to the Dharma protectors and various devas beneath the assembly;",
                pinyin: "huì xià hù fǎ zhū tiān",
                chinese: "會 下 ‧ 護 法 諸 天"
            ),
            Verse(
                number: 17,
                text: "to the spirits of the higher, middle, and lower realms;",
                pinyin: "shàng zhōng xià jiè zhī shén qí",
                chinese: "上 中 下 界 之 神 祇"
            ),
            Verse(
                number: 18,
                text: "as well as to the limitless spirits both near and far.",
                pinyin: "yuǎn jìn wú biān zhī líng kuàng",
                chinese: "遠 近 無 邊 之 靈 貺"
            ),
            Verse(
                number: 19,
                text: "We also humbly vow that through these merits and virtues, all will give rise to a mind of joy,",
                pinyin: "fú yuàn rú zī gōng dé xián shēng huān xǐ zhī xīn",
                chinese: "伏 願 ‧ 如 茲 功 德 ‧ 咸 生 歡 喜 之 心"
            ),
            Verse(
                number: 20,
                text: "blessings will flow and irrigate the human realm and the heavens above,",
                pinyin: "liú fú zé yú rén jiān tiān shàng",
                chinese: "流 福 澤 於 人 間 天 上"
            ),
            Verse(
                number: 21,
                text: "transform those in this and other realms.",
                pinyin: "xuān huà rì yú cǐ jiè tā fāng",
                chinese: "宣 化 日 於 此 界 他 方"
            ),
            Verse(
                number: 22,
                text: "The virtuous results from perfecting the Sanctuary of Awakening are dedicated on behalf of this assembly, your disciples who are seeking repentance,",
                pinyin: "yuán mǎn dào chǎng chū shēng shàn guǒ zhuān wèi qiú chàn mǒu děng",
                chinese: "圓 滿 道 場 ‧ 出 生 善 果 ‧ 專 為 求 懺 某 等"
            ),
            Verse(
                number: 23,
                text: "may all transgressions be absolved and all offenses be resolved.",
                pinyin: "miè zuì shì qiān yíng xiáng jí fú",
                chinese: "滅 罪 釋 愆 ‧ 迎 祥 集 福"
            ),
            Verse(
                number: 24,
                text: "May all seek rebirth in the Pure Land.",
                pinyin: "qiú shēng jìng tǔ",
                chinese: "求 生 淨 土"
            ),
            Verse(
                number: 25,
                text: "Furthermore, we humbly wish that all karmic transgressions in this life melt like ice,",
                pinyin: "fú jì yì shēng zuì yè bīng xiāo",
                chinese: "伏 冀 ‧ 一 生 罪 業 冰 消"
            ),
            Verse(
                number: 26,
                text: "that all karmic conditions be purified,",
                pinyin: "yí qiè yè yuán qīng jìng",
                chinese: "一 切 業 緣 清 淨"
            ),
            Verse(
                number: 27,
                text: "that we all are single-mindedly awakened and turn towards the truth of One Reality,",
                pinyin: "yì xīn jiě wù xiàng yī lǐ zhī zhēn rú",
                chinese: "一 心 解 悟 ‧ 向 一 理 之 眞 如"
            ),
            Verse(
                number: 28,
                text: "that we all have a single thought of returning to the light and create the wondrous path of the One Vehicle.",
                pinyin: "yí niàn huí guāng zào yí chèng zhī miào dào",
                chinese: "一 念 回 光 ‧ 造 一 乘 之 妙 道"
            ),
            Verse(
                number: 29,
                text: "May all conditions of suffering become instruments of bliss,",
                pinyin: "zhuǎn kǔ yuán ér chéng lè jù",
                chinese: "轉 苦 緣 而 成 樂 具"
            ),
            Verse(
                number: 30,
                text: "and may karmic afflictions be showered upon so that all obtain refreshing coolness.",
                pinyin: "sǎ yè nǎo ér dé qīng liáng",
                chinese: "灑 業 惱 而 得 清 涼"
            ),
            Verse(
                number: 31,
                text: "May our ancestors and those who have passed away affirm their rebirth in the Pure Land;",
                pinyin: "zǔ mí xiān wang jué ding wǎng shēng yú jìng jiè",
                chinese: "祖 禰 先 亡 ‧ 決 定 往 生 於 淨 界"
            ),
            Verse(
                number: 32,
                text: "may our surviving relatives continually enjoy the extents of their natural lifespan.",
                pinyin: "hé mén rén juàn fāng dāng yǒng xiǎng yú xiá líng",
                chinese: "合 門 人 眷 ‧ 方 當 永 享 於 遐 齡"
            ),
            Verse(
                number: 33,
                text: "May both our friends and foes bathe in the waves of benevolence together;",
                pinyin: "děng yuān qīn ér gong shè ēn bō",
                chinese: "等 冤 親 而 共 涉 恩 波"
            ),
            Verse(
                number: 34,
                text: "and may both ordinary and sacred beings ascend to the jeweled ground in unison.",
                pinyin: "yǔ fán shèng ér qí dēng bǎo dì",
                chinese: "與 凡 聖 而 齊 登 寶 地"
            ),
            Verse(
                number: 35,
                text: "Now, we have relied upon the text in repentance and reform.",
                pinyin: "jīn zé yī wén chàn huǐ",
                chinese: "今 則 依 文 懺 悔"
            ),
            Verse(
                number: 36,
                text: "Still fearing that the finer [transgressions] are difficult to eradicate, we again implore the honored assembly to seek repentance and reform together!",
                pinyin: "yòu kǒng wéi xì nán chú zài láo zūn zhòng tóng qiú chàn huǐ",
                chinese: "又 恐 微 細 難 除 ‧ 再 勞 尊 眾 ‧ 同 求 懺 悔"
            ),
            Verse(
                number: 37,
                text: "Homage to Samantabhadra Bodhisattva-Mahāsattva!",
                pinyin: "▲ ná mó pǔ xián wáng pú sà mó hē sà (3x)",
                chinese: "南 無 普 賢 王 菩 薩 摩 訶 薩"
            ),
            Verse(
                number: 38,
                text: "[Seven Buddhas Offense-Extinguishing Mantra]",
                pinyin: "qī fó miè zuì zhēn yán",
                chinese: "七 佛 滅 罪 真 言"
            ),
            Verse(
                number: 39,
                text: "ripa ripate kuha kuhate tranite nigalate vimarite mahāgate jāmlamcamte svāhā!",
                pinyin: "● li po li po di qiu he qiu he di tuo luo ni di ni he luo di pi li ni di mo he qie di zhen ling qian di sa po he (3x)",
                chinese: "離 婆 離 婆 帝 ‧ 求 訶 求 訶 帝 ‧ 陀 羅 尼 帝 ‧ 尼 訶 囉 帝 ‧ 毗 黎 你 帝 ‧ 摩 訶 伽 帝 ‧ 真 陵 乾 帝 ‧ 莎 婆 訶"
            )
        ]
        for verse in waterChapter6.verses {
            verse.chapter = waterChapter6
        }
        
        waterRepentance.chapters.append(contentsOf: [waterChapter1, waterChapter2, waterChapter3, waterChapter4, waterChapter5, waterChapter6])
        context.insert(waterRepentance)
        }
        
        // Great Compassion Repentance
        if shouldLoadGreatCompassionRepentance {
        let greatCompassionRepentance = BuddhistText(
            title: "Great Compassion Repentance (大悲咒)",
            author: "Buddha",
            textDescription: "Liturgy of the Great Compassion Repentance of the Thousand-Handed & Thousand-Eyed One",
            category: "Liturgy",
            coverImageName: "GreatCompassionRepentance"
        )
        
        let gcChapter1 = Chapter(number: 1, title: "Opening and Invocations")
        gcChapter1.text = greatCompassionRepentance
        gcChapter1.verses = [
            Verse(
                number: 1,
                text: "[Mindfully Invoke the Sacred Title]",
                pinyin: "chēng niàn shèng hào",
                chinese: "稱念聖號"
            ),
            Verse(
                number: 2,
                text: "Homage to Great Compassion, Avalokiteśvara Bodhisattva!",
                pinyin: "ná mó dà bēi guān shì yīn pú sà",
                chinese: "南無大悲觀世音菩薩"
            ),
            Verse(
                number: 3,
                text: "[Pure Water of the Willow Sprig Praise]",
                pinyin: "yáng zhī jìng shuǐ zàn",
                chinese: "楊枝淨水讚"
            ),
            Verse(
                number: 4,
                text: "Pure water of the willow sprig showers across the trichiliocosm.",
                pinyin: "yáng zhī jìng shuǐ piàn sǎ sān qiān",
                chinese: "楊枝淨水 偏灑三千"
            ),
            Verse(
                number: 5,
                text: "Its nature of emptiness has eight virtues benefitting human and celestial beings,",
                pinyin: "xìng kōng bà dé lì rén tiān",
                chinese: "性空八德利人天"
            ),
            Verse(
                number: 6,
                text: "extensively enhancing and lengthening blessings and longevity,",
                pinyin: "fú shòu guǎng zēng yán",
                chinese: "福壽廣增延"
            ),
            Verse(
                number: 7,
                text: "extinguishing sins and eliminating faults, blazing flames are transformed into red lotuses!",
                pinyin: "miè zuì xiāo qiān huǒ yàn huà hóng lián",
                chinese: "滅罪消愆 火燄化紅蓮"
            ),
            Verse(
                number: 8,
                text: "Homage to Avalokiteśvara Bodhisattva-Mahāsattva!",
                pinyin: "ná mó guān shì yīn pú sà mó hē sà (3x)",
                chinese: "南無觀世音菩薩摩訶薩"
            ),
            Verse(
                number: 9,
                text: "All be reverent and solemn!",
                pinyin: "yí qiè gōng jìng",
                chinese: "一切恭敬"
            ),
            Verse(
                number: 10,
                text: "Single-mindedly prostrate to the Eternally Abiding Triple Gem of the ten directions!",
                pinyin: "yì xīn dǐng lǐ shí fāng cháng zhù sān bǎo",
                chinese: "一心頂禮·十方常住三寶"
            ),
            Verse(
                number: 11,
                text: "Each in the assembly, all kneel down. Solemnly hold the incense and flowers and offer them in accordance with the Dharma.",
                pinyin: "shì zhū zhòng děng gè gè hú guì yán chí xiāng huá rú fă gòng yăng",
                chinese: "是諸眾等各各胡跪嚴持香華如法供養"
            ),
            Verse(
                number: 12,
                text: "May this cloud of incense and flowers pervade the realms of the ten directions,",
                pinyin: "yuàn cǐ xiāng huā yún piàn măn shí fāng jiè",
                chinese: "願此香花雲・偏滿十方界・"
            ),
            Verse(
                number: 13,
                text: "fill each and every buddha land with limitless fragrance and adornments,",
                pinyin: "yī yī zhū fó tù wú liàng xiāng zhuāng yán",
                chinese: "一一諸佛土・無量香莊嚴。"
            ),
            Verse(
                number: 14,
                text: "fulfill the bodhisattva path, and become the tathāgatha's fragrance!",
                pinyin: "jù zú pú sà dào chéng jiù rú lái xiāng",
                chinese: "具足菩薩道·成就如來香°"
            ),
            Verse(
                number: 15,
                text: "May these incense and flowers pervade the ten directions",
                pinyin: "wǒ cǐ xiāng huá piàn shí fāng",
                chinese: "我此香華偏十方"
            ),
            Verse(
                number: 16,
                text: "and become a subtle and wondrous platform of light; various kinds of celestial music, and precious celestial incenses; various celestial delicacies, and precious celestial robes;",
                pinyin: "yǐ wéi wéi miào guāng míng tái zhū tiān yīn yuè tiān bǎo xiāng zhū tiān yáo shàn tiān bǎo yī",
                chinese: "以為微妙光明臺・諸天音樂天寶香・諸天餚饍天寶衣・"
            ),
            Verse(
                number: 17,
                text: "and inconceivable and wondrous dharma sense objects. Each of these [six sense] objects manifests all sense objects; each of these [six sense] objects manifests all phenomena.",
                pinyin: "bù kě sī yì miào fă chén yī yī chén chū yí qiè chén yī yī chén chū yí qiè fă",
                chinese: "不可思議妙法塵・一一塵出一切塵 塵出一切法·"
            )
        ]
        for verse in gcChapter1.verses {
            verse.chapter = gcChapter1
        }
        
        let gcChapter2 = Chapter(number: 2, title: "Universal Offerings")
        gcChapter2.text = greatCompassionRepentance
        gcChapter2.verses = [
            Verse(
                number: 1,
                text: "[These offerings] spin and adorn each other without obstruction, spreading and arriving before the Triple Gem of the ten directions. And before all of the Triple Gem in the Dharma realms of",
                pinyin: "xuán zhuǎn wú ài hù zhuāng yán piàn zhì shí fāng sān bǎo qián shí fāng fǎ jiè sān bǎo qián",
                chinese: "旋轉無礙互莊嚴·偏至十方三寶前・十方法界三寶前・"
            ),
            Verse(
                number: 2,
                text: "the ten directions, my own body is making this offering, with each of my bodies appearing throughout Dharma Realms. [These offerings] do not interfere or obstruct each other,",
                pinyin: "xī yǒu wǒ shēn xiū gòng yăng yī yī jiě xī piàn få jiè bĩ bǐ wú zá wú zhàng ài",
                chinese: "悉有我身修供養・ 一皆悉编法界·彼彼無雜無障礙。"
            ),
            Verse(
                number: 3,
                text: "and until the limits of the future, they conduct the Buddha's work; [their fragrance] universally permeates all sentient beings in the Dharma Realms, and those who are permeated [by its fragrance] all give rise to the bodhi mind",
                pinyin: "jìn wèi lái jì zuò fó shì pù xūn fă jiè zhū zhòng shēng méng xūn jiē fā pú tí xīn",
                chinese: "盡未來際作佛事·普熏法界諸眾 生・蒙熏皆發菩提心。"
            ),
            Verse(
                number: 4,
                text: "and together enter the state of non-arising, awakening to the Buddha's wisdom!",
                pinyin: "tóng rù wú shēng zhèng fó zhì",
                chinese: "同入無生 證佛智"
            ),
            Verse(
                number: 5,
                text: "Having made offerings, all be reverent and solemn.",
                pinyin: "gòng yăng yǐ yí qiè gōng jìng",
                chinese: "供養巳・一切恭敬"
            ),
            Verse(
                number: 6,
                text: "Homage to Saddharmaprabhasa Tathagatha of the past, Avalokiteśvara Bodhisattva of the present.",
                pinyin: "ná mó guò qù zhèng fǎ míng rú lái xiàn qián guān shì yīn pú sà",
                chinese: "南無過去正法明如來 現前觀世音菩薩·"
            ),
            Verse(
                number: 7,
                text: "Having accomplished wonderful merits and virtue, you are replete in great kindness and compassion. With one body and mind, you manifest a thousand hands and eyes,",
                pinyin: "chéng miào gōng dé jù dà cí bēi yú yī shēn xīn xiàn qiān shòu",
                chinese: "成妙功德·具大慈悲·於一身心・現千手"
            ),
            Verse(
                number: 8,
                text: "illuminating and observing the Dharma Realms while protecting and supporting sentient beings, causing them to give rise to the vast and great aspiration for the Path and",
                pinyin: "yǎn zhào jiàn fă jiè hù chí zhòng shēng jīn fā guăng dà dào xīn",
                chinese: "眼・照見法界・護持眾 生。今發廣大道心。"
            )
        ]
        for verse in gcChapter2.verses {
            verse.chapter = gcChapter2
        }
        
        let gcChapter3 = Chapter(number: 3, title: "Prostrations to Buddhas")
        gcChapter3.text = greatCompassionRepentance
        gcChapter3.verses = [
            Verse(
                number: 1,
                text: "Single-mindedly prostrate to Our Teacher, Sakyamuni World-Honored One.",
                pinyin: "yī xīn dǐng lǐ běn shī shì jiā móu ní fó shì zūn",
                chinese: "一心頂禮·本師釋迦牟尼佛世尊"
            ),
            Verse(
                number: 2,
                text: "Single-mindedly prostrate to Western Pure Land, Amitabha World-Honored One.",
                pinyin: "yī xīn dǐng lǐ xī fāng jìng tǔ ō mí tuó fó shì zūn",
                chinese: "一心頂禮·西方淨土·阿彌陀佛世尊"
            ),
            Verse(
                number: 3,
                text: "Single-mindedly prostrate to Sahasraprabharaja-dhyāna-bhūmika World-Honored One of infinite millions of kalpas past.",
                pinyin: "yī xīn dǐng lǐ wú liàng yì jié qián qiān guāng wáng jìng zhù shì zūn",
                chinese: "一心頂禮·無量億劫前·千光王靜住世尊"
            ),
            Verse(
                number: 4,
                text: "Single-mindedly prostrate to the myriad buddhas, world-honored ones, of the past as numerous as the sands of ninety-nine million Ganges Rivers.",
                pinyin: "yī xīn dǐng lǐ guò qù jiù shí jiù yì jìng qié shā zhū fó shì zūn",
                chinese: "一心頂禮·過去九十九億殑伽沙諸佛世尊"
            ),
            Verse(
                number: 5,
                text: "Single-mindedly prostrate to Saddharmaprabhasa World-Honored One of limitless kalpas past.",
                pinyin: "yī xīn dǐng lǐ guò qù wú liàng jié zhèng fă míng shì zūn",
                chinese: "一心頂禮·過去無量劫正法明世尊"
            ),
            Verse(
                number: 6,
                text: "Single-mindedly prostrate to all buddhas, world-honored ones of the ten directions.",
                pinyin: "yī xīn dǐng lǐ shí fāng yī qiè zhū fó shì zūn",
                chinese: "一心頂禮·十方一切諸佛世尊"
            ),
            Verse(
                number: 7,
                text: "Single-mindedly prostrate to the thousand buddhas of the Virtuous Kalpa, and all buddhas, world-honored ones of the three periods of time.",
                pinyin: "yī xīn dǐng lǐ xián jié qiān fó sān shì yī qiè zhū fó shì zūn",
                chinese: "一心頂禮·賢劫千佛·三世一切諸佛世尊"
            ),
            Verse(
                number: 8,
                text: "Single-mindedly prostrate to the spiritually wondrous verses of the Great Dhāraṇī of the",
                pinyin: "yī xīn dǐng lǐ guăng dà yuán mǎn wú ài dà bēi xīn",
                chinese: "心頂禮·廣大圓滿無礙大悲心"
            ),
            Verse(
                number: 9,
                text: "Vast, Perfected, Unhindered Mind of Great Compassion.",
                pinyin: "dà tuó luó ní shén miào zhāng jù",
                chinese: "大陀羅尼神妙章句"
            ),
            Verse(
                number: 10,
                text: "Single-mindedly prostrate to all dhāraṇīs proclaimed by Avalokiteśvara,",
                pinyin: "yī xīn dǐng lǐ guān yīn suǒ shuō zhū tuó luó ní",
                chinese: "一心頂禮·觀音所說諸陀羅尼·"
            ),
            Verse(
                number: 11,
                text: "and all honored Dharma of the ten directions and three periods of time.",
                pinyin: "jí shí fāng sān shì yī qiè zūn fă",
                chinese: "及十方三世一切尊法"
            )
        ]
        for verse in gcChapter3.verses {
            verse.chapter = gcChapter3
        }
        
        let gcChapter4 = Chapter(number: 4, title: "Prostrations to Bodhisattvas")
        gcChapter4.text = greatCompassionRepentance
        gcChapter4.verses = [
            Verse(
                number: 1,
                text: "Single-mindedly prostrate to Thousand-Handed and Thousand-Eyed, Great Kindness and",
                pinyin: "yī xīn dĩng lĩ qiān shǒu qiān yăn dà cí dà bēi",
                chinese: "一心頂禮·千手千眼・大慈大悲・"
            ),
            Verse(
                number: 2,
                text: "Great Compassion, Avalokiteśvara Bodhisattva-Mahāsattva.",
                pinyin: "guān shì yīn zì zài pú sà mó hē sà",
                chinese: "觀世音自在菩薩摩訶薩"
            ),
            Verse(
                number: 3,
                text: "Single-mindedly prostrate to Mahāsthāmaprāpta Bodhisattva-Mahāsattva.",
                pinyin: "yī xīn dĩng lĩ dà shì zhì pú sà mó hē sà",
                chinese: "一心頂禮·大勢至菩薩摩訶薩"
            ),
            Verse(
                number: 4,
                text: "Single-mindedly prostrate to Dhāraṇī Bodhisattva-Mahāsattva",
                pinyin: "yī xīn dĩng lǐ zǒng chí wáng pú sà mó hē sà",
                chinese: "一心頂禮總持王菩薩摩訶薩"
            ),
            Verse(
                number: 5,
                text: "Single-mindedly prostrate to Sūryaprabha Bodhisattva-, Candraprabha Bodhisattva-Mahāsattvas.",
                pinyin: "yī xīn dĩng lĩ rì guāng pú sà yuè guāng pú sà mó hē sà",
                chinese: "一心頂禮·日光菩薩・月光菩薩摩訶薩"
            ),
            Verse(
                number: 6,
                text: "Single-mindedly prostrate to Ratnarāja Bodhisattva-, Bhaisajyarāja Bodhisattva-,",
                pinyin: "yī xīn dĩng lĩ bǎo wáng pú sà yào wáng pú sà",
                chinese: "一心頂禮·寶王菩薩‧藥王菩薩・"
            ),
            Verse(
                number: 7,
                text: "Bhaisajyasamudgata Bodhisattva-Mahāsattvas.",
                pinyin: "yào shàng pú sà mó hē sà",
                chinese: "藥上菩薩摩訶薩"
            ),
            Verse(
                number: 8,
                text: "Single-mindedly prostrate to Avatamsaka Bodhisattva-, Mahāvyūha Bodhisattva-,",
                pinyin: "yī xīn dĩng lĩ huá yán pú sà dà zhuāng yán pú sà",
                chinese: "一心頂禮·華嚴菩薩・大莊嚴菩薩・"
            ),
            Verse(
                number: 9,
                text: "Ratnagarbha Bodhisattva-Mahāsattvas.",
                pinyin: "bǎo zàng pú sà mó hē sà",
                chinese: "寶藏菩薩摩訶薩"
            ),
            Verse(
                number: 10,
                text: "Single-mindedly prostrate to Gunagarbha Bodhisattva-, Vajragarbha Bodhisattva-,",
                pinyin: "yī xīn dĩng lĩ dé zàng pú sà jīn gāng zàng pú sà",
                chinese: "一心頂禮·德藏菩薩・金剛藏菩薩・"
            ),
            Verse(
                number: 11,
                text: "Ākāśagarbha Bodhisattva-Mahāsattvas.",
                pinyin: "xū kōng zàng pú sà mó hē sà",
                chinese: "虛空藏菩薩摩訶薩"
            ),
            Verse(
                number: 12,
                text: "Single-mindedly prostrate to Maitreya Bodhisattva-, Samantabhadra Bodhisattva-,",
                pinyin: "yī xīn dǐng lǐ mí lēi pú sà pũ xián pú sà",
                chinese: "一心頂禮·彌勒菩薩・普賢菩薩・"
            ),
            Verse(
                number: 13,
                text: "Mañjuśrī Bodhisattva-Mahāsattvas.",
                pinyin: "wén shū shī lì pú sà mó hē sà",
                chinese: "文殊師利菩薩摩訶薩"
            ),
            Verse(
                number: 14,
                text: "Single-mindedly prostrate to all bodhisattva-mahāsattvas of the ten directions and three periods of time.",
                pinyin: "yī xīn dǐng lǐ shí fāng sān shì yī qiè pú sà mó hē sà",
                chinese: "一心頂禮·十方三世一切菩薩摩訶薩"
            )
        ]
        for verse in gcChapter4.verses {
            verse.chapter = gcChapter4
        }
        
        let gcChapter5 = Chapter(number: 5, title: "Vows and Invocations")
        gcChapter5.text = greatCompassionRepentance
        gcChapter5.verses = [
            Verse(
                number: 1,
                text: "The [Great Compassion Dhāraṇī] Sūtra states: \"If there are any bhiksus, bhikșunīs, upāsakas, upāsikās,",
                pinyin: "jīng yún ruò yǒu bĩ qiū bǐ qiū ní yōu pó sè yōu pó yí tóng nán",
                chinese: "經云・若有比丘・比丘尼·優婆塞・優婆夷·童男"
            ),
            Verse(
                number: 2,
                text: "boys or girls, who wish to recite and uphold [this dhāraṇī], bring forth the mind of kindness",
                pinyin: "tóng nữ yù sòng chí zhě yú zhū zhòng shēng qǐ cí bēi xīn xiān",
                chinese: "童女・欲誦持者・於諸眾生 起慈悲心・先"
            ),
            Verse(
                number: 3,
                text: "and compassion towards all sentient beings. They should first follow me in making these vows:",
                pinyin: "dāng cóng wõ fã rú shì yuàn",
                chinese: "當從我發如是願。"
            ),
            Verse(
                number: 4,
                text: "Seeking refuge in Great Compassion, Avalokiteśvara, I vow to quickly know all phenomena.",
                pinyin: "ná mó dà bēi guān shì yīn yuàn wǒ sù zhī yí qiè fă",
                chinese: "南無大悲觀世音·願我速知一切法。"
            ),
            Verse(
                number: 5,
                text: "Seeking refuge in Great Compassion, Avalokiteśvara, I vow to soon obtain the eye of wisdom.",
                pinyin: "ná mó dà bēi guān shì yīn yuàn wǒ zǎo dé zhì huì yăn",
                chinese: "南無大悲觀世音·願我早得智慧眼。"
            ),
            Verse(
                number: 6,
                text: "Seeking refuge in Great Compassion, Avalokiteśvara, I vow to quickly liberate all beings.",
                pinyin: "ná mó dà bēi guān shì yīn yuàn wǒ sù dù yí qiè zhòng",
                chinese: "南無大悲觀世音·願我速度一切眾"
            ),
            Verse(
                number: 7,
                text: "Seeking refuge in Great Compassion, Avalokiteśvara, I vow to soon obtain skillful and expedient means.",
                pinyin: "ná mó dà bēi guān shì yīn yuàn wǒ zǎo dé shàn fāng biàn",
                chinese: "南無大悲觀世音·願我早得善方便"
            ),
            Verse(
                number: 8,
                text: "Seeking refuge in Great Compassion, Avalokiteśvara, I vow to quickly sail upon the boat of prajñā.",
                pinyin: "ná mó dà bēi guān shì yīn yuàn wǒ sù chéng bō ruì chuán",
                chinese: "南無大悲觀世音·願我速乘般若船"
            ),
            Verse(
                number: 9,
                text: "Seeking refuge in Great Compassion, Avalokiteśvara, I vow to soon cross the sea of suffering.",
                pinyin: "ná mó dà bēi guān shì yīn yuàn wǒ zǎo dé yuè kŭ hăi",
                chinese: "南無大悲觀世音·願我早得越苦海。"
            ),
            Verse(
                number: 10,
                text: "Seeking refuge in Great Compassion, Avalokiteśvara, I vow to quickly master the path of precepts and concentration.",
                pinyin: "ná mó dà bēi guān shì yīn yuàn wǒ sù dé jiè dìng dào",
                chinese: "南無大悲觀世音·願我速得戒定道。"
            ),
            Verse(
                number: 11,
                text: "Seeking refuge in Great Compassion, Avalokiteśvara, I vow to soon ascend the mountain of nirvāņa.",
                pinyin: "ná mó dà bēi guān shì yīn yuàn wǒ zǎo dēng niè pán shān",
                chinese: "南無大悲觀世音·願我早登涅槃山"
            ),
            Verse(
                number: 12,
                text: "Seeking refuge in Great Compassion, Avalokiteśvara, I vow to quickly dwell in the home of the unconditioned.",
                pinyin: "ná mó dà bēi guān shì yīn yuàn wǒ sù huì wú wèi shě",
                chinese: "南無大悲觀世音·願我速會無為舍。"
            ),
            Verse(
                number: 13,
                text: "Seeking refuge in Great Compassion, Avalokiteśvara, I vow to soon recognize the Dharma nature body as my own.",
                pinyin: "ná mó dà bēi guān shì yīn yuàn wǒ zǎo tóng fǎ xìng shēn",
                chinese: "南無大悲觀世音·願我早同法性身"
            ),
            Verse(
                number: 14,
                text: "If I face a mountain of knives, the mountain of knives shall shatter by itself.",
                pinyin: "wõ ruò xiàng dão shān dão shān zì cuī zhé",
                chinese: "我若向刀山 ·刀山自摧折。"
            ),
            Verse(
                number: 15,
                text: "If I face liquid fire, the liquid fire shall dry-up by itself.",
                pinyin: "wõ ruò xiàng huõ tāng zì kū jié",
                chinese: "我若向火湯·火湯自枯竭"
            ),
            Verse(
                number: 16,
                text: "If I face the hells, the hells shall vanish and extinguish by themselves.",
                pinyin: "wõ ruò xiàng dì yù zì xiāo miè",
                chinese: "我若向地獄·地獄自消滅"
            ),
            Verse(
                number: 17,
                text: "If I face hungry ghosts, the hungry ghosts shall become self-satisfied.",
                pinyin: "wõ ruò xiàng è gui zì bão măn",
                chinese: "我若向餓鬼·餓鬼自飽滿"
            ),
            Verse(
                number: 18,
                text: "If I face the asūras, their minds of hatred shall tame themselves.",
                pinyin: "wõ ruò xiàng è xīn zì tiáo fú",
                chinese: "我若向惡心·惡心自調伏"
            ),
            Verse(
                number: 19,
                text: "If I face animals, by themselves they shall gain great wisdom!",
                pinyin: "wõ ruò xiàng zì dé dà zhì huì",
                chinese: "我若向自得大智慧"
            ),
            Verse(
                number: 20,
                text: "Homage to Avalokiteśvara Bodhisattva!",
                pinyin: "ná mó guān shì yīn pú sà (10x)",
                chinese: "南無觀世音菩薩"
            ),
            Verse(
                number: 21,
                text: "Homage to Amitābha Buddha!",
                pinyin: "ná mó ō mí tuó fó (10x)",
                chinese: "南無阿彌陀佛"
            ),
            Verse(
                number: 22,
                text: "Avalokiteśvara Bodhisattva addressed the Buddha saying, 'World-Honored One, if sentient beings",
                pinyin: "guān shì yīn pú sà bái fó yán shì zūn ruò zhū zhòng shēng sòng chí",
                chinese: "觀世音菩薩白佛言・世尊・若諸眾生・誦持"
            ),
            Verse(
                number: 23,
                text: "who recite and uphold the Great Compassion Dhāraṇī descend into the three lower realms, I vow to not achieve proper awakening.",
                pinyin: "dà bēi shén zhòu duò sân è dào zhě wǒ shì bù chéng zhèng jué",
                chinese: "大悲神咒・墮三惡道者・我誓不成正覺。"
            )
        ]
        for verse in gcChapter5.verses {
            verse.chapter = gcChapter5
        }
        
        let gcChapter6 = Chapter(number: 6, title: "The Great Compassion Dhāraṇī")
        gcChapter6.text = greatCompassionRepentance
        gcChapter6.verses = [
            Verse(
                number: 1,
                text: "[Repeat the following dhāraṇī multiple times as instructed.]",
                pinyin: "",
                chinese: ""
            ),
            Verse(
                number: 2,
                text: "After Avalokiteśvara Bodhisattva discoursed this dhāraṇī, the great earth quaked in six ways,",
                pinyin: "guān shì yīn pú sà shuō cǐ zhòu yĩ dà dì liù biàn zhèn dòng tiān yũ",
                chinese: "觀世音菩薩說此咒已・大地六變震動・天雨"
            ),
            Verse(
                number: 3,
                text: "the heavens showered precious blossoms which descended abundantly, the myriad buddhas of the ten directions were all delighted, celestial demons and those of other paths were terrified",
                pinyin: "bǎo huá bìn fēn ér xià shí fāng zhū fó xī jiē huān xi tiān mó wài",
                chinese: "寶華繽紛而下・十方諸佛悉皆歡喜·天魔外"
            ),
            Verse(
                number: 4,
                text: "as their hairs stood on end, and all in the assembly attained the realization of various stages",
                pinyin: "dào kòng bù máo shù yí qiè zhòng huì jiē huò guǒ zhèng huò dé",
                chinese: "道恐怖毛豎· 切眾會皆獲果證 ·或得"
            ),
            Verse(
                number: 5,
                text: "of fruition. Some attained the fruition of the śrotāpanna, some attained the fruition of the sakṛdāgāmin, some attained the fruition of the anāgāmin,",
                pinyin: "xū tuó huán guǒ huò dé sĩ tuó hán guǒ huò dé ō nà hán guo",
                chinese: "須陀洹果·或得斯陀含果·或得阿那含果"
            ),
            Verse(
                number: 6,
                text: "some attained the fruition of the arhat, some attained the first ground or second ground, the third, fourth, or fifth grounds,",
                pinyin: "huò dé ō luó hàn guǒ huò dé yī dì èr dì sān sì wũ dì",
                chinese: "或得阿羅漢果·或得一地二地·三四五地"
            ),
            Verse(
                number: 7,
                text: "and even the tenth ground [of a bodhisattva], and infinite sentient beings gave rise to the bodhi mind.",
                pinyin: "năi zhì shí dì zhě wú liàng zhòng shēng fā pú tí xīn",
                chinese: "乃至十地者・無量 眾 生發菩提心。"
            )
        ]
        for verse in gcChapter6.verses {
            verse.chapter = gcChapter6
        }
        
        let gcChapter7 = Chapter(number: 7, title: "Repentance and Confession")
        gcChapter7.text = greatCompassionRepentance
        gcChapter7.verses = [
            Verse(
                number: 1,
                text: "All beings and I,",
                pinyin: "wǒ jí zhòng shēng",
                chinese: "我及眾生・"
            ),
            Verse(
                number: 2,
                text: "since beginningless time, have been constantly obstructed by the grave transgressions of the three karmas and six faculties. We did not encounter the buddhas and did not know that it is necessary to leave [samsāra].",
                pinyin: "wú shĩ cháng wéi sān yè liù gēn zhòng zuì suo zhàng bù jiàn zhū fó bù zhī chú yào",
                chinese: "無始常為,三業六根重罪所障不見諸佛,不知出要・"
            ),
            Verse(
                number: 3,
                text: "Instead, we were complicit with birth and death and did not understand the wondrous principles [of the Dharma]. Although we now know this, we are obstructed by all grave transgressions,",
                pinyin: "dàn shùn shēng sǐ bù zhī miào lǐ wǒ jìn suī zhī yóu yù zhòng shēng tóng wéi yī qiè",
                chinese: "但順生死不知妙理·我今雖知·猶與眾 生 同為 切。"
            ),
            Verse(
                number: 4,
                text: "just like all sentient beings are. Now, [kneeling] before Avalokiteśvara and the buddhas of the ten directions, we seek refuge in you as well as repent and reform on universal behalf of all sentient beings.",
                pinyin: "zhòng zuì suǒ zhàng jìn duì guān yīn shí fāng fó qián pũ wéi zhòng shēng guī mìng chàn hui",
                chinese: "重罪所障今對觀音十方佛前·普為眾生皈命懺悔·"
            ),
            Verse(
                number: 5,
                text: "May you bless us with aid and support! Cause these obstacles to be dissolved and extinguished!",
                pinyin: "wéi yuàn jiā hù lìng zhàng xiāo miè",
                chinese: "惟願加護・令障消滅"
            ),
            Verse(
                number: 6,
                text: "Universally, on behalf of the four objects of gratitude, three states of existence, and all sentient beings in the Dharma Realms,",
                pinyin: "pů wéi sì ên sān yǒu fă jiè zhòng shēng",
                chinese: "普為四恩三有·法界眾 生"
            ),
            Verse(
                number: 7,
                text: "we all vow to sever and eradicate the three obstacles through seeking refuge, repentance, and reform.",
                pinyin: "xī yuàn duàn chú săn zhàng guī mìng chàn hui",
                chinese: "悉願斷除三障・皈命懺悔。"
            ),
            Verse(
                number: 8,
                text: "All beings and I,",
                pinyin: "wǒ yũ zhòng shēng",
                chinese: "我與眾生・"
            ),
            Verse(
                number: 9,
                text: "since beginningless time until now, have internally schemed for ourselves and externally conspired with evil friends due to attachments and wrong views. We did not rejoice in",
                pinyin: "wú shì lái jìn yóu ài jiàn gù nèi jì wõ rén wài yīn è yǒu bù suí xĩ tā",
                chinese: "無始來今・由愛見故・內計我人·外因悪友·不隨喜他·"
            ),
            Verse(
                number: 10,
                text: "a hair's breadth of others' virtues and instead extensively committed various offenses through the three karmas. Though each incident was not great, our unwholesome intentions pervaded.",
                pinyin: "yī háo zhī shàn wéi piàn sān yè guǎng zào zhòng zuì shì suī bù guăng è xīn piàn bù",
                chinese: "一毫之善·唯偏三業廣造眾罪事雖不廣·惡心偏布·"
            ),
            Verse(
                number: 11,
                text: "Wholeheartedly we repent and reform! We, your disciples and others, along with all beings of the Dharma Realms,",
                pinyin: "zhì xīn chàn huǐ dì zi zhòng děng",
                chinese: "至心懺悔・弟子眾 等 原與法界一切眾"
            ),
            Verse(
                number: 12,
                text: "possess this single mind of the present, which is inherently replete with the thousand phenomena,",
                pinyin: "jù cǐ yī xīn běn jù qiān rú",
                chinese: "具此一心本具千如"
            ),
            Verse(
                number: 13,
                text: "spiritual powers, and radiant wisdom. It is equal to the buddhas' mind above and identical to sentient beings below, but due to deluded actions since beginningless time,",
                pinyin: "shén tōng guāng zhì shàng děng fó xīn xià tóng zhòng shēng wú shǐ mí yòng",
                chinese: "神通光智上等佛心下同眾生無始迷用"
            ),
            Verse(
                number: 14,
                text: "this tranquil radiance has been obstructed. We were confused upon encountering situations and each thought that arose was fettered. Within the Dharma of equality,",
                pinyin: "cǐ jìng guāng zhàng suì yù jìng mí niàn qǐ jì fă jiè píng děng",
                chinese: "此寂光障遂遇境迷念起即繫法界平等"
            ),
            Verse(
                number: 15,
                text: "we gave rise to thoughts of self versus others. With attachments and wrong views as the foundation and our bodies and speech as the conditions,",
                pinyin: "qǐ zì tā xiǎng yǐ ài jiàn wéi běn shēn kǒu wéi yuán",
                chinese: "起自他想以愛見為本身口為緣"
            ),
            Verse(
                number: 16,
                text: "we left no transgression undone among the various states of existence. We committed the ten evils and five grave transgressions, slandered the Dharma and slandered people,",
                pinyin: "zhū qù wú zuì bù zuò shí è wǔ nì huǐ fǎ huǐ rén",
                chinese: "諸趣無罪不作十惡五逆謗法謗人"
            ),
            Verse(
                number: 17,
                text: "violated precepts and violated fasts, destroyed stūpas and ruined temples, stole the Sangha's property, defiled the pure practice of celibacy,",
                pinyin: "pò jiè pò zhāi huǐ tǎ huǐ sì qiè sēng wù wū pí nà xíng",
                chinese: "破戒破齋毀塔毀寺竊僧物汙梵行"
            ),
            Verse(
                number: 18,
                text: "and pillaged and plundered the monastery's food, drink, finances, and property. A thousand buddhas appeared in the world, but we did not know of repentance and reform.",
                pinyin: "qiè duó sì cái shí wù cái bǎo qiān fó chū shì bù zhī chàn huǐ",
                chinese: "竊奪寺財食五財寶千佛出世不知懺悔"
            ),
            Verse(
                number: 19,
                text: "Transgressions like these are limitless and boundless. Shedding this present body and life,",
                pinyin: "chàn huǐ rú shì děng zuì wú liàng wú biān shě zĩ xíng mìng",
                chinese: "懺悔·如是等罪・無量無邊·捨茲形命"
            ),
            Verse(
                number: 20,
                text: "we fall into the three lower realms together and undergo myriad sufferings. Furthermore, during this present life, we are tormented by various afflictions,",
                pinyin: "hé duò sân tú bèi yīng wàn kŭ fù yú xiàn shì zhòng năo jiāo",
                chinese: "合墮三途・備嬰萬苦,復於現世 眾惱交"
            ),
            Verse(
                number: 21,
                text: "or are bound by grave ailments, buffeted by external conditions, and are obstructed from the Path,",
                pinyin: "jiān huò è jí yíng chán tā yuán bì pò zhàng yú dào fă bù",
                chinese: "煎或惡疾縈纏・他緣逼迫・障於道法・不"
            ),
            Verse(
                number: 22,
                text: "preventing us from practicing and cultivating. Now, we have encountered the",
                pinyin: "dé xūn xiū jīn yù",
                chinese: "得熏修·今遇"
            ),
            Verse(
                number: 23,
                text: "perfect Great Compassion Dhāraṇī, which can swiftly extinguish and eradicate such transgressions and obstacles.",
                pinyin: "dà bēi yuán mǎn shén zhòu sù néng miè chú rú sĩ zuì zhàng",
                chinese: "大悲圓滿神 咒・速能滅除·如斯罪障・"
            ),
            Verse(
                number: 24,
                text: "Thus, today we sincerely recite and uphold it. Seeking refuge in and facing",
                pinyin: "gù yú jīn rì zhì xīn sòng chí guī xiàng",
                chinese: "故於今日·至心誦持·歸向"
            ),
            Verse(
                number: 25,
                text: "Avalokiteśvara Bodhisattva and the Great Teachers of the ten directions, we bring forth the bodhi mind and cultivate the practice of dhāraṇīs.",
                pinyin: "guān shì yīn pú sà jí shí fāng dà shĩ fā pú tí xīn xiū zhēn yán",
                chinese: "觀世音菩薩·及十方 大師‧發菩提心·修真言"
            ),
            Verse(
                number: 26,
                text: "Along with all sentient beings, we confess our many transgressions and seek repentance and reform,",
                pinyin: "hèng yũ zhū zhòng shēng fã lù zhòng zuì qiú qĩ chàn hui bì",
                chinese: "行・與諸眾 生 ·發露眾罪・求乞懺悔‧畢"
            ),
            Verse(
                number: 27,
                text: "wishing that these may be completely dissolved and eradicated.",
                pinyin: "jìng xiāo chú wéi yuàn",
                chinese: "竟消除・唯願"
            ),
            Verse(
                number: 28,
                text: "O, Great Compassion, Avalokiteśvara Bodhisattva-Mahāsattva! Protect and hold us with your thousand hands; illuminate and watch over us with your thousand eyes!",
                pinyin: "dà bēi guān shì yīn pú sà mó hē sà qiān shòu hù chí qiān yăn",
                chinese: "大悲觀世音菩薩摩訶薩・千手護持・千眼"
            ),
            Verse(
                number: 29,
                text: "Cause our internal and external obstructive conditions to be extinguished and tranquil and both our own and others' vows and practices to be perfectly accomplished;",
                pinyin: "zhào jiàn lìng wǒ děng nèi wài zhàng yuán jì miè zì tā hèng yuàn",
                chinese: "照見令我等內外障緣寂滅・自他行願"
            ),
            Verse(
                number: 30,
                text: "cause us to reveal our original [natures] and understand it upon seeing it [so that we are able to] subdue all demons and those of other paths; cause our three karmas to be diligent in",
                pinyin: "yuán chéng kāi běn jiàn zhī zhì zhū mó wài sān yè jìng jìn xiū",
                chinese: "圓成・開本見知・制諸魔外・三業精進・修"
            ),
            Verse(
                number: 31,
                text: "cultivating the causes [for rebirth] in the Pure Land so that when we shed this body, we will not have any other inclinations,",
                pinyin: "jìng tù yīn zhì shě cǐ shēn gèng wú tã qù",
                chinese: "淨土因・至捨此身・更無他趣・"
            ),
            Verse(
                number: 32,
                text: "and we will surely attain rebirth in Amitabha Buddha's Pure Land of Ultimate Bliss, where we",
                pinyin: "jué dìng dé shēng ō mí tuó fó jí lè shì jiè qīn chéng gòng",
                chinese: "決定得生 ·阿彌陀佛·極樂世界・親承供"
            ),
            Verse(
                number: 33,
                text: "will personally serve and present offerings to Great Compassion, Avalokiteśvara. Replete in all dhāraṇīs, we will extensively liberate the host of beings so that they may",
                pinyin: "yăng dà bēi guān yīn jù zhū zăng chí guăng dù qún pǐn jiē",
                chinese: "養・大悲觀音・具諸總持 廣度群品・皆"
            ),
            Verse(
                number: 34,
                text: "all leave the wheel of suffering and reach the ground of wisdom together.",
                pinyin: "chū kŭ lún tóng dào zhì dì",
                chinese: "出苦輪同到智地。"
            ),
            Verse(
                number: 35,
                text: "Having repented and reformed as well as made vows, venerate and seek refuge in the Triple Gem!",
                pinyin: "chàn huǐ fā yuàn yǐ guì mìng lĩ sân bão",
                chinese: "懺悔發願巳・皈命禮三寶"
            )
        ]
        for verse in gcChapter7.verses {
            verse.chapter = gcChapter7
        }
        
        let gcChapter8 = Chapter(number: 8, title: "Final Prostrations and Closing")
        gcChapter8.text = greatCompassionRepentance
        gcChapter8.verses = [
            Verse(
                number: 1,
                text: "Homage to the Buddhas of the ten directions.",
                pinyin: "ná mó shí fāng fó",
                chinese: "南無十方佛"
            ),
            Verse(
                number: 2,
                text: "Homage to the Dharma of the ten directions.",
                pinyin: "ná mó shí fāng fă",
                chinese: "南無十方法"
            ),
            Verse(
                number: 3,
                text: "Homage to the Sangha of the ten directions.",
                pinyin: "ná mó shí fāng sēng",
                chinese: "南無十方僧"
            ),
            Verse(
                number: 4,
                text: "Homage to Our Teacher, Śākyamuni Buddha.",
                pinyin: "ná mó běn shī shì jiā móu ní fó",
                chinese: "南無本師釋迦牟尼佛"
            ),
            Verse(
                number: 5,
                text: "Homage to Amitābha Buddha.",
                pinyin: "ná mó ō mí tuó fó",
                chinese: "南無阿彌陀佛"
            ),
            Verse(
                number: 6,
                text: "Homage to Sahasraprabharaja-dhyāna-bhūmika Buddha.",
                pinyin: "ná mó qiān guāng wáng jìng zhù fó",
                chinese: "南無千光王靜住佛"
            ),
            Verse(
                number: 7,
                text: "Homage to the Great Dhāraṇī of the Vast, Perfected, Unhindered Mind of Great Compassion.",
                pinyin: "ná mó guăng dà yuán mǎn wú ài dà bēi xīn dà tuó luó ní",
                chinese: "南無廣大圓滿無礙大悲心大陀羅尼"
            ),
            Verse(
                number: 8,
                text: "Homage to Thousand-Handed and Thousand-Eyed Avalokiteśvara Bodhisattva.",
                pinyin: "ná mó qiān shǒu qiān yăn guān shì yīn pú sà",
                chinese: "南無千手千眼觀世音菩薩"
            ),
            Verse(
                number: 9,
                text: "Homage to Mahāsthāmaprāpta Bodhisattva.",
                pinyin: "ná mó dà shì zhì pú sà",
                chinese: "南無大勢至菩薩"
            ),
            Verse(
                number: 10,
                text: "Homage to Dhāraṇī Bodhisattva.",
                pinyin: "ná mó zǒng chí wáng pú sà",
                chinese: "南無總持王菩薩"
            ),
            Verse(
                number: 11,
                text: "Homage to the Eternally Abiding Triple Gem of the Mahāyāna!",
                pinyin: "ná mó dà chèng cháng zhù sān bǎo (3x)",
                chinese: "南無大乘常住三寶"
            ),
            Verse(
                number: 12,
                text: "[Declaration of Dedicative Report]",
                pinyin: "xuān dú wén shū",
                chinese: "宣讀文疏"
            ),
            Verse(
                number: 13,
                text: "Homage to the Noble Adornment of the Buddha's Unsurpassed Bodhi!",
                pinyin: "ná mó zhuāng yán wú shàng fó pú tí (3x)",
                chinese: "南無 莊嚴無上佛菩提"
            ),
            Verse(
                number: 14,
                text: "[Three Refuges]",
                pinyin: "sān guī yī wén",
                chinese: "三皈依文"
            ),
            Verse(
                number: 15,
                text: "I seek refuge in the Buddha, wishing that all sentient beings",
                pinyin: "zì guī yī fó dāng yuàn zhòng shēng",
                chinese: "自皈依佛·當願眾 生"
            ),
            Verse(
                number: 16,
                text: "understand the great Path and make the greatest vow!",
                pinyin: "tǐ jiě dà dào fā wú shàng xīn",
                chinese: "體解大道·發無上心。"
            ),
            Verse(
                number: 17,
                text: "I seek refuge in the Dharma, wishing that all sentient beings",
                pinyin: "zì guī yī fǎ dāng yuàn zhòng shēng",
                chinese: "自皈依法・當願眾 生"
            ),
            Verse(
                number: 18,
                text: "deeply study the sūtra treasury and acquire an ocean of wisdom!",
                pinyin: "shēn rù jīng zàng zhì huì rú hǎi",
                chinese: "深入經藏·智慧如海。"
            ),
            Verse(
                number: 19,
                text: "I seek refuge in the Sangha, wishing that all sentient beings",
                pinyin: "zì guī yī sēng dāng yuàn zhòng shēng",
                chinese: "自皈依僧 當願眾 生"
            ),
            Verse(
                number: 20,
                text: "lead the congregation without any obstruction!",
                pinyin: "tǒng lǐ dà zhòng yí qiè wú ài",
                chinese: "統理大眾 切無礙。"
            ),
            Verse(
                number: 21,
                text: "Noble Avalokiteśvara is an ancient buddha's manifestation.",
                pinyin: "shèng guān zì zài zàn",
                chinese: "聖觀自在讚"
            ),
            Verse(
                number: 22,
                text: "With one thousand hands and eyes, he reveals the mind of compassion",
                pinyin: "yī qiān shǒu yǎn zhăn cí xīn",
                chinese: "一千手眼展慈心"
            ),
            Verse(
                number: 23,
                text: "as he rescues those drowning in the nine realms.",
                pinyin: "jiǔ jiè bá chén lún",
                chinese: "九界拔沉淪"
            ),
            Verse(
                number: 24,
                text: "The profound merits of the dhāraṇī brings myriads of virtues.",
                pinyin: "shén zhòu gōng shēn wàn shàn xĩ pián zhēn",
                chinese: "神咒功深萬善悉駢臻"
            ),
            Verse(
                number: 25,
                text: "Homage to Bestower of Fearlessness Bodhisattva-Mahāsattva!",
                pinyin: "ná mó shì wú wèi pú sà mó hē sà (3x)",
                chinese: "南無施無畏菩薩摩訶薩"
            ),
            Verse(
                number: 26,
                text: "[Three Prostrations to the Buddha + Bow]",
                pinyin: "lǐ fó sān bài wèn xùn",
                chinese: "禮佛三拜、問訊"
            ),
            Verse(
                number: 27,
                text: "[Address by Officiant]",
                pinyin: "zhǔ fǎ kāi shì",
                chinese: "主法開示"
            ),
            Verse(
                number: 28,
                text: "Liturgy of the Great Compassion Repentance of the Thousand-Handed and Thousand-Eyed One | The End",
                pinyin: "",
                chinese: ""
            )
        ]
        for verse in gcChapter8.verses {
            verse.chapter = gcChapter8
        }
        
        greatCompassionRepentance.chapters.append(contentsOf: [gcChapter1, gcChapter2, gcChapter3, gcChapter4, gcChapter5, gcChapter6, gcChapter7, gcChapter8])
        context.insert(greatCompassionRepentance)
        }
        
        // Medicine Buddha Sutra
        if shouldLoadMedicineBuddhaSutra {
        let medicineBuddhaSutra = BuddhistText(
            title: "Medicine Buddha Sutra (藥師經)",
            author: "Buddha",
            textDescription: "The Medicine Buddha of Pure Crystal Radiance Sutra (藥師琉璃光如來本願功德經)",
            category: "Sutra",
            coverImageName: "MedicineBuddhaSutra"
        )
        
        let mbChapter1 = Chapter(number: 1, title: "Incense Praise")
        mbChapter1.text = medicineBuddhaSutra
        mbChapter1.verses = [
            Verse(
                number: 1,
                text: "Incense burning in the censer,",
                pinyin: "lú xiāng zhà rè",
                chinese: "爐香乍熱"
            ),
            Verse(
                number: 2,
                text: "All space permeated with fragrance.",
                pinyin: "fǎ jiè méng xūn",
                chinese: "法界蒙熏"
            ),
            Verse(
                number: 3,
                text: "The Buddhas perceive it from every direction,",
                pinyin: "zhū fó hǎi huì xī yáo wén",
                chinese: "諸佛海會悉遙聞"
            ),
            Verse(
                number: 4,
                text: "Auspicious clouds gather everywhere.",
                pinyin: "suí chù jié xiáng yún",
                chinese: "隨處結祥雲"
            ),
            Verse(
                number: 5,
                text: "With our sincerity,",
                pinyin: "chéng yì fāng yīn",
                chinese: "誠意方殷"
            ),
            Verse(
                number: 6,
                text: "The Buddhas manifest themselves in their entirety.",
                pinyin: "zhū fó xiàn quán shēn",
                chinese: "諸佛現全身"
            ),
            Verse(
                number: 7,
                text: "We take refuge in the Bodhisattvas-Mahasattvas.",
                pinyin: "nán mó xiāng yún gài pú sà mó hē sà",
                chinese: "南無香雲蓋菩薩摩訶薩"
            )
        ]
        for verse in mbChapter1.verses {
            verse.chapter = mbChapter1
        }
        
        let mbChapter2 = Chapter(number: 2, title: "Sutra Opening Verse")
        mbChapter2.text = medicineBuddhaSutra
        mbChapter2.verses = [
            Verse(
                number: 1,
                text: "The unexcelled, most profound, and exquisitely wondrous Dharma,",
                pinyin: "wú shàng shèn shēn wēi miào fǎ",
                chinese: "無上甚深微妙法"
            ),
            Verse(
                number: 2,
                text: "Is difficult to encounter throughout hundreds of thousands of millions of kalpas.",
                pinyin: "bǎi qiān wàn jié nán zāo yù",
                chinese: "百千萬劫難遭遇"
            ),
            Verse(
                number: 3,
                text: "Since we are now able to see, hear, receive and retain it,",
                pinyin: "wǒ jīn jiàn wén dé shòu chí",
                chinese: "我今見聞得受持"
            ),
            Verse(
                number: 4,
                text: "May we comprehend the true meaning of the Tathagata.",
                pinyin: "yuàn jiě rú lái zhēn shí yì",
                chinese: "願解如來真實義"
            )
        ]
        for verse in mbChapter2.verses {
            verse.chapter = mbChapter2
        }
        
        let mbChapter3 = Chapter(number: 3, title: "Introduction")
        mbChapter3.text = medicineBuddhaSutra
        mbChapter3.verses = [
            Verse(
                number: 1,
                text: "Thus have I heard. One time, while traveling and teaching throughout several countries, the Bhagavat arrived at the magnificent city of Vaisali. There he sat beneath the Joyful Tree of Musical Breezes and was joined by a great multitude of beings, both human and non-human.",
                pinyin: "rú shì wǒ wén: yī shí, bó qié fàn yóu huà zhū guó, zhì guǎng yán chéng, zhù lè yīn shù xià. yǔ",
                chinese: "如是我聞: 一時, 薄伽梵遊化諸國, 至廣嚴城, 住樂音樹下。與"
            ),
            Verse(
                number: 2,
                text: "In attendance was a retinue of highly cultivated bhiksus, eight thousand in number. Accompanying them was a throng of bodhisattvas and great bodhisattvas, thirty-six thousand in total.",
                pinyin: "dà bì chú zhòng bā qiān rén jù; pú sà mó hē sà sān wàn liù",
                chinese: "大苾芻眾八千人俱; 菩薩摩訶薩三萬六"
            ),
            Verse(
                number: 3,
                text: "Also in attendance were kings and their subjects, brahmins, laity, and a constellation of heavenly beings. This great congregation respectfully gathered around the Buddha to hear his teaching.",
                pinyin: "qiān jí guó wáng, dà chén, pó luó mén、jū shì, tiān、lóng bā bù, rén、fēi rén děng, wú liàng dà zhòng, gōng jìng wéi rào, ér wéi shuō fǎ。",
                chinese: "千及國王, 大臣, 婆羅門、居士, 天、龍八部, 人、非人等, 無量大眾, 恭敬圍繞, 而為說法。"
            ),
            Verse(
                number: 4,
                text: "At that time, the Dharma Prince Manjusri, with the Buddha's omniscient power, arose from his seat and came before the Buddha. Baring his right shoulder and bowing upon his right knee with joined palms, the young prince implored, \"World-Honored One, we wish that you would speak to us about the various Buddhas' names and honorary titles, their great vows, and their magnificent virtues.",
                pinyin: "ěr shí, màn shū shì lì fǎ wáng zǐ, chéng fó wēi shén, cóng zuò ér qǐ, piān tǎn yī jiān, yòu xī zhuó dì, xiàng bó qié fàn, qū gōng hé zhǎng。bái yán: 「shì zūn! wéi yuàn yǎn shuō rú shì xiàng lèi zhū fó míng hào, jí běn dà yuàn shū shèng",
                chinese: "爾時, 曼殊室利法王子, 承佛威神, 從座而起, 偏袒一肩, 右膝著地, 向薄伽梵, 曲躬合掌。白言: 「世尊! 惟願演說如是相類諸佛名號, 及本大願殊勝"
            ),
            Verse(
                number: 5,
                text: "We hope that all who are within hearing of these words can become free from karmic obstructions. Moreover, for the sake of sentient beings in the Period of Semblance Dharma, we hope these beneficial words can make them truly happy.\"",
                pinyin: "gōng dé, lìng zhū wén zhě, yè zhàng xiāo chú, wéi yù lì lè xiàng fǎ zhuǎn shí, zhū yǒu qíng gù」",
                chinese: "功德,令諸聞者,業障消除,為欲利樂像法轉時,諸有情故」"
            ),
            Verse(
                number: 6,
                text: "Upon hearing this request, the World-Honored One praised Manjusri, \"Excellent, excellent, Manjusri! It is out of your deep and heartfelt compassion for sentient beings that you have implored me to speak of the Buddhas' names and titles, original vows, and virtues that accompany them. This is in order to release sentient beings from their entanglements in karmic obstructions and also to bring peace and joy to those in the Period of Semblance Dharma. Now, for your benefit, I am going to speak. You should listen attentively and contemplate carefully what I am going to say.\"",
                pinyin: "ěr shí, shì zūn zàn màn shū shì lì tóng zǐ yán: 「shàn zāi! shàn zāi! màn shū shì lì rú yǐ dà bēi, quàn qǐng wǒ shuō zhū fó míng hào、běn yuàn gōng dé, wéi bá yè zhàng suǒ chán yǒu qíng, lì yì ān lè xiàng fǎ zhuǎn shí zhū yǒu qíng gù。gù rú jīn dì tīng, jí shàn sī",
                chinese: "爾時, 世尊讚曼殊室利童子言: 「善哉!善哉!曼殊室利汝以大悲,勸請我說諸佛名號、本願功德,為拔業障所纏有情,利益安樂像法轉時諸有情故。故汝今諦聽,極善思"
            ),
            Verse(
                number: 7,
                text: "\"Splendid!\" replied Manjusri. \"We are most happy to hear from you.\"",
                pinyin: "wéi, dāng wéi rú shuō。」màn shū shì",
                chinese: "惟,當為汝說。」曼殊室"
            ),
            Verse(
                number: 8,
                text: "The Buddha said to Manjusri: \"In the east, beyond Buddha lands as numerous as the grains of sand in ten Ganges Rivers, there exists a Buddha world called 'The Land of Pure Crystal,' where the 'Medicine Buddha of Pure Crystal Radiance' presides. Manjusri, this World-Honored One has three names. He is called 'Medicine Buddha of Pure Crystal Radiance,' 'Worthy One,' 'Truly All-Knowing,' 'Perfect in Knowledge and Conduct,' 'Well-Gone,' 'Knower of the World,' 'Unsurpassed,' 'Tamer,' 'Teacher of Heavenly and Human Beings,' 'Awakened One,' and 'Bhagavat.'\"",
                pinyin: "",
                chinese: ""
            )
        ]
        for verse in mbChapter3.verses {
            verse.chapter = mbChapter3
        }
        
        let mbChapter4 = Chapter(number: 4, title: "The Twelve Great Vows")
        mbChapter4.text = medicineBuddhaSutra
        mbChapter4.verses = [
            Verse(
                number: 1,
                text: "Manjusri, twelve great vows evolved from the heart of the World-Honored Medicine Buddha of Pure Crystal Radiance as he advanced upon the bodhisattva path. These vows were made with the heartfelt wish that all sentient beings might fulfill their aspirations.",
                pinyin: "shì lì! bǐ shì zūn yào shī liú lí guāng rú lái, běn xíng pú sà dào shí, fā shí èr dà yuàn, lìng zhū yǒu qíng, suǒ qiú jié dé。",
                chinese: "室利!彼世尊藥師琉璃光如來,本行菩薩道時,發十二大願,令諸有情,所求皆得。"
            ),
            Verse(
                number: 2,
                text: "The first vow is this: 'In a future lifetime, may I attain Anuttara-Samyak-Sambodhi. Thus, my body shall be one of bright radiance, shining forth in blazing illumination, without measure, boundary, or limitation, lighting up innumerable worlds. This body will be adorned with the thirty-two marks of excellence and the eighty noble qualities, which accompany the form of the True Man. May all sentient beings be likewise brilliant and adorned in body, completely equal to me.'",
                pinyin: "dì yī dà yuàn: yuàn wǒ lái shì dé ā nòu duō luó sān miǎo sān pú tí shí, zì shēn guāng míng, chì rán zhào yào wú liàng wú shù wú biān shì jiè, yǐ sān shí èr dà zhàng fū xiàng、bā shí suí xíng, zhuāng yán qí shēn; lìng yī qiè yǒu",
                chinese: "第一大願:願我來世得阿耨多羅三藐三菩提時,自身光明,熾然照曜無量無數無邊世界,以三十二大丈夫相、八十隨形,莊嚴其身;令一切有"
            ),
            Verse(
                number: 3,
                text: "The second vow is this: 'In a future lifetime, upon my enlightenment, may my body be as clear as pure crystal, flawless and impeccable within and without. May it be of boundless radiance and majestic virtue, of serene abiding goodness. May this body be a magnificent blazing net of glory, more brilliant than the sun and moon, able to embrace and awaken even those beings caught in the depths of profound darkness and gloom. Thus, shall all beings accomplish their endeavors according to their intentions.'",
                pinyin: "qíng, rú wǒ wú yì。dì èr dà yuàn: yuàn wǒ lái shì dé pú tí shí, shēn rú liú lí, nèi wài míng chè, jìng wú xiá huì, guāng míng guǎng dà; gōng dé wēi wēi, shēn shàn ān zhù, yàn wǎng zhuāng yán, guò yú rì yuè; yōu míng zhòng shēng, xī méng kāi xiǎo, suí yì suǒ qù, zuò zhū shì yè。",
                chinese: "情,如我無異。第二大願:願我來世得菩提時,身如琉璃,內外明徹,淨無瑕穢,光明廣大;功德巍巍,身善安住,焰網莊嚴,過於日月;幽冥眾生,悉蒙開曉,隨意所趣,作諸事業。"
            ),
            Verse(
                number: 4,
                text: "The third vow is this: 'In a future lifetime, upon my enlightenment, may I enable all beings to gain an abundance of things most useful and enjoyable, eliminating all scarcity or want. This I will accomplish through boundless wisdom and skillful means beyond measure.'",
                pinyin: "dì sān dà yuàn: yuàn wǒ lái shì dé pú tí shí, yǐ wú liàng",
                chinese: "第三大願:願我來世得菩提時,以無量"
            ),
            Verse(
                number: 5,
                text: "The fourth vow is this: 'In a future lifetime, upon my enlightenment, may all sentient beings choose to follow the peaceful way of bodhi instead of traveling the path of evil. If there are beings who are proceeding via the sravaka or pratyeka-buddha vehicle, may they become engaged by means of the great vehicle.'",
                pinyin: "",
                chinese: ""
            ),
            Verse(
                number: 6,
                text: "The fifth vow is this: 'In a future lifetime, upon my enlightenment, may sentient beings beyond number practice wholesome living and uphold all precepts according to my teachings. Through the commitment to actualize the Dharma, may they accomplish the Tri-Vidhani Silani (three categories of bodhisattva precepts). When beings violate any precept, their purity can be restored and they can avoid falling into the suffering realms simply upon hearing my name.'",
                pinyin: "dì wǔ dà yuàn: yuàn wǒ lái shì dé pú tí shí, ruò yǒu wú liàng wú biān yǒu qíng, yú wǒ fǎ zhōng xiū xíng fàn xíng, yī qiè jiē lìng dé bù quē jiè, jù sān jù jiè。shè yǒu huǐ fàn, wén wǒ míng yǐ, huán dé qīng jìng, bù duò è qù。",
                chinese: "第五大願:願我來世得菩提時,若有無量無邊有情,於我法中修行梵行,一切皆令得不缺戒,具三聚戒。設有毀犯,聞我名已,還得清淨,不墮惡趣。"
            ),
            Verse(
                number: 7,
                text: "The sixth vow is this: 'In a future lifetime, upon my enlightenment, I vow to aid all sentient beings who suffer from any form of malady. I vow to relieve those whose bodies are deformed, who lack their complete sense organs, who lack beauty and appeal, or who are simple-minded or foolishly stubborn. Those who are blind, deaf, raspy-voiced, or who suffer from any other physical or mental affliction, upon hearing my name, may they all be restored to perfect health and wholeness.'",
                pinyin: "dì liù dà yuàn: yuàn wǒ lái shì dé pú tí shí, ruò zhū yǒu qíng, qí shēn xià liè、zhū gēn bù jù, chǒu lòu、wán yú、máng、lóng、yīn、yá、luán、bì、bèi lóu、bái lái、diān diàn kuáng, zhǒng zhǒng bìng kǔ; wén wǒ míng yǐ, yī qiè jiē dé duān zhèng xiá huì, zhū gēn wán jù, wú zhū jí kǔ。",
                chinese: "第六大願:願我來世得菩提時,若諸有情,其身下劣、諸根不具,醜陋、頑愚、盲、聾、瘠、癌、攣、躄、背僂、白癲癲狂,種種病苦;聞我名已,一切皆得端正點慧,諸根完具,無諸疾苦。"
            ),
            Verse(
                number: 8,
                text: "The seventh vow is this: 'In a future lifetime, upon my enlightenment, if there are any sentient beings who are tormented by illness, who have no hope of release or respite from their suffering, who are without doctors or medicine, or who have no family members or other caregivers to assist them, who are homeless or impoverished, or are suffering in any way, I vow that once the sound of my name has penetrated their ears, all illness shall cease, and they shall find serene contentment in body and mind. They shall be surrounded by family and caregivers and all that they have previously lacked shall become abundantly available to them, even unto the actualization of Buddhahood.'",
                pinyin: "dì qī dà yuàn: yuàn wǒ lái shì dé pú tí shí, ruò zhū yǒu qíng, zhòng bìng bī qiè, wú jiù wú guī, wú yī wú yào, wú qīn wú jiā, pín qióng duō kǔ。wǒ zhī míng hào, yī jīng qí ěr, zhòng bìng xī",
                chinese: "第七大願:願我來世得菩提時,若諸有情,眾病逼切,無救無歸,無醫無藥,無親無家,貧窮多苦。我之名號,一經其耳,眾病悉"
            ),
            Verse(
                number: 9,
                text: "The eighth vow is this: 'In a future lifetime, upon my enlightenment, if there are any women who feel coerced or oppressed by the many disadvantages of the female form and have given rise to the desire to let go of that form, they shall, after hearing my name be transformed into the male form. Accompanying this form are all the characteristics of the true man, even unto the attainment of Buddhahood.'",
                pinyin: "dì bā dà yuàn: yuàn wǒ lái shì dé pú tí shí, ruò yǒu nǚ rén, wéi nǚ bǎi è zhī suǒ bī nǎo, jí shēng yàn lí yuàn shě nǚ shēn。wén wǒ míng yī qiè jiē dé zhuǎn nǚ chéng nán, jù zhàng fū xiàng nǎi zhì zhèng dé wú shàng pú tí。",
                chinese: "第八大願:願我來世得菩提時,若有女人,為女百惡之所逼惱,極生厭離願捨女身。聞我名一切皆得轉女成男,具丈夫相乃至證得無上菩提。"
            ),
            Verse(
                number: 10,
                text: "The ninth vow is this: 'In a future lifetime, upon my enlightenment, all who are caught in the net of evil shall be released from their entanglement in heterodox practices. If there are those who have fallen into the dark forest of evil views, they shall all become established in the correct perspective and gradually assume practice of all the bodhisattvas' disciplines, quickly actualizing Buddhahood.'",
                pinyin: "dì jiǔ dà yuàn: yuàn wǒ lái shì dé pú tí shí, lìng zhū yǒu qíng, chū mó juàn wǎng, jiě tuō yī qiè wài dào chán fù; ruò duò zhǒng zhǒng è jiàn chóu lín, jiē dāng yǐn shè zhì yú zhèng jiàn, jiàn lìng xiū xí zhū pú sà xíng, sù zhèng wú shàng zhèng děng pú tí。",
                chinese: "第九大願:願我來世得菩提時,令諸有情,出魔絹網,解脫一切外道纏縛;若墮種種惡見稠林,皆當引攝置於正見,漸令修習諸菩薩行,速證無上正等菩提。"
            ),
            Verse(
                number: 11,
                text: "The tenth vow is this: 'In a future lifetime, upon my enlightenment, if there are any sentient beings who, due to the enforcement of local laws, find themselves sentenced to flogging, incarceration, torture, execution, or any other manner of brutal punishment, they shall be aided by hearing my name. For those who are insulted, humiliated, or in abject misery or who are oppressed by burning anxiety, suffering in both body and mind, if they hear my name, due to the power of my awe-inspiring spiritual élan, all shall gain release from their suffering and woes.'",
                pinyin: "dì shí dà yuàn: yuàn wǒ lái shì dé pú tí shí, ruò zhū yǒu qíng, wáng fǎ suǒ lù, shéng fù biān tà, xì bì láo yù, huò dāng xíng lù; jí yú wú liàng zāi nàn líng rǔ, bēi chóu jiān bī, shēn xīn shòu kǔ; ruò wén wǒ míng, yǐ wǒ fú dé wēi shén lì gù, jiē dé jiě tuō yī qiè yōu kǔ。",
                chinese: "第十大願:願我來世得菩提時,若諸有情,王法所錄,繩縛鞭撻,繫閉牢獄,或當刑戮;及餘無量災難凌辱,悲愁煎逼,身心受苦;若聞我名,以我福德威神力故,皆得解脫一切憂苦。"
            ),
            Verse(
                number: 12,
                text: "The eleventh vow is this: 'In a future lifetime, upon my enlightenment, if there are any sentient beings who commit wrongdoings due to the agony of hunger and thirst, they shall be aided by hearing my name and concentrating on it. First, by providing exquisite delicacies, I will bring about their complete bodily satisfaction and contentment. Physically sated, they may then enjoy the wondrous flavor of the Dharma and become established in spiritual satisfaction and contentment.'",
                pinyin: "dì shí yī dà yuàn: yuàn wǒ lái shì dé pú tí shí, ruò zhū yǒu qíng, jī kě suǒ nǎo, wéi qiú shí gù, zào zhū è yè, dé wén wǒ míng, zhuān niàn shòu chí, wǒ dāng xiān yǐ shàng miào yǐn shí, bǎo zú qí shēn; hòu yǐ fǎ wèi, bì jìng ān lè ér jiàn lì zhī。",
                chinese: "第十一大願:願我來世得菩提時,若諸有情,饑渴所惱,為求食故,造諸惡業,得聞我名,專念受持,我當先以上妙飲食,飽足其身;後以法味,畢竟安樂而建立之。"
            ),
            Verse(
                number: 13,
                text: "The twelfth vow is this: 'In a future lifetime, upon my enlightenment, if there are any sentient beings who are without clothing due to poverty, who suffer day and night the afflictions of extreme heat and cold and the torment of insects, they shall be aided by hearing my name and concentrating on it. They shall be afforded that which they wish: the acquisition of many kinds of exquisite clothing, precious gems for adornment, flowered hair ornaments, perfumed ointments, and musical entertainment. The full enjoyment of all these things shall evoke their complete satisfaction and contentment.'",
                pinyin: "dì shí èr dà yuàn: yuàn wǒ lái shì dé pú tí shí, ruò zhū yǒu qíng, pín wú yī fú, wén méng hán rè, zhòu yè bī nǎo; ruò wén wǒ míng, zhuān niàn shòu chí, rú qí suǒ hào jí dé zhǒng zhǒng shàng miào yī fú, yì dé yī qiè bǎo zhuāng yán jù, huā mán tú xiāng, gǔ yuè zhòng jì, suí xīn suǒ wán, jiē lìng mǎn zú。",
                chinese: "第十二大願:願我來世得菩提時,若諸有情,貧無衣服,蚊虻寒熱,晝夜逼惱;若聞我名,專念受持,如其所好即得種種上妙衣服,亦得一切寶莊嚴具,華鬘塗香,鼓樂眾伎,隨心所翫,皆令滿足。"
            ),
            Verse(
                number: 14,
                text: "Manjusri, these are the twelve supremely subtle and wonderful vows of the 'World-Honored Medicine Buddha of Pure Crystal Radiance, Worthy One, Truly All-Knowing' while he was practicing the bodhisattva path.",
                pinyin: "màn shū shì lì! shì wéi bǐ shì zūn yào shī liú lí guāng rú lái、yìng、zhèng děng jué, xíng pú sà dào shí, suǒ fā shí èr wēi miào shàng yuàn。",
                chinese: "曼殊室利!是為彼世尊藥師琉璃光如來、應、正等覺,行菩薩道時,所發十二微妙上願。"
            )
        ]
        for verse in mbChapter4.verses {
            verse.chapter = mbChapter4
        }
        
        let mbChapter5 = Chapter(number: 5, title: "The Buddha Land")
        mbChapter5.text = medicineBuddhaSutra
        mbChapter5.verses = [
            Verse(
                number: 1,
                text: "Again the Buddha said to Manjusri, \"Even in one or more kalpas, I could not finish speaking of the magnificent vows the Medicine Buddha pledged while on the bodhisattva path, nor fully describe the wonders of the pristine Buddha land he attained. I can tell you this Buddha land is infinitely pure. There are no women's forms, no lower forms of rebirth or sounds of suffering.",
                pinyin: "fù cì, màn shū shì lì! bǐ shì zūn yào shī liú lí guāng rú lái, xíng pú sà dào shí suǒ fā dà yuàn, jí bǐ fó tǔ gōng dé zhuāng yán, wǒ ruò yī jié yú, shuō bù néng jìn。fó tǔ yī xiàng qīng nǚ rén yī wú è",
                chinese: "復次,曼殊室利!彼世尊藥師琉璃光如來,行菩薩道時所發大願,及彼佛土功德莊嚴,我若一劫餘,說不能盡。佛土一向清女人亦無惡"
            ),
            Verse(
                number: 2,
                text: "The land is made of pure crystal with ropes of gold bordering the paths. It features magnificent palaces and pavilions with spacious windows strung with nets, all made of the seven precious gems. The virtue and magnificence of this Buddha land is no different from that of the Western Pure Land.",
                pinyin: "yīn shēng。liú lí wéi dì, jīn shéng jiè dào, chéng、què、gōng、gé、xuān、chuāng luó wǎng, jiē qī bǎo chéng。yì rú xī fāng jí lè shì jiè, gōng dé zhuāng yán, děng wú chā bié。",
                chinese: "音聲。琉璃為地,金繩界道,城、闕、宮、閣、軒、窗羅網,皆七寶成。亦如西方極樂世界,功德莊嚴,等無差別。"
            ),
            Verse(
                number: 3,
                text: "In this Buddha realm, there are innumerable bodhisattvas, including two bodhisattvas at the highest level, preceding Buddhahood. Their names are given as 'Radiant Sunlight Bodhisattva and Radiant Moonlight Bodhisattva.' Both bodhisattvas are skillful in upholding the Medicine Buddha's Dharma. Thus, Manjusri, all good men and women who have confidence and faith should vow to be born in this Buddha land.",
                pinyin: "yú qí guó zhōng, yǒu èr pú sà mó hē sà: yī míng rì guāng biàn zhào, èr míng yuè guāng biàn zhào, shì bǐ wú liàng wú shù pú sà zhòng zhī shàng shǒu, cì bǔ fó chù, xī néng chí bǐ shì zūn yào shī liú lí guāng rú lái zhèng fǎ bǎo zàng。shì gù, màn shū shì lì! zhū yǒu xìn xīn shàn nán zǐ shàn nǚ rén děng, yīng dāng yuàn shēng bǐ fó shì jiè。」",
                chinese: "於其國中,有二菩薩摩訶薩:一名日光遍照,二名月光遍照,是彼無量無數菩薩眾之上首,次補佛處,悉能持彼世尊藥師琉璃光如來正法寶藏。是故,曼殊室利!諸有信心善男子善女人等,應當願生彼佛世界。」"
            )
        ]
        for verse in mbChapter5.verses {
            verse.chapter = mbChapter5
        }
        
        let mbChapter6 = Chapter(number: 6, title: "Benefits and Merits")
        mbChapter6.text = medicineBuddhaSutra
        mbChapter6.verses = [
            Verse(
                number: 1,
                text: "Continuing in this manner, the World-Honored One said to Manjusri, \"There are sentient beings who do not know the difference between beneficial and harmful conduct. Bent on acquiring and maintaining advantages for themselves alone, they remain greedy and close-fisted, unaware of the beneficial fruit of giving. Ignorant and therefore lacking in any trust in the merit of giving, they desperately accumulate and guard their material riches.",
                pinyin: "ěr shí, shì zūn fù gào màn shū shì lì tóng zǐ yán: 「màn shū shì lì! yǒu zhū zhòng shēng, bù shí shàn è, wéi huái tān lìn, bù zhī bù shī jí shī guǒ bào; yú chī wú zhì, guān yú xìn gēn, duō jù cái bǎo, qín jiā shǒu hù;",
                chinese: "爾時,世尊復告曼殊室利童子言:「曼殊室利!有諸眾生,不識善惡,唯懷貪吝,不知布施及施果報;愚癡無智,關於信根,多聚財寶,勤加守護;"
            ),
            Verse(
                number: 2,
                text: "Thus, upon meeting a beggar, they experience suffering from the knowledge that they will receive nothing in return for their donation. So strong is their attachment to their riches that to part with even a portion is like parting with a portion of their own flesh. Manjusri, there are innumerable sentient beings, who being stingy and greedy, amass great resources and wealth. Yet, they are incapable of enjoying that which they have accumulated for themselves, let alone sharing any of their wealth with parents, spouses, stewards, servants, or beggars.",
                pinyin: "jiàn qǐ zhě lái, qí xīn bù xǐ, shè bù huò yǐ ér xíng shī shí, rú gē shēn ròu, shēn shēng tòng xī。fù yǒu wú liàng qiān tān yǒu qíng, jī zī cái, yú qí zì shēn shàng bù shòu yòng, hé kuàng néng yǔ fù mǔ、qī zǐ、nú bì、zuò shǐ、jí lái qǐ zhě?",
                chinese: "見乞者來,其心不喜,設不獲已而行施時,如割身肉,深生痛惜。復有無量慳貪有情,積資財,於其自身尚不受用,何況能與父母、妻子、奴婢、作使、及來乞者?"
            ),
            Verse(
                number: 3,
                text: "Those sentient beings who die in this frame of mind will be reborn in either the hungry ghost or animal realm. However, due to the fact that while in the human realm, they temporarily had the chance to hear the name of the Medicine Buddha, upon remembering this Buddha's name, they shall immediately be reborn in the human realm. Influenced by the memory of that past-life experience and the suffering of the lower realms, they are willing to forego the enjoyment of sensual pleasures and instead enter into activities of generosity, even praising the efforts of others who give.",
                pinyin: "bǐ zhū yǒu qíng, cóng cǐ mìng zhōng, shēng è guǐ jiè, huò páng shēng qù。yóu xī rén jiān, céng dé zàn wén yào shī liú lí guāng rú lái míng gù, jīn zài è qù, zàn dé yì niàn bǐ rú lái míng, jí yú niàn shí, cóng bǐ chù mò, huán shēng rén zhōng。dé sù mìng niàn, wèi è qù kǔ, bù lè yù lè, hǎo xíng huì shī, zàn tàn shī zhě, yī qiè suǒ yǒu xī wú tān xī。",
                chinese: "彼諸有情,從此命終,生餓鬼界,或傍生趣。由昔人間,曾得暫聞藥師琉璃光如來名故,今在惡趣,暫得憶念彼如來名,即於念時,從彼處沒,還生人中。得宿命念,畏惡趣苦,不樂欲樂,好行惠施,讚歎施者,一切所有悉無貪惜。"
            ),
            Verse(
                number: 4,
                text: "They are no longer attached to their possessions and are gradually willing to share parts of their bodies, if necessary, with any who request it, as well as the remainder of their wealth and possessions.",
                pinyin: "jiàn cì shàng néng yǐ tóu mù、shǒu zú、xuè ròu、shēn fèn, shī lái qiú zhě, kuàng yú cái wù!",
                chinese: "漸次尚能以頭目、手足、血肉、身分,施來求者,況餘財物!"
            ),
            Verse(
                number: 5,
                text: "And Manjusri, there are sentient beings who break the precepts even though they have received the Buddha's teachings about them. There are those who do not break the precepts per se, but they do, however, break rules and regulations pertaining to daily life. Then there are those who are successful in upholding the precepts and adhering to the rules and regulations of daily life, but they do not have the right view.",
                pinyin: "「fù cì, màn shū shì lì! ruò zhū yǒu qíng, suī yú rú lái shòu zhū xué chù, ér pò shī luó; yǒu suī bù pò shī luó, ér pò guī zé; yǒu yú shī luó、guī zé, suī dé bù huài, rán huǐ zhèng jiàn;",
                chinese: "「復次,曼殊室利!若諸有情,雖於如來受諸學處,而破尸羅;有雖不破尸羅,而破軌則;有於尸羅、軌則,雖得不壞,然毁正見;"
            ),
            Verse(
                number: 6,
                text: "Some sentient beings have the right view, but waste or avoid the opportunity to further their learning and cannot encounter the deep and profound meaning of the Buddha's teachings. Others pursue opportunities to learn, but do so with an arrogant attitude. Because this conceit obscures their minds, they still consider themselves as right and others as wrong.",
                pinyin: "yǒu suī bù huǐ zhèng jiàn, ér qì duō wén, yú fó suǒ shuō qì jīng shēn yì, bù néng jiě liǎo; yǒu suī duō wén ér zēng shàng màn, yóu zēng shàng màn fù bì xīn gù, zì shì fēi tā, xián bàng zhèng fǎ, wéi mó bàn dǎng, rú shì yú rén, zì xíng xié jiàn, fù lìng wú liàng jù zhī yǒu qíng, duò dà xiǎn kēng。",
                chinese: "有雖不毀正見,而棄多聞,於佛所說契經深義,不能解了;有雖多聞而增上慢,由增上慢覆蔽心故,自是非他,嫌謗正法,為魔伴黨,如是愚人,自行邪見,復令無量俱胝有情,墮大險坑。"
            ),
            Verse(
                number: 7,
                text: "This mindset leads them to criticize the Dharma and undermines their understanding of the truth. As they ignorantly slander the Dharma and incorrectly practice the Dharma, they harmfully influence others, causing them to fall into a dangerous pit. All these beings shall find themselves endlessly migrating in the lower realms.",
                pinyin: "cǐ zhū yǒu qíng, yīng yú dì yù、páng shēng、guǐ qù, liú zhuǎn wú qióng。",
                chinese: "此諸有情,應於地獄、傍生、鬼趣,流轉無窮。"
            ),
            Verse(
                number: 8,
                text: "However, if these beings are able to hear the name of the Medicine Buddha of Pure Crystal Radiance, they can give up their harmful practices and undertake all beneficial ones, no longer entering any lower realms.",
                pinyin: "ruò dé wén cǐ yào shī liú lí guāng rú lái míng hào, biàn shě è xíng, xiū zhū shàn fǎ, bù duò è qù, shè yǒu bù néng shě zhū è xíng, xiū xíng shàn fǎ, duò è qù zhě, yǐ bǐ rú lái běn yuàn wēi lì, lìng qí xiàn qián zàn wén míng hào, cóng bǐ mìng zhōng, huán shēng rén qù, dé zhèng jiàn jīng jìn, shàn tiáo yì lè, biàn néng shě jiā, qù yú fēi jiā, rú lái fǎ zhōng shòu chí xué chù, wú yǒu huǐ fàn; zhèng jiàn duō wén, jiě shèn shēn yì, lí zēng shàng màn, bù bàng zhèng fǎ, bù wéi mó bàn, jiàn cì xiū xíng zhū pú sà xíng, sù dé yuán mǎn。」",
                chinese: "若得聞此藥師琉璃光如來名號,便捨惡行,修諸善法,不墮惡趣,設有不能捨諸惡行,修行善法,墮惡趣者,以彼如來本願威力,令其現前暫聞名號,從彼命終,還生人趣,得正見精進,善調意樂,便能捨家,趣於非家,如來法中受持學處,無有毀犯;正見多聞,解甚深義,離增上慢,不謗正法,不為魔伴,漸次修行諸菩薩行,速得圓滿。」"
            ),
            Verse(
                number: 9,
                text: "Manjusri, if there are sentient beings who are stingy, greedy, jealous, boastful of themselves, and slanderous of others, they will fall into the three lower realms for innumerable thousands of years. After they have endured severe pain and suffering there, they will be born once again in the saha world, but as cows, horses, camels, or donkeys. These animals must bear heavy loads and walk long distances. Constantly subjected to whipping, thirst, and hunger, they are driven to exhaustion and anguish.",
                pinyin: "「fù cì, màn shū shì lì! ruò zhū yǒu qíng, qiān tān jí dù, zì zàn huǐ tā, dāng duò sān è qù zhōng, wú liàng qiān suì shòu zhū jù kǔ; shòu jù kǔ yǐ, cóng bǐ mìng zhōng, lái shēng rén jiān, zuò niú、mǎ、tuó、lǘ, héng bèi biān tà, jī kě bī nǎo; yòu cháng fù zhòng, suí lù ér xíng。",
                chinese: "「復次,曼殊室利!若諸有情,慳貪嫉妒,自讚毀他,當墮三惡趣中,無量千歲受諸劇苦;受劇苦已,從彼命終,來生人間,作牛、馬、駝、驢,恒被鞭撻,饑渴逼惱;又常負重,隨路而行。"
            ),
            Verse(
                number: 10,
                text: "Or, such beings are born as humans, but must endure life in lowly, despicable states of existence. As the servants and slaves of people, they are constantly commanded to labor for others with no freedom for themselves.",
                pinyin: "huò dé wéi xià jiàn, zuò rén nú qū yì, héng bù zì rén。",
                chinese: "或得為下賤,作人奴驅役,恒不自任。"
            ),
            Verse(
                number: 11,
                text: "If, however, in former lives in the human realm, they have heard the name of the Medicine Buddha of Pure Crystal Radiance and are able to remember it, they can wholeheartedly take refuge in the Buddha. Because of the strength of this Buddha's unique spiritual élan, they are liberated from all their sufferings. All their faculties are keen, and they are wise and learned, constantly seeking the superlative Dharma.",
                pinyin: "ruò zài rén zhōng, céng wén shì zūn yào shī liú lí guāng rú lái míng hào, yóu cǐ shàn yīn, jīn fù yì niàn, zhì xīn guī yī。yǐ fó shén lì, zhòng kǔ jiě tuō, zhū gēn cōng lì, zhì huì duō wén, héng qiú shèng fǎ, cháng yù shàn yǒu, yǒng duàn mó juàn, pò wú míng ké, jié fán nǎo hé, jiě tuō yī qiè shēng、lǎo、bìng、sǐ, yōu chóu、kǔ nǎo。",
                chinese: "若在人中,曾聞世尊藥師琉璃光如來名號,由此善因,今復憶念,至心歸依。以佛神力,眾苦解脫,諸根聰利,智慧多聞,恒求勝法,常遇善友,永斷魔羂,破無明殼,竭煩惱河,解脫一切生、老、病、死,憂愁、苦惱。"
            ),
            Verse(
                number: 12,
                text: "Again, Manjusri, if there are sentient beings who are habitually contrary and divisive, who engage in fighting and litigation, aggravating and disturbing both self and others by means of body, speech, and mind, these beings increase the occurrence of malevolent deeds. They call upon the spirits that reside in mountains, forests, trees, or tombs, such as yaksas or raksasas, who in turn may slay animals and offer up their blood and flesh in an act of sacrificial worship.",
                pinyin: "「fù cì, màn shū shì lì! ruò zhū yǒu qíng, hào xǐ guāi lí, gèng xiāng dòu sòng, nǎo luàn zì tā, yǐ shēn yǔ yì, zào zuò zēng zhǎng zhǒng zhǒng è yè, zhǎn zhuǎn cháng wéi bù ráo yì shì, hù xiāng móu hài。gào zhào shān lín shù zhǒng děng shén; shā zhū zhòng shēng, qǔ qí xuè ròu, jì sì yào chā luó chà pó děng;",
                chinese: "「復次,曼殊室利!若諸有情,好喜乖離,更相鬥訟,惱亂自他,以身語意,造作增長種種惡業,展轉常為不饒益事,互相謀害。告召山林樹塚等神;殺諸眾生,取其血肉,祭祀藥叉羅剎婆等;"
            ),
            Verse(
                number: 13,
                text: "Then these sentient beings write the name of the person they hold a grudge against and make an image in his or her likeness, using wizardry to cast a curse upon it. They engage in sorcery and use magical potions to harm the subject of their evil practices. They even use spells to raise the dead who, at their bidding, harm or kill the intended victim.",
                pinyin: "shū yuàn rén míng, zuò qí xíng xiàng, yǐ è zhòu shù ér zhòu zǔ zhī; yǎn měi gǔ dào, zhòu qǐ shī guǐ, lìng duàn bǐ mìng, jí huài qí shēn。",
                chinese: "書怨人名,作其形像,以惡咒術而咒詛之;魘魅蠱道,咒起屍鬼,令斷彼命,及壞其身。"
            ),
            Verse(
                number: 14,
                text: "However, if in the midst of harming by such means, they hear the name of the Medicine Buddha of Pure Crystal Radiance, all their vicious intentions will no longer have a harmful effect. Gradually, the compassionate mind will arise in the perpetrators and their victims, benefiting both with the presence of peace and joy. With the mind of hatred, destruction, and harm no longer present, each individual is happy and content with what he or she has received in its place. They no longer consider it necessary to abuse or invade one another, but instead find abundant mutual benefit.",
                pinyin: "shì zhū yǒu qíng, ruò dé wén cǐ yào shī liú lí guāng rú lái míng hào, bǐ zhū è shì, xī bù néng hài。yī qiè zhǎn zhuǎn jiē qǐ cí xīn, lì yì ān lè, wú sǔn nǎo yì jí xián hèn xīn; gè gè huān yuè, yú zì suǒ shòu, shēng yú xǐ zú, bù xiāng qīn líng, hù wéi ráo yì。」",
                chinese: "是諸有情,若得聞此藥師琉璃光如來名號,彼諸惡事,悉不能害。一切展轉皆起慈心,利益安樂,無損惱意及嫌恨心;各各歡悅,於自所受,生於喜足,不相侵凌,互為饒益。」"
            )
        ]
        for verse in mbChapter6.verses {
            verse.chapter = mbChapter6
        }
        
        let mbChapter7 = Chapter(number: 7, title: "Rebirth in the Pure Land")
        mbChapter7.text = medicineBuddhaSutra
        mbChapter7.verses = [
            Verse(
                number: 1,
                text: "Again, Manjusri, concerning the bhiksu and bhiksuni, layman and laywoman, and good men and women of pure faith, if they receive and uphold the eight purification precepts for one year or even for three months, they will have established good roots. Due to their cultivation, they wish to be reborn in Amitabha Buddha's Pure Land of Ultimate Bliss in order to hear and learn the correct Dharma. However, they may not have yet fully developed the necessary resolve to be reborn there.",
                pinyin: "「fù cì, màn shū shì lì! ruò yǒu sì zhòng: bì chú、bì chú ní、wū bō suǒ jiā、wū bō sī jiā, jí yú jìng xìn shàn nán zǐ shàn nǚ rén děng, yǒu néng shòu chí bā fēn zhāi jiè, huò jīng yī nián, huò fù sān yuè, shòu chí xué chù, yǐ cǐ shàn gēn, yuàn shēng xī fāng jí lè shì jiè wú liàng shòu fó suǒ, tīng wén zhèng fǎ, ér wèi dìng zhě。",
                chinese: "「復次,曼殊室利!若有四眾:苾芻、苾芻尼、鄔波索迦、鄔波斯迦,及餘淨信善男子善女人等,有能受持八分齋戒,或經一年,或復三月,受持學處,以此善根,願生西方極樂世界無量壽佛所,聽聞正法,而未定者。"
            ),
            Verse(
                number: 2,
                text: "In this circumstance, when they approach the end of life, if they hear the name of the Medicine Buddha, eight great bodhisattvas will come to their aid: Manjusri Bodhisattva, Avalokitesvara Bodhisattva, Maha Bodhisattva of Great Power to Heal and Save, Unlimited Intention Bodhisattva, Treasure of Sandalwood Flower Bodhisattva, the Medicine King Bodhisattva, the Supreme Medicine Bodhisattva, and Maitreya Bodhisattva. Gliding through the sky, they show these beings the path to the Pure Land of numerous precious multicolored blossoms, where each is instantly reborn in the heart of the flowers.",
                pinyin: "ruò wén shì zūn yào shī liú lí guāng rú lái míng hào, lín mìng zhōng shí, yǒu bā pú sà, qí míng: wén shū shì lì pú sà、guān zì zài pú sà、dà shì zhì pú sà、wú jìn yì pú sà、bǎo tán huā pú sà、yào wáng pú sà、yào shàng pú sà、mí lè pú sà, cǐ bā pú sà, chéng kōng ér lái, shì qí dào lù, jí yú bǐ shì jiè zhǒng zhǒng zá sè zhòng bǎo huā zhōng, zì rán huà shēng。",
                chinese: "若聞世尊藥師琉璃光如來名號,臨命終時,有八菩薩,其名:文殊師利菩薩、觀自在菩薩、大勢至菩薩、無盡意菩薩、寶檀華菩薩、藥王菩薩、藥上菩薩、彌勒菩薩,此八菩薩,乘空而來,示其道路,即於彼世界種種雜色眾寶華中,自然化生。"
            ),
            Verse(
                number: 3,
                text: "Or, if the resolve of these beings is weaker yet, they will be reborn in one of the heavenly realms. Despite this rebirth, their good roots remain intact. Therefore, after their life span in the heavenly realms, they will not be reborn in any of the lower realms, but instead will return to be born in the human realm. There they may be born as a cakravartin, a world sovereign of great virtue who effortlessly unites the four continents, peacefully establishing unlimited sentient beings in the ten good ways.",
                pinyin: "huò yǒu yīn cǐ shēng yú tiān shàng, suī shēng tiān shàng, ér běn shàn gēn yì wèi qióng jìn, bù fù gèng shēng zhū yú è qù。tiān shàng shòu jìn, huán shēng rén jiān, huò wéi lún wáng, tǒng shè sì zhōu, wēi dé zì zài, ān lì wú liàng bǎi qiān yǒu qíng yú shí shàn dào;",
                chinese: "或有因此生於天上,雖生天上,而本善根亦未窮盡,不復更生諸餘惡趣。天上壽盡,還生人間,或為輪王,統攝四洲,威德自在,安立無量百千有情於十善道;"
            ),
            Verse(
                number: 4,
                text: "Or, they may be born as a ksatriya, a brahmin, or a member of a prominent, prosperous family with numerous relatives and overflowing abundance of wealth and material possessions.",
                pinyin: "huò shēng chà dì lì、pó luó mén、jū shì dà jiā, duō ráo cái bǎo, cāng kù yíng yì, xíng xiāng duān zhèng,",
                chinese: "或生剎帝利、婆羅門、居士大家,多饒財寶,倉庫盈溢,形相端正,"
            )
        ]
        for verse in mbChapter7.verses {
            verse.chapter = mbChapter7
        }
        
        let mbChapter8 = Chapter(number: 8, title: "Additional Benefits")
        mbChapter8.text = medicineBuddhaSutra
        mbChapter8.verses = [
            Verse(
                number: 1,
                text: "They will have a pleasing appearance, and are astute, wise, courageous, and valiant, possessing physical health, strength, and energy. Or, if they were previously women, and were able to hear the name of the Medicine Buddha of Pure Crystal Radiance and wholeheartedly receive and uphold it, they will not again receive a woman's form.",
                pinyin: "juàn shǔ jù zú, cōng míng zhì huì, yǒng jiàn wēi měng, rú dà lì shì。ruò shì nǚ rén, dé wén shì zūn yào shī liú lí guāng rú lái míng hào, zhì xīn shòu chí, yú hòu bù fù gèng shòu nǚ shēn。」",
                chinese: "眷屬具足,聰明智慧,勇健威猛,如大力士。若是女人,得聞世尊藥師琉璃光如來名號,至心受持,於後不復更受女身。」"
            ),
            Verse(
                number: 2,
                text: "Manjusri, at the time of his enlightenment and due to the strength of his original vows, the Medicine Buddha of Pure Crystal Radiance was capable of seeing numerous sentient beings encountering various forms of illness, such as emaciation, yellow fever, and disorientation due to magical practices. He also observed them suffering due to premature demise, or an unexpected or violent death.",
                pinyin: "「fù cì, màn shū shì lì! bǐ yào shī liú lí guāng rú lái dé pú tí shí, yóu běn yuàn lì, guān zhū yǒu qíng, yù zhòng bìng kǔ shòu luán、gān xiāo、huáng rè děng bìng; huò bèi yǎn měi、gǔ dú suǒ zhòng; huò fù duǎn mìng, huò shí héng sǐ;",
                chinese: "「復次,曼殊室利!彼藥師琉璃光如來得菩提時,由本願力,觀諸有情,遇眾病苦瘦攣、乾消、黃熱等病;或被魘魅、蠱毒所中;或復短命,或時橫死;"
            ),
            Verse(
                number: 3,
                text: "Wanting to relieve these beings' suffering and illness, to fulfill all that they sought, he then, at that moment, entered into the samadhi called 'Eliminating the Suffering and Agitation of All Beings.' Upon entering meditative absorption, a great light emanated from the crown of the Buddha's head. Immersed in this light, the Buddha then recited a great dharani:",
                pinyin: "yù lìng shì děng bìng kǔ xiāo chú suǒ qiú yuàn mǎn。」shí bǐ shì zūn rù sān mó dì, míng yuē chú miè yī qiè zhòng shēng kǔ nǎo; jì rù dìng yǐ, yú ròu jì zhōng, chū dà guāng míng, guāng zhōng yǎn shuō dà tuó luó ní yuē:",
                chinese: "欲令是等病苦消除所求願滿。」時彼世尊入三摩地,名日除滅一切眾生苦惱;既入定已,於肉髻中,出大光明,光中演說大陀羅尼曰:"
            ),
            Verse(
                number: 4,
                text: "Namo Bhagavat Bhaisajyaguruvaiduryaprabharajaya tathagataya arhate samyaksambuddhaya tadyatha Om bhaisajye bhaisajye-bhaisajya samudgate svaha.",
                pinyin: "「nán mó bó qié fá dì, pí shā shè jù lú, bì liú lí, bō là pó hē là shé yě, dá tā jiē duō yē, ā là hē dì, sān miǎo sān bó tuó yē。dá zhí tā ān! pí shā shì, pí shā shì, pí shā shè, sān mò jiē dì! suō hē! 」",
                chinese: "「南謨薄伽伐帝,鞞殺社實嚕,薛琉璃,缽刺婆喝囉闍也,怛他揭多耶,阿囉喝帝,三藐三勃陀耶。怛姪他 唵!鞞殺逝,鞞殺逝,鞞殺社,三沒揭帝!莎訶! 」"
            ),
            Verse(
                number: 5,
                text: "After he uttered the dharani in the midst of such great light, the earth began trembling and sent forth a great radiance. All sentient beings' illnesses and suffering were healed, and they enjoyed total ease of body and mind.",
                pinyin: "ěr shí, guāng zhōng shuō cǐ zhòu yǐ, dà dì zhèn dòng, fàng dà guāng míng, yī qiè zhòng shēng bìng kǔ jiē chú, shòu ān yǐn lè。「màn shū shì lì! ruò jiàn nán zǐ、nǚ rén, yǒu bìng kǔ zhě, yīng dāng yī xīn wéi",
                chinese: "爾時,光中說此咒已,大地震動,放大光明,一切眾生病苦皆除,受安隱樂。「曼殊室利!若見男子、女人,有病苦者,應當一心為"
            ),
            Verse(
                number: 6,
                text: "Manjusri, if you see men and women who suffer from illness you should, with a devoted heart and mind, help bathe them, cleanse their mouths, and administer food, medicine, or water which has been purified through one hundred and eight recitations of the dharani. All their illness and suffering shall thereupon be extinguished.",
                pinyin: "bǐ bìng rén, cháng qīng jìng zǎo shù, huò shí、huò yào、huò wú chóng shuǐ、zhòu yī bǎi bā biàn, yǔ bǐ fú shí, suǒ yǒu bìng kǔ xī jiē xiāo miè。",
                chinese: "彼病人,常清淨澡漱,或食、或藥、或無蟲水、咒百八遍,與彼服食,所有病苦悉皆消滅。"
            ),
            Verse(
                number: 7,
                text: "If there is something they wish for, by reciting the dharani wholeheartedly, they shall obtain it. Thus, they shall enjoy long lives free from illness. After their lives have come to an end, they shall be reborn in the realm of the Medicine Buddha, where, without any regression, they advance to supreme enlightenment.",
                pinyin: "ruò yǒu suǒ qiú, zhì xīn niàn sòng, jiē dé rú shì wú bìng yán nián; mìng zhōng zhī hòu, shēng bǐ shì jiè, dé bù tuì zhuǎn, nǎi zhì pú tí。",
                chinese: "若有所求,志心念誦,皆得如是無病延年;命終之後,生彼世界,得不退轉,乃至菩提。"
            ),
            Verse(
                number: 8,
                text: "Manjusri, there are men and women who wholeheartedly, earnestly, and respectfully make offerings to the Medicine Buddha of Pure Crystal Radiance and who often uphold this dharani without neglect, never forgetting it.",
                pinyin: "shì gù màn shū shì lì! ruò yǒu nán zǐ、nǚ rén, yú bǐ yào shī liú lí guāng rú lái, zhì xīn yīn zhòng gōng jìng gòng yǎng zhě, cháng chí cǐ zhòu, wù lìng fèi wàng。",
                chinese: "是故曼殊室利!若有男子、女人,於彼藥師琉璃光如來,至心殷重恭敬供養者,常持此咒,勿令廢忘。"
            ),
            Verse(
                number: 9,
                text: "Also, Manjusri, there are men and women of pure faith who have the chance to hear and recite all the titles of the Medicine Buddha of Pure Crystal Radiance, who chew on the teeth-cleansing twig, rinse their mouths, and bathe their bodies before they offer fragrant flowers and incense and various kinds of devotional music to the image of the Medicine Buddha.",
                pinyin: "「fù cì, màn shū shì lì! ruò yǒu jìng xìn nán zǐ、nǚ zǐ rén, dé wén yào shī liú lí guāng rú lái、yìng、zhèng děng jué suǒ yǒu míng hào wén yǐ sòng chí; chén jué chǐ mù, zǎo shù qīng jìng, yǐ zhū xiāng huā、shāo xiāng、tú xiāng、zuò zhòng jì yuè, gòng yǎng xíng xiàng。",
                chinese: "「復次,曼殊室利!若有淨信男子、女子人,得聞藥師琉璃光如來、應、正等覺所有名號聞已誦持;晨嚼齒木,澡漱清淨,以諸香華、燒香、塗香、作眾伎樂,供養形像。"
            ),
            Verse(
                number: 10,
                text: "Then there are those who record or copy the sutra or teach others to transcribe it, and who listen to the sutra and understand its meaning, thereupon wholeheartedly upholding it. If there is a monastic who specializes in teaching the practice of the Medicine Buddha, one should offer all that is necessary for daily living, ensuring that the teacher lacks nothing.",
                pinyin: "yú cǐ jīng diǎn, ruò zì shū, ruò jiào rén shū, xīn shòu chí, tīng wén qí yì。yú bǐ fǎ shī, yīng xiū gòng yǎng: yī qiè suǒ yǒu zī shēn zhī jù, xī jiē shī yǔ, wù lìng fá shǎo;",
                chinese: "於此經典,若自書,若教人書,心受持,聽聞其義。於彼法師,應修供養:一切所有資身之具,悉皆施與,勿令乏少;"
            ),
            Verse(
                number: 11,
                text: "All of these mentioned will thereupon be protected and will be in the awareness of all Buddhas; that which they wish for will be fulfilled on their path to enlightenment.",
                pinyin: "rú shì biàn méng zhū fó hù niàn, suǒ qiú yuàn mǎn, nǎi zhì pú tí。」",
                chinese: "如是便蒙諸佛護念,所求願滿,乃至菩提。」"
            )
        ]
        for verse in mbChapter8.verses {
            verse.chapter = mbChapter8
        }
        
        let mbChapter9 = Chapter(number: 9, title: "Manjusri's Vow")
        mbChapter9.text = medicineBuddhaSutra
        mbChapter9.verses = [
            Verse(
                number: 1,
                text: "At that time, Manjusri spoke to the Buddha, \"World-Honored One, I will vow, at the time of the Period of Semblance Dharma, with various skillful means, to make it possible for all good men and women of pure faith to hear the titles of the World-Honored Medicine Buddha of Pure Crystal Radiance. Even while asleep they are able to awaken to truth upon hearing this sound in their ears.",
                pinyin: "ěr shí, màn shū shì lì tóng zǐ bái fó yán: 「shì zūn! wǒ dāng shì yú xiàng fǎ zhuǎn shí, yǐ zhǒng zhǒng fāng biàn, lìng zhū jìng xìn shàn nán zǐ shàn nǚ rén děng, dé wén shì zūn yào shī liú lí guāng rú lái míng hào nǎi zhì shuì zhōng yì yǐ fó míng jué wù qí ěr。",
                chinese: "爾時,曼殊室利童子白佛言:「世尊!我當誓於像法轉時,以種種方便,令諸淨信善男子、善女人等,得聞世尊藥師琉璃光如來名號乃至睡中亦以佛名覺悟其耳。"
            ),
            Verse(
                number: 2,
                text: "I will also make possible the upholding of this sutra through various skillful means such as recitation, explication of its profound meaning, self-practice through transcribing, or teaching others to transcribe it. Other means also include respectfully making offerings to the sutra itself by cleaning and purifying its environment and preparing an elevated place such as an altar upon which the sutra can be placed.",
                pinyin: "shì zūn! ruò yú cǐ jīng shòu chí dú sòng, huò fù wèi tā yǎn shuō kāi shì; ruò zì shū; ruò jiào rén shū; gōng jìng zūn zhòng, yǐ zhǒng zhǒng huā xiāng、tú xiāng、mò xiāng、shāo xiāng、huā mán、yīng luò、fān gài、jì yuè, ér wéi gòng yǎng; yǐ wǔ sè cǎi, zuò náng chéng zhī; sǎo sǎ jìng chù, fū shè gāo zuò, ér yòng ān chù。",
                chinese: "世尊!若於此經受持讀誦,或復為他演說開示;若自書;若教人書;恭敬尊重,以種種華香、塗香、末香、燒香、華鬘、瓔珞、幡蓋、伎樂,而為供養;以五色綵,作囊盛之;掃灑淨處,敷設高座,而用安處。"
            ),
            Verse(
                number: 3,
                text: "Upon the completion of these offerings, the Four Heavenly Kings and their retinue of hundreds of thousands of heavenly beings shall arrive at that place and offer their protection.",
                pinyin: "ěr shí, sì dà tiān wáng yǔ qí juàn shǔ, jí yú wú liàng bǎi qiān tiān zhòng, jiē yì qí suǒ, gòng yǎng shǒu hù。",
                chinese: "爾時,四大天王與其眷屬,及餘無量百千天眾,皆詣其所,供養守護。"
            ),
            Verse(
                number: 4,
                text: "World-Honored One, wherever this precious sutra is introduced and practiced, due to the virtue of the original vows of the Medicine Buddha of Pure Crystal Radiance, the hearing of his titles, and the upholding of this sutra, that place shall be free from the occurrence of any violent deaths. Those living in this area shall not be deprived of their vital energy. For those who have been deprived of their vital energy in this manner, they shall have it returned to them and enjoy peace of body and mind.",
                pinyin: "「shì zūn! ruò cǐ jīng bǎo liú xíng zhī chù, yǒu néng shòu chí, yǐ bǐ shì zūn yào shī liú lí guāng rú lái běn yuàn gōng dé, jí wén míng hào, dāng zhī shì chù wú fù héng sǐ; yì fù bù wéi zhū è guǐ shén, duó qí jīng qì; shè yǐ duó zhě, huán dé rú gù, shēn xīn ān lè。」",
                chinese: "「世尊!若此經寶流行之處,有能受持,以彼世尊藥師琉璃光如來本願功德,及聞名號,當知是處無復橫死;亦復不為諸惡鬼神,奪其精氣;設已奪者,還得如故,身心安樂。」"
            ),
            Verse(
                number: 5,
                text: "The Buddha then responded to Manjusri, \"Yes! Yes! It is as you have said, Manjusri. If there are men and women of pure practice who desire to make offerings to the World-Honored Medicine Buddha of Pure Crystal Radiance, they should first place an image of that Buddha in a clean, peaceful place and surround it with various flowers, fragrant burning incense, and colorful streamers and banners.",
                pinyin: "fó gào màn shū shì lì: 「rú shì! rú shì! rú rǔ suǒ shuō。màn shū shì lì! ruò yǒu jìng xìn shàn nán zǐ shàn nǚ rén děng, yù gòng yǎng bǐ shì zūn yào shī liú lí guāng rú lái zhě, yīng xiān zào lì bǐ fó xíng xiàng, fū qīng jìng zuò ér ān chù zhī; sàn zhǒng zhǒng huā, shāo zhǒng zhǒng xiāng, yǐ zhǒng zhǒng chuáng",
                chinese: "佛告曼殊室利:「如是!如是!如汝所說。曼殊室利!若有淨信善男子、善女人等,欲供養彼世尊藥師琉璃光如來者,應先造立彼佛形像,敷清淨座而安處之;散種種華,燒種種香,以種種幢"
            ),
            Verse(
                number: 6,
                text: "For seven days and nights, they should uphold the eight purification precepts, eat vegetarian meals, bathe their bodies to become clean and fragrant, and wear clean clothing. A mind free from turbidity, anger, and the desire to harm will give rise to a beneficial mind of peace, loving-kindness, compassion, joy, equanimity, and equality for all sentient beings.",
                pinyin: "fān zhuāng yán qí chù qī rì qī yè, shòu bā fēn zhāi jiè, shí qīng jìng shí, zǎo yù xiāng jié, zhuó qīng jìng yī, yīng shēng wú gòu zhuó xīn, wú nù hài xīn, yú yī qiè yǒu qíng qǐ lì yì ān lè, cí、bēi、xǐ、shě, píng děng zhī xīn;",
                chinese: "幡莊嚴其處七日七夜,受八分齋戒,食清淨食,澡浴香潔,著清淨衣,應生無垢濁心,無怒害心,於一切有情起利益安樂,慈、悲、喜、捨,平等之心;"
            ),
            Verse(
                number: 7,
                text: "They should circle the Buddha statue in a clockwise direction, drumming and singing songs of joyous praise. They should also contemplate the Buddha's vows of great virtue, study and recite this sutra, consider its meaning, and speak to reveal the profound teaching. If these pure practices are followed, all their wishes shall be granted: those who seek long life shall gain long life; those who seek abundant wealth shall gain abundant wealth; those who seek a government post shall receive such; and those who seek the birth of a male or female child shall be granted such.",
                pinyin: "gǔ yuè gē zàn, yòu rào fó xiàng。fù yīng niàn bǐ rú lái běn yuàn gōng dé, dú sòng cǐ jīng, sī wéi qí yì, yǎn shuō kāi shì。suí suǒ lè qiú, yī qiè jiē suì; qiú cháng shòu dé cháng shòu, qiú fù ráo dé fù ráo, qiú guān wèi dé guān wèi, qiú nán nǚ dé nán nǚ。",
                chinese: "鼓樂歌讚,右遶佛像。復應念彼如來本願功德,讀誦此經,思惟其義,演說開示。隨所樂求,一切皆遂;求長壽得長壽,求富饒得富饒,求官位得官位,求男女得男女。"
            ),
            Verse(
                number: 8,
                text: "If one unexpectedly experiences nightmares, apparitions, the ominous gathering of strange birds, or the arising of various strange phenomena around his or her residence, should he or she respectfully make offerings of numerous exquisite material objects, all these omens shall disappear without doing any harm.",
                pinyin: "ruò fù yǒu rén, hū dé è mèng, jiàn zhū è xiàng; huò guài niǎo lái jí, huò yú zhù chù bǎi guài chū xiàn; cǐ rén ruò yǐ zhòng miào zī jù, gōng jìng gòng yǎng bǐ shì zūn yào shī liú lí guāng rú lái zhě, è mèng è xiàng zhū bù jí xiáng, jiē xī yǐn mò, bù néng wéi huàn。",
                chinese: "若復有人,忽得惡夢,見諸惡相;或怪鳥來集,或於住處百怪出現;此人若以眾妙資具,恭敬供養彼世尊藥師琉璃光如來者,惡夢惡相諸不吉祥,皆悉隱沒,不能為患。"
            ),
            Verse(
                number: 9,
                text: "If there are those who encounter fears due to flood, fire, calamities of warfare, near-death experiences, or vicious wild creatures such as elephants, lions, tigers, wolves, brown bears, poisonous snakes, scorpions, centipedes, millipedes, mosquitoes, and biting flies, when they wholeheartedly contemplate the Buddha and respectfully make offerings to him, all their fears shall subside.",
                pinyin: "huò yǒu shuǐ、huǒ、dāo、dú、xuán xiǎn、è xiàng、shī zǐ、hǔ、láng、xióng、pí、dú shé、è xiē、wú gōng、yóu yán、wén méng děng bù; ruò néng zhì xīn yì niàn bǐ fó, gōng jìng gòng yǎng, yī qiè bù wèi jiē dé jiě tuō。",
                chinese: "或有水、火、刀、毒、懸險、惡象、師子、虎、狼、熊、羅、毒蛇、惡蠍、蜈蚣、蚰蜒、蚊蚊等怖;若能至心憶念彼佛,恭敬供養,一切怖畏皆得解脫。"
            ),
            Verse(
                number: 10,
                text: "If they have fears of being invaded by other countries, internal rebellions, or the activities of robbers and thieves, upon respectfully contemplating the Buddha, they shall find relief from these fears.",
                pinyin: "ruò tā guó qīn rǎo, dào zéi fǎn luàn; yì niàn gōng jìng bǐ rú lái zhě, yì jiē jiě tuō。",
                chinese: "若他國侵擾,盜賊反亂;憶念恭敬彼如來者,亦皆解脫。"
            )
        ]
        for verse in mbChapter9.verses {
            verse.chapter = mbChapter9
        }
        
        let mbChapter10 = Chapter(number: 10, title: "Protection and Benefits")
        mbChapter10.text = medicineBuddhaSutra
        mbChapter10.verses = [
            Verse(
                number: 1,
                text: "Again, Manjusri, let us suppose that good men and women of pure faith, who even unto death have not followed the path of any other faith, take refuge in the Buddha, the Dharma, and the Sangha and uphold the various sets of precepts, such as the five precepts, the ten precepts, the four hundred bodhisattva precepts, the two hundred and fifty bhiksu precepts, and the five hundred bhiksuni precepts.",
                pinyin: "「fù cì, màn shū shì lì! ruò yǒu jìng xìn shàn nán zǐ shàn nǚ rén děng, nǎi zhì jìn xíng bù shì yú tiān, wéi dāng yī xīn, guī fó、fǎ、sēng, shòu chí jìn jiè, ruò wǔ jiè、shí jiè、pú sà sì bǎi jiè, bì chú èr bǎi wǔ shí jiè、bì chú ní wǔ bǎi jiè。",
                chinese: "「復次,曼殊室利!若有淨信善男子、善女人等,乃至盡形不事餘天,唯當一心,歸佛、法、僧,受持禁戒,若五戒、十戒、菩薩四百戒,苾芻二百五十戒、苾芻尼五百戒。"
            ),
            Verse(
                number: 2,
                text: "If, in the midst of upholding these precepts, they violate any of them and thus become fearful of falling into the three lower realms upon rebirth, should they become absorbed in the contemplation of the Buddha's titles and respectfully make offerings, they can be certain of no further rebirth in these realms.",
                pinyin: "yú suǒ shòu zhōng, huò yǒu huǐ fàn, bù duò qù, ruò néng zhuān niàn bǐ fó míng hào, gōng jìng gòng yǎng zhě, bì dìng bù shòu sān è qù shēng。",
                chinese: "於所受中或有毀犯,怖墮趣,若能專念彼佛名號,恭敬供養者,必定不受三惡趣生。"
            ),
            Verse(
                number: 3,
                text: "When an expectant mother is experiencing the pains of labor, by chanting the Buddha's name as an offering, all of her fears and pain shall be removed. Due to the smooth delivery, the form and five faculties of the baby shall be perfectly complete. His or her countenance shall be very pleasant, such that people will be delighted when they see the baby. This child shall be inherently astute, enjoy a peaceful existence, and encounter little illness. No non-human being shall be capable of seizing that child's vital energy.",
                pinyin: "huò yǒu nǚ rén, lín dāng chǎn shí, shòu yú jí kǔ; ruò néng zhì xīn chēng míng lǐ zàn, gōng jìng gòng yǎng bǐ rú lái zhě, zhòng kǔ jiē chú。suǒ shēng zhī zǐ, shēn fēn jù zú, xíng sè duān zhèng, jiàn zhě huān xǐ, lì gēn cōng míng, ān yǐn shǎo bìng, wú yǒu fēi rén duó qí jīng qì。」",
                chinese: "或有女人,臨當產時,受於極苦;若能志心稱名禮讚,恭敬供養彼如來者,眾苦皆除。所生之子,身分具足,形色端正,見者歡喜,利根聰明,安隱少病,無有非人奪其精氣。」"
            ),
            Verse(
                number: 4,
                text: "At that time, the World-Honored One spoke to Ananda saying, \"Thus I praise all the virtues of the World-Honored Medicine Buddha of Pure Crystal Radiance. This virtuous state is shared by all Buddhas as a result of their deep and profound practice, but it is very difficult for ordinary people to understand. How about you, Ananda, do you trust this?\"",
                pinyin: "ěr shí, shì zūn gào ā nán yán: 「rú wǒ chēng yáng bǐ shì zūn yào shī liú lí guāng rú lái suǒ yǒu gōng dé, cǐ shì zhū fó shèn shēn suǒ xíng chù, nán kě xìn jiě; rú jīn néng shòu, dāng zhī jiē shì rú lái wēi lì。",
                chinese: "爾時,世尊告阿難言:「如我稱揚彼世尊藥師琉璃光如來所有功德,此是諸佛甚深所行處,難可信解;汝今能受,當知皆是如來威力。"
            ),
            Verse(
                number: 5,
                text: "Ananda replied, 'World-Honored One, with regard to the sutra spoken by the Buddha, I have absolutely no doubts concerning it. Why is that so? Because all the activities proceeding from the Buddha's body, speech, and mind are already completely pure. Even though the sun and moon may fall from the sky, even though the tallest mountain may collapse, the words of every Buddha are not subject to change.",
                pinyin: "ā nán bái yán: 「dà dé shì zūn! wǒ yú rú lái suǒ shuō qì jīng bù shēng yí huò。suǒ yǐ zhě hé? yī qiè rú lái shēn yǔ yì yè, wú bù qīng jìng。shì zūn! rì yuè lún, kě lìng duò luò; miào gāo shān wáng, kě shǐ qīng dòng, zhū fó suǒ yán, wú yǒu yì yě。",
                chinese: "阿難白言:「大德世尊!我於如來所說契經不生疑惑。所以者何?一切如來身語意業,無不清淨。世尊!日月輪,可令墮落;妙高山王,可使傾動,諸佛所言,無有異也。"
            ),
            Verse(
                number: 6,
                text: "World-Honored One, there are many beings who are not equipped with the roots of faith. Upon hearing the description of the profound state shared by all Buddhas, these beings question why such a multitude of remarkable benefits would accrue to one who simply contemplates and recites the titles of the Medicine Buddha of Pure Crystal Radiance. Due to this lack of trust, they even go so far as to engage in slander.",
                pinyin: "shì zūn! yǒu zhū zhòng shēng, xìn gēn bù jù, wén shuō zhū fó shèn shēn suǒ xíng chù, zuò shì sī wéi; yún hé dàn niàn yào shī liú lí guāng rú lái yī fó míng hào, biàn huò ěr suǒ gōng dé shèng lì? yóu cǐ bù xìn, fǎn shēng fěi bàng;",
                chinese: "世尊!有諸眾生,信根不具,聞說諸佛甚深所行處,作是思惟;云何但念藥師琉璃光如來一佛名號,便獲爾所功德勝利?由此不信,返生誹謗;"
            ),
            Verse(
                number: 7,
                text: "As a result, they remain in the endless darkness of ignorance, thus losing the opportunity for great benefit and happiness, and repeatedly fall into the various lower realms. The Buddha thus spoke to Ananda, \"For those particular sentient beings, if they hear the titles of the World-Honored Medicine Buddha of Pure Crystal Radiance and uphold them without doubt and bewilderment, there is no point in even being concerned about falling into lower realms of rebirth.",
                pinyin: "bǐ yú cháng yè, shī dà lì lè, duò zhū è qù, liú zhuǎn wú qióng。」fó gào ā nán: 「shì zhū yǒu qíng, ruò wén shì zūn yào shī liú lí guāng rú lái míng hào, zhì xīn shòu chí, bù shēng yí huò, duò è qù zhě, wú yǒu shì chù。",
                chinese: "彼於長夜,失大利樂,墮諸惡趣,流轉無窮。」佛告阿難:「是諸有情,若聞世尊藥師琉璃光如來名號,至心受持,不生疑惑,墮惡趣者,無有是處。"
            ),
            Verse(
                number: 8,
                text: "Ananda, this is the deep and profound practice of all Buddhas, found difficult to believe and understand by most. Your comprehension of this can be ascribed to the power of the Buddha's practices as well, Ananda. All sravakas, pratyeka-buddhas, and bodhisattvas who have not yet ascended the first of the ten stages of bodhisattva development are not yet able to understand and know the true nature of this practice.",
                pinyin: "ā nán! cǐ shì zhū fó shèn shēn suǒ xíng, nán kě xìn jiě; rú jīn néng shòu, dāng zhī jiē shì rú lái wēi lì。ā nán! yī qiè shēng wén、dú jué、jí wèi dēng dì zhū pú sà děng, jiē xī bù néng rú shí xìn jiě;",
                chinese: "阿難!此是諸佛甚深所行,難可信解;汝今能受,當知皆是如來威力。阿難!一切聲聞、獨覺、及未登地諸菩薩等,皆悉不能如實信解;"
            ),
            Verse(
                number: 9,
                text: "Only those bodhisattvas who will attain Buddhahood in their next lifetime are capable of true understanding. Ananda, it is difficult to be reborn in human form. Having faith and respect in the Triple Gem is also not easy. Most difficult to achieve, however, is the opportunity to hear the titles of the World-Honored Medicine Buddha of Pure Crystal Radiance.",
                pinyin: "wéi chú shēng suǒ xì pú sà。ā nán! rén shēn nán dé; yú sān bǎo zhōng, xìn jìng zūn zhòng, yì nán kě dé; wén shì zūn yào shī liú lí guāng rú lái míng hào, fù nán yú shì。",
                chinese: "唯除生所繫菩薩。阿難!人身難得;於三寶中,信敬尊重,亦難可得;聞世尊藥師琉璃光如來名號,復難於是。"
            ),
            Verse(
                number: 10,
                text: "Ananda, the Medicine Buddha of Pure Crystal Radiance has practiced endless bodhisattva spiritual disciplines, as well as developed innumerable wonderful skillful means and achieved numerous great vows. Were I to elaborate on this Buddha's disciplines, skillful means, and vows for one kalpa or more, I could not describe them completely for they are vast and limitless.",
                pinyin: "ā nán! bǐ yào shī liú lí guāng rú lái; wú liàng pú sà xíng; wú liàng shàn qiǎo fāng biàn; wú liàng guǎng dà yuàn; wǒ ruò yī jié, ruò yī jié yú ér guǎng shuō zhě, jié kě sù jìn, bǐ fó xíng yuàn shàn qiǎo fāng biàn, wú yǒu jìn yě!」",
                chinese: "阿難!彼藥師琉璃光如來;無量菩薩行;無量善巧方便;無量廣大願;我若一劫,若一劫餘而廣說者,劫可速盡,彼佛行願善巧方便,無有盡也!」"
            )
        ]
        for verse in mbChapter10.verses {
            verse.chapter = mbChapter10
        }
        
        let mbChapter11 = Chapter(number: 11, title: "Rescuing Aid Bodhisattva")
        mbChapter11.text = medicineBuddhaSutra
        mbChapter11.verses = [
            Verse(
                number: 1,
                text: "Subsequently, a great bodhisattva named Rescuing Aid Bodhisattva arose from the audience. With bared right shoulder and bowing upon his right knee with joined palms, he respectfully said to the Buddha, \"Great Virtuous World-Honored One, during the Period of Semblance Dharma, there will be many sentient beings who will be trapped by various kinds of suffering and adversity.",
                pinyin: "ěr shí, zhòng zhōng yǒu yī pú sà mó hē sà, míng yuē jiù tuō, cóng zuò ér qǐ, piān tǎn yòu jiān, yòu xī guì dì, hé zhǎng gōng jìng, bái fó yán: 「dà dé shì zūn!",
                chinese: "爾時,眾中有一菩薩摩訶薩,名曰救脫,從座而起,偏袒右肩,右膝跪地,合掌恭敬,白佛言:「大德世尊!"
            ),
            Verse(
                number: 2,
                text: "They will experience long periods of illness and grow weak and feeble. Unable to eat and drink, their lips and throats will become parched and dry. No matter where they look, they shall see only darkness and exhibit all the symptoms of approaching death. Their mothers, fathers, relatives, and friends will gather around them, weeping and wailing.",
                pinyin: "xiàng fǎ zhuǎn shí, yǒu zhū zhòng shēng, wèi zhū bìng kǔ suǒ jí, cháng bìng yíng shòu, bù néng shí yǐn, chún kǒu gān zào, jiàn zhě chù mù, shēng sǐ zhī xiàng; fù mǔ、qīn shǔ、péng yǒu, zhī shí, wéi rào ér kū;",
                chinese: "像法轉時,有諸眾生,為諸病苦所逼,長病羸瘦,不能飲食,唇口乾燥,見者觸目,生死之相;父母、親屬、朋友、知識,圍繞而哭;"
            ),
            Verse(
                number: 3,
                text: "However, unaware of all the concern that surrounds them, those on their deathbeds will be experiencing the arrival of the Judgment King of Hell's messenger, who escorts the consciousnesses of those who are dying into the presence of the King. Subsequently, these beings clearly recollect all their own deeds, both good and bad, record them and deliver their lists of deeds to the Judgment King of Hell.",
                pinyin: "rán bǐ bìng rén, běn wù suǒ zhī, jiàn zhū è guǐ, shǐ zhě lái qū; qí shén shí, zhì yú yǎn mó fǎ wáng zhī qián; rán zhū yǒu qíng, yǒu jù shēng shén, suí qí suǒ zuò ruò zuì ruò fú, jiē jù shū zhī, jìn chí shòu yǔ yǎn mó fǎ wáng。",
                chinese: "然彼病人,本無所知,見諸惡鬼,使者來取;其神識,至於琰魔法王之前;然諸有情,有俱生神,隨其所作若罪若福,皆具書之,盡持授與琰魔法王。"
            ),
            Verse(
                number: 4,
                text: "Thereafter, the King will interrogate them, and after considering the number of good and bad deeds, he will deliver an appropriate decision concerning their lives. If, at that time, the parents, relatives, and friends of those who are sick take refuge in the World-Honored Medicine Buddha of Pure Crystal Radiance, request many monastics to recite this sutra, light lamps, and make offerings, the consciousness of the sick person will be able to return.",
                pinyin: "ěr shí, bǐ wáng tuī wèn qí rén, jì suàn suǒ zuò, suí qí zuì fú ér chù duàn zhī。shí bǐ bìng rén qīn shǔ、zhī shí, ruò néng wéi bǐ guī yī shì zūn yào shī liú lí guāng rú lái, qǐng zhū zhòng sēng, zhuǎn dú cǐ jīng, rán děng fàng guāng, xiū zhū gòng yǎng, bǐ bìng rén shén shí, hái dé sù huán。",
                chinese: "爾時,彼王推問其人,計算所作,隨其罪福而處斷之。時彼病人親屬、知識,若能為彼歸依世尊藥師琉璃光如來,請諸眾僧,轉讀此經,然燈放光,修諸供養,彼病人神識,還得甦還。"
            )
        ]
        for verse in mbChapter11.verses {
            verse.chapter = mbChapter11
        }
        
        let mbChapter12 = Chapter(number: 12, title: "Practices for the Sick")
        mbChapter12.text = medicineBuddhaSutra
        mbChapter12.verses = [
            Verse(
                number: 1,
                text: "If, at that time, the parents, relatives, and friends of those who are sick take refuge in the World-Honored Medicine Buddha of Pure Crystal Radiance, request many monastics to recite this sutra, light seven layers of lamps, display the five-colored longevity banners, or undertake any similar practices on behalf of those who are sick, their consciousnesses could return after seven, twenty-one, thirty-five, or forty-nine days.",
                pinyin: "qī céng zhī děng, xuán wǔ sè xù mìng shén fān, huò yǒu shì chù, bǐ shí dé huán。rú zài mèng zhōng, míng liǎo zì jiàn; huò jīng qī rì, huò èr shí yī rì, huò sān shí wǔ rì, huò sì shí jiǔ rì, bǐ shí huán shí, rú cóng mèng jué, jiē zì yì zhī shàn bù shàn yè, suǒ dé guǒ bào。",
                chinese: "七層之燈,懸五色續命神旛,或有是處,彼識得還。如在夢中,明了自見;或經七日,或二十一日,或三十五日,或四十九日,彼識還時,如從夢覺,皆自憶知善不善業,所得果報。"
            ),
            Verse(
                number: 2,
                text: "When their consciousnesses return, it is like waking up from a dream. Through this experience, they remember all their good and bad deeds as well as the karmic retribution, thus proving to themselves the connection between cause and effect. Afterwards, they will no longer engage in activities that create bad karma. Therefore, all good men and women of pure faith should receive and uphold the titles of the Medicine Buddha of Pure Crystal Radiance according to their ability, and respectfully make offerings to him.",
                pinyin: "yóu zì zhèng jiàn yè guǒ bào gù, nǎi zhì mìng nán, yì bù zào zuò zhū è zhī yè。shì gù jìng xìn shàn nán zǐ、shàn nǚ rén děng, jiē yīng shòu chí yào shī liú lí guāng rú lái míng hào, suí lì suǒ néng, gōng jìng gòng yǎng。」",
                chinese: "由自證見業果報故,乃至命難,亦不造作諸惡之業。是故淨信善男子、善女人等,皆應受持藥師琉璃光如來名號,隨力所能,恭敬供養。」"
            ),
            Verse(
                number: 3,
                text: "Then, Ananda asked Rescuing Aid Bodhisattva, \"How should one make offerings to the Buddha? Furthermore, concerning the longevity banners and lamps, how should one engage in this type of activity?\"",
                pinyin: "ěr shí, ā nán wèn jiù tuō pú sà yuē: 「shàn nán zǐ! yīng yún hé gōng jìng gòng yǎng bǐ shì zūn yào shī liú lí guāng rú lái? xù mìng fān děng fù yún hé zào?」",
                chinese: "爾時,阿難問救脫菩薩曰:「善男子!應云何恭敬供養彼世尊藥師琉璃光如來?續命旛燈復云何造?」"
            ),
            Verse(
                number: 4,
                text: "Rescuing Aid Bodhisattva said, \"Great Virtuous One, if there are sick people who seek relief from their suffering, those who care about them can, on their behalf, uphold the eight purification precepts for seven days and nights. According to their means, they can make offerings of food, drink, and other material needs to monastics. Throughout the day, they can bow and make offerings before the World-Honored Medicine Buddha of Pure Crystal Radiance, recite this sutra forty-nine times, and light forty-nine lamps.",
                pinyin: "jiù tuō pú sà yán: 「dà dé! ruò yǒu bìng rén, yù tuō bìng kǔ, dāng wéi qí rén qī rì qī yè, shòu chí bā fēn zhāi jiè。yīng yǐ yǐn shí jí yú zī jù, suí lì suǒ bàn, gòng yǎng bì chú sēng; zhòu yè liù shí, lǐ bài gòng yǎng bǐ shì zūn yào shī liú lí guāng rú lái; dú sòng cǐ jīng sì shí jiǔ biàn; rán sì shí jiǔ děng;",
                chinese: "救脫菩薩言:「大德!若有病人,欲脫病苦,當為其人七日七夜,受持八分齋戒。應以飲食及餘資具,隨力所辦,供養苾芻僧;晝夜六時,禮拜供養彼世尊藥師琉璃光如來;讀誦此經四十九遍;然四十九燈;"
            ),
            Verse(
                number: 5,
                text: "They can create seven images of the Buddha and place seven lamps in front of each. The glow from each lamp should be as large as the circumference of the wheel of a cart, and the radiant brightness should never be extinguished during the forty-nine days. They can assemble the splendid five-colored longevity banners, each of which is composed of forty-nine three-finger-length sections. Also, they can set free forty-nine living beings of various kinds. Through these activities, sick individuals are supported in overcoming danger and distress, and are immune to being held hostage by any evil spirit.",
                pinyin: "zào bǐ rú lái xíng xiàng qī qū, xiàng qián gè zhì qī děng, yī děng liàng dà rú chē lún, nǎi zhì sì shí jiǔ rì guāng míng bù jué, zào wǔ sè cǎi fān, cháng sì shí jiǔ tàn shǒu; yīng fàng zá lèi zhòng shēng zhì sì shí jiǔ; kě dé guò dù wēi è zhī nán, bù wéi zhū héng è guǐ suǒ chí。」",
                chinese: "造彼如來形像七軀,像前各置七燈,一燈量大如車輪,乃至四十九日光明不絕,造五色綵旛,長四十九探手;應放雜類眾生至四十九;可得過度危厄之難,不為諸橫惡鬼所持。」"
            )
        ]
        for verse in mbChapter12.verses {
            verse.chapter = mbChapter12
        }
        
        let mbChapter13 = Chapter(number: 13, title: "Protection for Countries")
        mbChapter13.text = medicineBuddhaSutra
        mbChapter13.verses = [
            Verse(
                number: 1,
                text: "Again, Ananda, if calamities such as epidemics, invasions, internal rebellions, strange changes in constellations, solar and lunar eclipses, untimely wind and rain, or drought arise in a country, the ruler of that country should give rise to the heart and mind of compassion for all sentient beings and grant amnesty to all who are imprisoned.",
                pinyin: "「fù cì, ā nán! ruò chà dì lì、guàn dǐng wáng děng, zāi nàn qǐ shí, suǒ wèi rén zhòng jí yì nán、tā guó qīn bī nán, zì jiè pàn nì nán, xīng xiù biàn guài nán, rì yuè bó shí nán, fēi shí fēng yǔ nán, guò shí bù yǔ nán。",
                chinese: "「復次,阿難!若剎帝利、灌頂王等,災難起時,所謂人眾疾疫難、他國侵逼難,自界叛逆難,星宿變怪難,日月薄蝕難,非時風雨難,過時不雨難。"
            ),
            Verse(
                number: 2,
                text: "In reference to what I have previously suggested concerning offerings, they also can make offerings to the World-Honored Medicine Buddha of Pure Crystal Radiance on behalf of all sentient beings. Because of these good roots and the strength of the Buddha's original vows, that country will be able to quickly attain peace and stability. The wind and rain will arrive according to season and the harvest will be bountiful.",
                pinyin: "bǐ chà dì lì、guàn dǐng wáng děng, ěr shí yīng yú yī qiè yǒu qíng, qǐ cí bēi xīn shè zhū xì bì; yī qián suǒ shuō gòng yǎng zhī fǎ, gòng yǎng bǐ shì zūn yào shī liú lí guāng rú lái。yóu cǐ shàn gēn, jí bǐ rú lái běn yuàn lì gù, lìng qí guó jiè jí dé ān yǐn, fēng yǔ shùn shí, gǔ jià chéng shú;",
                chinese: "彼剎帝利、灌頂王等,爾時應於一切有情,起慈悲心赦諸繫閉;依前所說供養之法,供養彼世尊藥師琉璃光如來。由此善根,及彼如來本願力故,令其國界即得安隱,風雨順時,穀稼成熟;"
            ),
            Verse(
                number: 3,
                text: "All sentient beings will be free from illness and experience happiness. In the midst of this country there will be no yaksas, demons, and other spirits that harass sentient beings, and all evil phenomena will instantly disappear. Because the ruler engages in these activities on behalf of the populace, he shall remain energetic and enjoy a long life free from illness, in perfect ease.",
                pinyin: "yī qiè yǒu qíng, wú bìng huān lè; yú qí guó zhōng, wú yǒu bào è yào chā děng shén, nǎo yǒu qíng zhě; yī qiè è xiàng, jiē jí yǐn mò; ér chà dì lì、guàn dǐng wáng děng shòu mìng sè lì, wú bìng zì zài, jiē dé zēng yì。",
                chinese: "一切有情,無病歡樂;於其國中,無有暴惡藥叉等神,惱有情者;一切惡相,皆即隱沒;而剎帝利、灌頂王等壽命色力,無病自在,皆得增益。"
            ),
            Verse(
                number: 4,
                text: "Ananda, if the king, queen, the king's consorts, the prince, high-ranking officials, prime ministers, palace servants, officials, and the general public become troubled by illness or other difficulties, these people should assemble the five-colored longevity banners and light the lamps of continuous illumination. They also should set free a multitude of sentient beings, scatter multicolored flowers, and light numerous types of incense. Thereafter, they shall recover from the illness they have suffered and be released from their many difficulties.",
                pinyin: "ā nán! ruò dì hòu、fēi zhǔ、chǔ jūn、wáng zǐ、dà chén、fǔ xiàng、zhōng gōng、cǎi nǚ、bǎi guān、lí shù, wèi bìng suǒ kǔ, jí yú è nán; yì yīng zào lì wǔ sè shén fān, rán děng xù míng, fàng zhū shēng mìng, sàn zá sè xiāng; bìng dé chú tuō。」",
                chinese: "阿難!若帝后、妃主、儲君、王子、大臣、輔相、中宮、綵女、百官、黎庶,為病所苦,及餘厄難;亦應造立五色神旛,然燈續明,放諸生命,散雜色香;病得除脫。」"
            )
        ]
        for verse in mbChapter13.verses {
            verse.chapter = mbChapter13
        }
        
        let mbChapter14 = Chapter(number: 14, title: "The Nine Unfortunate Deaths")
        mbChapter14.text = medicineBuddhaSutra
        mbChapter14.verses = [
            Verse(
                number: 1,
                text: "Ananda asked Rescuing Aid Bodhisattva, \"Good man, how is it that a life at its end can still be lengthened and benefited by these practices?\"",
                pinyin: "ěr shí, ā nán wèn jiù tuō pú sà yán: 「shàn nán zǐ! yún hé yǐ jìn zhī mìng ér kě zēng yì?」",
                chinese: "爾時,阿難問救脫菩薩言:「善男子!云何已盡之命而可增益?」"
            ),
            Verse(
                number: 2,
                text: "Rescuing Aid Bodhisattva replied, \"Great Virtuous One, haven't you ever heard about the nine kinds of unfortunate death that the Buddha has spoken about? It is because of this that I encourage the assembling of longevity banners, lighting of lamps, and the cultivation of various blessings and virtues so that one does not have to experience suffering throughout one's life.\"",
                pinyin: "jiù tuō pú sà yán: 「dà dé! rǔ qǐ bù wén rú lái shuō yǒu jiǔ héng sǐ yē? shì gù quàn zào xù mìng fān děng, xiū zhū fú dé; yǐ xiū fú gù, jìn qí shòu mìng, bù jīng kǔ huàn。」",
                chinese: "救脫菩薩言:「大德!汝豈不聞如來說有九橫死耶?是故勸造續命旛燈,修諸福德;以修福故,盡其壽命,不經苦患。」"
            ),
            Verse(
                number: 3,
                text: "Ananda then asked, \"What are the nine kinds of unfortunate death?\"",
                pinyin: "ā nán wèn yán: 「jiǔ héng yún hé?」",
                chinese: "阿難問言:「九橫云何?」"
            ),
            Verse(
                number: 4,
                text: "Rescuing Aid Bodhisattva responded, \"For example, there are sentient beings who are suffering minor illnesses and find themselves without a doctor, medicine, or caregiver. Even though they might eventually find a doctor, they are administered the wrong medicine. Because it is a minor illness, they are not expected to die, but unfortunately they do. This is what is referred to as the first unfortunate death.",
                pinyin: "jiù tuō pú sà yán: 「ruò zhū yǒu qíng, dé bìng suī qīng, rán wú yī yào jí kàn bìng zhě, shè fù yù yī, shòu yǐ fēi yào, shí bù yīng sǐ ér biàn héng sǐ。",
                chinese: "救脫菩薩言:「若諸有情,得病雖輕,然無醫藥及看病者,設復遇醫,授以非藥,實不應死而便橫死。"
            ),
            Verse(
                number: 5,
                text: "Some of these beings believe in harmful heterodox and magical practices, seeking evil teachers who presumptuously predict disaster or good fortune. Thereupon, their lives become unstable and fearful, and their hearts and minds are turned in the wrong direction. Unsure of themselves, they seek methods of divination to predict disasters, and they kill various sentient beings as sacrifices in order to ask for blessings and protection from the deities and spirits of mountains and rivers. Although they hope to extend the duration of their lives, eventually it is clear they cannot do so. Due to their foolishness and confusion, they believe in inverted evil points of view and subsequently suffer an unfortunate death. They are then reborn in hell without hope for release. This is what is referred to as the first unfortunate death.",
                pinyin: "yòu xìn shì jiān xié mó、wài dào、yāo niè zhī shī, wàng shuō huò fú, biàn shēng hòng dòng, xīn bù zì zhèng, bù wén mì huò, shā zhǒng zhǒng zhòng shēng, jiě zòu shén míng, hū zhū wǎng liǎng, qǐng qǐ fú yòu, yù jì yán mìng, zhōng bù néng dé; yú chī mí huò, xìn xié dào jiàn, suì lìng héng sǐ rù yú dì yù, wú yǒu chū qī, shì míng chū héng。",
                chinese: "又信世間邪魔、外道、妖孽之師,妄說禍福,便生恐動,心不自正,卜問覓禍,殺種種眾生,解奏神明,呼諸魍魎,請乞福祐,欲冀延命,終不能得;愚癡迷惑,信邪倒見,遂令橫死入於地獄,無有出期,是名初橫。"
            ),
            Verse(
                number: 6,
                text: "The second kind of unfortunate death is execution due to the laws of a particular country.",
                pinyin: "èr zhě、héng bèi wáng fǎ zhī suǒ zhū lù。",
                chinese: "二者、橫被王法之所誅戮。"
            ),
            Verse(
                number: 7,
                text: "The third kind of unfortunate death comes about because of an indulgent lifestyle, which consists of hunting for pleasure, carousing, drinking, and engaging in lewd and licentious behavior. As a result of their idle ways, death occurs when non-human beings snatch their vital energy from them.",
                pinyin: "sān zhě、tián liè xī xì, dān yín shì jiǔ, fàng yì wú dù, héng wéi fēi rén duó qí jīng qì。",
                chinese: "三者、畋獵嬉戲,耽淫嗜酒,放逸無度,橫為非人奪其精氣。"
            ),
            Verse(
                number: 8,
                text: "The fourth kind of unfortunate death is by burning.",
                pinyin: "sì zhě、héng wéi huǒ fén。",
                chinese: "四者、橫為火焚。"
            ),
            Verse(
                number: 9,
                text: "The fifth kind of unfortunate death is drowning.",
                pinyin: "wǔ zhě、héng wéi shuǐ nì。",
                chinese: "五者、橫為水溺。"
            ),
            Verse(
                number: 10,
                text: "The sixth kind of unfortunate death is being devoured by vicious beasts.",
                pinyin: "liù zhě、héng wéi zhǒng zhǒng è shòu suǒ dàn。",
                chinese: "六者、橫為種種惡獸所啖。"
            ),
            Verse(
                number: 11,
                text: "The seventh kind of unfortunate death is plummeting off a mountain cliff.",
                pinyin: "qī zhě、héng duò shān yá。",
                chinese: "七者、橫墮山崖。"
            ),
            Verse(
                number: 12,
                text: "The eighth kind of unfortunate death is caused by poison, a curse, or a zombie.",
                pinyin: "bā zhě、héng wéi dú yào、yǎn dǎo、zhòu zǔ、qǐ shī guǐ。",
                chinese: "八者、橫為毒藥、厭禱、咒詛、起屍鬼。"
            ),
            Verse(
                number: 13,
                text: "The ninth kind of unfortunate death is caused by severe hunger without relief. These are the unfortunate deaths that the Buddha briefly spoke about. Here we have mentioned nine kinds, but there are numerous other kinds as well. It would be difficult for me to mention them all.",
                pinyin: "jiǔ zhě、héng wéi jī kě suǒ kùn, bù dé yǐn shí ér biàn mìng zhōng。",
                chinese: "九者、橫為饑渴所困,不得飲食而便命終。"
            ),
            Verse(
                number: 14,
                text: "Again, Ananda, the Judgment King of Hell is primarily in charge of the record book of both good and evil deeds. If there are sentient beings who do not respect their parents, commit one of the five violations, damage or slander the Triple Gem, break the laws of their country, or violate the five precepts, the Judgment King of Hell will weigh and evaluate their deeds and punish them accordingly.",
                pinyin: "「fù cì, ā nán! yǎn mó wáng zhǔ sī míng shì jiān, bù xiào fù mǔ, wǔ nì, pò rǔ sān bǎo, huài jūn chén fǎ, huǐ yú xìng jiè, yǎn mó fǎ wáng, suí zuì qīng zhòng, kǎo ér fá zhī。",
                chinese: "「復次,阿難!琰魔王主司命世間,不孝父母,五逆,破辱三寶,壞君臣法,毀於性戒,琰魔法王,隨罪輕重,考而罰之。"
            )
        ]
        for verse in mbChapter14.verses {
            verse.chapter = mbChapter14
        }
        
        let mbChapter15 = Chapter(number: 15, title: "The Twelve Yaksa Generals")
        mbChapter15.text = medicineBuddhaSutra
        mbChapter15.verses = [
            Verse(
                number: 1,
                text: "This is the reason I now encourage all sentient beings to light lamps and make longevity banners, and cultivate merit by the practice of releasing captive beings so that they might pass through suffering and stress without difficulties.",
                pinyin: "shì gù wǒ jīn quàn zhū yǒu qíng, rán děng fàng shēng, xiū zhū fú dé, yǐ xiū fú gù, dé qí shòu mìng, bù jīng kǔ huàn。",
                chinese: "是故我今勸諸有情,然燈放生,修諸福德,以修福故,得其壽命,不經苦患。"
            ),
            Verse(
                number: 2,
                text: "In the midst of this gathering, there were Twelve Yaksa Generals who had been in attendance during the entire assembly. Their names were: General Kumbhira, General Vajra, General Mihira, General Andira, General Majira, General Shandira, General Indra, General Pajra, General Makura, General Sindura, General Catura, and General Vikarala.",
                pinyin: "cǐ shí èr yào chā dà jiàng, yī gè yǒu qí qiān yào chā, yǐ wéi juàn shǔ, tóng shí jǔ shēng bái fó yán: 「shì zūn! wǒ děng jīn zhě méng fó wēi lì, dé wén shì zūn yào shī liú lí guāng rú lái míng hào, bù fù gèng yǒu è qù zhī bù。",
                chinese: "此十二藥叉大將,一各有七千藥叉,以為眷屬,同時舉聲白佛言:「世尊!我等今者蒙佛威力,得聞世尊藥師琉璃光如來名號,不復更有惡趣之怖。"
            ),
            Verse(
                number: 3,
                text: "These Twelve Yaksa Generals, each with his own seven-thousand-member retinue, raised their voices in praise to the Buddha, saying, \"World-Honored One! Due to the blessings of the Buddha's omniscient power, we now can hear the titles of the World-Honored Medicine Buddha of Pure Crystal Radiance. We no longer need to experience the fears of the three lower realms. With one accord, we wholeheartedly take refuge in the Buddha, the Dharma, and the Sangha for the duration of our lives in this form.",
                pinyin: "wǒ děng xiāng shuài, jiē tóng yī xīn, nǎi zhì jìn xíng guī fó fǎ sēng, shì dāng hé fù yī qiè yǒu qíng, wéi zuò yì lì, ráo yì ān lè。",
                chinese: "我等相率,皆同一心,乃至盡形歸佛法僧,誓當荷負一切有情,為作義利,饒益安樂。"
            ),
            Verse(
                number: 4,
                text: "We vow to bear responsibility for all sentient beings and to work toward their benefit. Because of this, there will be abundant peace and joy. We shall become the protectors of any village, town, city, country, or forest, that has been introduced to this sutra as well as its inhabitants who uphold the title of the Medicine Buddha of Pure Crystal Radiance and make respectful offerings thereto.",
                pinyin: "suí yú hé děng cūn chéng guó yì, kōng xián lín zhōng, ruò yǒu liú bù cǐ jīng, huò fù shòu chí yào shī liú lí guāng rú lái míng hào, gōng jìng gòng yǎng zhě, wǒ děng juàn shǔ wèi hù shì rén, jiē shǐ jiě tuō yī qiè kǔ nán;",
                chinese: "隨於何等村城國邑,空閑林中,若有流布此經,或復受持藥師琉璃光如來名號,恭敬供養者,我等眷屬衛護是人,皆使解脫一切苦難;"
            ),
            Verse(
                number: 5,
                text: "All shall find relief from their suffering and woes, and all existing wishes shall be fulfilled. If there are those who seek relief from an illness or a particular stressful situation, they should just recite this sutra. Using the five-colored ribbon streamers, they should tie a knot for each of our names. After their wishes are fulfilled, they can untie the knots.",
                pinyin: "zhū yǒu yuàn qiú, xī lìng mǎn zú。huò yǒu jí è qiú dù tuō zhě, yì yīng dú sòng cǐ jīng, yǐ wǔ sè lǚ, jié wǒ míng zì, dé rú yuàn yǐ, rán hòu jiě jié。」",
                chinese: "諸有願求,悉令滿足。或有疾厄求度脫者,亦應讀誦此經,以五色縷,結我名字,得如願已,然後解結。」"
            ),
            Verse(
                number: 6,
                text: "At that time, the World-Honored One praised the Yaksa Generals, saying, \"Excellent! Well done! Your wish to protect and bring happiness and peace to all sentient beings is an appropriate way to express your gratitude to the Medicine Buddha of Pure Crystal Radiance.\"",
                pinyin: "ěr shí, shì zūn zàn zhū yào chā dà jiàng yán: 「shàn zāi! shàn zāi! dà yào chā jiàng! rǔ děng niàn bào shì zūn yào shī liú lí guāng rú lái ēn dé zhě, cháng yīng rú shì lì yì ān lè yī qiè yǒu qíng。」",
                chinese: "爾時,世尊讚諸藥叉大將言:「善哉!善哉!大藥叉將!汝等念報世尊藥師琉璃光如來恩德者,常應如是利益安樂一切有情。」"
            )
        ]
        for verse in mbChapter15.verses {
            verse.chapter = mbChapter15
        }
        
        let mbChapter16 = Chapter(number: 16, title: "Conclusion")
        mbChapter16.text = medicineBuddhaSutra
        mbChapter16.verses = [
            Verse(
                number: 1,
                text: "Then, Ananda addressed the Buddha, \"World-Honored One, from now on, how should we refer to this Dharma practice and how should we respectfully uphold it?\"",
                pinyin: "ěr shí, ā nán bái fó yán: 「shì zūn! dāng hé míng cǐ fǎ mén? wǒ děng yún hé fèng chí?」",
                chinese: "爾時,阿難白佛言:「世尊!當何名此法門?我等云何奉持?」"
            ),
            Verse(
                number: 2,
                text: "The Buddha responded, \"This Dharma practice is called the 'Meritorious Virtuous and Original Vows of Medicine Buddha of Pure Crystal Radiance,' or it can be also referred to as the 'Powerful Mantra and Wish-Weaving Twelve Yaksa Generals Benefiting Sentient Beings.' This also may be referred to as 'The Practice of Removing All Karmic Obstructions.' This is how it can be named and upheld.\"",
                pinyin: "fó gào ā nán: 「cǐ fǎ mén míng shuō yào shī liú lí guāng rú lái běn yuàn gōng dé; yì míng shuō shí èr shén jiàng ráo yì yǒu qíng jié yuàn shén zhòu; yì míng bá chú yī qiè yè zhàng; yīng rú shì chí。」",
                chinese: "佛告阿難:「此法門名說藥師琉璃光如來本願功德;亦名說十二神將饒益有情結願神咒;亦名拔除一切業障;應如是持。」"
            ),
            Verse(
                number: 3,
                text: "After the Bhagavat had said these words, the entire assembly of all the bodhisattvas, great bodhisattvas, sravakas, kings and their subjects, brahmins, laypeople, nagas, yaksas, gandharas, asuras, garudas, kinnaras, mahoragas, human and non-human beings, and so forth, was delighted to hear the words of the Buddha and faithfully received this teaching and practice.",
                pinyin: "shí bó qié fàn, shuō shì yǔ yǐ, zhū pú sà mó hē sà, jí dà shēng wén, guó wáng、dà chén、pó luó mén、jū shì、tiān、lóng、yào chā、jiàn dá fù、ā sù luó、jiē lù chá、jǐn nà luó、mò hū luó qié, rén fēi rén děng, yī qiè dà zhòng, wén fó suǒ shuō, jiē dà huān xǐ; xìn shòu fèng xíng。",
                chinese: "時薄伽梵,說是語已,諸菩薩摩訶薩,及大聲聞,國王、大臣、婆羅門、居士、天、龍、藥叉、健達縛、阿素洛、揭路茶、緊那洛、莫呼洛伽,人非人等,一切大眾,聞佛所說,皆大歡喜;信受奉行。"
            )
        ]
        for verse in mbChapter16.verses {
            verse.chapter = mbChapter16
        }
        
        let mbChapter17 = Chapter(number: 17, title: "Triple Refuge")
        mbChapter17.text = medicineBuddhaSutra
        mbChapter17.verses = [
            Verse(
                number: 1,
                text: "I take refuge in the Buddha, wishing that all sentient beings understand the Dharma and make the supreme vow.",
                pinyin: "zì guī yī fó, dāng yuàn zhòng shēng, tǐ jiě dà dào, fā wú shàng xīn。",
                chinese: "自皈依佛,當願眾生,體解大道,發無上心。"
            ),
            Verse(
                number: 2,
                text: "I take refuge in the Dharma, wishing that all sentient beings study the sutras diligently and obtain prajna-wisdom.",
                pinyin: "zì guī yī fǎ, dāng yuàn zhòng shēng, shēn rù jīng zàng, zhì huì rú hǎi。",
                chinese: "自皈依法,當願眾生,深入經藏,智慧如海。"
            ),
            Verse(
                number: 3,
                text: "I take refuge in the Sangha, wishing that all sentient beings lead the masses in harmony without obstruction.",
                pinyin: "zì guī yī sēng, dāng yuàn zhòng shēng, tǒng lǐ dà zhòng, yī qiè wú ài。",
                chinese: "自皈依僧,當願眾生,統理大眾,一切無礙。"
            )
        ]
        for verse in mbChapter17.verses {
            verse.chapter = mbChapter17
        }
        
        let mbChapter18 = Chapter(number: 18, title: "Dedication of Merit")
        mbChapter18.text = medicineBuddhaSutra
        mbChapter18.verses = [
            Verse(
                number: 1,
                text: "May kindness, compassion, joy, and equanimity pervade the Dharma realms;",
                pinyin: "cí bēi xǐ shě biàn fǎ jiè,",
                chinese: "慈悲喜捨遍法界,"
            ),
            Verse(
                number: 2,
                text: "May all people and heavenly beings benefit from our blessings and friendship;",
                pinyin: "xī fú jié yuán lì rén tiān,",
                chinese: "惜福結緣利人天,"
            ),
            Verse(
                number: 3,
                text: "May our ethical practice of Chan, Pure Land, and Precepts help us to realize equality and patience;",
                pinyin: "chán jìng jiè xíng píng děng rěn,",
                chinese: "禪淨戒行平等忍,"
            ),
            Verse(
                number: 4,
                text: "May we undertake the Great Vows with humility and gratitude.",
                pinyin: "cán kuì gǎn ēn dà yuàn xīn。",
                chinese: "慚愧感恩大願心。"
            )
        ]
        for verse in mbChapter18.verses {
            verse.chapter = mbChapter18
        }
        
        let mbChapter19 = Chapter(number: 19, title: "A Prayer to Medicine Buddha")
        mbChapter19.text = medicineBuddhaSutra
        mbChapter19.verses = [
            Verse(
                number: 1,
                text: "Oh great, compassionate Medicine Buddha! Please listen to my report: There is truly too much suffering in the world these days: The crimes of arson, murder, and theft; The cruel oppression of corrupt officials; The turbulence of politics and the economy; And natural disasters of earth, water, fire, and wind;",
                pinyin: "cí bēi wěi dà de yào shī rú lái! qǐng nín chuí tīng wǒ de bào gào, jīn tiān shì jiè shàng de kǔ nàn shí zài shì tài duō le! shāo shā lǔ lüè de qīn fàn, tān guān wū lì de pò hài, zhèng zhì jīng jì de dòng dàng, dì shuǐ huǒ fēng de zāi biàn;",
                chinese: "慈悲偉大的藥師如來!請您垂聽我的報告,今天世界上的苦難實在是太多了!燒殺擄掠的侵犯,貪官污吏的迫害,政治經濟的動盪,地水火風的災變;"
            ),
            Verse(
                number: 2,
                text: "These things often cause people to lose everything they own in the blink of an eye. The suffering of being bedridden with a lingering illness Resulting from an imbalance of the four great elements; Even heroes moan in pain and have difficulty being at ease; The sea of karma that is full of passions and delusions, Resulting from greed, anger, and ignorance, Rolls unceasingly like roaring waves and billows.",
                pinyin: "wǎng wǎng shǐ rén men zài shùn xī zhī jiān, shī qù le suǒ yǒu de yī qiè。nà sì dà bù tiáo, chán mián bìng tà de tòng kǔ, jí shǐ yīng xióng hǎo hàn yě shēn yín nán ān; nà tān chēn yú chī, fán nǎo cóng shēng de yè hǎi, yǒu rú bō tāo xiōng yǒng dì fān gǔn bù tíng。",
                chinese: "往往促使人們在瞬息之間,失去了所有的一切。那四大不調,纏綿病榻的痛苦,即使英雄好漢也呻吟難安;那貪瞋愚癡,煩惱叢生的業海,有如波濤洶湧地翻滾不停。"
            ),
            Verse(
                number: 3,
                text: "Oh great, compassionate Medicine Buddha! If we do not depend on you now, How can we escape the sea of suffering? If we do not rely on you now, How can we subdue our defilements and resentments?",
                pinyin: "cí bēi wěi dà de yào shī rú lái! wǒ men zài bù yǐ kào nín, rú hé chū lí kǔ hǎi? wǒ men zài bù yǎng zhàng nín, rú hé jiàng fú yuàn mó?",
                chinese: "慈悲偉大的藥師如來!我們再不倚靠您,如何出離苦海?我們再不仰仗您,如何降伏怨魔?"
            ),
            Verse(
                number: 4,
                text: "Today, I sincerely chant your name, and Pay respect to your image, Not only to ask you to bless me, But in the hope that all beings will obtain your great protection To live and work in peace and contentment, And in happiness and harmony.",
                pinyin: "wǒ jīn tiān qián chéng dì chēng niàn nín de míng hào, lǐ jìng nín de shèng róng, bù zhǐ shì qí qiú nín néng jiā bèi wǒ gè rén, gèng xī wàng zhòng shēng dōu dé dào nín de bì hù, ān jū lè yè, huān xǐ róng hé。",
                chinese: "我今天虔誠地稱念您的名號,禮敬您的聖容,不只是祈求您能加被我個人,更希望眾生都得到您的庇護,安居樂業,歡喜融和。"
            ),
            Verse(
                number: 5,
                text: "Oh great, compassionate Medicine Buddha! We understand completely: That, in this world of impurity, All natural disasters and man-made calamities Are caused by collective karma; That, on this impure, mundane earth, Physical and mental suffering Is caused by the passions and delusions of life.",
                pinyin: "cí bēi wěi dà de yào shī rú lái! wǒ men shēn zhī zài zhè ge wǔ zhuó è shì lǐ, tiān zāi rén huò shì gòng yè suǒ gǎn zhào; zài zhè ge suō pó huì tǔ zhōng, shēn xīn jí kǔ shì fán nǎo suǒ zào chéng。",
                chinese: "慈悲偉大的藥師如來!我們深知在這個五濁惡世裡,天災人禍是共業所感召;在這個娑婆穢土中,身心疾苦是煩惱所造成。"
            ),
            Verse(
                number: 6,
                text: "If we want to thoroughly eliminate calamities and disasters, We must first eliminate the karma of our own wrongdoings; If we want to establish the Pure Land of the East, We must first purify our bodies and minds.",
                pinyin: "rú guǒ yào chè dǐ xiāo chú zāi nàn, xiān dé xiāo chú zì jǐ de zuì yè; rú guǒ yào jiàn lì liú lí jìng tǔ, xiān dé jìng huà zì jǐ de shēn xīn。",
                chinese: "如果要徹底消除災難,先得消除自己的罪業;如果要建立琉璃淨土,先得淨化自己的身心。"
            ),
            Verse(
                number: 7,
                text: "Therefore, I would like to pray to you, Medicine Buddha, To eliminate our greed and anger, To eliminate our ignorance and struggles. We willingly transfer all our good-rooted merits To all beings in the Dharma realms.",
                pinyin: "suǒ yǐ wǒ yào qí qiú yào shī rú lái nín, xiāo chú wǒ men de tān lán chēn huì, xiāo chú wǒ men de wú míng dòu zhēng。wǒ men yuàn jiāng suǒ yǒu shàn gēn gōng dé, huí xiàng fǎ jiè yī qiè zhòng shēng。",
                chinese: "所以我要祈求藥師如來您,消除我們的貪婪瞋恚,消除我們的無明鬥爭。我們願將所有善根功德,回向法界一切眾生。"
            ),
            Verse(
                number: 8,
                text: "May everyone live freely And may everything turn out as he or she wishes. Furthermore, great, compassionate Medicine Buddha! I pray to you to bestow your great power upon us for protection; I will undertake the following, pure, original vows:",
                pinyin: "ràng dà jiā dōu néng shēng huó zì zài, shì shì rú yì。cí bēi wěi dà de yào shī rú lái! gèng qí qiú nín yǐ shén lì jiā bèi wǒ men, wǒ zài nín de miàn qián yě fā rú shì qīng jìng běn yuàn:",
                chinese: "讓大家都能生活自在,事事如意。慈悲偉大的藥師如來!更祈求您以神力加被我們,我在您的面前也發如是清淨本願:"
            ),
            Verse(
                number: 9,
                text: "First vow: May all sentient beings be equal and at ease; Second vow: May all undertakings benefit the masses; Third vow: May panic and terror be kept far away; Fourth vow: May all sentient beings calmly uphold bodhi; Fifth vow: May man-made calamities and natural disasters disappear completely;",
                pinyin: "dì yī yuàn: yuàn suǒ yǒu zhòng shēng píng děng zì zài, dì èr yuàn: yuàn suǒ zuò shì yè lì yì dà zhòng, dì sān yuàn: yuàn jīng huāng kǒng bù cóng cǐ yuǎn lí, dì sì yuàn: yuàn yī qiè yǒu qíng ān zhù pú tí, dì wǔ yuàn: yuàn tiān zāi rén huò xiāo shī wú xíng,",
                chinese: "第一願:願所有眾生平等自在,第二願:願所作事業利益大眾,第三願:願驚慌恐怖從此遠離,第四願:願一切有情安住菩提,第五願:願天災人禍消失無形,"
            ),
            Verse(
                number: 10,
                text: "Sixth vow: May all sentient beings be free from illness and suffering; Seventh vow: May all sentient beings be protected from harm; Eighth vow: May all sentient beings be free from fear; Ninth vow: May all sentient beings be free from obstacles; Tenth vow: May all sentient beings be free from poverty; Eleventh vow: May all sentient beings be free from ignorance; Twelfth vow: May all sentient beings attain enlightenment.",
                pinyin: "dì liù yuàn: yuàn yī qiè zhòng shēng wú bìng wú kǔ, dì qī yuàn: yuàn yī qiè zhòng shēng miǎn zāo shāng hài, dì bā yuàn: yuàn yī qiè zhòng shēng yuǎn lí kǒng jù, dì jiǔ yuàn: yuàn yī qiè zhòng shēng pò chú zhàng ài, dì shí yuàn: yuàn yī qiè zhòng shēng tuō lí pín kùn, dì shí yī yuàn: yuàn yī qiè zhòng shēng chú jìn wú míng, dì shí èr yuàn: yuàn yī qiè zhòng shēng zhèng dé pú tí。",
                chinese: "第六願:願一切眾生無病無苦,第七願:願一切眾生免遭傷害,第八願:願一切眾生遠離恐懼,第九願:願一切眾生破除障礙,第十願:願一切眾生脫離貧困,第十一願:願一切眾生除盡無明,第十二願:願一切眾生證得菩提。"
            ),
            Verse(
                number: 11,
                text: "Oh great, compassionate Medicine Buddha! We make offerings to you With our pure deeds of body, speech, and mind; We take you as our model With our zealous progress in the study of morality, meditative concentration, and wisdom;",
                pinyin: "cí bēi wěi dà de yào shī rú lái! wǒ men yǐ qīng jìng de shēn kǒu yì yè gòng yǎng nín, wǒ men yǐ jīng jìn de jiè dìng huì xué xiào fǎ nín;",
                chinese: "慈悲偉大的藥師如來!我們以清淨的身口意業供養您,我們以精進的戒定慧學效法您;"
            ),
            Verse(
                number: 12,
                text: "I pray that you give, with your great compassion, Your respect-inspiring virtues all over the Dharma realms To fulfill our wishes, To let our human world also establish the Pure Land of the East. Oh great, compassionate Medicine Buddha, Please accept my sincerest prayer!",
                pinyin: "qí qiú nín shī shě dà cí dà bēi, jiāng nín de wēi dé biàn mǎn fǎ jiè, mǎn zú wǒ men de yuàn wàng, ràng wǒ men rén jiān yě néng jiàn shè liú lí jìng tǔ。cí bēi wěi dà de yào shī rú lái! qǐng qiú nín jiē shòu wǒ zhì chéng de qí yuàn!",
                chinese: "祈求您施捨大慈大悲,將您的威德遍滿法界,滿足我們的願望,讓我們人間也能建設琉璃淨土。慈悲偉大的藥師如來!請求您接受我至誠的祈願!"
            )
        ]
        for verse in mbChapter19.verses {
            verse.chapter = mbChapter19
        }
        
        medicineBuddhaSutra.chapters.append(contentsOf: [mbChapter1, mbChapter2, mbChapter3, mbChapter4, mbChapter5, mbChapter6, mbChapter7, mbChapter8, mbChapter9, mbChapter10, mbChapter11, mbChapter12, mbChapter13, mbChapter14, mbChapter15, mbChapter16, mbChapter17, mbChapter18, mbChapter19])
        context.insert(medicineBuddhaSutra)
        }
        
        // The Lotus Sutra's Universal Gate Chapter on Avalokitesvara Bodhisattva
        if shouldLoadLotusSutraUniversalGate {
        let lotusUniversalGate = BuddhistText(
            title: "The Universal Gateway of Guanyin Bodhisattva (普門品)",
            author: "Buddha",
            textDescription: "The Universal Gate Chapter on Avalokitesvara Bodhisattva (妙法蓮華經觀世音菩薩普門品)",
            category: "Sutra",
            coverImageName: "UniversalGateway"
        )
        
        let lgChapter1 = Chapter(number: 1, title: "Praise of Holy Water")
        lgChapter1.text = lotusUniversalGate
        lgChapter1.verses = [
            Verse(
                number: 1,
                text: "With willow twigs, may the holy water be sprinkled on the three thousand realms.",
                pinyin: "yáng zhī jìng shuǐ biàn sǎ sān qiān",
                chinese: "楊枝淨水遍灑三千"
            ),
            Verse(
                number: 2,
                text: "May the nature of emptiness and eight virtues benefit heaven and earth.",
                pinyin: "xìng kōng bā dé lì rén tiān",
                chinese: "性空八德利人天"
            ),
            Verse(
                number: 3,
                text: "May good fortune and long life both be enhanced and extended. May wrongdoing be extinguished and be gone.",
                pinyin: "fú shòu guǎng zēng yán, miè zuì xiāo qiān",
                chinese: "福壽廣增延, 滅罪消愆"
            ),
            Verse(
                number: 4,
                text: "Burning flames transform into red lotus blossoms.",
                pinyin: "huǒ yàn huà hóng lián",
                chinese: "火燄化紅蓮"
            ),
            Verse(
                number: 5,
                text: "We take refuge in Avalokitesvara Bodhisattva-Mahasattva. (repeat three times)",
                pinyin: "nán mó guān shì yīn pú sà, mó hē sà (sān chēng)",
                chinese: "南無觀世音菩薩, 摩訶薩 (三稱)"
            )
        ]
        for verse in lgChapter1.verses {
            verse.chapter = lgChapter1
        }
        
        let lgChapter2 = Chapter(number: 2, title: "Sutra Opening Verse")
        lgChapter2.text = lotusUniversalGate
        lgChapter2.verses = [
            Verse(
                number: 1,
                text: "Homage to great compassionate Avalokitesvara Bodhisattva. (repeat three times)",
                pinyin: "nán mó dà bēi guān shì yīn pú sà (sān chēng)",
                chinese: "南無大悲觀世音菩薩 (三稱)"
            ),
            Verse(
                number: 2,
                text: "The unexcelled, most profound, and exquisitely wondrous Dharma,",
                pinyin: "wú shàng shèn shēn wēi miào fǎ",
                chinese: "無上甚深微妙法"
            ),
            Verse(
                number: 3,
                text: "Is difficult to encounter throughout hundreds of thousands of millions of kalpas.",
                pinyin: "bǎi qiān wàn jié nán zāo yù",
                chinese: "百千萬劫難遭遇"
            ),
            Verse(
                number: 4,
                text: "Since we are now able to see, hear, receive and retain it,",
                pinyin: "wǒ jīn jiàn wén dé shòu chí",
                chinese: "我今見聞得受持"
            ),
            Verse(
                number: 5,
                text: "May we comprehend the true meaning of the Tathagata.",
                pinyin: "yuàn jiě rú lái zhēn shí yì",
                chinese: "願解如來真實義"
            )
        ]
        for verse in lgChapter2.verses {
            verse.chapter = lgChapter2
        }
        
        let lgChapter3 = Chapter(number: 3, title: "The Universal Gate Chapter")
        lgChapter3.text = lotusUniversalGate
        lgChapter3.verses = [
            Verse(
                number: 1,
                text: "At that time, Aksayamati Bodhisattva rose from his seat, bared his right shoulder, put his palms together facing the Buddha, and said, \"World-honored One, for what reason is Avalokitesvara Bodhisattva named 'Observing the Sounds of the World'?\"",
                pinyin: "ěr shí wú jìn yì pú sà, jí cóng zuò qǐ, piān tǎn yòu jiān, hé zhǎng xiàng fó, ér zuò shì yán: \"shì zūn! guān shì yīn pú sà yǐ hé yīn yuán míng guān shì yīn?\"",
                chinese: "爾時無盡意菩薩,即從座起,偏袒右肩,合掌向佛,而作是言:\"世尊!觀世音菩薩以何因緣名觀世音?\""
            ),
            Verse(
                number: 2,
                text: "The Buddha answered Aksayamati Bodhisattva, \"Good men, if there be countless hundreds of millions of billions of living beings experiencing all manner of suffering who hear of Avalokitesvara Bodhisattva and call his name with single-minded effort, then Avalokitesvara Bodhisattva will instantly observe the sound of their cries, and they will all be liberated.\"",
                pinyin: "fó gào wú jìn yì pú sà: \"shàn nán zǐ! ruò yǒu wú liàng bǎi qiān wàn yì zhòng shēng, shòu zhū kǔ nǎo, wén shì guān shì yīn pú sà, yī xīn chēng míng, guān shì yīn pú sà jí shí guān qí yīn shēng, jiē dé jiě tuō.\"",
                chinese: "佛告無盡意菩薩:\"善男子!若有無量百千萬億眾生,受諸苦惱,聞是觀世音菩薩,一心稱名,觀世音菩薩即時觀其音聲,皆得解脫。\""
            ),
            Verse(
                number: 3,
                text: "\"If anyone who upholds the name of Avalokitesvara Bodhisattva were to fall into a great fire, the fire would be unable to burn that person due to the bodhisattva's awe-inspiring spiritual powers. If anyone, carried away by a flood, were to call his name, that person would immediately reach a shallow place.\"",
                pinyin: "\"ruò yǒu chí shì guān shì yīn pú sà míng zhě, shè rù dà huǒ, huǒ bù néng shāo, yóu shì pú sà wēi shén lì gù. ruò wéi dà shuǐ suǒ piāo, chēng qí míng hào, jí dé qiǎn chù.\"",
                chinese: "\"若有持是觀世音菩薩名者,設入大火,火不能燒,由是菩薩威神力故。若為大水所漂,稱其名號,即得淺處。\""
            ),
            Verse(
                number: 4,
                text: "\"If there are living beings in the hundreds of millions of billions who go out to sea in search of such treasures as gold, silver, lapis lazuli, mother of pearl, carnelian, coral, amber, and pearls, and if a fierce storm were to blow their ship off course to make landfall in the territory of raksas, and further if among them there is even one person who calls the name of Avalokitesvara Bodhisattva, then all of those people will be liberated from the torment of the raksas. This is why the bodhisattva is named 'Observing the Sounds of the World.'\"",
                pinyin: "\"ruò yǒu bǎi qiān wàn yì zhòng shēng, wèi qiú jīn, yín, liú lí, chē qú, mǎ nǎo, shān hú, hǔ pò, zhēn zhū děng bǎo, rù yú dà hǎi, jiǎ shǐ hēi fēng chuī qí chuán fǎng, piāo duò luó chà guǐ guó, qí zhōng ruò yǒu nǎi zhì yī rén chēng guān shì yīn pú sà míng zhě, shì zhū rén děng, jiē dé jiě tuō luó chà zhī nán. yǐ shì yīn yuán, míng guān shì yīn.\"",
                chinese: "\"若有百千萬億眾生,為求金、銀、琉璃、硨磲、瑪瑙、珊瑚、琥珀、真珠等寶,入於大海,假使黑風吹其船舫,漂墮羅剎鬼國,其中若有乃至一人稱觀世音菩薩名者,是諸人等,皆得解脫羅剎之難。以是因緣,名觀世音。\""
            ),
            Verse(
                number: 5,
                text: "\"Or if someone facing imminent attack calls the name of Avalokitesvara Bodhisattva, the knives and clubs held by the attackers will then break into pieces, and that person will attain liberation.\"",
                pinyin: "\"ruò fù yǒu rén, lín dāng bèi hài, chēng guān shì yīn pú sà míng zhě, bǐ suǒ zhí dāo zhàng, xún duàn huài, ér dé jiě tuō.\"",
                chinese: "\"若復有人,臨當被害,稱觀世音菩薩名者,彼所執刀杖,尋段壞,而得解脫。\""
            ),
            Verse(
                number: 6,
                text: "\"If a great three thousand-fold world system was full of yaksas and raksas seeking to torment people, and they heard someone call the name of Avalokitesvara Bodhisattva, these evil demons would not even be able to see that person with their evil eyes, much less do any harm.\"",
                pinyin: "\"ruò sān qiān dà qiān shì jiè, mǎn zhōng yè chā, luó chà, yù lái náo rén, wén qí chēng guān shì yīn pú sà míng zhě, shì zhū è guǐ, shàng bù néng yǐ è yǎn shì zhī, hé kuàng jiā hài.\"",
                chinese: "\"若三千大千世界,滿中夜叉、羅剎,欲來惱人,聞其稱觀世音菩薩名者,是諸惡鬼,尚不能以惡眼視之,何況加害。\""
            ),
            Verse(
                number: 7,
                text: "\"Or if someone, whether guilty or not guilty, who is bound and fettered with manacles, shackles, and cangue calls the name of Avalokitesvara Bodhisattva, then all the bonds will be broken, and that person will instantly attain liberation.\"",
                pinyin: "\"ruò fù yǒu rén, lín dāng bèi zhí, chēng guān shì yīn pú sà míng zhě, suǒ zhí suǒ qiè, jí dé jiě tuō.\"",
                chinese: "\"若復有人,臨當被執,稱觀世音菩薩名者,所執所繫,即得解脫。\""
            ),
            Verse(
                number: 8,
                text: "\"If a great three thousand-fold world system were full of malevolent brigands, and a merchant chief were leading many merchants carrying valuable treasures along a perilous road, and among them one man were to speak up and say, 'Good men, do not be afraid. You should call the name of Avalokitesvara Bodhisattva with single-minded effort, for this bodhisattva can bestow fearlessness upon living beings. If you call his name, then you will surely be liberated from these malevolent brigands!'\"",
                pinyin: "\"ruò guó tǔ mǎn zhōng yuàn zéi, yǒu yī shāng zhǔ, jiāng zhū shāng rén, jī chí zhòng bǎo, jīng guò xiǎn lù, qí zhōng yī rén zuò shì chàng yán: 'zhū shàn nán zǐ! wù dé kǒng bù, rǔ děng yīng dāng yī xīn chēng guān shì yīn pú sà míng hào, shì pú sà néng yǐ wú wèi shī yú zhòng shēng; rǔ děng ruò chēng míng zhě, yú cǐ yuàn zéi, dāng dé jiě tuō!'\"",
                chinese: "\"若國土滿中怨賊,有一商主,將諸商人,齎持重寶,經過險路,其中一人作是唱言:'諸善男子!勿得恐怖,汝等應當一心稱觀世音菩薩名號,是菩薩能以無畏施於眾生;汝等若稱名者,於此怨賊,當得解脫!'\""
            ),
            Verse(
                number: 9,
                text: "\"Aksayamati, lofty indeed are the awe-inspiring spiritual powers of the great Avalokitesvara Bodhisattva.\"",
                pinyin: "\"wú jìn yì! shì guān shì yīn pú sà, chéng jiù rú shì gōng dé.\"",
                chinese: "\"無盡意!是觀世音菩薩,成就如是功德。\""
            ),
            Verse(
                number: 10,
                text: "\"If any living beings are much given to greed, let them keep in mind and revere Avalokitesvara Bodhisattva, and they will be freed from their greed. If any are much given to anger, let them keep in mind and revere Avalokitesvara Bodhisattva, and they will be freed from their anger. If any are much given to ignorance, let them keep in mind and revere Avalokitesvara Bodhisattva, and they will be freed from their ignorance.\"",
                pinyin: "\"ruò yǒu zhòng shēng duō yú yín yù, cháng niàn jìng lǐ guān shì yīn pú sà, biàn dé lǐ yù. ruò duō chēn huì, cháng niàn jìng lǐ guān shì yīn pú sà, biàn dé lǐ chēn huì. ruò duō yú chī, cháng niàn jìng lǐ guān shì yīn pú sà, biàn dé lǐ yú chī.\"",
                chinese: "\"若有眾生多於淫欲,常念恭敬觀世音菩薩,便得離欲。若多瞋恚,常念恭敬觀世音菩薩,便得離瞋恚。若多愚癡,常念恭敬觀世音菩薩,便得離愚癡。\""
            ),
            Verse(
                number: 11,
                text: "\"If any woman wishes for a male child by worshipping and making offerings to Avalokitesvara Bodhisattva, she will then give birth to a son blessed with merit and wisdom. If she wishes for a female child, she will then give birth to a daughter blessed with well-formed and attractive features, one who has planted the roots of virtue over lifetimes and is cherished and respected by all.\"",
                pinyin: "\"ruò yǒu nǚ rén, shè yù qiú nán, lǐ bài gōng yǎng guān shì yīn pú sà, biàn shēng fú dé zhì huì zhī nán; shè yù qiú nǚ, biàn shēng duān zhèng yǒu xiàng zhī nǚ, sù zhí dé běn, zhòng rén ài jìng.\"",
                chinese: "\"若有女人,設欲求男,禮拜供養觀世音菩薩,便生福德智慧之男;設欲求女,便生端正有相之女,宿植德本,眾人愛敬。\""
            ),
            Verse(
                number: 12,
                text: "\"This is why all of you should single-mindedly make offerings to Avalokitesvara Bodhisattva, for it is the great Avalokitesvara Bodhisattva who can bestow fearlessness in the midst of terror and in dire circumstances. This is why everyone in this Saha World calls him the bestower of fearlessness.\"",
                pinyin: "\"shì gù zhòng shēng, cháng yīng xīn niàn. ruò yǒu zhòng shēng gōng jìng lǐ bài guān shì yīn pú sà, fú bù táng juān. shì gù zhòng shēng jiē yīng shòu chí guān shì yīn pú sà míng hào.\"",
                chinese: "\"是故眾生,常應心念。若有眾生恭敬禮拜觀世音菩薩,福不唐捐。是故眾生皆應受持觀世音菩薩名號。\""
            ),
            Verse(
                number: 13,
                text: "The Buddha told Aksayamati Bodhisattva, \"Good men, if there are living beings in this land who should be liberated by someone in the form of a Buddha, then Avalokitesvara Bodhisattva will manifest in the form of a Buddha and teach the Dharma to them. For those who should be liberated by someone in the form of a pratyekabuddha, then Avalokitesvara Bodhisattva will manifest in the form of a pratyekabuddha and teach the Dharma to them.\"",
                pinyin: "\"fó gào wú jìn yì pú sà: 'shàn nán zǐ! ruò yǒu guó tǔ zhòng shēng, yīng yǐ fó shēn dé dù zhě, guān shì yīn pú sà jí xiàn fó shēn ér wéi shuō fǎ. yīng yǐ pì zhī fó shēn dé dù zhě, jí xiàn pì zhī fó shēn ér wéi shuō fǎ.'\"",
                chinese: "\"佛告無盡意菩薩:'善男子!若有國土眾生,應以佛身得度者,觀世音菩薩即現佛身而為說法。應以辟支佛身得度者,即現辟支佛身而為說法。'\""
            ),
            Verse(
                number: 14,
                text: "\"For those who should be liberated by someone in the form of a sravaka, then he will manifest in the form of a sravaka and teach the Dharma to them. For those who should be liberated by someone in the form of King Brahma, then he will manifest in the form of King Brahma and teach the Dharma to them.\"",
                pinyin: "\"yīng yǐ shēng wén shēn dé dù zhě, jí xiàn shēng wén shēn ér wéi shuō fǎ. yīng yǐ fàn wáng shēn dé dù zhě, jí xiàn fàn wáng shēn ér wéi shuō fǎ.\"",
                chinese: "\"應以聲聞身得度者,即現聲聞身而為說法。應以梵王身得度者,即現梵王身而為說法。\""
            ),
            Verse(
                number: 15,
                text: "\"For those who should be liberated by someone in the form of a young boy or young girl, then he will manifest in the form of a young boy or young girl and teach the Dharma to them. For those who should be liberated by someone in such forms as a deva, a naga, a yaksa, a gandharva, an asura, a garuda, a kimnara, a mahoraga, a human or a nonhuman being, then he will manifest in all these forms and teach the Dharma to them.\"",
                pinyin: "\"yīng yǐ tóng nán tóng nǚ shēn dé dù zhě, jí xiàn tóng nán tóng nǚ shēn ér wéi shuō fǎ. yīng yǐ tiān, lóng, yè chā, qián tà pó, ā xiū luó, jiā lóu luó, jǐn nà luó, mó hóu luó qié, rén, fēi rén děng shēn dé dù zhě, jí jiē xiàn zhī ér wéi shuō fǎ.\"",
                chinese: "\"應以童男童女身得度者,即現童男童女身而為說法。應以天、龍、夜叉、乾闥婆、阿修羅、迦樓羅、緊那羅、摩睺羅伽、人、非人等身得度者,即皆現之而為說法。\""
            ),
            Verse(
                number: 16,
                text: "\"Aksayamati, such is the merit that Avalokitesvara Bodhisattva has accomplished, and the various forms in which he wanders the various lands bringing liberation to living beings.\"",
                pinyin: "\"wú jìn yì! shì guān shì yīn pú sà, chéng jiù rú shì gōng dé, yǐ zhǒng zhǒng xíng yóu lì zhū guó tǔ, dù tuō zhòng shēng.\"",
                chinese: "\"無盡意!是觀世音菩薩,成就如是功德,以種種形遊歷諸國土,度脫眾生。\""
            ),
            Verse(
                number: 17,
                text: "\"World-honored One with all the wonderful signs, Let me now ask about him once more: For what reason is this son of the Buddha Named 'Observing the Sounds of the World'?\"",
                pinyin: "\"shì zūn miào xiàng jù, wǒ jīn chóng wèn bǐ: fó zǐ hé yīn yuán, míng wéi guān shì yīn?\"",
                chinese: "\"世尊妙相具,我今重問彼:佛子何因緣,名為觀世音?\""
            ),
            Verse(
                number: 18,
                text: "\"You listen now to the practice of Avalokitesvara, Who well responds to every region. His great vow is as deep as the sea, Inconceivable even after many kalpas. Having served Buddhas in the hundreds of billions, He has made a great, pure vow.\"",
                pinyin: "\"jù zú miào xiàng zūn, jí dá wú jìn yì: rǔ tīng guān yīn xíng, shàn yìng zhū fāng suǒ, hóng shì shēn rú hǎi, lì jié bù sī yì, shì duō qiān yì fó, fā dà qīng jìng yuàn.\"",
                chinese: "\"具足妙相尊,偈答無盡意:汝聽觀音行,善應諸方所,弘誓深如海,歷劫不思議,侍多千億佛,發大清淨願。\""
            ),
            Verse(
                number: 19,
                text: "\"Let me briefly tell you: Hearing his name and seeing his form, Keeping him unremittingly in mind, Can eliminate all manner of suffering.\"",
                pinyin: "\"wǒ wéi rǔ lüè shuō, wén míng jí jiàn shēn, xīn niàn bù kōng guò, néng miè zhū yǒu kǔ.\"",
                chinese: "\"我為汝略說,聞名及見身,心念不空過,能滅諸有苦。\""
            ),
            Verse(
                number: 20,
                text: "\"Suppose someone with harmful intent, Casts you into a great pit of fire; Keep in mind Avalokitesvara's powers, And the pit of fire will change into a pond.\"",
                pinyin: "\"jiǎ shǐ xīng hài yì, tuī luò dà huǒ kēng, niàn bǐ guān yīn lì, huǒ kēng biàn chéng chí.\"",
                chinese: "\"假使興害意,推落大火坑,念彼觀音力,火坑變成池。\""
            ),
            Verse(
                number: 21,
                text: "\"Or you are cast adrift upon an immense ocean, Menaced by dragons, fish, and demons; Keep in mind Avalokitesvara's powers, And the waves will not drown you.\"",
                pinyin: "\"huò piāo liú jù hǎi, lóng yú zhū guǐ nán, niàn bǐ guān yīn lì, bō làng bù néng mò.\"",
                chinese: "\"或漂流巨海,龍魚諸鬼難,念彼觀音力,波浪不能沒。\""
            ),
            Verse(
                number: 22,
                text: "\"Or someone pushes you down, From the top of Mount Sumeru; Keep in mind Avalokitesvara's powers, And you will hang in the sky like the sun.\"",
                pinyin: "\"huò zài xū mí fēng, wèi rén suǒ tuī duò, niàn bǐ guān yīn lì, rú rì xū kōng zhù.\"",
                chinese: "\"或在須彌峰,為人所推墮,念彼觀音力,如日虛空住。\""
            ),
            Verse(
                number: 23,
                text: "\"Or you are pursued by evil doers, Who push you down from Mount Vajra; Keep in mind Avalokitesvara's powers, And not one of your hairs will be harmed.\"",
                pinyin: "\"huò bèi è rén zhú, duò luò jīn gāng shān, niàn bǐ guān yīn lì, bù néng sǔn yī máo.\"",
                chinese: "\"或被惡人逐,墮落金剛山,念彼觀音力,不能損一毛。\""
            ),
            Verse(
                number: 24,
                text: "\"Or if surrounded by malevolent brigands, Each one brandishing a knife to attack you; Keep in mind Avalokitesvara's powers, And they will all experience a mind of loving-kindness.\"",
                pinyin: "\"huò zhí yuàn zéi rào, gè zhí dāo jiā hài, niàn bǐ guān yīn lì, xián jí qí cí xīn.\"",
                chinese: "\"或值怨賊繞,各執刀加害,念彼觀音力,咸即起慈心。\""
            ),
            Verse(
                number: 25,
                text: "\"Or if persecuted by the royal court, Facing death by execution; Keep in mind Avalokitesvara's powers, And the executioner's blade will break into pieces.\"",
                pinyin: "\"huò zāo wáng nán kǔ, lín xíng yù shòu zhōng, niàn bǐ guān yīn lì, dāo xún duàn duàn huài.\"",
                chinese: "\"或遭王難苦,臨刑欲壽終,念彼觀音力,刀尋段段壞。\""
            ),
            Verse(
                number: 26,
                text: "\"Or if imprisoned with cangue and chains, Hands and feet manacled and shackled; Keep in mind Avalokitesvara's powers, And the bonds will loosen and you will be liberated.\"",
                pinyin: "\"huò qiú jìn jiā suǒ, shǒu zú bèi chǒu xiè, niàn bǐ guān yīn lì, shì rán dé jiě tuō.\"",
                chinese: "\"或囚禁枷鎖,手足被杻械,念彼觀音力,釋然得解脫。\""
            ),
            Verse(
                number: 27,
                text: "\"If there is someone who would do you harm, Using spells and various poisons; Keep in mind Avalokitesvara's powers, And any harm will rebound on the originator.\"",
                pinyin: "\"zhòu zǔ zhū dú yào, suǒ yù hài shēn zhě, niàn bǐ guān yīn lì, huán zhuó yú běn rén.\"",
                chinese: "\"咒詛諸毒藥,所欲害身者,念彼觀音力,還著於本人。\""
            ),
            Verse(
                number: 28,
                text: "\"Or if you encounter evil raksas, Venomous dragons, various ghosts, and the like; Keep in mind Avalokitesvara's powers, And then none of them will dare harm you.\"",
                pinyin: "\"huò yù è luó chà, dú lóng zhū guǐ děng, niàn bǐ guān yīn lì, shí xī bù gǎn hài.\"",
                chinese: "\"或遇惡羅剎,毒龍諸鬼等,念彼觀音力,時悉不敢害。\""
            ),
            Verse(
                number: 29,
                text: "\"If you are surrounded by evil beasts With their sharp teeth and claws so horrifying; Keep in mind Avalokitesvara's powers, And they will flee in all directions.\"",
                pinyin: "\"ruò è shòu wéi rào, lì yá zhǎo kě pà, niàn bǐ guān yīn lì, jí zǒu wú biān fāng.\"",
                chinese: "\"若惡獸圍繞,利牙爪可怕,念彼觀音力,疾走無邊方。\""
            ),
            Verse(
                number: 30,
                text: "\"When lizards, snakes, vipers, and scorpions Scorch you with their poisonous vapors; Keep in mind Avalokitesvara's powers, And they will retreat at the sound of your voice.\"",
                pinyin: "\"yuán shé jí fù xiē, qì dú yān huǒ rán, niàn bǐ guān yīn lì, xún shēng zì huí qù.\"",
                chinese: "\"蚖蛇及蝮蠍,氣毒煙火然,念彼觀音力,尋聲自迴去。\""
            ),
            Verse(
                number: 31,
                text: "\"When thunderclouds rumble with lighting strikes, As hailstones and torrential rains come down; Keep in mind Avalokitesvara's powers, And the storm will disperse that very moment.\"",
                pinyin: "\"yún léi gǔ chè diàn, jiàng báo shù dà yǔ, niàn bǐ guān yīn lì, yìng shí dé xiāo sàn.\"",
                chinese: "\"雲雷鼓掣電,降雹澍大雨,念彼觀音力,應時得消散。\""
            ),
            Verse(
                number: 32,
                text: "\"Living beings suffer in agony, Oppressed by immeasurable pain; The power of Avalokitesvara's wondrous wisdom Can bring liberation from the world's sufferings.\"",
                pinyin: "\"zhòng shēng bèi kùn è, wú liàng kǔ bī shēn, guān yīn miào zhì lì, néng jiù shì jiān kǔ.\"",
                chinese: "\"眾生被困厄,無量苦逼身,觀音妙智力,能救世間苦。\""
            ),
            Verse(
                number: 33,
                text: "\"Perfect in supernatural powers, Widely practicing the skillful means of wisdom, In all the lands of the ten directions, There is no place where he fails to manifest.\"",
                pinyin: "\"jù zú shén tōng lì, guǎng xiū zhì fāng biàn, shí fāng zhū guó tǔ, wú chà bù xiàn shēn.\"",
                chinese: "\"具足神通力,廣修智方便,十方諸國土,無剎不現身。\""
            ),
            Verse(
                number: 34,
                text: "\"The lower realms in all their forms, That of hell-beings, hungry ghosts, and animals, The sufferings of birth, old age, sickness, and death, He steadily brings them all to an end.\"",
                pinyin: "\"zhǒng zhǒng zhū è qù, dì yù guǐ chù shēng, shēng lǎo bìng sǐ kǔ, yǐ jiàn xī lìng miè.\"",
                chinese: "\"種種諸惡趣,地獄鬼畜生,生老病死苦,以漸悉令滅。\""
            ),
            Verse(
                number: 35,
                text: "\"Contemplation of truth, contemplation of purity, Contemplation of the vast and greater wisdom, Contemplation of compassion and contemplation of kindness; Ever longed for, ever looked up to.\"",
                pinyin: "\"zhēn guān qīng jìng guān, guǎng dà zhì huì guān, bēi guān jí cí guān, cháng yuàn cháng zhān yǎng.\"",
                chinese: "\"真觀清淨觀,廣大智慧觀,悲觀及慈觀,常願常瞻仰。\""
            ),
            Verse(
                number: 36,
                text: "\"His undefiled light of purity Is the wisdom-sun dispelling all darkness, What can quell winds and fires that bring disaster And illuminate the world universally.\"",
                pinyin: "\"wú gòu qīng jìng guāng, huì rì pò zhū àn, néng fú zāi fēng huǒ, pǔ míng zhào shì jiān.\"",
                chinese: "\"無垢清淨光,慧日破諸闇,能伏災風火,普明照世間。\""
            ),
            Verse(
                number: 37,
                text: "\"Precepts of his compassionate body are like rolling thunder; The profundity of his kind mind is like a great cloud; He showers us with Dharma rain like nectar, That extinguishes the flames of affliction.\"",
                pinyin: "\"bēi tǐ jiè léi zhèn, cí yì miào dà yún, shù gān lù fǎ yǔ, miè chú fán nǎo yàn.\"",
                chinese: "\"悲體戒雷震,慈意妙大雲,澍甘露法雨,滅除煩惱燄。\""
            ),
            Verse(
                number: 38,
                text: "\"When lawsuits bring you to court, Or when fear strikes you in battle, Keep in mind Avalokitesvara's powers, And the enemy forces will all retreat.\"",
                pinyin: "\"zhēng sòng jīng guān chù, bù wèi jūn zhèn zhōng, niàn bǐ guān yīn lì, zhòng yuàn xī tuì sàn.\"",
                chinese: "\"諍訟經官處,怖畏軍陣中,念彼觀音力,眾怨悉退散。\""
            ),
            Verse(
                number: 39,
                text: "\"He can be their aid and support! In possession of all merit and virtue, He views living beings with the eyes of loving-kindness; His ocean of accumulated merit is infinite, So worship him with prostrations.\"",
                pinyin: "\"néng wéi zuò yī hù, jù yī qiē gōng dé, cí yǎn shì zhòng shēng, fú jù hǎi wú liàng, shì gù yīng dǐng lǐ.\"",
                chinese: "\"能為作依怙,具一切功德,慈眼視眾生,福聚海無量,是故應頂禮。\""
            ),
            Verse(
                number: 40,
                text: "At this time Dharanimdhara Bodhisattva rose from his seat, came forward, and said to the Buddha, \"World-honored One, if there are living beings who hear this chapter on Avalokitesvara Bodhisattva about his freedom of action, his revelation of the universal gate, and his supernatural powers, it should be known that their merits are not few.\"",
                pinyin: "ěr shí chí dì pú sà jí cóng zuò qǐ, qián bái fó yán: \"shì zūn! ruò yǒu zhòng shēng wén shì guān yīn pú sà pǐn zì zài zhī yè, pǔ mén shì xiàn shén tōng lì zhě, dāng zhī shì rén gōng dé bù shǎo.\"",
                chinese: "爾時持地菩薩即從座起,前白佛言:\"世尊!若有眾生聞是觀音菩薩品自在之業,普門示現神通力者,當知是人功德不少。\""
            ),
            Verse(
                number: 41,
                text: "When the Buddha preached this chapter on the Universal Gate, the eighty-four thousand living beings assembled there all generated the aspiration to attain anuttara-samyak-sambodhi.",
                pinyin: "fó shuō shì pǔ mén pǐn shí, zhòng zhōng bā wàn sì qiān zhòng shēng jiē fā wú děng děng ā nòu duō luó sān miǎo sān pú tí xīn.",
                chinese: "佛說是普門品時,眾中八萬四千眾生皆發無等等阿耨多羅三藐三菩提心。"
            )
        ]
        for verse in lgChapter3.verses {
            verse.chapter = lgChapter3
        }
        
        let lgChapter4 = Chapter(number: 4, title: "Dharani of Great Compassion")
        lgChapter4.text = lotusUniversalGate
        lgChapter4.verses = [
            Verse(
                number: 1,
                text: "Namo ratnatrayaya. Namo arya avalokitesvaraya bodhisattvaya mahasattvaya.",
                pinyin: "nán mó hē là dá nà duō là yè yē. nán mó ā lì yē, lú jié dì, shuò bō là yē, tí sà duò pó yē, mó hē sà duò pó yē, mó hē jiā lú ní jiā yē.",
                chinese: "南無喝囉怛那哆囉夜耶。南無阿唎耶,盧羯帝,爍缽囉耶,提薩埵婆耶,摩訶薩埵婆耶,摩訶迦盧尼迦耶。"
            ),
            Verse(
                number: 2,
                text: "Om. Sarva raksa. Namo bhagavate. Arya avalokitesvaraya bodhisattvaya mahasattvaya. Namo ratnatrayaya.",
                pinyin: "ān. sà pó là fá yì, shù dá nà dá xiě, nán mó xī jí lì duò yī méng ā lì yē, pó lú jí dì, shì fó là léng tuó pó, nán mó nà là jǐn chí.",
                chinese: "唵。薩皤囉罰曳,數怛那怛寫,南無悉吉嚤埵伊蒙阿唎耶,婆盧吉帝,室佛囉楞馱婆,南無那囉謹墀。"
            ),
            Verse(
                number: 3,
                text: "He who recites this dharani will be protected by all Buddhas and Bodhisattvas, and all suffering will be eliminated.",
                pinyin: "xī lì mó hē, pó duō shā miè, sà pó ā tā dòu shū péng, ā shì yùn, sà pó sà duō, nán mó pó sà duō, nán mó pó qiē, mó fá tè dòu.",
                chinese: "醯利摩訶,皤哆沙咩,薩婆阿他、豆輸朋,阿逝孕,薩婆薩哆、那摩婆薩哆、那摩婆伽,摩罰特豆。"
            ),
            Verse(
                number: 4,
                text: "This dharani is the great compassionate heart of the Thousand-Handed and Thousand-Eyed One, who removes all obstacles and brings liberation to all beings.",
                pinyin: "dá zhí tā, ān, ā pó lú xī, lú jiā dì, jiā luó dì, yí xī lì, mó hē pú tí sà duò.",
                chinese: "怛姪他,唵,阿婆盧醯,盧迦帝,迦羅帝,夷醯唎,摩訶菩提薩埵。"
            )
        ]
        for verse in lgChapter4.verses {
            verse.chapter = lgChapter4
        }
        
        let lgChapter5 = Chapter(number: 5, title: "Triple Refuge")
        lgChapter5.text = lotusUniversalGate
        lgChapter5.verses = [
            Verse(
                number: 1,
                text: "I take refuge in the Buddha, wishing that all sentient beings understand the Dharma and make the supreme vow.",
                pinyin: "zì guī yī fó, dāng yuàn zhòng shēng, tǐ jiě dà dào, fā wú shàng xīn.",
                chinese: "自皈依佛,當願眾生,體解大道,發無上心。"
            ),
            Verse(
                number: 2,
                text: "I take refuge in the Dharma, wishing that all sentient beings study the sutras diligently and obtain an ocean of wisdom.",
                pinyin: "zì guī yī fǎ, dāng yuàn zhòng shēng, shēn rù jīng zàng, zhì huì rú hǎi.",
                chinese: "自皈依法,當願眾生,深入經藏,智慧如海。"
            ),
            Verse(
                number: 3,
                text: "I take refuge in the Sangha, wishing that all sentient beings lead the masses in harmony without obstruction.",
                pinyin: "zì guī yī sēng, dāng yuàn zhòng shēng, tǒng lǐ dà zhòng, yī qiē wú ài.",
                chinese: "自皈依僧,當願眾生,統理大眾,一切無礙。"
            )
        ]
        for verse in lgChapter5.verses {
            verse.chapter = lgChapter5
        }
        
        let lgChapter6 = Chapter(number: 6, title: "Dedication of Merit")
        lgChapter6.text = lotusUniversalGate
        lgChapter6.verses = [
            Verse(
                number: 1,
                text: "May kindness, compassion, joy, and equanimity pervade the dharma realms;",
                pinyin: "cí bēi xǐ shě biàn fǎ jiè,",
                chinese: "慈悲喜捨遍法界,"
            ),
            Verse(
                number: 2,
                text: "May all people and heavenly beings benefit from our blessings and friendship;",
                pinyin: "xī fú jié yuán lì rén tiān;",
                chinese: "惜福結緣利人天;"
            ),
            Verse(
                number: 3,
                text: "May our ethical practice of Chan, Pure Land, and Precepts help us to realize equality and patience;",
                pinyin: "chán jìng jiè xíng píng děng rěn,",
                chinese: "禪淨戒行平等忍,"
            ),
            Verse(
                number: 4,
                text: "May we undertake the great vows with humility and gratitude.",
                pinyin: "cán kuì gǎn ēn dà yuàn xīn.",
                chinese: "慚愧感恩大願心。"
            )
        ]
        for verse in lgChapter6.verses {
            verse.chapter = lgChapter6
        }
        
        lotusUniversalGate.chapters.append(contentsOf: [lgChapter1, lgChapter2, lgChapter3, lgChapter4, lgChapter5, lgChapter6])
        context.insert(lotusUniversalGate)
        }
        
        // What the Buddha Taught by Walpola Rahula (PDF Book)
        if shouldLoadWhatBuddhaTaught {
        let whatBuddhaTaught = BuddhistText(
            title: "What the Buddha Taught",
            author: "Walpola Rahula",
            textDescription: "A classic introduction to Buddhism by Venerable Walpola Rahula",
            category: "Teaching",
            coverImageName: "WhatTheBuddhaTaught"
        )
        // This is a PDF book, so we'll add a placeholder chapter that indicates it's a PDF
        let pdfChapter = Chapter(number: 1, title: "PDF Book")
        pdfChapter.text = whatBuddhaTaught
        pdfChapter.verses = [
            Verse(number: 1, text: "This is a PDF book. Tap to open the PDF viewer.")
        ]
        for verse in pdfChapter.verses {
            verse.chapter = pdfChapter
        }
        whatBuddhaTaught.chapters.append(pdfChapter)
        context.insert(whatBuddhaTaught)
        }

        // The Life of the Buddha (PDF Book)
        if shouldLoadLifeOfBuddha {
        let lifeOfBuddha = BuddhistText(
            title: "The Life of the Buddha",
            author: "Bhikkhu Ñāṇamoli",
            textDescription: "The Life of the Buddha according to the Pali Canon",
            category: "Teaching",
            coverImageName: "TheLifeOfBuddha"
        )
        // This is a PDF book, so we'll add a placeholder chapter that indicates it's a PDF
        let pdfChapter = Chapter(number: 1, title: "PDF Book")
        pdfChapter.text = lifeOfBuddha
        pdfChapter.verses = [
            Verse(number: 1, text: "This is a PDF book. Tap to open the PDF viewer.")
        ]
        for verse in pdfChapter.verses {
            verse.chapter = pdfChapter
        }
        lifeOfBuddha.chapters.append(pdfChapter)
        context.insert(lifeOfBuddha)
        }

        // 流浪者之歌 (Siddhartha) by Hermann Hesse (PDF Book)
        if shouldLoadSiddhartha {
        let siddhartha = BuddhistText(
            title: "流浪者之歌 (Siddhartha)",
            author: "Hermann Hesse",
            textDescription: "An allegorical novel about the spiritual journey of self-discovery",
            category: "Teaching",
            coverImageName: "Siddhartha"
        )
        // This is a PDF book, so we'll add a placeholder chapter that indicates it's a PDF
        let pdfChapter = Chapter(number: 1, title: "PDF Book")
        pdfChapter.text = siddhartha
        pdfChapter.verses = [
            Verse(number: 1, text: "This is a PDF book. Tap to open the PDF viewer.")
        ]
        for verse in pdfChapter.verses {
            verse.chapter = pdfChapter
        }
        siddhartha.chapters.append(pdfChapter)
        context.insert(siddhartha)
        }

        try? context.save()
    }
}

