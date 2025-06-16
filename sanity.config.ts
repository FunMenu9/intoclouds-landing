import { defineConfig } from "sanity"
import { deskTool } from "sanity/desk"
import { visionTool } from "@sanity/vision"

import { schema } from "./sanity/schema"
import { apiVersion, dataset, projectId } from "./sanity/env"

export default defineConfig({
  basePath: "/studio",
  projectId,
  dataset,
  schema,
  plugins: [
    deskTool({
      structure: (S) =>
        S.list()
          .title("Content Management")
          .items([
            S.listItem()
              .title("Hero Sections")
              .child(S.documentTypeList("heroSection").title("Hero Sections by Language")),
            S.listItem().title("Services").child(S.documentTypeList("service").title("Services by Language")),
            S.listItem().title("Cloud Platforms").child(S.documentTypeList("platform").title("Platforms by Language")),
            S.listItem()
              .title("Process Steps")
              .child(S.documentTypeList("processStep").title("Process Steps by Language")),
            S.listItem()
              .title("Contact Information")
              .child(S.documentTypeList("contactInfo").title("Contact Info by Language")),
            S.listItem()
              .title("Site Settings")
              .child(S.documentTypeList("siteSettings").title("Site Settings by Language")),
          ]),
    }),
    visionTool({ defaultApiVersion: apiVersion }),
  ],
})
