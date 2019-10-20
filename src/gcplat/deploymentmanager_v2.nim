
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Cloud Deployment Manager
## version: v2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Declares, configures, and deploys complex solutions on Google Cloud Platform.
## 
## https://cloud.google.com/deployment-manager/
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_578355 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578355](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578355): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "deploymentmanager"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DeploymentmanagerDeploymentsInsert_578914 = ref object of OpenApiRestCall_578355
proc url_DeploymentmanagerDeploymentsInsert_578916(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/deployments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerDeploymentsInsert_578915(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a deployment and all of the resources described by the deployment manifest.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_578917 = path.getOrDefault("project")
  valid_578917 = validateParameter(valid_578917, JString, required = true,
                                 default = nil)
  if valid_578917 != nil:
    section.add "project", valid_578917
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   createPolicy: JString
  ##               : Sets the policy to use for creating new resources.
  ##   preview: JBool
  ##          : If set to true, creates a deployment and creates "shell" resources but does not actually instantiate these resources. This allows you to preview what your deployment looks like. After previewing a deployment, you can deploy your resources by making a request with the update() method or you can use the cancelPreview() method to cancel the preview altogether. Note that the deployment will still exist after you cancel the preview and you must separately delete this deployment if you want to remove it.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578918 = query.getOrDefault("key")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "key", valid_578918
  var valid_578919 = query.getOrDefault("prettyPrint")
  valid_578919 = validateParameter(valid_578919, JBool, required = false,
                                 default = newJBool(true))
  if valid_578919 != nil:
    section.add "prettyPrint", valid_578919
  var valid_578920 = query.getOrDefault("oauth_token")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "oauth_token", valid_578920
  var valid_578921 = query.getOrDefault("alt")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = newJString("json"))
  if valid_578921 != nil:
    section.add "alt", valid_578921
  var valid_578922 = query.getOrDefault("userIp")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "userIp", valid_578922
  var valid_578923 = query.getOrDefault("quotaUser")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "quotaUser", valid_578923
  var valid_578924 = query.getOrDefault("createPolicy")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = newJString("CREATE_OR_ACQUIRE"))
  if valid_578924 != nil:
    section.add "createPolicy", valid_578924
  var valid_578925 = query.getOrDefault("preview")
  valid_578925 = validateParameter(valid_578925, JBool, required = false, default = nil)
  if valid_578925 != nil:
    section.add "preview", valid_578925
  var valid_578926 = query.getOrDefault("fields")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = nil)
  if valid_578926 != nil:
    section.add "fields", valid_578926
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_578928: Call_DeploymentmanagerDeploymentsInsert_578914;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a deployment and all of the resources described by the deployment manifest.
  ## 
  let valid = call_578928.validator(path, query, header, formData, body)
  let scheme = call_578928.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578928.url(scheme.get, call_578928.host, call_578928.base,
                         call_578928.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578928, url, valid)

proc call*(call_578929: Call_DeploymentmanagerDeploymentsInsert_578914;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; createPolicy: string = "CREATE_OR_ACQUIRE";
          body: JsonNode = nil; preview: bool = false; fields: string = ""): Recallable =
  ## deploymentmanagerDeploymentsInsert
  ## Creates a deployment and all of the resources described by the deployment manifest.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   createPolicy: string
  ##               : Sets the policy to use for creating new resources.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   body: JObject
  ##   preview: bool
  ##          : If set to true, creates a deployment and creates "shell" resources but does not actually instantiate these resources. This allows you to preview what your deployment looks like. After previewing a deployment, you can deploy your resources by making a request with the update() method or you can use the cancelPreview() method to cancel the preview altogether. Note that the deployment will still exist after you cancel the preview and you must separately delete this deployment if you want to remove it.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578930 = newJObject()
  var query_578931 = newJObject()
  var body_578932 = newJObject()
  add(query_578931, "key", newJString(key))
  add(query_578931, "prettyPrint", newJBool(prettyPrint))
  add(query_578931, "oauth_token", newJString(oauthToken))
  add(query_578931, "alt", newJString(alt))
  add(query_578931, "userIp", newJString(userIp))
  add(query_578931, "quotaUser", newJString(quotaUser))
  add(query_578931, "createPolicy", newJString(createPolicy))
  add(path_578930, "project", newJString(project))
  if body != nil:
    body_578932 = body
  add(query_578931, "preview", newJBool(preview))
  add(query_578931, "fields", newJString(fields))
  result = call_578929.call(path_578930, query_578931, nil, nil, body_578932)

