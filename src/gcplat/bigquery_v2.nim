
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: BigQuery
## version: v2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## A data platform for customers to create, manage, share and query data.
## 
## https://cloud.google.com/bigquery/
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
  gcpServiceName = "bigquery"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BigqueryProjectsList_588734 = ref object of OpenApiRestCall_588466
proc url_BigqueryProjectsList_588736(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BigqueryProjectsList_588735(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all projects to which you have been granted any project role.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Page token, returned by a previous call, to request the next page of results
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of results to return
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_588848 = query.getOrDefault("fields")
  valid_588848 = validateParameter(valid_588848, JString, required = false,
                                 default = nil)
  if valid_588848 != nil:
    section.add "fields", valid_588848
  var valid_588849 = query.getOrDefault("pageToken")
  valid_588849 = validateParameter(valid_588849, JString, required = false,
                                 default = nil)
  if valid_588849 != nil:
    section.add "pageToken", valid_588849
  var valid_588850 = query.getOrDefault("quotaUser")
  valid_588850 = validateParameter(valid_588850, JString, required = false,
                                 default = nil)
  if valid_588850 != nil:
    section.add "quotaUser", valid_588850
  var valid_588864 = query.getOrDefault("alt")
  valid_588864 = validateParameter(valid_588864, JString, required = false,
                                 default = newJString("json"))
  if valid_588864 != nil:
    section.add "alt", valid_588864
  var valid_588865 = query.getOrDefault("oauth_token")
  valid_588865 = validateParameter(valid_588865, JString, required = false,
                                 default = nil)
  if valid_588865 != nil:
    section.add "oauth_token", valid_588865
  var valid_588866 = query.getOrDefault("userIp")
  valid_588866 = validateParameter(valid_588866, JString, required = false,
                                 default = nil)
  if valid_588866 != nil:
    section.add "userIp", valid_588866
  var valid_588867 = query.getOrDefault("maxResults")
  valid_588867 = validateParameter(valid_588867, JInt, required = false, default = nil)
  if valid_588867 != nil:
    section.add "maxResults", valid_588867
  var valid_588868 = query.getOrDefault("key")
  valid_588868 = validateParameter(valid_588868, JString, required = false,
                                 default = nil)
  if valid_588868 != nil:
    section.add "key", valid_588868
  var valid_588869 = query.getOrDefault("prettyPrint")
  valid_588869 = validateParameter(valid_588869, JBool, required = false,
                                 default = newJBool(true))
  if valid_588869 != nil:
    section.add "prettyPrint", valid_588869
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588892: Call_BigqueryProjectsList_588734; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all projects to which you have been granted any project role.
  ## 
  let valid = call_588892.validator(path, query, header, formData, body)
  let scheme = call_588892.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588892.url(scheme.get, call_588892.host, call_588892.base,
                         call_588892.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588892, url, valid)

proc call*(call_588963: Call_BigqueryProjectsList_588734; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## bigqueryProjectsList
  ## Lists all projects to which you have been granted any project role.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Page token, returned by a previous call, to request the next page of results
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of results to return
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_588964 = newJObject()
  add(query_588964, "fields", newJString(fields))
  add(query_588964, "pageToken", newJString(pageToken))
  add(query_588964, "quotaUser", newJString(quotaUser))
  add(query_588964, "alt", newJString(alt))
  add(query_588964, "oauth_token", newJString(oauthToken))
  add(query_588964, "userIp", newJString(userIp))
  add(query_588964, "maxResults", newJInt(maxResults))
  add(query_588964, "key", newJString(key))
  add(query_588964, "prettyPrint", newJBool(prettyPrint))
  result = call_588963.call(nil, query_588964, nil, nil, nil)

var bigqueryProjectsList* = Call_BigqueryProjectsList_588734(
    name: "bigqueryProjectsList", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com", route: "/projects",
    validator: validate_BigqueryProjectsList_588735, base: "/bigquery/v2",
    url: url_BigqueryProjectsList_588736, schemes: {Scheme.Https})
type
  Call_BigqueryDatasetsInsert_589037 = ref object of OpenApiRestCall_588466
proc url_BigqueryDatasetsInsert_589039(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/datasets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigqueryDatasetsInsert_589038(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new empty dataset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Project ID of the new dataset
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_589040 = path.getOrDefault("projectId")
  valid_589040 = validateParameter(valid_589040, JString, required = true,
                                 default = nil)
  if valid_589040 != nil:
    section.add "projectId", valid_589040
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
  var valid_589041 = query.getOrDefault("fields")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "fields", valid_589041
  var valid_589042 = query.getOrDefault("quotaUser")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "quotaUser", valid_589042
  var valid_589043 = query.getOrDefault("alt")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = newJString("json"))
  if valid_589043 != nil:
    section.add "alt", valid_589043
  var valid_589044 = query.getOrDefault("oauth_token")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "oauth_token", valid_589044
  var valid_589045 = query.getOrDefault("userIp")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "userIp", valid_589045
  var valid_589046 = query.getOrDefault("key")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "key", valid_589046
  var valid_589047 = query.getOrDefault("prettyPrint")
  valid_589047 = validateParameter(valid_589047, JBool, required = false,
                                 default = newJBool(true))
  if valid_589047 != nil:
    section.add "prettyPrint", valid_589047
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

proc call*(call_589049: Call_BigqueryDatasetsInsert_589037; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new empty dataset.
  ## 
  let valid = call_589049.validator(path, query, header, formData, body)
  let scheme = call_589049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589049.url(scheme.get, call_589049.host, call_589049.base,
                         call_589049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589049, url, valid)

proc call*(call_589050: Call_BigqueryDatasetsInsert_589037; projectId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## bigqueryDatasetsInsert
  ## Creates a new empty dataset.
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
  ##   projectId: string (required)
  ##            : Project ID of the new dataset
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589051 = newJObject()
  var query_589052 = newJObject()
  var body_589053 = newJObject()
  add(query_589052, "fields", newJString(fields))
  add(query_589052, "quotaUser", newJString(quotaUser))
  add(query_589052, "alt", newJString(alt))
  add(query_589052, "oauth_token", newJString(oauthToken))
  add(query_589052, "userIp", newJString(userIp))
  add(query_589052, "key", newJString(key))
  add(path_589051, "projectId", newJString(projectId))
  if body != nil:
    body_589053 = body
  add(query_589052, "prettyPrint", newJBool(prettyPrint))
  result = call_589050.call(path_589051, query_589052, nil, nil, body_589053)

var bigqueryDatasetsInsert* = Call_BigqueryDatasetsInsert_589037(
    name: "bigqueryDatasetsInsert", meth: HttpMethod.HttpPost,
    host: "bigquery.googleapis.com", route: "/projects/{projectId}/datasets",
    validator: validate_BigqueryDatasetsInsert_589038, base: "/bigquery/v2",
    url: url_BigqueryDatasetsInsert_589039, schemes: {Scheme.Https})
type
  Call_BigqueryDatasetsList_589004 = ref object of OpenApiRestCall_588466
proc url_BigqueryDatasetsList_589006(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/datasets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigqueryDatasetsList_589005(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all datasets in the specified project to which you have been granted the READER dataset role.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Project ID of the datasets to be listed
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_589021 = path.getOrDefault("projectId")
  valid_589021 = validateParameter(valid_589021, JString, required = true,
                                 default = nil)
  if valid_589021 != nil:
    section.add "projectId", valid_589021
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Page token, returned by a previous call, to request the next page of results
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   all: JBool
  ##      : Whether to list all datasets, including hidden ones
  ##   maxResults: JInt
  ##             : The maximum number of results to return
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : An expression for filtering the results of the request by label. The syntax is "labels.<name>[:<value>]". Multiple filters can be ANDed together by connecting with a space. Example: "labels.department:receiving labels.active". See Filtering datasets using labels for details.
  section = newJObject()
  var valid_589022 = query.getOrDefault("fields")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = nil)
  if valid_589022 != nil:
    section.add "fields", valid_589022
  var valid_589023 = query.getOrDefault("pageToken")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = nil)
  if valid_589023 != nil:
    section.add "pageToken", valid_589023
  var valid_589024 = query.getOrDefault("quotaUser")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = nil)
  if valid_589024 != nil:
    section.add "quotaUser", valid_589024
  var valid_589025 = query.getOrDefault("alt")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = newJString("json"))
  if valid_589025 != nil:
    section.add "alt", valid_589025
  var valid_589026 = query.getOrDefault("oauth_token")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = nil)
  if valid_589026 != nil:
    section.add "oauth_token", valid_589026
  var valid_589027 = query.getOrDefault("userIp")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = nil)
  if valid_589027 != nil:
    section.add "userIp", valid_589027
  var valid_589028 = query.getOrDefault("all")
  valid_589028 = validateParameter(valid_589028, JBool, required = false, default = nil)
  if valid_589028 != nil:
    section.add "all", valid_589028
  var valid_589029 = query.getOrDefault("maxResults")
  valid_589029 = validateParameter(valid_589029, JInt, required = false, default = nil)
  if valid_589029 != nil:
    section.add "maxResults", valid_589029
  var valid_589030 = query.getOrDefault("key")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "key", valid_589030
  var valid_589031 = query.getOrDefault("prettyPrint")
  valid_589031 = validateParameter(valid_589031, JBool, required = false,
                                 default = newJBool(true))
  if valid_589031 != nil:
    section.add "prettyPrint", valid_589031
  var valid_589032 = query.getOrDefault("filter")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "filter", valid_589032
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589033: Call_BigqueryDatasetsList_589004; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all datasets in the specified project to which you have been granted the READER dataset role.
  ## 
  let valid = call_589033.validator(path, query, header, formData, body)
  let scheme = call_589033.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589033.url(scheme.get, call_589033.host, call_589033.base,
                         call_589033.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589033, url, valid)

proc call*(call_589034: Call_BigqueryDatasetsList_589004; projectId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          all: bool = false; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## bigqueryDatasetsList
  ## Lists all datasets in the specified project to which you have been granted the READER dataset role.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Page token, returned by a previous call, to request the next page of results
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   all: bool
  ##      : Whether to list all datasets, including hidden ones
  ##   maxResults: int
  ##             : The maximum number of results to return
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Project ID of the datasets to be listed
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : An expression for filtering the results of the request by label. The syntax is "labels.<name>[:<value>]". Multiple filters can be ANDed together by connecting with a space. Example: "labels.department:receiving labels.active". See Filtering datasets using labels for details.
  var path_589035 = newJObject()
  var query_589036 = newJObject()
  add(query_589036, "fields", newJString(fields))
  add(query_589036, "pageToken", newJString(pageToken))
  add(query_589036, "quotaUser", newJString(quotaUser))
  add(query_589036, "alt", newJString(alt))
  add(query_589036, "oauth_token", newJString(oauthToken))
  add(query_589036, "userIp", newJString(userIp))
  add(query_589036, "all", newJBool(all))
  add(query_589036, "maxResults", newJInt(maxResults))
  add(query_589036, "key", newJString(key))
  add(path_589035, "projectId", newJString(projectId))
  add(query_589036, "prettyPrint", newJBool(prettyPrint))
  add(query_589036, "filter", newJString(filter))
  result = call_589034.call(path_589035, query_589036, nil, nil, nil)

var bigqueryDatasetsList* = Call_BigqueryDatasetsList_589004(
    name: "bigqueryDatasetsList", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com", route: "/projects/{projectId}/datasets",
    validator: validate_BigqueryDatasetsList_589005, base: "/bigquery/v2",
    url: url_BigqueryDatasetsList_589006, schemes: {Scheme.Https})
type
  Call_BigqueryDatasetsUpdate_589070 = ref object of OpenApiRestCall_588466
proc url_BigqueryDatasetsUpdate_589072(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "datasetId" in path, "`datasetId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/datasets/"),
               (kind: VariableSegment, value: "datasetId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigqueryDatasetsUpdate_589071(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates information in an existing dataset. The update method replaces the entire dataset resource, whereas the patch method only replaces fields that are provided in the submitted dataset resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   datasetId: JString (required)
  ##            : Dataset ID of the dataset being updated
  ##   projectId: JString (required)
  ##            : Project ID of the dataset being updated
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `datasetId` field"
  var valid_589073 = path.getOrDefault("datasetId")
  valid_589073 = validateParameter(valid_589073, JString, required = true,
                                 default = nil)
  if valid_589073 != nil:
    section.add "datasetId", valid_589073
  var valid_589074 = path.getOrDefault("projectId")
  valid_589074 = validateParameter(valid_589074, JString, required = true,
                                 default = nil)
  if valid_589074 != nil:
    section.add "projectId", valid_589074
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
  var valid_589075 = query.getOrDefault("fields")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = nil)
  if valid_589075 != nil:
    section.add "fields", valid_589075
  var valid_589076 = query.getOrDefault("quotaUser")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "quotaUser", valid_589076
  var valid_589077 = query.getOrDefault("alt")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = newJString("json"))
  if valid_589077 != nil:
    section.add "alt", valid_589077
  var valid_589078 = query.getOrDefault("oauth_token")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = nil)
  if valid_589078 != nil:
    section.add "oauth_token", valid_589078
  var valid_589079 = query.getOrDefault("userIp")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = nil)
  if valid_589079 != nil:
    section.add "userIp", valid_589079
  var valid_589080 = query.getOrDefault("key")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "key", valid_589080
  var valid_589081 = query.getOrDefault("prettyPrint")
  valid_589081 = validateParameter(valid_589081, JBool, required = false,
                                 default = newJBool(true))
  if valid_589081 != nil:
    section.add "prettyPrint", valid_589081
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

proc call*(call_589083: Call_BigqueryDatasetsUpdate_589070; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates information in an existing dataset. The update method replaces the entire dataset resource, whereas the patch method only replaces fields that are provided in the submitted dataset resource.
  ## 
  let valid = call_589083.validator(path, query, header, formData, body)
  let scheme = call_589083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589083.url(scheme.get, call_589083.host, call_589083.base,
                         call_589083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589083, url, valid)

proc call*(call_589084: Call_BigqueryDatasetsUpdate_589070; datasetId: string;
          projectId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## bigqueryDatasetsUpdate
  ## Updates information in an existing dataset. The update method replaces the entire dataset resource, whereas the patch method only replaces fields that are provided in the submitted dataset resource.
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
  ##   datasetId: string (required)
  ##            : Dataset ID of the dataset being updated
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Project ID of the dataset being updated
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589085 = newJObject()
  var query_589086 = newJObject()
  var body_589087 = newJObject()
  add(query_589086, "fields", newJString(fields))
  add(query_589086, "quotaUser", newJString(quotaUser))
  add(query_589086, "alt", newJString(alt))
  add(query_589086, "oauth_token", newJString(oauthToken))
  add(query_589086, "userIp", newJString(userIp))
  add(path_589085, "datasetId", newJString(datasetId))
  add(query_589086, "key", newJString(key))
  add(path_589085, "projectId", newJString(projectId))
  if body != nil:
    body_589087 = body
  add(query_589086, "prettyPrint", newJBool(prettyPrint))
  result = call_589084.call(path_589085, query_589086, nil, nil, body_589087)

var bigqueryDatasetsUpdate* = Call_BigqueryDatasetsUpdate_589070(
    name: "bigqueryDatasetsUpdate", meth: HttpMethod.HttpPut,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}",
    validator: validate_BigqueryDatasetsUpdate_589071, base: "/bigquery/v2",
    url: url_BigqueryDatasetsUpdate_589072, schemes: {Scheme.Https})
type
  Call_BigqueryDatasetsGet_589054 = ref object of OpenApiRestCall_588466
proc url_BigqueryDatasetsGet_589056(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "datasetId" in path, "`datasetId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/datasets/"),
               (kind: VariableSegment, value: "datasetId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigqueryDatasetsGet_589055(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Returns the dataset specified by datasetID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   datasetId: JString (required)
  ##            : Dataset ID of the requested dataset
  ##   projectId: JString (required)
  ##            : Project ID of the requested dataset
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `datasetId` field"
  var valid_589057 = path.getOrDefault("datasetId")
  valid_589057 = validateParameter(valid_589057, JString, required = true,
                                 default = nil)
  if valid_589057 != nil:
    section.add "datasetId", valid_589057
  var valid_589058 = path.getOrDefault("projectId")
  valid_589058 = validateParameter(valid_589058, JString, required = true,
                                 default = nil)
  if valid_589058 != nil:
    section.add "projectId", valid_589058
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
  var valid_589059 = query.getOrDefault("fields")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "fields", valid_589059
  var valid_589060 = query.getOrDefault("quotaUser")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "quotaUser", valid_589060
  var valid_589061 = query.getOrDefault("alt")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = newJString("json"))
  if valid_589061 != nil:
    section.add "alt", valid_589061
  var valid_589062 = query.getOrDefault("oauth_token")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "oauth_token", valid_589062
  var valid_589063 = query.getOrDefault("userIp")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "userIp", valid_589063
  var valid_589064 = query.getOrDefault("key")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "key", valid_589064
  var valid_589065 = query.getOrDefault("prettyPrint")
  valid_589065 = validateParameter(valid_589065, JBool, required = false,
                                 default = newJBool(true))
  if valid_589065 != nil:
    section.add "prettyPrint", valid_589065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589066: Call_BigqueryDatasetsGet_589054; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the dataset specified by datasetID.
  ## 
  let valid = call_589066.validator(path, query, header, formData, body)
  let scheme = call_589066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589066.url(scheme.get, call_589066.host, call_589066.base,
                         call_589066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589066, url, valid)

proc call*(call_589067: Call_BigqueryDatasetsGet_589054; datasetId: string;
          projectId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## bigqueryDatasetsGet
  ## Returns the dataset specified by datasetID.
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
  ##   datasetId: string (required)
  ##            : Dataset ID of the requested dataset
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Project ID of the requested dataset
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589068 = newJObject()
  var query_589069 = newJObject()
  add(query_589069, "fields", newJString(fields))
  add(query_589069, "quotaUser", newJString(quotaUser))
  add(query_589069, "alt", newJString(alt))
  add(query_589069, "oauth_token", newJString(oauthToken))
  add(query_589069, "userIp", newJString(userIp))
  add(path_589068, "datasetId", newJString(datasetId))
  add(query_589069, "key", newJString(key))
  add(path_589068, "projectId", newJString(projectId))
  add(query_589069, "prettyPrint", newJBool(prettyPrint))
  result = call_589067.call(path_589068, query_589069, nil, nil, nil)

var bigqueryDatasetsGet* = Call_BigqueryDatasetsGet_589054(
    name: "bigqueryDatasetsGet", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}",
    validator: validate_BigqueryDatasetsGet_589055, base: "/bigquery/v2",
    url: url_BigqueryDatasetsGet_589056, schemes: {Scheme.Https})
type
  Call_BigqueryDatasetsPatch_589105 = ref object of OpenApiRestCall_588466
proc url_BigqueryDatasetsPatch_589107(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "datasetId" in path, "`datasetId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/datasets/"),
               (kind: VariableSegment, value: "datasetId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigqueryDatasetsPatch_589106(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates information in an existing dataset. The update method replaces the entire dataset resource, whereas the patch method only replaces fields that are provided in the submitted dataset resource. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   datasetId: JString (required)
  ##            : Dataset ID of the dataset being updated
  ##   projectId: JString (required)
  ##            : Project ID of the dataset being updated
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `datasetId` field"
  var valid_589108 = path.getOrDefault("datasetId")
  valid_589108 = validateParameter(valid_589108, JString, required = true,
                                 default = nil)
  if valid_589108 != nil:
    section.add "datasetId", valid_589108
  var valid_589109 = path.getOrDefault("projectId")
  valid_589109 = validateParameter(valid_589109, JString, required = true,
                                 default = nil)
  if valid_589109 != nil:
    section.add "projectId", valid_589109
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
  var valid_589110 = query.getOrDefault("fields")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "fields", valid_589110
  var valid_589111 = query.getOrDefault("quotaUser")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = nil)
  if valid_589111 != nil:
    section.add "quotaUser", valid_589111
  var valid_589112 = query.getOrDefault("alt")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = newJString("json"))
  if valid_589112 != nil:
    section.add "alt", valid_589112
  var valid_589113 = query.getOrDefault("oauth_token")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "oauth_token", valid_589113
  var valid_589114 = query.getOrDefault("userIp")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "userIp", valid_589114
  var valid_589115 = query.getOrDefault("key")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "key", valid_589115
  var valid_589116 = query.getOrDefault("prettyPrint")
  valid_589116 = validateParameter(valid_589116, JBool, required = false,
                                 default = newJBool(true))
  if valid_589116 != nil:
    section.add "prettyPrint", valid_589116
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

