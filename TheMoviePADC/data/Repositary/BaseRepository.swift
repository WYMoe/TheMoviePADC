//
//  BaseRepository.swift
//  TheMoviePADC
//
//  Created by Wai Yan Moe on 30/06/2023.
//

import Foundation
import CoreData

class BaseRepository: NSObject {
    
    override init() {
        super.init()
    }
    
    var coreData = CoreDataStack.shared
    
    public func handleDataError(anError:Error?) -> String {
        if let anError = anError,(anError as NSError).domain == "NSCocoaErrorDomain" {
            
            let nsError = anError as NSError
            
            var errors :[AnyObject] = []
            
            
            //multiple errors
            if (nsError.code == NSValidationMultipleErrorsError) {
                errors = nsError.userInfo[NSDetailedErrorsKey] as! [AnyObject]
            } else {
                errors = [nsError].compactMap{$0}
            }
            
            return errors.reduce("Reasons(s):\n"){(result,error) -> String in
                guard let error = error as? Error else {
                    return ""
                }
                
                
                let entityName = ((error as NSError).userInfo["NSValidationErrorObject"] as? NSManagedObject)?.entity.name ?? "Undefined Entity Name"
                let attributeName = (error as NSError).userInfo["NSValidationErrorKey"] as? String ?? "Undefined attribute"
                var msg = ""
                switch (error as NSError).code {
                case NSManagedObjectValidationError:
                    msg = "Generic validation error.";
                    break;
                case NSValidationMissingMandatoryPropertyError:
                    msg = String(format:"The attribute '%@' mustn't be empty.", attributeName)
                    break;
                case NSManagedObjectConstraintMergeError :
                    let conflictKey : String = ((error as NSError).userInfo["conflictList"] as! [NSConstraintConflict])[0].constraintValues.keys.reduce("") {"\($0):\($1)"}
                    
                    msg = "Given attribute(s) \(conflictKey) is/are in conflict with existing data"
                    
                case NSValidationRelationshipLacksMinimumCountError:
                    msg = String(format:"The relationship '%@' doesn't have enough entries.", attributeName)
                    break;
                case NSValidationRelationshipExceedsMaximumCountError:
                    msg = String(format:"The relationship '%@' has too many entries.", attributeName)
                    break;
                case NSValidationRelationshipDeniedDeleteError:
                    msg = String(format:"To delete, the relationship '%@' must be empty.", attributeName)
                    break;
                case NSValidationNumberTooLargeError:
                    msg = String(format:"The number of the attribute '%@' is too large.", attributeName)
                    break;
                case NSValidationNumberTooSmallError:
                    msg = String(format:"The number of the attribute '%@' is too small.", attributeName)
                    break;
                case NSValidationDateTooLateError:
                    msg = String(format:"The date of the attribute '%@' is too late.", attributeName)
                    break;
                case NSValidationDateTooSoonError:
                    msg = String(format:"The date of the attribute '%@' is too soon.", attributeName)
                    break;
                case NSValidationInvalidDateError:
                    msg = String(format:"The date of the attribute '%@' is invalid.", attributeName)
                    break;
                case NSValidationStringTooLongError:
                    msg = String(format:"The text of the attribute '%@' is too long.", attributeName)
                    break;
                case NSValidationStringTooShortError:
                    msg = String(format:"The text of the attribute '%@' is too short.", attributeName)
                    break;
                case NSValidationStringPatternMatchingError:
                    msg = String(format:"The text of the attribute '%@' doesn't match the required pattern.", attributeName)
                    break;
                default:
                    msg = String(format:"Unknown error (code %i).",(error as NSError))
                    break;
                }
                return "\(result)\(String(describing: entityName)):\(msg)\n"
                
                
            }
            
        } else {
            return "undefined error : CoreData Error Nil"
            
        }
    }
}
