A library chart is a type of Helm chart that defines chart primitives or definitions which can be shared by Helm templates in other charts. This allows users to share snippets of code that can be re-used across charts, avoiding repetition and keeping charts DRY


Using Library Charts
To leverage the named templates defined in your library chart, you need to import it by declaring it as a dependency in your application chart’s Chart.yaml file. You’ll provide your library chart’s name, version, and repository under the dependencies section. Here’s an example:
```yaml
apiVersion: v2
name: nginx
version: 1.0.0
dependencies:
  - name: helm-chart-library
    version: 1.0.0
    repository: https://my-chart-repo.example.com/
```
Sometimes, it’s more convenient to reference the library chart as a local file path, especially if your library chart is part of a monorepo with the rest of your application charts. In that case, the below declaration might be easier to maintain:
```yaml
apiVersion: v2
name: nginx
version: 1.0.0
dependencies:
  - name: helm-chart-library
    version: 1.0.0
    repository: file://../library-chart
```
Once you have declared your library chart as a dependency, be sure to run the helm dependency update command to import the chart:
```bash
→ helm dependency update nginx
```
Hang tight while we grab the latest from your chart repositories...
...
Update Complete. ⎈Happy Helming!⎈
Saving 1 charts

Reference documentation:
https://austindewey.com/2020/08/17/how-to-reduce-helm-chart-boilerplate-with-library-charts/