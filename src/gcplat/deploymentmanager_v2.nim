
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

  OpenApiRestCall_579424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579424): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "deploymentmanager"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DeploymentmanagerDeploymentsInsert_579981 = ref object of OpenApiRestCall_579424
proc url_DeploymentmanagerDeploymentsInsert_579983(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerDeploymentsInsert_579982(path: JsonNode;
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
  var valid_579984 = path.getOrDefault("project")
  valid_579984 = validateParameter(valid_579984, JString, required = true,
                                 default = nil)
  if valid_579984 != nil:
    section.add "project", valid_579984
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   createPolicy: JString
  ##               : Sets the policy to use for creating new resources.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   preview: JBool
  ##          : If set to true, creates a deployment and creates "shell" resources but does not actually instantiate these resources. This allows you to preview what your deployment looks like. After previewing a deployment, you can deploy your resources by making a request with the update() method or you can use the cancelPreview() method to cancel the preview altogether. Note that the deployment will still exist after you cancel the preview and you must separately delete this deployment if you want to remove it.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579985 = query.getOrDefault("fields")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "fields", valid_579985
  var valid_579986 = query.getOrDefault("quotaUser")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "quotaUser", valid_579986
  var valid_579987 = query.getOrDefault("alt")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = newJString("json"))
  if valid_579987 != nil:
    section.add "alt", valid_579987
  var valid_579988 = query.getOrDefault("createPolicy")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = newJString("CREATE_OR_ACQUIRE"))
  if valid_579988 != nil:
    section.add "createPolicy", valid_579988
  var valid_579989 = query.getOrDefault("oauth_token")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "oauth_token", valid_579989
  var valid_579990 = query.getOrDefault("userIp")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "userIp", valid_579990
  var valid_579991 = query.getOrDefault("key")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "key", valid_579991
  var valid_579992 = query.getOrDefault("preview")
  valid_579992 = validateParameter(valid_579992, JBool, required = false, default = nil)
  if valid_579992 != nil:
    section.add "preview", valid_579992
  var valid_579993 = query.getOrDefault("prettyPrint")
  valid_579993 = validateParameter(valid_579993, JBool, required = false,
                                 default = newJBool(true))
  if valid_579993 != nil:
    section.add "prettyPrint", valid_579993
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