proc call*(call_589118: Call_BigqueryDatasetsPatch_589105; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates information in an existing dataset. The update method replaces the entire dataset resource, whereas the patch method only replaces fields that are provided in the submitted dataset resource. This method supports patch semantics.
  ## 
  let valid = call_589118.validator(path, query, header, formData, body)
  let scheme = call_589118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589118.url(scheme.get, call_589118.host, call_589118.base,
                         call_589118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589118, url, valid)

proc call*(call_589119: Call_BigqueryDatasetsPatch_589105; datasetId: string;
          projectId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## bigqueryDatasetsPatch
  ## Updates information in an existing dataset. The update method replaces the entire dataset resource, whereas the patch method only replaces fields that are provided in the submitted dataset resource. This method supports patch semantics.
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
  ##   datasetId: string (required)
  ##            : Dataset ID of the dataset being updated
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Project ID of the dataset being updated
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589120 = newJObject()
  var query_589121 = newJObject()
  var body_589122 = newJObject()
  add(query_589121, "fields", newJString(fields))
  add(query_589121, "quotaUser", newJString(quotaUser))
  add(query_589121, "alt", newJString(alt))
  add(query_589121, "oauth_token", newJString(oauthToken))
  add(query_589121, "userIp", newJString(userIp))
  add(path_589120, "datasetId", newJString(datasetId))
  add(query_589121, "key", newJString(key))
  add(path_589120, "projectId", newJString(projectId))
  if body != nil:
    body_589122 = body
  add(query_589121, "prettyPrint", newJBool(prettyPrint))
  result = call_589119.call(path_589120, query_589121, nil, nil, body_589122)

var bigqueryDatasetsPatch* = Call_BigqueryDatasetsPatch_589105(
    name: "bigqueryDatasetsPatch", meth: HttpMethod.HttpPatch,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}",
    validator: validate_BigqueryDatasetsPatch_589106, base: "/bigquery/v2",
    url: url_BigqueryDatasetsPatch_589107, schemes: {Scheme.Https})
type
  Call_BigqueryDatasetsDelete_589088 = ref object of OpenApiRestCall_588466
proc url_BigqueryDatasetsDelete_589090(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "datasetId" in path, "`datasetId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/datasets/"),
               (kind: VariableSegment, value: "datasetId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigqueryDatasetsDelete_589089(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the dataset specified by the datasetId value. Before you can delete a dataset, you must delete all its tables, either manually or by specifying deleteContents. Immediately after deletion, you can create another dataset with the same name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   datasetId: JString (required)
  ##            : Dataset ID of dataset being deleted
  ##   projectId: JString (required)
  ##            : Project ID of the dataset being deleted
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `datasetId` field"
  var valid_589091 = path.getOrDefault("datasetId")
  valid_589091 = validateParameter(valid_589091, JString, required = true,
                                 default = nil)
  if valid_589091 != nil:
    section.add "datasetId", valid_589091
  var valid_589092 = path.getOrDefault("projectId")
  valid_589092 = validateParameter(valid_589092, JString, required = true,
                                 default = nil)
  if valid_589092 != nil:
    section.add "projectId", valid_589092
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   deleteContents: JBool
  ##                 : If True, delete all the tables in the dataset. If False and the dataset contains tables, the request will fail. Default is False
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589093 = query.getOrDefault("fields")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "fields", valid_589093
  var valid_589094 = query.getOrDefault("quotaUser")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "quotaUser", valid_589094
  var valid_589095 = query.getOrDefault("alt")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = newJString("json"))
  if valid_589095 != nil:
    section.add "alt", valid_589095
  var valid_589096 = query.getOrDefault("deleteContents")
  valid_589096 = validateParameter(valid_589096, JBool, required = false, default = nil)
  if valid_589096 != nil:
    section.add "deleteContents", valid_589096
  var valid_589097 = query.getOrDefault("oauth_token")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "oauth_token", valid_589097
  var valid_589098 = query.getOrDefault("userIp")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "userIp", valid_589098
  var valid_589099 = query.getOrDefault("key")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = nil)
  if valid_589099 != nil:
    section.add "key", valid_589099
  var valid_589100 = query.getOrDefault("prettyPrint")
  valid_589100 = validateParameter(valid_589100, JBool, required = false,
                                 default = newJBool(true))
  if valid_589100 != nil:
    section.add "prettyPrint", valid_589100
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589101: Call_BigqueryDatasetsDelete_589088; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the dataset specified by the datasetId value. Before you can delete a dataset, you must delete all its tables, either manually or by specifying deleteContents. Immediately after deletion, you can create another dataset with the same name.
  ## 
  let valid = call_589101.validator(path, query, header, formData, body)
  let scheme = call_589101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589101.url(scheme.get, call_589101.host, call_589101.base,
                         call_589101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589101, url, valid)

proc call*(call_589102: Call_BigqueryDatasetsDelete_589088; datasetId: string;
          projectId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; deleteContents: bool = false; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## bigqueryDatasetsDelete
  ## Deletes the dataset specified by the datasetId value. Before you can delete a dataset, you must delete all its tables, either manually or by specifying deleteContents. Immediately after deletion, you can create another dataset with the same name.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   deleteContents: bool
  ##                 : If True, delete all the tables in the dataset. If False and the dataset contains tables, the request will fail. Default is False
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   datasetId: string (required)
  ##            : Dataset ID of dataset being deleted
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Project ID of the dataset being deleted
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589103 = newJObject()
  var query_589104 = newJObject()
  add(query_589104, "fields", newJString(fields))
  add(query_589104, "quotaUser", newJString(quotaUser))
  add(query_589104, "alt", newJString(alt))
  add(query_589104, "deleteContents", newJBool(deleteContents))
  add(query_589104, "oauth_token", newJString(oauthToken))
  add(query_589104, "userIp", newJString(userIp))
  add(path_589103, "datasetId", newJString(datasetId))
  add(query_589104, "key", newJString(key))
  add(path_589103, "projectId", newJString(projectId))
  add(query_589104, "prettyPrint", newJBool(prettyPrint))
  result = call_589102.call(path_589103, query_589104, nil, nil, nil)

var bigqueryDatasetsDelete* = Call_BigqueryDatasetsDelete_589088(
    name: "bigqueryDatasetsDelete", meth: HttpMethod.HttpDelete,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}",
    validator: validate_BigqueryDatasetsDelete_589089, base: "/bigquery/v2",
    url: url_BigqueryDatasetsDelete_589090, schemes: {Scheme.Https})
type
  Call_BigqueryModelsList_589123 = ref object of OpenApiRestCall_588466
proc url_BigqueryModelsList_589125(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "datasetId" in path, "`datasetId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/datasets/"),
               (kind: VariableSegment, value: "datasetId"),
               (kind: ConstantSegment, value: "/models")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigqueryModelsList_589124(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists all models in the specified dataset. Requires the READER dataset
  ## role.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   datasetId: JString (required)
  ##            : Required. Dataset ID of the models to list.
  ##   projectId: JString (required)
  ##            : Required. Project ID of the models to list.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `datasetId` field"
  var valid_589126 = path.getOrDefault("datasetId")
  valid_589126 = validateParameter(valid_589126, JString, required = true,
                                 default = nil)
  if valid_589126 != nil:
    section.add "datasetId", valid_589126
  var valid_589127 = path.getOrDefault("projectId")
  valid_589127 = validateParameter(valid_589127, JString, required = true,
                                 default = nil)
  if valid_589127 != nil:
    section.add "projectId", valid_589127
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Page token, returned by a previous call to request the next page of
  ## results
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of results to return in a single response page.
  ## Leverage the page tokens to iterate through the entire collection.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589128 = query.getOrDefault("fields")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "fields", valid_589128
  var valid_589129 = query.getOrDefault("pageToken")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = nil)
  if valid_589129 != nil:
    section.add "pageToken", valid_589129
  var valid_589130 = query.getOrDefault("quotaUser")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "quotaUser", valid_589130
  var valid_589131 = query.getOrDefault("alt")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = newJString("json"))
  if valid_589131 != nil:
    section.add "alt", valid_589131
  var valid_589132 = query.getOrDefault("oauth_token")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "oauth_token", valid_589132
  var valid_589133 = query.getOrDefault("userIp")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = nil)
  if valid_589133 != nil:
    section.add "userIp", valid_589133
  var valid_589134 = query.getOrDefault("maxResults")
  valid_589134 = validateParameter(valid_589134, JInt, required = false, default = nil)
  if valid_589134 != nil:
    section.add "maxResults", valid_589134
  var valid_589135 = query.getOrDefault("key")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "key", valid_589135
  var valid_589136 = query.getOrDefault("prettyPrint")
  valid_589136 = validateParameter(valid_589136, JBool, required = false,
                                 default = newJBool(true))
  if valid_589136 != nil:
    section.add "prettyPrint", valid_589136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589137: Call_BigqueryModelsList_589123; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all models in the specified dataset. Requires the READER dataset
  ## role.
  ## 
  let valid = call_589137.validator(path, query, header, formData, body)
  let scheme = call_589137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589137.url(scheme.get, call_589137.host, call_589137.base,
                         call_589137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589137, url, valid)

proc call*(call_589138: Call_BigqueryModelsList_589123; datasetId: string;
          projectId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## bigqueryModelsList
  ## Lists all models in the specified dataset. Requires the READER dataset
  ## role.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Page token, returned by a previous call to request the next page of
  ## results
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   datasetId: string (required)
  ##            : Required. Dataset ID of the models to list.
  ##   maxResults: int
  ##             : The maximum number of results to return in a single response page.
  ## Leverage the page tokens to iterate through the entire collection.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Required. Project ID of the models to list.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589139 = newJObject()
  var query_589140 = newJObject()
  add(query_589140, "fields", newJString(fields))
  add(query_589140, "pageToken", newJString(pageToken))
  add(query_589140, "quotaUser", newJString(quotaUser))
  add(query_589140, "alt", newJString(alt))
  add(query_589140, "oauth_token", newJString(oauthToken))
  add(query_589140, "userIp", newJString(userIp))
  add(path_589139, "datasetId", newJString(datasetId))
  add(query_589140, "maxResults", newJInt(maxResults))
  add(query_589140, "key", newJString(key))
  add(path_589139, "projectId", newJString(projectId))
  add(query_589140, "prettyPrint", newJBool(prettyPrint))
  result = call_589138.call(path_589139, query_589140, nil, nil, nil)

var bigqueryModelsList* = Call_BigqueryModelsList_589123(
    name: "bigqueryModelsList", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/models",
    validator: validate_BigqueryModelsList_589124, base: "/bigquery/v2",
    url: url_BigqueryModelsList_589125, schemes: {Scheme.Https})
type
  Call_BigqueryModelsGet_589141 = ref object of OpenApiRestCall_588466
proc url_BigqueryModelsGet_589143(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "datasetId" in path, "`datasetId` is a required path parameter"
  assert "modelId" in path, "`modelId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/datasets/"),
               (kind: VariableSegment, value: "datasetId"),
               (kind: ConstantSegment, value: "/models/"),
               (kind: VariableSegment, value: "modelId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigqueryModelsGet_589142(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets the specified model resource by model ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   datasetId: JString (required)
  ##            : Required. Dataset ID of the requested model.
  ##   projectId: JString (required)
  ##            : Required. Project ID of the requested model.
  ##   modelId: JString (required)
  ##          : Required. Model ID of the requested model.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `datasetId` field"
  var valid_589144 = path.getOrDefault("datasetId")
  valid_589144 = validateParameter(valid_589144, JString, required = true,
                                 default = nil)
  if valid_589144 != nil:
    section.add "datasetId", valid_589144
  var valid_589145 = path.getOrDefault("projectId")
  valid_589145 = validateParameter(valid_589145, JString, required = true,
                                 default = nil)
  if valid_589145 != nil:
    section.add "projectId", valid_589145
  var valid_589146 = path.getOrDefault("modelId")
  valid_589146 = validateParameter(valid_589146, JString, required = true,
                                 default = nil)
  if valid_589146 != nil:
    section.add "modelId", valid_589146
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
  var valid_589147 = query.getOrDefault("fields")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = nil)
  if valid_589147 != nil:
    section.add "fields", valid_589147
  var valid_589148 = query.getOrDefault("quotaUser")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "quotaUser", valid_589148
  var valid_589149 = query.getOrDefault("alt")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = newJString("json"))
  if valid_589149 != nil:
    section.add "alt", valid_589149
  var valid_589150 = query.getOrDefault("oauth_token")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = nil)
  if valid_589150 != nil:
    section.add "oauth_token", valid_589150
  var valid_589151 = query.getOrDefault("userIp")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = nil)
  if valid_589151 != nil:
    section.add "userIp", valid_589151
  var valid_589152 = query.getOrDefault("key")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "key", valid_589152
  var valid_589153 = query.getOrDefault("prettyPrint")
  valid_589153 = validateParameter(valid_589153, JBool, required = false,
                                 default = newJBool(true))
  if valid_589153 != nil:
    section.add "prettyPrint", valid_589153
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589154: Call_BigqueryModelsGet_589141; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified model resource by model ID.
  ## 
  let valid = call_589154.validator(path, query, header, formData, body)
  let scheme = call_589154.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589154.url(scheme.get, call_589154.host, call_589154.base,
                         call_589154.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589154, url, valid)

