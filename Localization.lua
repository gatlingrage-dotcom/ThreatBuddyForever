local ADDON_NAME, addonTable = ...
addonTable.Locales = {}

-- 1. TRADUÇÃO: INGLÊS (enUS / enGB)
addonTable.Locales["enUS"] = {
    LOADED = "|cff00ff00ThreatBuddyForever V2.0|r active! Use |cffffff00/tbf|r to open settings. Smart Tank/DPS detection active.",
    SCALE_CHANGED = "|cff00ff00ThreatBuddyForever|r: Scale changed to ",
    SCALE_ERROR = "|cffff0000ThreatBuddyForever|r: Choose a value between 0.5 and 2.5.",
    TEST_ON = "|cff00ff00ThreatBuddyForever|r: Test mode active! Hold Alt + Left Click to drag.",
    TEST_OFF = "|cff00ff00ThreatBuddyForever|r: Mode test disabled.",
    RESET_POS = "|cff00ff00ThreatBuddyForever|r: Position reset to screen center.",
    HELP_LINE1 = "ThreatBuddyForever Commands:",
    HELP_LINE2 = "|cffffff00/tbf scale [0.5-2.5]|r - Changes the widget scale.",
    HELP_LINE3 = "|cffffff00/tbf test|r - Toggles test mode for dragging.",
    HELP_LINE4 = "|cffffff00/tbf reset|r - Resets the widget position to default.",
    PANEL_TITLE = "ThreatBuddyForever - Settings",
    PANEL_SUB = "Adjust the visual behavior of your multi-target smart signal light.",
    TEXT_GLOW = " Enable Neon Glow (Pulse Effect)",
    TEXT_SOLO = " Hide Addon in Single Player (Out of Group)",
    TEXT_PET = " Allow Solo Display if Pet is Active (Hunter/Warlock)",
    TEXT_LAG = " Update Frequency (Lag Control): ",
    TEXT_LANG = " Addon Language: ",
    TEXT_SCALE = " General Size (Scale): ",
    TEXT_DIST = " Lateral Distance: ",
    STATUS_OK = "SAFE",
    STATUS_WARN = "WARN",
    STATUS_AGRO = "AGRO",
    TEXT_SOUND = " Play Sound Alert on New Agro",
    TEXT_HIGHLIGHT = " Highlight Current Target Signal",
    TEXT_FILTER = " Filter out Totems & Trivial Pets",
    TEXT_TARSCALE = " Target Highlight Size (Scale): ",
    TEXT_SOUND_SEL = " Select Alert Sound: ",
    TEXT_CHARPROFILE = " Use Per-Character Profile (Independent Settings)",
    STATUS_TAUNT = "TAUNT"
}