var deploymentmanagerDeploymentsInsert* = Call_DeploymentmanagerDeploymentsInsert_578914(
    name: "deploymentmanagerDeploymentsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{project}/global/deployments",
    validator: validate_DeploymentmanagerDeploymentsInsert_578915,
    base: "/deploymentmanager/v2/projects",
    url: url_DeploymentmanagerDeploymentsInsert_578916, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsList_578625 = ref object of OpenApiRestCall_578355
proc url_DeploymentmanagerDeploymentsList_578627(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/deployments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerDeploymentsList_578626(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all deployments for a given project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_578753 = path.getOrDefault("project")
  valid_578753 = validateParameter(valid_578753, JString, required = true,
                                 default = nil)
  if valid_578753 != nil:
    section.add "project", valid_578753
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   orderBy: JString
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   filter: JString
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  section = newJObject()
  var valid_578754 = query.getOrDefault("key")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "key", valid_578754
  var valid_578768 = query.getOrDefault("prettyPrint")
  valid_578768 = validateParameter(valid_578768, JBool, required = false,
                                 default = newJBool(true))
  if valid_578768 != nil:
    section.add "prettyPrint", valid_578768
  var valid_578769 = query.getOrDefault("oauth_token")
  valid_578769 = validateParameter(valid_578769, JString, required = false,
                                 default = nil)
  if valid_578769 != nil:
    section.add "oauth_token", valid_578769
  var valid_578770 = query.getOrDefault("alt")
  valid_578770 = validateParameter(valid_578770, JString, required = false,
                                 default = newJString("json"))
  if valid_578770 != nil:
    section.add "alt", valid_578770
  var valid_578771 = query.getOrDefault("userIp")
  valid_578771 = validateParameter(valid_578771, JString, required = false,
                                 default = nil)
  if valid_578771 != nil:
    section.add "userIp", valid_578771
  var valid_578772 = query.getOrDefault("quotaUser")
  valid_578772 = validateParameter(valid_578772, JString, required = false,
                                 default = nil)
  if valid_578772 != nil:
    section.add "quotaUser", valid_578772
  var valid_578773 = query.getOrDefault("orderBy")
  valid_578773 = validateParameter(valid_578773, JString, required = false,
                                 default = nil)
  if valid_578773 != nil:
    section.add "orderBy", valid_578773
  var valid_578774 = query.getOrDefault("filter")
  valid_578774 = validateParameter(valid_578774, JString, required = false,
                                 default = nil)
  if valid_578774 != nil:
    section.add "filter", valid_578774
  var valid_578775 = query.getOrDefault("pageToken")
  valid_578775 = validateParameter(valid_578775, JString, required = false,
                                 default = nil)
  if valid_578775 != nil:
    section.add "pageToken", valid_578775
  var valid_578776 = query.getOrDefault("fields")
  valid_578776 = validateParameter(valid_578776, JString, required = false,
                                 default = nil)
  if valid_578776 != nil:
    section.add "fields", valid_578776
  var valid_578778 = query.getOrDefault("maxResults")
  valid_578778 = validateParameter(valid_578778, JInt, required = false,
                                 default = newJInt(500))
  if valid_578778 != nil:
    section.add "maxResults", valid_578778
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578801: Call_DeploymentmanagerDeploymentsList_578625;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all deployments for a given project.
  ## 
  let valid = call_578801.validator(path, query, header, formData, body)
  let scheme = call_578801.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578801.url(scheme.get, call_578801.host, call_578801.base,
                         call_578801.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578801, url, valid)

proc call*(call_578872: Call_DeploymentmanagerDeploymentsList_578625;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; orderBy: string = ""; filter: string = "";
          pageToken: string = ""; fields: string = ""; maxResults: int = 500): Recallable =
  ## deploymentmanagerDeploymentsList
  ## Lists all deployments for a given project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   orderBy: string
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   filter: string
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  ##   pageToken: string
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  var path_578873 = newJObject()
  var query_578875 = newJObject()
  add(query_578875, "key", newJString(key))
  add(query_578875, "prettyPrint", newJBool(prettyPrint))
  add(query_578875, "oauth_token", newJString(oauthToken))
  add(query_578875, "alt", newJString(alt))
  add(query_578875, "userIp", newJString(userIp))
  add(query_578875, "quotaUser", newJString(quotaUser))
  add(query_578875, "orderBy", newJString(orderBy))
  add(query_578875, "filter", newJString(filter))
  add(query_578875, "pageToken", newJString(pageToken))
  add(path_578873, "project", newJString(project))
  add(query_578875, "fields", newJString(fields))
  add(query_578875, "maxResults", newJInt(maxResults))
  result = call_578872.call(path_578873, query_578875, nil, nil, nil)

var deploymentmanagerDeploymentsList* = Call_DeploymentmanagerDeploymentsList_578625(
    name: "deploymentmanagerDeploymentsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/deployments",
    validator: validate_DeploymentmanagerDeploymentsList_578626,
    base: "/deploymentmanager/v2/projects",
    url: url_DeploymentmanagerDeploymentsList_578627, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsUpdate_578949 = ref object of OpenApiRestCall_578355
proc url_DeploymentmanagerDeploymentsUpdate_578951(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "deployment" in path, "`deployment` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/deployments/"),
               (kind: VariableSegment, value: "deployment")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerDeploymentsUpdate_578950(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a deployment and all of the resources described by the deployment manifest.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deployment: JString (required)
  ##             : The name of the deployment for this request.
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deployment` field"
  var valid_578952 = path.getOrDefault("deployment")
  valid_578952 = validateParameter(valid_578952, JString, required = true,
                                 default = nil)
  if valid_578952 != nil:
    section.add "deployment", valid_578952
  var valid_578953 = path.getOrDefault("project")
  valid_578953 = validateParameter(valid_578953, JString, required = true,
                                 default = nil)
  if valid_578953 != nil:
    section.add "project", valid_578953
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   createPolicy: JString
  ##               : Sets the policy to use for creating new resources.
  ##   deletePolicy: JString
  ##               : Sets the policy to use for deleting resources.
  ##   preview: JBool
  ##          : If set to true, updates the deployment and creates and updates the "shell" resources but does not actually alter or instantiate these resources. This allows you to preview what your deployment will look like. You can use this intent to preview how an update would affect your deployment. You must provide a target.config with a configuration if this is set to true. After previewing a deployment, you can deploy your resources by making a request with the update() or you can cancelPreview() to remove the preview altogether. Note that the deployment will still exist after you cancel the preview and you must separately delete this deployment if you want to remove it.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578954 = query.getOrDefault("key")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "key", valid_578954
  var valid_578955 = query.getOrDefault("prettyPrint")
  valid_578955 = validateParameter(valid_578955, JBool, required = false,
                                 default = newJBool(true))
  if valid_578955 != nil:
    section.add "prettyPrint", valid_578955
  var valid_578956 = query.getOrDefault("oauth_token")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "oauth_token", valid_578956
  var valid_578957 = query.getOrDefault("alt")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = newJString("json"))
  if valid_578957 != nil:
    section.add "alt", valid_578957
  var valid_578958 = query.getOrDefault("userIp")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "userIp", valid_578958
  var valid_578959 = query.getOrDefault("quotaUser")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "quotaUser", valid_578959
  var valid_578960 = query.getOrDefault("createPolicy")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = newJString("CREATE_OR_ACQUIRE"))
  if valid_578960 != nil:
    section.add "createPolicy", valid_578960
  var valid_578961 = query.getOrDefault("deletePolicy")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = newJString("DELETE"))
  if valid_578961 != nil:
    section.add "deletePolicy", valid_578961
  var valid_578962 = query.getOrDefault("preview")
  valid_578962 = validateParameter(valid_578962, JBool, required = false,
                                 default = newJBool(false))
  if valid_578962 != nil:
    section.add "preview", valid_578962
  var valid_578963 = query.getOrDefault("fields")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "fields", valid_578963
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_578965: Call_DeploymentmanagerDeploymentsUpdate_578949;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a deployment and all of the resources described by the deployment manifest.
  ## 
  let valid = call_578965.validator(path, query, header, formData, body)
  let scheme = call_578965.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578965.url(scheme.get, call_578965.host, call_578965.base,
                         call_578965.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578965, url, valid)

proc call*(call_578966: Call_DeploymentmanagerDeploymentsUpdate_578949;
          deployment: string; project: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = "";
          createPolicy: string = "CREATE_OR_ACQUIRE";
          deletePolicy: string = "DELETE"; body: JsonNode = nil; preview: bool = false;
          fields: string = ""): Recallable =
  ## deploymentmanagerDeploymentsUpdate
  ## Updates a deployment and all of the resources described by the deployment manifest.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   deployment: string (required)
  ##             : The name of the deployment for this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   createPolicy: string
  ##               : Sets the policy to use for creating new resources.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   deletePolicy: string
  ##               : Sets the policy to use for deleting resources.
  ##   body: JObject
  ##   preview: bool
  ##          : If set to true, updates the deployment and creates and updates the "shell" resources but does not actually alter or instantiate these resources. This allows you to preview what your deployment will look like. You can use this intent to preview how an update would affect your deployment. You must provide a target.config with a configuration if this is set to true. After previewing a deployment, you can deploy your resources by making a request with the update() or you can cancelPreview() to remove the preview altogether. Note that the deployment will still exist after you cancel the preview and you must separately delete this deployment if you want to remove it.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578967 = newJObject()
  var query_578968 = newJObject()
  var body_578969 = newJObject()
  add(query_578968, "key", newJString(key))
  add(query_578968, "prettyPrint", newJBool(prettyPrint))
  add(query_578968, "oauth_token", newJString(oauthToken))
  add(path_578967, "deployment", newJString(deployment))
  add(query_578968, "alt", newJString(alt))
  add(query_578968, "userIp", newJString(userIp))
  add(query_578968, "quotaUser", newJString(quotaUser))
  add(query_578968, "createPolicy", newJString(createPolicy))
  add(path_578967, "project", newJString(project))
  add(query_578968, "deletePolicy", newJString(deletePolicy))
  if body != nil:
    body_578969 = body
  add(query_578968, "preview", newJBool(preview))
  add(query_578968, "fields", newJString(fields))
  result = call_578966.call(path_578967, query_578968, nil, nil, body_578969)

var deploymentmanagerDeploymentsUpdate* = Call_DeploymentmanagerDeploymentsUpdate_578949(
    name: "deploymentmanagerDeploymentsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}",
    validator: validate_DeploymentmanagerDeploymentsUpdate_578950,
    base: "/deploymentmanager/v2/projects",
    url: url_DeploymentmanagerDeploymentsUpdate_578951, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsGet_578933 = ref object of OpenApiRestCall_578355
proc url_DeploymentmanagerDeploymentsGet_578935(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "deployment" in path, "`deployment` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/deployments/"),
               (kind: VariableSegment, value: "deployment")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerDeploymentsGet_578934(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about a specific deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deployment: JString (required)
  ##             : The name of the deployment for this request.
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deployment` field"
  var valid_578936 = path.getOrDefault("deployment")
  valid_578936 = validateParameter(valid_578936, JString, required = true,
                                 default = nil)
  if valid_578936 != nil:
    section.add "deployment", valid_578936
  var valid_578937 = path.getOrDefault("project")
  valid_578937 = validateParameter(valid_578937, JString, required = true,
                                 default = nil)
  if valid_578937 != nil:
    section.add "project", valid_578937
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578938 = query.getOrDefault("key")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "key", valid_578938
  var valid_578939 = query.getOrDefault("prettyPrint")
  valid_578939 = validateParameter(valid_578939, JBool, required = false,
                                 default = newJBool(true))
  if valid_578939 != nil:
    section.add "prettyPrint", valid_578939
  var valid_578940 = query.getOrDefault("oauth_token")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "oauth_token", valid_578940
  var valid_578941 = query.getOrDefault("alt")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = newJString("json"))
  if valid_578941 != nil:
    section.add "alt", valid_578941
  var valid_578942 = query.getOrDefault("userIp")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "userIp", valid_578942
  var valid_578943 = query.getOrDefault("quotaUser")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "quotaUser", valid_578943
  var valid_578944 = query.getOrDefault("fields")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "fields", valid_578944
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578945: Call_DeploymentmanagerDeploymentsGet_578933;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information about a specific deployment.
  ## 
  let valid = call_578945.validator(path, query, header, formData, body)
  let scheme = call_578945.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578945.url(scheme.get, call_578945.host, call_578945.base,
                         call_578945.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578945, url, valid)

proc call*(call_578946: Call_DeploymentmanagerDeploymentsGet_578933;
          deployment: string; project: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## deploymentmanagerDeploymentsGet
  ## Gets information about a specific deployment.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   deployment: string (required)
  ##             : The name of the deployment for this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578947 = newJObject()
  var query_578948 = newJObject()
  add(query_578948, "key", newJString(key))
  add(query_578948, "prettyPrint", newJBool(prettyPrint))
  add(query_578948, "oauth_token", newJString(oauthToken))
  add(path_578947, "deployment", newJString(deployment))
  add(query_578948, "alt", newJString(alt))
  add(query_578948, "userIp", newJString(userIp))
  add(query_578948, "quotaUser", newJString(quotaUser))
  add(path_578947, "project", newJString(project))
  add(query_578948, "fields", newJString(fields))
  result = call_578946.call(path_578947, query_578948, nil, nil, nil)

var deploymentmanagerDeploymentsGet* = Call_DeploymentmanagerDeploymentsGet_578933(
    name: "deploymentmanagerDeploymentsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}",
    validator: validate_DeploymentmanagerDeploymentsGet_578934,
    base: "/deploymentmanager/v2/projects",
    url: url_DeploymentmanagerDeploymentsGet_578935, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsPatch_578987 = ref object of OpenApiRestCall_578355
proc url_DeploymentmanagerDeploymentsPatch_578989(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "deployment" in path, "`deployment` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/deployments/"),
               (kind: VariableSegment, value: "deployment")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerDeploymentsPatch_578988(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a deployment and all of the resources described by the deployment manifest. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deployment: JString (required)
  ##             : The name of the deployment for this request.
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deployment` field"
  var valid_578990 = path.getOrDefault("deployment")
  valid_578990 = validateParameter(valid_578990, JString, required = true,
                                 default = nil)
  if valid_578990 != nil:
    section.add "deployment", valid_578990
  var valid_578991 = path.getOrDefault("project")
  valid_578991 = validateParameter(valid_578991, JString, required = true,
                                 default = nil)
  if valid_578991 != nil:
    section.add "project", valid_578991
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   createPolicy: JString
  ##               : Sets the policy to use for creating new resources.
  ##   deletePolicy: JString
  ##               : Sets the policy to use for deleting resources.
  ##   preview: JBool
  ##          : If set to true, updates the deployment and creates and updates the "shell" resources but does not actually alter or instantiate these resources. This allows you to preview what your deployment will look like. You can use this intent to preview how an update would affect your deployment. You must provide a target.config with a configuration if this is set to true. After previewing a deployment, you can deploy your resources by making a request with the update() or you can cancelPreview() to remove the preview altogether. Note that the deployment will still exist after you cancel the preview and you must separately delete this deployment if you want to remove it.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578992 = query.getOrDefault("key")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "key", valid_578992
  var valid_578993 = query.getOrDefault("prettyPrint")
  valid_578993 = validateParameter(valid_578993, JBool, required = false,
                                 default = newJBool(true))
  if valid_578993 != nil:
    section.add "prettyPrint", valid_578993
  var valid_578994 = query.getOrDefault("oauth_token")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "oauth_token", valid_578994
  var valid_578995 = query.getOrDefault("alt")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = newJString("json"))
  if valid_578995 != nil:
    section.add "alt", valid_578995
  var valid_578996 = query.getOrDefault("userIp")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "userIp", valid_578996
  var valid_578997 = query.getOrDefault("quotaUser")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = nil)
  if valid_578997 != nil:
    section.add "quotaUser", valid_578997
  var valid_578998 = query.getOrDefault("createPolicy")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = newJString("CREATE_OR_ACQUIRE"))
  if valid_578998 != nil:
    section.add "createPolicy", valid_578998
  var valid_578999 = query.getOrDefault("deletePolicy")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = newJString("DELETE"))
  if valid_578999 != nil:
    section.add "deletePolicy", valid_578999
  var valid_579000 = query.getOrDefault("preview")
  valid_579000 = validateParameter(valid_579000, JBool, required = false,
                                 default = newJBool(false))
  if valid_579000 != nil:
    section.add "preview", valid_579000
  var valid_579001 = query.getOrDefault("fields")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "fields", valid_579001
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579003: Call_DeploymentmanagerDeploymentsPatch_578987;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a deployment and all of the resources described by the deployment manifest. This method supports patch semantics.
  ## 
  let valid = call_579003.validator(path, query, header, formData, body)
  let scheme = call_579003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579003.url(scheme.get, call_579003.host, call_579003.base,
                         call_579003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579003, url, valid)

proc call*(call_579004: Call_DeploymentmanagerDeploymentsPatch_578987;
          deployment: string; project: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = "";
          createPolicy: string = "CREATE_OR_ACQUIRE";
          deletePolicy: string = "DELETE"; body: JsonNode = nil; preview: bool = false;
          fields: string = ""): Recallable =
  ## deploymentmanagerDeploymentsPatch
  ## Updates a deployment and all of the resources described by the deployment manifest. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   deployment: string (required)
  ##             : The name of the deployment for this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   createPolicy: string
  ##               : Sets the policy to use for creating new resources.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   deletePolicy: string
  ##               : Sets the policy to use for deleting resources.
  ##   body: JObject
  ##   preview: bool
  ##          : If set to true, updates the deployment and creates and updates the "shell" resources but does not actually alter or instantiate these resources. This allows you to preview what your deployment will look like. You can use this intent to preview how an update would affect your deployment. You must provide a target.config with a configuration if this is set to true. After previewing a deployment, you can deploy your resources by making a request with the update() or you can cancelPreview() to remove the preview altogether. Note that the deployment will still exist after you cancel the preview and you must separately delete this deployment if you want to remove it.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579005 = newJObject()
  var query_579006 = newJObject()
  var body_579007 = newJObject()
  add(query_579006, "key", newJString(key))
  add(query_579006, "prettyPrint", newJBool(prettyPrint))
  add(query_579006, "oauth_token", newJString(oauthToken))
  add(path_579005, "deployment", newJString(deployment))
  add(query_579006, "alt", newJString(alt))
  add(query_579006, "userIp", newJString(userIp))
  add(query_579006, "quotaUser", newJString(quotaUser))
  add(query_579006, "createPolicy", newJString(createPolicy))
  add(path_579005, "project", newJString(project))
  add(query_579006, "deletePolicy", newJString(deletePolicy))
  if body != nil:
    body_579007 = body
  add(query_579006, "preview", newJBool(preview))
  add(query_579006, "fields", newJString(fields))
  result = call_579004.call(path_579005, query_579006, nil, nil, body_579007)

var deploymentmanagerDeploymentsPatch* = Call_DeploymentmanagerDeploymentsPatch_578987(
    name: "deploymentmanagerDeploymentsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}",
    validator: validate_DeploymentmanagerDeploymentsPatch_578988,
    base: "/deploymentmanager/v2/projects",
    url: url_DeploymentmanagerDeploymentsPatch_578989, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsDelete_578970 = ref object of OpenApiRestCall_578355
proc url_DeploymentmanagerDeploymentsDelete_578972(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "deployment" in path, "`deployment` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/deployments/"),
               (kind: VariableSegment, value: "deployment")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerDeploymentsDelete_578971(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a deployment and all of the resources in the deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deployment: JString (required)
  ##             : The name of the deployment for this request.
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deployment` field"
  var valid_578973 = path.getOrDefault("deployment")
  valid_578973 = validateParameter(valid_578973, JString, required = true,
                                 default = nil)
  if valid_578973 != nil:
    section.add "deployment", valid_578973
  var valid_578974 = path.getOrDefault("project")
  valid_578974 = validateParameter(valid_578974, JString, required = true,
                                 default = nil)
  if valid_578974 != nil:
    section.add "project", valid_578974
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   deletePolicy: JString
  ##               : Sets the policy to use for deleting resources.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578975 = query.getOrDefault("key")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "key", valid_578975
  var valid_578976 = query.getOrDefault("prettyPrint")
  valid_578976 = validateParameter(valid_578976, JBool, required = false,
                                 default = newJBool(true))
  if valid_578976 != nil:
    section.add "prettyPrint", valid_578976
  var valid_578977 = query.getOrDefault("oauth_token")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = nil)
  if valid_578977 != nil:
    section.add "oauth_token", valid_578977
  var valid_578978 = query.getOrDefault("alt")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = newJString("json"))
  if valid_578978 != nil:
    section.add "alt", valid_578978
  var valid_578979 = query.getOrDefault("userIp")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = nil)
  if valid_578979 != nil:
    section.add "userIp", valid_578979
  var valid_578980 = query.getOrDefault("quotaUser")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = nil)
  if valid_578980 != nil:
    section.add "quotaUser", valid_578980
  var valid_578981 = query.getOrDefault("deletePolicy")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = newJString("DELETE"))
  if valid_578981 != nil:
    section.add "deletePolicy", valid_578981
  var valid_578982 = query.getOrDefault("fields")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = nil)
  if valid_578982 != nil:
    section.add "fields", valid_578982
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578983: Call_DeploymentmanagerDeploymentsDelete_578970;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a deployment and all of the resources in the deployment.
  ## 
  let valid = call_578983.validator(path, query, header, formData, body)
  let scheme = call_578983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578983.url(scheme.get, call_578983.host, call_578983.base,
                         call_578983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578983, url, valid)

proc call*(call_578984: Call_DeploymentmanagerDeploymentsDelete_578970;
          deployment: string; project: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; deletePolicy: string = "DELETE";
          fields: string = ""): Recallable =
  ## deploymentmanagerDeploymentsDelete
  ## Deletes a deployment and all of the resources in the deployment.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   deployment: string (required)
  ##             : The name of the deployment for this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   deletePolicy: string
  ##               : Sets the policy to use for deleting resources.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578985 = newJObject()
  var query_578986 = newJObject()
  add(query_578986, "key", newJString(key))
  add(query_578986, "prettyPrint", newJBool(prettyPrint))
  add(query_578986, "oauth_token", newJString(oauthToken))
  add(path_578985, "deployment", newJString(deployment))
  add(query_578986, "alt", newJString(alt))
  add(query_578986, "userIp", newJString(userIp))
  add(query_578986, "quotaUser", newJString(quotaUser))
  add(path_578985, "project", newJString(project))
  add(query_578986, "deletePolicy", newJString(deletePolicy))
  add(query_578986, "fields", newJString(fields))
  result = call_578984.call(path_578985, query_578986, nil, nil, nil)

var deploymentmanagerDeploymentsDelete* = Call_DeploymentmanagerDeploymentsDelete_578970(
    name: "deploymentmanagerDeploymentsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}",
    validator: validate_DeploymentmanagerDeploymentsDelete_578971,
    base: "/deploymentmanager/v2/projects",
    url: url_DeploymentmanagerDeploymentsDelete_578972, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsCancelPreview_579008 = ref object of OpenApiRestCall_578355
proc url_DeploymentmanagerDeploymentsCancelPreview_579010(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "deployment" in path, "`deployment` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/deployments/"),
               (kind: VariableSegment, value: "deployment"),
               (kind: ConstantSegment, value: "/cancelPreview")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerDeploymentsCancelPreview_579009(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels and removes the preview currently associated with the deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deployment: JString (required)
  ##             : The name of the deployment for this request.
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deployment` field"
  var valid_579011 = path.getOrDefault("deployment")
  valid_579011 = validateParameter(valid_579011, JString, required = true,
                                 default = nil)
  if valid_579011 != nil:
    section.add "deployment", valid_579011
  var valid_579012 = path.getOrDefault("project")
  valid_579012 = validateParameter(valid_579012, JString, required = true,
                                 default = nil)
  if valid_579012 != nil:
    section.add "project", valid_579012
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579013 = query.getOrDefault("key")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "key", valid_579013
  var valid_579014 = query.getOrDefault("prettyPrint")
  valid_579014 = validateParameter(valid_579014, JBool, required = false,
                                 default = newJBool(true))
  if valid_579014 != nil:
    section.add "prettyPrint", valid_579014
  var valid_579015 = query.getOrDefault("oauth_token")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "oauth_token", valid_579015
  var valid_579016 = query.getOrDefault("alt")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = newJString("json"))
  if valid_579016 != nil:
    section.add "alt", valid_579016
  var valid_579017 = query.getOrDefault("userIp")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "userIp", valid_579017
  var valid_579018 = query.getOrDefault("quotaUser")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "quotaUser", valid_579018
  var valid_579019 = query.getOrDefault("fields")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "fields", valid_579019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579021: Call_DeploymentmanagerDeploymentsCancelPreview_579008;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels and removes the preview currently associated with the deployment.
  ## 
  let valid = call_579021.validator(path, query, header, formData, body)
  let scheme = call_579021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579021.url(scheme.get, call_579021.host, call_579021.base,
                         call_579021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579021, url, valid)

proc call*(call_579022: Call_DeploymentmanagerDeploymentsCancelPreview_579008;
          deployment: string; project: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## deploymentmanagerDeploymentsCancelPreview
  ## Cancels and removes the preview currently associated with the deployment.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   deployment: string (required)
  ##             : The name of the deployment for this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579023 = newJObject()
  var query_579024 = newJObject()
  var body_579025 = newJObject()
  add(query_579024, "key", newJString(key))
  add(query_579024, "prettyPrint", newJBool(prettyPrint))
  add(query_579024, "oauth_token", newJString(oauthToken))
  add(path_579023, "deployment", newJString(deployment))
  add(query_579024, "alt", newJString(alt))
  add(query_579024, "userIp", newJString(userIp))
  add(query_579024, "quotaUser", newJString(quotaUser))
  add(path_579023, "project", newJString(project))
  if body != nil:
    body_579025 = body
  add(query_579024, "fields", newJString(fields))
  result = call_579022.call(path_579023, query_579024, nil, nil, body_579025)

var deploymentmanagerDeploymentsCancelPreview* = Call_DeploymentmanagerDeploymentsCancelPreview_579008(
    name: "deploymentmanagerDeploymentsCancelPreview", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}/cancelPreview",
    validator: validate_DeploymentmanagerDeploymentsCancelPreview_579009,
    base: "/deploymentmanager/v2/projects",
    url: url_DeploymentmanagerDeploymentsCancelPreview_579010,
    schemes: {Scheme.Https})
type
  Call_DeploymentmanagerManifestsList_579026 = ref object of OpenApiRestCall_578355
proc url_DeploymentmanagerManifestsList_579028(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "deployment" in path, "`deployment` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/deployments/"),
               (kind: VariableSegment, value: "deployment"),
               (kind: ConstantSegment, value: "/manifests")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerManifestsList_579027(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all manifests for a given deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deployment: JString (required)
  ##             : The name of the deployment for this request.
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deployment` field"
  var valid_579029 = path.getOrDefault("deployment")
  valid_579029 = validateParameter(valid_579029, JString, required = true,
                                 default = nil)
  if valid_579029 != nil:
    section.add "deployment", valid_579029
  var valid_579030 = path.getOrDefault("project")
  valid_579030 = validateParameter(valid_579030, JString, required = true,
                                 default = nil)
  if valid_579030 != nil:
    section.add "project", valid_579030
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   orderBy: JString
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   filter: JString
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  section = newJObject()
  var valid_579031 = query.getOrDefault("key")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = nil)
  if valid_579031 != nil:
    section.add "key", valid_579031
  var valid_579032 = query.getOrDefault("prettyPrint")
  valid_579032 = validateParameter(valid_579032, JBool, required = false,
                                 default = newJBool(true))
  if valid_579032 != nil:
    section.add "prettyPrint", valid_579032
  var valid_579033 = query.getOrDefault("oauth_token")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = nil)
  if valid_579033 != nil:
    section.add "oauth_token", valid_579033
  var valid_579034 = query.getOrDefault("alt")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = newJString("json"))
  if valid_579034 != nil:
    section.add "alt", valid_579034
  var valid_579035 = query.getOrDefault("userIp")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "userIp", valid_579035
  var valid_579036 = query.getOrDefault("quotaUser")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "quotaUser", valid_579036
  var valid_579037 = query.getOrDefault("orderBy")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "orderBy", valid_579037
  var valid_579038 = query.getOrDefault("filter")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = nil)
  if valid_579038 != nil:
    section.add "filter", valid_579038
  var valid_579039 = query.getOrDefault("pageToken")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "pageToken", valid_579039
  var valid_579040 = query.getOrDefault("fields")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "fields", valid_579040
  var valid_579041 = query.getOrDefault("maxResults")
  valid_579041 = validateParameter(valid_579041, JInt, required = false,
                                 default = newJInt(500))
  if valid_579041 != nil:
    section.add "maxResults", valid_579041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579042: Call_DeploymentmanagerManifestsList_579026; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all manifests for a given deployment.
  ## 
  let valid = call_579042.validator(path, query, header, formData, body)
  let scheme = call_579042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579042.url(scheme.get, call_579042.host, call_579042.base,
                         call_579042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579042, url, valid)

