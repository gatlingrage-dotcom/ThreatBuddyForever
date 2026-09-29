local ADDON_NAME, addonTable = ...

-- Root dictionary to house language maps
addonTable.L = {}
local L = addonTable.L

-- ===========================================================================
-- DEFAULT FALLBACK BASE: ENGLISH (enUS)
-- ===========================================================================
local defaultLocale = {
    LOADED = "ThreatBuddyForever initialized successfully! Type /tbf to configure settings.",
    PANEL_SUB = "Threat Configuration Profile Panel Manager.",
    STATUS_AGRO = "AGRO",
    STATUS_WARN = "WARN",
    STATUS_OK = "SAFE",
    STATUS_TAUNT = "TAUNT",
    TEXT_GLOW = "Enable Neon Glow Visual Effects",
    TEXT_SOLO = "Hide While Solo (Ignore nameplates when out of groups)",
    TEXT_PET  = "Keep Enabled if Pet is Actively Engaged",
    TEXT_SOUND = "Play Audio Alarm Alerts on Aggro Losses",
    TEXT_HIGHLIGHT = "Scale Target Widget Focus Highlighting",
    TEXT_FILTER = "Filter out Trivial Mobs & Background Totems",
    TEXT_CHARPROFILE = "Use Separate Character Profiles (Ignore Global Settings)",
    TEXT_LANG = "Language Localization Pack Profile:",
    TEXT_SCALE = "Master Widget Size Scale: ",
    TEXT_TARSCALE = "Focus Target Highlights Scaling: ",
    TEXT_DIST = "Nameplate Horizontal Pixel Spacing Offset: ",
    TEXT_LAG = "Nameplate Interface Scanner Throttle Ticks: ",
    TEXT_ALPHA = "Threat Indicator Opacity: ",
    -- CORRECTED MINIMALIST SELECTION STRINGS
    TEXT_ICON_LABEL = "Custom Icon Name or Asset ID:",
    TEXT_BROWSE_BTN = "Browse...",
    TEXT_COLOR_ALPHA = "Icon Texture Color Opacity: ",
    TEXT_CUT_EDGES = "Clip Icon Corners (Smooth Rounded Edges)",
    TEXT_RESET_BTN  = "Reset Default"
}

-- Seed the initial table map
for k, v in pairs(defaultLocale) do L[k] = v end

-- Detect client localization token channel
local gameLocale = GetLocale()

-- Helper proxy function to fetch strings across modular directories safely
function addonTable.GetText(key)
    local forced = ThreatBuddyForeverDB and ThreatBuddyForeverDB.forcedLocale
    local activeLocale = forced or gameLocale
    
    if addonTable.Locales and addonTable.Locales[activeLocale] and addonTable.Locales[activeLocale][key] then
        return addonTable.Locales[activeLocale][key]
    end
    return L[key] or key
end
addonTable.SafeGetText = addonTable.GetText

