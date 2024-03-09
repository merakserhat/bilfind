import "reflect-metadata";
import { classToPlain, plainToClass } from "class-transformer";
import { validateSync, ValidationError } from "class-validator";
import * as _ from "lodash";
import { ApiErrorCode } from "./error-codes";

export class Mapper {
  static map(classToMap: any, data: any): any {
    const object: any = plainToClass(classToMap, data, {
      excludeExtraneousValues: true,
    });
    if (data) {
      const validationErrors: ValidationError[] = validateSync(object, {
        validationError: { target: false },
      });
      if (_.isEmpty(validationErrors)) {
        return object;
      }
      throw new Error(`${ApiErrorCode.INVALID_REQUEST_BODY} ${_.map(validationErrors, "property").toString()}`);
    }

    return object;
  }

  static toPlain(data: any): any {
    return classToPlain(data, { excludeExtraneousValues: true });
  }

  private static ifAnyPropertyIsUndefined(object: { [key: string]: any }, skippedProperties?: string[]): boolean {
    const keys: string[] = Object.keys(object);
    for (let i = 0; i < keys.length; i++) {
      const key: string = keys[i];
      if (skippedProperties && skippedProperties.includes(key)) {
        // eslint-disable-next-line no-continue
        continue;
      }
      if (object[key] === undefined) {
        console.error(`Property is missing!${key}`);
        return true;
      }
    }
    return false;
  }
}
