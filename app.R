# This is a Shiny web application. You can run the application by clicking
# Author: Biomanba生信基地 （稳妥少年）
# Date:2024-11-1
# https://shiny.posit.co/

library(shiny)
library(DT)
library(shinyjs)
library(shinycssloaders)
library(shinyWidgets)
library(shinydashboard)
library(markdown)

text = "欢迎来到我们的转录组数据库，这是一个专为生物医学研究人员设计的资源，旨在提供全面的支持进行转录组数据分析。我们的数据库集成了强大的差异表达分析工具和通路分析功能，能够帮助您深入理解基因表达模式，揭示生物学过程中的关键调控机制。通过这个数据库，研究人员可以轻松地识别出在不同条件下显著变化的基因，以及它们在生物学通路中的作用，从而加速科学发现和新药开发的过程。"
ui <- fluidPage(
  shinyjs::useShinyjs(),
  tags$head(
    tags$style(HTML("
    
    .home-page {
      background-image: url('https://geng-1317909610.cos.ap-beijing.myqcloud.com/1.jpg');
      background-size: cover;
      background-position: center;
      background-repeat: no-repeat;
      height: 90vh;
      display: flex;
      justify-content: center;
      align-items: center;
      text-align: center;
    }
    h1 {
      font-family: 'Arial', sans-serif;
      font-size: 40px;
      color: black;
    }
    .info-box {
      background-color: rgba(255, 255, 255, 0.8);
      border: 2px solid #ccc;
      padding: 20px;
      border-radius: 10px;
      font-family: 'Arial', sans-serif;
      font-size: 20px;
      color: #333;
      max-width: 1000px;
      margin: 0 auto;
    }
    #search {
      display: block;
      margin: 0 auto;
      width: 350%;
      max-width: 1000px;
      padding: 10px;
      font-size: 18px;
    }
    .btn-center {
      display: block;
      margin: 10px auto;
      font-size: 18px;
    }

    /* Loading animation */
    #loading {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      z-index: 100;
      display: none;
    }
    
    "))
  ),
  # 创建导航栏
  navbarPage("Shiny_WTSN", id = "navbar",
             
             # 首页标签
             tabPanel("首页",
                      div(class = "home-page", 
                          div(
                            h1("Shiny Database"),
                            div(class = "info-box",
                                p(text)
                            ),
                            br(),
                            textInput("search", label = NULL, placeholder = "Input gene name"),
                            actionButton("search_button", "Search", class = "btn-center"),
                            br(),
                            a("查看结果展示", href = "#", id = "link_to_results", class = "btn btn-link")
                          )
                      )
             ),
             tabPanel("Support",
                      fluidRow(
                        column(7,
                               box(
                                 width = 7,
                                 height = "800px",
                                 collapsible = TRUE,
                                 collapsed = TRUE,
                                 tags$div(
                                   class = "box-body",
                                   tags$iframe(src = "Help-page.html", 
                                               style = "width: 180%; height: 800px; border: none;")
                                 ))),
                        column(5,
                               h2("Help-page Data Download"),
                               fluidRow(
                                 div(
                                   style = "display: flex; justify-content: center; align-items: center; gap: 20px;",
                                   box(title = "", status = "success", solidHeader = TRUE, width = 10,
                                       h3(text),
                                       # br(),
                                       h3("GitHub URL: "),
                                       p(a("gengjie2000/", href = "https://github.com/gengjie2000/Help-page.git", target = "_blank"))  # 超链接
                                   ))),
                               fluidRow(
                                 a(href = "https://github.com/gengjie2000/Help-page.git", class = "image-link7")
                                 ))
                        ))
))

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  # 初始化标志，判断用户是否进行了搜索
  search_triggered <- reactiveVal(FALSE)
  
  # 监听搜索按钮事件
  observeEvent(input$search_button, {
    gene_input <- input$search  # 获取用户输入的基因名称
    
    # 如果用户输入了基因名称并点击了搜索按钮，进行搜索
    if (gene_input != "") {
      # 设置标志为TRUE，表示用户进行了搜索
      search_triggered(TRUE)
      
      # 基于用户输入筛选数据
      filtered_data <- data1[grep(gene_input, data1$GeneSymbol, ignore.case = TRUE), ]
      
      # 渲染过滤后的数据表
      output$results_table2 <- renderDT({
        datatable(filtered_data,
                  options = list(
                    pageLength = 5,  # 每页显示5行
                    lengthMenu = c(5, 10, 15),  # 用户可选择每页显示5行、10行或15行
                    searching = FALSE,  # 禁用搜索框（因为我们已经通过输入框搜索）
                    ordering = TRUE,  # 启用列排序
                    autoWidth = TRUE  # 自动调整列宽
                  ),
                  rownames = FALSE  # 隐藏行名
        )
      })
      observeEvent(input$link_to_results, {
        updateTabsetPanel(session, "navbar", selected = "结果展示")
      })
    }
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