-- 2. TRADUÇÃO: PORTUGUÊS (ptBR / ptPT)
addonTable.Locales["ptBR"] = {
    LOADED = "|cff00ff00ThreatBuddyForever V2.0|r ativo! Usa |cffffff00/tbf|r para abrir as definições. Deteção inteligente de Tank/DPS ativa.",
    SCALE_CHANGED = "|cff00ff00ThreatBuddyForever|r: Tamanho alterado para ",
    SCALE_ERROR = "|cffff0000ThreatBuddyForever|r: Escolhe um valor entre 0.5 e 2.5.",
    TEST_ON = "|cff00ff00ThreatBuddyForever|r: Modo de teste ativo! Podes arrastar com Alt + Rato.",
    TEST_OFF = "|cff00ff00ThreatBuddyForever|r: Modo de teste desligado.",
    RESET_POS = "|cff00ff00ThreatBuddyForever|r: Posição redefinida para o centro do ecrã.",
    HELP_LINE1 = "Comandos do ThreatBuddyForever:",
    HELP_LINE2 = "|cffffff00/tbf scale [0.5-2.5]|r - Altera o tamanho do semáforo.",
    HELP_LINE3 = "|cffffff00/tbf test|r - Liga/desliga o modo de teste para arrastar.",
    HELP_LINE4 = "|cffffff00/tbf reset|r - Redefine a posição do widget de emergência.",
    PANEL_TITLE = "ThreatBuddyForever - Definições",
    PANEL_SUB = "Ajusta o comportamento visual do teu semáforo inteligente multi-alvo.",
    TEXT_GLOW = " Ativar Brilho Néon (Glow Pulsante)",
    TEXT_SOLO = " Ocultar Addon em Single Player (Fora de Grupo)",
    TEXT_PET = " Permitir exibir Solo se tiver Pet Ativo (Hunter/Warlock)",
    TEXT_LAG = " Frequência de Atualização (Atraso/Lag): ",
    TEXT_LANG = " Idioma do Addon: ",
    TEXT_SCALE = " Tamanho Geral (Scale): ",
    TEXT_DIST = " Distância Lateral: ",
    STATUS_OK = "OK",
    STATUS_WARN = "ALERTA",
    STATUS_AGRO = "AGRO",
    TEXT_SOUND = " Ativar Alerta Sonoro ao Ganhar Agro",
    TEXT_HIGHLIGHT = " Destacar o Semáforo do Alvo Atual",
    TEXT_FILTER = " Filtrar Totens e Guardas Inofensivos",
    TEXT_TARSCALE = " Tamanho do Alvo Destacado (Scale): ",
    TEXT_SOUND_SEL = " Selecionar Som do Alerta: ",
    TEXT_CHARPROFILE = " Usar Perfil por Personagem (Configurações Independentes)",
    STATUS_TAUNT = "FIXADO"
}


-- 3. TRADUÇÃO: FRANCÊS (frFR)
addonTable.Locales["frFR"] = {
    LOADED = "|cff00ff00ThreatBuddyForever V2.0|r actif! Utilisez |cffffff00/tbf|r pour les options. Détection intelligente Tank/DPS active.",
    SCALE_CHANGED = "|cff00ff00ThreatBuddyForever|r: Échelle modifiée à ",
    SCALE_ERROR = "|cffff0000ThreatBuddyForever|r: Choisissez une valeur entre 0.5 et 2.5.",
    TEST_ON = "|cff00ff00ThreatBuddyForever|r: Mode test actif! Maintenez Alt + Clic gauche pour glisser.",
    TEST_OFF = "|cff00ff00ThreatBuddyForever|r: Mode test désactivé.",
    RESET_POS = "|cff00ff00ThreatBuddyForever|r: Position réinitialisée au centre de l'écran.",
    HELP_LINE1 = "Commandes de ThreatBuddyForever:",
    HELP_LINE2 = "|cffffff00/tbf scale [0.5-2.5]|r - Modifie l'échelle du widget.",
    HELP_LINE3 = "|cffffff00/tbf test|r - Active/désactive le mode test.",
    HELP_LINE4 = "|cffffff00/tbf reset|r - Réinitialise la position par défaut.",
    PANEL_TITLE = "ThreatBuddyForever - Configuration",
    PANEL_SUB = "Ajustez le comportement visuel de votre feu indicateur de menace.",
    TEXT_GLOW = " Activer la lueur néon (effet de pulsation)",
    TEXT_SOLO = " Masquer l'addon en solo (hors groupe)",
    TEXT_PET = " Autoriser l'affichage en solo si le familier est actif",
    TEXT_LAG = " Fréquence de mise à jour (Contrôle du Lag): ",
    TEXT_LANG = " Langue de l'Addon: ",
    TEXT_SCALE = " Taille générale (Échelle): ",
    TEXT_DIST = " Distance latérale: ",
    STATUS_OK = "SAIN",
    STATUS_WARN = "ATTN",
    STATUS_AGRO = "AGRO",
    TEXT_SOUND = " Activer l'alerte sonore en cas d'agro",
    TEXT_HIGHLIGHT = " Mettre en valeur le signal de la cible actuelle",
    TEXT_FILTER = " Filtrer les totems et mascottes triviales",
    TEXT_TARSCALE = " Taille de la cible en surbrillance (Échelle): ",
    TEXT_SOUND_SEL = " Option Son: ",
    TEXT_CHARPROFILE = " Utiliser un profil par personnage (Configuration indépendante)",
    STATUS_TAUNT = "PROVOQUÉ"
}

