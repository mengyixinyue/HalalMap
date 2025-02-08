//
//  HMMapNetworkAPI.h
//  HalalMap
//
//  Created by 刘艳杰 on 16/3/29.
//  Copyright © 2016年 halalMap. All rights reserved.
//

#ifndef HMMapNetworkAPI_h
#define HMMapNetworkAPI_h


//搜索附近一定范围内的POI
#define HMRequestSearchAroundPOI @"v1/poi/search/around"

//按区县商圈筛选 
#define HMRequestSearchDistrictPOI(city_guid) ([NSString stringWithFormat:@"v1/poi/%@/search/region", city_guid])

//开通清真地图的城市
#define HMRequestCities  @"v1/region/cities"

//某城市下区县及商圈列表
#define HMRequestDistrictsAndBusinessAreas(city_guid) ([NSString stringWithFormat:@"v1/region/city/%@/regions", city_guid])

//地理反编码
#define HMRequestGeocode @"v1/geocode/regeo"

#endif /* HMMapNetworkAPI_h */