proc call*(call_579043: Call_DeploymentmanagerManifestsList_579026;
          deployment: string; project: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; orderBy: string = "";
          filter: string = ""; pageToken: string = ""; fields: string = "";
          maxResults: int = 500): Recallable =
  ## deploymentmanagerManifestsList
  ## Lists all manifests for a given deployment.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   deployment: string (required)
  ##             : The name of the deployment for this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   orderBy: string
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   filter: string
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  ##   pageToken: string
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  var path_579044 = newJObject()
  var query_579045 = newJObject()
  add(query_579045, "key", newJString(key))
  add(query_579045, "prettyPrint", newJBool(prettyPrint))
  add(query_579045, "oauth_token", newJString(oauthToken))
  add(path_579044, "deployment", newJString(deployment))
  add(query_579045, "alt", newJString(alt))
  add(query_579045, "userIp", newJString(userIp))
  add(query_579045, "quotaUser", newJString(quotaUser))
  add(query_579045, "orderBy", newJString(orderBy))
  add(query_579045, "filter", newJString(filter))
  add(query_579045, "pageToken", newJString(pageToken))
  add(path_579044, "project", newJString(project))
  add(query_579045, "fields", newJString(fields))
  add(query_579045, "maxResults", newJInt(maxResults))
  result = call_579043.call(path_579044, query_579045, nil, nil, nil)

