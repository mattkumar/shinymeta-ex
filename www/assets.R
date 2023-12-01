# Assets.R
wp <- data.frame(SUBJIDN = 1:100,
                 TRT01A  = sample(c('High-Dose','Medium-Dose','Low-Dose'),
                                  replace = T,
                                  100),
                 AVAL    = round(runif(100,
                                       min = -100,
                                       max = 100)),
                 BOR     = sample(c('PD','SD','PR','CR'),
                                  replace = T,
                                  100),
                 stringsAsFactors = FALSE)

c1 <- '#AC92EB'
c2 <- '#4FC1E8'
c3 <- '#A0D568'
c4 <- '#FFCE54'
c5 <- '#ED5564'

# Custom CSS
styles <- "
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