addonTable.Locales = {}
addonTable.Locales["enUS"] = defaultLocale
-- ===========================================================================
-- PORTUGUÊS (ptBR)
-- ===========================================================================
addonTable.Locales["ptBR"] = {
    LOADED = "ThreatBuddyForever inicializado com sucesso! Digite /tbf para configurar as opções.",
    PANEL_SUB = "Gerenciador de Perfis de Configuração de Ameaça.",
    STATUS_AGRO = "AGRO",
    STATUS_WARN = "ALERTA",
    STATUS_OK = "SEGURO",
    STATUS_TAUNT = "PROVOCADO",
    TEXT_GLOW = "Ativar Efeitos Visuais de Brilho Neon",
    TEXT_SOLO = "Ocultar Jogando Solo (Ignorar placas fora de grupo)",
    TEXT_PET  = "Manter Ativo se o Ajudante Estiver Engajado",
    TEXT_SOUND = "Tocar Alarme Sonoro ao Perder o Agro",
    TEXT_HIGHLIGHT = "Aumentar Escala do Alvo em Foco",
    TEXT_FILTER = "Filtrar Criaturas Triviais e Totens de Fundo",
    TEXT_CHARPROFILE = "Usar Perfis de Personagem Separados (Ignorar Configurações Globais)",
    TEXT_LANG = "Perfil de Idioma da Localização:",
    TEXT_SCALE = "Escala de Tamanho do Widget Geral: ",
    TEXT_TARSCALE = "Escala de Realce do Alvo Focado: ",
    TEXT_DIST = "Deslocamento Pixel Horizontal das Placas: ",
    TEXT_LAG = "Intervalo de Varredura do Scanner: ",
    TEXT_ALPHA = "Opacidade do Indicador de Ameaça: ",
    TEXT_ICON_LABEL = "Nome do Ícone Personalizado ou ID do Asset:",
    TEXT_BROWSE_BTN = "Procurar...",
    TEXT_COLOR_ALPHA = "Opacidade da Cor do Ícone: ",
    TEXT_CUT_EDGES = "Cortar Bordas do Ícone (Bordas Arredondadas)",
    TEXT_RESET_BTN  = "Resetar Padrão"
}
-- ===========================================================================
-- ESPAÑOL (esES / esMX)
-- ===========================================================================
local esLocale = {
    LOADED = "¡ThreatBuddyForever inicializado correctamente! Escribe /tbf para configurar las opciones.",
    PANEL_SUB = "Gestor del Panel de Configuración de Amenaza.",
    STATUS_AGRO = "AGRO",
    STATUS_WARN = "AVISO",
    STATUS_OK = "SEGURO",
    STATUS_TAUNT = "PROVOCADO",
    TEXT_GLOW = "Activar Efectos Visuales de Brillo Neón",
    TEXT_SOLO = "Ocultar al Jugar Solo (Ignorar placas fuera de grupo)",
    TEXT_PET  = "Mantener Activo si la Mascota Está en Combate",
    TEXT_SOUND = "Reproducir Alarma Sonora al Perder el Agro",
    TEXT_HIGHLIGHT = "Escalar Resaltado del Objetivo en Foco",
    TEXT_FILTER = "Filtrar Criaturas Triviales y Tótems de Fondo",
    TEXT_CHARPROFILE = "Usar Perfiles de Personaje Separados (Ignorar Ajustes Globales)",
    TEXT_LANG = "Perfil de Idioma de Localización:",
    TEXT_SCALE = "Escala de Tamaño del Widget Principal: ",
    TEXT_TARSCALE = "Escala de Resaltado del Objetivo: ",
    TEXT_DIST = "Desplazamiento Pixel Horizontal de Placas: ",
    TEXT_LAG = "Intervalo de Escaneo del Rastreador: ",
    TEXT_ALPHA = "Opacidad del Indicador de Amenaza: ",
    TEXT_ICON_LABEL = "Nombre de Icono Personalizado o ID de Asset:",
    TEXT_BROWSE_BTN = "Examinar...",
    TEXT_COLOR_ALPHA = "Opacidad del Color del Icono: ",
    TEXT_CUT_EDGES = "Recortar Bordas del Icono (Bordes Redondeados)",
    TEXT_RESET_BTN  = "Restablecer"
}
addonTable.Locales["esES"] = esLocale
addonTable.Locales["esMX"] = esLocale
-- ===========================================================================
-- ITALIANO (itIT)
-- ===========================================================================
addonTable.Locales["itIT"] = {
    LOADED = "ThreatBuddyForever inizializzato con successo! Digita /tbf para configurare le opzioni.",
    PANEL_SUB = "Gestore del Pannello di Configurazione della Minaccia.",
    STATUS_AGRO = "AGRO",
    STATUS_WARN = "OCCHIO",
    STATUS_OK = "SICURO",
    STATUS_TAUNT = "PROVOCATO",
    TEXT_GLOW = "Attiva Effetti Visivi di Bagliore al Neon",
    TEXT_SOLO = "Nascondi Quando Sei Solo (Ignora piastre fuori dal gruppo)",
    TEXT_PET  = "Mantieni Attivo se il Famiglio è in Combattimento",
    TEXT_SOUND = "Riproduci Allarme Sonoro alla Perdita di Aggro",
    TEXT_HIGHLIGHT = "Scala l'Evidenziazione del Bersaglio in Focus",
    TEXT_FILTER = "Filtra Mostri Triviali e Totem di Sfondo",
    TEXT_CHARPROFILE = "Usa Profili Personaggio Separati (Ignore Impostazioni Globali)",
    TEXT_LANG = "Profilo della Lingua di Localizzazione:",
    TEXT_SCALE = "Scala Dimensioni del Widget Principale: ",
    TEXT_TARSCALE = "Scala di Evidenziazione del Bersaglio: ",
    TEXT_DIST = "Distanza Pixel Orizzontale delle Piastre: ",
    TEXT_LAG = "Intervallo di Scansione del Tracciatore: ",
    TEXT_ALPHA = "Opacità dell'Indicatore di Minaccia: ",
    TEXT_ICON_LABEL = "Nome Icona Personalizzata o ID dell'Asset:",
    TEXT_BROWSE_BTN = "Sfoglia...",
    TEXT_COLOR_ALPHA = "Opacità Colore dell'Icona: ",
    TEXT_CUT_EDGES = "Arrotonda i Bordi dell'Icona (Angoli Lisci)",
    TEXT_RESET_BTN  = "Ripristina Predefinito"
}
-- ===========================================================================
-- FRANÇAIS (frFR)
-- ===========================================================================
addonTable.Locales["frFR"] = {
    LOADED = "ThreatBuddyForever initialisé avec succès ! Tapez /tbf pour configurer les options.",
    PANEL_SUB = "Gestionnaire du Panneau de Configuration de la Menace.",
    STATUS_AGRO = "AGRO",
    STATUS_WARN = "ATTEN",
    STATUS_OK = "SÉCUR",
    STATUS_TAUNT = "PROVOQUÉ",
    TEXT_GLOW = "Activer les Effets Visuels de Lueur Néon",
    TEXT_SOLO = "Masquer en Solo (Ignorer les plaques hors groupe)",
    TEXT_PET  = "Maintenir Actif si le Familier est Engagé",
    TEXT_SOUND = "Jouer une Alarme Sonore en Cas de Perte d'Aggro",
    TEXT_HIGHLIGHT = "Mettre à l'Échelle le Ciblage Prioritaire",
    TEXT_FILTER = "Filtrer les Créatures Triviales & Totems de Fond",
    TEXT_CHARPROFILE = "Utiliser des Profils de Personnage Séparés",
    TEXT_LANG = "Profil de Langue de Localisation :",
    TEXT_SCALE = "Échelle de Taille du Widget Principal : ",
    TEXT_TARSCALE = "Échelle de Mise en Valeur de la Cible : ",
    TEXT_DIST = "Décalage Pixel Horizontal des Plaques : ",
    TEXT_LAG = "Fréquence de Balayage du Scanner : ",
    TEXT_ALPHA = "Opacité de l'Indicateur de Menace: ",
    TEXT_ICON_LABEL = "Nom d'Icône Personnalisé ou ID de l'Asset:",
    TEXT_BROWSE_BTN = "Parcourir...",
    TEXT_COLOR_ALPHA = "Opacité de la Couleur de l'Icône : ",
    TEXT_CUT_EDGES = "Arrondir les Angles de l'Icône (Bords Lisses)",
    TEXT_RESET_BTN  = "Réinitialiser"
}
-- ===========================================================================
-- DEUTSCH (deDE)
-- ===========================================================================
addonTable.Locales["deDE"] = {
    LOADED = "ThreatBuddyForever erfolgreich initialisiert! Gib /tbf ein, um die Optionen zu konfigurieren.",
    PANEL_SUB = "Bedrohungskonfigurations-Profilmanager.",
    STATUS_AGRO = "AGRO",
    STATUS_WARN = "WARNUNG",
    STATUS_OK = "SICHER",
    STATUS_TAUNT = "SPOTT",
    TEXT_GLOW = "Neon-Leuchteffekte aktivieren",
    TEXT_SOLO = "Solo ausblenden (Namensplaketten außerhalb von Gruppen ignorieren)",
    TEXT_PET  = "Aktiv lassen, wenn das Begleiter aktiv kämpft",
    TEXT_SOUND = "Akustischen Alarm bei Aggro-Verlust abspielen",
    TEXT_HIGHLIGHT = "Hervorhebung des Fokusziels skalieren",
    TEXT_FILTER = "Triviale Mobs & Hintergrund-Totems filtern",
    TEXT_CHARPROFILE = "Separate Charakterprofile verwenden (Globale Einstellungen ignorieren)",
    TEXT_LANG = "Sprachlokalisierungspaket-Profil:",
    TEXT_SCALE = "Haupt-Widget-Größenskalierung: ",
    TEXT_TARSCALE = "Hervorhebungsskalierung des Fokusziels: ",
    TEXT_DIST = "Horizontaler Pixelabstand der Namensplaketten: ",
    TEXT_LAG = "Aktualisierungsintervall des Schnittstellen-Scanners: ",
    TEXT_ALPHA = "Bedrohungsanzeige-Deckkraft: ",
    TEXT_ICON_LABEL = "Benutzerdefinierter Symbolname oder Asset-ID:",
    TEXT_BROWSE_BTN = "Durchsuchen...",
    TEXT_COLOR_ALPHA = "Symbolfarbe-Deckkraft: ",
    TEXT_CUT_EDGES = "Symbolränder abrunden (Glatte Ecken)",
    TEXT_RESET_BTN  = "Standard zurücksetzen"
}
-- ===========================================================================
-- 日本語 (jaJP)
-- ===========================================================================
addonTable.Locales["jaJP"] = {
    LOADED = "ThreatBuddyForever が正常に初期化されました！設定するには /tbf と入力してください。",
    PANEL_SUB = "脅威設定プロファイルパネルマネージャー。",
    STATUS_AGRO = "ヘイト",
    STATUS_WARN = "警告",
    STATUS_OK = "安全",
    STATUS_TAUNT = "挑発中",
    TEXT_GLOW = "ネオングロー視覚効果を有効にする",
    TEXT_SOLO = "ソロ時は非表示（グループ外 of ネームプレートを無視）",
    TEXT_PET  = "ペットが戦闘中の場合は有効を維持",
    TEXT_SOUND = "タゲ落ち時に警告音を再生",
    TEXT_HIGHLIGHT = "ターゲットウィジェットの拡大強調表示",
    TEXT_FILTER = "雑魚Mobや背景のトーテムを除外",
    TEXT_CHARPROFILE = "キャラクターごとのプロファイルを使用（全体設定を無視）",
    TEXT_LANG = "言語ロケールパック設定：",
    TEXT_SCALE = "マスターウィジェットのサイズ倍率：",
    TEXT_TARSCALE = "ターゲット強調表示の拡大倍率：",
    TEXT_DIST = "ネームプレートの水平ピクセルオフセット：",
    TEXT_LAG = "インターフェーススキャン更新間隔：",
    TEXT_ALPHA = "脅威インジケータの不透明度：",
    TEXT_ICON_LABEL = "カスタムアイコン名、またはアセットID：",
    TEXT_BROWSE_BTN = "参照...",
    TEXT_COLOR_ALPHA = "アイコンの色の不透明度：",
    TEXT_CUT_EDGES = "アイコンの角を切り落とす（丸みのあるエッジ）：",
    TEXT_RESET_BTN  = "デフォルトに戻す"
}