var deploymentmanagerManifestsList* = Call_DeploymentmanagerManifestsList_579026(
    name: "deploymentmanagerManifestsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}/manifests",
    validator: validate_DeploymentmanagerManifestsList_579027,
    base: "/deploymentmanager/v2/projects",
    url: url_DeploymentmanagerManifestsList_579028, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerManifestsGet_579046 = ref object of OpenApiRestCall_578355
proc url_DeploymentmanagerManifestsGet_579048(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "deployment" in path, "`deployment` is a required path parameter"
  assert "manifest" in path, "`manifest` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/deployments/"),
               (kind: VariableSegment, value: "deployment"),
               (kind: ConstantSegment, value: "/manifests/"),
               (kind: VariableSegment, value: "manifest")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerManifestsGet_579047(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about a specific manifest.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deployment: JString (required)
  ##             : The name of the deployment for this request.
  ##   project: JString (required)
  ##          : The project ID for this request.
  ##   manifest: JString (required)
  ##           : The name of the manifest for this request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deployment` field"
  var valid_579049 = path.getOrDefault("deployment")
  valid_579049 = validateParameter(valid_579049, JString, required = true,
                                 default = nil)
  if valid_579049 != nil:
    section.add "deployment", valid_579049
  var valid_579050 = path.getOrDefault("project")
  valid_579050 = validateParameter(valid_579050, JString, required = true,
                                 default = nil)
  if valid_579050 != nil:
    section.add "project", valid_579050
  var valid_579051 = path.getOrDefault("manifest")
  valid_579051 = validateParameter(valid_579051, JString, required = true,
                                 default = nil)
  if valid_579051 != nil:
    section.add "manifest", valid_579051
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579052 = query.getOrDefault("key")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = nil)
  if valid_579052 != nil:
    section.add "key", valid_579052
  var valid_579053 = query.getOrDefault("prettyPrint")
  valid_579053 = validateParameter(valid_579053, JBool, required = false,
                                 default = newJBool(true))
  if valid_579053 != nil:
    section.add "prettyPrint", valid_579053
  var valid_579054 = query.getOrDefault("oauth_token")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = nil)
  if valid_579054 != nil:
    section.add "oauth_token", valid_579054
  var valid_579055 = query.getOrDefault("alt")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = newJString("json"))
  if valid_579055 != nil:
    section.add "alt", valid_579055
  var valid_579056 = query.getOrDefault("userIp")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "userIp", valid_579056
  var valid_579057 = query.getOrDefault("quotaUser")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = nil)
  if valid_579057 != nil:
    section.add "quotaUser", valid_579057
  var valid_579058 = query.getOrDefault("fields")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "fields", valid_579058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579059: Call_DeploymentmanagerManifestsGet_579046; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a specific manifest.
  ## 
  let valid = call_579059.validator(path, query, header, formData, body)
  let scheme = call_579059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579059.url(scheme.get, call_579059.host, call_579059.base,
                         call_579059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579059, url, valid)

