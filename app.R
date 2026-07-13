# -------------------------------------------------------------------------
# PROJE: GELIR VE REFAH ANALIZORU (SaaS Mimari)
# DIL: R (SHINY FRAMEWORK)
# GELISTIRICI: Recep Semih Tani (Istatistikci)
# RESMI PORTFOY: https://github.com/receptanii
# OYNATMA HAKKI: Tum haklari Recep Semih Taniya aittir. © 2026
# -------------------------------------------------------------------------

if (Sys.info()["sysname"] == "Windows") {
  Sys.setlocale("LC_ALL", "Turkish")
}
options(shiny.sanitize.errors = FALSE, encoding = "UTF-8")

gerekli_paketler <- c("shiny", "shinydashboard", "ggplot2", "dplyr", "plotly", "readxl", "scales")
yeni_paketler <- gerekli_paketler[!(gerekli_paketler %in% installed.packages()[, "Package"])]
if (length(yeni_paketler)) {
  install.packages(yeni_paketler, dependencies = TRUE)
}

library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(plotly)
library(readxl)
library(scales)

ui <- dashboardPage(
  skin = "black",
  dashboardHeader(title = "Gelir ve Refah Analizörü"),
  
  dashboardSidebar(
    sidebarMenu(
      id = "tabs",
      menuItem("Veri Yukleme Merkezi", tabName = "yukleme", icon = icon("upload")),
      menuItem("Gelir vs Yasam Kalitesi", tabName = "bubble", icon = icon("braille")),
      menuItem("Ulke Trendleri", tabName = "trend", icon = icon("chart-line")),
      menuItem("Istatistiksel Ozet", tabName = "istatistik", icon = icon("calculator"))
    ),
    hr(),
    div(style = "padding: 15px; color: #b8c7ce; font-size: 12px;",
        p(strong("Gelistirici:")),
        p("Recep Semih Tanı"),
        p("İstatistikçi"),
        a(href = "https://github.com/receptanii", target = "_blank", style = "color: #3c8dbc; font-weight: bold;", icon("github"), " GitHub Profilim")
    )
  ),
  
  dashboardBody(
    tags$head(tags$style(HTML("
      .shiny-output-error-validation { color: #2c3e50; font-weight: bold; font-size: 15px;
        padding: 15px; background-color: #ecf0f1; border-left: 5px solid #34495e; border-radius: 4px; }
      .footer-signature { text-align: right; margin-top: 30px; color: #7f8c8d; font-style: italic; border-top: 1px solid #bdc3c7; padding-top: 10px; }
    "))),
    
    tabItems(
      tabItem(tabName = "yukleme",
              fluidRow(
                box(width = 4, title = "Dosya Yukleme Paneli", status = "primary", solidHeader = TRUE,
                    p("Sisteme yukleyeceginiz Excel veya CSV dosyasinda su 4 sutun ismi mutlaka (kucuk harflerle) bulunmalidir:"),
                    tags$ul(
                      tags$li(strong("ulke")), tags$li(strong("yil")),
                      tags$li(strong("gelir")), tags$li(strong("yasam_beklentisi"))
                    ),
                    p("Grafikleri renklendirmek icin opsiyonel olarak 'kita' sutununu da ekleyebilirsiniz."),
                    hr(),
                    # GITHUB ÖRNEK VERİ İNDİRME BUTONU
                    tags$a(
                      href = "https://github.com/receptanii/gelir-ve-refah-analizatoru/raw/main/refah_analizi_ornek_veri.xlsx", 
                      "📥 Örnek Veri Setini İndir (.xlsx)", 
                      class = "btn btn-info btn-block", 
                      style = "margin-bottom: 15px; color: white; font-weight: bold;", 
                      download = NA
                    ),
                    fileInput("yuklenen_dosya", "Analiz Icin Veri Dosyasi Sec (.csv veya .xlsx):", accept = c(".csv", ".xlsx")),
                    actionButton("veriyi_uygula", "Veriyi Sisteme Entegre Et", icon = icon("check"), class = "btn-success")
                ),
                box(width = 8, title = "Yuklenen Veri Onizleme (Ilk 8 Satir)", status = "success", solidHeader = TRUE,
                    tableOutput("yuklenen_onizleme")
                )
              ),
              div(class = "footer-signature", "Bu yazılım platformunun tum hakları ve mimarisi Recep Semih Tanı'ya aittir. © 2026")
      ),
      
      tabItem(tabName = "bubble",
              fluidRow(
                box(width = 3, title = "Kontroller", status = "info", solidHeader = TRUE,
                    uiOutput("dinamik_yil_slider"),
                    uiOutput("dinamik_kita_filtresi"),
                    checkboxInput("log_olcek", "Geliri logaritmik olcekte goster", TRUE)
                ),
                box(width = 9, title = "Kisi Basi Gelir vs Yasam Beklentisi", status = "primary", solidHeader = TRUE,
                    plotlyOutput("bubble_grafik", height = "520px")
                )
              ),
              div(class = "footer-signature", "Recep Semih Tanı - İstatistik Portföyü")
      ),
      
      tabItem(tabName = "trend",
              fluidRow(
                box(width = 3, title = "Ulke Secimi", status = "info", solidHeader = TRUE,
                    uiOutput("dinamik_ulke_secici")
                ),
                box(width = 9, title = "Gelir Trendi (Yillar Icinde)", status = "primary", solidHeader = TRUE,
                    plotlyOutput("gelir_trend_grafik", height = "300px")
                )
              ),
              fluidRow(
                box(width = 12, title = "Yasam Beklentisi Trendi", status = "success", solidHeader = TRUE,
                    plotlyOutput("yasam_trend_grafik", height = "300px")
                )
              ),
              div(class = "footer-signature", "Recep Semih Tanı - İstatistik Portföyü")
      ),
      
      tabItem(tabName = "istatistik",
              fluidRow(
                box(width = 4, title = "Ayarlar", status = "info", solidHeader = TRUE,
                    uiOutput("dinamik_istatistik_yil")
                ),
                box(width = 8, title = "Korelasyon Analizi Sonuclari", status = "warning", solidHeader = TRUE,
                    tableOutput("korelasyon_tablo")
                )
              ),
              fluidRow(
                box(width = 12, title = "Ekonometrik Degerlendirme (Preston Egrisi)", status = "primary", solidHeader = TRUE,
                    uiOutput("istatistik_yorum")
                )
              ),
              div(class = "footer-signature", "Recep Semih Tanı - İstatistik Portföyü")
      )
    )
  )
)

server <- function(input, output, session) {
  
  aktif_veri <- reactiveVal(NULL)
  
  veri_oku <- reactive({
    infile <- input$yuklenen_dosya
    if (is.null(infile)) return(NULL)
    ext <- tools::file_ext(infile$name)
    df <- tryCatch({
      if (ext == "csv") read.csv(infile$datapath, stringsAsFactors = FALSE)
      else if (ext == "xlsx") as.data.frame(read_excel(infile$datapath, sheet = 1))
      else "FORMAT_HATASI"
    }, error = function(e) "OKUMA_HATASI")
    
    if (is.data.frame(df)) {
      if ("gelir" %in% names(df)) {
        df$gelir <- as.numeric(gsub("[^0-9.]", "", as.character(df$gelir)))
      }
      if ("yasam_beklentisi" %in% names(df)) {
        df$yasam_beklentisi <- as.numeric(gsub("[^0-9.]", "", as.character(df$yasam_beklentisi)))
      }
      if ("yil" %in% names(df)) {
        df$yil <- as.numeric(gsub("[^0-9.]", "", as.character(df$yil)))
      }
      df <- df[complete.cases(df[, c("ulke", "yil", "gelir", "yasam_beklentisi")]), ]
    }
    df
  })
  
  output$yuklenen_onizleme <- renderTable({
    df <- veri_oku()
    validate(need(!is.null(df), "Lutfen analiz etmek istediginiz Excel (.xlsx) veya CSV (.csv) dosyasini sisteme yukleyin."))
    validate(need(!identical(df, "FORMAT_HATASI"), "HATA: Sadece .csv veya .xlsx formatlari kabul edilmektedir."))
    validate(need(!identical(df, "OKUMA_HATASI"), "HATA: Dosya okunurken bir sorun olustu. Dosya yapisini kontrol edin."))
    
    zorunlu_kolonlar <- c("ulke", "yil", "gelir", "yasam_beklentisi")
    validate(need(all(zorunlu_kolonlar %in% names(df)),
                  paste("HATA: Yuklenen dosyada su zorunlu sutunlar eksik:", 
                        paste(setdiff(zorunlu_kolonlar, names(df)), collapse = ", "))))
    head(df, 8)
  })
  
  observeEvent(input$veriyi_uygula, {
    df <- veri_oku()
    zorunlu_kolonlar <- c("ulke", "yil", "gelir", "yasam_beklentisi")
    if (!is.null(df) && is.data.frame(df) && all(zorunlu_kolonlar %in% names(df))) {
      if (!"kita" %in% names(df)) df$kita <- "Genel"
      if (!"nufus" %in% names(df)) df$nufus <- 10000000 
      
      aktif_veri(df)
      showNotification("Veri seti sisteme basariyla entegre edildi. Diger sekmelerden analize baslayabilirsiniz.", type = "message")
    } else {
      showNotification("Veri entegrasyonu basarisiz! Lutfen once gecerli bir dosya yukleyin.", type = "error")
    }
  })
  
  veri_mevcut_mu <- function() {
    df <- aktif_veri()
    validate(need(!is.null(df), "Bu analizi gorebilmek icin once 'Veri Yukleme Merkezi' sekmesinden dosyanizi yukleyip entegre etmelisiniz."))
    return(df)
  }
  
  output$dinamik_yil_slider <- renderUI({
    df <- veri_mevcut_mu()
    sliderInput("secilen_yil", "Yil Secimi:",
                min = min(df$yil), max = max(df$yil),
                value = max(df$yil), step = if(length(unique(df$yil)) > 1) sort(unique(df$yil))[2] - sort(unique(df$yil))[1] else 1,
                sep = "", animate = animationOptions(interval = 1300, loop = TRUE))
  })
  
  output$dinamik_kita_filtresi <- renderUI({
    df <- veri_mevcut_mu()
    checkboxGroupInput("secilen_kita", "Bolge / Kita Filtresi:",
                       choices = unique(df$kita), selected = unique(df$kita))
  })
  
  output$dinamik_ulke_secici <- renderUI({
    df <- veri_mevcut_mu()
    selectInput("secilen_ulkeler", "Karsilastirilacak Ulkeler:",
                choices = unique(df$ulke),
                selected = head(unique(df$ulke), 3),
                multiple = TRUE)
  })
  
  output$dinamik_istatistik_yil <- renderUI({
    df <- veri_mevcut_mu()
    selectInput("istatistik_yil", "Analiz Yili Secin:",
                choices = sort(unique(df$yil), decreasing = TRUE))
  })
  
  output$bubble_grafik <- renderPlotly({
    df <- veri_mevcut_mu()
    req(input$secilen_yil, input$secilen_kita)
    
    veri_yil <- df %>% filter(yil == input$secilen_yil, kita %in% input$secilen_kita)
    validate(need(nrow(veri_yil) > 0, "Secilen kriterlere uygun veri bulunamadi."))
    
    p <- ggplot(veri_yil, aes(x = gelir, y = yarom_beklentisi, size = nufus, color = kita,
                              text = paste0("Ulke: ", ulke, "<br>Gelir: ", comma(round(gelir)), " TL",
                                            "<br>Yasam Beklentisi: ", round(yasam_beklentisi, 1), " Yil"))) +
      geom_point(alpha = 0.7) +
      scale_size_continuous(range = c(3, 18), guide = "none") +
      labs(x = "Kisi Basina Dusen Gelir (TL)", y = "Yasam Beklentisi (Yil)", color = "Bolge") +
      theme_minimal(base_size = 13)
    
    if (isTRUE(input$log_olcek)) p <- p + scale_x_log10(labels = comma)
    else p <- p + scale_x_continuous(labels = comma)
    
    ggplotly(p, tooltip = "text")
  })
  
  output$gelir_trend_grafik <- renderPlotly({
    df <- veri_mevcut_mu()
    req(input$secilen_ulkeler)
    
    veri <- df %>% filter(ulke %in% input$secilen_ulkeler)
    validate(need(nrow(veri) > 0, "Lutfen en az bir ulke secin."))
    
    p <- ggplot(veri, aes(x = yil, y = gelir, color = ulke)) +
      geom_line(size = 1) + geom_point(size = 1.5) +
      labs(x = "Yil", y = "Kisi Basi Gelir (TL)", color = "Ulke") +
      scale_y_continuous(labels = comma) +
      theme_minimal(base_size = 13)
    ggplotly(p)
  })
  
  output$yasam_trend_grafik <- renderPlotly({
    df <- veri_mevcut_mu()
    req(input$secilen_ulkeler)
    
    veri <- df %>% filter(ulke %in% input$secilen_ulkeler)
    validate(need(nrow(veri) > 0, "Lutfen en az bir ulke secin."))
    
    p <- ggplot(veri, aes(x = yil, y = yasam_beklentisi, color = ulke)) +
      geom_line(size = 1) + geom_point(size = 1.5) +
      labs(x = "Yil", y = "Yasam Beklentisi (Yil)", color = "Ulke") +
      theme_minimal(base_size = 13)
    ggplotly(p)
  })
  
  output$korelasyon_tablo <- renderTable({
    df <- veri_mevcut_mu()
    req(input$istatistik_yil)
    
    veri <- df %>% filter(yil == input$istatistik_yil)
    validate(need(nrow(veri) > 3, "Korelasyon analizi icin bu yilda yeterli gozlem sayisi yok."))
    
    dogrusal_kor <- cor(veri$gelir, veri$yasam_beklentisi, use = "complete.obs")
    log_kor <- cor(log(veri$gelir), veri$yasam_beklentisi, use = "complete.obs")
    model <- lm(yasam_beklentisi ~ log(gelir), data = veri)
    r2 <- summary(model)$r.squared
    
    data.frame(
      Analiz_Metrigi = c("Dogrusal Korelasyon Katsayisi (r)",
                         "Logaritmik Donusumlu Korelasyon Katsayisi (r)",
                         "Regresyon R-Kare Degeri (Aciklayicilik Orani)"),
      Deger = round(c(dogrusal_kor, log_kor, r2), 3)
    )
  })
  
  output$istatistik_yorum <- renderUI({
    df <- veri_mevcut_mu()
    req(input$istatistik_yil)
    
    veri <- df %>% filter(yil == input$istatistik_yil)
    if(nrow(veri) <= 3) return(p("Yorum uretmek icin yetersiz gozlem sayisi."))
    
    log_kor <- cor(log(veri$gelir), veri$yasam_beklentisi, use = "complete.obs")
    model <- lm(yasam_beklentisi ~ log(gelir), data = veri)
    r2 <- summary(model)$r.squared
    
    HTML(paste0(
      "<p>Secilen yil olan <b>", input$istatistik_yil, "</b> icin analiz sonuclari: ",
      "Logaritmik korelasyon katsayisi <b>", round(log_kor, 2), "</b> olarak hesaplanmistir. ",
      "Kurulan regresyon modeli varyansin yaklasik <b>%", round(r2 * 100, 0), "</b> kismini tek basina aciklamaktadir.</p>",
      "<p>Logaritmik modelin basarisi ampirik olarak <b>Preston Egrisi</b> hipotezini destekler. Gelir artisi dusuk gelir grubundaki bolgelerde yasam suresini hizla yukseltirken, yuksek gelir grubundaki bolgelerde marjinal artisin etkisi azalmaktadir.</p>"
    ))
  })
}

shinyApp(ui = ui, server = server)