-- 4. TRADUÇÃO: ALEMÃO (deDE)
addonTable.Locales["deDE"] = {
    LOADED = "|cff00ff00ThreatBuddyForever V2.0|r aktiv! Nutzen Sie |cffffff00/tbf|r für Einstellungen. Intelligente Tank/DPS-Erkennung aktiv.",
    SCALE_CHANGED = "|cff00ff00ThreatBuddyForever|r: Skalierung geändert auf " ,
    SCALE_ERROR = "|cffff0000ThreatBuddyForever|r: Wählen Sie einen Wert zwischen 0.5 und 2.5.",
    TEST_ON = "|cff00ff00ThreatBuddyForever|r: Testmodus aktiv! Halten Sie Alt + Links-Klick zum Ziehen.",
    TEST_OFF = "|cff00ff00ThreatBuddyForever|r: Testmodus deaktiviert.",
    RESET_POS = "|cff00ff00ThreatBuddyForever|r: Position auf Bildschirmmitte zurückgesetzt.",
    HELP_LINE1 = "ThreatBuddyForever Befehle:",
    HELP_LINE2 = "|cffffff00/tbf scale [0.5-2.5]|r - Ändert die Widget-Skalierung.",
    HELP_LINE3 = "|cffffff00/tbf test|r - Schaltet den Testmodus zum Ziehen um.",
    HELP_LINE4 = "|cffffff00/tbf reset|r - Setzt die Widget-Position zurück.",
    PANEL_TITLE = "ThreatBuddyForever - Einstellungen",
    PANEL_SUB = "Bedrohungs-Signallichts anpassen.",
    TEXT_GLOW = " Neon-Glow aktivieren (Pulse-Effekt)",
    TEXT_SOLO = " Addon im Solospiel ausblenden",
    TEXT_PET = " Solo-Anzeige erlauben, wenn Begleiter aktiv ist",
    TEXT_LAG = " Aktualisierungsfrequenz (Lag-Kontrolle): ",
    TEXT_LANG = " Addon-Sprache: ",
    TEXT_SCALE = " Allgemeine Größe (Skalierung): ",
    TEXT_DIST = " Seitlicher Abstand: ",
    STATUS_OK = "SICHER",
    STATUS_WARN = "WARN",
    STATUS_AGRO = "GEFAHR",
    TEXT_SOUND = " Aktivieren Sie den Audioalarm bei Agro",
    TEXT_HIGHLIGHT = " Markieren Sie das aktuelle Zielsignal",
    TEXT_FILTER = " Totems und triviale Haustiere herausfiltern",
    TEXT_TARSCALE = " Hervorgehobene Zielgröße (Skalierung): ",
    TEXT_SOUND_SEL = " Ton-Auswahl: ",
    TEXT_CHARPROFILE = " Profil pro Charakter verwenden (Unabhängige Einstellungen)",
    STATUS_TAUNT = "GESPOTTET"
}