proc call*(call_579995: Call_DeploymentmanagerDeploymentsInsert_579981;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a deployment and all of the resources described by the deployment manifest.
  ## 
  let valid = call_579995.validator(path, query, header, formData, body)
  let scheme = call_579995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579995.url(scheme.get, call_579995.host, call_579995.base,
                         call_579995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579995, url, valid)

proc call*(call_579996: Call_DeploymentmanagerDeploymentsInsert_579981;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; createPolicy: string = "CREATE_OR_ACQUIRE";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          preview: bool = false; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## deploymentmanagerDeploymentsInsert
  ## Creates a deployment and all of the resources described by the deployment manifest.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   createPolicy: string
  ##               : Sets the policy to use for creating new resources.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   preview: bool
  ##          : If set to true, creates a deployment and creates "shell" resources but does not actually instantiate these resources. This allows you to preview what your deployment looks like. After previewing a deployment, you can deploy your resources by making a request with the update() method or you can use the cancelPreview() method to cancel the preview altogether. Note that the deployment will still exist after you cancel the preview and you must separately delete this deployment if you want to remove it.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_579997 = newJObject()
  var query_579998 = newJObject()
  var body_579999 = newJObject()
  add(query_579998, "fields", newJString(fields))
  add(query_579998, "quotaUser", newJString(quotaUser))
  add(query_579998, "alt", newJString(alt))
  add(query_579998, "createPolicy", newJString(createPolicy))
  add(query_579998, "oauth_token", newJString(oauthToken))
  add(query_579998, "userIp", newJString(userIp))
  add(query_579998, "key", newJString(key))
  add(query_579998, "preview", newJBool(preview))
  add(path_579997, "project", newJString(project))
  if body != nil:
    body_579999 = body
  add(query_579998, "prettyPrint", newJBool(prettyPrint))
  result = call_579996.call(path_579997, query_579998, nil, nil, body_579999)

var deploymentmanagerDeploymentsInsert* = Call_DeploymentmanagerDeploymentsInsert_579981(
    name: "deploymentmanagerDeploymentsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{project}/global/deployments",
    validator: validate_DeploymentmanagerDeploymentsInsert_579982,
    base: "/deploymentmanager/v2/projects",
    url: url_DeploymentmanagerDeploymentsInsert_579983, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsList_579692 = ref object of OpenApiRestCall_579424
proc url_DeploymentmanagerDeploymentsList_579694(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerDeploymentsList_579693(path: JsonNode;
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
  var valid_579820 = path.getOrDefault("project")
  valid_579820 = validateParameter(valid_579820, JString, required = true,
                                 default = nil)
  if valid_579820 != nil:
    section.add "project", valid_579820
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  ##   orderBy: JString
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  section = newJObject()
  var valid_579821 = query.getOrDefault("fields")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = nil)
  if valid_579821 != nil:
    section.add "fields", valid_579821
  var valid_579822 = query.getOrDefault("pageToken")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = nil)
  if valid_579822 != nil:
    section.add "pageToken", valid_579822
  var valid_579823 = query.getOrDefault("quotaUser")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "quotaUser", valid_579823
  var valid_579837 = query.getOrDefault("alt")
  valid_579837 = validateParameter(valid_579837, JString, required = false,
                                 default = newJString("json"))
  if valid_579837 != nil:
    section.add "alt", valid_579837
  var valid_579838 = query.getOrDefault("oauth_token")
  valid_579838 = validateParameter(valid_579838, JString, required = false,
                                 default = nil)
  if valid_579838 != nil:
    section.add "oauth_token", valid_579838
  var valid_579839 = query.getOrDefault("userIp")
  valid_579839 = validateParameter(valid_579839, JString, required = false,
                                 default = nil)
  if valid_579839 != nil:
    section.add "userIp", valid_579839
  var valid_579841 = query.getOrDefault("maxResults")
  valid_579841 = validateParameter(valid_579841, JInt, required = false,
                                 default = newJInt(500))
  if valid_579841 != nil:
    section.add "maxResults", valid_579841
  var valid_579842 = query.getOrDefault("orderBy")
  valid_579842 = validateParameter(valid_579842, JString, required = false,
                                 default = nil)
  if valid_579842 != nil:
    section.add "orderBy", valid_579842
  var valid_579843 = query.getOrDefault("key")
  valid_579843 = validateParameter(valid_579843, JString, required = false,
                                 default = nil)
  if valid_579843 != nil:
    section.add "key", valid_579843
  var valid_579844 = query.getOrDefault("prettyPrint")
  valid_579844 = validateParameter(valid_579844, JBool, required = false,
                                 default = newJBool(true))
  if valid_579844 != nil:
    section.add "prettyPrint", valid_579844
  var valid_579845 = query.getOrDefault("filter")
  valid_579845 = validateParameter(valid_579845, JString, required = false,
                                 default = nil)
  if valid_579845 != nil:
    section.add "filter", valid_579845
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579868: Call_DeploymentmanagerDeploymentsList_579692;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all deployments for a given project.
  ## 
  let valid = call_579868.validator(path, query, header, formData, body)
  let scheme = call_579868.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579868.url(scheme.get, call_579868.host, call_579868.base,
                         call_579868.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579868, url, valid)

proc call*(call_579939: Call_DeploymentmanagerDeploymentsList_579692;
          project: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 500; orderBy: string = "";
          key: string = ""; prettyPrint: bool = true; filter: string = ""): Recallable =
  ## deploymentmanagerDeploymentsList
  ## Lists all deployments for a given project.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  ##   orderBy: string
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  var path_579940 = newJObject()
  var query_579942 = newJObject()
  add(query_579942, "fields", newJString(fields))
  add(query_579942, "pageToken", newJString(pageToken))
  add(query_579942, "quotaUser", newJString(quotaUser))
  add(query_579942, "alt", newJString(alt))
  add(query_579942, "oauth_token", newJString(oauthToken))
  add(query_579942, "userIp", newJString(userIp))
  add(query_579942, "maxResults", newJInt(maxResults))
  add(query_579942, "orderBy", newJString(orderBy))
  add(query_579942, "key", newJString(key))
  add(path_579940, "project", newJString(project))
  add(query_579942, "prettyPrint", newJBool(prettyPrint))
  add(query_579942, "filter", newJString(filter))
  result = call_579939.call(path_579940, query_579942, nil, nil, nil)

var deploymentmanagerDeploymentsList* = Call_DeploymentmanagerDeploymentsList_579692(
    name: "deploymentmanagerDeploymentsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/deployments",
    validator: validate_DeploymentmanagerDeploymentsList_579693,
    base: "/deploymentmanager/v2/projects",
    url: url_DeploymentmanagerDeploymentsList_579694, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsUpdate_580016 = ref object of OpenApiRestCall_579424
proc url_DeploymentmanagerDeploymentsUpdate_580018(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerDeploymentsUpdate_580017(path: JsonNode;
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
  var valid_580019 = path.getOrDefault("deployment")
  valid_580019 = validateParameter(valid_580019, JString, required = true,
                                 default = nil)
  if valid_580019 != nil:
    section.add "deployment", valid_580019
  var valid_580020 = path.getOrDefault("project")
  valid_580020 = validateParameter(valid_580020, JString, required = true,
                                 default = nil)
  if valid_580020 != nil:
    section.add "project", valid_580020
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   createPolicy: JString
  ##               : Sets the policy to use for creating new resources.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   preview: JBool
  ##          : If set to true, updates the deployment and creates and updates the "shell" resources but does not actually alter or instantiate these resources. This allows you to preview what your deployment will look like. You can use this intent to preview how an update would affect your deployment. You must provide a target.config with a configuration if this is set to true. After previewing a deployment, you can deploy your resources by making a request with the update() or you can cancelPreview() to remove the preview altogether. Note that the deployment will still exist after you cancel the preview and you must separately delete this deployment if you want to remove it.
  ##   deletePolicy: JString
  ##               : Sets the policy to use for deleting resources.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580021 = query.getOrDefault("fields")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "fields", valid_580021
  var valid_580022 = query.getOrDefault("quotaUser")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "quotaUser", valid_580022
  var valid_580023 = query.getOrDefault("alt")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = newJString("json"))
  if valid_580023 != nil:
    section.add "alt", valid_580023
  var valid_580024 = query.getOrDefault("createPolicy")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = newJString("CREATE_OR_ACQUIRE"))
  if valid_580024 != nil:
    section.add "createPolicy", valid_580024
  var valid_580025 = query.getOrDefault("oauth_token")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "oauth_token", valid_580025
  var valid_580026 = query.getOrDefault("userIp")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "userIp", valid_580026
  var valid_580027 = query.getOrDefault("key")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "key", valid_580027
  var valid_580028 = query.getOrDefault("preview")
  valid_580028 = validateParameter(valid_580028, JBool, required = false,
                                 default = newJBool(false))
  if valid_580028 != nil:
    section.add "preview", valid_580028
  var valid_580029 = query.getOrDefault("deletePolicy")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = newJString("DELETE"))
  if valid_580029 != nil:
    section.add "deletePolicy", valid_580029
  var valid_580030 = query.getOrDefault("prettyPrint")
  valid_580030 = validateParameter(valid_580030, JBool, required = false,
                                 default = newJBool(true))
  if valid_580030 != nil:
    section.add "prettyPrint", valid_580030
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

proc call*(call_580032: Call_DeploymentmanagerDeploymentsUpdate_580016;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a deployment and all of the resources described by the deployment manifest.
  ## 
  let valid = call_580032.validator(path, query, header, formData, body)
  let scheme = call_580032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580032.url(scheme.get, call_580032.host, call_580032.base,
                         call_580032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580032, url, valid)

proc call*(call_580033: Call_DeploymentmanagerDeploymentsUpdate_580016;
          deployment: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json";
          createPolicy: string = "CREATE_OR_ACQUIRE"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; preview: bool = false;
          deletePolicy: string = "DELETE"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## deploymentmanagerDeploymentsUpdate
  ## Updates a deployment and all of the resources described by the deployment manifest.
  ##   deployment: string (required)
  ##             : The name of the deployment for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   createPolicy: string
  ##               : Sets the policy to use for creating new resources.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   preview: bool
  ##          : If set to true, updates the deployment and creates and updates the "shell" resources but does not actually alter or instantiate these resources. This allows you to preview what your deployment will look like. You can use this intent to preview how an update would affect your deployment. You must provide a target.config with a configuration if this is set to true. After previewing a deployment, you can deploy your resources by making a request with the update() or you can cancelPreview() to remove the preview altogether. Note that the deployment will still exist after you cancel the preview and you must separately delete this deployment if you want to remove it.
  ##   deletePolicy: string
  ##               : Sets the policy to use for deleting resources.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580034 = newJObject()
  var query_580035 = newJObject()
  var body_580036 = newJObject()
  add(path_580034, "deployment", newJString(deployment))
  add(query_580035, "fields", newJString(fields))
  add(query_580035, "quotaUser", newJString(quotaUser))
  add(query_580035, "alt", newJString(alt))
  add(query_580035, "createPolicy", newJString(createPolicy))
  add(query_580035, "oauth_token", newJString(oauthToken))
  add(query_580035, "userIp", newJString(userIp))
  add(query_580035, "key", newJString(key))
  add(query_580035, "preview", newJBool(preview))
  add(query_580035, "deletePolicy", newJString(deletePolicy))
  add(path_580034, "project", newJString(project))
  if body != nil:
    body_580036 = body
  add(query_580035, "prettyPrint", newJBool(prettyPrint))
  result = call_580033.call(path_580034, query_580035, nil, nil, body_580036)

var deploymentmanagerDeploymentsUpdate* = Call_DeploymentmanagerDeploymentsUpdate_580016(
    name: "deploymentmanagerDeploymentsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}",
    validator: validate_DeploymentmanagerDeploymentsUpdate_580017,
    base: "/deploymentmanager/v2/projects",
    url: url_DeploymentmanagerDeploymentsUpdate_580018, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsGet_580000 = ref object of OpenApiRestCall_579424
proc url_DeploymentmanagerDeploymentsGet_580002(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerDeploymentsGet_580001(path: JsonNode;
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
  var valid_580003 = path.getOrDefault("deployment")
  valid_580003 = validateParameter(valid_580003, JString, required = true,
                                 default = nil)
  if valid_580003 != nil:
    section.add "deployment", valid_580003
  var valid_580004 = path.getOrDefault("project")
  valid_580004 = validateParameter(valid_580004, JString, required = true,
                                 default = nil)
  if valid_580004 != nil:
    section.add "project", valid_580004
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580005 = query.getOrDefault("fields")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "fields", valid_580005
  var valid_580006 = query.getOrDefault("quotaUser")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "quotaUser", valid_580006
  var valid_580007 = query.getOrDefault("alt")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = newJString("json"))
  if valid_580007 != nil:
    section.add "alt", valid_580007
  var valid_580008 = query.getOrDefault("oauth_token")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "oauth_token", valid_580008
  var valid_580009 = query.getOrDefault("userIp")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "userIp", valid_580009
  var valid_580010 = query.getOrDefault("key")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "key", valid_580010
  var valid_580011 = query.getOrDefault("prettyPrint")
  valid_580011 = validateParameter(valid_580011, JBool, required = false,
                                 default = newJBool(true))
  if valid_580011 != nil:
    section.add "prettyPrint", valid_580011
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580012: Call_DeploymentmanagerDeploymentsGet_580000;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information about a specific deployment.
  ## 
  let valid = call_580012.validator(path, query, header, formData, body)
  let scheme = call_580012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580012.url(scheme.get, call_580012.host, call_580012.base,
                         call_580012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580012, url, valid)

proc call*(call_580013: Call_DeploymentmanagerDeploymentsGet_580000;
          deployment: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## deploymentmanagerDeploymentsGet
  ## Gets information about a specific deployment.
  ##   deployment: string (required)
  ##             : The name of the deployment for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580014 = newJObject()
  var query_580015 = newJObject()
  add(path_580014, "deployment", newJString(deployment))
  add(query_580015, "fields", newJString(fields))
  add(query_580015, "quotaUser", newJString(quotaUser))
  add(query_580015, "alt", newJString(alt))
  add(query_580015, "oauth_token", newJString(oauthToken))
  add(query_580015, "userIp", newJString(userIp))
  add(query_580015, "key", newJString(key))
  add(path_580014, "project", newJString(project))
  add(query_580015, "prettyPrint", newJBool(prettyPrint))
  result = call_580013.call(path_580014, query_580015, nil, nil, nil)

var deploymentmanagerDeploymentsGet* = Call_DeploymentmanagerDeploymentsGet_580000(
    name: "deploymentmanagerDeploymentsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}",
    validator: validate_DeploymentmanagerDeploymentsGet_580001,
    base: "/deploymentmanager/v2/projects",
    url: url_DeploymentmanagerDeploymentsGet_580002, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsPatch_580054 = ref object of OpenApiRestCall_579424
proc url_DeploymentmanagerDeploymentsPatch_580056(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerDeploymentsPatch_580055(path: JsonNode;
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
  var valid_580057 = path.getOrDefault("deployment")
  valid_580057 = validateParameter(valid_580057, JString, required = true,
                                 default = nil)
  if valid_580057 != nil:
    section.add "deployment", valid_580057
  var valid_580058 = path.getOrDefault("project")
  valid_580058 = validateParameter(valid_580058, JString, required = true,
                                 default = nil)
  if valid_580058 != nil:
    section.add "project", valid_580058
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   createPolicy: JString
  ##               : Sets the policy to use for creating new resources.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   preview: JBool
  ##          : If set to true, updates the deployment and creates and updates the "shell" resources but does not actually alter or instantiate these resources. This allows you to preview what your deployment will look like. You can use this intent to preview how an update would affect your deployment. You must provide a target.config with a configuration if this is set to true. After previewing a deployment, you can deploy your resources by making a request with the update() or you can cancelPreview() to remove the preview altogether. Note that the deployment will still exist after you cancel the preview and you must separately delete this deployment if you want to remove it.
  ##   deletePolicy: JString
  ##               : Sets the policy to use for deleting resources.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580059 = query.getOrDefault("fields")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "fields", valid_580059
  var valid_580060 = query.getOrDefault("quotaUser")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "quotaUser", valid_580060
  var valid_580061 = query.getOrDefault("alt")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = newJString("json"))
  if valid_580061 != nil:
    section.add "alt", valid_580061
  var valid_580062 = query.getOrDefault("createPolicy")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = newJString("CREATE_OR_ACQUIRE"))
  if valid_580062 != nil:
    section.add "createPolicy", valid_580062
  var valid_580063 = query.getOrDefault("oauth_token")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "oauth_token", valid_580063
  var valid_580064 = query.getOrDefault("userIp")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "userIp", valid_580064
  var valid_580065 = query.getOrDefault("key")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "key", valid_580065
  var valid_580066 = query.getOrDefault("preview")
  valid_580066 = validateParameter(valid_580066, JBool, required = false,
                                 default = newJBool(false))
  if valid_580066 != nil:
    section.add "preview", valid_580066
  var valid_580067 = query.getOrDefault("deletePolicy")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = newJString("DELETE"))
  if valid_580067 != nil:
    section.add "deletePolicy", valid_580067
  var valid_580068 = query.getOrDefault("prettyPrint")
  valid_580068 = validateParameter(valid_580068, JBool, required = false,
                                 default = newJBool(true))
  if valid_580068 != nil:
    section.add "prettyPrint", valid_580068
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

proc call*(call_580070: Call_DeploymentmanagerDeploymentsPatch_580054;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a deployment and all of the resources described by the deployment manifest. This method supports patch semantics.
  ## 
  let valid = call_580070.validator(path, query, header, formData, body)
  let scheme = call_580070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580070.url(scheme.get, call_580070.host, call_580070.base,
                         call_580070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580070, url, valid)

proc call*(call_580071: Call_DeploymentmanagerDeploymentsPatch_580054;
          deployment: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json";
          createPolicy: string = "CREATE_OR_ACQUIRE"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; preview: bool = false;
          deletePolicy: string = "DELETE"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## deploymentmanagerDeploymentsPatch
  ## Updates a deployment and all of the resources described by the deployment manifest. This method supports patch semantics.
  ##   deployment: string (required)
  ##             : The name of the deployment for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   createPolicy: string
  ##               : Sets the policy to use for creating new resources.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   preview: bool
  ##          : If set to true, updates the deployment and creates and updates the "shell" resources but does not actually alter or instantiate these resources. This allows you to preview what your deployment will look like. You can use this intent to preview how an update would affect your deployment. You must provide a target.config with a configuration if this is set to true. After previewing a deployment, you can deploy your resources by making a request with the update() or you can cancelPreview() to remove the preview altogether. Note that the deployment will still exist after you cancel the preview and you must separately delete this deployment if you want to remove it.
  ##   deletePolicy: string
  ##               : Sets the policy to use for deleting resources.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580072 = newJObject()
  var query_580073 = newJObject()
  var body_580074 = newJObject()
  add(path_580072, "deployment", newJString(deployment))
  add(query_580073, "fields", newJString(fields))
  add(query_580073, "quotaUser", newJString(quotaUser))
  add(query_580073, "alt", newJString(alt))
  add(query_580073, "createPolicy", newJString(createPolicy))
  add(query_580073, "oauth_token", newJString(oauthToken))
  add(query_580073, "userIp", newJString(userIp))
  add(query_580073, "key", newJString(key))
  add(query_580073, "preview", newJBool(preview))
  add(query_580073, "deletePolicy", newJString(deletePolicy))
  add(path_580072, "project", newJString(project))
  if body != nil:
    body_580074 = body
  add(query_580073, "prettyPrint", newJBool(prettyPrint))
  result = call_580071.call(path_580072, query_580073, nil, nil, body_580074)

var deploymentmanagerDeploymentsPatch* = Call_DeploymentmanagerDeploymentsPatch_580054(
    name: "deploymentmanagerDeploymentsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}",
    validator: validate_DeploymentmanagerDeploymentsPatch_580055,
    base: "/deploymentmanager/v2/projects",
    url: url_DeploymentmanagerDeploymentsPatch_580056, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsDelete_580037 = ref object of OpenApiRestCall_579424
proc url_DeploymentmanagerDeploymentsDelete_580039(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerDeploymentsDelete_580038(path: JsonNode;
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
  var valid_580040 = path.getOrDefault("deployment")
  valid_580040 = validateParameter(valid_580040, JString, required = true,
                                 default = nil)
  if valid_580040 != nil:
    section.add "deployment", valid_580040
  var valid_580041 = path.getOrDefault("project")
  valid_580041 = validateParameter(valid_580041, JString, required = true,
                                 default = nil)
  if valid_580041 != nil:
    section.add "project", valid_580041
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   deletePolicy: JString
  ##               : Sets the policy to use for deleting resources.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580042 = query.getOrDefault("fields")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "fields", valid_580042
  var valid_580043 = query.getOrDefault("quotaUser")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "quotaUser", valid_580043
  var valid_580044 = query.getOrDefault("alt")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = newJString("json"))
  if valid_580044 != nil:
    section.add "alt", valid_580044
  var valid_580045 = query.getOrDefault("oauth_token")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "oauth_token", valid_580045
  var valid_580046 = query.getOrDefault("userIp")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "userIp", valid_580046
  var valid_580047 = query.getOrDefault("key")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "key", valid_580047
  var valid_580048 = query.getOrDefault("deletePolicy")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = newJString("DELETE"))
  if valid_580048 != nil:
    section.add "deletePolicy", valid_580048
  var valid_580049 = query.getOrDefault("prettyPrint")
  valid_580049 = validateParameter(valid_580049, JBool, required = false,
                                 default = newJBool(true))
  if valid_580049 != nil:
    section.add "prettyPrint", valid_580049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580050: Call_DeploymentmanagerDeploymentsDelete_580037;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a deployment and all of the resources in the deployment.
  ## 
  let valid = call_580050.validator(path, query, header, formData, body)
  let scheme = call_580050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580050.url(scheme.get, call_580050.host, call_580050.base,
                         call_580050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580050, url, valid)

proc call*(call_580051: Call_DeploymentmanagerDeploymentsDelete_580037;
          deployment: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; deletePolicy: string = "DELETE";
          prettyPrint: bool = true): Recallable =
  ## deploymentmanagerDeploymentsDelete
  ## Deletes a deployment and all of the resources in the deployment.
  ##   deployment: string (required)
  ##             : The name of the deployment for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   deletePolicy: string
  ##               : Sets the policy to use for deleting resources.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580052 = newJObject()
  var query_580053 = newJObject()
  add(path_580052, "deployment", newJString(deployment))
  add(query_580053, "fields", newJString(fields))
  add(query_580053, "quotaUser", newJString(quotaUser))
  add(query_580053, "alt", newJString(alt))
  add(query_580053, "oauth_token", newJString(oauthToken))
  add(query_580053, "userIp", newJString(userIp))
  add(query_580053, "key", newJString(key))
  add(query_580053, "deletePolicy", newJString(deletePolicy))
  add(path_580052, "project", newJString(project))
  add(query_580053, "prettyPrint", newJBool(prettyPrint))
  result = call_580051.call(path_580052, query_580053, nil, nil, nil)

var deploymentmanagerDeploymentsDelete* = Call_DeploymentmanagerDeploymentsDelete_580037(
    name: "deploymentmanagerDeploymentsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}",
    validator: validate_DeploymentmanagerDeploymentsDelete_580038,
    base: "/deploymentmanager/v2/projects",
    url: url_DeploymentmanagerDeploymentsDelete_580039, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsCancelPreview_580075 = ref object of OpenApiRestCall_579424
proc url_DeploymentmanagerDeploymentsCancelPreview_580077(protocol: Scheme;
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

proc validate_DeploymentmanagerDeploymentsCancelPreview_580076(path: JsonNode;
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
  var valid_580078 = path.getOrDefault("deployment")
  valid_580078 = validateParameter(valid_580078, JString, required = true,
                                 default = nil)
  if valid_580078 != nil:
    section.add "deployment", valid_580078
  var valid_580079 = path.getOrDefault("project")
  valid_580079 = validateParameter(valid_580079, JString, required = true,
                                 default = nil)
  if valid_580079 != nil:
    section.add "project", valid_580079
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580080 = query.getOrDefault("fields")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "fields", valid_580080
  var valid_580081 = query.getOrDefault("quotaUser")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "quotaUser", valid_580081
  var valid_580082 = query.getOrDefault("alt")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = newJString("json"))
  if valid_580082 != nil:
    section.add "alt", valid_580082
  var valid_580083 = query.getOrDefault("oauth_token")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "oauth_token", valid_580083
  var valid_580084 = query.getOrDefault("userIp")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "userIp", valid_580084
  var valid_580085 = query.getOrDefault("key")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "key", valid_580085
  var valid_580086 = query.getOrDefault("prettyPrint")
  valid_580086 = validateParameter(valid_580086, JBool, required = false,
                                 default = newJBool(true))
  if valid_580086 != nil:
    section.add "prettyPrint", valid_580086
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

proc call*(call_580088: Call_DeploymentmanagerDeploymentsCancelPreview_580075;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels and removes the preview currently associated with the deployment.
  ## 
  let valid = call_580088.validator(path, query, header, formData, body)
  let scheme = call_580088.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580088.url(scheme.get, call_580088.host, call_580088.base,
                         call_580088.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580088, url, valid)

proc call*(call_580089: Call_DeploymentmanagerDeploymentsCancelPreview_580075;
          deployment: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## deploymentmanagerDeploymentsCancelPreview
  ## Cancels and removes the preview currently associated with the deployment.
  ##   deployment: string (required)
  ##             : The name of the deployment for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580090 = newJObject()
  var query_580091 = newJObject()
  var body_580092 = newJObject()
  add(path_580090, "deployment", newJString(deployment))
  add(query_580091, "fields", newJString(fields))
  add(query_580091, "quotaUser", newJString(quotaUser))
  add(query_580091, "alt", newJString(alt))
  add(query_580091, "oauth_token", newJString(oauthToken))
  add(query_580091, "userIp", newJString(userIp))
  add(query_580091, "key", newJString(key))
  add(path_580090, "project", newJString(project))
  if body != nil:
    body_580092 = body
  add(query_580091, "prettyPrint", newJBool(prettyPrint))
  result = call_580089.call(path_580090, query_580091, nil, nil, body_580092)

var deploymentmanagerDeploymentsCancelPreview* = Call_DeploymentmanagerDeploymentsCancelPreview_580075(
    name: "deploymentmanagerDeploymentsCancelPreview", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}/cancelPreview",
    validator: validate_DeploymentmanagerDeploymentsCancelPreview_580076,
    base: "/deploymentmanager/v2/projects",
    url: url_DeploymentmanagerDeploymentsCancelPreview_580077,
    schemes: {Scheme.Https})
type
  Call_DeploymentmanagerManifestsList_580093 = ref object of OpenApiRestCall_579424
proc url_DeploymentmanagerManifestsList_580095(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerManifestsList_580094(path: JsonNode;
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
  var valid_580096 = path.getOrDefault("deployment")
  valid_580096 = validateParameter(valid_580096, JString, required = true,
                                 default = nil)
  if valid_580096 != nil:
    section.add "deployment", valid_580096
  var valid_580097 = path.getOrDefault("project")
  valid_580097 = validateParameter(valid_580097, JString, required = true,
                                 default = nil)
  if valid_580097 != nil:
    section.add "project", valid_580097
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  ##   orderBy: JString
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  section = newJObject()
  var valid_580098 = query.getOrDefault("fields")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "fields", valid_580098
  var valid_580099 = query.getOrDefault("pageToken")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "pageToken", valid_580099
  var valid_580100 = query.getOrDefault("quotaUser")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "quotaUser", valid_580100
  var valid_580101 = query.getOrDefault("alt")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = newJString("json"))
  if valid_580101 != nil:
    section.add "alt", valid_580101
  var valid_580102 = query.getOrDefault("oauth_token")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "oauth_token", valid_580102
  var valid_580103 = query.getOrDefault("userIp")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "userIp", valid_580103
  var valid_580104 = query.getOrDefault("maxResults")
  valid_580104 = validateParameter(valid_580104, JInt, required = false,
                                 default = newJInt(500))
  if valid_580104 != nil:
    section.add "maxResults", valid_580104
  var valid_580105 = query.getOrDefault("orderBy")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "orderBy", valid_580105
  var valid_580106 = query.getOrDefault("key")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "key", valid_580106
  var valid_580107 = query.getOrDefault("prettyPrint")
  valid_580107 = validateParameter(valid_580107, JBool, required = false,
                                 default = newJBool(true))
  if valid_580107 != nil:
    section.add "prettyPrint", valid_580107
  var valid_580108 = query.getOrDefault("filter")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "filter", valid_580108
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580109: Call_DeploymentmanagerManifestsList_580093; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all manifests for a given deployment.
  ## 
  let valid = call_580109.validator(path, query, header, formData, body)
  let scheme = call_580109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580109.url(scheme.get, call_580109.host, call_580109.base,
                         call_580109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580109, url, valid)

proc call*(call_580110: Call_DeploymentmanagerManifestsList_580093;
          deployment: string; project: string; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 500;
          orderBy: string = ""; key: string = ""; prettyPrint: bool = true;
          filter: string = ""): Recallable =
  ## deploymentmanagerManifestsList
  ## Lists all manifests for a given deployment.
  ##   deployment: string (required)
  ##             : The name of the deployment for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  ##   orderBy: string
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  var path_580111 = newJObject()
  var query_580112 = newJObject()
  add(path_580111, "deployment", newJString(deployment))
  add(query_580112, "fields", newJString(fields))
  add(query_580112, "pageToken", newJString(pageToken))
  add(query_580112, "quotaUser", newJString(quotaUser))
  add(query_580112, "alt", newJString(alt))
  add(query_580112, "oauth_token", newJString(oauthToken))
  add(query_580112, "userIp", newJString(userIp))
  add(query_580112, "maxResults", newJInt(maxResults))
  add(query_580112, "orderBy", newJString(orderBy))
  add(query_580112, "key", newJString(key))
  add(path_580111, "project", newJString(project))
  add(query_580112, "prettyPrint", newJBool(prettyPrint))
  add(query_580112, "filter", newJString(filter))
  result = call_580110.call(path_580111, query_580112, nil, nil, nil)

var deploymentmanagerManifestsList* = Call_DeploymentmanagerManifestsList_580093(
    name: "deploymentmanagerManifestsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}/manifests",
    validator: validate_DeploymentmanagerManifestsList_580094,
    base: "/deploymentmanager/v2/projects",
    url: url_DeploymentmanagerManifestsList_580095, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerManifestsGet_580113 = ref object of OpenApiRestCall_579424
proc url_DeploymentmanagerManifestsGet_580115(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerManifestsGet_580114(path: JsonNode; query: JsonNode;
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
  var valid_580116 = path.getOrDefault("deployment")
  valid_580116 = validateParameter(valid_580116, JString, required = true,
                                 default = nil)
  if valid_580116 != nil:
    section.add "deployment", valid_580116
  var valid_580117 = path.getOrDefault("project")
  valid_580117 = validateParameter(valid_580117, JString, required = true,
                                 default = nil)
  if valid_580117 != nil:
    section.add "project", valid_580117
  var valid_580118 = path.getOrDefault("manifest")
  valid_580118 = validateParameter(valid_580118, JString, required = true,
                                 default = nil)
  if valid_580118 != nil:
    section.add "manifest", valid_580118
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580119 = query.getOrDefault("fields")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "fields", valid_580119
  var valid_580120 = query.getOrDefault("quotaUser")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "quotaUser", valid_580120
  var valid_580121 = query.getOrDefault("alt")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = newJString("json"))
  if valid_580121 != nil:
    section.add "alt", valid_580121
  var valid_580122 = query.getOrDefault("oauth_token")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "oauth_token", valid_580122
  var valid_580123 = query.getOrDefault("userIp")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "userIp", valid_580123
  var valid_580124 = query.getOrDefault("key")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "key", valid_580124
  var valid_580125 = query.getOrDefault("prettyPrint")
  valid_580125 = validateParameter(valid_580125, JBool, required = false,
                                 default = newJBool(true))
  if valid_580125 != nil:
    section.add "prettyPrint", valid_580125
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580126: Call_DeploymentmanagerManifestsGet_580113; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a specific manifest.
  ## 
  let valid = call_580126.validator(path, query, header, formData, body)
  let scheme = call_580126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580126.url(scheme.get, call_580126.host, call_580126.base,
                         call_580126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580126, url, valid)

proc call*(call_580127: Call_DeploymentmanagerManifestsGet_580113;
          deployment: string; project: string; manifest: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## deploymentmanagerManifestsGet
  ## Gets information about a specific manifest.
  ##   deployment: string (required)
  ##             : The name of the deployment for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   manifest: string (required)
  ##           : The name of the manifest for this request.
  var path_580128 = newJObject()
  var query_580129 = newJObject()
  add(path_580128, "deployment", newJString(deployment))
  add(query_580129, "fields", newJString(fields))
  add(query_580129, "quotaUser", newJString(quotaUser))
  add(query_580129, "alt", newJString(alt))
  add(query_580129, "oauth_token", newJString(oauthToken))
  add(query_580129, "userIp", newJString(userIp))
  add(query_580129, "key", newJString(key))
  add(path_580128, "project", newJString(project))
  add(query_580129, "prettyPrint", newJBool(prettyPrint))
  add(path_580128, "manifest", newJString(manifest))
  result = call_580127.call(path_580128, query_580129, nil, nil, nil)

var deploymentmanagerManifestsGet* = Call_DeploymentmanagerManifestsGet_580113(
    name: "deploymentmanagerManifestsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}/manifests/{manifest}",
    validator: validate_DeploymentmanagerManifestsGet_580114,
    base: "/deploymentmanager/v2/projects",
    url: url_DeploymentmanagerManifestsGet_580115, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerResourcesList_580130 = ref object of OpenApiRestCall_579424
proc url_DeploymentmanagerResourcesList_580132(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerResourcesList_580131(path: JsonNode;
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
  var valid_580133 = path.getOrDefault("deployment")
  valid_580133 = validateParameter(valid_580133, JString, required = true,
                                 default = nil)
  if valid_580133 != nil:
    section.add "deployment", valid_580133
  var valid_580134 = path.getOrDefault("project")
  valid_580134 = validateParameter(valid_580134, JString, required = true,
                                 default = nil)
  if valid_580134 != nil:
    section.add "project", valid_580134
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  ##   orderBy: JString
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  section = newJObject()
  var valid_580135 = query.getOrDefault("fields")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "fields", valid_580135
  var valid_580136 = query.getOrDefault("pageToken")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "pageToken", valid_580136
  var valid_580137 = query.getOrDefault("quotaUser")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "quotaUser", valid_580137
  var valid_580138 = query.getOrDefault("alt")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = newJString("json"))
  if valid_580138 != nil:
    section.add "alt", valid_580138
  var valid_580139 = query.getOrDefault("oauth_token")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "oauth_token", valid_580139
  var valid_580140 = query.getOrDefault("userIp")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = nil)
  if valid_580140 != nil:
    section.add "userIp", valid_580140
  var valid_580141 = query.getOrDefault("maxResults")
  valid_580141 = validateParameter(valid_580141, JInt, required = false,
                                 default = newJInt(500))
  if valid_580141 != nil:
    section.add "maxResults", valid_580141
  var valid_580142 = query.getOrDefault("orderBy")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "orderBy", valid_580142
  var valid_580143 = query.getOrDefault("key")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "key", valid_580143
  var valid_580144 = query.getOrDefault("prettyPrint")
  valid_580144 = validateParameter(valid_580144, JBool, required = false,
                                 default = newJBool(true))
  if valid_580144 != nil:
    section.add "prettyPrint", valid_580144
  var valid_580145 = query.getOrDefault("filter")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "filter", valid_580145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580146: Call_DeploymentmanagerResourcesList_580130; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all resources in a given deployment.
  ## 
  let valid = call_580146.validator(path, query, header, formData, body)
  let scheme = call_580146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580146.url(scheme.get, call_580146.host, call_580146.base,
                         call_580146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580146, url, valid)

proc call*(call_580147: Call_DeploymentmanagerResourcesList_580130;
          deployment: string; project: string; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 500;
          orderBy: string = ""; key: string = ""; prettyPrint: bool = true;
          filter: string = ""): Recallable =
  ## deploymentmanagerResourcesList
  ## Lists all resources in a given deployment.
  ##   deployment: string (required)
  ##             : The name of the deployment for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  ##   orderBy: string
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  var path_580148 = newJObject()
  var query_580149 = newJObject()
  add(path_580148, "deployment", newJString(deployment))
  add(query_580149, "fields", newJString(fields))
  add(query_580149, "pageToken", newJString(pageToken))
  add(query_580149, "quotaUser", newJString(quotaUser))
  add(query_580149, "alt", newJString(alt))
  add(query_580149, "oauth_token", newJString(oauthToken))
  add(query_580149, "userIp", newJString(userIp))
  add(query_580149, "maxResults", newJInt(maxResults))
  add(query_580149, "orderBy", newJString(orderBy))
  add(query_580149, "key", newJString(key))
  add(path_580148, "project", newJString(project))
  add(query_580149, "prettyPrint", newJBool(prettyPrint))
  add(query_580149, "filter", newJString(filter))
  result = call_580147.call(path_580148, query_580149, nil, nil, nil)

var deploymentmanagerResourcesList* = Call_DeploymentmanagerResourcesList_580130(
    name: "deploymentmanagerResourcesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}/resources",
    validator: validate_DeploymentmanagerResourcesList_580131,
    base: "/deploymentmanager/v2/projects",
    url: url_DeploymentmanagerResourcesList_580132, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerResourcesGet_580150 = ref object of OpenApiRestCall_579424
proc url_DeploymentmanagerResourcesGet_580152(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerResourcesGet_580151(path: JsonNode; query: JsonNode;
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
  var valid_580153 = path.getOrDefault("deployment")
  valid_580153 = validateParameter(valid_580153, JString, required = true,
                                 default = nil)
  if valid_580153 != nil:
    section.add "deployment", valid_580153
  var valid_580154 = path.getOrDefault("resource")
  valid_580154 = validateParameter(valid_580154, JString, required = true,
                                 default = nil)
  if valid_580154 != nil:
    section.add "resource", valid_580154
  var valid_580155 = path.getOrDefault("project")
  valid_580155 = validateParameter(valid_580155, JString, required = true,
                                 default = nil)
  if valid_580155 != nil:
    section.add "project", valid_580155
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580156 = query.getOrDefault("fields")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "fields", valid_580156
  var valid_580157 = query.getOrDefault("quotaUser")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = nil)
  if valid_580157 != nil:
    section.add "quotaUser", valid_580157
  var valid_580158 = query.getOrDefault("alt")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = newJString("json"))
  if valid_580158 != nil:
    section.add "alt", valid_580158
  var valid_580159 = query.getOrDefault("oauth_token")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = nil)
  if valid_580159 != nil:
    section.add "oauth_token", valid_580159
  var valid_580160 = query.getOrDefault("userIp")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "userIp", valid_580160
  var valid_580161 = query.getOrDefault("key")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "key", valid_580161
  var valid_580162 = query.getOrDefault("prettyPrint")
  valid_580162 = validateParameter(valid_580162, JBool, required = false,
                                 default = newJBool(true))
  if valid_580162 != nil:
    section.add "prettyPrint", valid_580162
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580163: Call_DeploymentmanagerResourcesGet_580150; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a single resource.
  ## 
  let valid = call_580163.validator(path, query, header, formData, body)
  let scheme = call_580163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580163.url(scheme.get, call_580163.host, call_580163.base,
                         call_580163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580163, url, valid)

proc call*(call_580164: Call_DeploymentmanagerResourcesGet_580150;
          deployment: string; resource: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## deploymentmanagerResourcesGet
  ## Gets information about a single resource.
  ##   deployment: string (required)
  ##             : The name of the deployment for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   resource: string (required)
  ##           : The name of the resource for this request.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580165 = newJObject()
  var query_580166 = newJObject()
  add(path_580165, "deployment", newJString(deployment))
  add(query_580166, "fields", newJString(fields))
  add(query_580166, "quotaUser", newJString(quotaUser))
  add(query_580166, "alt", newJString(alt))
  add(query_580166, "oauth_token", newJString(oauthToken))
  add(query_580166, "userIp", newJString(userIp))
  add(query_580166, "key", newJString(key))
  add(path_580165, "resource", newJString(resource))
  add(path_580165, "project", newJString(project))
  add(query_580166, "prettyPrint", newJBool(prettyPrint))
  result = call_580164.call(path_580165, query_580166, nil, nil, nil)

var deploymentmanagerResourcesGet* = Call_DeploymentmanagerResourcesGet_580150(
    name: "deploymentmanagerResourcesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}/resources/{resource}",
    validator: validate_DeploymentmanagerResourcesGet_580151,
    base: "/deploymentmanager/v2/projects",
    url: url_DeploymentmanagerResourcesGet_580152, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsStop_580167 = ref object of OpenApiRestCall_579424
proc url_DeploymentmanagerDeploymentsStop_580169(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerDeploymentsStop_580168(path: JsonNode;
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
  var valid_580170 = path.getOrDefault("deployment")
  valid_580170 = validateParameter(valid_580170, JString, required = true,
                                 default = nil)
  if valid_580170 != nil:
    section.add "deployment", valid_580170
  var valid_580171 = path.getOrDefault("project")
  valid_580171 = validateParameter(valid_580171, JString, required = true,
                                 default = nil)
  if valid_580171 != nil:
    section.add "project", valid_580171
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580172 = query.getOrDefault("fields")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "fields", valid_580172
  var valid_580173 = query.getOrDefault("quotaUser")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "quotaUser", valid_580173
  var valid_580174 = query.getOrDefault("alt")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = newJString("json"))
  if valid_580174 != nil:
    section.add "alt", valid_580174
  var valid_580175 = query.getOrDefault("oauth_token")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "oauth_token", valid_580175
  var valid_580176 = query.getOrDefault("userIp")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = nil)
  if valid_580176 != nil:
    section.add "userIp", valid_580176
  var valid_580177 = query.getOrDefault("key")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "key", valid_580177
  var valid_580178 = query.getOrDefault("prettyPrint")
  valid_580178 = validateParameter(valid_580178, JBool, required = false,
                                 default = newJBool(true))
  if valid_580178 != nil:
    section.add "prettyPrint", valid_580178
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

proc call*(call_580180: Call_DeploymentmanagerDeploymentsStop_580167;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Stops an ongoing operation. This does not roll back any work that has already been completed, but prevents any new work from being started.
  ## 
  let valid = call_580180.validator(path, query, header, formData, body)
  let scheme = call_580180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580180.url(scheme.get, call_580180.host, call_580180.base,
                         call_580180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580180, url, valid)

proc call*(call_580181: Call_DeploymentmanagerDeploymentsStop_580167;
          deployment: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## deploymentmanagerDeploymentsStop
  ## Stops an ongoing operation. This does not roll back any work that has already been completed, but prevents any new work from being started.
  ##   deployment: string (required)
  ##             : The name of the deployment for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580182 = newJObject()
  var query_580183 = newJObject()
  var body_580184 = newJObject()
  add(path_580182, "deployment", newJString(deployment))
  add(query_580183, "fields", newJString(fields))
  add(query_580183, "quotaUser", newJString(quotaUser))
  add(query_580183, "alt", newJString(alt))
  add(query_580183, "oauth_token", newJString(oauthToken))
  add(query_580183, "userIp", newJString(userIp))
  add(query_580183, "key", newJString(key))
  add(path_580182, "project", newJString(project))
  if body != nil:
    body_580184 = body
  add(query_580183, "prettyPrint", newJBool(prettyPrint))
  result = call_580181.call(path_580182, query_580183, nil, nil, body_580184)

var deploymentmanagerDeploymentsStop* = Call_DeploymentmanagerDeploymentsStop_580167(
    name: "deploymentmanagerDeploymentsStop", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}/stop",
    validator: validate_DeploymentmanagerDeploymentsStop_580168,
    base: "/deploymentmanager/v2/projects",
    url: url_DeploymentmanagerDeploymentsStop_580169, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsGetIamPolicy_580185 = ref object of OpenApiRestCall_579424
proc url_DeploymentmanagerDeploymentsGetIamPolicy_580187(protocol: Scheme;
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

proc validate_DeploymentmanagerDeploymentsGetIamPolicy_580186(path: JsonNode;
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
  var valid_580188 = path.getOrDefault("resource")
  valid_580188 = validateParameter(valid_580188, JString, required = true,
                                 default = nil)
  if valid_580188 != nil:
    section.add "resource", valid_580188
  var valid_580189 = path.getOrDefault("project")
  valid_580189 = validateParameter(valid_580189, JString, required = true,
                                 default = nil)
  if valid_580189 != nil:
    section.add "project", valid_580189
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580190 = query.getOrDefault("fields")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "fields", valid_580190
  var valid_580191 = query.getOrDefault("quotaUser")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "quotaUser", valid_580191
  var valid_580192 = query.getOrDefault("alt")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = newJString("json"))
  if valid_580192 != nil:
    section.add "alt", valid_580192
  var valid_580193 = query.getOrDefault("oauth_token")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = nil)
  if valid_580193 != nil:
    section.add "oauth_token", valid_580193
  var valid_580194 = query.getOrDefault("userIp")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "userIp", valid_580194
  var valid_580195 = query.getOrDefault("key")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "key", valid_580195
  var valid_580196 = query.getOrDefault("prettyPrint")
  valid_580196 = validateParameter(valid_580196, JBool, required = false,
                                 default = newJBool(true))
  if valid_580196 != nil:
    section.add "prettyPrint", valid_580196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580197: Call_DeploymentmanagerDeploymentsGetIamPolicy_580185;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource. May be empty if no such policy or resource exists.
  ## 
  let valid = call_580197.validator(path, query, header, formData, body)
  let scheme = call_580197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580197.url(scheme.get, call_580197.host, call_580197.base,
                         call_580197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580197, url, valid)

proc call*(call_580198: Call_DeploymentmanagerDeploymentsGetIamPolicy_580185;
          resource: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## deploymentmanagerDeploymentsGetIamPolicy
  ## Gets the access control policy for a resource. May be empty if no such policy or resource exists.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   resource: string (required)
  ##           : Name or id of the resource for this request.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580199 = newJObject()
  var query_580200 = newJObject()
  add(query_580200, "fields", newJString(fields))
  add(query_580200, "quotaUser", newJString(quotaUser))
  add(query_580200, "alt", newJString(alt))
  add(query_580200, "oauth_token", newJString(oauthToken))
  add(query_580200, "userIp", newJString(userIp))
  add(query_580200, "key", newJString(key))
  add(path_580199, "resource", newJString(resource))
  add(path_580199, "project", newJString(project))
  add(query_580200, "prettyPrint", newJBool(prettyPrint))
  result = call_580198.call(path_580199, query_580200, nil, nil, nil)

var deploymentmanagerDeploymentsGetIamPolicy* = Call_DeploymentmanagerDeploymentsGetIamPolicy_580185(
    name: "deploymentmanagerDeploymentsGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{resource}/getIamPolicy",
    validator: validate_DeploymentmanagerDeploymentsGetIamPolicy_580186,
    base: "/deploymentmanager/v2/projects",
    url: url_DeploymentmanagerDeploymentsGetIamPolicy_580187,
    schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsSetIamPolicy_580201 = ref object of OpenApiRestCall_579424
proc url_DeploymentmanagerDeploymentsSetIamPolicy_580203(protocol: Scheme;
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

proc validate_DeploymentmanagerDeploymentsSetIamPolicy_580202(path: JsonNode;
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
  var valid_580204 = path.getOrDefault("resource")
  valid_580204 = validateParameter(valid_580204, JString, required = true,
                                 default = nil)
  if valid_580204 != nil:
    section.add "resource", valid_580204
  var valid_580205 = path.getOrDefault("project")
  valid_580205 = validateParameter(valid_580205, JString, required = true,
                                 default = nil)
  if valid_580205 != nil:
    section.add "project", valid_580205
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580206 = query.getOrDefault("fields")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "fields", valid_580206
  var valid_580207 = query.getOrDefault("quotaUser")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "quotaUser", valid_580207
  var valid_580208 = query.getOrDefault("alt")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = newJString("json"))
  if valid_580208 != nil:
    section.add "alt", valid_580208
  var valid_580209 = query.getOrDefault("oauth_token")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "oauth_token", valid_580209
  var valid_580210 = query.getOrDefault("userIp")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "userIp", valid_580210
  var valid_580211 = query.getOrDefault("key")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = nil)
  if valid_580211 != nil:
    section.add "key", valid_580211
  var valid_580212 = query.getOrDefault("prettyPrint")
  valid_580212 = validateParameter(valid_580212, JBool, required = false,
                                 default = newJBool(true))
  if valid_580212 != nil:
    section.add "prettyPrint", valid_580212
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

proc call*(call_580214: Call_DeploymentmanagerDeploymentsSetIamPolicy_580201;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any existing policy.
  ## 
  let valid = call_580214.validator(path, query, header, formData, body)
  let scheme = call_580214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580214.url(scheme.get, call_580214.host, call_580214.base,
                         call_580214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580214, url, valid)

proc call*(call_580215: Call_DeploymentmanagerDeploymentsSetIamPolicy_580201;
          resource: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## deploymentmanagerDeploymentsSetIamPolicy
  ## Sets the access control policy on the specified resource. Replaces any existing policy.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   resource: string (required)
  ##           : Name or id of the resource for this request.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580216 = newJObject()
  var query_580217 = newJObject()
  var body_580218 = newJObject()
  add(query_580217, "fields", newJString(fields))
  add(query_580217, "quotaUser", newJString(quotaUser))
  add(query_580217, "alt", newJString(alt))
  add(query_580217, "oauth_token", newJString(oauthToken))
  add(query_580217, "userIp", newJString(userIp))
  add(query_580217, "key", newJString(key))
  add(path_580216, "resource", newJString(resource))
  add(path_580216, "project", newJString(project))
  if body != nil:
    body_580218 = body
  add(query_580217, "prettyPrint", newJBool(prettyPrint))
  result = call_580215.call(path_580216, query_580217, nil, nil, body_580218)

var deploymentmanagerDeploymentsSetIamPolicy* = Call_DeploymentmanagerDeploymentsSetIamPolicy_580201(
    name: "deploymentmanagerDeploymentsSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{resource}/setIamPolicy",
    validator: validate_DeploymentmanagerDeploymentsSetIamPolicy_580202,
    base: "/deploymentmanager/v2/projects",
    url: url_DeploymentmanagerDeploymentsSetIamPolicy_580203,
    schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsTestIamPermissions_580219 = ref object of OpenApiRestCall_579424
proc url_DeploymentmanagerDeploymentsTestIamPermissions_580221(protocol: Scheme;
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

proc validate_DeploymentmanagerDeploymentsTestIamPermissions_580220(
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
  var valid_580222 = path.getOrDefault("resource")
  valid_580222 = validateParameter(valid_580222, JString, required = true,
                                 default = nil)
  if valid_580222 != nil:
    section.add "resource", valid_580222
  var valid_580223 = path.getOrDefault("project")
  valid_580223 = validateParameter(valid_580223, JString, required = true,
                                 default = nil)
  if valid_580223 != nil:
    section.add "project", valid_580223
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580224 = query.getOrDefault("fields")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = nil)
  if valid_580224 != nil:
    section.add "fields", valid_580224
  var valid_580225 = query.getOrDefault("quotaUser")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = nil)
  if valid_580225 != nil:
    section.add "quotaUser", valid_580225
  var valid_580226 = query.getOrDefault("alt")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = newJString("json"))
  if valid_580226 != nil:
    section.add "alt", valid_580226
  var valid_580227 = query.getOrDefault("oauth_token")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = nil)
  if valid_580227 != nil:
    section.add "oauth_token", valid_580227
  var valid_580228 = query.getOrDefault("userIp")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = nil)
  if valid_580228 != nil:
    section.add "userIp", valid_580228
  var valid_580229 = query.getOrDefault("key")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "key", valid_580229
  var valid_580230 = query.getOrDefault("prettyPrint")
  valid_580230 = validateParameter(valid_580230, JBool, required = false,
                                 default = newJBool(true))
  if valid_580230 != nil:
    section.add "prettyPrint", valid_580230
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

proc call*(call_580232: Call_DeploymentmanagerDeploymentsTestIamPermissions_580219;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified resource.
  ## 
  let valid = call_580232.validator(path, query, header, formData, body)
  let scheme = call_580232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580232.url(scheme.get, call_580232.host, call_580232.base,
                         call_580232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580232, url, valid)

proc call*(call_580233: Call_DeploymentmanagerDeploymentsTestIamPermissions_580219;
          resource: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## deploymentmanagerDeploymentsTestIamPermissions
  ## Returns permissions that a caller has on the specified resource.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   resource: string (required)
  ##           : Name or id of the resource for this request.
  ##   project: string (required)
  ##          : Project ID for this request.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580234 = newJObject()
  var query_580235 = newJObject()
  var body_580236 = newJObject()
  add(query_580235, "fields", newJString(fields))
  add(query_580235, "quotaUser", newJString(quotaUser))
  add(query_580235, "alt", newJString(alt))
  add(query_580235, "oauth_token", newJString(oauthToken))
  add(query_580235, "userIp", newJString(userIp))
  add(query_580235, "key", newJString(key))
  add(path_580234, "resource", newJString(resource))
  add(path_580234, "project", newJString(project))
  if body != nil:
    body_580236 = body
  add(query_580235, "prettyPrint", newJBool(prettyPrint))
  result = call_580233.call(path_580234, query_580235, nil, nil, body_580236)

var deploymentmanagerDeploymentsTestIamPermissions* = Call_DeploymentmanagerDeploymentsTestIamPermissions_580219(
    name: "deploymentmanagerDeploymentsTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{project}/global/deployments/{resource}/testIamPermissions",
    validator: validate_DeploymentmanagerDeploymentsTestIamPermissions_580220,
    base: "/deploymentmanager/v2/projects",
    url: url_DeploymentmanagerDeploymentsTestIamPermissions_580221,
    schemes: {Scheme.Https})
type
  Call_DeploymentmanagerOperationsList_580237 = ref object of OpenApiRestCall_579424
proc url_DeploymentmanagerOperationsList_580239(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerOperationsList_580238(path: JsonNode;
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
  var valid_580240 = path.getOrDefault("project")
  valid_580240 = validateParameter(valid_580240, JString, required = true,
                                 default = nil)
  if valid_580240 != nil:
    section.add "project", valid_580240
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  ##   orderBy: JString
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  section = newJObject()
  var valid_580241 = query.getOrDefault("fields")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = nil)
  if valid_580241 != nil:
    section.add "fields", valid_580241
  var valid_580242 = query.getOrDefault("pageToken")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = nil)
  if valid_580242 != nil:
    section.add "pageToken", valid_580242
  var valid_580243 = query.getOrDefault("quotaUser")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = nil)
  if valid_580243 != nil:
    section.add "quotaUser", valid_580243
  var valid_580244 = query.getOrDefault("alt")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = newJString("json"))
  if valid_580244 != nil:
    section.add "alt", valid_580244
  var valid_580245 = query.getOrDefault("oauth_token")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = nil)
  if valid_580245 != nil:
    section.add "oauth_token", valid_580245
  var valid_580246 = query.getOrDefault("userIp")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "userIp", valid_580246
  var valid_580247 = query.getOrDefault("maxResults")
  valid_580247 = validateParameter(valid_580247, JInt, required = false,
                                 default = newJInt(500))
  if valid_580247 != nil:
    section.add "maxResults", valid_580247
  var valid_580248 = query.getOrDefault("orderBy")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = nil)
  if valid_580248 != nil:
    section.add "orderBy", valid_580248
  var valid_580249 = query.getOrDefault("key")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = nil)
  if valid_580249 != nil:
    section.add "key", valid_580249
  var valid_580250 = query.getOrDefault("prettyPrint")
  valid_580250 = validateParameter(valid_580250, JBool, required = false,
                                 default = newJBool(true))
  if valid_580250 != nil:
    section.add "prettyPrint", valid_580250
  var valid_580251 = query.getOrDefault("filter")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = nil)
  if valid_580251 != nil:
    section.add "filter", valid_580251
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580252: Call_DeploymentmanagerOperationsList_580237;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all operations for a project.
  ## 
  let valid = call_580252.validator(path, query, header, formData, body)
  let scheme = call_580252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580252.url(scheme.get, call_580252.host, call_580252.base,
                         call_580252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580252, url, valid)

proc call*(call_580253: Call_DeploymentmanagerOperationsList_580237;
          project: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 500; orderBy: string = "";
          key: string = ""; prettyPrint: bool = true; filter: string = ""): Recallable =
  ## deploymentmanagerOperationsList
  ## Lists all operations for a project.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  ##   orderBy: string
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  var path_580254 = newJObject()
  var query_580255 = newJObject()
  add(query_580255, "fields", newJString(fields))
  add(query_580255, "pageToken", newJString(pageToken))
  add(query_580255, "quotaUser", newJString(quotaUser))
  add(query_580255, "alt", newJString(alt))
  add(query_580255, "oauth_token", newJString(oauthToken))
  add(query_580255, "userIp", newJString(userIp))
  add(query_580255, "maxResults", newJInt(maxResults))
  add(query_580255, "orderBy", newJString(orderBy))
  add(query_580255, "key", newJString(key))
  add(path_580254, "project", newJString(project))
  add(query_580255, "prettyPrint", newJBool(prettyPrint))
  add(query_580255, "filter", newJString(filter))
  result = call_580253.call(path_580254, query_580255, nil, nil, nil)

var deploymentmanagerOperationsList* = Call_DeploymentmanagerOperationsList_580237(
    name: "deploymentmanagerOperationsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/operations",
    validator: validate_DeploymentmanagerOperationsList_580238,
    base: "/deploymentmanager/v2/projects",
    url: url_DeploymentmanagerOperationsList_580239, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerOperationsGet_580256 = ref object of OpenApiRestCall_579424
proc url_DeploymentmanagerOperationsGet_580258(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerOperationsGet_580257(path: JsonNode;
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
  var valid_580259 = path.getOrDefault("operation")
  valid_580259 = validateParameter(valid_580259, JString, required = true,
                                 default = nil)
  if valid_580259 != nil:
    section.add "operation", valid_580259
  var valid_580260 = path.getOrDefault("project")
  valid_580260 = validateParameter(valid_580260, JString, required = true,
                                 default = nil)
  if valid_580260 != nil:
    section.add "project", valid_580260
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580261 = query.getOrDefault("fields")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = nil)
  if valid_580261 != nil:
    section.add "fields", valid_580261
  var valid_580262 = query.getOrDefault("quotaUser")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = nil)
  if valid_580262 != nil:
    section.add "quotaUser", valid_580262
  var valid_580263 = query.getOrDefault("alt")
  valid_580263 = validateParameter(valid_580263, JString, required = false,
                                 default = newJString("json"))
  if valid_580263 != nil:
    section.add "alt", valid_580263
  var valid_580264 = query.getOrDefault("oauth_token")
  valid_580264 = validateParameter(valid_580264, JString, required = false,
                                 default = nil)
  if valid_580264 != nil:
    section.add "oauth_token", valid_580264
  var valid_580265 = query.getOrDefault("userIp")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = nil)
  if valid_580265 != nil:
    section.add "userIp", valid_580265
  var valid_580266 = query.getOrDefault("key")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = nil)
  if valid_580266 != nil:
    section.add "key", valid_580266
  var valid_580267 = query.getOrDefault("prettyPrint")
  valid_580267 = validateParameter(valid_580267, JBool, required = false,
                                 default = newJBool(true))
  if valid_580267 != nil:
    section.add "prettyPrint", valid_580267
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580268: Call_DeploymentmanagerOperationsGet_580256; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a specific operation.
  ## 
  let valid = call_580268.validator(path, query, header, formData, body)
  let scheme = call_580268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580268.url(scheme.get, call_580268.host, call_580268.base,
                         call_580268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580268, url, valid)

proc call*(call_580269: Call_DeploymentmanagerOperationsGet_580256;
          operation: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## deploymentmanagerOperationsGet
  ## Gets information about a specific operation.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   operation: string (required)
  ##            : The name of the operation for this request.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580270 = newJObject()
  var query_580271 = newJObject()
  add(query_580271, "fields", newJString(fields))
  add(query_580271, "quotaUser", newJString(quotaUser))
  add(query_580271, "alt", newJString(alt))
  add(path_580270, "operation", newJString(operation))
  add(query_580271, "oauth_token", newJString(oauthToken))
  add(query_580271, "userIp", newJString(userIp))
  add(query_580271, "key", newJString(key))
  add(path_580270, "project", newJString(project))
  add(query_580271, "prettyPrint", newJBool(prettyPrint))
  result = call_580269.call(path_580270, query_580271, nil, nil, nil)

var deploymentmanagerOperationsGet* = Call_DeploymentmanagerOperationsGet_580256(
    name: "deploymentmanagerOperationsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/operations/{operation}",
    validator: validate_DeploymentmanagerOperationsGet_580257,
    base: "/deploymentmanager/v2/projects",
    url: url_DeploymentmanagerOperationsGet_580258, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerTypesList_580272 = ref object of OpenApiRestCall_579424
proc url_DeploymentmanagerTypesList_580274(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerTypesList_580273(path: JsonNode; query: JsonNode;
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
  var valid_580275 = path.getOrDefault("project")
  valid_580275 = validateParameter(valid_580275, JString, required = true,
                                 default = nil)
  if valid_580275 != nil:
    section.add "project", valid_580275
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  ##   orderBy: JString
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  section = newJObject()
  var valid_580276 = query.getOrDefault("fields")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = nil)
  if valid_580276 != nil:
    section.add "fields", valid_580276
  var valid_580277 = query.getOrDefault("pageToken")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = nil)
  if valid_580277 != nil:
    section.add "pageToken", valid_580277
  var valid_580278 = query.getOrDefault("quotaUser")
  valid_580278 = validateParameter(valid_580278, JString, required = false,
                                 default = nil)
  if valid_580278 != nil:
    section.add "quotaUser", valid_580278
  var valid_580279 = query.getOrDefault("alt")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = newJString("json"))
  if valid_580279 != nil:
    section.add "alt", valid_580279
  var valid_580280 = query.getOrDefault("oauth_token")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = nil)
  if valid_580280 != nil:
    section.add "oauth_token", valid_580280
  var valid_580281 = query.getOrDefault("userIp")
  valid_580281 = validateParameter(valid_580281, JString, required = false,
                                 default = nil)
  if valid_580281 != nil:
    section.add "userIp", valid_580281
  var valid_580282 = query.getOrDefault("maxResults")
  valid_580282 = validateParameter(valid_580282, JInt, required = false,
                                 default = newJInt(500))
  if valid_580282 != nil:
    section.add "maxResults", valid_580282
  var valid_580283 = query.getOrDefault("orderBy")
  valid_580283 = validateParameter(valid_580283, JString, required = false,
                                 default = nil)
  if valid_580283 != nil:
    section.add "orderBy", valid_580283
  var valid_580284 = query.getOrDefault("key")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = nil)
  if valid_580284 != nil:
    section.add "key", valid_580284
  var valid_580285 = query.getOrDefault("prettyPrint")
  valid_580285 = validateParameter(valid_580285, JBool, required = false,
                                 default = newJBool(true))
  if valid_580285 != nil:
    section.add "prettyPrint", valid_580285
  var valid_580286 = query.getOrDefault("filter")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = nil)
  if valid_580286 != nil:
    section.add "filter", valid_580286
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580287: Call_DeploymentmanagerTypesList_580272; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all resource types for Deployment Manager.
  ## 
  let valid = call_580287.validator(path, query, header, formData, body)
  let scheme = call_580287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580287.url(scheme.get, call_580287.host, call_580287.base,
                         call_580287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580287, url, valid)

proc call*(call_580288: Call_DeploymentmanagerTypesList_580272; project: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 500; orderBy: string = ""; key: string = "";
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## deploymentmanagerTypesList
  ## Lists all resource types for Deployment Manager.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of results per page that should be returned. If the number of available results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive. (Default: 500)
  ##   orderBy: string
  ##          : Sorts list results by a certain order. By default, results are returned in alphanumerical order based on the resource name.
  ## 
  ## You can also sort results in descending order based on the creation timestamp using orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse chronological order (newest result first). Use this to sort resources like operations so that the newest operation is returned first.
  ## 
  ## Currently, only sorting by name or creationTimestamp desc is supported.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   project: string (required)
  ##          : The project ID for this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : A filter expression that filters resources listed in the response. The expression must specify the field name, a comparison operator, and the value that you want to use for filtering. The value must be a string, a number, or a boolean. The comparison operator must be either =, !=, >, or <.
  ## 
  ## For example, if you are filtering Compute Engine instances, you can exclude instances named example-instance by specifying name != example-instance.
  ## 
  ## You can also filter nested fields. For example, you could specify scheduling.automaticRestart = false to include instances only if they are not scheduled for automatic restarts. You can use filtering on nested fields to filter based on resource labels.
  ## 
  ## To filter on multiple expressions, provide each separate expression within parentheses. For example, (scheduling.automaticRestart = true) (cpuPlatform = "Intel Skylake"). By default, each expression is an AND expression. However, you can include AND and OR expressions explicitly. For example, (cpuPlatform = "Intel Skylake") OR (cpuPlatform = "Intel Broadwell") AND (scheduling.automaticRestart = true).
  var path_580289 = newJObject()
  var query_580290 = newJObject()
  add(query_580290, "fields", newJString(fields))
  add(query_580290, "pageToken", newJString(pageToken))
  add(query_580290, "quotaUser", newJString(quotaUser))
  add(query_580290, "alt", newJString(alt))
  add(query_580290, "oauth_token", newJString(oauthToken))
  add(query_580290, "userIp", newJString(userIp))
  add(query_580290, "maxResults", newJInt(maxResults))
  add(query_580290, "orderBy", newJString(orderBy))
  add(query_580290, "key", newJString(key))
  add(path_580289, "project", newJString(project))
  add(query_580290, "prettyPrint", newJBool(prettyPrint))
  add(query_580290, "filter", newJString(filter))
  result = call_580288.call(path_580289, query_580290, nil, nil, nil)

var deploymentmanagerTypesList* = Call_DeploymentmanagerTypesList_580272(
    name: "deploymentmanagerTypesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/types",
    validator: validate_DeploymentmanagerTypesList_580273,
    base: "/deploymentmanager/v2/projects", url: url_DeploymentmanagerTypesList_580274,
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

proc authenticate*(fresh: float64 = -3600.0; lifetime: int = 3600): Future[bool] {.async.} =
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
