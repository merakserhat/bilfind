import { hashSync, genSaltSync, compareSync } from "bcryptjs";

export class HashingHelper {
  public static hashPassword(password: string): string {
    const salt = genSaltSync();
    return hashSync(password, salt);
  }
  public static comparePassword(raw: string, hash: string): boolean {
    return compareSync(raw, hash);
  }
}
