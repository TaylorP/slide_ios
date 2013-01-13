/*
 *
 *  OBImage/OBImageCacheConfig.h
 *
 *  Taylor Petrick
 *  Orange Bytes
 *
 */

#define kOBImageCacheVersion    110
#define kOBImageCacheDebug      NO

#define kOBLargeTileCornerSize  4.0f
#define kOBSmallTileCornerSize  3.0f
#define kOBPreviewCornerSize    4.0f

#define kOBButtonEdgeThickness  2.0f
#define kOBButtonCornerSize     4.0f

#define kOBSwitchEdgeThickness  2.0f
#define kOBSwitchCornerSize     4.0f

#define kOBTileImageNameFormat              @"im_tile_background_%i"
#define kOBTileContentNameFormat            @"im_%@_%i_%i_%i"
#define kOBPreviewImageNameFormat           @"im_preview_background_%f_%f"
#define kOBButtonEdgeImageNameFormat        @"im_button_edge_%f_%f"
#define kOBSwitchEdgeImageNameFormat        @"im_switch_edge_%f_%f"
#define kOBSwitchControlImageNameFormat     @"im_switch_control_%f_%f"
#define kOBOrangeGradientImageNameFormat    @"im_orange_gradient_%f_%f"

#define kOBCustomImageFolderName            @"custom_images"