proc call*(call_579060: Call_DeploymentmanagerManifestsGet_579046;
          deployment: string; project: string; manifest: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## deploymentmanagerManifestsGet
  ## Gets information about a specific manifest.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   deployment: string (required)
  ##             : The name of the deployment for this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   manifest: string (required)
  ##           : The name of the manifest for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579061 = newJObject()
  var query_579062 = newJObject()
  add(query_579062, "key", newJString(key))
  add(query_579062, "prettyPrint", newJBool(prettyPrint))
  add(query_579062, "oauth_token", newJString(oauthToken))
  add(path_579061, "deployment", newJString(deployment))
  add(query_579062, "alt", newJString(alt))
  add(query_579062, "userIp", newJString(userIp))
  add(query_579062, "quotaUser", newJString(quotaUser))
  add(path_579061, "project", newJString(project))
  add(path_579061, "manifest", newJString(manifest))
  add(query_579062, "fields", newJString(fields))
  result = call_579060.call(path_579061, query_579062, nil, nil, nil)

var deploymentmanagerManifestsGet* = Call_DeploymentmanagerManifestsGet_579046(
    name: "deploymentmanagerManifestsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}/manifests/{manifest}",
    validator: validate_DeploymentmanagerManifestsGet_579047,
    base: "/deploymentmanager/v2/projects",
    url: url_DeploymentmanagerManifestsGet_579048, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerResourcesList_579063 = ref object of OpenApiRestCall_578355
proc url_DeploymentmanagerResourcesList_579065(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "deployment" in path, "`deployment` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/deployments/"),
               (kind: VariableSegment, value: "deployment"),
               (kind: ConstantSegment, value: "/resources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerResourcesList_579064(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all resources in a given deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deployment: JString (required)
  ##             : The name of the deployment for this request.
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deployment` field"
  var valid_579066 = path.getOrDefault("deployment")
  valid_579066 = validateParameter(valid_579066, JString, required = true,
                                 default = nil)
  if valid_579066 != nil:
    section.add "deployment", valid_579066
  var valid_579067 = path.getOrDefault("project")
  valid_579067 = validateParameter(valid_579067, JString, required = true,
                                 default = nil)
  if valid_579067 != nil:
    section.add "project", valid_579067
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   orderBy: JString
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   filter: JString
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  section = newJObject()
  var valid_579068 = query.getOrDefault("key")
  valid_579068 = validateParameter(valid_579068, JString, required = false,
                                 default = nil)
  if valid_579068 != nil:
    section.add "key", valid_579068
  var valid_579069 = query.getOrDefault("prettyPrint")
  valid_579069 = validateParameter(valid_579069, JBool, required = false,
                                 default = newJBool(true))
  if valid_579069 != nil:
    section.add "prettyPrint", valid_579069
  var valid_579070 = query.getOrDefault("oauth_token")
  valid_579070 = validateParameter(valid_579070, JString, required = false,
                                 default = nil)
  if valid_579070 != nil:
    section.add "oauth_token", valid_579070
  var valid_579071 = query.getOrDefault("alt")
  valid_579071 = validateParameter(valid_579071, JString, required = false,
                                 default = newJString("json"))
  if valid_579071 != nil:
    section.add "alt", valid_579071
  var valid_579072 = query.getOrDefault("userIp")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = nil)
  if valid_579072 != nil:
    section.add "userIp", valid_579072
  var valid_579073 = query.getOrDefault("quotaUser")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = nil)
  if valid_579073 != nil:
    section.add "quotaUser", valid_579073
  var valid_579074 = query.getOrDefault("orderBy")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = nil)
  if valid_579074 != nil:
    section.add "orderBy", valid_579074
  var valid_579075 = query.getOrDefault("filter")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = nil)
  if valid_579075 != nil:
    section.add "filter", valid_579075
  var valid_579076 = query.getOrDefault("pageToken")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = nil)
  if valid_579076 != nil:
    section.add "pageToken", valid_579076
  var valid_579077 = query.getOrDefault("fields")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "fields", valid_579077
  var valid_579078 = query.getOrDefault("maxResults")
  valid_579078 = validateParameter(valid_579078, JInt, required = false,
                                 default = newJInt(500))
  if valid_579078 != nil:
    section.add "maxResults", valid_579078
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579079: Call_DeploymentmanagerResourcesList_579063; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all resources in a given deployment.
  ## 
  let valid = call_579079.validator(path, query, header, formData, body)
  let scheme = call_579079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579079.url(scheme.get, call_579079.host, call_579079.base,
                         call_579079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579079, url, valid)

proc call*(call_579080: Call_DeploymentmanagerResourcesList_579063;
          deployment: string; project: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; orderBy: string = "";
          filter: string = ""; pageToken: string = ""; fields: string = "";
          maxResults: int = 500): Recallable =
  ## deploymentmanagerResourcesList
  ## Lists all resources in a given deployment.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   deployment: string (required)
  ##             : The name of the deployment for this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   orderBy: string
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   filter: string
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  ##   pageToken: string
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  var path_579081 = newJObject()
  var query_579082 = newJObject()
  add(query_579082, "key", newJString(key))
  add(query_579082, "prettyPrint", newJBool(prettyPrint))
  add(query_579082, "oauth_token", newJString(oauthToken))
  add(path_579081, "deployment", newJString(deployment))
  add(query_579082, "alt", newJString(alt))
  add(query_579082, "userIp", newJString(userIp))
  add(query_579082, "quotaUser", newJString(quotaUser))
  add(query_579082, "orderBy", newJString(orderBy))
  add(query_579082, "filter", newJString(filter))
  add(query_579082, "pageToken", newJString(pageToken))
  add(path_579081, "project", newJString(project))
  add(query_579082, "fields", newJString(fields))
  add(query_579082, "maxResults", newJInt(maxResults))
  result = call_579080.call(path_579081, query_579082, nil, nil, nil)

var deploymentmanagerResourcesList* = Call_DeploymentmanagerResourcesList_579063(
    name: "deploymentmanagerResourcesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}/resources",
    validator: validate_DeploymentmanagerResourcesList_579064,
    base: "/deploymentmanager/v2/projects",
    url: url_DeploymentmanagerResourcesList_579065, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerResourcesGet_579083 = ref object of OpenApiRestCall_578355
proc url_DeploymentmanagerResourcesGet_579085(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "deployment" in path, "`deployment` is a required path parameter"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/deployments/"),
               (kind: VariableSegment, value: "deployment"),
               (kind: ConstantSegment, value: "/resources/"),
               (kind: VariableSegment, value: "resource")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerResourcesGet_579084(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about a single resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deployment: JString (required)
  ##             : The name of the deployment for this request.
  ##   resource: JString (required)
  ##           : The name of the resource for this request.
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deployment` field"
  var valid_579086 = path.getOrDefault("deployment")
  valid_579086 = validateParameter(valid_579086, JString, required = true,
                                 default = nil)
  if valid_579086 != nil:
    section.add "deployment", valid_579086
  var valid_579087 = path.getOrDefault("resource")
  valid_579087 = validateParameter(valid_579087, JString, required = true,
                                 default = nil)
  if valid_579087 != nil:
    section.add "resource", valid_579087
  var valid_579088 = path.getOrDefault("project")
  valid_579088 = validateParameter(valid_579088, JString, required = true,
                                 default = nil)
  if valid_579088 != nil:
    section.add "project", valid_579088
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579089 = query.getOrDefault("key")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = nil)
  if valid_579089 != nil:
    section.add "key", valid_579089
  var valid_579090 = query.getOrDefault("prettyPrint")
  valid_579090 = validateParameter(valid_579090, JBool, required = false,
                                 default = newJBool(true))
  if valid_579090 != nil:
    section.add "prettyPrint", valid_579090
  var valid_579091 = query.getOrDefault("oauth_token")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = nil)
  if valid_579091 != nil:
    section.add "oauth_token", valid_579091
  var valid_579092 = query.getOrDefault("alt")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = newJString("json"))
  if valid_579092 != nil:
    section.add "alt", valid_579092
  var valid_579093 = query.getOrDefault("userIp")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "userIp", valid_579093
  var valid_579094 = query.getOrDefault("quotaUser")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = nil)
  if valid_579094 != nil:
    section.add "quotaUser", valid_579094
  var valid_579095 = query.getOrDefault("fields")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "fields", valid_579095
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579096: Call_DeploymentmanagerResourcesGet_579083; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a single resource.
  ## 
  let valid = call_579096.validator(path, query, header, formData, body)
  let scheme = call_579096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579096.url(scheme.get, call_579096.host, call_579096.base,
                         call_579096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579096, url, valid)