-- 5. TRADUÇÃO: ESPANHOL (esES / esMX) - NOVO!
addonTable.Locales["esES"] = {
    LOADED = "|cff00ff00ThreatBuddyForever V2.0|r ¡activo! Usa |cffffff00/tbf|r para abrir la configuración. Detección inteligente de Tanque/DPS activa.",
    SCALE_CHANGED = "|cff00ff00ThreatBuddyForever|r: Escala cambiada a ",
    SCALE_ERROR = "|cffff0000ThreatBuddyForever|r: Elige un valor entre 0.5 y 2.5.",
    TEST_ON = "|cff00ff00ThreatBuddyForever|r: ¡Modo de prueba activo! Mantén Alt + Clic izquierdo para arrastrar.",
    TEST_OFF = "|cff00ff00ThreatBuddyForever|r: Modo de prueba desactivado.",
    RESET_POS = "|cff00ff00ThreatBuddyForever|r: Posición restablecida al centro de la pantalla.",
    HELP_LINE1 = "Comandos de ThreatBuddyForever:",
    HELP_LINE2 = "|cffffff00/tbf scale [0.5-2.5]|r - Cambia la escala del semáforo.",
    HELP_LINE3 = "|cffffff00/tbf test|r - Alterna el modo de prueba para arrastrar.",
    HELP_LINE4 = "|cffffff00/tbf reset|r - Restablece la posición de emergencia por defecto.",
    PANEL_TITLE = "ThreatBuddyForever - Configuración",
    PANEL_SUB = "Ajusta el comportamiento visual de tu semáforo inteligente multi-objetivo.",
    TEXT_GLOW = " Activar brillo de neón (efecto de pulso)",
    TEXT_SOLO = " Ocultar addon en solitario (fuera de grupo)",
    TEXT_PET = " Permitir mostrar en solitario si la mascota está activa (Cazador/Brujo)",
    TEXT_LAG = " Frecuencia de actualización (Control de Lag): ",
    TEXT_LANG = " Idioma del Addon: ",
    TEXT_SCALE = " Tamaño general (Escala): ",
    TEXT_DIST = " Distancia lateral: ",
    STATUS_OK = "SEGURO",
    STATUS_WARN = "ALERTA",
    STATUS_AGRO = "AGRO",
    TEXT_SOUND = " Activar alerta de sonido al ganar agro",
    TEXT_HIGHLIGHT = " Destacar el semáforo del objetivo actual",
    TEXT_FILTER = " Filtrar tótems y mascotas triviales",
    TEXT_TARSCALE = " Tamaño del objetivo destacado (Escala): ",
    TEXT_SOUND_SEL = " Seleccionar sonido: ",
    TEXT_CHARPROFILE = " Usar perfil por personaje (Configuración independiente)",
    STATUS_TAUNT = "PROVOCADO"
}

-- 6. TRADUÇÃO: ITALIANO (itIT) - NOVO!
addonTable.Locales["itIT"] = {
    LOADED = "|cff00ff00ThreatBuddyForever V2.0|r attivo! Usa |cffffff00/tbf|r per aprire le impostazioni. Rilevamento intelligente Tank/DPS attivo.",
    SCALE_CHANGED = "|cff00ff00ThreatBuddyForever|r: Scala modificata in ",
    SCALE_ERROR = "|cffff0000ThreatBuddyForever|r: Scegli un valore compreso tra 0.5 e 2.5.",
    TEST_ON = "|cff00ff00ThreatBuddyForever|r: Modalità test attiva! Tieni premuto Alt + Clic sinistro per trascinare.",
    TEST_OFF = "|cff00ff00ThreatBuddyForever|r: Modalità test disattivata.",
    RESET_POS = "|cff00ff00ThreatBuddyForever|r: Posizione ripristinata al centro dello schermo.",
    HELP_LINE1 = "Comandi di ThreatBuddyForever:",
    HELP_LINE2 = "|cffffff00/tbf scale [0.5-2.5]|r - Cambia la scala del widget.",
    HELP_LINE3 = "|cffffff00/tbf test|r - Attiva/disattiva la modalità test per il trascinamento.",
    HELP_LINE4 = "|cffffff00/tbf reset|r - Ripristina la posizione del widget predefinita.",
    PANEL_TITLE = "ThreatBuddyForever - Impostazioni",
    PANEL_SUB = "Regola il comportamento visivo del tuo semaforo intelligente multi-bersaglio.",
    TEXT_GLOW = " Attiva il bagliore al neon (effetto pulsante)",
    TEXT_SOLO = " Nascondi l'addon in modalità solo (fuori dal gruppo)",
    TEXT_PET = " Consenti visualizzazione solo se il pet è attivo (Cacciatore/Stregone)",
    TEXT_LAG = " Frequenza di aggiornamento (Controllo Lag): ",
    TEXT_LANG = " Lingua dell'Addon: ",
    TEXT_SCALE = " Dimensione generale (Scala): ",
    TEXT_DIST = " Distanza laterale: ",
    STATUS_OK = "SICURO",
    STATUS_WARN = "ATTENZ",
    STATUS_AGRO = "AGRO",
    TEXT_SOUND = " Riproduci avviso sonoro quando prendi l'agro",
    TEXT_HIGHLIGHT = " Evidenzia il segnale del bersaglio attuale",
    TEXT_FILTER = " Filtra totem e mascotte banali",
    TEXT_TARSCALE = " Dimensione del bersaglio evidenziato (Scala): ",
    TEXT_SOUND_SEL = " Seleziona suono: ",
    TEXT_CHARPROFILE = " Usa profilo per personaggio (Impostazioni indipendenti)",
    STATUS_TAUNT = "FISSATO"
}