proc call*(call_589155: Call_BigqueryModelsGet_589141; datasetId: string;
          projectId: string; modelId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## bigqueryModelsGet
  ## Gets the specified model resource by model ID.
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
  ##   datasetId: string (required)
  ##            : Required. Dataset ID of the requested model.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Required. Project ID of the requested model.
  ##   modelId: string (required)
  ##          : Required. Model ID of the requested model.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589156 = newJObject()
  var query_589157 = newJObject()
  add(query_589157, "fields", newJString(fields))
  add(query_589157, "quotaUser", newJString(quotaUser))
  add(query_589157, "alt", newJString(alt))
  add(query_589157, "oauth_token", newJString(oauthToken))
  add(query_589157, "userIp", newJString(userIp))
  add(path_589156, "datasetId", newJString(datasetId))
  add(query_589157, "key", newJString(key))
  add(path_589156, "projectId", newJString(projectId))
  add(path_589156, "modelId", newJString(modelId))
  add(query_589157, "prettyPrint", newJBool(prettyPrint))
  result = call_589155.call(path_589156, query_589157, nil, nil, nil)

var bigqueryModelsGet* = Call_BigqueryModelsGet_589141(name: "bigqueryModelsGet",
    meth: HttpMethod.HttpGet, host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/models/{modelId}",
    validator: validate_BigqueryModelsGet_589142, base: "/bigquery/v2",
    url: url_BigqueryModelsGet_589143, schemes: {Scheme.Https})
type
  Call_BigqueryModelsPatch_589175 = ref object of OpenApiRestCall_588466
proc url_BigqueryModelsPatch_589177(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "datasetId" in path, "`datasetId` is a required path parameter"
  assert "modelId" in path, "`modelId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/datasets/"),
               (kind: VariableSegment, value: "datasetId"),
               (kind: ConstantSegment, value: "/models/"),
               (kind: VariableSegment, value: "modelId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigqueryModelsPatch_589176(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Patch specific fields in the specified model.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   datasetId: JString (required)
  ##            : Required. Dataset ID of the model to patch.
  ##   projectId: JString (required)
  ##            : Required. Project ID of the model to patch.
  ##   modelId: JString (required)
  ##          : Required. Model ID of the model to patch.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `datasetId` field"
  var valid_589178 = path.getOrDefault("datasetId")
  valid_589178 = validateParameter(valid_589178, JString, required = true,
                                 default = nil)
  if valid_589178 != nil:
    section.add "datasetId", valid_589178
  var valid_589179 = path.getOrDefault("projectId")
  valid_589179 = validateParameter(valid_589179, JString, required = true,
                                 default = nil)
  if valid_589179 != nil:
    section.add "projectId", valid_589179
  var valid_589180 = path.getOrDefault("modelId")
  valid_589180 = validateParameter(valid_589180, JString, required = true,
                                 default = nil)
  if valid_589180 != nil:
    section.add "modelId", valid_589180
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
  var valid_589181 = query.getOrDefault("fields")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = nil)
  if valid_589181 != nil:
    section.add "fields", valid_589181
  var valid_589182 = query.getOrDefault("quotaUser")
  valid_589182 = validateParameter(valid_589182, JString, required = false,
                                 default = nil)
  if valid_589182 != nil:
    section.add "quotaUser", valid_589182
  var valid_589183 = query.getOrDefault("alt")
  valid_589183 = validateParameter(valid_589183, JString, required = false,
                                 default = newJString("json"))
  if valid_589183 != nil:
    section.add "alt", valid_589183
  var valid_589184 = query.getOrDefault("oauth_token")
  valid_589184 = validateParameter(valid_589184, JString, required = false,
                                 default = nil)
  if valid_589184 != nil:
    section.add "oauth_token", valid_589184
  var valid_589185 = query.getOrDefault("userIp")
  valid_589185 = validateParameter(valid_589185, JString, required = false,
                                 default = nil)
  if valid_589185 != nil:
    section.add "userIp", valid_589185
  var valid_589186 = query.getOrDefault("key")
  valid_589186 = validateParameter(valid_589186, JString, required = false,
                                 default = nil)
  if valid_589186 != nil:
    section.add "key", valid_589186
  var valid_589187 = query.getOrDefault("prettyPrint")
  valid_589187 = validateParameter(valid_589187, JBool, required = false,
                                 default = newJBool(true))
  if valid_589187 != nil:
    section.add "prettyPrint", valid_589187
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

proc call*(call_589189: Call_BigqueryModelsPatch_589175; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch specific fields in the specified model.
  ## 
  let valid = call_589189.validator(path, query, header, formData, body)
  let scheme = call_589189.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589189.url(scheme.get, call_589189.host, call_589189.base,
                         call_589189.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589189, url, valid)

proc call*(call_589190: Call_BigqueryModelsPatch_589175; datasetId: string;
          projectId: string; modelId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## bigqueryModelsPatch
  ## Patch specific fields in the specified model.
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
  ##   datasetId: string (required)
  ##            : Required. Dataset ID of the model to patch.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Required. Project ID of the model to patch.
  ##   modelId: string (required)
  ##          : Required. Model ID of the model to patch.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589191 = newJObject()
  var query_589192 = newJObject()
  var body_589193 = newJObject()
  add(query_589192, "fields", newJString(fields))
  add(query_589192, "quotaUser", newJString(quotaUser))
  add(query_589192, "alt", newJString(alt))
  add(query_589192, "oauth_token", newJString(oauthToken))
  add(query_589192, "userIp", newJString(userIp))
  add(path_589191, "datasetId", newJString(datasetId))
  add(query_589192, "key", newJString(key))
  add(path_589191, "projectId", newJString(projectId))
  add(path_589191, "modelId", newJString(modelId))
  if body != nil:
    body_589193 = body
  add(query_589192, "prettyPrint", newJBool(prettyPrint))
  result = call_589190.call(path_589191, query_589192, nil, nil, body_589193)

var bigqueryModelsPatch* = Call_BigqueryModelsPatch_589175(
    name: "bigqueryModelsPatch", meth: HttpMethod.HttpPatch,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/models/{modelId}",
    validator: validate_BigqueryModelsPatch_589176, base: "/bigquery/v2",
    url: url_BigqueryModelsPatch_589177, schemes: {Scheme.Https})
type
  Call_BigqueryModelsDelete_589158 = ref object of OpenApiRestCall_588466
proc url_BigqueryModelsDelete_589160(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "datasetId" in path, "`datasetId` is a required path parameter"
  assert "modelId" in path, "`modelId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/datasets/"),
               (kind: VariableSegment, value: "datasetId"),
               (kind: ConstantSegment, value: "/models/"),
               (kind: VariableSegment, value: "modelId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigqueryModelsDelete_589159(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the model specified by modelId from the dataset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   datasetId: JString (required)
  ##            : Required. Dataset ID of the model to delete.
  ##   projectId: JString (required)
  ##            : Required. Project ID of the model to delete.
  ##   modelId: JString (required)
  ##          : Required. Model ID of the model to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `datasetId` field"
  var valid_589161 = path.getOrDefault("datasetId")
  valid_589161 = validateParameter(valid_589161, JString, required = true,
                                 default = nil)
  if valid_589161 != nil:
    section.add "datasetId", valid_589161
  var valid_589162 = path.getOrDefault("projectId")
  valid_589162 = validateParameter(valid_589162, JString, required = true,
                                 default = nil)
  if valid_589162 != nil:
    section.add "projectId", valid_589162
  var valid_589163 = path.getOrDefault("modelId")
  valid_589163 = validateParameter(valid_589163, JString, required = true,
                                 default = nil)
  if valid_589163 != nil:
    section.add "modelId", valid_589163
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
  var valid_589164 = query.getOrDefault("fields")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = nil)
  if valid_589164 != nil:
    section.add "fields", valid_589164
  var valid_589165 = query.getOrDefault("quotaUser")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = nil)
  if valid_589165 != nil:
    section.add "quotaUser", valid_589165
  var valid_589166 = query.getOrDefault("alt")
  valid_589166 = validateParameter(valid_589166, JString, required = false,
                                 default = newJString("json"))
  if valid_589166 != nil:
    section.add "alt", valid_589166
  var valid_589167 = query.getOrDefault("oauth_token")
  valid_589167 = validateParameter(valid_589167, JString, required = false,
                                 default = nil)
  if valid_589167 != nil:
    section.add "oauth_token", valid_589167
  var valid_589168 = query.getOrDefault("userIp")
  valid_589168 = validateParameter(valid_589168, JString, required = false,
                                 default = nil)
  if valid_589168 != nil:
    section.add "userIp", valid_589168
  var valid_589169 = query.getOrDefault("key")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = nil)
  if valid_589169 != nil:
    section.add "key", valid_589169
  var valid_589170 = query.getOrDefault("prettyPrint")
  valid_589170 = validateParameter(valid_589170, JBool, required = false,
                                 default = newJBool(true))
  if valid_589170 != nil:
    section.add "prettyPrint", valid_589170
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589171: Call_BigqueryModelsDelete_589158; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the model specified by modelId from the dataset.
  ## 
  let valid = call_589171.validator(path, query, header, formData, body)
  let scheme = call_589171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589171.url(scheme.get, call_589171.host, call_589171.base,
                         call_589171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589171, url, valid)

proc call*(call_589172: Call_BigqueryModelsDelete_589158; datasetId: string;
          projectId: string; modelId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## bigqueryModelsDelete
  ## Deletes the model specified by modelId from the dataset.
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
  ##   datasetId: string (required)
  ##            : Required. Dataset ID of the model to delete.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Required. Project ID of the model to delete.
  ##   modelId: string (required)
  ##          : Required. Model ID of the model to delete.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589173 = newJObject()
  var query_589174 = newJObject()
  add(query_589174, "fields", newJString(fields))
  add(query_589174, "quotaUser", newJString(quotaUser))
  add(query_589174, "alt", newJString(alt))
  add(query_589174, "oauth_token", newJString(oauthToken))
  add(query_589174, "userIp", newJString(userIp))
  add(path_589173, "datasetId", newJString(datasetId))
  add(query_589174, "key", newJString(key))
  add(path_589173, "projectId", newJString(projectId))
  add(path_589173, "modelId", newJString(modelId))
  add(query_589174, "prettyPrint", newJBool(prettyPrint))
  result = call_589172.call(path_589173, query_589174, nil, nil, nil)

var bigqueryModelsDelete* = Call_BigqueryModelsDelete_589158(
    name: "bigqueryModelsDelete", meth: HttpMethod.HttpDelete,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/models/{modelId}",
    validator: validate_BigqueryModelsDelete_589159, base: "/bigquery/v2",
    url: url_BigqueryModelsDelete_589160, schemes: {Scheme.Https})
type
  Call_BigqueryRoutinesInsert_589212 = ref object of OpenApiRestCall_588466
proc url_BigqueryRoutinesInsert_589214(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "datasetId" in path, "`datasetId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/datasets/"),
               (kind: VariableSegment, value: "datasetId"),
               (kind: ConstantSegment, value: "/routines")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigqueryRoutinesInsert_589213(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new routine in the dataset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   datasetId: JString (required)
  ##            : Required. Dataset ID of the new routine
  ##   projectId: JString (required)
  ##            : Required. Project ID of the new routine
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `datasetId` field"
  var valid_589215 = path.getOrDefault("datasetId")
  valid_589215 = validateParameter(valid_589215, JString, required = true,
                                 default = nil)
  if valid_589215 != nil:
    section.add "datasetId", valid_589215
  var valid_589216 = path.getOrDefault("projectId")
  valid_589216 = validateParameter(valid_589216, JString, required = true,
                                 default = nil)
  if valid_589216 != nil:
    section.add "projectId", valid_589216
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
  var valid_589217 = query.getOrDefault("fields")
  valid_589217 = validateParameter(valid_589217, JString, required = false,
                                 default = nil)
  if valid_589217 != nil:
    section.add "fields", valid_589217
  var valid_589218 = query.getOrDefault("quotaUser")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = nil)
  if valid_589218 != nil:
    section.add "quotaUser", valid_589218
  var valid_589219 = query.getOrDefault("alt")
  valid_589219 = validateParameter(valid_589219, JString, required = false,
                                 default = newJString("json"))
  if valid_589219 != nil:
    section.add "alt", valid_589219
  var valid_589220 = query.getOrDefault("oauth_token")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = nil)
  if valid_589220 != nil:
    section.add "oauth_token", valid_589220
  var valid_589221 = query.getOrDefault("userIp")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = nil)
  if valid_589221 != nil:
    section.add "userIp", valid_589221
  var valid_589222 = query.getOrDefault("key")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = nil)
  if valid_589222 != nil:
    section.add "key", valid_589222
  var valid_589223 = query.getOrDefault("prettyPrint")
  valid_589223 = validateParameter(valid_589223, JBool, required = false,
                                 default = newJBool(true))
  if valid_589223 != nil:
    section.add "prettyPrint", valid_589223
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