proc call*(call_579097: Call_DeploymentmanagerResourcesGet_579083;
          deployment: string; resource: string; project: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## deploymentmanagerResourcesGet
  ## Gets information about a single resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   deployment: string (required)
  ##             : The name of the deployment for this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   resource: string (required)
  ##           : The name of the resource for this request.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579098 = newJObject()
  var query_579099 = newJObject()
  add(query_579099, "key", newJString(key))
  add(query_579099, "prettyPrint", newJBool(prettyPrint))
  add(query_579099, "oauth_token", newJString(oauthToken))
  add(path_579098, "deployment", newJString(deployment))
  add(query_579099, "alt", newJString(alt))
  add(query_579099, "userIp", newJString(userIp))
  add(query_579099, "quotaUser", newJString(quotaUser))
  add(path_579098, "resource", newJString(resource))
  add(path_579098, "project", newJString(project))
  add(query_579099, "fields", newJString(fields))
  result = call_579097.call(path_579098, query_579099, nil, nil, nil)

var deploymentmanagerResourcesGet* = Call_DeploymentmanagerResourcesGet_579083(
    name: "deploymentmanagerResourcesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}/resources/{resource}",
    validator: validate_DeploymentmanagerResourcesGet_579084,
    base: "/deploymentmanager/v2/projects",
    url: url_DeploymentmanagerResourcesGet_579085, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsStop_579100 = ref object of OpenApiRestCall_578355
proc url_DeploymentmanagerDeploymentsStop_579102(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "deployment" in path, "`deployment` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/deployments/"),
               (kind: VariableSegment, value: "deployment"),
               (kind: ConstantSegment, value: "/stop")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerDeploymentsStop_579101(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Stops an ongoing operation. This does not roll back any work that has already been completed, but prevents any new work from being started.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deployment: JString (required)
  ##             : The name of the deployment for this request.
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deployment` field"
  var valid_579103 = path.getOrDefault("deployment")
  valid_579103 = validateParameter(valid_579103, JString, required = true,
                                 default = nil)
  if valid_579103 != nil:
    section.add "deployment", valid_579103
  var valid_579104 = path.getOrDefault("project")
  valid_579104 = validateParameter(valid_579104, JString, required = true,
                                 default = nil)
  if valid_579104 != nil:
    section.add "project", valid_579104
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579105 = query.getOrDefault("key")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = nil)
  if valid_579105 != nil:
    section.add "key", valid_579105
  var valid_579106 = query.getOrDefault("prettyPrint")
  valid_579106 = validateParameter(valid_579106, JBool, required = false,
                                 default = newJBool(true))
  if valid_579106 != nil:
    section.add "prettyPrint", valid_579106
  var valid_579107 = query.getOrDefault("oauth_token")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "oauth_token", valid_579107
  var valid_579108 = query.getOrDefault("alt")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = newJString("json"))
  if valid_579108 != nil:
    section.add "alt", valid_579108
  var valid_579109 = query.getOrDefault("userIp")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "userIp", valid_579109
  var valid_579110 = query.getOrDefault("quotaUser")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = nil)
  if valid_579110 != nil:
    section.add "quotaUser", valid_579110
  var valid_579111 = query.getOrDefault("fields")
  valid_579111 = validateParameter(valid_579111, JString, required = false,
                                 default = nil)
  if valid_579111 != nil:
    section.add "fields", valid_579111
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579113: Call_DeploymentmanagerDeploymentsStop_579100;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Stops an ongoing operation. This does not roll back any work that has already been completed, but prevents any new work from being started.
  ## 
  let valid = call_579113.validator(path, query, header, formData, body)
  let scheme = call_579113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579113.url(scheme.get, call_579113.host, call_579113.base,
                         call_579113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579113, url, valid)

proc call*(call_579114: Call_DeploymentmanagerDeploymentsStop_579100;
          deployment: string; project: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## deploymentmanagerDeploymentsStop
  ## Stops an ongoing operation. This does not roll back any work that has already been completed, but prevents any new work from being started.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   deployment: string (required)
  ##             : The name of the deployment for this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579115 = newJObject()
  var query_579116 = newJObject()
  var body_579117 = newJObject()
  add(query_579116, "key", newJString(key))
  add(query_579116, "prettyPrint", newJBool(prettyPrint))
  add(query_579116, "oauth_token", newJString(oauthToken))
  add(path_579115, "deployment", newJString(deployment))
  add(query_579116, "alt", newJString(alt))
  add(query_579116, "userIp", newJString(userIp))
  add(query_579116, "quotaUser", newJString(quotaUser))
  add(path_579115, "project", newJString(project))
  if body != nil:
    body_579117 = body
  add(query_579116, "fields", newJString(fields))
  result = call_579114.call(path_579115, query_579116, nil, nil, body_579117)

var deploymentmanagerDeploymentsStop* = Call_DeploymentmanagerDeploymentsStop_579100(
    name: "deploymentmanagerDeploymentsStop", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}/stop",
    validator: validate_DeploymentmanagerDeploymentsStop_579101,
    base: "/deploymentmanager/v2/projects",
    url: url_DeploymentmanagerDeploymentsStop_579102, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsGetIamPolicy_579118 = ref object of OpenApiRestCall_578355
proc url_DeploymentmanagerDeploymentsGetIamPolicy_579120(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/deployments/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: "/getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerDeploymentsGetIamPolicy_579119(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the access control policy for a resource. May be empty if no such policy or resource exists.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : Name or id of the resource for this request.
  ##   project: JString (required)
  ##          : Project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579121 = path.getOrDefault("resource")
  valid_579121 = validateParameter(valid_579121, JString, required = true,
                                 default = nil)
  if valid_579121 != nil:
    section.add "resource", valid_579121
  var valid_579122 = path.getOrDefault("project")
  valid_579122 = validateParameter(valid_579122, JString, required = true,
                                 default = nil)
  if valid_579122 != nil:
    section.add "project", valid_579122
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579123 = query.getOrDefault("key")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = nil)
  if valid_579123 != nil:
    section.add "key", valid_579123
  var valid_579124 = query.getOrDefault("prettyPrint")
  valid_579124 = validateParameter(valid_579124, JBool, required = false,
                                 default = newJBool(true))
  if valid_579124 != nil:
    section.add "prettyPrint", valid_579124
  var valid_579125 = query.getOrDefault("oauth_token")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = nil)
  if valid_579125 != nil:
    section.add "oauth_token", valid_579125
  var valid_579126 = query.getOrDefault("alt")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = newJString("json"))
  if valid_579126 != nil:
    section.add "alt", valid_579126
  var valid_579127 = query.getOrDefault("userIp")
  valid_579127 = validateParameter(valid_579127, JString, required = false,
                                 default = nil)
  if valid_579127 != nil:
    section.add "userIp", valid_579127
  var valid_579128 = query.getOrDefault("quotaUser")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = nil)
  if valid_579128 != nil:
    section.add "quotaUser", valid_579128
  var valid_579129 = query.getOrDefault("fields")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = nil)
  if valid_579129 != nil:
    section.add "fields", valid_579129
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579130: Call_DeploymentmanagerDeploymentsGetIamPolicy_579118;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource. May be empty if no such policy or resource exists.
  ## 
  let valid = call_579130.validator(path, query, header, formData, body)
  let scheme = call_579130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579130.url(scheme.get, call_579130.host, call_579130.base,
                         call_579130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579130, url, valid)

proc call*(call_579131: Call_DeploymentmanagerDeploymentsGetIamPolicy_579118;
          resource: string; project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## deploymentmanagerDeploymentsGetIamPolicy
  ## Gets the access control policy for a resource. May be empty if no such policy or resource exists.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   resource: string (required)
  ##           : Name or id of the resource for this request.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579132 = newJObject()
  var query_579133 = newJObject()
  add(query_579133, "key", newJString(key))
  add(query_579133, "prettyPrint", newJBool(prettyPrint))
  add(query_579133, "oauth_token", newJString(oauthToken))
  add(query_579133, "alt", newJString(alt))
  add(query_579133, "userIp", newJString(userIp))
  add(query_579133, "quotaUser", newJString(quotaUser))
  add(path_579132, "resource", newJString(resource))
  add(path_579132, "project", newJString(project))
  add(query_579133, "fields", newJString(fields))
  result = call_579131.call(path_579132, query_579133, nil, nil, nil)

var deploymentmanagerDeploymentsGetIamPolicy* = Call_DeploymentmanagerDeploymentsGetIamPolicy_579118(
    name: "deploymentmanagerDeploymentsGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{resource}/getIamPolicy",
    validator: validate_DeploymentmanagerDeploymentsGetIamPolicy_579119,
    base: "/deploymentmanager/v2/projects",
    url: url_DeploymentmanagerDeploymentsGetIamPolicy_579120,
    schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsSetIamPolicy_579134 = ref object of OpenApiRestCall_578355
proc url_DeploymentmanagerDeploymentsSetIamPolicy_579136(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/deployments/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: "/setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerDeploymentsSetIamPolicy_579135(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the access control policy on the specified resource. Replaces any existing policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : Name or id of the resource for this request.
  ##   project: JString (required)
  ##          : Project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579137 = path.getOrDefault("resource")
  valid_579137 = validateParameter(valid_579137, JString, required = true,
                                 default = nil)
  if valid_579137 != nil:
    section.add "resource", valid_579137
  var valid_579138 = path.getOrDefault("project")
  valid_579138 = validateParameter(valid_579138, JString, required = true,
                                 default = nil)
  if valid_579138 != nil:
    section.add "project", valid_579138
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579139 = query.getOrDefault("key")
  valid_579139 = validateParameter(valid_579139, JString, required = false,
                                 default = nil)
  if valid_579139 != nil:
    section.add "key", valid_579139
  var valid_579140 = query.getOrDefault("prettyPrint")
  valid_579140 = validateParameter(valid_579140, JBool, required = false,
                                 default = newJBool(true))
  if valid_579140 != nil:
    section.add "prettyPrint", valid_579140
  var valid_579141 = query.getOrDefault("oauth_token")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = nil)
  if valid_579141 != nil:
    section.add "oauth_token", valid_579141
  var valid_579142 = query.getOrDefault("alt")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = newJString("json"))
  if valid_579142 != nil:
    section.add "alt", valid_579142
  var valid_579143 = query.getOrDefault("userIp")
  valid_579143 = validateParameter(valid_579143, JString, required = false,
                                 default = nil)
  if valid_579143 != nil:
    section.add "userIp", valid_579143
  var valid_579144 = query.getOrDefault("quotaUser")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = nil)
  if valid_579144 != nil:
    section.add "quotaUser", valid_579144
  var valid_579145 = query.getOrDefault("fields")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = nil)
  if valid_579145 != nil:
    section.add "fields", valid_579145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579147: Call_DeploymentmanagerDeploymentsSetIamPolicy_579134;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any existing policy.
  ## 
  let valid = call_579147.validator(path, query, header, formData, body)
  let scheme = call_579147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579147.url(scheme.get, call_579147.host, call_579147.base,
                         call_579147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579147, url, valid)

proc call*(call_579148: Call_DeploymentmanagerDeploymentsSetIamPolicy_579134;
          resource: string; project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## deploymentmanagerDeploymentsSetIamPolicy
  ## Sets the access control policy on the specified resource. Replaces any existing policy.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   resource: string (required)
  ##           : Name or id of the resource for this request.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579149 = newJObject()
  var query_579150 = newJObject()
  var body_579151 = newJObject()
  add(query_579150, "key", newJString(key))
  add(query_579150, "prettyPrint", newJBool(prettyPrint))
  add(query_579150, "oauth_token", newJString(oauthToken))
  add(query_579150, "alt", newJString(alt))
  add(query_579150, "userIp", newJString(userIp))
  add(query_579150, "quotaUser", newJString(quotaUser))
  add(path_579149, "resource", newJString(resource))
  add(path_579149, "project", newJString(project))
  if body != nil:
    body_579151 = body
  add(query_579150, "fields", newJString(fields))
  result = call_579148.call(path_579149, query_579150, nil, nil, body_579151)

var deploymentmanagerDeploymentsSetIamPolicy* = Call_DeploymentmanagerDeploymentsSetIamPolicy_579134(
    name: "deploymentmanagerDeploymentsSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{resource}/setIamPolicy",
    validator: validate_DeploymentmanagerDeploymentsSetIamPolicy_579135,
    base: "/deploymentmanager/v2/projects",
    url: url_DeploymentmanagerDeploymentsSetIamPolicy_579136,
    schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsTestIamPermissions_579152 = ref object of OpenApiRestCall_578355
proc url_DeploymentmanagerDeploymentsTestIamPermissions_579154(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/deployments/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: "/testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerDeploymentsTestIamPermissions_579153(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns permissions that a caller has on the specified resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : Name or id of the resource for this request.
  ##   project: JString (required)
  ##          : Project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579155 = path.getOrDefault("resource")
  valid_579155 = validateParameter(valid_579155, JString, required = true,
                                 default = nil)
  if valid_579155 != nil:
    section.add "resource", valid_579155
  var valid_579156 = path.getOrDefault("project")
  valid_579156 = validateParameter(valid_579156, JString, required = true,
                                 default = nil)
  if valid_579156 != nil:
    section.add "project", valid_579156
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579157 = query.getOrDefault("key")
  valid_579157 = validateParameter(valid_579157, JString, required = false,
                                 default = nil)
  if valid_579157 != nil:
    section.add "key", valid_579157
  var valid_579158 = query.getOrDefault("prettyPrint")
  valid_579158 = validateParameter(valid_579158, JBool, required = false,
                                 default = newJBool(true))
  if valid_579158 != nil:
    section.add "prettyPrint", valid_579158
  var valid_579159 = query.getOrDefault("oauth_token")
  valid_579159 = validateParameter(valid_579159, JString, required = false,
                                 default = nil)
  if valid_579159 != nil:
    section.add "oauth_token", valid_579159
  var valid_579160 = query.getOrDefault("alt")
  valid_579160 = validateParameter(valid_579160, JString, required = false,
                                 default = newJString("json"))
  if valid_579160 != nil:
    section.add "alt", valid_579160
  var valid_579161 = query.getOrDefault("userIp")
  valid_579161 = validateParameter(valid_579161, JString, required = false,
                                 default = nil)
  if valid_579161 != nil:
    section.add "userIp", valid_579161
  var valid_579162 = query.getOrDefault("quotaUser")
  valid_579162 = validateParameter(valid_579162, JString, required = false,
                                 default = nil)
  if valid_579162 != nil:
    section.add "quotaUser", valid_579162
  var valid_579163 = query.getOrDefault("fields")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = nil)
  if valid_579163 != nil:
    section.add "fields", valid_579163
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579165: Call_DeploymentmanagerDeploymentsTestIamPermissions_579152;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified resource.
  ## 
  let valid = call_579165.validator(path, query, header, formData, body)
  let scheme = call_579165.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579165.url(scheme.get, call_579165.host, call_579165.base,
                         call_579165.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579165, url, valid)

proc call*(call_579166: Call_DeploymentmanagerDeploymentsTestIamPermissions_579152;
          resource: string; project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## deploymentmanagerDeploymentsTestIamPermissions
  ## Returns permissions that a caller has on the specified resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   resource: string (required)
  ##           : Name or id of the resource for this request.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579167 = newJObject()
  var query_579168 = newJObject()
  var body_579169 = newJObject()
  add(query_579168, "key", newJString(key))
  add(query_579168, "prettyPrint", newJBool(prettyPrint))
  add(query_579168, "oauth_token", newJString(oauthToken))
  add(query_579168, "alt", newJString(alt))
  add(query_579168, "userIp", newJString(userIp))
  add(query_579168, "quotaUser", newJString(quotaUser))
  add(path_579167, "resource", newJString(resource))
  add(path_579167, "project", newJString(project))
  if body != nil:
    body_579169 = body
  add(query_579168, "fields", newJString(fields))
  result = call_579166.call(path_579167, query_579168, nil, nil, body_579169)

var deploymentmanagerDeploymentsTestIamPermissions* = Call_DeploymentmanagerDeploymentsTestIamPermissions_579152(
    name: "deploymentmanagerDeploymentsTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{project}/global/deployments/{resource}/testIamPermissions",
    validator: validate_DeploymentmanagerDeploymentsTestIamPermissions_579153,
    base: "/deploymentmanager/v2/projects",
    url: url_DeploymentmanagerDeploymentsTestIamPermissions_579154,
    schemes: {Scheme.Https})
type
  Call_DeploymentmanagerOperationsList_579170 = ref object of OpenApiRestCall_578355
proc url_DeploymentmanagerOperationsList_579172(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerOperationsList_579171(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all operations for a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_579173 = path.getOrDefault("project")
  valid_579173 = validateParameter(valid_579173, JString, required = true,
                                 default = nil)
  if valid_579173 != nil:
    section.add "project", valid_579173
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   orderBy: JString
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   filter: JString
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  section = newJObject()
  var valid_579174 = query.getOrDefault("key")
  valid_579174 = validateParameter(valid_579174, JString, required = false,
                                 default = nil)
  if valid_579174 != nil:
    section.add "key", valid_579174
  var valid_579175 = query.getOrDefault("prettyPrint")
  valid_579175 = validateParameter(valid_579175, JBool, required = false,
                                 default = newJBool(true))
  if valid_579175 != nil:
    section.add "prettyPrint", valid_579175
  var valid_579176 = query.getOrDefault("oauth_token")
  valid_579176 = validateParameter(valid_579176, JString, required = false,
                                 default = nil)
  if valid_579176 != nil:
    section.add "oauth_token", valid_579176
  var valid_579177 = query.getOrDefault("alt")
  valid_579177 = validateParameter(valid_579177, JString, required = false,
                                 default = newJString("json"))
  if valid_579177 != nil:
    section.add "alt", valid_579177
  var valid_579178 = query.getOrDefault("userIp")
  valid_579178 = validateParameter(valid_579178, JString, required = false,
                                 default = nil)
  if valid_579178 != nil:
    section.add "userIp", valid_579178
  var valid_579179 = query.getOrDefault("quotaUser")
  valid_579179 = validateParameter(valid_579179, JString, required = false,
                                 default = nil)
  if valid_579179 != nil:
    section.add "quotaUser", valid_579179
  var valid_579180 = query.getOrDefault("orderBy")
  valid_579180 = validateParameter(valid_579180, JString, required = false,
                                 default = nil)
  if valid_579180 != nil:
    section.add "orderBy", valid_579180
  var valid_579181 = query.getOrDefault("filter")
  valid_579181 = validateParameter(valid_579181, JString, required = false,
                                 default = nil)
  if valid_579181 != nil:
    section.add "filter", valid_579181
  var valid_579182 = query.getOrDefault("pageToken")
  valid_579182 = validateParameter(valid_579182, JString, required = false,
                                 default = nil)
  if valid_579182 != nil:
    section.add "pageToken", valid_579182
  var valid_579183 = query.getOrDefault("fields")
  valid_579183 = validateParameter(valid_579183, JString, required = false,
                                 default = nil)
  if valid_579183 != nil:
    section.add "fields", valid_579183
  var valid_579184 = query.getOrDefault("maxResults")
  valid_579184 = validateParameter(valid_579184, JInt, required = false,
                                 default = newJInt(500))
  if valid_579184 != nil:
    section.add "maxResults", valid_579184
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579185: Call_DeploymentmanagerOperationsList_579170;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all operations for a project.
  ## 
  let valid = call_579185.validator(path, query, header, formData, body)
  let scheme = call_579185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579185.url(scheme.get, call_579185.host, call_579185.base,
                         call_579185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579185, url, valid)

proc call*(call_579186: Call_DeploymentmanagerOperationsList_579170;
          project: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; orderBy: string = ""; filter: string = "";
          pageToken: string = ""; fields: string = ""; maxResults: int = 500): Recallable =
  ## deploymentmanagerOperationsList
  ## Lists all operations for a project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   orderBy: string
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   filter: string
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  ##   pageToken: string
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  var path_579187 = newJObject()
  var query_579188 = newJObject()
  add(query_579188, "key", newJString(key))
  add(query_579188, "prettyPrint", newJBool(prettyPrint))
  add(query_579188, "oauth_token", newJString(oauthToken))
  add(query_579188, "alt", newJString(alt))
  add(query_579188, "userIp", newJString(userIp))
  add(query_579188, "quotaUser", newJString(quotaUser))
  add(query_579188, "orderBy", newJString(orderBy))
  add(query_579188, "filter", newJString(filter))
  add(query_579188, "pageToken", newJString(pageToken))
  add(path_579187, "project", newJString(project))
  add(query_579188, "fields", newJString(fields))
  add(query_579188, "maxResults", newJInt(maxResults))
  result = call_579186.call(path_579187, query_579188, nil, nil, nil)

var deploymentmanagerOperationsList* = Call_DeploymentmanagerOperationsList_579170(
    name: "deploymentmanagerOperationsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/operations",
    validator: validate_DeploymentmanagerOperationsList_579171,
    base: "/deploymentmanager/v2/projects",
    url: url_DeploymentmanagerOperationsList_579172, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerOperationsGet_579189 = ref object of OpenApiRestCall_578355
proc url_DeploymentmanagerOperationsGet_579191(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "operation" in path, "`operation` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/operations/"),
               (kind: VariableSegment, value: "operation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerOperationsGet_579190(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about a specific operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   operation: JString (required)
  ##            : The name of the operation for this request.
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `operation` field"
  var valid_579192 = path.getOrDefault("operation")
  valid_579192 = validateParameter(valid_579192, JString, required = true,
                                 default = nil)
  if valid_579192 != nil:
    section.add "operation", valid_579192
  var valid_579193 = path.getOrDefault("project")
  valid_579193 = validateParameter(valid_579193, JString, required = true,
                                 default = nil)
  if valid_579193 != nil:
    section.add "project", valid_579193
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579194 = query.getOrDefault("key")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = nil)
  if valid_579194 != nil:
    section.add "key", valid_579194
  var valid_579195 = query.getOrDefault("prettyPrint")
  valid_579195 = validateParameter(valid_579195, JBool, required = false,
                                 default = newJBool(true))
  if valid_579195 != nil:
    section.add "prettyPrint", valid_579195
  var valid_579196 = query.getOrDefault("oauth_token")
  valid_579196 = validateParameter(valid_579196, JString, required = false,
                                 default = nil)
  if valid_579196 != nil:
    section.add "oauth_token", valid_579196
  var valid_579197 = query.getOrDefault("alt")
  valid_579197 = validateParameter(valid_579197, JString, required = false,
                                 default = newJString("json"))
  if valid_579197 != nil:
    section.add "alt", valid_579197
  var valid_579198 = query.getOrDefault("userIp")
  valid_579198 = validateParameter(valid_579198, JString, required = false,
                                 default = nil)
  if valid_579198 != nil:
    section.add "userIp", valid_579198
  var valid_579199 = query.getOrDefault("quotaUser")
  valid_579199 = validateParameter(valid_579199, JString, required = false,
                                 default = nil)
  if valid_579199 != nil:
    section.add "quotaUser", valid_579199
  var valid_579200 = query.getOrDefault("fields")
  valid_579200 = validateParameter(valid_579200, JString, required = false,
                                 default = nil)
  if valid_579200 != nil:
    section.add "fields", valid_579200
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579201: Call_DeploymentmanagerOperationsGet_579189; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a specific operation.
  ## 
  let valid = call_579201.validator(path, query, header, formData, body)
  let scheme = call_579201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579201.url(scheme.get, call_579201.host, call_579201.base,
                         call_579201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579201, url, valid)

proc call*(call_579202: Call_DeploymentmanagerOperationsGet_579189;
          operation: string; project: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## deploymentmanagerOperationsGet
  ## Gets information about a specific operation.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   operation: string (required)
  ##            : The name of the operation for this request.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579203 = newJObject()
  var query_579204 = newJObject()
  add(query_579204, "key", newJString(key))
  add(query_579204, "prettyPrint", newJBool(prettyPrint))
  add(query_579204, "oauth_token", newJString(oauthToken))
  add(path_579203, "operation", newJString(operation))
  add(query_579204, "alt", newJString(alt))
  add(query_579204, "userIp", newJString(userIp))
  add(query_579204, "quotaUser", newJString(quotaUser))
  add(path_579203, "project", newJString(project))
  add(query_579204, "fields", newJString(fields))
  result = call_579202.call(path_579203, query_579204, nil, nil, nil)

var deploymentmanagerOperationsGet* = Call_DeploymentmanagerOperationsGet_579189(
    name: "deploymentmanagerOperationsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/operations/{operation}",
    validator: validate_DeploymentmanagerOperationsGet_579190,
    base: "/deploymentmanager/v2/projects",
    url: url_DeploymentmanagerOperationsGet_579191, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerTypesList_579205 = ref object of OpenApiRestCall_578355
proc url_DeploymentmanagerTypesList_579207(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/types")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerTypesList_579206(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all resource types for Deployment Manager.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_579208 = path.getOrDefault("project")
  valid_579208 = validateParameter(valid_579208, JString, required = true,
                                 default = nil)
  if valid_579208 != nil:
    section.add "project", valid_579208
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   orderBy: JString
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   filter: JString
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  section = newJObject()
  var valid_579209 = query.getOrDefault("key")
  valid_579209 = validateParameter(valid_579209, JString, required = false,
                                 default = nil)
  if valid_579209 != nil:
    section.add "key", valid_579209
  var valid_579210 = query.getOrDefault("prettyPrint")
  valid_579210 = validateParameter(valid_579210, JBool, required = false,
                                 default = newJBool(true))
  if valid_579210 != nil:
    section.add "prettyPrint", valid_579210
  var valid_579211 = query.getOrDefault("oauth_token")
  valid_579211 = validateParameter(valid_579211, JString, required = false,
                                 default = nil)
  if valid_579211 != nil:
    section.add "oauth_token", valid_579211
  var valid_579212 = query.getOrDefault("alt")
  valid_579212 = validateParameter(valid_579212, JString, required = false,
                                 default = newJString("json"))
  if valid_579212 != nil:
    section.add "alt", valid_579212
  var valid_579213 = query.getOrDefault("userIp")
  valid_579213 = validateParameter(valid_579213, JString, required = false,
                                 default = nil)
  if valid_579213 != nil:
    section.add "userIp", valid_579213
  var valid_579214 = query.getOrDefault("quotaUser")
  valid_579214 = validateParameter(valid_579214, JString, required = false,
                                 default = nil)
  if valid_579214 != nil:
    section.add "quotaUser", valid_579214
  var valid_579215 = query.getOrDefault("orderBy")
  valid_579215 = validateParameter(valid_579215, JString, required = false,
                                 default = nil)
  if valid_579215 != nil:
    section.add "orderBy", valid_579215
  var valid_579216 = query.getOrDefault("filter")
  valid_579216 = validateParameter(valid_579216, JString, required = false,
                                 default = nil)
  if valid_579216 != nil:
    section.add "filter", valid_579216
  var valid_579217 = query.getOrDefault("pageToken")
  valid_579217 = validateParameter(valid_579217, JString, required = false,
                                 default = nil)
  if valid_579217 != nil:
    section.add "pageToken", valid_579217
  var valid_579218 = query.getOrDefault("fields")
  valid_579218 = validateParameter(valid_579218, JString, required = false,
                                 default = nil)
  if valid_579218 != nil:
    section.add "fields", valid_579218
  var valid_579219 = query.getOrDefault("maxResults")
  valid_579219 = validateParameter(valid_579219, JInt, required = false,
                                 default = newJInt(500))
  if valid_579219 != nil:
    section.add "maxResults", valid_579219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579220: Call_DeploymentmanagerTypesList_579205; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all resource types for Deployment Manager.
  ## 
  let valid = call_579220.validator(path, query, header, formData, body)
  let scheme = call_579220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579220.url(scheme.get, call_579220.host, call_579220.base,
                         call_579220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579220, url, valid)

proc call*(call_579221: Call_DeploymentmanagerTypesList_579205; project: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          orderBy: string = ""; filter: string = ""; pageToken: string = "";
          fields: string = ""; maxResults: int = 500): Recallable =
  ## deploymentmanagerTypesList
  ## Lists all resource types for Deployment Manager.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   orderBy: string
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   filter: string
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  ##   pageToken: string
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  var path_579222 = newJObject()
  var query_579223 = newJObject()
  add(query_579223, "key", newJString(key))
  add(query_579223, "prettyPrint", newJBool(prettyPrint))
  add(query_579223, "oauth_token", newJString(oauthToken))
  add(query_579223, "alt", newJString(alt))
  add(query_579223, "userIp", newJString(userIp))
  add(query_579223, "quotaUser", newJString(quotaUser))
  add(query_579223, "orderBy", newJString(orderBy))
  add(query_579223, "filter", newJString(filter))
  add(query_579223, "pageToken", newJString(pageToken))
  add(path_579222, "project", newJString(project))
  add(query_579223, "fields", newJString(fields))
  add(query_579223, "maxResults", newJInt(maxResults))
  result = call_579221.call(path_579222, query_579223, nil, nil, nil)

var deploymentmanagerTypesList* = Call_DeploymentmanagerTypesList_579205(
    name: "deploymentmanagerTypesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/types",
    validator: validate_DeploymentmanagerTypesList_579206,
    base: "/deploymentmanager/v2/projects", url: url_DeploymentmanagerTypesList_579207,
    schemes: {Scheme.Https})
export
  rest

type
  GoogleAuth = ref object
    endpoint*: Uri
    token: string
    expiry*: float64
    issued*: float64
    email: string
    key: string
    scope*: seq[string]
    form: string
    digest: Hash

const
  endpoint = "https://www.googleapis.com/oauth2/v4/token".parseUri
var auth = GoogleAuth(endpoint: endpoint)
proc hash(auth: GoogleAuth): Hash =
  ## yield differing values for effectively different auth payloads
  result = hash($auth.endpoint)
  result = result !& hash(auth.email)
  result = result !& hash(auth.key)
  result = result !& hash(auth.scope.join(" "))
  result = !$result

proc newAuthenticator*(path: string): GoogleAuth =
  let
    input = readFile(path)
    js = parseJson(input)
  auth.email = js["client_email"].getStr
  auth.key = js["private_key"].getStr
  result = auth

proc store(auth: var GoogleAuth; token: string; expiry: int; form: string) =
  auth.token = token
  auth.issued = epochTime()
  auth.expiry = auth.issued + expiry.float64
  auth.form = form
  auth.digest = auth.hash

proc authenticate*(fresh: float64 = 3600.0; lifetime: int = 3600): Future[bool] {.async.} =
  ## get or refresh an authentication token; provide `fresh`
  ## to ensure that the token won't expire in the next N seconds.
  ## provide `lifetime` to indicate how long the token should last.
  let clock = epochTime()
  if auth.expiry > clock + fresh:
    if auth.hash == auth.digest:
      return true
  let
    expiry = clock.int + lifetime
    header = JOSEHeader(alg: RS256, typ: "JWT")
    claims = %*{"iss": auth.email, "scope": auth.scope.join(" "),
              "aud": "https://www.googleapis.com/oauth2/v4/token", "exp": expiry,
              "iat": clock.int}
  var tok = JWT(header: header, claims: toClaims(claims))
  tok.sign(auth.key)
  let post = encodeQuery({"grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
                       "assertion": $tok}, usePlus = false, omitEq = false)
  var client = newAsyncHttpClient()
  client.headers = newHttpHeaders({"Content-Type": "application/x-www-form-urlencoded",
                                 "Content-Length": $post.len})
  let response = await client.request($auth.endpoint, HttpPost, body = post)
  if not response.code.is2xx:
    return false
  let body = await response.body
  client.close
  try:
    let js = parseJson(body)
    auth.store(js["access_token"].getStr, js["expires_in"].getInt,
               js["token_type"].getStr)
  except KeyError:
    return false
  except JsonParsingError:
    return false
  return true

proc composeQueryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs, usePlus = false, omitEq = false)

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  var headers = massageHeaders(input.getOrDefault("header"))
  let body = input.getOrDefault("body").getStr
  if auth.scope.len == 0:
    raise newException(ValueError, "specify authentication scopes")
  if not waitfor authenticate(fresh = 10.0):
    raise newException(IOError, "unable to refresh authentication token")
  headers.add ("Authorization", auth.form & " " & auth.token)
  headers.add ("Content-Type", "application/json")
  headers.add ("Content-Length", $body.len)
  result = newRecallable(call, url, headers, body = body)
