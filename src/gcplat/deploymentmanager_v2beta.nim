
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Cloud Deployment Manager API V2Beta Methods
## version: v2beta
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## The Deployment Manager API allows users to declaratively configure, deploy and run complex solutions on the Google Cloud Platform.
## 
## https://developers.google.com/deployment-manager/
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

  OpenApiRestCall_588466 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588466](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588466): Option[Scheme] {.used.} =
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
  Call_DeploymentmanagerCompositeTypesInsert_589023 = ref object of OpenApiRestCall_588466
proc url_DeploymentmanagerCompositeTypesInsert_589025(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/compositeTypes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerCompositeTypesInsert_589024(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a composite type.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_589026 = path.getOrDefault("project")
  valid_589026 = validateParameter(valid_589026, JString, required = true,
                                 default = nil)
  if valid_589026 != nil:
    section.add "project", valid_589026
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
  var valid_589027 = query.getOrDefault("fields")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = nil)
  if valid_589027 != nil:
    section.add "fields", valid_589027
  var valid_589028 = query.getOrDefault("quotaUser")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "quotaUser", valid_589028
  var valid_589029 = query.getOrDefault("alt")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = newJString("json"))
  if valid_589029 != nil:
    section.add "alt", valid_589029
  var valid_589030 = query.getOrDefault("oauth_token")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "oauth_token", valid_589030
  var valid_589031 = query.getOrDefault("userIp")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "userIp", valid_589031
  var valid_589032 = query.getOrDefault("key")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "key", valid_589032
  var valid_589033 = query.getOrDefault("prettyPrint")
  valid_589033 = validateParameter(valid_589033, JBool, required = false,
                                 default = newJBool(true))
  if valid_589033 != nil:
    section.add "prettyPrint", valid_589033
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

