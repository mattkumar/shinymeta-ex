# Define server logic 
shinyServer(function(input, output, session) {
  
  #### Panel 1 - Intro
  # Give the user a demo of what the data layout is 
  output$sample_data_view <- renderReactable(
    reactable(tibble::tribble(
      ~SUBJIDN,     ~TRT01A, ~AVAL, ~GRP,
            1L,  "Low-Dose",    19, "SD",
            2L, "High-Dose",   -93, "CR",
            3L,  "Low-Dose",    40, "CR",
            4L,  "Low-Dose",    49, "SD",
            5L, "High-Dose",    84, "PD"
          ),
          defaultColDef = colDef(align = "center"))
  )

  
  #### Panel 2 - Data
  # Create a set of shiny inputs for each group, based on how many are requested
  output$groups <- renderUI({
    req(input$ngroups > 0)
    n <- input$ngroups
    lapply(1:n, function(i) {
      tagList(
        div(style="display:inline-block;align-content: center;justify-content: center",
            textInput(paste0("grp",i), paste("Arm",i,"Name"), paste("Arm", i)),
            numericInput(paste0("n",i), paste("Arm",i,"Size"), value = 3)
            ))
    })
  })
  
  output$gen_button <- renderUI({
    req(input$ngroups>0)
    actionButton("gen","generate", style="color: #fff; background-color: #4FC1E8; border-color: #2e6da4")
  })
  
  # Create the simulated data set
  data_gen <- eventReactive(input$gen, {
    removeClass("preview", "collapsed")
    runjs(paste0('$("#preview").css({"data-width": "600", "width": "600px"})'))
    
     n <- input$ngroups
    df <- c()
    for (i in 1:n) {
      df[[i]] <- data.frame(stringsAsFactors = FALSE,
                            TRT01A = rep(eval(parse(text = paste0("input$grp",i))), 
                                         each = eval(parse(text = paste0("input$n",i))))
      )
    }
    sample_data <- do.call(rbind, df)
    sample_data$AVAL <- round(runif(nrow(sample_data), min = -100, max = 100)) 
    sample_data$GRP  <- sample(c('CR','PR','SD','PD'), nrow(sample_data), replace = T)
    sample_data$SUBJIDN   <- 1:nrow(sample_data)
    sample_data <- sample_data[, c("SUBJIDN","TRT01A","AVAL","GRP")]
    sample_data
  })

  
  output$data_view <- renderUI({
    req(data_gen())
    tagList(
      h2("Data Preview"),
      hr(color = c2),
      p("Below is a preview of your simulated data."),
      br(),
      reactable(data_gen(),
                defaultPageSize = 6,
                defaultColDef = colDef(align = "center")))

  })
  
  #### Panel 4 - Configure
  # Create a dynamic set of colorInputs for each value of TRT01A in the simulated data
  output$colors <- renderUI({
    req(input$x != "None")
    names <- sort(unique(data_gen()[[input$x]]))
    n <- as.integer(length(sort(unique(data_gen()[[input$x]]))))
    colours <- viridis::viridis(n)
    lapply(1:n, function(i) {
      column(3,
             colourpicker::colourInput(paste0("fill",i), paste0("Category ", names[i], ":"), colours[i])
      )
    })
  })
  
  # Track color selections
  my_colors <- metaReactive2({
    if (input$x == "None") {
      metaExpr({
        geom_blank()
      })
    } else {
      if(is.null(input$fill1)) {
        allfills <- rep("black",each = input$ngroups)
      } else {
        allfills <- c()
        for (i in length(unique(data_gen()[[input$x]])):1){
          eval(parse(text = paste0("allfills[",i,"] <- input$fill",i)))
        }
      }
      metaExpr({
        my_color_values <- ..(allfills)
        scale_fill_manual(values = my_color_values)
      })
    }
  })
  
  # Track mappings decision
  my_mappings <- metaReactive2({
    if (input$x == "None") {
      metaExpr({aes_string(y = "AVAL", 
                           x = "reorder(SUBJIDN, -AVAL)")
      })
    } else {
      metaExpr({aes_string(y = "AVAL", 
                           x = "reorder(SUBJIDN, -AVAL)",
                           fill = ..(input$x))
      })
    }
  })
  
  # Track facets decision
  my_facets <- metaReactive2({
    if (input$y == "None") {
      metaExpr({
        geom_blank()
      })
    } else {
      metaExpr({
        facet_wrap(. ~ .data[[..(input$y)]], scales = "free_x")
      })
    }
  })
  
  # Track themes decision
  my_plot_theme <- metaReactive2({
    if (input$theme == "light") {
      metaExpr({
        theme_light()
      })
    } else if (input$theme == "dark") {
      metaExpr({
        theme_dark()
      })
    } else if (input$theme == "classic") {
      metaExpr({
        theme_classic()
      })
    } else if (input$theme == "minimal") {  
      metaExpr({
        theme_minimal()
      })
    }
  })
  
  # Track refline decision
  my_refline <- metaReactive2({
    if (input$refline_type == "None") {
      metaExpr({
        geom_blank()
      })
    } else {
      metaExpr({
        geom_hline(yintercept = ..(input$refline_coord), linetype = ..(input$refline_type), color = ..(input$refline_color))
      })
    }
  })
  
  observeEvent(input$refline_type, {
    if (input$refline_type == "None")
      hide('refline_ctrl')
    if (input$refline_type != "None")
      show('refline_ctrl')
  })
 
  
  #### Panel 3 - Visualization
  # Create the waterfall plot
  output$plot <-  metaRender2(renderPlot, {
     
    sim_data <- data_gen()
    metaExpr({
      '# Plot'
      p <- ggplot(sim_data, mapping = ..(my_mappings())) +
        geom_bar(stat="identity") +
        ..(my_colors()) +
        labs(x = ..(input$xaxis), 
             y = ..(input$yaxis), 
             title = ..(input$title)) +
        ..(my_facets()) +
        ..(my_refline()) +
        scale_y_continuous(labels = function(x) paste0(x, "%")) +
        ..(my_plot_theme()) +
        theme(axis.text.x = element_blank(),
              axis.ticks.x = element_blank(),
              legend.position = "bottom") 
      
      p
    })
  })
  
  # outputOptions(output, "plot", suspendWhenHidden = FALSE)
  
  
  #### Panel 5 - Code
  # Create an output for the data gen so it appears in order
  output$data <- metaRender2(renderPrint, {
    metaExpr({
      '# Restore User Data and Plot Options'
      sim_data <- ..(data_gen())
    })
  })
    
    
  # Create a dynamic view of the code for output$plot()
  output$code <- renderPrint({
    expandChain(output$data(),
                output$plot())
  })
  
  # Download Button 1 - creates script.r
  output$download_button <- downloadHandler(
    filename = function(){
      paste("script.r", sep = "")
    },
    content = function(file) {
      code <- expandChain(
        metaAction({
          '# Load Libraries'
          library(ggplot2)
        })(),
        output$data(),
        output$plot(),
        metaAction({
          '# Save Image'
          ggsave(filename = "waterfall_output.png")
        })()
      ) %>%
        formatCode() %>%
        paste(collapse = "\n")
      
      template = readLines("www/template_r.r")
      data <- list(r_date = Sys.Date(), r_name = input$name, r_code = code, valid_r = input$valid_r)
      writeLines(whisker.render(template, data), file)
    }
  )

})