-- 7. TRADUÇÃO: JAPONÊS (jaJP)
addonTable.Locales["jaJP"] = {
    LOADED = "|cff00ff00ThreatBuddyForever V2.0|r 有効! 設定を開くには |cffffff00/tbf|r と入力してください。スマートTank/DPS検出機能が有効です。",
    SCALE_CHANGED = "|cff00ff00ThreatBuddyForever|r: サイズを次のように変更しました: ",
    SCALE_ERROR = "|cffff0000ThreatBuddyForever|r: 0.5から2.5の間の数値を指定してください。",
    TEST_ON = "|cff00ff00ThreatBuddyForever|r: テストモード有効! 移動できます。",
    TEST_OFF = "|cff00ff00ThreatBuddyForever|r: テストモード無効。",
    RESET_POS = "|cff00ff00ThreatBuddyForever|r: 位置を画面中央にリセットしました。",
    HELP_LINE1 = "ThreatBuddyForever コマンド:",
    HELP_LINE2 = "|cffffff00/tbf scale [0.5-2.5]|r - シグナルのサイズを変更します。",
    HELP_LINE3 = "|cffffff00/tbf test|r - 移動テストモードを切り替えます。",
    HELP_LINE4 = "|cffffff00/tbf reset|r - 中央に緊急リセットします。",
    PANEL_TITLE = "ThreatBuddyForever - 設定" ,
    PANEL_SUB = "マルチターゲット対応ヘイトシグナルの表示設定を調整します。",
    TEXT_GLOW = " ネオングロー効果を有効にする",
    TEXT_SOLO = " ソロプレイ時は非表示にする",
    TEXT_PET = " ペットがアクティブな場合はソロでも表示する",
    TEXT_LAG = " 更新頻度（ラグ調整）: ",
    TEXT_LANG = " 言語設定: ",
    TEXT_SCALE = " 全体のサイズ（スケール）: ",
    TEXT_DIST = " 左右の間隔: ",
    STATUS_OK = "安全",
    STATUS_WARN = "注意",
    STATUS_AGRO = "危険",
    TEXT_SOUND = " ヘイト獲得時に警告音を鳴らす",
    TEXT_HIGHLIGHT = " 現在のターゲットのシグナルを強調表示する",
    TEXT_FILTER = " トーテムや低脅威ペットを除外する",
    TEXT_TARSCALE = " 強調表示されたターゲットのサイズ: ",
    TEXT_SOUND_SEL = " サウンド設定: ",
    TEXT_CHARPROFILE = " キャラクターごとのプロファイルを使用する（個別設定）",
    STATUS_TAUNT = "固定中"
}

-- MOTOR MESTRE DE GANCHO MULTILÍNGUE
function addonTable.GetText(key)
    local forced = ThreatBuddyForeverDB and ThreatBuddyForeverDB.forcedLocale
    local gameLocale = GetLocale()
    if gameLocale == "ptPT" then gameLocale = "ptBR" end
    
    local selectedLocale = forced or gameLocale
    if not addonTable.Locales[selectedLocale] then selectedLocale = "enUS" end
    return addonTable.Locales[selectedLocale][key] or addonTable.Locales["enUS"][key] or ""
end
