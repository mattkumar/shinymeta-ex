# Libraries
library(shiny)
library(shinymeta)
#remotes::install_github("datasketch/shinypanels@8be05c0ff074000f82f5903d597ce9e0eb0fc6b2")
library(shinypanels)  
library(shinyglide)
library(reactable)
library(colourpicker)
library(whisker)
library(dplyr)
library(magrittr)
library(ggplot2)
library(shinyjs)

# App Header
app_header <- div(style="", 
                  class="topbar",
                  #img(class="topbar__img2", src = "img2.png", width="60", height="60"),
                  HTML("<div class = 'top_title'> Waterfall Creator <div class = 'top_line'> <div style = 'margin-left: 10px;'> Reproducibility with shinyMeta </div></div></div>"),
                  HTML("<div class = 'topbar__img'>  </div>"))

# Panel Colors
c1 <- '#AC92EB'
c2 <- '#4FC1E8'
c3 <- '#A0D568'
c4 <- '#FFCE54'
c5 <- '#ED5564'

# Choice List for selectInputs
my_choices <- c('TRT01A' = 'TRT01A',
                'GRP' = 'GRP',
                'None' = 'None')

# Choice List for radioButtons
my_theme_choices <- c("Light" = "light",
                      "Dark"  = "dark",
                      "Classic" = "classic",
                      "Minimal" = "minimal")

# Custom CSS
styles <- "
ol { counter-reset: item; }

ol li { display: block; }

ol li:before {
              content: counter(item) '. ';
              counter-increment: item;
              color: #AC92EB;
              font-weight: bold;
             }
        
.center {
  float: left;
  padding-right: 40px;
}

.topbar {
    padding: 20px 55px;
    background-image: linear-gradient(to left, #226554, #2e4856);
    font-size: 14px;
    color: #fff;
    overflow: hidden;
}
.top_title {
  margin-left: 24px;
  display: flex;
}
.topbar__img {
  margin-left: auto;
  font-style: italic;
  font-weight: 700;
}
.topbar__img2 {
  float: left;
  font-style: italic;
  font-weight: 700;
}
.top_line {
  border-left: 1px solid #ffffff;
  margin-left: 10px;
  font-weight: 700;
}

@media only screen and (min-width: 768px) {
  .topbar, .tex_sub {
    font-size: 20px;
  }
}
@media only screen and (min-width: 1024px) {
  .topbar, .tex_sub {
    font-size: 32px;
  }
}
}
"