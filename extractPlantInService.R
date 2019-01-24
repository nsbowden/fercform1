### FERC Form 1 Table Number 52: Plant in Service

extractPlantInService = function(datadir) {

  years = seq(1994, 2017)
  prefix = paste0("f1_", years, "_")

  files1 = paste0(prefix, "F1_1.csv") 
  files52 = paste0(prefix, "F1_52.csv") 

  f1 = paste0(datadir, files1)
  f52 = paste0(datadir, files52)

  d1 = lapply(f1, function(x) read.csv(x, stringsAsFactors=FALSE))
  dd1 = do.call(rbind, d1)
  dd1 = dd1[,1:2]
  names(dd1) = c('fercID', 'utilityName')
  fercIDList = unique(dd1$fercID)
  fercList = unique(dd1)

  d52 = lapply(f52, function(x) read.csv(x, stringsAsFactors=FALSE))
  dd52 = do.call(rbind, d52)
  names(dd52) = c('fercID', 'year', 'suppNum', 'rowNum', 'rowSeq', 'rp', 'beginBal', 'add', 'retire', 'adj', 'transfer', 'endBal', 'beginBal2', 'add2', 'retire2', 'adj2', 'transfer2', 'endBal2', 'report', 'flags') 
  dd52 = dd52[c('fercID', 'year', 'rowNum', 'beginBal', 'add', 'retire', 'adj', 'transfer', 'endBal')]

  a94 = dd52$year >= 1994
  b02 = dd52$year <= 2002
  a03 = dd52$year >= 2003
  b05 = dd52$year <= 2005
  a06 = dd52$year >= 2006
  b17 = dd52$year <= 2017

  it = dd52[dd52$rowNum==5,]
  spp = dd52[(a94 & b02 & dd52$rowNum == 15) | (a03 & b17 & dd52$rowNum == 16),]
  npp = dd52[(a94 & b02 & dd52$rowNum == 23) | (a03 & b17 & dd52$rowNum == 25),]
  hpp = dd52[(a94 & b02 & dd52$rowNum == 32) | (a03 & b17 & dd52$rowNum == 35),]
  opp = dd52[(a94 & b02 & dd52$rowNum == 41) | (a03 & b17 & dd52$rowNum == 45),]
  tpp = dd52[(a94 & b02 & dd52$rowNum == 42) | (a03 & b17 & dd52$rowNum == 46),]
  tps = dd52[(a94 & b02 & dd52$rowNum == 53) | (a03 & b17 & dd52$rowNum == 58),]
  dps = dd52[(a94 & b02 & dd52$rowNum == 69) | (a03 & b17 & dd52$rowNum == 75),]
  iso = dd52[(a06 & dd52$rowNum == 84),]
  gps = dd52[(a94 & b02 & dd52$rowNum == 83) | (a03 & b05 & dd52$rowNum == 90) | (a06 & b17 & dd52$rowNum == 99),]
  ps = dd52[(a94 & b02 & dd52$rowNum == 88) | (a03 & b05 & dd52$rowNum == 95) | (a06 & b17 & dd52$rowNum == 104),]

  d = list(it, spp, npp, hpp, opp, tpp, tps, dps, iso, gps, ps)
  names(d) = c("it", "spp", "npp", "hpp", "opp", "tpp", "tps", "dps", "iso", "gps", "ps")
  d
}
