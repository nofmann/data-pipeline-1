# Ben Fasoli

site   <- 'lgn'

# Load settings and initialize lock file
source('/uufs/chpc.utah.edu/common/home/lin-group2/measurements-beta/proc/_global.r')
lock_create()


# Licor 6262 -------------------------------------------------------------------
instrument <- 'licor_6262'
proc_init()
nd <- proc_cr1000()
update_archive(nd, file.path('data', site, instrument, 'raw/%Y_%m_raw.dat'))
nd <- licor_6262_qaqc()
update_archive(nd, file.path('data', site, instrument, 'qaqc/%Y_%m_qaqc.dat'))
nd <- licor_6262_calibrate()
update_archive(nd, file.path('data', site, instrument, 'calibrated/%Y_%m_calibrated.dat'))


# Remove lock file and exit
lock_remove()
q('no')
