
#import <UIKit/UIKit.h>

@interface Productcell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblProductName;
@property (weak, nonatomic) IBOutlet UILabel *lblProductDesc;
@property (weak, nonatomic) IBOutlet UILabel *lblProductCost;
@property (weak, nonatomic) IBOutlet UIImageView *ProductImage;
@property (weak, nonatomic) IBOutlet UIImageView *UserImage;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblStartTime;
@property (weak, nonatomic) IBOutlet UILabel *lblEndTime;

@end