proc call*(call_589035: Call_DeploymentmanagerCompositeTypesInsert_589023;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a composite type.
  ## 
  let valid = call_589035.validator(path, query, header, formData, body)
  let scheme = call_589035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589035.url(scheme.get, call_589035.host, call_589035.base,
                         call_589035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589035, url, valid)

proc call*(call_589036: Call_DeploymentmanagerCompositeTypesInsert_589023;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## deploymentmanagerCompositeTypesInsert
  ## Creates a composite type.
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
  var path_589037 = newJObject()
  var query_589038 = newJObject()
  var body_589039 = newJObject()
  add(query_589038, "fields", newJString(fields))
  add(query_589038, "quotaUser", newJString(quotaUser))
  add(query_589038, "alt", newJString(alt))
  add(query_589038, "oauth_token", newJString(oauthToken))
  add(query_589038, "userIp", newJString(userIp))
  add(query_589038, "key", newJString(key))
  add(path_589037, "project", newJString(project))
  if body != nil:
    body_589039 = body
  add(query_589038, "prettyPrint", newJBool(prettyPrint))
  result = call_589036.call(path_589037, query_589038, nil, nil, body_589039)

var deploymentmanagerCompositeTypesInsert* = Call_DeploymentmanagerCompositeTypesInsert_589023(
    name: "deploymentmanagerCompositeTypesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{project}/global/compositeTypes",
    validator: validate_DeploymentmanagerCompositeTypesInsert_589024,
    base: "/deploymentmanager/v2beta/projects",
    url: url_DeploymentmanagerCompositeTypesInsert_589025, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerCompositeTypesList_588734 = ref object of OpenApiRestCall_588466
proc url_DeploymentmanagerCompositeTypesList_588736(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/compositeTypes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerCompositeTypesList_588735(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all composite types for Deployment Manager.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_588862 = path.getOrDefault("project")
  valid_588862 = validateParameter(valid_588862, JString, required = true,
                                 default = nil)
  if valid_588862 != nil:
    section.add "project", valid_588862
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
  var valid_588863 = query.getOrDefault("fields")
  valid_588863 = validateParameter(valid_588863, JString, required = false,
                                 default = nil)
  if valid_588863 != nil:
    section.add "fields", valid_588863
  var valid_588864 = query.getOrDefault("pageToken")
  valid_588864 = validateParameter(valid_588864, JString, required = false,
                                 default = nil)
  if valid_588864 != nil:
    section.add "pageToken", valid_588864
  var valid_588865 = query.getOrDefault("quotaUser")
  valid_588865 = validateParameter(valid_588865, JString, required = false,
                                 default = nil)
  if valid_588865 != nil:
    section.add "quotaUser", valid_588865
  var valid_588879 = query.getOrDefault("alt")
  valid_588879 = validateParameter(valid_588879, JString, required = false,
                                 default = newJString("json"))
  if valid_588879 != nil:
    section.add "alt", valid_588879
  var valid_588880 = query.getOrDefault("oauth_token")
  valid_588880 = validateParameter(valid_588880, JString, required = false,
                                 default = nil)
  if valid_588880 != nil:
    section.add "oauth_token", valid_588880
  var valid_588881 = query.getOrDefault("userIp")
  valid_588881 = validateParameter(valid_588881, JString, required = false,
                                 default = nil)
  if valid_588881 != nil:
    section.add "userIp", valid_588881
  var valid_588883 = query.getOrDefault("maxResults")
  valid_588883 = validateParameter(valid_588883, JInt, required = false,
                                 default = newJInt(500))
  if valid_588883 != nil:
    section.add "maxResults", valid_588883
  var valid_588884 = query.getOrDefault("orderBy")
  valid_588884 = validateParameter(valid_588884, JString, required = false,
                                 default = nil)
  if valid_588884 != nil:
    section.add "orderBy", valid_588884
  var valid_588885 = query.getOrDefault("key")
  valid_588885 = validateParameter(valid_588885, JString, required = false,
                                 default = nil)
  if valid_588885 != nil:
    section.add "key", valid_588885
  var valid_588886 = query.getOrDefault("prettyPrint")
  valid_588886 = validateParameter(valid_588886, JBool, required = false,
                                 default = newJBool(true))
  if valid_588886 != nil:
    section.add "prettyPrint", valid_588886
  var valid_588887 = query.getOrDefault("filter")
  valid_588887 = validateParameter(valid_588887, JString, required = false,
                                 default = nil)
  if valid_588887 != nil:
    section.add "filter", valid_588887
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588910: Call_DeploymentmanagerCompositeTypesList_588734;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all composite types for Deployment Manager.
  ## 
  let valid = call_588910.validator(path, query, header, formData, body)
  let scheme = call_588910.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588910.url(scheme.get, call_588910.host, call_588910.base,
                         call_588910.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588910, url, valid)

proc call*(call_588981: Call_DeploymentmanagerCompositeTypesList_588734;
          project: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 500; orderBy: string = "";
          key: string = ""; prettyPrint: bool = true; filter: string = ""): Recallable =
  ## deploymentmanagerCompositeTypesList
  ## Lists all composite types for Deployment Manager.
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
  var path_588982 = newJObject()
  var query_588984 = newJObject()
  add(query_588984, "fields", newJString(fields))
  add(query_588984, "pageToken", newJString(pageToken))
  add(query_588984, "quotaUser", newJString(quotaUser))
  add(query_588984, "alt", newJString(alt))
  add(query_588984, "oauth_token", newJString(oauthToken))
  add(query_588984, "userIp", newJString(userIp))
  add(query_588984, "maxResults", newJInt(maxResults))
  add(query_588984, "orderBy", newJString(orderBy))
  add(query_588984, "key", newJString(key))
  add(path_588982, "project", newJString(project))
  add(query_588984, "prettyPrint", newJBool(prettyPrint))
  add(query_588984, "filter", newJString(filter))
  result = call_588981.call(path_588982, query_588984, nil, nil, nil)

var deploymentmanagerCompositeTypesList* = Call_DeploymentmanagerCompositeTypesList_588734(
    name: "deploymentmanagerCompositeTypesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/compositeTypes",
    validator: validate_DeploymentmanagerCompositeTypesList_588735,
    base: "/deploymentmanager/v2beta/projects",
    url: url_DeploymentmanagerCompositeTypesList_588736, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerCompositeTypesUpdate_589056 = ref object of OpenApiRestCall_588466
proc url_DeploymentmanagerCompositeTypesUpdate_589058(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "compositeType" in path, "`compositeType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/compositeTypes/"),
               (kind: VariableSegment, value: "compositeType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerCompositeTypesUpdate_589057(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a composite type.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The project ID for this request.
  ##   compositeType: JString (required)
  ##                : The name of the composite type for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_589059 = path.getOrDefault("project")
  valid_589059 = validateParameter(valid_589059, JString, required = true,
                                 default = nil)
  if valid_589059 != nil:
    section.add "project", valid_589059
  var valid_589060 = path.getOrDefault("compositeType")
  valid_589060 = validateParameter(valid_589060, JString, required = true,
                                 default = nil)
  if valid_589060 != nil:
    section.add "compositeType", valid_589060
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
  var valid_589061 = query.getOrDefault("fields")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "fields", valid_589061
  var valid_589062 = query.getOrDefault("quotaUser")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "quotaUser", valid_589062
  var valid_589063 = query.getOrDefault("alt")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = newJString("json"))
  if valid_589063 != nil:
    section.add "alt", valid_589063
  var valid_589064 = query.getOrDefault("oauth_token")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "oauth_token", valid_589064
  var valid_589065 = query.getOrDefault("userIp")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "userIp", valid_589065
  var valid_589066 = query.getOrDefault("key")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "key", valid_589066
  var valid_589067 = query.getOrDefault("prettyPrint")
  valid_589067 = validateParameter(valid_589067, JBool, required = false,
                                 default = newJBool(true))
  if valid_589067 != nil:
    section.add "prettyPrint", valid_589067
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

proc call*(call_589069: Call_DeploymentmanagerCompositeTypesUpdate_589056;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a composite type.
  ## 
  let valid = call_589069.validator(path, query, header, formData, body)
  let scheme = call_589069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589069.url(scheme.get, call_589069.host, call_589069.base,
                         call_589069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589069, url, valid)

proc call*(call_589070: Call_DeploymentmanagerCompositeTypesUpdate_589056;
          project: string; compositeType: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## deploymentmanagerCompositeTypesUpdate
  ## Updates a composite type.
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
  ##   compositeType: string (required)
  ##                : The name of the composite type for this request.
  var path_589071 = newJObject()
  var query_589072 = newJObject()
  var body_589073 = newJObject()
  add(query_589072, "fields", newJString(fields))
  add(query_589072, "quotaUser", newJString(quotaUser))
  add(query_589072, "alt", newJString(alt))
  add(query_589072, "oauth_token", newJString(oauthToken))
  add(query_589072, "userIp", newJString(userIp))
  add(query_589072, "key", newJString(key))
  add(path_589071, "project", newJString(project))
  if body != nil:
    body_589073 = body
  add(query_589072, "prettyPrint", newJBool(prettyPrint))
  add(path_589071, "compositeType", newJString(compositeType))
  result = call_589070.call(path_589071, query_589072, nil, nil, body_589073)

var deploymentmanagerCompositeTypesUpdate* = Call_DeploymentmanagerCompositeTypesUpdate_589056(
    name: "deploymentmanagerCompositeTypesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{project}/global/compositeTypes/{compositeType}",
    validator: validate_DeploymentmanagerCompositeTypesUpdate_589057,
    base: "/deploymentmanager/v2beta/projects",
    url: url_DeploymentmanagerCompositeTypesUpdate_589058, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerCompositeTypesGet_589040 = ref object of OpenApiRestCall_588466
proc url_DeploymentmanagerCompositeTypesGet_589042(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "compositeType" in path, "`compositeType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/compositeTypes/"),
               (kind: VariableSegment, value: "compositeType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerCompositeTypesGet_589041(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about a specific composite type.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The project ID for this request.
  ##   compositeType: JString (required)
  ##                : The name of the composite type for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_589043 = path.getOrDefault("project")
  valid_589043 = validateParameter(valid_589043, JString, required = true,
                                 default = nil)
  if valid_589043 != nil:
    section.add "project", valid_589043
  var valid_589044 = path.getOrDefault("compositeType")
  valid_589044 = validateParameter(valid_589044, JString, required = true,
                                 default = nil)
  if valid_589044 != nil:
    section.add "compositeType", valid_589044
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
  var valid_589045 = query.getOrDefault("fields")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "fields", valid_589045
  var valid_589046 = query.getOrDefault("quotaUser")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "quotaUser", valid_589046
  var valid_589047 = query.getOrDefault("alt")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = newJString("json"))
  if valid_589047 != nil:
    section.add "alt", valid_589047
  var valid_589048 = query.getOrDefault("oauth_token")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "oauth_token", valid_589048
  var valid_589049 = query.getOrDefault("userIp")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "userIp", valid_589049
  var valid_589050 = query.getOrDefault("key")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "key", valid_589050
  var valid_589051 = query.getOrDefault("prettyPrint")
  valid_589051 = validateParameter(valid_589051, JBool, required = false,
                                 default = newJBool(true))
  if valid_589051 != nil:
    section.add "prettyPrint", valid_589051
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589052: Call_DeploymentmanagerCompositeTypesGet_589040;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information about a specific composite type.
  ## 
  let valid = call_589052.validator(path, query, header, formData, body)
  let scheme = call_589052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589052.url(scheme.get, call_589052.host, call_589052.base,
                         call_589052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589052, url, valid)

proc call*(call_589053: Call_DeploymentmanagerCompositeTypesGet_589040;
          project: string; compositeType: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## deploymentmanagerCompositeTypesGet
  ## Gets information about a specific composite type.
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
  ##   compositeType: string (required)
  ##                : The name of the composite type for this request.
  var path_589054 = newJObject()
  var query_589055 = newJObject()
  add(query_589055, "fields", newJString(fields))
  add(query_589055, "quotaUser", newJString(quotaUser))
  add(query_589055, "alt", newJString(alt))
  add(query_589055, "oauth_token", newJString(oauthToken))
  add(query_589055, "userIp", newJString(userIp))
  add(query_589055, "key", newJString(key))
  add(path_589054, "project", newJString(project))
  add(query_589055, "prettyPrint", newJBool(prettyPrint))
  add(path_589054, "compositeType", newJString(compositeType))
  result = call_589053.call(path_589054, query_589055, nil, nil, nil)

var deploymentmanagerCompositeTypesGet* = Call_DeploymentmanagerCompositeTypesGet_589040(
    name: "deploymentmanagerCompositeTypesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/compositeTypes/{compositeType}",
    validator: validate_DeploymentmanagerCompositeTypesGet_589041,
    base: "/deploymentmanager/v2beta/projects",
    url: url_DeploymentmanagerCompositeTypesGet_589042, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerCompositeTypesPatch_589090 = ref object of OpenApiRestCall_588466
proc url_DeploymentmanagerCompositeTypesPatch_589092(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "compositeType" in path, "`compositeType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/compositeTypes/"),
               (kind: VariableSegment, value: "compositeType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerCompositeTypesPatch_589091(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a composite type. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The project ID for this request.
  ##   compositeType: JString (required)
  ##                : The name of the composite type for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_589093 = path.getOrDefault("project")
  valid_589093 = validateParameter(valid_589093, JString, required = true,
                                 default = nil)
  if valid_589093 != nil:
    section.add "project", valid_589093
  var valid_589094 = path.getOrDefault("compositeType")
  valid_589094 = validateParameter(valid_589094, JString, required = true,
                                 default = nil)
  if valid_589094 != nil:
    section.add "compositeType", valid_589094
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
  var valid_589095 = query.getOrDefault("fields")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "fields", valid_589095
  var valid_589096 = query.getOrDefault("quotaUser")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = nil)
  if valid_589096 != nil:
    section.add "quotaUser", valid_589096
  var valid_589097 = query.getOrDefault("alt")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = newJString("json"))
  if valid_589097 != nil:
    section.add "alt", valid_589097
  var valid_589098 = query.getOrDefault("oauth_token")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "oauth_token", valid_589098
  var valid_589099 = query.getOrDefault("userIp")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = nil)
  if valid_589099 != nil:
    section.add "userIp", valid_589099
  var valid_589100 = query.getOrDefault("key")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = nil)
  if valid_589100 != nil:
    section.add "key", valid_589100
  var valid_589101 = query.getOrDefault("prettyPrint")
  valid_589101 = validateParameter(valid_589101, JBool, required = false,
                                 default = newJBool(true))
  if valid_589101 != nil:
    section.add "prettyPrint", valid_589101
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

proc call*(call_589103: Call_DeploymentmanagerCompositeTypesPatch_589090;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a composite type. This method supports patch semantics.
  ## 
  let valid = call_589103.validator(path, query, header, formData, body)
  let scheme = call_589103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589103.url(scheme.get, call_589103.host, call_589103.base,
                         call_589103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589103, url, valid)

proc call*(call_589104: Call_DeploymentmanagerCompositeTypesPatch_589090;
          project: string; compositeType: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## deploymentmanagerCompositeTypesPatch
  ## Updates a composite type. This method supports patch semantics.
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
  ##   compositeType: string (required)
  ##                : The name of the composite type for this request.
  var path_589105 = newJObject()
  var query_589106 = newJObject()
  var body_589107 = newJObject()
  add(query_589106, "fields", newJString(fields))
  add(query_589106, "quotaUser", newJString(quotaUser))
  add(query_589106, "alt", newJString(alt))
  add(query_589106, "oauth_token", newJString(oauthToken))
  add(query_589106, "userIp", newJString(userIp))
  add(query_589106, "key", newJString(key))
  add(path_589105, "project", newJString(project))
  if body != nil:
    body_589107 = body
  add(query_589106, "prettyPrint", newJBool(prettyPrint))
  add(path_589105, "compositeType", newJString(compositeType))
  result = call_589104.call(path_589105, query_589106, nil, nil, body_589107)

var deploymentmanagerCompositeTypesPatch* = Call_DeploymentmanagerCompositeTypesPatch_589090(
    name: "deploymentmanagerCompositeTypesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/{project}/global/compositeTypes/{compositeType}",
    validator: validate_DeploymentmanagerCompositeTypesPatch_589091,
    base: "/deploymentmanager/v2beta/projects",
    url: url_DeploymentmanagerCompositeTypesPatch_589092, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerCompositeTypesDelete_589074 = ref object of OpenApiRestCall_588466
proc url_DeploymentmanagerCompositeTypesDelete_589076(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "compositeType" in path, "`compositeType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/compositeTypes/"),
               (kind: VariableSegment, value: "compositeType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerCompositeTypesDelete_589075(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a composite type.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The project ID for this request.
  ##   compositeType: JString (required)
  ##                : The name of the type for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_589077 = path.getOrDefault("project")
  valid_589077 = validateParameter(valid_589077, JString, required = true,
                                 default = nil)
  if valid_589077 != nil:
    section.add "project", valid_589077
  var valid_589078 = path.getOrDefault("compositeType")
  valid_589078 = validateParameter(valid_589078, JString, required = true,
                                 default = nil)
  if valid_589078 != nil:
    section.add "compositeType", valid_589078
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
  var valid_589079 = query.getOrDefault("fields")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = nil)
  if valid_589079 != nil:
    section.add "fields", valid_589079
  var valid_589080 = query.getOrDefault("quotaUser")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "quotaUser", valid_589080
  var valid_589081 = query.getOrDefault("alt")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = newJString("json"))
  if valid_589081 != nil:
    section.add "alt", valid_589081
  var valid_589082 = query.getOrDefault("oauth_token")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "oauth_token", valid_589082
  var valid_589083 = query.getOrDefault("userIp")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "userIp", valid_589083
  var valid_589084 = query.getOrDefault("key")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "key", valid_589084
  var valid_589085 = query.getOrDefault("prettyPrint")
  valid_589085 = validateParameter(valid_589085, JBool, required = false,
                                 default = newJBool(true))
  if valid_589085 != nil:
    section.add "prettyPrint", valid_589085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589086: Call_DeploymentmanagerCompositeTypesDelete_589074;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a composite type.
  ## 
  let valid = call_589086.validator(path, query, header, formData, body)
  let scheme = call_589086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589086.url(scheme.get, call_589086.host, call_589086.base,
                         call_589086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589086, url, valid)

proc call*(call_589087: Call_DeploymentmanagerCompositeTypesDelete_589074;
          project: string; compositeType: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## deploymentmanagerCompositeTypesDelete
  ## Deletes a composite type.
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
  ##   compositeType: string (required)
  ##                : The name of the type for this request.
  var path_589088 = newJObject()
  var query_589089 = newJObject()
  add(query_589089, "fields", newJString(fields))
  add(query_589089, "quotaUser", newJString(quotaUser))
  add(query_589089, "alt", newJString(alt))
  add(query_589089, "oauth_token", newJString(oauthToken))
  add(query_589089, "userIp", newJString(userIp))
  add(query_589089, "key", newJString(key))
  add(path_589088, "project", newJString(project))
  add(query_589089, "prettyPrint", newJBool(prettyPrint))
  add(path_589088, "compositeType", newJString(compositeType))
  result = call_589087.call(path_589088, query_589089, nil, nil, nil)

var deploymentmanagerCompositeTypesDelete* = Call_DeploymentmanagerCompositeTypesDelete_589074(
    name: "deploymentmanagerCompositeTypesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{project}/global/compositeTypes/{compositeType}",
    validator: validate_DeploymentmanagerCompositeTypesDelete_589075,
    base: "/deploymentmanager/v2beta/projects",
    url: url_DeploymentmanagerCompositeTypesDelete_589076, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsInsert_589127 = ref object of OpenApiRestCall_588466
proc url_DeploymentmanagerDeploymentsInsert_589129(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerDeploymentsInsert_589128(path: JsonNode;
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
  var valid_589130 = path.getOrDefault("project")
  valid_589130 = validateParameter(valid_589130, JString, required = true,
                                 default = nil)
  if valid_589130 != nil:
    section.add "project", valid_589130
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
  var valid_589131 = query.getOrDefault("fields")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "fields", valid_589131
  var valid_589132 = query.getOrDefault("quotaUser")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "quotaUser", valid_589132
  var valid_589133 = query.getOrDefault("alt")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = newJString("json"))
  if valid_589133 != nil:
    section.add "alt", valid_589133
  var valid_589134 = query.getOrDefault("createPolicy")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = newJString("CREATE_OR_ACQUIRE"))
  if valid_589134 != nil:
    section.add "createPolicy", valid_589134
  var valid_589135 = query.getOrDefault("oauth_token")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "oauth_token", valid_589135
  var valid_589136 = query.getOrDefault("userIp")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = nil)
  if valid_589136 != nil:
    section.add "userIp", valid_589136
  var valid_589137 = query.getOrDefault("key")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = nil)
  if valid_589137 != nil:
    section.add "key", valid_589137
  var valid_589138 = query.getOrDefault("preview")
  valid_589138 = validateParameter(valid_589138, JBool, required = false, default = nil)
  if valid_589138 != nil:
    section.add "preview", valid_589138
  var valid_589139 = query.getOrDefault("prettyPrint")
  valid_589139 = validateParameter(valid_589139, JBool, required = false,
                                 default = newJBool(true))
  if valid_589139 != nil:
    section.add "prettyPrint", valid_589139
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

proc call*(call_589141: Call_DeploymentmanagerDeploymentsInsert_589127;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a deployment and all of the resources described by the deployment manifest.
  ## 
  let valid = call_589141.validator(path, query, header, formData, body)
  let scheme = call_589141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589141.url(scheme.get, call_589141.host, call_589141.base,
                         call_589141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589141, url, valid)

proc call*(call_589142: Call_DeploymentmanagerDeploymentsInsert_589127;
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
  var path_589143 = newJObject()
  var query_589144 = newJObject()
  var body_589145 = newJObject()
  add(query_589144, "fields", newJString(fields))
  add(query_589144, "quotaUser", newJString(quotaUser))
  add(query_589144, "alt", newJString(alt))
  add(query_589144, "createPolicy", newJString(createPolicy))
  add(query_589144, "oauth_token", newJString(oauthToken))
  add(query_589144, "userIp", newJString(userIp))
  add(query_589144, "key", newJString(key))
  add(query_589144, "preview", newJBool(preview))
  add(path_589143, "project", newJString(project))
  if body != nil:
    body_589145 = body
  add(query_589144, "prettyPrint", newJBool(prettyPrint))
  result = call_589142.call(path_589143, query_589144, nil, nil, body_589145)

var deploymentmanagerDeploymentsInsert* = Call_DeploymentmanagerDeploymentsInsert_589127(
    name: "deploymentmanagerDeploymentsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{project}/global/deployments",
    validator: validate_DeploymentmanagerDeploymentsInsert_589128,
    base: "/deploymentmanager/v2beta/projects",
    url: url_DeploymentmanagerDeploymentsInsert_589129, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsList_589108 = ref object of OpenApiRestCall_588466
proc url_DeploymentmanagerDeploymentsList_589110(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerDeploymentsList_589109(path: JsonNode;
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
  var valid_589111 = path.getOrDefault("project")
  valid_589111 = validateParameter(valid_589111, JString, required = true,
                                 default = nil)
  if valid_589111 != nil:
    section.add "project", valid_589111
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
  var valid_589112 = query.getOrDefault("fields")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "fields", valid_589112
  var valid_589113 = query.getOrDefault("pageToken")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "pageToken", valid_589113
  var valid_589114 = query.getOrDefault("quotaUser")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "quotaUser", valid_589114
  var valid_589115 = query.getOrDefault("alt")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = newJString("json"))
  if valid_589115 != nil:
    section.add "alt", valid_589115
  var valid_589116 = query.getOrDefault("oauth_token")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = nil)
  if valid_589116 != nil:
    section.add "oauth_token", valid_589116
  var valid_589117 = query.getOrDefault("userIp")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = nil)
  if valid_589117 != nil:
    section.add "userIp", valid_589117
  var valid_589118 = query.getOrDefault("maxResults")
  valid_589118 = validateParameter(valid_589118, JInt, required = false,
                                 default = newJInt(500))
  if valid_589118 != nil:
    section.add "maxResults", valid_589118
  var valid_589119 = query.getOrDefault("orderBy")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = nil)
  if valid_589119 != nil:
    section.add "orderBy", valid_589119
  var valid_589120 = query.getOrDefault("key")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = nil)
  if valid_589120 != nil:
    section.add "key", valid_589120
  var valid_589121 = query.getOrDefault("prettyPrint")
  valid_589121 = validateParameter(valid_589121, JBool, required = false,
                                 default = newJBool(true))
  if valid_589121 != nil:
    section.add "prettyPrint", valid_589121
  var valid_589122 = query.getOrDefault("filter")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = nil)
  if valid_589122 != nil:
    section.add "filter", valid_589122
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589123: Call_DeploymentmanagerDeploymentsList_589108;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all deployments for a given project.
  ## 
  let valid = call_589123.validator(path, query, header, formData, body)
  let scheme = call_589123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589123.url(scheme.get, call_589123.host, call_589123.base,
                         call_589123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589123, url, valid)

proc call*(call_589124: Call_DeploymentmanagerDeploymentsList_589108;
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
  var path_589125 = newJObject()
  var query_589126 = newJObject()
  add(query_589126, "fields", newJString(fields))
  add(query_589126, "pageToken", newJString(pageToken))
  add(query_589126, "quotaUser", newJString(quotaUser))
  add(query_589126, "alt", newJString(alt))
  add(query_589126, "oauth_token", newJString(oauthToken))
  add(query_589126, "userIp", newJString(userIp))
  add(query_589126, "maxResults", newJInt(maxResults))
  add(query_589126, "orderBy", newJString(orderBy))
  add(query_589126, "key", newJString(key))
  add(path_589125, "project", newJString(project))
  add(query_589126, "prettyPrint", newJBool(prettyPrint))
  add(query_589126, "filter", newJString(filter))
  result = call_589124.call(path_589125, query_589126, nil, nil, nil)

var deploymentmanagerDeploymentsList* = Call_DeploymentmanagerDeploymentsList_589108(
    name: "deploymentmanagerDeploymentsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/deployments",
    validator: validate_DeploymentmanagerDeploymentsList_589109,
    base: "/deploymentmanager/v2beta/projects",
    url: url_DeploymentmanagerDeploymentsList_589110, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsUpdate_589162 = ref object of OpenApiRestCall_588466
proc url_DeploymentmanagerDeploymentsUpdate_589164(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerDeploymentsUpdate_589163(path: JsonNode;
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
  var valid_589165 = path.getOrDefault("deployment")
  valid_589165 = validateParameter(valid_589165, JString, required = true,
                                 default = nil)
  if valid_589165 != nil:
    section.add "deployment", valid_589165
  var valid_589166 = path.getOrDefault("project")
  valid_589166 = validateParameter(valid_589166, JString, required = true,
                                 default = nil)
  if valid_589166 != nil:
    section.add "project", valid_589166
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
  var valid_589167 = query.getOrDefault("fields")
  valid_589167 = validateParameter(valid_589167, JString, required = false,
                                 default = nil)
  if valid_589167 != nil:
    section.add "fields", valid_589167
  var valid_589168 = query.getOrDefault("quotaUser")
  valid_589168 = validateParameter(valid_589168, JString, required = false,
                                 default = nil)
  if valid_589168 != nil:
    section.add "quotaUser", valid_589168
  var valid_589169 = query.getOrDefault("alt")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = newJString("json"))
  if valid_589169 != nil:
    section.add "alt", valid_589169
  var valid_589170 = query.getOrDefault("createPolicy")
  valid_589170 = validateParameter(valid_589170, JString, required = false,
                                 default = newJString("CREATE_OR_ACQUIRE"))
  if valid_589170 != nil:
    section.add "createPolicy", valid_589170
  var valid_589171 = query.getOrDefault("oauth_token")
  valid_589171 = validateParameter(valid_589171, JString, required = false,
                                 default = nil)
  if valid_589171 != nil:
    section.add "oauth_token", valid_589171
  var valid_589172 = query.getOrDefault("userIp")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = nil)
  if valid_589172 != nil:
    section.add "userIp", valid_589172
  var valid_589173 = query.getOrDefault("key")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = nil)
  if valid_589173 != nil:
    section.add "key", valid_589173
  var valid_589174 = query.getOrDefault("preview")
  valid_589174 = validateParameter(valid_589174, JBool, required = false,
                                 default = newJBool(false))
  if valid_589174 != nil:
    section.add "preview", valid_589174
  var valid_589175 = query.getOrDefault("deletePolicy")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = newJString("DELETE"))
  if valid_589175 != nil:
    section.add "deletePolicy", valid_589175
  var valid_589176 = query.getOrDefault("prettyPrint")
  valid_589176 = validateParameter(valid_589176, JBool, required = false,
                                 default = newJBool(true))
  if valid_589176 != nil:
    section.add "prettyPrint", valid_589176
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

proc call*(call_589178: Call_DeploymentmanagerDeploymentsUpdate_589162;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a deployment and all of the resources described by the deployment manifest.
  ## 
  let valid = call_589178.validator(path, query, header, formData, body)
  let scheme = call_589178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589178.url(scheme.get, call_589178.host, call_589178.base,
                         call_589178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589178, url, valid)

proc call*(call_589179: Call_DeploymentmanagerDeploymentsUpdate_589162;
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
  var path_589180 = newJObject()
  var query_589181 = newJObject()
  var body_589182 = newJObject()
  add(path_589180, "deployment", newJString(deployment))
  add(query_589181, "fields", newJString(fields))
  add(query_589181, "quotaUser", newJString(quotaUser))
  add(query_589181, "alt", newJString(alt))
  add(query_589181, "createPolicy", newJString(createPolicy))
  add(query_589181, "oauth_token", newJString(oauthToken))
  add(query_589181, "userIp", newJString(userIp))
  add(query_589181, "key", newJString(key))
  add(query_589181, "preview", newJBool(preview))
  add(query_589181, "deletePolicy", newJString(deletePolicy))
  add(path_589180, "project", newJString(project))
  if body != nil:
    body_589182 = body
  add(query_589181, "prettyPrint", newJBool(prettyPrint))
  result = call_589179.call(path_589180, query_589181, nil, nil, body_589182)

var deploymentmanagerDeploymentsUpdate* = Call_DeploymentmanagerDeploymentsUpdate_589162(
    name: "deploymentmanagerDeploymentsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}",
    validator: validate_DeploymentmanagerDeploymentsUpdate_589163,
    base: "/deploymentmanager/v2beta/projects",
    url: url_DeploymentmanagerDeploymentsUpdate_589164, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsGet_589146 = ref object of OpenApiRestCall_588466
proc url_DeploymentmanagerDeploymentsGet_589148(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerDeploymentsGet_589147(path: JsonNode;
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
  var valid_589149 = path.getOrDefault("deployment")
  valid_589149 = validateParameter(valid_589149, JString, required = true,
                                 default = nil)
  if valid_589149 != nil:
    section.add "deployment", valid_589149
  var valid_589150 = path.getOrDefault("project")
  valid_589150 = validateParameter(valid_589150, JString, required = true,
                                 default = nil)
  if valid_589150 != nil:
    section.add "project", valid_589150
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
  var valid_589151 = query.getOrDefault("fields")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = nil)
  if valid_589151 != nil:
    section.add "fields", valid_589151
  var valid_589152 = query.getOrDefault("quotaUser")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "quotaUser", valid_589152
  var valid_589153 = query.getOrDefault("alt")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = newJString("json"))
  if valid_589153 != nil:
    section.add "alt", valid_589153
  var valid_589154 = query.getOrDefault("oauth_token")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "oauth_token", valid_589154
  var valid_589155 = query.getOrDefault("userIp")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = nil)
  if valid_589155 != nil:
    section.add "userIp", valid_589155
  var valid_589156 = query.getOrDefault("key")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = nil)
  if valid_589156 != nil:
    section.add "key", valid_589156
  var valid_589157 = query.getOrDefault("prettyPrint")
  valid_589157 = validateParameter(valid_589157, JBool, required = false,
                                 default = newJBool(true))
  if valid_589157 != nil:
    section.add "prettyPrint", valid_589157
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589158: Call_DeploymentmanagerDeploymentsGet_589146;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information about a specific deployment.
  ## 
  let valid = call_589158.validator(path, query, header, formData, body)
  let scheme = call_589158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589158.url(scheme.get, call_589158.host, call_589158.base,
                         call_589158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589158, url, valid)

proc call*(call_589159: Call_DeploymentmanagerDeploymentsGet_589146;
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
  var path_589160 = newJObject()
  var query_589161 = newJObject()
  add(path_589160, "deployment", newJString(deployment))
  add(query_589161, "fields", newJString(fields))
  add(query_589161, "quotaUser", newJString(quotaUser))
  add(query_589161, "alt", newJString(alt))
  add(query_589161, "oauth_token", newJString(oauthToken))
  add(query_589161, "userIp", newJString(userIp))
  add(query_589161, "key", newJString(key))
  add(path_589160, "project", newJString(project))
  add(query_589161, "prettyPrint", newJBool(prettyPrint))
  result = call_589159.call(path_589160, query_589161, nil, nil, nil)

var deploymentmanagerDeploymentsGet* = Call_DeploymentmanagerDeploymentsGet_589146(
    name: "deploymentmanagerDeploymentsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}",
    validator: validate_DeploymentmanagerDeploymentsGet_589147,
    base: "/deploymentmanager/v2beta/projects",
    url: url_DeploymentmanagerDeploymentsGet_589148, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsPatch_589200 = ref object of OpenApiRestCall_588466
proc url_DeploymentmanagerDeploymentsPatch_589202(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerDeploymentsPatch_589201(path: JsonNode;
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
  var valid_589203 = path.getOrDefault("deployment")
  valid_589203 = validateParameter(valid_589203, JString, required = true,
                                 default = nil)
  if valid_589203 != nil:
    section.add "deployment", valid_589203
  var valid_589204 = path.getOrDefault("project")
  valid_589204 = validateParameter(valid_589204, JString, required = true,
                                 default = nil)
  if valid_589204 != nil:
    section.add "project", valid_589204
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
  var valid_589205 = query.getOrDefault("fields")
  valid_589205 = validateParameter(valid_589205, JString, required = false,
                                 default = nil)
  if valid_589205 != nil:
    section.add "fields", valid_589205
  var valid_589206 = query.getOrDefault("quotaUser")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = nil)
  if valid_589206 != nil:
    section.add "quotaUser", valid_589206
  var valid_589207 = query.getOrDefault("alt")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = newJString("json"))
  if valid_589207 != nil:
    section.add "alt", valid_589207
  var valid_589208 = query.getOrDefault("createPolicy")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = newJString("CREATE_OR_ACQUIRE"))
  if valid_589208 != nil:
    section.add "createPolicy", valid_589208
  var valid_589209 = query.getOrDefault("oauth_token")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = nil)
  if valid_589209 != nil:
    section.add "oauth_token", valid_589209
  var valid_589210 = query.getOrDefault("userIp")
  valid_589210 = validateParameter(valid_589210, JString, required = false,
                                 default = nil)
  if valid_589210 != nil:
    section.add "userIp", valid_589210
  var valid_589211 = query.getOrDefault("key")
  valid_589211 = validateParameter(valid_589211, JString, required = false,
                                 default = nil)
  if valid_589211 != nil:
    section.add "key", valid_589211
  var valid_589212 = query.getOrDefault("preview")
  valid_589212 = validateParameter(valid_589212, JBool, required = false,
                                 default = newJBool(false))
  if valid_589212 != nil:
    section.add "preview", valid_589212
  var valid_589213 = query.getOrDefault("deletePolicy")
  valid_589213 = validateParameter(valid_589213, JString, required = false,
                                 default = newJString("DELETE"))
  if valid_589213 != nil:
    section.add "deletePolicy", valid_589213
  var valid_589214 = query.getOrDefault("prettyPrint")
  valid_589214 = validateParameter(valid_589214, JBool, required = false,
                                 default = newJBool(true))
  if valid_589214 != nil:
    section.add "prettyPrint", valid_589214
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

proc call*(call_589216: Call_DeploymentmanagerDeploymentsPatch_589200;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a deployment and all of the resources described by the deployment manifest. This method supports patch semantics.
  ## 
  let valid = call_589216.validator(path, query, header, formData, body)
  let scheme = call_589216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589216.url(scheme.get, call_589216.host, call_589216.base,
                         call_589216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589216, url, valid)

proc call*(call_589217: Call_DeploymentmanagerDeploymentsPatch_589200;
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
  var path_589218 = newJObject()
  var query_589219 = newJObject()
  var body_589220 = newJObject()
  add(path_589218, "deployment", newJString(deployment))
  add(query_589219, "fields", newJString(fields))
  add(query_589219, "quotaUser", newJString(quotaUser))
  add(query_589219, "alt", newJString(alt))
  add(query_589219, "createPolicy", newJString(createPolicy))
  add(query_589219, "oauth_token", newJString(oauthToken))
  add(query_589219, "userIp", newJString(userIp))
  add(query_589219, "key", newJString(key))
  add(query_589219, "preview", newJBool(preview))
  add(query_589219, "deletePolicy", newJString(deletePolicy))
  add(path_589218, "project", newJString(project))
  if body != nil:
    body_589220 = body
  add(query_589219, "prettyPrint", newJBool(prettyPrint))
  result = call_589217.call(path_589218, query_589219, nil, nil, body_589220)

var deploymentmanagerDeploymentsPatch* = Call_DeploymentmanagerDeploymentsPatch_589200(
    name: "deploymentmanagerDeploymentsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}",
    validator: validate_DeploymentmanagerDeploymentsPatch_589201,
    base: "/deploymentmanager/v2beta/projects",
    url: url_DeploymentmanagerDeploymentsPatch_589202, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsDelete_589183 = ref object of OpenApiRestCall_588466
proc url_DeploymentmanagerDeploymentsDelete_589185(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerDeploymentsDelete_589184(path: JsonNode;
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
  var valid_589186 = path.getOrDefault("deployment")
  valid_589186 = validateParameter(valid_589186, JString, required = true,
                                 default = nil)
  if valid_589186 != nil:
    section.add "deployment", valid_589186
  var valid_589187 = path.getOrDefault("project")
  valid_589187 = validateParameter(valid_589187, JString, required = true,
                                 default = nil)
  if valid_589187 != nil:
    section.add "project", valid_589187
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
  var valid_589188 = query.getOrDefault("fields")
  valid_589188 = validateParameter(valid_589188, JString, required = false,
                                 default = nil)
  if valid_589188 != nil:
    section.add "fields", valid_589188
  var valid_589189 = query.getOrDefault("quotaUser")
  valid_589189 = validateParameter(valid_589189, JString, required = false,
                                 default = nil)
  if valid_589189 != nil:
    section.add "quotaUser", valid_589189
  var valid_589190 = query.getOrDefault("alt")
  valid_589190 = validateParameter(valid_589190, JString, required = false,
                                 default = newJString("json"))
  if valid_589190 != nil:
    section.add "alt", valid_589190
  var valid_589191 = query.getOrDefault("oauth_token")
  valid_589191 = validateParameter(valid_589191, JString, required = false,
                                 default = nil)
  if valid_589191 != nil:
    section.add "oauth_token", valid_589191
  var valid_589192 = query.getOrDefault("userIp")
  valid_589192 = validateParameter(valid_589192, JString, required = false,
                                 default = nil)
  if valid_589192 != nil:
    section.add "userIp", valid_589192
  var valid_589193 = query.getOrDefault("key")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = nil)
  if valid_589193 != nil:
    section.add "key", valid_589193
  var valid_589194 = query.getOrDefault("deletePolicy")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = newJString("DELETE"))
  if valid_589194 != nil:
    section.add "deletePolicy", valid_589194
  var valid_589195 = query.getOrDefault("prettyPrint")
  valid_589195 = validateParameter(valid_589195, JBool, required = false,
                                 default = newJBool(true))
  if valid_589195 != nil:
    section.add "prettyPrint", valid_589195
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589196: Call_DeploymentmanagerDeploymentsDelete_589183;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a deployment and all of the resources in the deployment.
  ## 
  let valid = call_589196.validator(path, query, header, formData, body)
  let scheme = call_589196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589196.url(scheme.get, call_589196.host, call_589196.base,
                         call_589196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589196, url, valid)

proc call*(call_589197: Call_DeploymentmanagerDeploymentsDelete_589183;
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
  var path_589198 = newJObject()
  var query_589199 = newJObject()
  add(path_589198, "deployment", newJString(deployment))
  add(query_589199, "fields", newJString(fields))
  add(query_589199, "quotaUser", newJString(quotaUser))
  add(query_589199, "alt", newJString(alt))
  add(query_589199, "oauth_token", newJString(oauthToken))
  add(query_589199, "userIp", newJString(userIp))
  add(query_589199, "key", newJString(key))
  add(query_589199, "deletePolicy", newJString(deletePolicy))
  add(path_589198, "project", newJString(project))
  add(query_589199, "prettyPrint", newJBool(prettyPrint))
  result = call_589197.call(path_589198, query_589199, nil, nil, nil)

var deploymentmanagerDeploymentsDelete* = Call_DeploymentmanagerDeploymentsDelete_589183(
    name: "deploymentmanagerDeploymentsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}",
    validator: validate_DeploymentmanagerDeploymentsDelete_589184,
    base: "/deploymentmanager/v2beta/projects",
    url: url_DeploymentmanagerDeploymentsDelete_589185, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsCancelPreview_589221 = ref object of OpenApiRestCall_588466
proc url_DeploymentmanagerDeploymentsCancelPreview_589223(protocol: Scheme;
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

proc validate_DeploymentmanagerDeploymentsCancelPreview_589222(path: JsonNode;
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
  var valid_589224 = path.getOrDefault("deployment")
  valid_589224 = validateParameter(valid_589224, JString, required = true,
                                 default = nil)
  if valid_589224 != nil:
    section.add "deployment", valid_589224
  var valid_589225 = path.getOrDefault("project")
  valid_589225 = validateParameter(valid_589225, JString, required = true,
                                 default = nil)
  if valid_589225 != nil:
    section.add "project", valid_589225
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
  var valid_589226 = query.getOrDefault("fields")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = nil)
  if valid_589226 != nil:
    section.add "fields", valid_589226
  var valid_589227 = query.getOrDefault("quotaUser")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = nil)
  if valid_589227 != nil:
    section.add "quotaUser", valid_589227
  var valid_589228 = query.getOrDefault("alt")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = newJString("json"))
  if valid_589228 != nil:
    section.add "alt", valid_589228
  var valid_589229 = query.getOrDefault("oauth_token")
  valid_589229 = validateParameter(valid_589229, JString, required = false,
                                 default = nil)
  if valid_589229 != nil:
    section.add "oauth_token", valid_589229
  var valid_589230 = query.getOrDefault("userIp")
  valid_589230 = validateParameter(valid_589230, JString, required = false,
                                 default = nil)
  if valid_589230 != nil:
    section.add "userIp", valid_589230
  var valid_589231 = query.getOrDefault("key")
  valid_589231 = validateParameter(valid_589231, JString, required = false,
                                 default = nil)
  if valid_589231 != nil:
    section.add "key", valid_589231
  var valid_589232 = query.getOrDefault("prettyPrint")
  valid_589232 = validateParameter(valid_589232, JBool, required = false,
                                 default = newJBool(true))
  if valid_589232 != nil:
    section.add "prettyPrint", valid_589232
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

proc call*(call_589234: Call_DeploymentmanagerDeploymentsCancelPreview_589221;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels and removes the preview currently associated with the deployment.
  ## 
  let valid = call_589234.validator(path, query, header, formData, body)
  let scheme = call_589234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589234.url(scheme.get, call_589234.host, call_589234.base,
                         call_589234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589234, url, valid)

proc call*(call_589235: Call_DeploymentmanagerDeploymentsCancelPreview_589221;
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
  var path_589236 = newJObject()
  var query_589237 = newJObject()
  var body_589238 = newJObject()
  add(path_589236, "deployment", newJString(deployment))
  add(query_589237, "fields", newJString(fields))
  add(query_589237, "quotaUser", newJString(quotaUser))
  add(query_589237, "alt", newJString(alt))
  add(query_589237, "oauth_token", newJString(oauthToken))
  add(query_589237, "userIp", newJString(userIp))
  add(query_589237, "key", newJString(key))
  add(path_589236, "project", newJString(project))
  if body != nil:
    body_589238 = body
  add(query_589237, "prettyPrint", newJBool(prettyPrint))
  result = call_589235.call(path_589236, query_589237, nil, nil, body_589238)

var deploymentmanagerDeploymentsCancelPreview* = Call_DeploymentmanagerDeploymentsCancelPreview_589221(
    name: "deploymentmanagerDeploymentsCancelPreview", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}/cancelPreview",
    validator: validate_DeploymentmanagerDeploymentsCancelPreview_589222,
    base: "/deploymentmanager/v2beta/projects",
    url: url_DeploymentmanagerDeploymentsCancelPreview_589223,
    schemes: {Scheme.Https})
type
  Call_DeploymentmanagerManifestsList_589239 = ref object of OpenApiRestCall_588466
proc url_DeploymentmanagerManifestsList_589241(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerManifestsList_589240(path: JsonNode;
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
  var valid_589242 = path.getOrDefault("deployment")
  valid_589242 = validateParameter(valid_589242, JString, required = true,
                                 default = nil)
  if valid_589242 != nil:
    section.add "deployment", valid_589242
  var valid_589243 = path.getOrDefault("project")
  valid_589243 = validateParameter(valid_589243, JString, required = true,
                                 default = nil)
  if valid_589243 != nil:
    section.add "project", valid_589243
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
  var valid_589244 = query.getOrDefault("fields")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = nil)
  if valid_589244 != nil:
    section.add "fields", valid_589244
  var valid_589245 = query.getOrDefault("pageToken")
  valid_589245 = validateParameter(valid_589245, JString, required = false,
                                 default = nil)
  if valid_589245 != nil:
    section.add "pageToken", valid_589245
  var valid_589246 = query.getOrDefault("quotaUser")
  valid_589246 = validateParameter(valid_589246, JString, required = false,
                                 default = nil)
  if valid_589246 != nil:
    section.add "quotaUser", valid_589246
  var valid_589247 = query.getOrDefault("alt")
  valid_589247 = validateParameter(valid_589247, JString, required = false,
                                 default = newJString("json"))
  if valid_589247 != nil:
    section.add "alt", valid_589247
  var valid_589248 = query.getOrDefault("oauth_token")
  valid_589248 = validateParameter(valid_589248, JString, required = false,
                                 default = nil)
  if valid_589248 != nil:
    section.add "oauth_token", valid_589248
  var valid_589249 = query.getOrDefault("userIp")
  valid_589249 = validateParameter(valid_589249, JString, required = false,
                                 default = nil)
  if valid_589249 != nil:
    section.add "userIp", valid_589249
  var valid_589250 = query.getOrDefault("maxResults")
  valid_589250 = validateParameter(valid_589250, JInt, required = false,
                                 default = newJInt(500))
  if valid_589250 != nil:
    section.add "maxResults", valid_589250
  var valid_589251 = query.getOrDefault("orderBy")
  valid_589251 = validateParameter(valid_589251, JString, required = false,
                                 default = nil)
  if valid_589251 != nil:
    section.add "orderBy", valid_589251
  var valid_589252 = query.getOrDefault("key")
  valid_589252 = validateParameter(valid_589252, JString, required = false,
                                 default = nil)
  if valid_589252 != nil:
    section.add "key", valid_589252
  var valid_589253 = query.getOrDefault("prettyPrint")
  valid_589253 = validateParameter(valid_589253, JBool, required = false,
                                 default = newJBool(true))
  if valid_589253 != nil:
    section.add "prettyPrint", valid_589253
  var valid_589254 = query.getOrDefault("filter")
  valid_589254 = validateParameter(valid_589254, JString, required = false,
                                 default = nil)
  if valid_589254 != nil:
    section.add "filter", valid_589254
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589255: Call_DeploymentmanagerManifestsList_589239; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all manifests for a given deployment.
  ## 
  let valid = call_589255.validator(path, query, header, formData, body)
  let scheme = call_589255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589255.url(scheme.get, call_589255.host, call_589255.base,
                         call_589255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589255, url, valid)

proc call*(call_589256: Call_DeploymentmanagerManifestsList_589239;
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
  var path_589257 = newJObject()
  var query_589258 = newJObject()
  add(path_589257, "deployment", newJString(deployment))
  add(query_589258, "fields", newJString(fields))
  add(query_589258, "pageToken", newJString(pageToken))
  add(query_589258, "quotaUser", newJString(quotaUser))
  add(query_589258, "alt", newJString(alt))
  add(query_589258, "oauth_token", newJString(oauthToken))
  add(query_589258, "userIp", newJString(userIp))
  add(query_589258, "maxResults", newJInt(maxResults))
  add(query_589258, "orderBy", newJString(orderBy))
  add(query_589258, "key", newJString(key))
  add(path_589257, "project", newJString(project))
  add(query_589258, "prettyPrint", newJBool(prettyPrint))
  add(query_589258, "filter", newJString(filter))
  result = call_589256.call(path_589257, query_589258, nil, nil, nil)

var deploymentmanagerManifestsList* = Call_DeploymentmanagerManifestsList_589239(
    name: "deploymentmanagerManifestsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}/manifests",
    validator: validate_DeploymentmanagerManifestsList_589240,
    base: "/deploymentmanager/v2beta/projects",
    url: url_DeploymentmanagerManifestsList_589241, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerManifestsGet_589259 = ref object of OpenApiRestCall_588466
proc url_DeploymentmanagerManifestsGet_589261(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerManifestsGet_589260(path: JsonNode; query: JsonNode;
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
  var valid_589262 = path.getOrDefault("deployment")
  valid_589262 = validateParameter(valid_589262, JString, required = true,
                                 default = nil)
  if valid_589262 != nil:
    section.add "deployment", valid_589262
  var valid_589263 = path.getOrDefault("project")
  valid_589263 = validateParameter(valid_589263, JString, required = true,
                                 default = nil)
  if valid_589263 != nil:
    section.add "project", valid_589263
  var valid_589264 = path.getOrDefault("manifest")
  valid_589264 = validateParameter(valid_589264, JString, required = true,
                                 default = nil)
  if valid_589264 != nil:
    section.add "manifest", valid_589264
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
  var valid_589265 = query.getOrDefault("fields")
  valid_589265 = validateParameter(valid_589265, JString, required = false,
                                 default = nil)
  if valid_589265 != nil:
    section.add "fields", valid_589265
  var valid_589266 = query.getOrDefault("quotaUser")
  valid_589266 = validateParameter(valid_589266, JString, required = false,
                                 default = nil)
  if valid_589266 != nil:
    section.add "quotaUser", valid_589266
  var valid_589267 = query.getOrDefault("alt")
  valid_589267 = validateParameter(valid_589267, JString, required = false,
                                 default = newJString("json"))
  if valid_589267 != nil:
    section.add "alt", valid_589267
  var valid_589268 = query.getOrDefault("oauth_token")
  valid_589268 = validateParameter(valid_589268, JString, required = false,
                                 default = nil)
  if valid_589268 != nil:
    section.add "oauth_token", valid_589268
  var valid_589269 = query.getOrDefault("userIp")
  valid_589269 = validateParameter(valid_589269, JString, required = false,
                                 default = nil)
  if valid_589269 != nil:
    section.add "userIp", valid_589269
  var valid_589270 = query.getOrDefault("key")
  valid_589270 = validateParameter(valid_589270, JString, required = false,
                                 default = nil)
  if valid_589270 != nil:
    section.add "key", valid_589270
  var valid_589271 = query.getOrDefault("prettyPrint")
  valid_589271 = validateParameter(valid_589271, JBool, required = false,
                                 default = newJBool(true))
  if valid_589271 != nil:
    section.add "prettyPrint", valid_589271
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589272: Call_DeploymentmanagerManifestsGet_589259; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a specific manifest.
  ## 
  let valid = call_589272.validator(path, query, header, formData, body)
  let scheme = call_589272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589272.url(scheme.get, call_589272.host, call_589272.base,
                         call_589272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589272, url, valid)

proc call*(call_589273: Call_DeploymentmanagerManifestsGet_589259;
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
  var path_589274 = newJObject()
  var query_589275 = newJObject()
  add(path_589274, "deployment", newJString(deployment))
  add(query_589275, "fields", newJString(fields))
  add(query_589275, "quotaUser", newJString(quotaUser))
  add(query_589275, "alt", newJString(alt))
  add(query_589275, "oauth_token", newJString(oauthToken))
  add(query_589275, "userIp", newJString(userIp))
  add(query_589275, "key", newJString(key))
  add(path_589274, "project", newJString(project))
  add(query_589275, "prettyPrint", newJBool(prettyPrint))
  add(path_589274, "manifest", newJString(manifest))
  result = call_589273.call(path_589274, query_589275, nil, nil, nil)

var deploymentmanagerManifestsGet* = Call_DeploymentmanagerManifestsGet_589259(
    name: "deploymentmanagerManifestsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}/manifests/{manifest}",
    validator: validate_DeploymentmanagerManifestsGet_589260,
    base: "/deploymentmanager/v2beta/projects",
    url: url_DeploymentmanagerManifestsGet_589261, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerResourcesList_589276 = ref object of OpenApiRestCall_588466
proc url_DeploymentmanagerResourcesList_589278(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerResourcesList_589277(path: JsonNode;
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
  var valid_589279 = path.getOrDefault("deployment")
  valid_589279 = validateParameter(valid_589279, JString, required = true,
                                 default = nil)
  if valid_589279 != nil:
    section.add "deployment", valid_589279
  var valid_589280 = path.getOrDefault("project")
  valid_589280 = validateParameter(valid_589280, JString, required = true,
                                 default = nil)
  if valid_589280 != nil:
    section.add "project", valid_589280
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
  var valid_589281 = query.getOrDefault("fields")
  valid_589281 = validateParameter(valid_589281, JString, required = false,
                                 default = nil)
  if valid_589281 != nil:
    section.add "fields", valid_589281
  var valid_589282 = query.getOrDefault("pageToken")
  valid_589282 = validateParameter(valid_589282, JString, required = false,
                                 default = nil)
  if valid_589282 != nil:
    section.add "pageToken", valid_589282
  var valid_589283 = query.getOrDefault("quotaUser")
  valid_589283 = validateParameter(valid_589283, JString, required = false,
                                 default = nil)
  if valid_589283 != nil:
    section.add "quotaUser", valid_589283
  var valid_589284 = query.getOrDefault("alt")
  valid_589284 = validateParameter(valid_589284, JString, required = false,
                                 default = newJString("json"))
  if valid_589284 != nil:
    section.add "alt", valid_589284
  var valid_589285 = query.getOrDefault("oauth_token")
  valid_589285 = validateParameter(valid_589285, JString, required = false,
                                 default = nil)
  if valid_589285 != nil:
    section.add "oauth_token", valid_589285
  var valid_589286 = query.getOrDefault("userIp")
  valid_589286 = validateParameter(valid_589286, JString, required = false,
                                 default = nil)
  if valid_589286 != nil:
    section.add "userIp", valid_589286
  var valid_589287 = query.getOrDefault("maxResults")
  valid_589287 = validateParameter(valid_589287, JInt, required = false,
                                 default = newJInt(500))
  if valid_589287 != nil:
    section.add "maxResults", valid_589287
  var valid_589288 = query.getOrDefault("orderBy")
  valid_589288 = validateParameter(valid_589288, JString, required = false,
                                 default = nil)
  if valid_589288 != nil:
    section.add "orderBy", valid_589288
  var valid_589289 = query.getOrDefault("key")
  valid_589289 = validateParameter(valid_589289, JString, required = false,
                                 default = nil)
  if valid_589289 != nil:
    section.add "key", valid_589289
  var valid_589290 = query.getOrDefault("prettyPrint")
  valid_589290 = validateParameter(valid_589290, JBool, required = false,
                                 default = newJBool(true))
  if valid_589290 != nil:
    section.add "prettyPrint", valid_589290
  var valid_589291 = query.getOrDefault("filter")
  valid_589291 = validateParameter(valid_589291, JString, required = false,
                                 default = nil)
  if valid_589291 != nil:
    section.add "filter", valid_589291
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589292: Call_DeploymentmanagerResourcesList_589276; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all resources in a given deployment.
  ## 
  let valid = call_589292.validator(path, query, header, formData, body)
  let scheme = call_589292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589292.url(scheme.get, call_589292.host, call_589292.base,
                         call_589292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589292, url, valid)

proc call*(call_589293: Call_DeploymentmanagerResourcesList_589276;
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
  var path_589294 = newJObject()
  var query_589295 = newJObject()
  add(path_589294, "deployment", newJString(deployment))
  add(query_589295, "fields", newJString(fields))
  add(query_589295, "pageToken", newJString(pageToken))
  add(query_589295, "quotaUser", newJString(quotaUser))
  add(query_589295, "alt", newJString(alt))
  add(query_589295, "oauth_token", newJString(oauthToken))
  add(query_589295, "userIp", newJString(userIp))
  add(query_589295, "maxResults", newJInt(maxResults))
  add(query_589295, "orderBy", newJString(orderBy))
  add(query_589295, "key", newJString(key))
  add(path_589294, "project", newJString(project))
  add(query_589295, "prettyPrint", newJBool(prettyPrint))
  add(query_589295, "filter", newJString(filter))
  result = call_589293.call(path_589294, query_589295, nil, nil, nil)

var deploymentmanagerResourcesList* = Call_DeploymentmanagerResourcesList_589276(
    name: "deploymentmanagerResourcesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}/resources",
    validator: validate_DeploymentmanagerResourcesList_589277,
    base: "/deploymentmanager/v2beta/projects",
    url: url_DeploymentmanagerResourcesList_589278, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerResourcesGet_589296 = ref object of OpenApiRestCall_588466
proc url_DeploymentmanagerResourcesGet_589298(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerResourcesGet_589297(path: JsonNode; query: JsonNode;
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
  var valid_589299 = path.getOrDefault("deployment")
  valid_589299 = validateParameter(valid_589299, JString, required = true,
                                 default = nil)
  if valid_589299 != nil:
    section.add "deployment", valid_589299
  var valid_589300 = path.getOrDefault("resource")
  valid_589300 = validateParameter(valid_589300, JString, required = true,
                                 default = nil)
  if valid_589300 != nil:
    section.add "resource", valid_589300
  var valid_589301 = path.getOrDefault("project")
  valid_589301 = validateParameter(valid_589301, JString, required = true,
                                 default = nil)
  if valid_589301 != nil:
    section.add "project", valid_589301
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
  var valid_589302 = query.getOrDefault("fields")
  valid_589302 = validateParameter(valid_589302, JString, required = false,
                                 default = nil)
  if valid_589302 != nil:
    section.add "fields", valid_589302
  var valid_589303 = query.getOrDefault("quotaUser")
  valid_589303 = validateParameter(valid_589303, JString, required = false,
                                 default = nil)
  if valid_589303 != nil:
    section.add "quotaUser", valid_589303
  var valid_589304 = query.getOrDefault("alt")
  valid_589304 = validateParameter(valid_589304, JString, required = false,
                                 default = newJString("json"))
  if valid_589304 != nil:
    section.add "alt", valid_589304
  var valid_589305 = query.getOrDefault("oauth_token")
  valid_589305 = validateParameter(valid_589305, JString, required = false,
                                 default = nil)
  if valid_589305 != nil:
    section.add "oauth_token", valid_589305
  var valid_589306 = query.getOrDefault("userIp")
  valid_589306 = validateParameter(valid_589306, JString, required = false,
                                 default = nil)
  if valid_589306 != nil:
    section.add "userIp", valid_589306
  var valid_589307 = query.getOrDefault("key")
  valid_589307 = validateParameter(valid_589307, JString, required = false,
                                 default = nil)
  if valid_589307 != nil:
    section.add "key", valid_589307
  var valid_589308 = query.getOrDefault("prettyPrint")
  valid_589308 = validateParameter(valid_589308, JBool, required = false,
                                 default = newJBool(true))
  if valid_589308 != nil:
    section.add "prettyPrint", valid_589308
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589309: Call_DeploymentmanagerResourcesGet_589296; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a single resource.
  ## 
  let valid = call_589309.validator(path, query, header, formData, body)
  let scheme = call_589309.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589309.url(scheme.get, call_589309.host, call_589309.base,
                         call_589309.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589309, url, valid)

proc call*(call_589310: Call_DeploymentmanagerResourcesGet_589296;
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
  var path_589311 = newJObject()
  var query_589312 = newJObject()
  add(path_589311, "deployment", newJString(deployment))
  add(query_589312, "fields", newJString(fields))
  add(query_589312, "quotaUser", newJString(quotaUser))
  add(query_589312, "alt", newJString(alt))
  add(query_589312, "oauth_token", newJString(oauthToken))
  add(query_589312, "userIp", newJString(userIp))
  add(query_589312, "key", newJString(key))
  add(path_589311, "resource", newJString(resource))
  add(path_589311, "project", newJString(project))
  add(query_589312, "prettyPrint", newJBool(prettyPrint))
  result = call_589310.call(path_589311, query_589312, nil, nil, nil)

var deploymentmanagerResourcesGet* = Call_DeploymentmanagerResourcesGet_589296(
    name: "deploymentmanagerResourcesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}/resources/{resource}",
    validator: validate_DeploymentmanagerResourcesGet_589297,
    base: "/deploymentmanager/v2beta/projects",
    url: url_DeploymentmanagerResourcesGet_589298, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsStop_589313 = ref object of OpenApiRestCall_588466
proc url_DeploymentmanagerDeploymentsStop_589315(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerDeploymentsStop_589314(path: JsonNode;
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
  var valid_589316 = path.getOrDefault("deployment")
  valid_589316 = validateParameter(valid_589316, JString, required = true,
                                 default = nil)
  if valid_589316 != nil:
    section.add "deployment", valid_589316
  var valid_589317 = path.getOrDefault("project")
  valid_589317 = validateParameter(valid_589317, JString, required = true,
                                 default = nil)
  if valid_589317 != nil:
    section.add "project", valid_589317
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
  var valid_589318 = query.getOrDefault("fields")
  valid_589318 = validateParameter(valid_589318, JString, required = false,
                                 default = nil)
  if valid_589318 != nil:
    section.add "fields", valid_589318
  var valid_589319 = query.getOrDefault("quotaUser")
  valid_589319 = validateParameter(valid_589319, JString, required = false,
                                 default = nil)
  if valid_589319 != nil:
    section.add "quotaUser", valid_589319
  var valid_589320 = query.getOrDefault("alt")
  valid_589320 = validateParameter(valid_589320, JString, required = false,
                                 default = newJString("json"))
  if valid_589320 != nil:
    section.add "alt", valid_589320
  var valid_589321 = query.getOrDefault("oauth_token")
  valid_589321 = validateParameter(valid_589321, JString, required = false,
                                 default = nil)
  if valid_589321 != nil:
    section.add "oauth_token", valid_589321
  var valid_589322 = query.getOrDefault("userIp")
  valid_589322 = validateParameter(valid_589322, JString, required = false,
                                 default = nil)
  if valid_589322 != nil:
    section.add "userIp", valid_589322
  var valid_589323 = query.getOrDefault("key")
  valid_589323 = validateParameter(valid_589323, JString, required = false,
                                 default = nil)
  if valid_589323 != nil:
    section.add "key", valid_589323
  var valid_589324 = query.getOrDefault("prettyPrint")
  valid_589324 = validateParameter(valid_589324, JBool, required = false,
                                 default = newJBool(true))
  if valid_589324 != nil:
    section.add "prettyPrint", valid_589324
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

proc call*(call_589326: Call_DeploymentmanagerDeploymentsStop_589313;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Stops an ongoing operation. This does not roll back any work that has already been completed, but prevents any new work from being started.
  ## 
  let valid = call_589326.validator(path, query, header, formData, body)
  let scheme = call_589326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589326.url(scheme.get, call_589326.host, call_589326.base,
                         call_589326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589326, url, valid)

proc call*(call_589327: Call_DeploymentmanagerDeploymentsStop_589313;
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
  var path_589328 = newJObject()
  var query_589329 = newJObject()
  var body_589330 = newJObject()
  add(path_589328, "deployment", newJString(deployment))
  add(query_589329, "fields", newJString(fields))
  add(query_589329, "quotaUser", newJString(quotaUser))
  add(query_589329, "alt", newJString(alt))
  add(query_589329, "oauth_token", newJString(oauthToken))
  add(query_589329, "userIp", newJString(userIp))
  add(query_589329, "key", newJString(key))
  add(path_589328, "project", newJString(project))
  if body != nil:
    body_589330 = body
  add(query_589329, "prettyPrint", newJBool(prettyPrint))
  result = call_589327.call(path_589328, query_589329, nil, nil, body_589330)

var deploymentmanagerDeploymentsStop* = Call_DeploymentmanagerDeploymentsStop_589313(
    name: "deploymentmanagerDeploymentsStop", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{deployment}/stop",
    validator: validate_DeploymentmanagerDeploymentsStop_589314,
    base: "/deploymentmanager/v2beta/projects",
    url: url_DeploymentmanagerDeploymentsStop_589315, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsGetIamPolicy_589331 = ref object of OpenApiRestCall_588466
proc url_DeploymentmanagerDeploymentsGetIamPolicy_589333(protocol: Scheme;
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

proc validate_DeploymentmanagerDeploymentsGetIamPolicy_589332(path: JsonNode;
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
  var valid_589334 = path.getOrDefault("resource")
  valid_589334 = validateParameter(valid_589334, JString, required = true,
                                 default = nil)
  if valid_589334 != nil:
    section.add "resource", valid_589334
  var valid_589335 = path.getOrDefault("project")
  valid_589335 = validateParameter(valid_589335, JString, required = true,
                                 default = nil)
  if valid_589335 != nil:
    section.add "project", valid_589335
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
  var valid_589336 = query.getOrDefault("fields")
  valid_589336 = validateParameter(valid_589336, JString, required = false,
                                 default = nil)
  if valid_589336 != nil:
    section.add "fields", valid_589336
  var valid_589337 = query.getOrDefault("quotaUser")
  valid_589337 = validateParameter(valid_589337, JString, required = false,
                                 default = nil)
  if valid_589337 != nil:
    section.add "quotaUser", valid_589337
  var valid_589338 = query.getOrDefault("alt")
  valid_589338 = validateParameter(valid_589338, JString, required = false,
                                 default = newJString("json"))
  if valid_589338 != nil:
    section.add "alt", valid_589338
  var valid_589339 = query.getOrDefault("oauth_token")
  valid_589339 = validateParameter(valid_589339, JString, required = false,
                                 default = nil)
  if valid_589339 != nil:
    section.add "oauth_token", valid_589339
  var valid_589340 = query.getOrDefault("userIp")
  valid_589340 = validateParameter(valid_589340, JString, required = false,
                                 default = nil)
  if valid_589340 != nil:
    section.add "userIp", valid_589340
  var valid_589341 = query.getOrDefault("key")
  valid_589341 = validateParameter(valid_589341, JString, required = false,
                                 default = nil)
  if valid_589341 != nil:
    section.add "key", valid_589341
  var valid_589342 = query.getOrDefault("prettyPrint")
  valid_589342 = validateParameter(valid_589342, JBool, required = false,
                                 default = newJBool(true))
  if valid_589342 != nil:
    section.add "prettyPrint", valid_589342
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589343: Call_DeploymentmanagerDeploymentsGetIamPolicy_589331;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a resource. May be empty if no such policy or resource exists.
  ## 
  let valid = call_589343.validator(path, query, header, formData, body)
  let scheme = call_589343.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589343.url(scheme.get, call_589343.host, call_589343.base,
                         call_589343.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589343, url, valid)

proc call*(call_589344: Call_DeploymentmanagerDeploymentsGetIamPolicy_589331;
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
  var path_589345 = newJObject()
  var query_589346 = newJObject()
  add(query_589346, "fields", newJString(fields))
  add(query_589346, "quotaUser", newJString(quotaUser))
  add(query_589346, "alt", newJString(alt))
  add(query_589346, "oauth_token", newJString(oauthToken))
  add(query_589346, "userIp", newJString(userIp))
  add(query_589346, "key", newJString(key))
  add(path_589345, "resource", newJString(resource))
  add(path_589345, "project", newJString(project))
  add(query_589346, "prettyPrint", newJBool(prettyPrint))
  result = call_589344.call(path_589345, query_589346, nil, nil, nil)

var deploymentmanagerDeploymentsGetIamPolicy* = Call_DeploymentmanagerDeploymentsGetIamPolicy_589331(
    name: "deploymentmanagerDeploymentsGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{resource}/getIamPolicy",
    validator: validate_DeploymentmanagerDeploymentsGetIamPolicy_589332,
    base: "/deploymentmanager/v2beta/projects",
    url: url_DeploymentmanagerDeploymentsGetIamPolicy_589333,
    schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsSetIamPolicy_589347 = ref object of OpenApiRestCall_588466
proc url_DeploymentmanagerDeploymentsSetIamPolicy_589349(protocol: Scheme;
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

proc validate_DeploymentmanagerDeploymentsSetIamPolicy_589348(path: JsonNode;
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
  var valid_589350 = path.getOrDefault("resource")
  valid_589350 = validateParameter(valid_589350, JString, required = true,
                                 default = nil)
  if valid_589350 != nil:
    section.add "resource", valid_589350
  var valid_589351 = path.getOrDefault("project")
  valid_589351 = validateParameter(valid_589351, JString, required = true,
                                 default = nil)
  if valid_589351 != nil:
    section.add "project", valid_589351
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
  var valid_589352 = query.getOrDefault("fields")
  valid_589352 = validateParameter(valid_589352, JString, required = false,
                                 default = nil)
  if valid_589352 != nil:
    section.add "fields", valid_589352
  var valid_589353 = query.getOrDefault("quotaUser")
  valid_589353 = validateParameter(valid_589353, JString, required = false,
                                 default = nil)
  if valid_589353 != nil:
    section.add "quotaUser", valid_589353
  var valid_589354 = query.getOrDefault("alt")
  valid_589354 = validateParameter(valid_589354, JString, required = false,
                                 default = newJString("json"))
  if valid_589354 != nil:
    section.add "alt", valid_589354
  var valid_589355 = query.getOrDefault("oauth_token")
  valid_589355 = validateParameter(valid_589355, JString, required = false,
                                 default = nil)
  if valid_589355 != nil:
    section.add "oauth_token", valid_589355
  var valid_589356 = query.getOrDefault("userIp")
  valid_589356 = validateParameter(valid_589356, JString, required = false,
                                 default = nil)
  if valid_589356 != nil:
    section.add "userIp", valid_589356
  var valid_589357 = query.getOrDefault("key")
  valid_589357 = validateParameter(valid_589357, JString, required = false,
                                 default = nil)
  if valid_589357 != nil:
    section.add "key", valid_589357
  var valid_589358 = query.getOrDefault("prettyPrint")
  valid_589358 = validateParameter(valid_589358, JBool, required = false,
                                 default = newJBool(true))
  if valid_589358 != nil:
    section.add "prettyPrint", valid_589358
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

proc call*(call_589360: Call_DeploymentmanagerDeploymentsSetIamPolicy_589347;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified resource. Replaces any existing policy.
  ## 
  let valid = call_589360.validator(path, query, header, formData, body)
  let scheme = call_589360.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589360.url(scheme.get, call_589360.host, call_589360.base,
                         call_589360.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589360, url, valid)

proc call*(call_589361: Call_DeploymentmanagerDeploymentsSetIamPolicy_589347;
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
  var path_589362 = newJObject()
  var query_589363 = newJObject()
  var body_589364 = newJObject()
  add(query_589363, "fields", newJString(fields))
  add(query_589363, "quotaUser", newJString(quotaUser))
  add(query_589363, "alt", newJString(alt))
  add(query_589363, "oauth_token", newJString(oauthToken))
  add(query_589363, "userIp", newJString(userIp))
  add(query_589363, "key", newJString(key))
  add(path_589362, "resource", newJString(resource))
  add(path_589362, "project", newJString(project))
  if body != nil:
    body_589364 = body
  add(query_589363, "prettyPrint", newJBool(prettyPrint))
  result = call_589361.call(path_589362, query_589363, nil, nil, body_589364)

var deploymentmanagerDeploymentsSetIamPolicy* = Call_DeploymentmanagerDeploymentsSetIamPolicy_589347(
    name: "deploymentmanagerDeploymentsSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/{project}/global/deployments/{resource}/setIamPolicy",
    validator: validate_DeploymentmanagerDeploymentsSetIamPolicy_589348,
    base: "/deploymentmanager/v2beta/projects",
    url: url_DeploymentmanagerDeploymentsSetIamPolicy_589349,
    schemes: {Scheme.Https})
type
  Call_DeploymentmanagerDeploymentsTestIamPermissions_589365 = ref object of OpenApiRestCall_588466
proc url_DeploymentmanagerDeploymentsTestIamPermissions_589367(protocol: Scheme;
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

proc validate_DeploymentmanagerDeploymentsTestIamPermissions_589366(
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
  var valid_589368 = path.getOrDefault("resource")
  valid_589368 = validateParameter(valid_589368, JString, required = true,
                                 default = nil)
  if valid_589368 != nil:
    section.add "resource", valid_589368
  var valid_589369 = path.getOrDefault("project")
  valid_589369 = validateParameter(valid_589369, JString, required = true,
                                 default = nil)
  if valid_589369 != nil:
    section.add "project", valid_589369
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
  var valid_589370 = query.getOrDefault("fields")
  valid_589370 = validateParameter(valid_589370, JString, required = false,
                                 default = nil)
  if valid_589370 != nil:
    section.add "fields", valid_589370
  var valid_589371 = query.getOrDefault("quotaUser")
  valid_589371 = validateParameter(valid_589371, JString, required = false,
                                 default = nil)
  if valid_589371 != nil:
    section.add "quotaUser", valid_589371
  var valid_589372 = query.getOrDefault("alt")
  valid_589372 = validateParameter(valid_589372, JString, required = false,
                                 default = newJString("json"))
  if valid_589372 != nil:
    section.add "alt", valid_589372
  var valid_589373 = query.getOrDefault("oauth_token")
  valid_589373 = validateParameter(valid_589373, JString, required = false,
                                 default = nil)
  if valid_589373 != nil:
    section.add "oauth_token", valid_589373
  var valid_589374 = query.getOrDefault("userIp")
  valid_589374 = validateParameter(valid_589374, JString, required = false,
                                 default = nil)
  if valid_589374 != nil:
    section.add "userIp", valid_589374
  var valid_589375 = query.getOrDefault("key")
  valid_589375 = validateParameter(valid_589375, JString, required = false,
                                 default = nil)
  if valid_589375 != nil:
    section.add "key", valid_589375
  var valid_589376 = query.getOrDefault("prettyPrint")
  valid_589376 = validateParameter(valid_589376, JBool, required = false,
                                 default = newJBool(true))
  if valid_589376 != nil:
    section.add "prettyPrint", valid_589376
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

proc call*(call_589378: Call_DeploymentmanagerDeploymentsTestIamPermissions_589365;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that a caller has on the specified resource.
  ## 
  let valid = call_589378.validator(path, query, header, formData, body)
  let scheme = call_589378.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589378.url(scheme.get, call_589378.host, call_589378.base,
                         call_589378.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589378, url, valid)

proc call*(call_589379: Call_DeploymentmanagerDeploymentsTestIamPermissions_589365;
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
  var path_589380 = newJObject()
  var query_589381 = newJObject()
  var body_589382 = newJObject()
  add(query_589381, "fields", newJString(fields))
  add(query_589381, "quotaUser", newJString(quotaUser))
  add(query_589381, "alt", newJString(alt))
  add(query_589381, "oauth_token", newJString(oauthToken))
  add(query_589381, "userIp", newJString(userIp))
  add(query_589381, "key", newJString(key))
  add(path_589380, "resource", newJString(resource))
  add(path_589380, "project", newJString(project))
  if body != nil:
    body_589382 = body
  add(query_589381, "prettyPrint", newJBool(prettyPrint))
  result = call_589379.call(path_589380, query_589381, nil, nil, body_589382)

var deploymentmanagerDeploymentsTestIamPermissions* = Call_DeploymentmanagerDeploymentsTestIamPermissions_589365(
    name: "deploymentmanagerDeploymentsTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/{project}/global/deployments/{resource}/testIamPermissions",
    validator: validate_DeploymentmanagerDeploymentsTestIamPermissions_589366,
    base: "/deploymentmanager/v2beta/projects",
    url: url_DeploymentmanagerDeploymentsTestIamPermissions_589367,
    schemes: {Scheme.Https})
type
  Call_DeploymentmanagerOperationsList_589383 = ref object of OpenApiRestCall_588466
proc url_DeploymentmanagerOperationsList_589385(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerOperationsList_589384(path: JsonNode;
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
  var valid_589386 = path.getOrDefault("project")
  valid_589386 = validateParameter(valid_589386, JString, required = true,
                                 default = nil)
  if valid_589386 != nil:
    section.add "project", valid_589386
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
  var valid_589387 = query.getOrDefault("fields")
  valid_589387 = validateParameter(valid_589387, JString, required = false,
                                 default = nil)
  if valid_589387 != nil:
    section.add "fields", valid_589387
  var valid_589388 = query.getOrDefault("pageToken")
  valid_589388 = validateParameter(valid_589388, JString, required = false,
                                 default = nil)
  if valid_589388 != nil:
    section.add "pageToken", valid_589388
  var valid_589389 = query.getOrDefault("quotaUser")
  valid_589389 = validateParameter(valid_589389, JString, required = false,
                                 default = nil)
  if valid_589389 != nil:
    section.add "quotaUser", valid_589389
  var valid_589390 = query.getOrDefault("alt")
  valid_589390 = validateParameter(valid_589390, JString, required = false,
                                 default = newJString("json"))
  if valid_589390 != nil:
    section.add "alt", valid_589390
  var valid_589391 = query.getOrDefault("oauth_token")
  valid_589391 = validateParameter(valid_589391, JString, required = false,
                                 default = nil)
  if valid_589391 != nil:
    section.add "oauth_token", valid_589391
  var valid_589392 = query.getOrDefault("userIp")
  valid_589392 = validateParameter(valid_589392, JString, required = false,
                                 default = nil)
  if valid_589392 != nil:
    section.add "userIp", valid_589392
  var valid_589393 = query.getOrDefault("maxResults")
  valid_589393 = validateParameter(valid_589393, JInt, required = false,
                                 default = newJInt(500))
  if valid_589393 != nil:
    section.add "maxResults", valid_589393
  var valid_589394 = query.getOrDefault("orderBy")
  valid_589394 = validateParameter(valid_589394, JString, required = false,
                                 default = nil)
  if valid_589394 != nil:
    section.add "orderBy", valid_589394
  var valid_589395 = query.getOrDefault("key")
  valid_589395 = validateParameter(valid_589395, JString, required = false,
                                 default = nil)
  if valid_589395 != nil:
    section.add "key", valid_589395
  var valid_589396 = query.getOrDefault("prettyPrint")
  valid_589396 = validateParameter(valid_589396, JBool, required = false,
                                 default = newJBool(true))
  if valid_589396 != nil:
    section.add "prettyPrint", valid_589396
  var valid_589397 = query.getOrDefault("filter")
  valid_589397 = validateParameter(valid_589397, JString, required = false,
                                 default = nil)
  if valid_589397 != nil:
    section.add "filter", valid_589397
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589398: Call_DeploymentmanagerOperationsList_589383;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all operations for a project.
  ## 
  let valid = call_589398.validator(path, query, header, formData, body)
  let scheme = call_589398.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589398.url(scheme.get, call_589398.host, call_589398.base,
                         call_589398.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589398, url, valid)

proc call*(call_589399: Call_DeploymentmanagerOperationsList_589383;
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
  var path_589400 = newJObject()
  var query_589401 = newJObject()
  add(query_589401, "fields", newJString(fields))
  add(query_589401, "pageToken", newJString(pageToken))
  add(query_589401, "quotaUser", newJString(quotaUser))
  add(query_589401, "alt", newJString(alt))
  add(query_589401, "oauth_token", newJString(oauthToken))
  add(query_589401, "userIp", newJString(userIp))
  add(query_589401, "maxResults", newJInt(maxResults))
  add(query_589401, "orderBy", newJString(orderBy))
  add(query_589401, "key", newJString(key))
  add(path_589400, "project", newJString(project))
  add(query_589401, "prettyPrint", newJBool(prettyPrint))
  add(query_589401, "filter", newJString(filter))
  result = call_589399.call(path_589400, query_589401, nil, nil, nil)

var deploymentmanagerOperationsList* = Call_DeploymentmanagerOperationsList_589383(
    name: "deploymentmanagerOperationsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/operations",
    validator: validate_DeploymentmanagerOperationsList_589384,
    base: "/deploymentmanager/v2beta/projects",
    url: url_DeploymentmanagerOperationsList_589385, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerOperationsGet_589402 = ref object of OpenApiRestCall_588466
proc url_DeploymentmanagerOperationsGet_589404(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerOperationsGet_589403(path: JsonNode;
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
  var valid_589405 = path.getOrDefault("operation")
  valid_589405 = validateParameter(valid_589405, JString, required = true,
                                 default = nil)
  if valid_589405 != nil:
    section.add "operation", valid_589405
  var valid_589406 = path.getOrDefault("project")
  valid_589406 = validateParameter(valid_589406, JString, required = true,
                                 default = nil)
  if valid_589406 != nil:
    section.add "project", valid_589406
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
  var valid_589407 = query.getOrDefault("fields")
  valid_589407 = validateParameter(valid_589407, JString, required = false,
                                 default = nil)
  if valid_589407 != nil:
    section.add "fields", valid_589407
  var valid_589408 = query.getOrDefault("quotaUser")
  valid_589408 = validateParameter(valid_589408, JString, required = false,
                                 default = nil)
  if valid_589408 != nil:
    section.add "quotaUser", valid_589408
  var valid_589409 = query.getOrDefault("alt")
  valid_589409 = validateParameter(valid_589409, JString, required = false,
                                 default = newJString("json"))
  if valid_589409 != nil:
    section.add "alt", valid_589409
  var valid_589410 = query.getOrDefault("oauth_token")
  valid_589410 = validateParameter(valid_589410, JString, required = false,
                                 default = nil)
  if valid_589410 != nil:
    section.add "oauth_token", valid_589410
  var valid_589411 = query.getOrDefault("userIp")
  valid_589411 = validateParameter(valid_589411, JString, required = false,
                                 default = nil)
  if valid_589411 != nil:
    section.add "userIp", valid_589411
  var valid_589412 = query.getOrDefault("key")
  valid_589412 = validateParameter(valid_589412, JString, required = false,
                                 default = nil)
  if valid_589412 != nil:
    section.add "key", valid_589412
  var valid_589413 = query.getOrDefault("prettyPrint")
  valid_589413 = validateParameter(valid_589413, JBool, required = false,
                                 default = newJBool(true))
  if valid_589413 != nil:
    section.add "prettyPrint", valid_589413
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589414: Call_DeploymentmanagerOperationsGet_589402; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about a specific operation.
  ## 
  let valid = call_589414.validator(path, query, header, formData, body)
  let scheme = call_589414.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589414.url(scheme.get, call_589414.host, call_589414.base,
                         call_589414.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589414, url, valid)

proc call*(call_589415: Call_DeploymentmanagerOperationsGet_589402;
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
  var path_589416 = newJObject()
  var query_589417 = newJObject()
  add(query_589417, "fields", newJString(fields))
  add(query_589417, "quotaUser", newJString(quotaUser))
  add(query_589417, "alt", newJString(alt))
  add(path_589416, "operation", newJString(operation))
  add(query_589417, "oauth_token", newJString(oauthToken))
  add(query_589417, "userIp", newJString(userIp))
  add(query_589417, "key", newJString(key))
  add(path_589416, "project", newJString(project))
  add(query_589417, "prettyPrint", newJBool(prettyPrint))
  result = call_589415.call(path_589416, query_589417, nil, nil, nil)

var deploymentmanagerOperationsGet* = Call_DeploymentmanagerOperationsGet_589402(
    name: "deploymentmanagerOperationsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/operations/{operation}",
    validator: validate_DeploymentmanagerOperationsGet_589403,
    base: "/deploymentmanager/v2beta/projects",
    url: url_DeploymentmanagerOperationsGet_589404, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerTypeProvidersInsert_589437 = ref object of OpenApiRestCall_588466
proc url_DeploymentmanagerTypeProvidersInsert_589439(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/typeProviders")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerTypeProvidersInsert_589438(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a type provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_589440 = path.getOrDefault("project")
  valid_589440 = validateParameter(valid_589440, JString, required = true,
                                 default = nil)
  if valid_589440 != nil:
    section.add "project", valid_589440
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
  var valid_589441 = query.getOrDefault("fields")
  valid_589441 = validateParameter(valid_589441, JString, required = false,
                                 default = nil)
  if valid_589441 != nil:
    section.add "fields", valid_589441
  var valid_589442 = query.getOrDefault("quotaUser")
  valid_589442 = validateParameter(valid_589442, JString, required = false,
                                 default = nil)
  if valid_589442 != nil:
    section.add "quotaUser", valid_589442
  var valid_589443 = query.getOrDefault("alt")
  valid_589443 = validateParameter(valid_589443, JString, required = false,
                                 default = newJString("json"))
  if valid_589443 != nil:
    section.add "alt", valid_589443
  var valid_589444 = query.getOrDefault("oauth_token")
  valid_589444 = validateParameter(valid_589444, JString, required = false,
                                 default = nil)
  if valid_589444 != nil:
    section.add "oauth_token", valid_589444
  var valid_589445 = query.getOrDefault("userIp")
  valid_589445 = validateParameter(valid_589445, JString, required = false,
                                 default = nil)
  if valid_589445 != nil:
    section.add "userIp", valid_589445
  var valid_589446 = query.getOrDefault("key")
  valid_589446 = validateParameter(valid_589446, JString, required = false,
                                 default = nil)
  if valid_589446 != nil:
    section.add "key", valid_589446
  var valid_589447 = query.getOrDefault("prettyPrint")
  valid_589447 = validateParameter(valid_589447, JBool, required = false,
                                 default = newJBool(true))
  if valid_589447 != nil:
    section.add "prettyPrint", valid_589447
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

proc call*(call_589449: Call_DeploymentmanagerTypeProvidersInsert_589437;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a type provider.
  ## 
  let valid = call_589449.validator(path, query, header, formData, body)
  let scheme = call_589449.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589449.url(scheme.get, call_589449.host, call_589449.base,
                         call_589449.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589449, url, valid)

proc call*(call_589450: Call_DeploymentmanagerTypeProvidersInsert_589437;
          project: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## deploymentmanagerTypeProvidersInsert
  ## Creates a type provider.
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
  var path_589451 = newJObject()
  var query_589452 = newJObject()
  var body_589453 = newJObject()
  add(query_589452, "fields", newJString(fields))
  add(query_589452, "quotaUser", newJString(quotaUser))
  add(query_589452, "alt", newJString(alt))
  add(query_589452, "oauth_token", newJString(oauthToken))
  add(query_589452, "userIp", newJString(userIp))
  add(query_589452, "key", newJString(key))
  add(path_589451, "project", newJString(project))
  if body != nil:
    body_589453 = body
  add(query_589452, "prettyPrint", newJBool(prettyPrint))
  result = call_589450.call(path_589451, query_589452, nil, nil, body_589453)

var deploymentmanagerTypeProvidersInsert* = Call_DeploymentmanagerTypeProvidersInsert_589437(
    name: "deploymentmanagerTypeProvidersInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/{project}/global/typeProviders",
    validator: validate_DeploymentmanagerTypeProvidersInsert_589438,
    base: "/deploymentmanager/v2beta/projects",
    url: url_DeploymentmanagerTypeProvidersInsert_589439, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerTypeProvidersList_589418 = ref object of OpenApiRestCall_588466
proc url_DeploymentmanagerTypeProvidersList_589420(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/typeProviders")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerTypeProvidersList_589419(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all resource type providers for Deployment Manager.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `project` field"
  var valid_589421 = path.getOrDefault("project")
  valid_589421 = validateParameter(valid_589421, JString, required = true,
                                 default = nil)
  if valid_589421 != nil:
    section.add "project", valid_589421
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
  var valid_589422 = query.getOrDefault("fields")
  valid_589422 = validateParameter(valid_589422, JString, required = false,
                                 default = nil)
  if valid_589422 != nil:
    section.add "fields", valid_589422
  var valid_589423 = query.getOrDefault("pageToken")
  valid_589423 = validateParameter(valid_589423, JString, required = false,
                                 default = nil)
  if valid_589423 != nil:
    section.add "pageToken", valid_589423
  var valid_589424 = query.getOrDefault("quotaUser")
  valid_589424 = validateParameter(valid_589424, JString, required = false,
                                 default = nil)
  if valid_589424 != nil:
    section.add "quotaUser", valid_589424
  var valid_589425 = query.getOrDefault("alt")
  valid_589425 = validateParameter(valid_589425, JString, required = false,
                                 default = newJString("json"))
  if valid_589425 != nil:
    section.add "alt", valid_589425
  var valid_589426 = query.getOrDefault("oauth_token")
  valid_589426 = validateParameter(valid_589426, JString, required = false,
                                 default = nil)
  if valid_589426 != nil:
    section.add "oauth_token", valid_589426
  var valid_589427 = query.getOrDefault("userIp")
  valid_589427 = validateParameter(valid_589427, JString, required = false,
                                 default = nil)
  if valid_589427 != nil:
    section.add "userIp", valid_589427
  var valid_589428 = query.getOrDefault("maxResults")
  valid_589428 = validateParameter(valid_589428, JInt, required = false,
                                 default = newJInt(500))
  if valid_589428 != nil:
    section.add "maxResults", valid_589428
  var valid_589429 = query.getOrDefault("orderBy")
  valid_589429 = validateParameter(valid_589429, JString, required = false,
                                 default = nil)
  if valid_589429 != nil:
    section.add "orderBy", valid_589429
  var valid_589430 = query.getOrDefault("key")
  valid_589430 = validateParameter(valid_589430, JString, required = false,
                                 default = nil)
  if valid_589430 != nil:
    section.add "key", valid_589430
  var valid_589431 = query.getOrDefault("prettyPrint")
  valid_589431 = validateParameter(valid_589431, JBool, required = false,
                                 default = newJBool(true))
  if valid_589431 != nil:
    section.add "prettyPrint", valid_589431
  var valid_589432 = query.getOrDefault("filter")
  valid_589432 = validateParameter(valid_589432, JString, required = false,
                                 default = nil)
  if valid_589432 != nil:
    section.add "filter", valid_589432
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589433: Call_DeploymentmanagerTypeProvidersList_589418;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all resource type providers for Deployment Manager.
  ## 
  let valid = call_589433.validator(path, query, header, formData, body)
  let scheme = call_589433.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589433.url(scheme.get, call_589433.host, call_589433.base,
                         call_589433.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589433, url, valid)

proc call*(call_589434: Call_DeploymentmanagerTypeProvidersList_589418;
          project: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 500; orderBy: string = "";
          key: string = ""; prettyPrint: bool = true; filter: string = ""): Recallable =
  ## deploymentmanagerTypeProvidersList
  ## Lists all resource type providers for Deployment Manager.
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
  var path_589435 = newJObject()
  var query_589436 = newJObject()
  add(query_589436, "fields", newJString(fields))
  add(query_589436, "pageToken", newJString(pageToken))
  add(query_589436, "quotaUser", newJString(quotaUser))
  add(query_589436, "alt", newJString(alt))
  add(query_589436, "oauth_token", newJString(oauthToken))
  add(query_589436, "userIp", newJString(userIp))
  add(query_589436, "maxResults", newJInt(maxResults))
  add(query_589436, "orderBy", newJString(orderBy))
  add(query_589436, "key", newJString(key))
  add(path_589435, "project", newJString(project))
  add(query_589436, "prettyPrint", newJBool(prettyPrint))
  add(query_589436, "filter", newJString(filter))
  result = call_589434.call(path_589435, query_589436, nil, nil, nil)

var deploymentmanagerTypeProvidersList* = Call_DeploymentmanagerTypeProvidersList_589418(
    name: "deploymentmanagerTypeProvidersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/typeProviders",
    validator: validate_DeploymentmanagerTypeProvidersList_589419,
    base: "/deploymentmanager/v2beta/projects",
    url: url_DeploymentmanagerTypeProvidersList_589420, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerTypeProvidersUpdate_589470 = ref object of OpenApiRestCall_588466
proc url_DeploymentmanagerTypeProvidersUpdate_589472(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "typeProvider" in path, "`typeProvider` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/typeProviders/"),
               (kind: VariableSegment, value: "typeProvider")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerTypeProvidersUpdate_589471(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a type provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   typeProvider: JString (required)
  ##               : The name of the type provider for this request.
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `typeProvider` field"
  var valid_589473 = path.getOrDefault("typeProvider")
  valid_589473 = validateParameter(valid_589473, JString, required = true,
                                 default = nil)
  if valid_589473 != nil:
    section.add "typeProvider", valid_589473
  var valid_589474 = path.getOrDefault("project")
  valid_589474 = validateParameter(valid_589474, JString, required = true,
                                 default = nil)
  if valid_589474 != nil:
    section.add "project", valid_589474
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
  var valid_589475 = query.getOrDefault("fields")
  valid_589475 = validateParameter(valid_589475, JString, required = false,
                                 default = nil)
  if valid_589475 != nil:
    section.add "fields", valid_589475
  var valid_589476 = query.getOrDefault("quotaUser")
  valid_589476 = validateParameter(valid_589476, JString, required = false,
                                 default = nil)
  if valid_589476 != nil:
    section.add "quotaUser", valid_589476
  var valid_589477 = query.getOrDefault("alt")
  valid_589477 = validateParameter(valid_589477, JString, required = false,
                                 default = newJString("json"))
  if valid_589477 != nil:
    section.add "alt", valid_589477
  var valid_589478 = query.getOrDefault("oauth_token")
  valid_589478 = validateParameter(valid_589478, JString, required = false,
                                 default = nil)
  if valid_589478 != nil:
    section.add "oauth_token", valid_589478
  var valid_589479 = query.getOrDefault("userIp")
  valid_589479 = validateParameter(valid_589479, JString, required = false,
                                 default = nil)
  if valid_589479 != nil:
    section.add "userIp", valid_589479
  var valid_589480 = query.getOrDefault("key")
  valid_589480 = validateParameter(valid_589480, JString, required = false,
                                 default = nil)
  if valid_589480 != nil:
    section.add "key", valid_589480
  var valid_589481 = query.getOrDefault("prettyPrint")
  valid_589481 = validateParameter(valid_589481, JBool, required = false,
                                 default = newJBool(true))
  if valid_589481 != nil:
    section.add "prettyPrint", valid_589481
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

proc call*(call_589483: Call_DeploymentmanagerTypeProvidersUpdate_589470;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a type provider.
  ## 
  let valid = call_589483.validator(path, query, header, formData, body)
  let scheme = call_589483.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589483.url(scheme.get, call_589483.host, call_589483.base,
                         call_589483.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589483, url, valid)

proc call*(call_589484: Call_DeploymentmanagerTypeProvidersUpdate_589470;
          typeProvider: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## deploymentmanagerTypeProvidersUpdate
  ## Updates a type provider.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   typeProvider: string (required)
  ##               : The name of the type provider for this request.
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
  var path_589485 = newJObject()
  var query_589486 = newJObject()
  var body_589487 = newJObject()
  add(query_589486, "fields", newJString(fields))
  add(query_589486, "quotaUser", newJString(quotaUser))
  add(query_589486, "alt", newJString(alt))
  add(path_589485, "typeProvider", newJString(typeProvider))
  add(query_589486, "oauth_token", newJString(oauthToken))
  add(query_589486, "userIp", newJString(userIp))
  add(query_589486, "key", newJString(key))
  add(path_589485, "project", newJString(project))
  if body != nil:
    body_589487 = body
  add(query_589486, "prettyPrint", newJBool(prettyPrint))
  result = call_589484.call(path_589485, query_589486, nil, nil, body_589487)

var deploymentmanagerTypeProvidersUpdate* = Call_DeploymentmanagerTypeProvidersUpdate_589470(
    name: "deploymentmanagerTypeProvidersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/{project}/global/typeProviders/{typeProvider}",
    validator: validate_DeploymentmanagerTypeProvidersUpdate_589471,
    base: "/deploymentmanager/v2beta/projects",
    url: url_DeploymentmanagerTypeProvidersUpdate_589472, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerTypeProvidersGet_589454 = ref object of OpenApiRestCall_588466
proc url_DeploymentmanagerTypeProvidersGet_589456(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "typeProvider" in path, "`typeProvider` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/typeProviders/"),
               (kind: VariableSegment, value: "typeProvider")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerTypeProvidersGet_589455(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about a specific type provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   typeProvider: JString (required)
  ##               : The name of the type provider for this request.
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `typeProvider` field"
  var valid_589457 = path.getOrDefault("typeProvider")
  valid_589457 = validateParameter(valid_589457, JString, required = true,
                                 default = nil)
  if valid_589457 != nil:
    section.add "typeProvider", valid_589457
  var valid_589458 = path.getOrDefault("project")
  valid_589458 = validateParameter(valid_589458, JString, required = true,
                                 default = nil)
  if valid_589458 != nil:
    section.add "project", valid_589458
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
  var valid_589459 = query.getOrDefault("fields")
  valid_589459 = validateParameter(valid_589459, JString, required = false,
                                 default = nil)
  if valid_589459 != nil:
    section.add "fields", valid_589459
  var valid_589460 = query.getOrDefault("quotaUser")
  valid_589460 = validateParameter(valid_589460, JString, required = false,
                                 default = nil)
  if valid_589460 != nil:
    section.add "quotaUser", valid_589460
  var valid_589461 = query.getOrDefault("alt")
  valid_589461 = validateParameter(valid_589461, JString, required = false,
                                 default = newJString("json"))
  if valid_589461 != nil:
    section.add "alt", valid_589461
  var valid_589462 = query.getOrDefault("oauth_token")
  valid_589462 = validateParameter(valid_589462, JString, required = false,
                                 default = nil)
  if valid_589462 != nil:
    section.add "oauth_token", valid_589462
  var valid_589463 = query.getOrDefault("userIp")
  valid_589463 = validateParameter(valid_589463, JString, required = false,
                                 default = nil)
  if valid_589463 != nil:
    section.add "userIp", valid_589463
  var valid_589464 = query.getOrDefault("key")
  valid_589464 = validateParameter(valid_589464, JString, required = false,
                                 default = nil)
  if valid_589464 != nil:
    section.add "key", valid_589464
  var valid_589465 = query.getOrDefault("prettyPrint")
  valid_589465 = validateParameter(valid_589465, JBool, required = false,
                                 default = newJBool(true))
  if valid_589465 != nil:
    section.add "prettyPrint", valid_589465
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589466: Call_DeploymentmanagerTypeProvidersGet_589454;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information about a specific type provider.
  ## 
  let valid = call_589466.validator(path, query, header, formData, body)
  let scheme = call_589466.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589466.url(scheme.get, call_589466.host, call_589466.base,
                         call_589466.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589466, url, valid)

proc call*(call_589467: Call_DeploymentmanagerTypeProvidersGet_589454;
          typeProvider: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## deploymentmanagerTypeProvidersGet
  ## Gets information about a specific type provider.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   typeProvider: string (required)
  ##               : The name of the type provider for this request.
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
  var path_589468 = newJObject()
  var query_589469 = newJObject()
  add(query_589469, "fields", newJString(fields))
  add(query_589469, "quotaUser", newJString(quotaUser))
  add(query_589469, "alt", newJString(alt))
  add(path_589468, "typeProvider", newJString(typeProvider))
  add(query_589469, "oauth_token", newJString(oauthToken))
  add(query_589469, "userIp", newJString(userIp))
  add(query_589469, "key", newJString(key))
  add(path_589468, "project", newJString(project))
  add(query_589469, "prettyPrint", newJBool(prettyPrint))
  result = call_589467.call(path_589468, query_589469, nil, nil, nil)

var deploymentmanagerTypeProvidersGet* = Call_DeploymentmanagerTypeProvidersGet_589454(
    name: "deploymentmanagerTypeProvidersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/typeProviders/{typeProvider}",
    validator: validate_DeploymentmanagerTypeProvidersGet_589455,
    base: "/deploymentmanager/v2beta/projects",
    url: url_DeploymentmanagerTypeProvidersGet_589456, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerTypeProvidersPatch_589504 = ref object of OpenApiRestCall_588466
proc url_DeploymentmanagerTypeProvidersPatch_589506(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "typeProvider" in path, "`typeProvider` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/typeProviders/"),
               (kind: VariableSegment, value: "typeProvider")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerTypeProvidersPatch_589505(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a type provider. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   typeProvider: JString (required)
  ##               : The name of the type provider for this request.
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `typeProvider` field"
  var valid_589507 = path.getOrDefault("typeProvider")
  valid_589507 = validateParameter(valid_589507, JString, required = true,
                                 default = nil)
  if valid_589507 != nil:
    section.add "typeProvider", valid_589507
  var valid_589508 = path.getOrDefault("project")
  valid_589508 = validateParameter(valid_589508, JString, required = true,
                                 default = nil)
  if valid_589508 != nil:
    section.add "project", valid_589508
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
  var valid_589509 = query.getOrDefault("fields")
  valid_589509 = validateParameter(valid_589509, JString, required = false,
                                 default = nil)
  if valid_589509 != nil:
    section.add "fields", valid_589509
  var valid_589510 = query.getOrDefault("quotaUser")
  valid_589510 = validateParameter(valid_589510, JString, required = false,
                                 default = nil)
  if valid_589510 != nil:
    section.add "quotaUser", valid_589510
  var valid_589511 = query.getOrDefault("alt")
  valid_589511 = validateParameter(valid_589511, JString, required = false,
                                 default = newJString("json"))
  if valid_589511 != nil:
    section.add "alt", valid_589511
  var valid_589512 = query.getOrDefault("oauth_token")
  valid_589512 = validateParameter(valid_589512, JString, required = false,
                                 default = nil)
  if valid_589512 != nil:
    section.add "oauth_token", valid_589512
  var valid_589513 = query.getOrDefault("userIp")
  valid_589513 = validateParameter(valid_589513, JString, required = false,
                                 default = nil)
  if valid_589513 != nil:
    section.add "userIp", valid_589513
  var valid_589514 = query.getOrDefault("key")
  valid_589514 = validateParameter(valid_589514, JString, required = false,
                                 default = nil)
  if valid_589514 != nil:
    section.add "key", valid_589514
  var valid_589515 = query.getOrDefault("prettyPrint")
  valid_589515 = validateParameter(valid_589515, JBool, required = false,
                                 default = newJBool(true))
  if valid_589515 != nil:
    section.add "prettyPrint", valid_589515
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

proc call*(call_589517: Call_DeploymentmanagerTypeProvidersPatch_589504;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a type provider. This method supports patch semantics.
  ## 
  let valid = call_589517.validator(path, query, header, formData, body)
  let scheme = call_589517.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589517.url(scheme.get, call_589517.host, call_589517.base,
                         call_589517.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589517, url, valid)

proc call*(call_589518: Call_DeploymentmanagerTypeProvidersPatch_589504;
          typeProvider: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## deploymentmanagerTypeProvidersPatch
  ## Updates a type provider. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   typeProvider: string (required)
  ##               : The name of the type provider for this request.
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
  var path_589519 = newJObject()
  var query_589520 = newJObject()
  var body_589521 = newJObject()
  add(query_589520, "fields", newJString(fields))
  add(query_589520, "quotaUser", newJString(quotaUser))
  add(query_589520, "alt", newJString(alt))
  add(path_589519, "typeProvider", newJString(typeProvider))
  add(query_589520, "oauth_token", newJString(oauthToken))
  add(query_589520, "userIp", newJString(userIp))
  add(query_589520, "key", newJString(key))
  add(path_589519, "project", newJString(project))
  if body != nil:
    body_589521 = body
  add(query_589520, "prettyPrint", newJBool(prettyPrint))
  result = call_589518.call(path_589519, query_589520, nil, nil, body_589521)

var deploymentmanagerTypeProvidersPatch* = Call_DeploymentmanagerTypeProvidersPatch_589504(
    name: "deploymentmanagerTypeProvidersPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/{project}/global/typeProviders/{typeProvider}",
    validator: validate_DeploymentmanagerTypeProvidersPatch_589505,
    base: "/deploymentmanager/v2beta/projects",
    url: url_DeploymentmanagerTypeProvidersPatch_589506, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerTypeProvidersDelete_589488 = ref object of OpenApiRestCall_588466
proc url_DeploymentmanagerTypeProvidersDelete_589490(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "typeProvider" in path, "`typeProvider` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/typeProviders/"),
               (kind: VariableSegment, value: "typeProvider")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerTypeProvidersDelete_589489(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a type provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   typeProvider: JString (required)
  ##               : The name of the type provider for this request.
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `typeProvider` field"
  var valid_589491 = path.getOrDefault("typeProvider")
  valid_589491 = validateParameter(valid_589491, JString, required = true,
                                 default = nil)
  if valid_589491 != nil:
    section.add "typeProvider", valid_589491
  var valid_589492 = path.getOrDefault("project")
  valid_589492 = validateParameter(valid_589492, JString, required = true,
                                 default = nil)
  if valid_589492 != nil:
    section.add "project", valid_589492
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
  var valid_589493 = query.getOrDefault("fields")
  valid_589493 = validateParameter(valid_589493, JString, required = false,
                                 default = nil)
  if valid_589493 != nil:
    section.add "fields", valid_589493
  var valid_589494 = query.getOrDefault("quotaUser")
  valid_589494 = validateParameter(valid_589494, JString, required = false,
                                 default = nil)
  if valid_589494 != nil:
    section.add "quotaUser", valid_589494
  var valid_589495 = query.getOrDefault("alt")
  valid_589495 = validateParameter(valid_589495, JString, required = false,
                                 default = newJString("json"))
  if valid_589495 != nil:
    section.add "alt", valid_589495
  var valid_589496 = query.getOrDefault("oauth_token")
  valid_589496 = validateParameter(valid_589496, JString, required = false,
                                 default = nil)
  if valid_589496 != nil:
    section.add "oauth_token", valid_589496
  var valid_589497 = query.getOrDefault("userIp")
  valid_589497 = validateParameter(valid_589497, JString, required = false,
                                 default = nil)
  if valid_589497 != nil:
    section.add "userIp", valid_589497
  var valid_589498 = query.getOrDefault("key")
  valid_589498 = validateParameter(valid_589498, JString, required = false,
                                 default = nil)
  if valid_589498 != nil:
    section.add "key", valid_589498
  var valid_589499 = query.getOrDefault("prettyPrint")
  valid_589499 = validateParameter(valid_589499, JBool, required = false,
                                 default = newJBool(true))
  if valid_589499 != nil:
    section.add "prettyPrint", valid_589499
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589500: Call_DeploymentmanagerTypeProvidersDelete_589488;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a type provider.
  ## 
  let valid = call_589500.validator(path, query, header, formData, body)
  let scheme = call_589500.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589500.url(scheme.get, call_589500.host, call_589500.base,
                         call_589500.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589500, url, valid)

proc call*(call_589501: Call_DeploymentmanagerTypeProvidersDelete_589488;
          typeProvider: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## deploymentmanagerTypeProvidersDelete
  ## Deletes a type provider.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   typeProvider: string (required)
  ##               : The name of the type provider for this request.
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
  var path_589502 = newJObject()
  var query_589503 = newJObject()
  add(query_589503, "fields", newJString(fields))
  add(query_589503, "quotaUser", newJString(quotaUser))
  add(query_589503, "alt", newJString(alt))
  add(path_589502, "typeProvider", newJString(typeProvider))
  add(query_589503, "oauth_token", newJString(oauthToken))
  add(query_589503, "userIp", newJString(userIp))
  add(query_589503, "key", newJString(key))
  add(path_589502, "project", newJString(project))
  add(query_589503, "prettyPrint", newJBool(prettyPrint))
  result = call_589501.call(path_589502, query_589503, nil, nil, nil)

var deploymentmanagerTypeProvidersDelete* = Call_DeploymentmanagerTypeProvidersDelete_589488(
    name: "deploymentmanagerTypeProvidersDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/{project}/global/typeProviders/{typeProvider}",
    validator: validate_DeploymentmanagerTypeProvidersDelete_589489,
    base: "/deploymentmanager/v2beta/projects",
    url: url_DeploymentmanagerTypeProvidersDelete_589490, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerTypeProvidersListTypes_589522 = ref object of OpenApiRestCall_588466
proc url_DeploymentmanagerTypeProvidersListTypes_589524(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "typeProvider" in path, "`typeProvider` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/typeProviders/"),
               (kind: VariableSegment, value: "typeProvider"),
               (kind: ConstantSegment, value: "/types")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerTypeProvidersListTypes_589523(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the type info for a TypeProvider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   typeProvider: JString (required)
  ##               : The name of the type provider for this request.
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `typeProvider` field"
  var valid_589525 = path.getOrDefault("typeProvider")
  valid_589525 = validateParameter(valid_589525, JString, required = true,
                                 default = nil)
  if valid_589525 != nil:
    section.add "typeProvider", valid_589525
  var valid_589526 = path.getOrDefault("project")
  valid_589526 = validateParameter(valid_589526, JString, required = true,
                                 default = nil)
  if valid_589526 != nil:
    section.add "project", valid_589526
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
  var valid_589527 = query.getOrDefault("fields")
  valid_589527 = validateParameter(valid_589527, JString, required = false,
                                 default = nil)
  if valid_589527 != nil:
    section.add "fields", valid_589527
  var valid_589528 = query.getOrDefault("pageToken")
  valid_589528 = validateParameter(valid_589528, JString, required = false,
                                 default = nil)
  if valid_589528 != nil:
    section.add "pageToken", valid_589528
  var valid_589529 = query.getOrDefault("quotaUser")
  valid_589529 = validateParameter(valid_589529, JString, required = false,
                                 default = nil)
  if valid_589529 != nil:
    section.add "quotaUser", valid_589529
  var valid_589530 = query.getOrDefault("alt")
  valid_589530 = validateParameter(valid_589530, JString, required = false,
                                 default = newJString("json"))
  if valid_589530 != nil:
    section.add "alt", valid_589530
  var valid_589531 = query.getOrDefault("oauth_token")
  valid_589531 = validateParameter(valid_589531, JString, required = false,
                                 default = nil)
  if valid_589531 != nil:
    section.add "oauth_token", valid_589531
  var valid_589532 = query.getOrDefault("userIp")
  valid_589532 = validateParameter(valid_589532, JString, required = false,
                                 default = nil)
  if valid_589532 != nil:
    section.add "userIp", valid_589532
  var valid_589533 = query.getOrDefault("maxResults")
  valid_589533 = validateParameter(valid_589533, JInt, required = false,
                                 default = newJInt(500))
  if valid_589533 != nil:
    section.add "maxResults", valid_589533
  var valid_589534 = query.getOrDefault("orderBy")
  valid_589534 = validateParameter(valid_589534, JString, required = false,
                                 default = nil)
  if valid_589534 != nil:
    section.add "orderBy", valid_589534
  var valid_589535 = query.getOrDefault("key")
  valid_589535 = validateParameter(valid_589535, JString, required = false,
                                 default = nil)
  if valid_589535 != nil:
    section.add "key", valid_589535
  var valid_589536 = query.getOrDefault("prettyPrint")
  valid_589536 = validateParameter(valid_589536, JBool, required = false,
                                 default = newJBool(true))
  if valid_589536 != nil:
    section.add "prettyPrint", valid_589536
  var valid_589537 = query.getOrDefault("filter")
  valid_589537 = validateParameter(valid_589537, JString, required = false,
                                 default = nil)
  if valid_589537 != nil:
    section.add "filter", valid_589537
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589538: Call_DeploymentmanagerTypeProvidersListTypes_589522;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the type info for a TypeProvider.
  ## 
  let valid = call_589538.validator(path, query, header, formData, body)
  let scheme = call_589538.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589538.url(scheme.get, call_589538.host, call_589538.base,
                         call_589538.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589538, url, valid)

proc call*(call_589539: Call_DeploymentmanagerTypeProvidersListTypes_589522;
          typeProvider: string; project: string; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 500;
          orderBy: string = ""; key: string = ""; prettyPrint: bool = true;
          filter: string = ""): Recallable =
  ## deploymentmanagerTypeProvidersListTypes
  ## Lists all the type info for a TypeProvider.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list request to get the next page of results.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   typeProvider: string (required)
  ##               : The name of the type provider for this request.
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
  var path_589540 = newJObject()
  var query_589541 = newJObject()
  add(query_589541, "fields", newJString(fields))
  add(query_589541, "pageToken", newJString(pageToken))
  add(query_589541, "quotaUser", newJString(quotaUser))
  add(query_589541, "alt", newJString(alt))
  add(path_589540, "typeProvider", newJString(typeProvider))
  add(query_589541, "oauth_token", newJString(oauthToken))
  add(query_589541, "userIp", newJString(userIp))
  add(query_589541, "maxResults", newJInt(maxResults))
  add(query_589541, "orderBy", newJString(orderBy))
  add(query_589541, "key", newJString(key))
  add(path_589540, "project", newJString(project))
  add(query_589541, "prettyPrint", newJBool(prettyPrint))
  add(query_589541, "filter", newJString(filter))
  result = call_589539.call(path_589540, query_589541, nil, nil, nil)

var deploymentmanagerTypeProvidersListTypes* = Call_DeploymentmanagerTypeProvidersListTypes_589522(
    name: "deploymentmanagerTypeProvidersListTypes", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/typeProviders/{typeProvider}/types",
    validator: validate_DeploymentmanagerTypeProvidersListTypes_589523,
    base: "/deploymentmanager/v2beta/projects",
    url: url_DeploymentmanagerTypeProvidersListTypes_589524,
    schemes: {Scheme.Https})
type
  Call_DeploymentmanagerTypeProvidersGetType_589542 = ref object of OpenApiRestCall_588466
proc url_DeploymentmanagerTypeProvidersGetType_589544(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "project" in path, "`project` is a required path parameter"
  assert "typeProvider" in path, "`typeProvider` is a required path parameter"
  assert "type" in path, "`type` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "project"),
               (kind: ConstantSegment, value: "/global/typeProviders/"),
               (kind: VariableSegment, value: "typeProvider"),
               (kind: ConstantSegment, value: "/types/"),
               (kind: VariableSegment, value: "type")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentmanagerTypeProvidersGetType_589543(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a type info for a type provided by a TypeProvider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   type: JString (required)
  ##       : The name of the type provider type for this request.
  ##   typeProvider: JString (required)
  ##               : The name of the type provider for this request.
  ##   project: JString (required)
  ##          : The project ID for this request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `type` field"
  var valid_589545 = path.getOrDefault("type")
  valid_589545 = validateParameter(valid_589545, JString, required = true,
                                 default = nil)
  if valid_589545 != nil:
    section.add "type", valid_589545
  var valid_589546 = path.getOrDefault("typeProvider")
  valid_589546 = validateParameter(valid_589546, JString, required = true,
                                 default = nil)
  if valid_589546 != nil:
    section.add "typeProvider", valid_589546
  var valid_589547 = path.getOrDefault("project")
  valid_589547 = validateParameter(valid_589547, JString, required = true,
                                 default = nil)
  if valid_589547 != nil:
    section.add "project", valid_589547
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
  var valid_589548 = query.getOrDefault("fields")
  valid_589548 = validateParameter(valid_589548, JString, required = false,
                                 default = nil)
  if valid_589548 != nil:
    section.add "fields", valid_589548
  var valid_589549 = query.getOrDefault("quotaUser")
  valid_589549 = validateParameter(valid_589549, JString, required = false,
                                 default = nil)
  if valid_589549 != nil:
    section.add "quotaUser", valid_589549
  var valid_589550 = query.getOrDefault("alt")
  valid_589550 = validateParameter(valid_589550, JString, required = false,
                                 default = newJString("json"))
  if valid_589550 != nil:
    section.add "alt", valid_589550
  var valid_589551 = query.getOrDefault("oauth_token")
  valid_589551 = validateParameter(valid_589551, JString, required = false,
                                 default = nil)
  if valid_589551 != nil:
    section.add "oauth_token", valid_589551
  var valid_589552 = query.getOrDefault("userIp")
  valid_589552 = validateParameter(valid_589552, JString, required = false,
                                 default = nil)
  if valid_589552 != nil:
    section.add "userIp", valid_589552
  var valid_589553 = query.getOrDefault("key")
  valid_589553 = validateParameter(valid_589553, JString, required = false,
                                 default = nil)
  if valid_589553 != nil:
    section.add "key", valid_589553
  var valid_589554 = query.getOrDefault("prettyPrint")
  valid_589554 = validateParameter(valid_589554, JBool, required = false,
                                 default = newJBool(true))
  if valid_589554 != nil:
    section.add "prettyPrint", valid_589554
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589555: Call_DeploymentmanagerTypeProvidersGetType_589542;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a type info for a type provided by a TypeProvider.
  ## 
  let valid = call_589555.validator(path, query, header, formData, body)
  let scheme = call_589555.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589555.url(scheme.get, call_589555.host, call_589555.base,
                         call_589555.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589555, url, valid)

proc call*(call_589556: Call_DeploymentmanagerTypeProvidersGetType_589542;
          `type`: string; typeProvider: string; project: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## deploymentmanagerTypeProvidersGetType
  ## Gets a type info for a type provided by a TypeProvider.
  ##   type: string (required)
  ##       : The name of the type provider type for this request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   typeProvider: string (required)
  ##               : The name of the type provider for this request.
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
  var path_589557 = newJObject()
  var query_589558 = newJObject()
  add(path_589557, "type", newJString(`type`))
  add(query_589558, "fields", newJString(fields))
  add(query_589558, "quotaUser", newJString(quotaUser))
  add(query_589558, "alt", newJString(alt))
  add(path_589557, "typeProvider", newJString(typeProvider))
  add(query_589558, "oauth_token", newJString(oauthToken))
  add(query_589558, "userIp", newJString(userIp))
  add(query_589558, "key", newJString(key))
  add(path_589557, "project", newJString(project))
  add(query_589558, "prettyPrint", newJBool(prettyPrint))
  result = call_589556.call(path_589557, query_589558, nil, nil, nil)

var deploymentmanagerTypeProvidersGetType* = Call_DeploymentmanagerTypeProvidersGetType_589542(
    name: "deploymentmanagerTypeProvidersGetType", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/{project}/global/typeProviders/{typeProvider}/types/{type}",
    validator: validate_DeploymentmanagerTypeProvidersGetType_589543,
    base: "/deploymentmanager/v2beta/projects",
    url: url_DeploymentmanagerTypeProvidersGetType_589544, schemes: {Scheme.Https})
type
  Call_DeploymentmanagerTypesList_589559 = ref object of OpenApiRestCall_588466
proc url_DeploymentmanagerTypesList_589561(protocol: Scheme; host: string;
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

proc validate_DeploymentmanagerTypesList_589560(path: JsonNode; query: JsonNode;
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
  var valid_589562 = path.getOrDefault("project")
  valid_589562 = validateParameter(valid_589562, JString, required = true,
                                 default = nil)
  if valid_589562 != nil:
    section.add "project", valid_589562
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
  var valid_589563 = query.getOrDefault("fields")
  valid_589563 = validateParameter(valid_589563, JString, required = false,
                                 default = nil)
  if valid_589563 != nil:
    section.add "fields", valid_589563
  var valid_589564 = query.getOrDefault("pageToken")
  valid_589564 = validateParameter(valid_589564, JString, required = false,
                                 default = nil)
  if valid_589564 != nil:
    section.add "pageToken", valid_589564
  var valid_589565 = query.getOrDefault("quotaUser")
  valid_589565 = validateParameter(valid_589565, JString, required = false,
                                 default = nil)
  if valid_589565 != nil:
    section.add "quotaUser", valid_589565
  var valid_589566 = query.getOrDefault("alt")
  valid_589566 = validateParameter(valid_589566, JString, required = false,
                                 default = newJString("json"))
  if valid_589566 != nil:
    section.add "alt", valid_589566
  var valid_589567 = query.getOrDefault("oauth_token")
  valid_589567 = validateParameter(valid_589567, JString, required = false,
                                 default = nil)
  if valid_589567 != nil:
    section.add "oauth_token", valid_589567
  var valid_589568 = query.getOrDefault("userIp")
  valid_589568 = validateParameter(valid_589568, JString, required = false,
                                 default = nil)
  if valid_589568 != nil:
    section.add "userIp", valid_589568
  var valid_589569 = query.getOrDefault("maxResults")
  valid_589569 = validateParameter(valid_589569, JInt, required = false,
                                 default = newJInt(500))
  if valid_589569 != nil:
    section.add "maxResults", valid_589569
  var valid_589570 = query.getOrDefault("orderBy")
  valid_589570 = validateParameter(valid_589570, JString, required = false,
                                 default = nil)
  if valid_589570 != nil:
    section.add "orderBy", valid_589570
  var valid_589571 = query.getOrDefault("key")
  valid_589571 = validateParameter(valid_589571, JString, required = false,
                                 default = nil)
  if valid_589571 != nil:
    section.add "key", valid_589571
  var valid_589572 = query.getOrDefault("prettyPrint")
  valid_589572 = validateParameter(valid_589572, JBool, required = false,
                                 default = newJBool(true))
  if valid_589572 != nil:
    section.add "prettyPrint", valid_589572
  var valid_589573 = query.getOrDefault("filter")
  valid_589573 = validateParameter(valid_589573, JString, required = false,
                                 default = nil)
  if valid_589573 != nil:
    section.add "filter", valid_589573
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589574: Call_DeploymentmanagerTypesList_589559; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all resource types for Deployment Manager.
  ## 
  let valid = call_589574.validator(path, query, header, formData, body)
  let scheme = call_589574.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589574.url(scheme.get, call_589574.host, call_589574.base,
                         call_589574.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589574, url, valid)

proc call*(call_589575: Call_DeploymentmanagerTypesList_589559; project: string;
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
  var path_589576 = newJObject()
  var query_589577 = newJObject()
  add(query_589577, "fields", newJString(fields))
  add(query_589577, "pageToken", newJString(pageToken))
  add(query_589577, "quotaUser", newJString(quotaUser))
  add(query_589577, "alt", newJString(alt))
  add(query_589577, "oauth_token", newJString(oauthToken))
  add(query_589577, "userIp", newJString(userIp))
  add(query_589577, "maxResults", newJInt(maxResults))
  add(query_589577, "orderBy", newJString(orderBy))
  add(query_589577, "key", newJString(key))
  add(path_589576, "project", newJString(project))
  add(query_589577, "prettyPrint", newJBool(prettyPrint))
  add(query_589577, "filter", newJString(filter))
  result = call_589575.call(path_589576, query_589577, nil, nil, nil)

var deploymentmanagerTypesList* = Call_DeploymentmanagerTypesList_589559(
    name: "deploymentmanagerTypesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/{project}/global/types",
    validator: validate_DeploymentmanagerTypesList_589560,
    base: "/deploymentmanager/v2beta/projects",
    url: url_DeploymentmanagerTypesList_589561, schemes: {Scheme.Https})
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
