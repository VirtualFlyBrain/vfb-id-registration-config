# Virtual Fly Brain ID Server: Overview

![Pipeline Overview](curation-pipeline-overview.png)

Summary: The VFB ID server allows the user to register image data and reserve VFB identifiers. It consists of four main components:

1. vfb-imageserver: The [image server](https://www.synology.com/en-global/knowledgebase/DSM/help/FileStation/file_request) allows the user to bulk-upload a set of images to a specified user directory. Files uploaded this way cannot be changed.
1. vfb-add-image: Jenkins job that has two tasks:
   1. Whenever an image is uploaded to the image server, add the image node to the kb with a status flag: "under review" and connect to existing dataset. Uploading again will simply overwrite the status flag to "under review" (we need to decide what happens to metadata - probably keep);
   1. For each set of images, the submitting user is sent a confirmation email with a CSV table  with the relevant metadata columns (and additional instructions).
1. vfb-kb
   * Image: virtualflybrain/docker-neo4j-knowledgebase:neo2owl
   * Git: https://github.com/VirtualFlyBrain/docker-neo4j-knowledgebase
   * Summary: The VFB KB instance loads the [VFB KB Archive](http://data.virtualflybrain.org/archive/VFB-KB.tar.gz) and deploys it as a Neo4J instance. All the image metadata and their associations with Neurons and projects will be managed in the KB.
   * Access: http://kb.ids.virtualflybrain.org/browser/
1. vfb-data-ingest-api
   * Image: matentzn/vfb-curation-api:latest
   * Git: https://github.com/VirtualFlyBrain/vfb-data-ingest-api
   * Summary: The Data Ingest API is a swagger REST API that allows the registration of datasets and images (image metadata upload).
   * Access: http://ids.virtualflybrain.org/api/
1. vfb-data-ingest-ui
   * Image: matentzn/vfb-curation-ui-demo:latest
   * Git: https://github.com/monarch-ebi-dev/vfb-curation-demo
   * Summary: The ID Server UI offers access to basic functionality of the vfb-curation-api. It furthermore allows groups to look at 'what is already there' in terms of metadata (without the possibility to change data).
   * Access: http://ids.virtualflybrain.org/vfb-curation-ui/
1. vfb-data-ingest-config 
   * Git: https://github.com/VirtualFlyBrain/vfb-data-ingest-config
   * Summary: This repository contains global pipeline configuration, documentations, slides and references to other Data Ingest API/UI related metadata

# Primary user story "Ingest Dataset":
 
1. (ORCID-authenticated) user registers a project, receives project id
1. User registers a dataset, receives dataset token
1. User uploads metadata to vfb-imageserver with dataset token (images are placed in temporary directory on NAS)
   * Once images are uploaded, they cannot be deleted by normal means (need email to vfb)
1. Jenkins regularly checks for new submissions. If new images are found, trigger vfb-add-image pipeline:
   1. Move image to its runtime location
   1. Add image entry to KB
      1. Add "UPLOADED" and "EMBARGOED" label
      1. Assign provisional VFB identifier
      1. If image was registered previously, set the status back to "under review"; do not re-assign identifier
      1. Decide: when image is uploaded again, should we
         1. Remove image metadata?
         1. Create a new version of the image, and add a property version="current"?
         1. Keep image metadata
            1. Always
            1. Only if checksum is the same
   1. Create a CSV file with all columns that need to be populated to activate VFB ID.
      * Add VFB id if metadata is already present and validated, else hide
   1. Send email with confirmation of dataset upload, the CSV file (and perhaps some initial QC results, min filesize violations etc?)
1. User uploads CSV with metadata to vfb-data-ingest-ui.
1. vfb-data-ingest-ui submits data to vfb-data-ingest-api (one-by-one)
1. vfb-data-ingest-ui displays a tabbed table with validated IDs; 
   * Entries which failed validation are clearly indicated in red (and filterable)
   * Progress is clearly indicated for user to know % of valid images in dataset
   * Metadata can only be replaced by valid metadata (as the ID will have been assigned at that point)

If an image has been registered previously (i.e. the metadata is valid), the VFB_ID columns come populated, else it is simply overwritten