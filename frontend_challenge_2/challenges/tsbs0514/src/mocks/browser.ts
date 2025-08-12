import { setupWorker } from "msw/browser";
import { handlers } from "./handlers";

// Service workerの設定
export const worker = setupWorker(...handlers);
