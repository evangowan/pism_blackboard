#! /bin/bash

mkdir figures


cover=50
for folder in new_basal_50_cover new_basal_50_cover_lowangle2 new_basal_50_cover_lowangle2_phi20 new_basal_50_cover_lowangle2_phi20_wet new_basal_50_cover_lowangle2_phi20_wet0 new_basal_50_cover_lowangle2_phi20_wet2 new_basal_50_cover_lowangle2_phi20_wet3 new_basal_50_cover_lowangle3 new_basal_50_cover_lowangle3_phi20
do


cd ${folder}/high

bash ../../velocity_ts_plot.sh ${cover}

cp velocity_compare_6.pdf ../../figures/${folder}.pdf

cd ../..

done


cover=80
for folder in  new_basal_80_cover 
do


cd ${folder}/high

bash ../../velocity_ts_plot.sh ${cover}

cp velocity_compare_6.pdf ../../figures/${folder}.pdf

cd ../..

done

cover=95
for folder in new_basal_95_cover new_basal_95_cover_default_phi20 new_basal_95_cover_lowangle new_basal_95_cover_lowangle2 new_basal_95_cover_lowangle2_phi20 new_basal_95_cover_lowangle3 new_basal_95_cover_lowangle3_phi20 
do


cd ${folder}/high

bash ../../velocity_ts_plot.sh ${cover}

cp velocity_compare_6.pdf ../../figures/${folder}.pdf

cd ../..

done


cover=99
for folder in  new_basal_99_cover
do


cd ${folder}/high

bash ../../velocity_ts_plot.sh ${cover}

cp velocity_compare_6.pdf ../../figures/${folder}.pdf

cd ../..

done