proc call*(call_589225: Call_BigqueryRoutinesInsert_589212; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new routine in the dataset.
  ## 
  let valid = call_589225.validator(path, query, header, formData, body)
  let scheme = call_589225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589225.url(scheme.get, call_589225.host, call_589225.base,
                         call_589225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589225, url, valid)

proc call*(call_589226: Call_BigqueryRoutinesInsert_589212; datasetId: string;
          projectId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## bigqueryRoutinesInsert
  ## Creates a new routine in the dataset.
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
  ##   datasetId: string (required)
  ##            : Required. Dataset ID of the new routine
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Required. Project ID of the new routine
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589227 = newJObject()
  var query_589228 = newJObject()
  var body_589229 = newJObject()
  add(query_589228, "fields", newJString(fields))
  add(query_589228, "quotaUser", newJString(quotaUser))
  add(query_589228, "alt", newJString(alt))
  add(query_589228, "oauth_token", newJString(oauthToken))
  add(query_589228, "userIp", newJString(userIp))
  add(path_589227, "datasetId", newJString(datasetId))
  add(query_589228, "key", newJString(key))
  add(path_589227, "projectId", newJString(projectId))
  if body != nil:
    body_589229 = body
  add(query_589228, "prettyPrint", newJBool(prettyPrint))
  result = call_589226.call(path_589227, query_589228, nil, nil, body_589229)

var bigqueryRoutinesInsert* = Call_BigqueryRoutinesInsert_589212(
    name: "bigqueryRoutinesInsert", meth: HttpMethod.HttpPost,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/routines",
    validator: validate_BigqueryRoutinesInsert_589213, base: "/bigquery/v2",
    url: url_BigqueryRoutinesInsert_589214, schemes: {Scheme.Https})
type
  Call_BigqueryRoutinesList_589194 = ref object of OpenApiRestCall_588466
proc url_BigqueryRoutinesList_589196(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "datasetId" in path, "`datasetId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/datasets/"),
               (kind: VariableSegment, value: "datasetId"),
               (kind: ConstantSegment, value: "/routines")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigqueryRoutinesList_589195(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all routines in the specified dataset. Requires the READER dataset
  ## role.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   datasetId: JString (required)
  ##            : Required. Dataset ID of the routines to list
  ##   projectId: JString (required)
  ##            : Required. Project ID of the routines to list
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `datasetId` field"
  var valid_589197 = path.getOrDefault("datasetId")
  valid_589197 = validateParameter(valid_589197, JString, required = true,
                                 default = nil)
  if valid_589197 != nil:
    section.add "datasetId", valid_589197
  var valid_589198 = path.getOrDefault("projectId")
  valid_589198 = validateParameter(valid_589198, JString, required = true,
                                 default = nil)
  if valid_589198 != nil:
    section.add "projectId", valid_589198
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Page token, returned by a previous call, to request the next page of
  ## results
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of results to return in a single response page.
  ## Leverage the page tokens to iterate through the entire collection.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589199 = query.getOrDefault("fields")
  valid_589199 = validateParameter(valid_589199, JString, required = false,
                                 default = nil)
  if valid_589199 != nil:
    section.add "fields", valid_589199
  var valid_589200 = query.getOrDefault("pageToken")
  valid_589200 = validateParameter(valid_589200, JString, required = false,
                                 default = nil)
  if valid_589200 != nil:
    section.add "pageToken", valid_589200
  var valid_589201 = query.getOrDefault("quotaUser")
  valid_589201 = validateParameter(valid_589201, JString, required = false,
                                 default = nil)
  if valid_589201 != nil:
    section.add "quotaUser", valid_589201
  var valid_589202 = query.getOrDefault("alt")
  valid_589202 = validateParameter(valid_589202, JString, required = false,
                                 default = newJString("json"))
  if valid_589202 != nil:
    section.add "alt", valid_589202
  var valid_589203 = query.getOrDefault("oauth_token")
  valid_589203 = validateParameter(valid_589203, JString, required = false,
                                 default = nil)
  if valid_589203 != nil:
    section.add "oauth_token", valid_589203
  var valid_589204 = query.getOrDefault("userIp")
  valid_589204 = validateParameter(valid_589204, JString, required = false,
                                 default = nil)
  if valid_589204 != nil:
    section.add "userIp", valid_589204
  var valid_589205 = query.getOrDefault("maxResults")
  valid_589205 = validateParameter(valid_589205, JInt, required = false, default = nil)
  if valid_589205 != nil:
    section.add "maxResults", valid_589205
  var valid_589206 = query.getOrDefault("key")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = nil)
  if valid_589206 != nil:
    section.add "key", valid_589206
  var valid_589207 = query.getOrDefault("prettyPrint")
  valid_589207 = validateParameter(valid_589207, JBool, required = false,
                                 default = newJBool(true))
  if valid_589207 != nil:
    section.add "prettyPrint", valid_589207
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589208: Call_BigqueryRoutinesList_589194; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all routines in the specified dataset. Requires the READER dataset
  ## role.
  ## 
  let valid = call_589208.validator(path, query, header, formData, body)
  let scheme = call_589208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589208.url(scheme.get, call_589208.host, call_589208.base,
                         call_589208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589208, url, valid)

proc call*(call_589209: Call_BigqueryRoutinesList_589194; datasetId: string;
          projectId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## bigqueryRoutinesList
  ## Lists all routines in the specified dataset. Requires the READER dataset
  ## role.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Page token, returned by a previous call, to request the next page of
  ## results
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   datasetId: string (required)
  ##            : Required. Dataset ID of the routines to list
  ##   maxResults: int
  ##             : The maximum number of results to return in a single response page.
  ## Leverage the page tokens to iterate through the entire collection.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Required. Project ID of the routines to list
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589210 = newJObject()
  var query_589211 = newJObject()
  add(query_589211, "fields", newJString(fields))
  add(query_589211, "pageToken", newJString(pageToken))
  add(query_589211, "quotaUser", newJString(quotaUser))
  add(query_589211, "alt", newJString(alt))
  add(query_589211, "oauth_token", newJString(oauthToken))
  add(query_589211, "userIp", newJString(userIp))
  add(path_589210, "datasetId", newJString(datasetId))
  add(query_589211, "maxResults", newJInt(maxResults))
  add(query_589211, "key", newJString(key))
  add(path_589210, "projectId", newJString(projectId))
  add(query_589211, "prettyPrint", newJBool(prettyPrint))
  result = call_589209.call(path_589210, query_589211, nil, nil, nil)

var bigqueryRoutinesList* = Call_BigqueryRoutinesList_589194(
    name: "bigqueryRoutinesList", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/routines",
    validator: validate_BigqueryRoutinesList_589195, base: "/bigquery/v2",
    url: url_BigqueryRoutinesList_589196, schemes: {Scheme.Https})
type
  Call_BigqueryRoutinesUpdate_589248 = ref object of OpenApiRestCall_588466
proc url_BigqueryRoutinesUpdate_589250(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "datasetId" in path, "`datasetId` is a required path parameter"
  assert "routineId" in path, "`routineId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/datasets/"),
               (kind: VariableSegment, value: "datasetId"),
               (kind: ConstantSegment, value: "/routines/"),
               (kind: VariableSegment, value: "routineId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigqueryRoutinesUpdate_589249(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates information in an existing routine. The update method replaces the
  ## entire Routine resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   datasetId: JString (required)
  ##            : Required. Dataset ID of the routine to update
  ##   projectId: JString (required)
  ##            : Required. Project ID of the routine to update
  ##   routineId: JString (required)
  ##            : Required. Routine ID of the routine to update
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `datasetId` field"
  var valid_589251 = path.getOrDefault("datasetId")
  valid_589251 = validateParameter(valid_589251, JString, required = true,
                                 default = nil)
  if valid_589251 != nil:
    section.add "datasetId", valid_589251
  var valid_589252 = path.getOrDefault("projectId")
  valid_589252 = validateParameter(valid_589252, JString, required = true,
                                 default = nil)
  if valid_589252 != nil:
    section.add "projectId", valid_589252
  var valid_589253 = path.getOrDefault("routineId")
  valid_589253 = validateParameter(valid_589253, JString, required = true,
                                 default = nil)
  if valid_589253 != nil:
    section.add "routineId", valid_589253
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
  var valid_589254 = query.getOrDefault("fields")
  valid_589254 = validateParameter(valid_589254, JString, required = false,
                                 default = nil)
  if valid_589254 != nil:
    section.add "fields", valid_589254
  var valid_589255 = query.getOrDefault("quotaUser")
  valid_589255 = validateParameter(valid_589255, JString, required = false,
                                 default = nil)
  if valid_589255 != nil:
    section.add "quotaUser", valid_589255
  var valid_589256 = query.getOrDefault("alt")
  valid_589256 = validateParameter(valid_589256, JString, required = false,
                                 default = newJString("json"))
  if valid_589256 != nil:
    section.add "alt", valid_589256
  var valid_589257 = query.getOrDefault("oauth_token")
  valid_589257 = validateParameter(valid_589257, JString, required = false,
                                 default = nil)
  if valid_589257 != nil:
    section.add "oauth_token", valid_589257
  var valid_589258 = query.getOrDefault("userIp")
  valid_589258 = validateParameter(valid_589258, JString, required = false,
                                 default = nil)
  if valid_589258 != nil:
    section.add "userIp", valid_589258
  var valid_589259 = query.getOrDefault("key")
  valid_589259 = validateParameter(valid_589259, JString, required = false,
                                 default = nil)
  if valid_589259 != nil:
    section.add "key", valid_589259
  var valid_589260 = query.getOrDefault("prettyPrint")
  valid_589260 = validateParameter(valid_589260, JBool, required = false,
                                 default = newJBool(true))
  if valid_589260 != nil:
    section.add "prettyPrint", valid_589260
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

proc call*(call_589262: Call_BigqueryRoutinesUpdate_589248; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates information in an existing routine. The update method replaces the
  ## entire Routine resource.
  ## 
  let valid = call_589262.validator(path, query, header, formData, body)
  let scheme = call_589262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589262.url(scheme.get, call_589262.host, call_589262.base,
                         call_589262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589262, url, valid)

proc call*(call_589263: Call_BigqueryRoutinesUpdate_589248; datasetId: string;
          projectId: string; routineId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## bigqueryRoutinesUpdate
  ## Updates information in an existing routine. The update method replaces the
  ## entire Routine resource.
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
  ##   datasetId: string (required)
  ##            : Required. Dataset ID of the routine to update
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Required. Project ID of the routine to update
  ##   routineId: string (required)
  ##            : Required. Routine ID of the routine to update
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589264 = newJObject()
  var query_589265 = newJObject()
  var body_589266 = newJObject()
  add(query_589265, "fields", newJString(fields))
  add(query_589265, "quotaUser", newJString(quotaUser))
  add(query_589265, "alt", newJString(alt))
  add(query_589265, "oauth_token", newJString(oauthToken))
  add(query_589265, "userIp", newJString(userIp))
  add(path_589264, "datasetId", newJString(datasetId))
  add(query_589265, "key", newJString(key))
  add(path_589264, "projectId", newJString(projectId))
  add(path_589264, "routineId", newJString(routineId))
  if body != nil:
    body_589266 = body
  add(query_589265, "prettyPrint", newJBool(prettyPrint))
  result = call_589263.call(path_589264, query_589265, nil, nil, body_589266)

var bigqueryRoutinesUpdate* = Call_BigqueryRoutinesUpdate_589248(
    name: "bigqueryRoutinesUpdate", meth: HttpMethod.HttpPut,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/routines/{routineId}",
    validator: validate_BigqueryRoutinesUpdate_589249, base: "/bigquery/v2",
    url: url_BigqueryRoutinesUpdate_589250, schemes: {Scheme.Https})
type
  Call_BigqueryRoutinesGet_589230 = ref object of OpenApiRestCall_588466
proc url_BigqueryRoutinesGet_589232(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "datasetId" in path, "`datasetId` is a required path parameter"
  assert "routineId" in path, "`routineId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/datasets/"),
               (kind: VariableSegment, value: "datasetId"),
               (kind: ConstantSegment, value: "/routines/"),
               (kind: VariableSegment, value: "routineId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigqueryRoutinesGet_589231(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets the specified routine resource by routine ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   datasetId: JString (required)
  ##            : Required. Dataset ID of the requested routine
  ##   projectId: JString (required)
  ##            : Required. Project ID of the requested routine
  ##   routineId: JString (required)
  ##            : Required. Routine ID of the requested routine
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `datasetId` field"
  var valid_589233 = path.getOrDefault("datasetId")
  valid_589233 = validateParameter(valid_589233, JString, required = true,
                                 default = nil)
  if valid_589233 != nil:
    section.add "datasetId", valid_589233
  var valid_589234 = path.getOrDefault("projectId")
  valid_589234 = validateParameter(valid_589234, JString, required = true,
                                 default = nil)
  if valid_589234 != nil:
    section.add "projectId", valid_589234
  var valid_589235 = path.getOrDefault("routineId")
  valid_589235 = validateParameter(valid_589235, JString, required = true,
                                 default = nil)
  if valid_589235 != nil:
    section.add "routineId", valid_589235
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
  ##   fieldMask: JString
  ##            : If set, only the Routine fields in the field mask are returned in the
  ## response. If unset, all Routine fields are returned.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589236 = query.getOrDefault("fields")
  valid_589236 = validateParameter(valid_589236, JString, required = false,
                                 default = nil)
  if valid_589236 != nil:
    section.add "fields", valid_589236
  var valid_589237 = query.getOrDefault("quotaUser")
  valid_589237 = validateParameter(valid_589237, JString, required = false,
                                 default = nil)
  if valid_589237 != nil:
    section.add "quotaUser", valid_589237
  var valid_589238 = query.getOrDefault("alt")
  valid_589238 = validateParameter(valid_589238, JString, required = false,
                                 default = newJString("json"))
  if valid_589238 != nil:
    section.add "alt", valid_589238
  var valid_589239 = query.getOrDefault("oauth_token")
  valid_589239 = validateParameter(valid_589239, JString, required = false,
                                 default = nil)
  if valid_589239 != nil:
    section.add "oauth_token", valid_589239
  var valid_589240 = query.getOrDefault("userIp")
  valid_589240 = validateParameter(valid_589240, JString, required = false,
                                 default = nil)
  if valid_589240 != nil:
    section.add "userIp", valid_589240
  var valid_589241 = query.getOrDefault("key")
  valid_589241 = validateParameter(valid_589241, JString, required = false,
                                 default = nil)
  if valid_589241 != nil:
    section.add "key", valid_589241
  var valid_589242 = query.getOrDefault("fieldMask")
  valid_589242 = validateParameter(valid_589242, JString, required = false,
                                 default = nil)
  if valid_589242 != nil:
    section.add "fieldMask", valid_589242
  var valid_589243 = query.getOrDefault("prettyPrint")
  valid_589243 = validateParameter(valid_589243, JBool, required = false,
                                 default = newJBool(true))
  if valid_589243 != nil:
    section.add "prettyPrint", valid_589243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589244: Call_BigqueryRoutinesGet_589230; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified routine resource by routine ID.
  ## 
  let valid = call_589244.validator(path, query, header, formData, body)
  let scheme = call_589244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589244.url(scheme.get, call_589244.host, call_589244.base,
                         call_589244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589244, url, valid)

proc call*(call_589245: Call_BigqueryRoutinesGet_589230; datasetId: string;
          projectId: string; routineId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; fieldMask: string = "";
          prettyPrint: bool = true): Recallable =
  ## bigqueryRoutinesGet
  ## Gets the specified routine resource by routine ID.
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
  ##   datasetId: string (required)
  ##            : Required. Dataset ID of the requested routine
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   fieldMask: string
  ##            : If set, only the Routine fields in the field mask are returned in the
  ## response. If unset, all Routine fields are returned.
  ##   projectId: string (required)
  ##            : Required. Project ID of the requested routine
  ##   routineId: string (required)
  ##            : Required. Routine ID of the requested routine
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589246 = newJObject()
  var query_589247 = newJObject()
  add(query_589247, "fields", newJString(fields))
  add(query_589247, "quotaUser", newJString(quotaUser))
  add(query_589247, "alt", newJString(alt))
  add(query_589247, "oauth_token", newJString(oauthToken))
  add(query_589247, "userIp", newJString(userIp))
  add(path_589246, "datasetId", newJString(datasetId))
  add(query_589247, "key", newJString(key))
  add(query_589247, "fieldMask", newJString(fieldMask))
  add(path_589246, "projectId", newJString(projectId))
  add(path_589246, "routineId", newJString(routineId))
  add(query_589247, "prettyPrint", newJBool(prettyPrint))
  result = call_589245.call(path_589246, query_589247, nil, nil, nil)

var bigqueryRoutinesGet* = Call_BigqueryRoutinesGet_589230(
    name: "bigqueryRoutinesGet", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/routines/{routineId}",
    validator: validate_BigqueryRoutinesGet_589231, base: "/bigquery/v2",
    url: url_BigqueryRoutinesGet_589232, schemes: {Scheme.Https})
type
  Call_BigqueryRoutinesDelete_589267 = ref object of OpenApiRestCall_588466
proc url_BigqueryRoutinesDelete_589269(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "datasetId" in path, "`datasetId` is a required path parameter"
  assert "routineId" in path, "`routineId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/datasets/"),
               (kind: VariableSegment, value: "datasetId"),
               (kind: ConstantSegment, value: "/routines/"),
               (kind: VariableSegment, value: "routineId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigqueryRoutinesDelete_589268(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the routine specified by routineId from the dataset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   datasetId: JString (required)
  ##            : Required. Dataset ID of the routine to delete
  ##   projectId: JString (required)
  ##            : Required. Project ID of the routine to delete
  ##   routineId: JString (required)
  ##            : Required. Routine ID of the routine to delete
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `datasetId` field"
  var valid_589270 = path.getOrDefault("datasetId")
  valid_589270 = validateParameter(valid_589270, JString, required = true,
                                 default = nil)
  if valid_589270 != nil:
    section.add "datasetId", valid_589270
  var valid_589271 = path.getOrDefault("projectId")
  valid_589271 = validateParameter(valid_589271, JString, required = true,
                                 default = nil)
  if valid_589271 != nil:
    section.add "projectId", valid_589271
  var valid_589272 = path.getOrDefault("routineId")
  valid_589272 = validateParameter(valid_589272, JString, required = true,
                                 default = nil)
  if valid_589272 != nil:
    section.add "routineId", valid_589272
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
  var valid_589273 = query.getOrDefault("fields")
  valid_589273 = validateParameter(valid_589273, JString, required = false,
                                 default = nil)
  if valid_589273 != nil:
    section.add "fields", valid_589273
  var valid_589274 = query.getOrDefault("quotaUser")
  valid_589274 = validateParameter(valid_589274, JString, required = false,
                                 default = nil)
  if valid_589274 != nil:
    section.add "quotaUser", valid_589274
  var valid_589275 = query.getOrDefault("alt")
  valid_589275 = validateParameter(valid_589275, JString, required = false,
                                 default = newJString("json"))
  if valid_589275 != nil:
    section.add "alt", valid_589275
  var valid_589276 = query.getOrDefault("oauth_token")
  valid_589276 = validateParameter(valid_589276, JString, required = false,
                                 default = nil)
  if valid_589276 != nil:
    section.add "oauth_token", valid_589276
  var valid_589277 = query.getOrDefault("userIp")
  valid_589277 = validateParameter(valid_589277, JString, required = false,
                                 default = nil)
  if valid_589277 != nil:
    section.add "userIp", valid_589277
  var valid_589278 = query.getOrDefault("key")
  valid_589278 = validateParameter(valid_589278, JString, required = false,
                                 default = nil)
  if valid_589278 != nil:
    section.add "key", valid_589278
  var valid_589279 = query.getOrDefault("prettyPrint")
  valid_589279 = validateParameter(valid_589279, JBool, required = false,
                                 default = newJBool(true))
  if valid_589279 != nil:
    section.add "prettyPrint", valid_589279
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589280: Call_BigqueryRoutinesDelete_589267; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the routine specified by routineId from the dataset.
  ## 
  let valid = call_589280.validator(path, query, header, formData, body)
  let scheme = call_589280.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589280.url(scheme.get, call_589280.host, call_589280.base,
                         call_589280.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589280, url, valid)

proc call*(call_589281: Call_BigqueryRoutinesDelete_589267; datasetId: string;
          projectId: string; routineId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## bigqueryRoutinesDelete
  ## Deletes the routine specified by routineId from the dataset.
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
  ##   datasetId: string (required)
  ##            : Required. Dataset ID of the routine to delete
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Required. Project ID of the routine to delete
  ##   routineId: string (required)
  ##            : Required. Routine ID of the routine to delete
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589282 = newJObject()
  var query_589283 = newJObject()
  add(query_589283, "fields", newJString(fields))
  add(query_589283, "quotaUser", newJString(quotaUser))
  add(query_589283, "alt", newJString(alt))
  add(query_589283, "oauth_token", newJString(oauthToken))
  add(query_589283, "userIp", newJString(userIp))
  add(path_589282, "datasetId", newJString(datasetId))
  add(query_589283, "key", newJString(key))
  add(path_589282, "projectId", newJString(projectId))
  add(path_589282, "routineId", newJString(routineId))
  add(query_589283, "prettyPrint", newJBool(prettyPrint))
  result = call_589281.call(path_589282, query_589283, nil, nil, nil)

var bigqueryRoutinesDelete* = Call_BigqueryRoutinesDelete_589267(
    name: "bigqueryRoutinesDelete", meth: HttpMethod.HttpDelete,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/routines/{routineId}",
    validator: validate_BigqueryRoutinesDelete_589268, base: "/bigquery/v2",
    url: url_BigqueryRoutinesDelete_589269, schemes: {Scheme.Https})
type
  Call_BigqueryTablesInsert_589302 = ref object of OpenApiRestCall_588466
proc url_BigqueryTablesInsert_589304(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "datasetId" in path, "`datasetId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/datasets/"),
               (kind: VariableSegment, value: "datasetId"),
               (kind: ConstantSegment, value: "/tables")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigqueryTablesInsert_589303(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new, empty table in the dataset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   datasetId: JString (required)
  ##            : Dataset ID of the new table
  ##   projectId: JString (required)
  ##            : Project ID of the new table
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `datasetId` field"
  var valid_589305 = path.getOrDefault("datasetId")
  valid_589305 = validateParameter(valid_589305, JString, required = true,
                                 default = nil)
  if valid_589305 != nil:
    section.add "datasetId", valid_589305
  var valid_589306 = path.getOrDefault("projectId")
  valid_589306 = validateParameter(valid_589306, JString, required = true,
                                 default = nil)
  if valid_589306 != nil:
    section.add "projectId", valid_589306
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
  var valid_589307 = query.getOrDefault("fields")
  valid_589307 = validateParameter(valid_589307, JString, required = false,
                                 default = nil)
  if valid_589307 != nil:
    section.add "fields", valid_589307
  var valid_589308 = query.getOrDefault("quotaUser")
  valid_589308 = validateParameter(valid_589308, JString, required = false,
                                 default = nil)
  if valid_589308 != nil:
    section.add "quotaUser", valid_589308
  var valid_589309 = query.getOrDefault("alt")
  valid_589309 = validateParameter(valid_589309, JString, required = false,
                                 default = newJString("json"))
  if valid_589309 != nil:
    section.add "alt", valid_589309
  var valid_589310 = query.getOrDefault("oauth_token")
  valid_589310 = validateParameter(valid_589310, JString, required = false,
                                 default = nil)
  if valid_589310 != nil:
    section.add "oauth_token", valid_589310
  var valid_589311 = query.getOrDefault("userIp")
  valid_589311 = validateParameter(valid_589311, JString, required = false,
                                 default = nil)
  if valid_589311 != nil:
    section.add "userIp", valid_589311
  var valid_589312 = query.getOrDefault("key")
  valid_589312 = validateParameter(valid_589312, JString, required = false,
                                 default = nil)
  if valid_589312 != nil:
    section.add "key", valid_589312
  var valid_589313 = query.getOrDefault("prettyPrint")
  valid_589313 = validateParameter(valid_589313, JBool, required = false,
                                 default = newJBool(true))
  if valid_589313 != nil:
    section.add "prettyPrint", valid_589313
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

proc call*(call_589315: Call_BigqueryTablesInsert_589302; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new, empty table in the dataset.
  ## 
  let valid = call_589315.validator(path, query, header, formData, body)
  let scheme = call_589315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589315.url(scheme.get, call_589315.host, call_589315.base,
                         call_589315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589315, url, valid)

proc call*(call_589316: Call_BigqueryTablesInsert_589302; datasetId: string;
          projectId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## bigqueryTablesInsert
  ## Creates a new, empty table in the dataset.
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
  ##   datasetId: string (required)
  ##            : Dataset ID of the new table
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Project ID of the new table
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589317 = newJObject()
  var query_589318 = newJObject()
  var body_589319 = newJObject()
  add(query_589318, "fields", newJString(fields))
  add(query_589318, "quotaUser", newJString(quotaUser))
  add(query_589318, "alt", newJString(alt))
  add(query_589318, "oauth_token", newJString(oauthToken))
  add(query_589318, "userIp", newJString(userIp))
  add(path_589317, "datasetId", newJString(datasetId))
  add(query_589318, "key", newJString(key))
  add(path_589317, "projectId", newJString(projectId))
  if body != nil:
    body_589319 = body
  add(query_589318, "prettyPrint", newJBool(prettyPrint))
  result = call_589316.call(path_589317, query_589318, nil, nil, body_589319)

var bigqueryTablesInsert* = Call_BigqueryTablesInsert_589302(
    name: "bigqueryTablesInsert", meth: HttpMethod.HttpPost,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/tables",
    validator: validate_BigqueryTablesInsert_589303, base: "/bigquery/v2",
    url: url_BigqueryTablesInsert_589304, schemes: {Scheme.Https})
type
  Call_BigqueryTablesList_589284 = ref object of OpenApiRestCall_588466
proc url_BigqueryTablesList_589286(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "datasetId" in path, "`datasetId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/datasets/"),
               (kind: VariableSegment, value: "datasetId"),
               (kind: ConstantSegment, value: "/tables")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigqueryTablesList_589285(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists all tables in the specified dataset. Requires the READER dataset role.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   datasetId: JString (required)
  ##            : Dataset ID of the tables to list
  ##   projectId: JString (required)
  ##            : Project ID of the tables to list
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `datasetId` field"
  var valid_589287 = path.getOrDefault("datasetId")
  valid_589287 = validateParameter(valid_589287, JString, required = true,
                                 default = nil)
  if valid_589287 != nil:
    section.add "datasetId", valid_589287
  var valid_589288 = path.getOrDefault("projectId")
  valid_589288 = validateParameter(valid_589288, JString, required = true,
                                 default = nil)
  if valid_589288 != nil:
    section.add "projectId", valid_589288
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Page token, returned by a previous call, to request the next page of results
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of results to return
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589289 = query.getOrDefault("fields")
  valid_589289 = validateParameter(valid_589289, JString, required = false,
                                 default = nil)
  if valid_589289 != nil:
    section.add "fields", valid_589289
  var valid_589290 = query.getOrDefault("pageToken")
  valid_589290 = validateParameter(valid_589290, JString, required = false,
                                 default = nil)
  if valid_589290 != nil:
    section.add "pageToken", valid_589290
  var valid_589291 = query.getOrDefault("quotaUser")
  valid_589291 = validateParameter(valid_589291, JString, required = false,
                                 default = nil)
  if valid_589291 != nil:
    section.add "quotaUser", valid_589291
  var valid_589292 = query.getOrDefault("alt")
  valid_589292 = validateParameter(valid_589292, JString, required = false,
                                 default = newJString("json"))
  if valid_589292 != nil:
    section.add "alt", valid_589292
  var valid_589293 = query.getOrDefault("oauth_token")
  valid_589293 = validateParameter(valid_589293, JString, required = false,
                                 default = nil)
  if valid_589293 != nil:
    section.add "oauth_token", valid_589293
  var valid_589294 = query.getOrDefault("userIp")
  valid_589294 = validateParameter(valid_589294, JString, required = false,
                                 default = nil)
  if valid_589294 != nil:
    section.add "userIp", valid_589294
  var valid_589295 = query.getOrDefault("maxResults")
  valid_589295 = validateParameter(valid_589295, JInt, required = false, default = nil)
  if valid_589295 != nil:
    section.add "maxResults", valid_589295
  var valid_589296 = query.getOrDefault("key")
  valid_589296 = validateParameter(valid_589296, JString, required = false,
                                 default = nil)
  if valid_589296 != nil:
    section.add "key", valid_589296
  var valid_589297 = query.getOrDefault("prettyPrint")
  valid_589297 = validateParameter(valid_589297, JBool, required = false,
                                 default = newJBool(true))
  if valid_589297 != nil:
    section.add "prettyPrint", valid_589297
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589298: Call_BigqueryTablesList_589284; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all tables in the specified dataset. Requires the READER dataset role.
  ## 
  let valid = call_589298.validator(path, query, header, formData, body)
  let scheme = call_589298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589298.url(scheme.get, call_589298.host, call_589298.base,
                         call_589298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589298, url, valid)

proc call*(call_589299: Call_BigqueryTablesList_589284; datasetId: string;
          projectId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## bigqueryTablesList
  ## Lists all tables in the specified dataset. Requires the READER dataset role.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Page token, returned by a previous call, to request the next page of results
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   datasetId: string (required)
  ##            : Dataset ID of the tables to list
  ##   maxResults: int
  ##             : Maximum number of results to return
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Project ID of the tables to list
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589300 = newJObject()
  var query_589301 = newJObject()
  add(query_589301, "fields", newJString(fields))
  add(query_589301, "pageToken", newJString(pageToken))
  add(query_589301, "quotaUser", newJString(quotaUser))
  add(query_589301, "alt", newJString(alt))
  add(query_589301, "oauth_token", newJString(oauthToken))
  add(query_589301, "userIp", newJString(userIp))
  add(path_589300, "datasetId", newJString(datasetId))
  add(query_589301, "maxResults", newJInt(maxResults))
  add(query_589301, "key", newJString(key))
  add(path_589300, "projectId", newJString(projectId))
  add(query_589301, "prettyPrint", newJBool(prettyPrint))
  result = call_589299.call(path_589300, query_589301, nil, nil, nil)

var bigqueryTablesList* = Call_BigqueryTablesList_589284(
    name: "bigqueryTablesList", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/tables",
    validator: validate_BigqueryTablesList_589285, base: "/bigquery/v2",
    url: url_BigqueryTablesList_589286, schemes: {Scheme.Https})
type
  Call_BigqueryTablesUpdate_589338 = ref object of OpenApiRestCall_588466
proc url_BigqueryTablesUpdate_589340(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "datasetId" in path, "`datasetId` is a required path parameter"
  assert "tableId" in path, "`tableId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/datasets/"),
               (kind: VariableSegment, value: "datasetId"),
               (kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigqueryTablesUpdate_589339(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates information in an existing table. The update method replaces the entire table resource, whereas the patch method only replaces fields that are provided in the submitted table resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tableId: JString (required)
  ##          : Table ID of the table to update
  ##   datasetId: JString (required)
  ##            : Dataset ID of the table to update
  ##   projectId: JString (required)
  ##            : Project ID of the table to update
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tableId` field"
  var valid_589341 = path.getOrDefault("tableId")
  valid_589341 = validateParameter(valid_589341, JString, required = true,
                                 default = nil)
  if valid_589341 != nil:
    section.add "tableId", valid_589341
  var valid_589342 = path.getOrDefault("datasetId")
  valid_589342 = validateParameter(valid_589342, JString, required = true,
                                 default = nil)
  if valid_589342 != nil:
    section.add "datasetId", valid_589342
  var valid_589343 = path.getOrDefault("projectId")
  valid_589343 = validateParameter(valid_589343, JString, required = true,
                                 default = nil)
  if valid_589343 != nil:
    section.add "projectId", valid_589343
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
  var valid_589344 = query.getOrDefault("fields")
  valid_589344 = validateParameter(valid_589344, JString, required = false,
                                 default = nil)
  if valid_589344 != nil:
    section.add "fields", valid_589344
  var valid_589345 = query.getOrDefault("quotaUser")
  valid_589345 = validateParameter(valid_589345, JString, required = false,
                                 default = nil)
  if valid_589345 != nil:
    section.add "quotaUser", valid_589345
  var valid_589346 = query.getOrDefault("alt")
  valid_589346 = validateParameter(valid_589346, JString, required = false,
                                 default = newJString("json"))
  if valid_589346 != nil:
    section.add "alt", valid_589346
  var valid_589347 = query.getOrDefault("oauth_token")
  valid_589347 = validateParameter(valid_589347, JString, required = false,
                                 default = nil)
  if valid_589347 != nil:
    section.add "oauth_token", valid_589347
  var valid_589348 = query.getOrDefault("userIp")
  valid_589348 = validateParameter(valid_589348, JString, required = false,
                                 default = nil)
  if valid_589348 != nil:
    section.add "userIp", valid_589348
  var valid_589349 = query.getOrDefault("key")
  valid_589349 = validateParameter(valid_589349, JString, required = false,
                                 default = nil)
  if valid_589349 != nil:
    section.add "key", valid_589349
  var valid_589350 = query.getOrDefault("prettyPrint")
  valid_589350 = validateParameter(valid_589350, JBool, required = false,
                                 default = newJBool(true))
  if valid_589350 != nil:
    section.add "prettyPrint", valid_589350
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

proc call*(call_589352: Call_BigqueryTablesUpdate_589338; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates information in an existing table. The update method replaces the entire table resource, whereas the patch method only replaces fields that are provided in the submitted table resource.
  ## 
  let valid = call_589352.validator(path, query, header, formData, body)
  let scheme = call_589352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589352.url(scheme.get, call_589352.host, call_589352.base,
                         call_589352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589352, url, valid)

proc call*(call_589353: Call_BigqueryTablesUpdate_589338; tableId: string;
          datasetId: string; projectId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## bigqueryTablesUpdate
  ## Updates information in an existing table. The update method replaces the entire table resource, whereas the patch method only replaces fields that are provided in the submitted table resource.
  ##   tableId: string (required)
  ##          : Table ID of the table to update
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
  ##   datasetId: string (required)
  ##            : Dataset ID of the table to update
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Project ID of the table to update
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589354 = newJObject()
  var query_589355 = newJObject()
  var body_589356 = newJObject()
  add(path_589354, "tableId", newJString(tableId))
  add(query_589355, "fields", newJString(fields))
  add(query_589355, "quotaUser", newJString(quotaUser))
  add(query_589355, "alt", newJString(alt))
  add(query_589355, "oauth_token", newJString(oauthToken))
  add(query_589355, "userIp", newJString(userIp))
  add(path_589354, "datasetId", newJString(datasetId))
  add(query_589355, "key", newJString(key))
  add(path_589354, "projectId", newJString(projectId))
  if body != nil:
    body_589356 = body
  add(query_589355, "prettyPrint", newJBool(prettyPrint))
  result = call_589353.call(path_589354, query_589355, nil, nil, body_589356)

var bigqueryTablesUpdate* = Call_BigqueryTablesUpdate_589338(
    name: "bigqueryTablesUpdate", meth: HttpMethod.HttpPut,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/tables/{tableId}",
    validator: validate_BigqueryTablesUpdate_589339, base: "/bigquery/v2",
    url: url_BigqueryTablesUpdate_589340, schemes: {Scheme.Https})
type
  Call_BigqueryTablesGet_589320 = ref object of OpenApiRestCall_588466
proc url_BigqueryTablesGet_589322(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "datasetId" in path, "`datasetId` is a required path parameter"
  assert "tableId" in path, "`tableId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/datasets/"),
               (kind: VariableSegment, value: "datasetId"),
               (kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigqueryTablesGet_589321(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets the specified table resource by table ID. This method does not return the data in the table, it only returns the table resource, which describes the structure of this table.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tableId: JString (required)
  ##          : Table ID of the requested table
  ##   datasetId: JString (required)
  ##            : Dataset ID of the requested table
  ##   projectId: JString (required)
  ##            : Project ID of the requested table
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tableId` field"
  var valid_589323 = path.getOrDefault("tableId")
  valid_589323 = validateParameter(valid_589323, JString, required = true,
                                 default = nil)
  if valid_589323 != nil:
    section.add "tableId", valid_589323
  var valid_589324 = path.getOrDefault("datasetId")
  valid_589324 = validateParameter(valid_589324, JString, required = true,
                                 default = nil)
  if valid_589324 != nil:
    section.add "datasetId", valid_589324
  var valid_589325 = path.getOrDefault("projectId")
  valid_589325 = validateParameter(valid_589325, JString, required = true,
                                 default = nil)
  if valid_589325 != nil:
    section.add "projectId", valid_589325
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
  ##   selectedFields: JString
  ##                 : List of fields to return (comma-separated). If unspecified, all fields are returned
  section = newJObject()
  var valid_589326 = query.getOrDefault("fields")
  valid_589326 = validateParameter(valid_589326, JString, required = false,
                                 default = nil)
  if valid_589326 != nil:
    section.add "fields", valid_589326
  var valid_589327 = query.getOrDefault("quotaUser")
  valid_589327 = validateParameter(valid_589327, JString, required = false,
                                 default = nil)
  if valid_589327 != nil:
    section.add "quotaUser", valid_589327
  var valid_589328 = query.getOrDefault("alt")
  valid_589328 = validateParameter(valid_589328, JString, required = false,
                                 default = newJString("json"))
  if valid_589328 != nil:
    section.add "alt", valid_589328
  var valid_589329 = query.getOrDefault("oauth_token")
  valid_589329 = validateParameter(valid_589329, JString, required = false,
                                 default = nil)
  if valid_589329 != nil:
    section.add "oauth_token", valid_589329
  var valid_589330 = query.getOrDefault("userIp")
  valid_589330 = validateParameter(valid_589330, JString, required = false,
                                 default = nil)
  if valid_589330 != nil:
    section.add "userIp", valid_589330
  var valid_589331 = query.getOrDefault("key")
  valid_589331 = validateParameter(valid_589331, JString, required = false,
                                 default = nil)
  if valid_589331 != nil:
    section.add "key", valid_589331
  var valid_589332 = query.getOrDefault("prettyPrint")
  valid_589332 = validateParameter(valid_589332, JBool, required = false,
                                 default = newJBool(true))
  if valid_589332 != nil:
    section.add "prettyPrint", valid_589332
  var valid_589333 = query.getOrDefault("selectedFields")
  valid_589333 = validateParameter(valid_589333, JString, required = false,
                                 default = nil)
  if valid_589333 != nil:
    section.add "selectedFields", valid_589333
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589334: Call_BigqueryTablesGet_589320; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified table resource by table ID. This method does not return the data in the table, it only returns the table resource, which describes the structure of this table.
  ## 
  let valid = call_589334.validator(path, query, header, formData, body)
  let scheme = call_589334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589334.url(scheme.get, call_589334.host, call_589334.base,
                         call_589334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589334, url, valid)

proc call*(call_589335: Call_BigqueryTablesGet_589320; tableId: string;
          datasetId: string; projectId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true;
          selectedFields: string = ""): Recallable =
  ## bigqueryTablesGet
  ## Gets the specified table resource by table ID. This method does not return the data in the table, it only returns the table resource, which describes the structure of this table.
  ##   tableId: string (required)
  ##          : Table ID of the requested table
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
  ##   datasetId: string (required)
  ##            : Dataset ID of the requested table
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Project ID of the requested table
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   selectedFields: string
  ##                 : List of fields to return (comma-separated). If unspecified, all fields are returned
  var path_589336 = newJObject()
  var query_589337 = newJObject()
  add(path_589336, "tableId", newJString(tableId))
  add(query_589337, "fields", newJString(fields))
  add(query_589337, "quotaUser", newJString(quotaUser))
  add(query_589337, "alt", newJString(alt))
  add(query_589337, "oauth_token", newJString(oauthToken))
  add(query_589337, "userIp", newJString(userIp))
  add(path_589336, "datasetId", newJString(datasetId))
  add(query_589337, "key", newJString(key))
  add(path_589336, "projectId", newJString(projectId))
  add(query_589337, "prettyPrint", newJBool(prettyPrint))
  add(query_589337, "selectedFields", newJString(selectedFields))
  result = call_589335.call(path_589336, query_589337, nil, nil, nil)

var bigqueryTablesGet* = Call_BigqueryTablesGet_589320(name: "bigqueryTablesGet",
    meth: HttpMethod.HttpGet, host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/tables/{tableId}",
    validator: validate_BigqueryTablesGet_589321, base: "/bigquery/v2",
    url: url_BigqueryTablesGet_589322, schemes: {Scheme.Https})
type
  Call_BigqueryTablesPatch_589374 = ref object of OpenApiRestCall_588466
proc url_BigqueryTablesPatch_589376(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "datasetId" in path, "`datasetId` is a required path parameter"
  assert "tableId" in path, "`tableId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/datasets/"),
               (kind: VariableSegment, value: "datasetId"),
               (kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigqueryTablesPatch_589375(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates information in an existing table. The update method replaces the entire table resource, whereas the patch method only replaces fields that are provided in the submitted table resource. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tableId: JString (required)
  ##          : Table ID of the table to update
  ##   datasetId: JString (required)
  ##            : Dataset ID of the table to update
  ##   projectId: JString (required)
  ##            : Project ID of the table to update
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tableId` field"
  var valid_589377 = path.getOrDefault("tableId")
  valid_589377 = validateParameter(valid_589377, JString, required = true,
                                 default = nil)
  if valid_589377 != nil:
    section.add "tableId", valid_589377
  var valid_589378 = path.getOrDefault("datasetId")
  valid_589378 = validateParameter(valid_589378, JString, required = true,
                                 default = nil)
  if valid_589378 != nil:
    section.add "datasetId", valid_589378
  var valid_589379 = path.getOrDefault("projectId")
  valid_589379 = validateParameter(valid_589379, JString, required = true,
                                 default = nil)
  if valid_589379 != nil:
    section.add "projectId", valid_589379
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
  var valid_589380 = query.getOrDefault("fields")
  valid_589380 = validateParameter(valid_589380, JString, required = false,
                                 default = nil)
  if valid_589380 != nil:
    section.add "fields", valid_589380
  var valid_589381 = query.getOrDefault("quotaUser")
  valid_589381 = validateParameter(valid_589381, JString, required = false,
                                 default = nil)
  if valid_589381 != nil:
    section.add "quotaUser", valid_589381
  var valid_589382 = query.getOrDefault("alt")
  valid_589382 = validateParameter(valid_589382, JString, required = false,
                                 default = newJString("json"))
  if valid_589382 != nil:
    section.add "alt", valid_589382
  var valid_589383 = query.getOrDefault("oauth_token")
  valid_589383 = validateParameter(valid_589383, JString, required = false,
                                 default = nil)
  if valid_589383 != nil:
    section.add "oauth_token", valid_589383
  var valid_589384 = query.getOrDefault("userIp")
  valid_589384 = validateParameter(valid_589384, JString, required = false,
                                 default = nil)
  if valid_589384 != nil:
    section.add "userIp", valid_589384
  var valid_589385 = query.getOrDefault("key")
  valid_589385 = validateParameter(valid_589385, JString, required = false,
                                 default = nil)
  if valid_589385 != nil:
    section.add "key", valid_589385
  var valid_589386 = query.getOrDefault("prettyPrint")
  valid_589386 = validateParameter(valid_589386, JBool, required = false,
                                 default = newJBool(true))
  if valid_589386 != nil:
    section.add "prettyPrint", valid_589386
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

proc call*(call_589388: Call_BigqueryTablesPatch_589374; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates information in an existing table. The update method replaces the entire table resource, whereas the patch method only replaces fields that are provided in the submitted table resource. This method supports patch semantics.
  ## 
  let valid = call_589388.validator(path, query, header, formData, body)
  let scheme = call_589388.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589388.url(scheme.get, call_589388.host, call_589388.base,
                         call_589388.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589388, url, valid)

proc call*(call_589389: Call_BigqueryTablesPatch_589374; tableId: string;
          datasetId: string; projectId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## bigqueryTablesPatch
  ## Updates information in an existing table. The update method replaces the entire table resource, whereas the patch method only replaces fields that are provided in the submitted table resource. This method supports patch semantics.
  ##   tableId: string (required)
  ##          : Table ID of the table to update
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
  ##   datasetId: string (required)
  ##            : Dataset ID of the table to update
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Project ID of the table to update
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589390 = newJObject()
  var query_589391 = newJObject()
  var body_589392 = newJObject()
  add(path_589390, "tableId", newJString(tableId))
  add(query_589391, "fields", newJString(fields))
  add(query_589391, "quotaUser", newJString(quotaUser))
  add(query_589391, "alt", newJString(alt))
  add(query_589391, "oauth_token", newJString(oauthToken))
  add(query_589391, "userIp", newJString(userIp))
  add(path_589390, "datasetId", newJString(datasetId))
  add(query_589391, "key", newJString(key))
  add(path_589390, "projectId", newJString(projectId))
  if body != nil:
    body_589392 = body
  add(query_589391, "prettyPrint", newJBool(prettyPrint))
  result = call_589389.call(path_589390, query_589391, nil, nil, body_589392)

var bigqueryTablesPatch* = Call_BigqueryTablesPatch_589374(
    name: "bigqueryTablesPatch", meth: HttpMethod.HttpPatch,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/tables/{tableId}",
    validator: validate_BigqueryTablesPatch_589375, base: "/bigquery/v2",
    url: url_BigqueryTablesPatch_589376, schemes: {Scheme.Https})
type
  Call_BigqueryTablesDelete_589357 = ref object of OpenApiRestCall_588466
proc url_BigqueryTablesDelete_589359(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "datasetId" in path, "`datasetId` is a required path parameter"
  assert "tableId" in path, "`tableId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/datasets/"),
               (kind: VariableSegment, value: "datasetId"),
               (kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigqueryTablesDelete_589358(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the table specified by tableId from the dataset. If the table contains data, all the data will be deleted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tableId: JString (required)
  ##          : Table ID of the table to delete
  ##   datasetId: JString (required)
  ##            : Dataset ID of the table to delete
  ##   projectId: JString (required)
  ##            : Project ID of the table to delete
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tableId` field"
  var valid_589360 = path.getOrDefault("tableId")
  valid_589360 = validateParameter(valid_589360, JString, required = true,
                                 default = nil)
  if valid_589360 != nil:
    section.add "tableId", valid_589360
  var valid_589361 = path.getOrDefault("datasetId")
  valid_589361 = validateParameter(valid_589361, JString, required = true,
                                 default = nil)
  if valid_589361 != nil:
    section.add "datasetId", valid_589361
  var valid_589362 = path.getOrDefault("projectId")
  valid_589362 = validateParameter(valid_589362, JString, required = true,
                                 default = nil)
  if valid_589362 != nil:
    section.add "projectId", valid_589362
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
  var valid_589363 = query.getOrDefault("fields")
  valid_589363 = validateParameter(valid_589363, JString, required = false,
                                 default = nil)
  if valid_589363 != nil:
    section.add "fields", valid_589363
  var valid_589364 = query.getOrDefault("quotaUser")
  valid_589364 = validateParameter(valid_589364, JString, required = false,
                                 default = nil)
  if valid_589364 != nil:
    section.add "quotaUser", valid_589364
  var valid_589365 = query.getOrDefault("alt")
  valid_589365 = validateParameter(valid_589365, JString, required = false,
                                 default = newJString("json"))
  if valid_589365 != nil:
    section.add "alt", valid_589365
  var valid_589366 = query.getOrDefault("oauth_token")
  valid_589366 = validateParameter(valid_589366, JString, required = false,
                                 default = nil)
  if valid_589366 != nil:
    section.add "oauth_token", valid_589366
  var valid_589367 = query.getOrDefault("userIp")
  valid_589367 = validateParameter(valid_589367, JString, required = false,
                                 default = nil)
  if valid_589367 != nil:
    section.add "userIp", valid_589367
  var valid_589368 = query.getOrDefault("key")
  valid_589368 = validateParameter(valid_589368, JString, required = false,
                                 default = nil)
  if valid_589368 != nil:
    section.add "key", valid_589368
  var valid_589369 = query.getOrDefault("prettyPrint")
  valid_589369 = validateParameter(valid_589369, JBool, required = false,
                                 default = newJBool(true))
  if valid_589369 != nil:
    section.add "prettyPrint", valid_589369
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589370: Call_BigqueryTablesDelete_589357; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the table specified by tableId from the dataset. If the table contains data, all the data will be deleted.
  ## 
  let valid = call_589370.validator(path, query, header, formData, body)
  let scheme = call_589370.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589370.url(scheme.get, call_589370.host, call_589370.base,
                         call_589370.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589370, url, valid)

proc call*(call_589371: Call_BigqueryTablesDelete_589357; tableId: string;
          datasetId: string; projectId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## bigqueryTablesDelete
  ## Deletes the table specified by tableId from the dataset. If the table contains data, all the data will be deleted.
  ##   tableId: string (required)
  ##          : Table ID of the table to delete
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
  ##   datasetId: string (required)
  ##            : Dataset ID of the table to delete
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Project ID of the table to delete
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589372 = newJObject()
  var query_589373 = newJObject()
  add(path_589372, "tableId", newJString(tableId))
  add(query_589373, "fields", newJString(fields))
  add(query_589373, "quotaUser", newJString(quotaUser))
  add(query_589373, "alt", newJString(alt))
  add(query_589373, "oauth_token", newJString(oauthToken))
  add(query_589373, "userIp", newJString(userIp))
  add(path_589372, "datasetId", newJString(datasetId))
  add(query_589373, "key", newJString(key))
  add(path_589372, "projectId", newJString(projectId))
  add(query_589373, "prettyPrint", newJBool(prettyPrint))
  result = call_589371.call(path_589372, query_589373, nil, nil, nil)

var bigqueryTablesDelete* = Call_BigqueryTablesDelete_589357(
    name: "bigqueryTablesDelete", meth: HttpMethod.HttpDelete,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/tables/{tableId}",
    validator: validate_BigqueryTablesDelete_589358, base: "/bigquery/v2",
    url: url_BigqueryTablesDelete_589359, schemes: {Scheme.Https})
type
  Call_BigqueryTabledataList_589393 = ref object of OpenApiRestCall_588466
proc url_BigqueryTabledataList_589395(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "datasetId" in path, "`datasetId` is a required path parameter"
  assert "tableId" in path, "`tableId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/datasets/"),
               (kind: VariableSegment, value: "datasetId"),
               (kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableId"),
               (kind: ConstantSegment, value: "/data")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigqueryTabledataList_589394(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves table data from a specified set of rows. Requires the READER dataset role.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tableId: JString (required)
  ##          : Table ID of the table to read
  ##   datasetId: JString (required)
  ##            : Dataset ID of the table to read
  ##   projectId: JString (required)
  ##            : Project ID of the table to read
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tableId` field"
  var valid_589396 = path.getOrDefault("tableId")
  valid_589396 = validateParameter(valid_589396, JString, required = true,
                                 default = nil)
  if valid_589396 != nil:
    section.add "tableId", valid_589396
  var valid_589397 = path.getOrDefault("datasetId")
  valid_589397 = validateParameter(valid_589397, JString, required = true,
                                 default = nil)
  if valid_589397 != nil:
    section.add "datasetId", valid_589397
  var valid_589398 = path.getOrDefault("projectId")
  valid_589398 = validateParameter(valid_589398, JString, required = true,
                                 default = nil)
  if valid_589398 != nil:
    section.add "projectId", valid_589398
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Page token, returned by a previous call, identifying the result set
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of results to return
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   selectedFields: JString
  ##                 : List of fields to return (comma-separated). If unspecified, all fields are returned
  ##   startIndex: JString
  ##             : Zero-based index of the starting row to read
  section = newJObject()
  var valid_589399 = query.getOrDefault("fields")
  valid_589399 = validateParameter(valid_589399, JString, required = false,
                                 default = nil)
  if valid_589399 != nil:
    section.add "fields", valid_589399
  var valid_589400 = query.getOrDefault("pageToken")
  valid_589400 = validateParameter(valid_589400, JString, required = false,
                                 default = nil)
  if valid_589400 != nil:
    section.add "pageToken", valid_589400
  var valid_589401 = query.getOrDefault("quotaUser")
  valid_589401 = validateParameter(valid_589401, JString, required = false,
                                 default = nil)
  if valid_589401 != nil:
    section.add "quotaUser", valid_589401
  var valid_589402 = query.getOrDefault("alt")
  valid_589402 = validateParameter(valid_589402, JString, required = false,
                                 default = newJString("json"))
  if valid_589402 != nil:
    section.add "alt", valid_589402
  var valid_589403 = query.getOrDefault("oauth_token")
  valid_589403 = validateParameter(valid_589403, JString, required = false,
                                 default = nil)
  if valid_589403 != nil:
    section.add "oauth_token", valid_589403
  var valid_589404 = query.getOrDefault("userIp")
  valid_589404 = validateParameter(valid_589404, JString, required = false,
                                 default = nil)
  if valid_589404 != nil:
    section.add "userIp", valid_589404
  var valid_589405 = query.getOrDefault("maxResults")
  valid_589405 = validateParameter(valid_589405, JInt, required = false, default = nil)
  if valid_589405 != nil:
    section.add "maxResults", valid_589405
  var valid_589406 = query.getOrDefault("key")
  valid_589406 = validateParameter(valid_589406, JString, required = false,
                                 default = nil)
  if valid_589406 != nil:
    section.add "key", valid_589406
  var valid_589407 = query.getOrDefault("prettyPrint")
  valid_589407 = validateParameter(valid_589407, JBool, required = false,
                                 default = newJBool(true))
  if valid_589407 != nil:
    section.add "prettyPrint", valid_589407
  var valid_589408 = query.getOrDefault("selectedFields")
  valid_589408 = validateParameter(valid_589408, JString, required = false,
                                 default = nil)
  if valid_589408 != nil:
    section.add "selectedFields", valid_589408
  var valid_589409 = query.getOrDefault("startIndex")
  valid_589409 = validateParameter(valid_589409, JString, required = false,
                                 default = nil)
  if valid_589409 != nil:
    section.add "startIndex", valid_589409
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589410: Call_BigqueryTabledataList_589393; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves table data from a specified set of rows. Requires the READER dataset role.
  ## 
  let valid = call_589410.validator(path, query, header, formData, body)
  let scheme = call_589410.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589410.url(scheme.get, call_589410.host, call_589410.base,
                         call_589410.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589410, url, valid)

proc call*(call_589411: Call_BigqueryTabledataList_589393; tableId: string;
          datasetId: string; projectId: string; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true; selectedFields: string = "";
          startIndex: string = ""): Recallable =
  ## bigqueryTabledataList
  ## Retrieves table data from a specified set of rows. Requires the READER dataset role.
  ##   tableId: string (required)
  ##          : Table ID of the table to read
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Page token, returned by a previous call, identifying the result set
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   datasetId: string (required)
  ##            : Dataset ID of the table to read
  ##   maxResults: int
  ##             : Maximum number of results to return
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Project ID of the table to read
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   selectedFields: string
  ##                 : List of fields to return (comma-separated). If unspecified, all fields are returned
  ##   startIndex: string
  ##             : Zero-based index of the starting row to read
  var path_589412 = newJObject()
  var query_589413 = newJObject()
  add(path_589412, "tableId", newJString(tableId))
  add(query_589413, "fields", newJString(fields))
  add(query_589413, "pageToken", newJString(pageToken))
  add(query_589413, "quotaUser", newJString(quotaUser))
  add(query_589413, "alt", newJString(alt))
  add(query_589413, "oauth_token", newJString(oauthToken))
  add(query_589413, "userIp", newJString(userIp))
  add(path_589412, "datasetId", newJString(datasetId))
  add(query_589413, "maxResults", newJInt(maxResults))
  add(query_589413, "key", newJString(key))
  add(path_589412, "projectId", newJString(projectId))
  add(query_589413, "prettyPrint", newJBool(prettyPrint))
  add(query_589413, "selectedFields", newJString(selectedFields))
  add(query_589413, "startIndex", newJString(startIndex))
  result = call_589411.call(path_589412, query_589413, nil, nil, nil)

var bigqueryTabledataList* = Call_BigqueryTabledataList_589393(
    name: "bigqueryTabledataList", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/tables/{tableId}/data",
    validator: validate_BigqueryTabledataList_589394, base: "/bigquery/v2",
    url: url_BigqueryTabledataList_589395, schemes: {Scheme.Https})
type
  Call_BigqueryTabledataInsertAll_589414 = ref object of OpenApiRestCall_588466
proc url_BigqueryTabledataInsertAll_589416(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "datasetId" in path, "`datasetId` is a required path parameter"
  assert "tableId" in path, "`tableId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/datasets/"),
               (kind: VariableSegment, value: "datasetId"),
               (kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableId"),
               (kind: ConstantSegment, value: "/insertAll")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigqueryTabledataInsertAll_589415(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Streams data into BigQuery one record at a time without needing to run a load job. Requires the WRITER dataset role.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tableId: JString (required)
  ##          : Table ID of the destination table.
  ##   datasetId: JString (required)
  ##            : Dataset ID of the destination table.
  ##   projectId: JString (required)
  ##            : Project ID of the destination table.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tableId` field"
  var valid_589417 = path.getOrDefault("tableId")
  valid_589417 = validateParameter(valid_589417, JString, required = true,
                                 default = nil)
  if valid_589417 != nil:
    section.add "tableId", valid_589417
  var valid_589418 = path.getOrDefault("datasetId")
  valid_589418 = validateParameter(valid_589418, JString, required = true,
                                 default = nil)
  if valid_589418 != nil:
    section.add "datasetId", valid_589418
  var valid_589419 = path.getOrDefault("projectId")
  valid_589419 = validateParameter(valid_589419, JString, required = true,
                                 default = nil)
  if valid_589419 != nil:
    section.add "projectId", valid_589419
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
  var valid_589420 = query.getOrDefault("fields")
  valid_589420 = validateParameter(valid_589420, JString, required = false,
                                 default = nil)
  if valid_589420 != nil:
    section.add "fields", valid_589420
  var valid_589421 = query.getOrDefault("quotaUser")
  valid_589421 = validateParameter(valid_589421, JString, required = false,
                                 default = nil)
  if valid_589421 != nil:
    section.add "quotaUser", valid_589421
  var valid_589422 = query.getOrDefault("alt")
  valid_589422 = validateParameter(valid_589422, JString, required = false,
                                 default = newJString("json"))
  if valid_589422 != nil:
    section.add "alt", valid_589422
  var valid_589423 = query.getOrDefault("oauth_token")
  valid_589423 = validateParameter(valid_589423, JString, required = false,
                                 default = nil)
  if valid_589423 != nil:
    section.add "oauth_token", valid_589423
  var valid_589424 = query.getOrDefault("userIp")
  valid_589424 = validateParameter(valid_589424, JString, required = false,
                                 default = nil)
  if valid_589424 != nil:
    section.add "userIp", valid_589424
  var valid_589425 = query.getOrDefault("key")
  valid_589425 = validateParameter(valid_589425, JString, required = false,
                                 default = nil)
  if valid_589425 != nil:
    section.add "key", valid_589425
  var valid_589426 = query.getOrDefault("prettyPrint")
  valid_589426 = validateParameter(valid_589426, JBool, required = false,
                                 default = newJBool(true))
  if valid_589426 != nil:
    section.add "prettyPrint", valid_589426
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

proc call*(call_589428: Call_BigqueryTabledataInsertAll_589414; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Streams data into BigQuery one record at a time without needing to run a load job. Requires the WRITER dataset role.
  ## 
  let valid = call_589428.validator(path, query, header, formData, body)
  let scheme = call_589428.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589428.url(scheme.get, call_589428.host, call_589428.base,
                         call_589428.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589428, url, valid)

proc call*(call_589429: Call_BigqueryTabledataInsertAll_589414; tableId: string;
          datasetId: string; projectId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## bigqueryTabledataInsertAll
  ## Streams data into BigQuery one record at a time without needing to run a load job. Requires the WRITER dataset role.
  ##   tableId: string (required)
  ##          : Table ID of the destination table.
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
  ##   datasetId: string (required)
  ##            : Dataset ID of the destination table.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Project ID of the destination table.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589430 = newJObject()
  var query_589431 = newJObject()
  var body_589432 = newJObject()
  add(path_589430, "tableId", newJString(tableId))
  add(query_589431, "fields", newJString(fields))
  add(query_589431, "quotaUser", newJString(quotaUser))
  add(query_589431, "alt", newJString(alt))
  add(query_589431, "oauth_token", newJString(oauthToken))
  add(query_589431, "userIp", newJString(userIp))
  add(path_589430, "datasetId", newJString(datasetId))
  add(query_589431, "key", newJString(key))
  add(path_589430, "projectId", newJString(projectId))
  if body != nil:
    body_589432 = body
  add(query_589431, "prettyPrint", newJBool(prettyPrint))
  result = call_589429.call(path_589430, query_589431, nil, nil, body_589432)

var bigqueryTabledataInsertAll* = Call_BigqueryTabledataInsertAll_589414(
    name: "bigqueryTabledataInsertAll", meth: HttpMethod.HttpPost,
    host: "bigquery.googleapis.com", route: "/projects/{projectId}/datasets/{datasetId}/tables/{tableId}/insertAll",
    validator: validate_BigqueryTabledataInsertAll_589415, base: "/bigquery/v2",
    url: url_BigqueryTabledataInsertAll_589416, schemes: {Scheme.Https})
type
  Call_BigqueryJobsInsert_589456 = ref object of OpenApiRestCall_588466
proc url_BigqueryJobsInsert_589458(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/jobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigqueryJobsInsert_589457(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Starts a new asynchronous job. Requires the Can View project role.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Project ID of the project that will be billed for the job
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_589459 = path.getOrDefault("projectId")
  valid_589459 = validateParameter(valid_589459, JString, required = true,
                                 default = nil)
  if valid_589459 != nil:
    section.add "projectId", valid_589459
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
  var valid_589460 = query.getOrDefault("fields")
  valid_589460 = validateParameter(valid_589460, JString, required = false,
                                 default = nil)
  if valid_589460 != nil:
    section.add "fields", valid_589460
  var valid_589461 = query.getOrDefault("quotaUser")
  valid_589461 = validateParameter(valid_589461, JString, required = false,
                                 default = nil)
  if valid_589461 != nil:
    section.add "quotaUser", valid_589461
  var valid_589462 = query.getOrDefault("alt")
  valid_589462 = validateParameter(valid_589462, JString, required = false,
                                 default = newJString("json"))
  if valid_589462 != nil:
    section.add "alt", valid_589462
  var valid_589463 = query.getOrDefault("oauth_token")
  valid_589463 = validateParameter(valid_589463, JString, required = false,
                                 default = nil)
  if valid_589463 != nil:
    section.add "oauth_token", valid_589463
  var valid_589464 = query.getOrDefault("userIp")
  valid_589464 = validateParameter(valid_589464, JString, required = false,
                                 default = nil)
  if valid_589464 != nil:
    section.add "userIp", valid_589464
  var valid_589465 = query.getOrDefault("key")
  valid_589465 = validateParameter(valid_589465, JString, required = false,
                                 default = nil)
  if valid_589465 != nil:
    section.add "key", valid_589465
  var valid_589466 = query.getOrDefault("prettyPrint")
  valid_589466 = validateParameter(valid_589466, JBool, required = false,
                                 default = newJBool(true))
  if valid_589466 != nil:
    section.add "prettyPrint", valid_589466
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

proc call*(call_589468: Call_BigqueryJobsInsert_589456; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a new asynchronous job. Requires the Can View project role.
  ## 
  let valid = call_589468.validator(path, query, header, formData, body)
  let scheme = call_589468.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589468.url(scheme.get, call_589468.host, call_589468.base,
                         call_589468.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589468, url, valid)

proc call*(call_589469: Call_BigqueryJobsInsert_589456; projectId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## bigqueryJobsInsert
  ## Starts a new asynchronous job. Requires the Can View project role.
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
  ##   projectId: string (required)
  ##            : Project ID of the project that will be billed for the job
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589470 = newJObject()
  var query_589471 = newJObject()
  var body_589472 = newJObject()
  add(query_589471, "fields", newJString(fields))
  add(query_589471, "quotaUser", newJString(quotaUser))
  add(query_589471, "alt", newJString(alt))
  add(query_589471, "oauth_token", newJString(oauthToken))
  add(query_589471, "userIp", newJString(userIp))
  add(query_589471, "key", newJString(key))
  add(path_589470, "projectId", newJString(projectId))
  if body != nil:
    body_589472 = body
  add(query_589471, "prettyPrint", newJBool(prettyPrint))
  result = call_589469.call(path_589470, query_589471, nil, nil, body_589472)

var bigqueryJobsInsert* = Call_BigqueryJobsInsert_589456(
    name: "bigqueryJobsInsert", meth: HttpMethod.HttpPost,
    host: "bigquery.googleapis.com", route: "/projects/{projectId}/jobs",
    validator: validate_BigqueryJobsInsert_589457, base: "/bigquery/v2",
    url: url_BigqueryJobsInsert_589458, schemes: {Scheme.Https})
type
  Call_BigqueryJobsList_589433 = ref object of OpenApiRestCall_588466
proc url_BigqueryJobsList_589435(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/jobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigqueryJobsList_589434(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists all jobs that you started in the specified project. Job information is available for a six month period after creation. The job list is sorted in reverse chronological order, by job creation time. Requires the Can View project role, or the Is Owner project role if you set the allUsers property.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Project ID of the jobs to list
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_589436 = path.getOrDefault("projectId")
  valid_589436 = validateParameter(valid_589436, JString, required = true,
                                 default = nil)
  if valid_589436 != nil:
    section.add "projectId", valid_589436
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Page token, returned by a previous call, to request the next page of results
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   parentJobId: JString
  ##              : If set, retrieves only jobs whose parent is this job. Otherwise, retrieves only jobs which have no parent
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of results to return
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   allUsers: JBool
  ##           : Whether to display jobs owned by all users in the project. Default false
  ##   projection: JString
  ##             : Restrict information returned to a set of selected fields
  ##   minCreationTime: JString
  ##                  : Min value for job creation time, in milliseconds since the POSIX epoch. If set, only jobs created after or at this timestamp are returned
  ##   maxCreationTime: JString
  ##                  : Max value for job creation time, in milliseconds since the POSIX epoch. If set, only jobs created before or at this timestamp are returned
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   stateFilter: JArray
  ##              : Filter for job state
  section = newJObject()
  var valid_589437 = query.getOrDefault("fields")
  valid_589437 = validateParameter(valid_589437, JString, required = false,
                                 default = nil)
  if valid_589437 != nil:
    section.add "fields", valid_589437
  var valid_589438 = query.getOrDefault("pageToken")
  valid_589438 = validateParameter(valid_589438, JString, required = false,
                                 default = nil)
  if valid_589438 != nil:
    section.add "pageToken", valid_589438
  var valid_589439 = query.getOrDefault("quotaUser")
  valid_589439 = validateParameter(valid_589439, JString, required = false,
                                 default = nil)
  if valid_589439 != nil:
    section.add "quotaUser", valid_589439
  var valid_589440 = query.getOrDefault("alt")
  valid_589440 = validateParameter(valid_589440, JString, required = false,
                                 default = newJString("json"))
  if valid_589440 != nil:
    section.add "alt", valid_589440
  var valid_589441 = query.getOrDefault("parentJobId")
  valid_589441 = validateParameter(valid_589441, JString, required = false,
                                 default = nil)
  if valid_589441 != nil:
    section.add "parentJobId", valid_589441
  var valid_589442 = query.getOrDefault("oauth_token")
  valid_589442 = validateParameter(valid_589442, JString, required = false,
                                 default = nil)
  if valid_589442 != nil:
    section.add "oauth_token", valid_589442
  var valid_589443 = query.getOrDefault("userIp")
  valid_589443 = validateParameter(valid_589443, JString, required = false,
                                 default = nil)
  if valid_589443 != nil:
    section.add "userIp", valid_589443
  var valid_589444 = query.getOrDefault("maxResults")
  valid_589444 = validateParameter(valid_589444, JInt, required = false, default = nil)
  if valid_589444 != nil:
    section.add "maxResults", valid_589444
  var valid_589445 = query.getOrDefault("key")
  valid_589445 = validateParameter(valid_589445, JString, required = false,
                                 default = nil)
  if valid_589445 != nil:
    section.add "key", valid_589445
  var valid_589446 = query.getOrDefault("allUsers")
  valid_589446 = validateParameter(valid_589446, JBool, required = false, default = nil)
  if valid_589446 != nil:
    section.add "allUsers", valid_589446
  var valid_589447 = query.getOrDefault("projection")
  valid_589447 = validateParameter(valid_589447, JString, required = false,
                                 default = newJString("full"))
  if valid_589447 != nil:
    section.add "projection", valid_589447
  var valid_589448 = query.getOrDefault("minCreationTime")
  valid_589448 = validateParameter(valid_589448, JString, required = false,
                                 default = nil)
  if valid_589448 != nil:
    section.add "minCreationTime", valid_589448
  var valid_589449 = query.getOrDefault("maxCreationTime")
  valid_589449 = validateParameter(valid_589449, JString, required = false,
                                 default = nil)
  if valid_589449 != nil:
    section.add "maxCreationTime", valid_589449
  var valid_589450 = query.getOrDefault("prettyPrint")
  valid_589450 = validateParameter(valid_589450, JBool, required = false,
                                 default = newJBool(true))
  if valid_589450 != nil:
    section.add "prettyPrint", valid_589450
  var valid_589451 = query.getOrDefault("stateFilter")
  valid_589451 = validateParameter(valid_589451, JArray, required = false,
                                 default = nil)
  if valid_589451 != nil:
    section.add "stateFilter", valid_589451
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589452: Call_BigqueryJobsList_589433; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all jobs that you started in the specified project. Job information is available for a six month period after creation. The job list is sorted in reverse chronological order, by job creation time. Requires the Can View project role, or the Is Owner project role if you set the allUsers property.
  ## 
  let valid = call_589452.validator(path, query, header, formData, body)
  let scheme = call_589452.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589452.url(scheme.get, call_589452.host, call_589452.base,
                         call_589452.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589452, url, valid)

proc call*(call_589453: Call_BigqueryJobsList_589433; projectId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; parentJobId: string = ""; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          allUsers: bool = false; projection: string = "full";
          minCreationTime: string = ""; maxCreationTime: string = "";
          prettyPrint: bool = true; stateFilter: JsonNode = nil): Recallable =
  ## bigqueryJobsList
  ## Lists all jobs that you started in the specified project. Job information is available for a six month period after creation. The job list is sorted in reverse chronological order, by job creation time. Requires the Can View project role, or the Is Owner project role if you set the allUsers property.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Page token, returned by a previous call, to request the next page of results
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   parentJobId: string
  ##              : If set, retrieves only jobs whose parent is this job. Otherwise, retrieves only jobs which have no parent
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of results to return
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   allUsers: bool
  ##           : Whether to display jobs owned by all users in the project. Default false
  ##   projectId: string (required)
  ##            : Project ID of the jobs to list
  ##   projection: string
  ##             : Restrict information returned to a set of selected fields
  ##   minCreationTime: string
  ##                  : Min value for job creation time, in milliseconds since the POSIX epoch. If set, only jobs created after or at this timestamp are returned
  ##   maxCreationTime: string
  ##                  : Max value for job creation time, in milliseconds since the POSIX epoch. If set, only jobs created before or at this timestamp are returned
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   stateFilter: JArray
  ##              : Filter for job state
  var path_589454 = newJObject()
  var query_589455 = newJObject()
  add(query_589455, "fields", newJString(fields))
  add(query_589455, "pageToken", newJString(pageToken))
  add(query_589455, "quotaUser", newJString(quotaUser))
  add(query_589455, "alt", newJString(alt))
  add(query_589455, "parentJobId", newJString(parentJobId))
  add(query_589455, "oauth_token", newJString(oauthToken))
  add(query_589455, "userIp", newJString(userIp))
  add(query_589455, "maxResults", newJInt(maxResults))
  add(query_589455, "key", newJString(key))
  add(query_589455, "allUsers", newJBool(allUsers))
  add(path_589454, "projectId", newJString(projectId))
  add(query_589455, "projection", newJString(projection))
  add(query_589455, "minCreationTime", newJString(minCreationTime))
  add(query_589455, "maxCreationTime", newJString(maxCreationTime))
  add(query_589455, "prettyPrint", newJBool(prettyPrint))
  if stateFilter != nil:
    query_589455.add "stateFilter", stateFilter
  result = call_589453.call(path_589454, query_589455, nil, nil, nil)

var bigqueryJobsList* = Call_BigqueryJobsList_589433(name: "bigqueryJobsList",
    meth: HttpMethod.HttpGet, host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/jobs", validator: validate_BigqueryJobsList_589434,
    base: "/bigquery/v2", url: url_BigqueryJobsList_589435, schemes: {Scheme.Https})
type
  Call_BigqueryJobsGet_589473 = ref object of OpenApiRestCall_588466
proc url_BigqueryJobsGet_589475(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigqueryJobsGet_589474(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Returns information about a specific job. Job information is available for a six month period after creation. Requires that you're the person who ran the job, or have the Is Owner project role.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : [Required] Job ID of the requested job
  ##   projectId: JString (required)
  ##            : [Required] Project ID of the requested job
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_589476 = path.getOrDefault("jobId")
  valid_589476 = validateParameter(valid_589476, JString, required = true,
                                 default = nil)
  if valid_589476 != nil:
    section.add "jobId", valid_589476
  var valid_589477 = path.getOrDefault("projectId")
  valid_589477 = validateParameter(valid_589477, JString, required = true,
                                 default = nil)
  if valid_589477 != nil:
    section.add "projectId", valid_589477
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
  ##   location: JString
  ##           : The geographic location of the job. Required except for US and EU. See details at https://cloud.google.com/bigquery/docs/locations#specifying_your_location.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589478 = query.getOrDefault("fields")
  valid_589478 = validateParameter(valid_589478, JString, required = false,
                                 default = nil)
  if valid_589478 != nil:
    section.add "fields", valid_589478
  var valid_589479 = query.getOrDefault("quotaUser")
  valid_589479 = validateParameter(valid_589479, JString, required = false,
                                 default = nil)
  if valid_589479 != nil:
    section.add "quotaUser", valid_589479
  var valid_589480 = query.getOrDefault("alt")
  valid_589480 = validateParameter(valid_589480, JString, required = false,
                                 default = newJString("json"))
  if valid_589480 != nil:
    section.add "alt", valid_589480
  var valid_589481 = query.getOrDefault("oauth_token")
  valid_589481 = validateParameter(valid_589481, JString, required = false,
                                 default = nil)
  if valid_589481 != nil:
    section.add "oauth_token", valid_589481
  var valid_589482 = query.getOrDefault("userIp")
  valid_589482 = validateParameter(valid_589482, JString, required = false,
                                 default = nil)
  if valid_589482 != nil:
    section.add "userIp", valid_589482
  var valid_589483 = query.getOrDefault("location")
  valid_589483 = validateParameter(valid_589483, JString, required = false,
                                 default = nil)
  if valid_589483 != nil:
    section.add "location", valid_589483
  var valid_589484 = query.getOrDefault("key")
  valid_589484 = validateParameter(valid_589484, JString, required = false,
                                 default = nil)
  if valid_589484 != nil:
    section.add "key", valid_589484
  var valid_589485 = query.getOrDefault("prettyPrint")
  valid_589485 = validateParameter(valid_589485, JBool, required = false,
                                 default = newJBool(true))
  if valid_589485 != nil:
    section.add "prettyPrint", valid_589485
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589486: Call_BigqueryJobsGet_589473; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns information about a specific job. Job information is available for a six month period after creation. Requires that you're the person who ran the job, or have the Is Owner project role.
  ## 
  let valid = call_589486.validator(path, query, header, formData, body)
  let scheme = call_589486.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589486.url(scheme.get, call_589486.host, call_589486.base,
                         call_589486.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589486, url, valid)

proc call*(call_589487: Call_BigqueryJobsGet_589473; jobId: string;
          projectId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          location: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## bigqueryJobsGet
  ## Returns information about a specific job. Job information is available for a six month period after creation. Requires that you're the person who ran the job, or have the Is Owner project role.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   jobId: string (required)
  ##        : [Required] Job ID of the requested job
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   location: string
  ##           : The geographic location of the job. Required except for US and EU. See details at https://cloud.google.com/bigquery/docs/locations#specifying_your_location.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : [Required] Project ID of the requested job
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589488 = newJObject()
  var query_589489 = newJObject()
  add(query_589489, "fields", newJString(fields))
  add(query_589489, "quotaUser", newJString(quotaUser))
  add(query_589489, "alt", newJString(alt))
  add(path_589488, "jobId", newJString(jobId))
  add(query_589489, "oauth_token", newJString(oauthToken))
  add(query_589489, "userIp", newJString(userIp))
  add(query_589489, "location", newJString(location))
  add(query_589489, "key", newJString(key))
  add(path_589488, "projectId", newJString(projectId))
  add(query_589489, "prettyPrint", newJBool(prettyPrint))
  result = call_589487.call(path_589488, query_589489, nil, nil, nil)

var bigqueryJobsGet* = Call_BigqueryJobsGet_589473(name: "bigqueryJobsGet",
    meth: HttpMethod.HttpGet, host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/jobs/{jobId}",
    validator: validate_BigqueryJobsGet_589474, base: "/bigquery/v2",
    url: url_BigqueryJobsGet_589475, schemes: {Scheme.Https})
type
  Call_BigqueryJobsCancel_589490 = ref object of OpenApiRestCall_588466
proc url_BigqueryJobsCancel_589492(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/jobs/"),
               (kind: VariableSegment, value: "jobId"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigqueryJobsCancel_589491(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Requests that a job be cancelled. This call will return immediately, and the client will need to poll for the job status to see if the cancel completed successfully. Cancelled jobs may still incur costs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : [Required] Job ID of the job to cancel
  ##   projectId: JString (required)
  ##            : [Required] Project ID of the job to cancel
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_589493 = path.getOrDefault("jobId")
  valid_589493 = validateParameter(valid_589493, JString, required = true,
                                 default = nil)
  if valid_589493 != nil:
    section.add "jobId", valid_589493
  var valid_589494 = path.getOrDefault("projectId")
  valid_589494 = validateParameter(valid_589494, JString, required = true,
                                 default = nil)
  if valid_589494 != nil:
    section.add "projectId", valid_589494
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
  ##   location: JString
  ##           : The geographic location of the job. Required except for US and EU. See details at https://cloud.google.com/bigquery/docs/locations#specifying_your_location.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589495 = query.getOrDefault("fields")
  valid_589495 = validateParameter(valid_589495, JString, required = false,
                                 default = nil)
  if valid_589495 != nil:
    section.add "fields", valid_589495
  var valid_589496 = query.getOrDefault("quotaUser")
  valid_589496 = validateParameter(valid_589496, JString, required = false,
                                 default = nil)
  if valid_589496 != nil:
    section.add "quotaUser", valid_589496
  var valid_589497 = query.getOrDefault("alt")
  valid_589497 = validateParameter(valid_589497, JString, required = false,
                                 default = newJString("json"))
  if valid_589497 != nil:
    section.add "alt", valid_589497
  var valid_589498 = query.getOrDefault("oauth_token")
  valid_589498 = validateParameter(valid_589498, JString, required = false,
                                 default = nil)
  if valid_589498 != nil:
    section.add "oauth_token", valid_589498
  var valid_589499 = query.getOrDefault("userIp")
  valid_589499 = validateParameter(valid_589499, JString, required = false,
                                 default = nil)
  if valid_589499 != nil:
    section.add "userIp", valid_589499
  var valid_589500 = query.getOrDefault("location")
  valid_589500 = validateParameter(valid_589500, JString, required = false,
                                 default = nil)
  if valid_589500 != nil:
    section.add "location", valid_589500
  var valid_589501 = query.getOrDefault("key")
  valid_589501 = validateParameter(valid_589501, JString, required = false,
                                 default = nil)
  if valid_589501 != nil:
    section.add "key", valid_589501
  var valid_589502 = query.getOrDefault("prettyPrint")
  valid_589502 = validateParameter(valid_589502, JBool, required = false,
                                 default = newJBool(true))
  if valid_589502 != nil:
    section.add "prettyPrint", valid_589502
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589503: Call_BigqueryJobsCancel_589490; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Requests that a job be cancelled. This call will return immediately, and the client will need to poll for the job status to see if the cancel completed successfully. Cancelled jobs may still incur costs.
  ## 
  let valid = call_589503.validator(path, query, header, formData, body)
  let scheme = call_589503.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589503.url(scheme.get, call_589503.host, call_589503.base,
                         call_589503.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589503, url, valid)

proc call*(call_589504: Call_BigqueryJobsCancel_589490; jobId: string;
          projectId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          location: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## bigqueryJobsCancel
  ## Requests that a job be cancelled. This call will return immediately, and the client will need to poll for the job status to see if the cancel completed successfully. Cancelled jobs may still incur costs.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   jobId: string (required)
  ##        : [Required] Job ID of the job to cancel
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   location: string
  ##           : The geographic location of the job. Required except for US and EU. See details at https://cloud.google.com/bigquery/docs/locations#specifying_your_location.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : [Required] Project ID of the job to cancel
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589505 = newJObject()
  var query_589506 = newJObject()
  add(query_589506, "fields", newJString(fields))
  add(query_589506, "quotaUser", newJString(quotaUser))
  add(query_589506, "alt", newJString(alt))
  add(path_589505, "jobId", newJString(jobId))
  add(query_589506, "oauth_token", newJString(oauthToken))
  add(query_589506, "userIp", newJString(userIp))
  add(query_589506, "location", newJString(location))
  add(query_589506, "key", newJString(key))
  add(path_589505, "projectId", newJString(projectId))
  add(query_589506, "prettyPrint", newJBool(prettyPrint))
  result = call_589504.call(path_589505, query_589506, nil, nil, nil)

var bigqueryJobsCancel* = Call_BigqueryJobsCancel_589490(
    name: "bigqueryJobsCancel", meth: HttpMethod.HttpPost,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/jobs/{jobId}/cancel",
    validator: validate_BigqueryJobsCancel_589491, base: "/bigquery/v2",
    url: url_BigqueryJobsCancel_589492, schemes: {Scheme.Https})
type
  Call_BigqueryJobsQuery_589507 = ref object of OpenApiRestCall_588466
proc url_BigqueryJobsQuery_589509(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/queries")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigqueryJobsQuery_589508(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Runs a BigQuery SQL query synchronously and returns query results if the query completes within a specified timeout.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Project ID of the project billed for the query
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_589510 = path.getOrDefault("projectId")
  valid_589510 = validateParameter(valid_589510, JString, required = true,
                                 default = nil)
  if valid_589510 != nil:
    section.add "projectId", valid_589510
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
  var valid_589511 = query.getOrDefault("fields")
  valid_589511 = validateParameter(valid_589511, JString, required = false,
                                 default = nil)
  if valid_589511 != nil:
    section.add "fields", valid_589511
  var valid_589512 = query.getOrDefault("quotaUser")
  valid_589512 = validateParameter(valid_589512, JString, required = false,
                                 default = nil)
  if valid_589512 != nil:
    section.add "quotaUser", valid_589512
  var valid_589513 = query.getOrDefault("alt")
  valid_589513 = validateParameter(valid_589513, JString, required = false,
                                 default = newJString("json"))
  if valid_589513 != nil:
    section.add "alt", valid_589513
  var valid_589514 = query.getOrDefault("oauth_token")
  valid_589514 = validateParameter(valid_589514, JString, required = false,
                                 default = nil)
  if valid_589514 != nil:
    section.add "oauth_token", valid_589514
  var valid_589515 = query.getOrDefault("userIp")
  valid_589515 = validateParameter(valid_589515, JString, required = false,
                                 default = nil)
  if valid_589515 != nil:
    section.add "userIp", valid_589515
  var valid_589516 = query.getOrDefault("key")
  valid_589516 = validateParameter(valid_589516, JString, required = false,
                                 default = nil)
  if valid_589516 != nil:
    section.add "key", valid_589516
  var valid_589517 = query.getOrDefault("prettyPrint")
  valid_589517 = validateParameter(valid_589517, JBool, required = false,
                                 default = newJBool(true))
  if valid_589517 != nil:
    section.add "prettyPrint", valid_589517
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

proc call*(call_589519: Call_BigqueryJobsQuery_589507; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Runs a BigQuery SQL query synchronously and returns query results if the query completes within a specified timeout.
  ## 
  let valid = call_589519.validator(path, query, header, formData, body)
  let scheme = call_589519.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589519.url(scheme.get, call_589519.host, call_589519.base,
                         call_589519.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589519, url, valid)

proc call*(call_589520: Call_BigqueryJobsQuery_589507; projectId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## bigqueryJobsQuery
  ## Runs a BigQuery SQL query synchronously and returns query results if the query completes within a specified timeout.
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
  ##   projectId: string (required)
  ##            : Project ID of the project billed for the query
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589521 = newJObject()
  var query_589522 = newJObject()
  var body_589523 = newJObject()
  add(query_589522, "fields", newJString(fields))
  add(query_589522, "quotaUser", newJString(quotaUser))
  add(query_589522, "alt", newJString(alt))
  add(query_589522, "oauth_token", newJString(oauthToken))
  add(query_589522, "userIp", newJString(userIp))
  add(query_589522, "key", newJString(key))
  add(path_589521, "projectId", newJString(projectId))
  if body != nil:
    body_589523 = body
  add(query_589522, "prettyPrint", newJBool(prettyPrint))
  result = call_589520.call(path_589521, query_589522, nil, nil, body_589523)

var bigqueryJobsQuery* = Call_BigqueryJobsQuery_589507(name: "bigqueryJobsQuery",
    meth: HttpMethod.HttpPost, host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/queries", validator: validate_BigqueryJobsQuery_589508,
    base: "/bigquery/v2", url: url_BigqueryJobsQuery_589509, schemes: {Scheme.Https})
type
  Call_BigqueryJobsGetQueryResults_589524 = ref object of OpenApiRestCall_588466
proc url_BigqueryJobsGetQueryResults_589526(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "jobId" in path, "`jobId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/queries/"),
               (kind: VariableSegment, value: "jobId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigqueryJobsGetQueryResults_589525(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the results of a query job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   jobId: JString (required)
  ##        : [Required] Job ID of the query job
  ##   projectId: JString (required)
  ##            : [Required] Project ID of the query job
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `jobId` field"
  var valid_589527 = path.getOrDefault("jobId")
  valid_589527 = validateParameter(valid_589527, JString, required = true,
                                 default = nil)
  if valid_589527 != nil:
    section.add "jobId", valid_589527
  var valid_589528 = path.getOrDefault("projectId")
  valid_589528 = validateParameter(valid_589528, JString, required = true,
                                 default = nil)
  if valid_589528 != nil:
    section.add "projectId", valid_589528
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Page token, returned by a previous call, to request the next page of results
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   location: JString
  ##           : The geographic location where the job should run. Required except for US and EU. See details at https://cloud.google.com/bigquery/docs/locations#specifying_your_location.
  ##   maxResults: JInt
  ##             : Maximum number of results to read
  ##   timeoutMs: JInt
  ##            : How long to wait for the query to complete, in milliseconds, before returning. Default is 10 seconds. If the timeout passes before the job completes, the 'jobComplete' field in the response will be false
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   startIndex: JString
  ##             : Zero-based index of the starting row
  section = newJObject()
  var valid_589529 = query.getOrDefault("fields")
  valid_589529 = validateParameter(valid_589529, JString, required = false,
                                 default = nil)
  if valid_589529 != nil:
    section.add "fields", valid_589529
  var valid_589530 = query.getOrDefault("pageToken")
  valid_589530 = validateParameter(valid_589530, JString, required = false,
                                 default = nil)
  if valid_589530 != nil:
    section.add "pageToken", valid_589530
  var valid_589531 = query.getOrDefault("quotaUser")
  valid_589531 = validateParameter(valid_589531, JString, required = false,
                                 default = nil)
  if valid_589531 != nil:
    section.add "quotaUser", valid_589531
  var valid_589532 = query.getOrDefault("alt")
  valid_589532 = validateParameter(valid_589532, JString, required = false,
                                 default = newJString("json"))
  if valid_589532 != nil:
    section.add "alt", valid_589532
  var valid_589533 = query.getOrDefault("oauth_token")
  valid_589533 = validateParameter(valid_589533, JString, required = false,
                                 default = nil)
  if valid_589533 != nil:
    section.add "oauth_token", valid_589533
  var valid_589534 = query.getOrDefault("userIp")
  valid_589534 = validateParameter(valid_589534, JString, required = false,
                                 default = nil)
  if valid_589534 != nil:
    section.add "userIp", valid_589534
  var valid_589535 = query.getOrDefault("location")
  valid_589535 = validateParameter(valid_589535, JString, required = false,
                                 default = nil)
  if valid_589535 != nil:
    section.add "location", valid_589535
  var valid_589536 = query.getOrDefault("maxResults")
  valid_589536 = validateParameter(valid_589536, JInt, required = false, default = nil)
  if valid_589536 != nil:
    section.add "maxResults", valid_589536
  var valid_589537 = query.getOrDefault("timeoutMs")
  valid_589537 = validateParameter(valid_589537, JInt, required = false, default = nil)
  if valid_589537 != nil:
    section.add "timeoutMs", valid_589537
  var valid_589538 = query.getOrDefault("key")
  valid_589538 = validateParameter(valid_589538, JString, required = false,
                                 default = nil)
  if valid_589538 != nil:
    section.add "key", valid_589538
  var valid_589539 = query.getOrDefault("prettyPrint")
  valid_589539 = validateParameter(valid_589539, JBool, required = false,
                                 default = newJBool(true))
  if valid_589539 != nil:
    section.add "prettyPrint", valid_589539
  var valid_589540 = query.getOrDefault("startIndex")
  valid_589540 = validateParameter(valid_589540, JString, required = false,
                                 default = nil)
  if valid_589540 != nil:
    section.add "startIndex", valid_589540
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589541: Call_BigqueryJobsGetQueryResults_589524; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the results of a query job.
  ## 
  let valid = call_589541.validator(path, query, header, formData, body)
  let scheme = call_589541.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589541.url(scheme.get, call_589541.host, call_589541.base,
                         call_589541.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589541, url, valid)

proc call*(call_589542: Call_BigqueryJobsGetQueryResults_589524; jobId: string;
          projectId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; location: string = ""; maxResults: int = 0;
          timeoutMs: int = 0; key: string = ""; prettyPrint: bool = true;
          startIndex: string = ""): Recallable =
  ## bigqueryJobsGetQueryResults
  ## Retrieves the results of a query job.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Page token, returned by a previous call, to request the next page of results
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   jobId: string (required)
  ##        : [Required] Job ID of the query job
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   location: string
  ##           : The geographic location where the job should run. Required except for US and EU. See details at https://cloud.google.com/bigquery/docs/locations#specifying_your_location.
  ##   maxResults: int
  ##             : Maximum number of results to read
  ##   timeoutMs: int
  ##            : How long to wait for the query to complete, in milliseconds, before returning. Default is 10 seconds. If the timeout passes before the job completes, the 'jobComplete' field in the response will be false
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : [Required] Project ID of the query job
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   startIndex: string
  ##             : Zero-based index of the starting row
  var path_589543 = newJObject()
  var query_589544 = newJObject()
  add(query_589544, "fields", newJString(fields))
  add(query_589544, "pageToken", newJString(pageToken))
  add(query_589544, "quotaUser", newJString(quotaUser))
  add(query_589544, "alt", newJString(alt))
  add(path_589543, "jobId", newJString(jobId))
  add(query_589544, "oauth_token", newJString(oauthToken))
  add(query_589544, "userIp", newJString(userIp))
  add(query_589544, "location", newJString(location))
  add(query_589544, "maxResults", newJInt(maxResults))
  add(query_589544, "timeoutMs", newJInt(timeoutMs))
  add(query_589544, "key", newJString(key))
  add(path_589543, "projectId", newJString(projectId))
  add(query_589544, "prettyPrint", newJBool(prettyPrint))
  add(query_589544, "startIndex", newJString(startIndex))
  result = call_589542.call(path_589543, query_589544, nil, nil, nil)

var bigqueryJobsGetQueryResults* = Call_BigqueryJobsGetQueryResults_589524(
    name: "bigqueryJobsGetQueryResults", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/queries/{jobId}",
    validator: validate_BigqueryJobsGetQueryResults_589525, base: "/bigquery/v2",
    url: url_BigqueryJobsGetQueryResults_589526, schemes: {Scheme.Https})
type
  Call_BigqueryProjectsGetServiceAccount_589545 = ref object of OpenApiRestCall_588466
proc url_BigqueryProjectsGetServiceAccount_589547(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/serviceAccount")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigqueryProjectsGetServiceAccount_589546(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the email address of the service account for your project used for interactions with Google Cloud KMS.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Project ID for which the service account is requested.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_589548 = path.getOrDefault("projectId")
  valid_589548 = validateParameter(valid_589548, JString, required = true,
                                 default = nil)
  if valid_589548 != nil:
    section.add "projectId", valid_589548
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
  var valid_589549 = query.getOrDefault("fields")
  valid_589549 = validateParameter(valid_589549, JString, required = false,
                                 default = nil)
  if valid_589549 != nil:
    section.add "fields", valid_589549
  var valid_589550 = query.getOrDefault("quotaUser")
  valid_589550 = validateParameter(valid_589550, JString, required = false,
                                 default = nil)
  if valid_589550 != nil:
    section.add "quotaUser", valid_589550
  var valid_589551 = query.getOrDefault("alt")
  valid_589551 = validateParameter(valid_589551, JString, required = false,
                                 default = newJString("json"))
  if valid_589551 != nil:
    section.add "alt", valid_589551
  var valid_589552 = query.getOrDefault("oauth_token")
  valid_589552 = validateParameter(valid_589552, JString, required = false,
                                 default = nil)
  if valid_589552 != nil:
    section.add "oauth_token", valid_589552
  var valid_589553 = query.getOrDefault("userIp")
  valid_589553 = validateParameter(valid_589553, JString, required = false,
                                 default = nil)
  if valid_589553 != nil:
    section.add "userIp", valid_589553
  var valid_589554 = query.getOrDefault("key")
  valid_589554 = validateParameter(valid_589554, JString, required = false,
                                 default = nil)
  if valid_589554 != nil:
    section.add "key", valid_589554
  var valid_589555 = query.getOrDefault("prettyPrint")
  valid_589555 = validateParameter(valid_589555, JBool, required = false,
                                 default = newJBool(true))
  if valid_589555 != nil:
    section.add "prettyPrint", valid_589555
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589556: Call_BigqueryProjectsGetServiceAccount_589545;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the email address of the service account for your project used for interactions with Google Cloud KMS.
  ## 
  let valid = call_589556.validator(path, query, header, formData, body)
  let scheme = call_589556.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589556.url(scheme.get, call_589556.host, call_589556.base,
                         call_589556.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589556, url, valid)

proc call*(call_589557: Call_BigqueryProjectsGetServiceAccount_589545;
          projectId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## bigqueryProjectsGetServiceAccount
  ## Returns the email address of the service account for your project used for interactions with Google Cloud KMS.
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
  ##   projectId: string (required)
  ##            : Project ID for which the service account is requested.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589558 = newJObject()
  var query_589559 = newJObject()
  add(query_589559, "fields", newJString(fields))
  add(query_589559, "quotaUser", newJString(quotaUser))
  add(query_589559, "alt", newJString(alt))
  add(query_589559, "oauth_token", newJString(oauthToken))
  add(query_589559, "userIp", newJString(userIp))
  add(query_589559, "key", newJString(key))
  add(path_589558, "projectId", newJString(projectId))
  add(query_589559, "prettyPrint", newJBool(prettyPrint))
  result = call_589557.call(path_589558, query_589559, nil, nil, nil)

var bigqueryProjectsGetServiceAccount* = Call_BigqueryProjectsGetServiceAccount_589545(
    name: "bigqueryProjectsGetServiceAccount", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/serviceAccount",
    validator: validate_BigqueryProjectsGetServiceAccount_589546,
    base: "/bigquery/v2", url: url_BigqueryProjectsGetServiceAccount_589547,
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
