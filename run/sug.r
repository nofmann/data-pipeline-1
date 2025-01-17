# Ben Fasoli

site   <- 'sug'

# Load settings and initialize lock file
source('/uufs/chpc.utah.edu/common/home/lin-group9/measurements/pipeline/_global.r')
site_config <- site_config[site_config$stid == site, ]
lock_create()

try({
  # Licor 6262 -----------------------------------------------------------------
  # instrument <- 'licor_6262'
  instrument <- site_config$instrument.ghg   # 'licor_6262', 'licor_7000', or 'lgr_ugga'

  proc_init()
  nd <- cr1000_init()
  if (!site_config$reprocess)
    update_archive(nd, data_path(site, instrument, 'raw'), check_header = F)
  if(instrument=='licor_6262') nd <- licor_6262_qaqc()
  if(instrument=='licor_7000') nd <- licor_7000_qaqc()

  # Correct time stamp (erroneously set in MDT) to UTC in Oct 2021
  mask <- nd$Time_UTC > as.POSIXct('2021-10-01 00:00:00', tz = 'UTC') &
          nd$Time_UTC < as.POSIXct('2021-10-19 15:00:00' , tz = 'UTC')
  nd$Time_UTC[mask] <- nd$Time_UTC[mask] + 6*3600 # UTC is 6 hours ahead of MDT

  update_archive(nd, data_path(site, instrument, 'qaqc'))
  nd <- licor_6262_calibrate()
  update_archive(nd, data_path(site, instrument, 'calibrated'))
})

# try({
#   # MetOne ES642 ---------------------------------------------------------------
#   instrument <- 'metone_es642'
#   proc_init()
#   nd <- cr1000_init()
#   if (!site_config$reprocess)
#     update_archive(nd, data_path(site, instrument, 'raw'), check_header = F)
#   nd <- metone_es642_qaqc()
#   update_archive(nd, data_path(site, instrument, 'qaqc'))
#   nd <- metone_es642_calibrate()
#   update_archive(nd, data_path(site, instrument, 'calibrated'))
# })

lock_remove()
