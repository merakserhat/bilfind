import chalk from "chalk";

export default class Logging {
  public static log = (args: any) => this.info(args);
  public static info = (args: any, other?: any) =>
    console.log(
      chalk.blue(`[${new Date().toLocaleString()}]`),
      typeof args === "string" ? chalk.blueBright(args) : args,
      other ? other : ""
    );
  public static warning = (args: any) =>
    console.log(
      chalk.yellow(`[${new Date().toLocaleString()}]`),
      typeof args === "string" ? chalk.yellowBright(args) : args
    );
  public static error = (args: any) =>
    console.log(chalk.red(`[${new Date().toLocaleString()}]`), typeof args === "string" ? chalk.redBright(args) : args);
}
