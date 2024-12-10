# Job Match Recommendation app

### This application evaluates two CSV inputs:

`jobseekers.csv`: This file contains information about jobseekers. Each row represents a jobseeker and has the following columns:

* `id`: A unique identifier for the jobseeker.
* `name`: The name of the jobseeker.
* `skills`: A comma-separated list of the jobseeker's skills.

### and

`jobs.csv`: This file contains information about jobs. Each row represents a job and has the following columns:

* `id`: A unique identifier for the job.
* `title`: The title of the job.
* `required_skills`: A comma-separated list of skills required for the job.

It outputs a list of job recommendations for each jobseeker. Each recommendation includes the jobseeker's ID, the job ID, and the number of matching skills.

The output is sorted first by jobseeker ID and then by the percentage of matching skills in descending order (so that jobs with the highest percentage of matching skills are listed first).
If two jobs have the same matching skill percentage, they are sorted by job ID in ascending order.

Here's an example of what the output will look like:

```
jobseeker_id, jobseeker_name, job_id, job_title, matching_skill_count, matching_skill_percent
1, Alice, 5, Ruby Developer, 3, 100
1, Alice, 2, .NET Developer, 3, 75
1, Alice, 7, C# Developer, 3, 75
1, Alice, 4, Dev Ops Engineer, 4, 50
2, Bob, 3, C++ Developer, 4, 100
2, Bob, 1, Go Developer, 3, 75
...
```

Prerequisites:
- Postgresql (any will do, recommended is v17)

To run:
```
$ bin/setup
$ bin/dev
```
