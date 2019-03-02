# DEMO instructions

## Prepare
1. Clone this repo
2. cd /path-to-repo
3. Run: `docker-compose pull` to make sure you have the latest versions of the images installed.
4. Run: `docker-compose up`, wait for about 5 min for KB to start (restart docker first if you are unsure what is running at the moment)
5. Go to http://localhost:7474/browser/
6. Run:
  ```
  CREATE (p:Project {projectid:'PROJ'}) // Creates a project
  CREATE (n:Person {orcid:'1234'}) // Creates a Person
  MERGE (p)<-[:has_admin_permissions]-(n) // Gives privileges to the person
```

## DEMO WEB API 

### Add Dataset
1. Go to http://localhost:5000/api
2. Click on POST /dataset/
3. Paste the following example in the Value Box
```
{
  "orcid": "1234",
  "project": "PROJ",
  "publication": "",
  "short_name": "DOS2019",
  "source_data": "https://github.com/monarch-ebi-dev/vfb-curation-demo/blob/master/docker-compose.yml",
  "title": "DOS Demo Dataset (2019)"
}
```
4. Click 'Try it out'
5. Inspect response body
6. Click again 'Try it out' to demonstrate that it would fail the second time you try to register.
7. Change the orcid and click again 'Try it out' to demonstrate that it would fail if you person does not have the right permissions.
8. Go to http://localhost:7474/browser/
9. Query `MATCH (n:Project {projectid:'PROJ'}) RETURN n`, unfold to demonstrate what happened internally

### Add Neuron
1. Go to http://localhost:5000/api
2. Click on POST /neuron/
3. Paste the following in the value box (Note the dataset IRI needs to be correct from the previous task):
```
{
  "orcid": "1234",
  "project": "PROJ",
  "primary_name": "dos-Neuron1 (demo)",
  "alternative_names": [
    "dos-Neuron1", "dos-Neuron1 demo"
  ],
  "classification": "http://purl.obolibrary.org/obo/FBbt_00110272",
  "classification_comment": "DOS Motor Neuron comment",
  "dataset_id": "http://virtualflybrain.org/data/DOS2019",
  "external_identifiers": [
    "ident1", "flybase:fictional1"
  ],
  "imaging_type": "",
  "template_id": "",
  "type_specimen": "",
  "url_skeleton_id": ""
}
```
4. Click 'Try it out'
5. Inspect response body (note that in the current version of the api, there are no uniqueness assumption on neurons: each time you submit the same payload, you get a new ID.)
6. Go to http://localhost:7474/browser/
7. Query `MATCH (n:Project {projectid:'PROJ'}) RETURN n`, unfold to demonstrate what happened internally
8. Unfold the Neuron you create to demonstrate the link to the neuron type

## UI Demo

### Add Dataset
 1. Go to http://localhost:8080/vfb-curation-ui/
 2. Click on 'Register Dataset'
 3. Add data (PROJ, 1234, Some kind of name)
 4. Hit save dataset
 5. You will see a confiromation dataset was create in the textfield below.
 6. You can deliberately chose to add wrong data, like the same dataset twice or a wrong ORCID. Not needed.
 
 ## Add Neuron
 1. Analogous to Add Dataset. Note that currently, there is no uniqueness constraint on labels; you can generate multiple ids for the same label
 
 ## Upload Neurons
 1. Download example data from https://github.com/monarch-ebi-dev/vfb-curation-demo/blob/master/demo_upload.csv
 2. Note that I only tried this with exactly this one dataset; not sure what will happen if you remove/add columns. But give changing it a shot if you want! Should work.
 3. Inspect the result table: some records might have failed. There is a button to tell you why. 
