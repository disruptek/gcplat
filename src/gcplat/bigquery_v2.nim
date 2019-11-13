
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

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

  OpenApiRestCall_579389 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579389](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579389): Option[Scheme] {.used.} =
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
  gcpServiceName = "bigquery"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BigqueryProjectsList_579659 = ref object of OpenApiRestCall_579389
proc url_BigqueryProjectsList_579661(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_BigqueryProjectsList_579660(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all projects to which you have been granted any project role.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  ##   pageToken: JString
  ##            : Page token, returned by a previous call, to request the next page of results
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of results to return
  section = newJObject()
  var valid_579773 = query.getOrDefault("key")
  valid_579773 = validateParameter(valid_579773, JString, required = false,
                                 default = nil)
  if valid_579773 != nil:
    section.add "key", valid_579773
  var valid_579787 = query.getOrDefault("prettyPrint")
  valid_579787 = validateParameter(valid_579787, JBool, required = false,
                                 default = newJBool(true))
  if valid_579787 != nil:
    section.add "prettyPrint", valid_579787
  var valid_579788 = query.getOrDefault("oauth_token")
  valid_579788 = validateParameter(valid_579788, JString, required = false,
                                 default = nil)
  if valid_579788 != nil:
    section.add "oauth_token", valid_579788
  var valid_579789 = query.getOrDefault("alt")
  valid_579789 = validateParameter(valid_579789, JString, required = false,
                                 default = newJString("json"))
  if valid_579789 != nil:
    section.add "alt", valid_579789
  var valid_579790 = query.getOrDefault("userIp")
  valid_579790 = validateParameter(valid_579790, JString, required = false,
                                 default = nil)
  if valid_579790 != nil:
    section.add "userIp", valid_579790
  var valid_579791 = query.getOrDefault("quotaUser")
  valid_579791 = validateParameter(valid_579791, JString, required = false,
                                 default = nil)
  if valid_579791 != nil:
    section.add "quotaUser", valid_579791
  var valid_579792 = query.getOrDefault("pageToken")
  valid_579792 = validateParameter(valid_579792, JString, required = false,
                                 default = nil)
  if valid_579792 != nil:
    section.add "pageToken", valid_579792
  var valid_579793 = query.getOrDefault("fields")
  valid_579793 = validateParameter(valid_579793, JString, required = false,
                                 default = nil)
  if valid_579793 != nil:
    section.add "fields", valid_579793
  var valid_579794 = query.getOrDefault("maxResults")
  valid_579794 = validateParameter(valid_579794, JInt, required = false, default = nil)
  if valid_579794 != nil:
    section.add "maxResults", valid_579794
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579817: Call_BigqueryProjectsList_579659; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all projects to which you have been granted any project role.
  ## 
  let valid = call_579817.validator(path, query, header, formData, body)
  let scheme = call_579817.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579817.url(scheme.get, call_579817.host, call_579817.base,
                         call_579817.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579817, url, valid)

proc call*(call_579888: Call_BigqueryProjectsList_579659; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          fields: string = ""; maxResults: int = 0): Recallable =
  ## bigqueryProjectsList
  ## Lists all projects to which you have been granted any project role.
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
  ##   pageToken: string
  ##            : Page token, returned by a previous call, to request the next page of results
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum number of results to return
  var query_579889 = newJObject()
  add(query_579889, "key", newJString(key))
  add(query_579889, "prettyPrint", newJBool(prettyPrint))
  add(query_579889, "oauth_token", newJString(oauthToken))
  add(query_579889, "alt", newJString(alt))
  add(query_579889, "userIp", newJString(userIp))
  add(query_579889, "quotaUser", newJString(quotaUser))
  add(query_579889, "pageToken", newJString(pageToken))
  add(query_579889, "fields", newJString(fields))
  add(query_579889, "maxResults", newJInt(maxResults))
  result = call_579888.call(nil, query_579889, nil, nil, nil)

var bigqueryProjectsList* = Call_BigqueryProjectsList_579659(
    name: "bigqueryProjectsList", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com", route: "/projects",
    validator: validate_BigqueryProjectsList_579660, base: "/bigquery/v2",
    url: url_BigqueryProjectsList_579661, schemes: {Scheme.Https})
type
  Call_BigqueryDatasetsInsert_579962 = ref object of OpenApiRestCall_579389
proc url_BigqueryDatasetsInsert_579964(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigqueryDatasetsInsert_579963(path: JsonNode; query: JsonNode;
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
  var valid_579965 = path.getOrDefault("projectId")
  valid_579965 = validateParameter(valid_579965, JString, required = true,
                                 default = nil)
  if valid_579965 != nil:
    section.add "projectId", valid_579965
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
  var valid_579966 = query.getOrDefault("key")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "key", valid_579966
  var valid_579967 = query.getOrDefault("prettyPrint")
  valid_579967 = validateParameter(valid_579967, JBool, required = false,
                                 default = newJBool(true))
  if valid_579967 != nil:
    section.add "prettyPrint", valid_579967
  var valid_579968 = query.getOrDefault("oauth_token")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "oauth_token", valid_579968
  var valid_579969 = query.getOrDefault("alt")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = newJString("json"))
  if valid_579969 != nil:
    section.add "alt", valid_579969
  var valid_579970 = query.getOrDefault("userIp")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "userIp", valid_579970
  var valid_579971 = query.getOrDefault("quotaUser")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "quotaUser", valid_579971
  var valid_579972 = query.getOrDefault("fields")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "fields", valid_579972
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

proc call*(call_579974: Call_BigqueryDatasetsInsert_579962; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new empty dataset.
  ## 
  let valid = call_579974.validator(path, query, header, formData, body)
  let scheme = call_579974.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579974.url(scheme.get, call_579974.host, call_579974.base,
                         call_579974.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579974, url, valid)

proc call*(call_579975: Call_BigqueryDatasetsInsert_579962; projectId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## bigqueryDatasetsInsert
  ## Creates a new empty dataset.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Project ID of the new dataset
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579976 = newJObject()
  var query_579977 = newJObject()
  var body_579978 = newJObject()
  add(query_579977, "key", newJString(key))
  add(query_579977, "prettyPrint", newJBool(prettyPrint))
  add(query_579977, "oauth_token", newJString(oauthToken))
  add(path_579976, "projectId", newJString(projectId))
  add(query_579977, "alt", newJString(alt))
  add(query_579977, "userIp", newJString(userIp))
  add(query_579977, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579978 = body
  add(query_579977, "fields", newJString(fields))
  result = call_579975.call(path_579976, query_579977, nil, nil, body_579978)

var bigqueryDatasetsInsert* = Call_BigqueryDatasetsInsert_579962(
    name: "bigqueryDatasetsInsert", meth: HttpMethod.HttpPost,
    host: "bigquery.googleapis.com", route: "/projects/{projectId}/datasets",
    validator: validate_BigqueryDatasetsInsert_579963, base: "/bigquery/v2",
    url: url_BigqueryDatasetsInsert_579964, schemes: {Scheme.Https})
type
  Call_BigqueryDatasetsList_579929 = ref object of OpenApiRestCall_579389
proc url_BigqueryDatasetsList_579931(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigqueryDatasetsList_579930(path: JsonNode; query: JsonNode;
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
  var valid_579946 = path.getOrDefault("projectId")
  valid_579946 = validateParameter(valid_579946, JString, required = true,
                                 default = nil)
  if valid_579946 != nil:
    section.add "projectId", valid_579946
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   all: JBool
  ##      : Whether to list all datasets, including hidden ones
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   filter: JString
  ##         : An expression for filtering the results of the request by label. The syntax is "labels.<name>[:<value>]". Multiple filters can be ANDed together by connecting with a space. Example: "labels.department:receiving labels.active". See Filtering datasets using labels for details.
  ##   pageToken: JString
  ##            : Page token, returned by a previous call, to request the next page of results
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of results to return
  section = newJObject()
  var valid_579947 = query.getOrDefault("key")
  valid_579947 = validateParameter(valid_579947, JString, required = false,
                                 default = nil)
  if valid_579947 != nil:
    section.add "key", valid_579947
  var valid_579948 = query.getOrDefault("prettyPrint")
  valid_579948 = validateParameter(valid_579948, JBool, required = false,
                                 default = newJBool(true))
  if valid_579948 != nil:
    section.add "prettyPrint", valid_579948
  var valid_579949 = query.getOrDefault("oauth_token")
  valid_579949 = validateParameter(valid_579949, JString, required = false,
                                 default = nil)
  if valid_579949 != nil:
    section.add "oauth_token", valid_579949
  var valid_579950 = query.getOrDefault("all")
  valid_579950 = validateParameter(valid_579950, JBool, required = false, default = nil)
  if valid_579950 != nil:
    section.add "all", valid_579950
  var valid_579951 = query.getOrDefault("alt")
  valid_579951 = validateParameter(valid_579951, JString, required = false,
                                 default = newJString("json"))
  if valid_579951 != nil:
    section.add "alt", valid_579951
  var valid_579952 = query.getOrDefault("userIp")
  valid_579952 = validateParameter(valid_579952, JString, required = false,
                                 default = nil)
  if valid_579952 != nil:
    section.add "userIp", valid_579952
  var valid_579953 = query.getOrDefault("quotaUser")
  valid_579953 = validateParameter(valid_579953, JString, required = false,
                                 default = nil)
  if valid_579953 != nil:
    section.add "quotaUser", valid_579953
  var valid_579954 = query.getOrDefault("filter")
  valid_579954 = validateParameter(valid_579954, JString, required = false,
                                 default = nil)
  if valid_579954 != nil:
    section.add "filter", valid_579954
  var valid_579955 = query.getOrDefault("pageToken")
  valid_579955 = validateParameter(valid_579955, JString, required = false,
                                 default = nil)
  if valid_579955 != nil:
    section.add "pageToken", valid_579955
  var valid_579956 = query.getOrDefault("fields")
  valid_579956 = validateParameter(valid_579956, JString, required = false,
                                 default = nil)
  if valid_579956 != nil:
    section.add "fields", valid_579956
  var valid_579957 = query.getOrDefault("maxResults")
  valid_579957 = validateParameter(valid_579957, JInt, required = false, default = nil)
  if valid_579957 != nil:
    section.add "maxResults", valid_579957
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579958: Call_BigqueryDatasetsList_579929; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all datasets in the specified project to which you have been granted the READER dataset role.
  ## 
  let valid = call_579958.validator(path, query, header, formData, body)
  let scheme = call_579958.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579958.url(scheme.get, call_579958.host, call_579958.base,
                         call_579958.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579958, url, valid)

proc call*(call_579959: Call_BigqueryDatasetsList_579929; projectId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          all: bool = false; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; filter: string = ""; pageToken: string = "";
          fields: string = ""; maxResults: int = 0): Recallable =
  ## bigqueryDatasetsList
  ## Lists all datasets in the specified project to which you have been granted the READER dataset role.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Project ID of the datasets to be listed
  ##   all: bool
  ##      : Whether to list all datasets, including hidden ones
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   filter: string
  ##         : An expression for filtering the results of the request by label. The syntax is "labels.<name>[:<value>]". Multiple filters can be ANDed together by connecting with a space. Example: "labels.department:receiving labels.active". See Filtering datasets using labels for details.
  ##   pageToken: string
  ##            : Page token, returned by a previous call, to request the next page of results
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of results to return
  var path_579960 = newJObject()
  var query_579961 = newJObject()
  add(query_579961, "key", newJString(key))
  add(query_579961, "prettyPrint", newJBool(prettyPrint))
  add(query_579961, "oauth_token", newJString(oauthToken))
  add(path_579960, "projectId", newJString(projectId))
  add(query_579961, "all", newJBool(all))
  add(query_579961, "alt", newJString(alt))
  add(query_579961, "userIp", newJString(userIp))
  add(query_579961, "quotaUser", newJString(quotaUser))
  add(query_579961, "filter", newJString(filter))
  add(query_579961, "pageToken", newJString(pageToken))
  add(query_579961, "fields", newJString(fields))
  add(query_579961, "maxResults", newJInt(maxResults))
  result = call_579959.call(path_579960, query_579961, nil, nil, nil)

var bigqueryDatasetsList* = Call_BigqueryDatasetsList_579929(
    name: "bigqueryDatasetsList", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com", route: "/projects/{projectId}/datasets",
    validator: validate_BigqueryDatasetsList_579930, base: "/bigquery/v2",
    url: url_BigqueryDatasetsList_579931, schemes: {Scheme.Https})
type
  Call_BigqueryDatasetsUpdate_579995 = ref object of OpenApiRestCall_579389
proc url_BigqueryDatasetsUpdate_579997(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigqueryDatasetsUpdate_579996(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates information in an existing dataset. The update method replaces the entire dataset resource, whereas the patch method only replaces fields that are provided in the submitted dataset resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Project ID of the dataset being updated
  ##   datasetId: JString (required)
  ##            : Dataset ID of the dataset being updated
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579998 = path.getOrDefault("projectId")
  valid_579998 = validateParameter(valid_579998, JString, required = true,
                                 default = nil)
  if valid_579998 != nil:
    section.add "projectId", valid_579998
  var valid_579999 = path.getOrDefault("datasetId")
  valid_579999 = validateParameter(valid_579999, JString, required = true,
                                 default = nil)
  if valid_579999 != nil:
    section.add "datasetId", valid_579999
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
  var valid_580000 = query.getOrDefault("key")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "key", valid_580000
  var valid_580001 = query.getOrDefault("prettyPrint")
  valid_580001 = validateParameter(valid_580001, JBool, required = false,
                                 default = newJBool(true))
  if valid_580001 != nil:
    section.add "prettyPrint", valid_580001
  var valid_580002 = query.getOrDefault("oauth_token")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "oauth_token", valid_580002
  var valid_580003 = query.getOrDefault("alt")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = newJString("json"))
  if valid_580003 != nil:
    section.add "alt", valid_580003
  var valid_580004 = query.getOrDefault("userIp")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "userIp", valid_580004
  var valid_580005 = query.getOrDefault("quotaUser")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "quotaUser", valid_580005
  var valid_580006 = query.getOrDefault("fields")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "fields", valid_580006
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

proc call*(call_580008: Call_BigqueryDatasetsUpdate_579995; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates information in an existing dataset. The update method replaces the entire dataset resource, whereas the patch method only replaces fields that are provided in the submitted dataset resource.
  ## 
  let valid = call_580008.validator(path, query, header, formData, body)
  let scheme = call_580008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580008.url(scheme.get, call_580008.host, call_580008.base,
                         call_580008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580008, url, valid)

proc call*(call_580009: Call_BigqueryDatasetsUpdate_579995; projectId: string;
          datasetId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## bigqueryDatasetsUpdate
  ## Updates information in an existing dataset. The update method replaces the entire dataset resource, whereas the patch method only replaces fields that are provided in the submitted dataset resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Project ID of the dataset being updated
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   datasetId: string (required)
  ##            : Dataset ID of the dataset being updated
  var path_580010 = newJObject()
  var query_580011 = newJObject()
  var body_580012 = newJObject()
  add(query_580011, "key", newJString(key))
  add(query_580011, "prettyPrint", newJBool(prettyPrint))
  add(query_580011, "oauth_token", newJString(oauthToken))
  add(path_580010, "projectId", newJString(projectId))
  add(query_580011, "alt", newJString(alt))
  add(query_580011, "userIp", newJString(userIp))
  add(query_580011, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580012 = body
  add(query_580011, "fields", newJString(fields))
  add(path_580010, "datasetId", newJString(datasetId))
  result = call_580009.call(path_580010, query_580011, nil, nil, body_580012)

var bigqueryDatasetsUpdate* = Call_BigqueryDatasetsUpdate_579995(
    name: "bigqueryDatasetsUpdate", meth: HttpMethod.HttpPut,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}",
    validator: validate_BigqueryDatasetsUpdate_579996, base: "/bigquery/v2",
    url: url_BigqueryDatasetsUpdate_579997, schemes: {Scheme.Https})
type
  Call_BigqueryDatasetsGet_579979 = ref object of OpenApiRestCall_579389
proc url_BigqueryDatasetsGet_579981(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigqueryDatasetsGet_579980(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Returns the dataset specified by datasetID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Project ID of the requested dataset
  ##   datasetId: JString (required)
  ##            : Dataset ID of the requested dataset
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579982 = path.getOrDefault("projectId")
  valid_579982 = validateParameter(valid_579982, JString, required = true,
                                 default = nil)
  if valid_579982 != nil:
    section.add "projectId", valid_579982
  var valid_579983 = path.getOrDefault("datasetId")
  valid_579983 = validateParameter(valid_579983, JString, required = true,
                                 default = nil)
  if valid_579983 != nil:
    section.add "datasetId", valid_579983
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
  var valid_579984 = query.getOrDefault("key")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "key", valid_579984
  var valid_579985 = query.getOrDefault("prettyPrint")
  valid_579985 = validateParameter(valid_579985, JBool, required = false,
                                 default = newJBool(true))
  if valid_579985 != nil:
    section.add "prettyPrint", valid_579985
  var valid_579986 = query.getOrDefault("oauth_token")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "oauth_token", valid_579986
  var valid_579987 = query.getOrDefault("alt")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = newJString("json"))
  if valid_579987 != nil:
    section.add "alt", valid_579987
  var valid_579988 = query.getOrDefault("userIp")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "userIp", valid_579988
  var valid_579989 = query.getOrDefault("quotaUser")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "quotaUser", valid_579989
  var valid_579990 = query.getOrDefault("fields")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "fields", valid_579990
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579991: Call_BigqueryDatasetsGet_579979; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the dataset specified by datasetID.
  ## 
  let valid = call_579991.validator(path, query, header, formData, body)
  let scheme = call_579991.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579991.url(scheme.get, call_579991.host, call_579991.base,
                         call_579991.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579991, url, valid)

proc call*(call_579992: Call_BigqueryDatasetsGet_579979; projectId: string;
          datasetId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## bigqueryDatasetsGet
  ## Returns the dataset specified by datasetID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Project ID of the requested dataset
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   datasetId: string (required)
  ##            : Dataset ID of the requested dataset
  var path_579993 = newJObject()
  var query_579994 = newJObject()
  add(query_579994, "key", newJString(key))
  add(query_579994, "prettyPrint", newJBool(prettyPrint))
  add(query_579994, "oauth_token", newJString(oauthToken))
  add(path_579993, "projectId", newJString(projectId))
  add(query_579994, "alt", newJString(alt))
  add(query_579994, "userIp", newJString(userIp))
  add(query_579994, "quotaUser", newJString(quotaUser))
  add(query_579994, "fields", newJString(fields))
  add(path_579993, "datasetId", newJString(datasetId))
  result = call_579992.call(path_579993, query_579994, nil, nil, nil)

var bigqueryDatasetsGet* = Call_BigqueryDatasetsGet_579979(
    name: "bigqueryDatasetsGet", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}",
    validator: validate_BigqueryDatasetsGet_579980, base: "/bigquery/v2",
    url: url_BigqueryDatasetsGet_579981, schemes: {Scheme.Https})
type
  Call_BigqueryDatasetsPatch_580030 = ref object of OpenApiRestCall_579389
proc url_BigqueryDatasetsPatch_580032(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigqueryDatasetsPatch_580031(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates information in an existing dataset. The update method replaces the entire dataset resource, whereas the patch method only replaces fields that are provided in the submitted dataset resource. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Project ID of the dataset being updated
  ##   datasetId: JString (required)
  ##            : Dataset ID of the dataset being updated
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580033 = path.getOrDefault("projectId")
  valid_580033 = validateParameter(valid_580033, JString, required = true,
                                 default = nil)
  if valid_580033 != nil:
    section.add "projectId", valid_580033
  var valid_580034 = path.getOrDefault("datasetId")
  valid_580034 = validateParameter(valid_580034, JString, required = true,
                                 default = nil)
  if valid_580034 != nil:
    section.add "datasetId", valid_580034
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
  var valid_580035 = query.getOrDefault("key")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "key", valid_580035
  var valid_580036 = query.getOrDefault("prettyPrint")
  valid_580036 = validateParameter(valid_580036, JBool, required = false,
                                 default = newJBool(true))
  if valid_580036 != nil:
    section.add "prettyPrint", valid_580036
  var valid_580037 = query.getOrDefault("oauth_token")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "oauth_token", valid_580037
  var valid_580038 = query.getOrDefault("alt")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = newJString("json"))
  if valid_580038 != nil:
    section.add "alt", valid_580038
  var valid_580039 = query.getOrDefault("userIp")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "userIp", valid_580039
  var valid_580040 = query.getOrDefault("quotaUser")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "quotaUser", valid_580040
  var valid_580041 = query.getOrDefault("fields")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "fields", valid_580041
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

proc call*(call_580043: Call_BigqueryDatasetsPatch_580030; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates information in an existing dataset. The update method replaces the entire dataset resource, whereas the patch method only replaces fields that are provided in the submitted dataset resource. This method supports patch semantics.
  ## 
  let valid = call_580043.validator(path, query, header, formData, body)
  let scheme = call_580043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580043.url(scheme.get, call_580043.host, call_580043.base,
                         call_580043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580043, url, valid)

proc call*(call_580044: Call_BigqueryDatasetsPatch_580030; projectId: string;
          datasetId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## bigqueryDatasetsPatch
  ## Updates information in an existing dataset. The update method replaces the entire dataset resource, whereas the patch method only replaces fields that are provided in the submitted dataset resource. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Project ID of the dataset being updated
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   datasetId: string (required)
  ##            : Dataset ID of the dataset being updated
  var path_580045 = newJObject()
  var query_580046 = newJObject()
  var body_580047 = newJObject()
  add(query_580046, "key", newJString(key))
  add(query_580046, "prettyPrint", newJBool(prettyPrint))
  add(query_580046, "oauth_token", newJString(oauthToken))
  add(path_580045, "projectId", newJString(projectId))
  add(query_580046, "alt", newJString(alt))
  add(query_580046, "userIp", newJString(userIp))
  add(query_580046, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580047 = body
  add(query_580046, "fields", newJString(fields))
  add(path_580045, "datasetId", newJString(datasetId))
  result = call_580044.call(path_580045, query_580046, nil, nil, body_580047)

var bigqueryDatasetsPatch* = Call_BigqueryDatasetsPatch_580030(
    name: "bigqueryDatasetsPatch", meth: HttpMethod.HttpPatch,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}",
    validator: validate_BigqueryDatasetsPatch_580031, base: "/bigquery/v2",
    url: url_BigqueryDatasetsPatch_580032, schemes: {Scheme.Https})
type
  Call_BigqueryDatasetsDelete_580013 = ref object of OpenApiRestCall_579389
proc url_BigqueryDatasetsDelete_580015(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigqueryDatasetsDelete_580014(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the dataset specified by the datasetId value. Before you can delete a dataset, you must delete all its tables, either manually or by specifying deleteContents. Immediately after deletion, you can create another dataset with the same name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Project ID of the dataset being deleted
  ##   datasetId: JString (required)
  ##            : Dataset ID of dataset being deleted
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580016 = path.getOrDefault("projectId")
  valid_580016 = validateParameter(valid_580016, JString, required = true,
                                 default = nil)
  if valid_580016 != nil:
    section.add "projectId", valid_580016
  var valid_580017 = path.getOrDefault("datasetId")
  valid_580017 = validateParameter(valid_580017, JString, required = true,
                                 default = nil)
  if valid_580017 != nil:
    section.add "datasetId", valid_580017
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   deleteContents: JBool
  ##                 : If True, delete all the tables in the dataset. If False and the dataset contains tables, the request will fail. Default is False
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580018 = query.getOrDefault("key")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "key", valid_580018
  var valid_580019 = query.getOrDefault("prettyPrint")
  valid_580019 = validateParameter(valid_580019, JBool, required = false,
                                 default = newJBool(true))
  if valid_580019 != nil:
    section.add "prettyPrint", valid_580019
  var valid_580020 = query.getOrDefault("oauth_token")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "oauth_token", valid_580020
  var valid_580021 = query.getOrDefault("deleteContents")
  valid_580021 = validateParameter(valid_580021, JBool, required = false, default = nil)
  if valid_580021 != nil:
    section.add "deleteContents", valid_580021
  var valid_580022 = query.getOrDefault("alt")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = newJString("json"))
  if valid_580022 != nil:
    section.add "alt", valid_580022
  var valid_580023 = query.getOrDefault("userIp")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "userIp", valid_580023
  var valid_580024 = query.getOrDefault("quotaUser")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "quotaUser", valid_580024
  var valid_580025 = query.getOrDefault("fields")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "fields", valid_580025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580026: Call_BigqueryDatasetsDelete_580013; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the dataset specified by the datasetId value. Before you can delete a dataset, you must delete all its tables, either manually or by specifying deleteContents. Immediately after deletion, you can create another dataset with the same name.
  ## 
  let valid = call_580026.validator(path, query, header, formData, body)
  let scheme = call_580026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580026.url(scheme.get, call_580026.host, call_580026.base,
                         call_580026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580026, url, valid)

proc call*(call_580027: Call_BigqueryDatasetsDelete_580013; projectId: string;
          datasetId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; deleteContents: bool = false; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## bigqueryDatasetsDelete
  ## Deletes the dataset specified by the datasetId value. Before you can delete a dataset, you must delete all its tables, either manually or by specifying deleteContents. Immediately after deletion, you can create another dataset with the same name.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Project ID of the dataset being deleted
  ##   deleteContents: bool
  ##                 : If True, delete all the tables in the dataset. If False and the dataset contains tables, the request will fail. Default is False
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   datasetId: string (required)
  ##            : Dataset ID of dataset being deleted
  var path_580028 = newJObject()
  var query_580029 = newJObject()
  add(query_580029, "key", newJString(key))
  add(query_580029, "prettyPrint", newJBool(prettyPrint))
  add(query_580029, "oauth_token", newJString(oauthToken))
  add(path_580028, "projectId", newJString(projectId))
  add(query_580029, "deleteContents", newJBool(deleteContents))
  add(query_580029, "alt", newJString(alt))
  add(query_580029, "userIp", newJString(userIp))
  add(query_580029, "quotaUser", newJString(quotaUser))
  add(query_580029, "fields", newJString(fields))
  add(path_580028, "datasetId", newJString(datasetId))
  result = call_580027.call(path_580028, query_580029, nil, nil, nil)

var bigqueryDatasetsDelete* = Call_BigqueryDatasetsDelete_580013(
    name: "bigqueryDatasetsDelete", meth: HttpMethod.HttpDelete,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}",
    validator: validate_BigqueryDatasetsDelete_580014, base: "/bigquery/v2",
    url: url_BigqueryDatasetsDelete_580015, schemes: {Scheme.Https})
type
  Call_BigqueryModelsList_580048 = ref object of OpenApiRestCall_579389
proc url_BigqueryModelsList_580050(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigqueryModelsList_580049(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists all models in the specified dataset. Requires the READER dataset
  ## role.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required. Project ID of the models to list.
  ##   datasetId: JString (required)
  ##            : Required. Dataset ID of the models to list.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580051 = path.getOrDefault("projectId")
  valid_580051 = validateParameter(valid_580051, JString, required = true,
                                 default = nil)
  if valid_580051 != nil:
    section.add "projectId", valid_580051
  var valid_580052 = path.getOrDefault("datasetId")
  valid_580052 = validateParameter(valid_580052, JString, required = true,
                                 default = nil)
  if valid_580052 != nil:
    section.add "datasetId", valid_580052
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
  ##   pageToken: JString
  ##            : Page token, returned by a previous call to request the next page of
  ## results
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of results to return in a single response page.
  ## Leverage the page tokens to iterate through the entire collection.
  section = newJObject()
  var valid_580053 = query.getOrDefault("key")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "key", valid_580053
  var valid_580054 = query.getOrDefault("prettyPrint")
  valid_580054 = validateParameter(valid_580054, JBool, required = false,
                                 default = newJBool(true))
  if valid_580054 != nil:
    section.add "prettyPrint", valid_580054
  var valid_580055 = query.getOrDefault("oauth_token")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "oauth_token", valid_580055
  var valid_580056 = query.getOrDefault("alt")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = newJString("json"))
  if valid_580056 != nil:
    section.add "alt", valid_580056
  var valid_580057 = query.getOrDefault("userIp")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "userIp", valid_580057
  var valid_580058 = query.getOrDefault("quotaUser")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "quotaUser", valid_580058
  var valid_580059 = query.getOrDefault("pageToken")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "pageToken", valid_580059
  var valid_580060 = query.getOrDefault("fields")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "fields", valid_580060
  var valid_580061 = query.getOrDefault("maxResults")
  valid_580061 = validateParameter(valid_580061, JInt, required = false, default = nil)
  if valid_580061 != nil:
    section.add "maxResults", valid_580061
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580062: Call_BigqueryModelsList_580048; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all models in the specified dataset. Requires the READER dataset
  ## role.
  ## 
  let valid = call_580062.validator(path, query, header, formData, body)
  let scheme = call_580062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580062.url(scheme.get, call_580062.host, call_580062.base,
                         call_580062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580062, url, valid)

proc call*(call_580063: Call_BigqueryModelsList_580048; projectId: string;
          datasetId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; fields: string = "";
          maxResults: int = 0): Recallable =
  ## bigqueryModelsList
  ## Lists all models in the specified dataset. Requires the READER dataset
  ## role.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Required. Project ID of the models to list.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : Page token, returned by a previous call to request the next page of
  ## results
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of results to return in a single response page.
  ## Leverage the page tokens to iterate through the entire collection.
  ##   datasetId: string (required)
  ##            : Required. Dataset ID of the models to list.
  var path_580064 = newJObject()
  var query_580065 = newJObject()
  add(query_580065, "key", newJString(key))
  add(query_580065, "prettyPrint", newJBool(prettyPrint))
  add(query_580065, "oauth_token", newJString(oauthToken))
  add(path_580064, "projectId", newJString(projectId))
  add(query_580065, "alt", newJString(alt))
  add(query_580065, "userIp", newJString(userIp))
  add(query_580065, "quotaUser", newJString(quotaUser))
  add(query_580065, "pageToken", newJString(pageToken))
  add(query_580065, "fields", newJString(fields))
  add(query_580065, "maxResults", newJInt(maxResults))
  add(path_580064, "datasetId", newJString(datasetId))
  result = call_580063.call(path_580064, query_580065, nil, nil, nil)

var bigqueryModelsList* = Call_BigqueryModelsList_580048(
    name: "bigqueryModelsList", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/models",
    validator: validate_BigqueryModelsList_580049, base: "/bigquery/v2",
    url: url_BigqueryModelsList_580050, schemes: {Scheme.Https})
type
  Call_BigqueryModelsGet_580066 = ref object of OpenApiRestCall_579389
proc url_BigqueryModelsGet_580068(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigqueryModelsGet_580067(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets the specified model resource by model ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required. Project ID of the requested model.
  ##   modelId: JString (required)
  ##          : Required. Model ID of the requested model.
  ##   datasetId: JString (required)
  ##            : Required. Dataset ID of the requested model.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580069 = path.getOrDefault("projectId")
  valid_580069 = validateParameter(valid_580069, JString, required = true,
                                 default = nil)
  if valid_580069 != nil:
    section.add "projectId", valid_580069
  var valid_580070 = path.getOrDefault("modelId")
  valid_580070 = validateParameter(valid_580070, JString, required = true,
                                 default = nil)
  if valid_580070 != nil:
    section.add "modelId", valid_580070
  var valid_580071 = path.getOrDefault("datasetId")
  valid_580071 = validateParameter(valid_580071, JString, required = true,
                                 default = nil)
  if valid_580071 != nil:
    section.add "datasetId", valid_580071
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
  var valid_580072 = query.getOrDefault("key")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "key", valid_580072
  var valid_580073 = query.getOrDefault("prettyPrint")
  valid_580073 = validateParameter(valid_580073, JBool, required = false,
                                 default = newJBool(true))
  if valid_580073 != nil:
    section.add "prettyPrint", valid_580073
  var valid_580074 = query.getOrDefault("oauth_token")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "oauth_token", valid_580074
  var valid_580075 = query.getOrDefault("alt")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = newJString("json"))
  if valid_580075 != nil:
    section.add "alt", valid_580075
  var valid_580076 = query.getOrDefault("userIp")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "userIp", valid_580076
  var valid_580077 = query.getOrDefault("quotaUser")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "quotaUser", valid_580077
  var valid_580078 = query.getOrDefault("fields")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "fields", valid_580078
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580079: Call_BigqueryModelsGet_580066; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified model resource by model ID.
  ## 
  let valid = call_580079.validator(path, query, header, formData, body)
  let scheme = call_580079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580079.url(scheme.get, call_580079.host, call_580079.base,
                         call_580079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580079, url, valid)

proc call*(call_580080: Call_BigqueryModelsGet_580066; projectId: string;
          modelId: string; datasetId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## bigqueryModelsGet
  ## Gets the specified model resource by model ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Required. Project ID of the requested model.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   modelId: string (required)
  ##          : Required. Model ID of the requested model.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   datasetId: string (required)
  ##            : Required. Dataset ID of the requested model.
  var path_580081 = newJObject()
  var query_580082 = newJObject()
  add(query_580082, "key", newJString(key))
  add(query_580082, "prettyPrint", newJBool(prettyPrint))
  add(query_580082, "oauth_token", newJString(oauthToken))
  add(path_580081, "projectId", newJString(projectId))
  add(query_580082, "alt", newJString(alt))
  add(query_580082, "userIp", newJString(userIp))
  add(query_580082, "quotaUser", newJString(quotaUser))
  add(path_580081, "modelId", newJString(modelId))
  add(query_580082, "fields", newJString(fields))
  add(path_580081, "datasetId", newJString(datasetId))
  result = call_580080.call(path_580081, query_580082, nil, nil, nil)

var bigqueryModelsGet* = Call_BigqueryModelsGet_580066(name: "bigqueryModelsGet",
    meth: HttpMethod.HttpGet, host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/models/{modelId}",
    validator: validate_BigqueryModelsGet_580067, base: "/bigquery/v2",
    url: url_BigqueryModelsGet_580068, schemes: {Scheme.Https})
type
  Call_BigqueryModelsPatch_580100 = ref object of OpenApiRestCall_579389
proc url_BigqueryModelsPatch_580102(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigqueryModelsPatch_580101(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Patch specific fields in the specified model.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required. Project ID of the model to patch.
  ##   modelId: JString (required)
  ##          : Required. Model ID of the model to patch.
  ##   datasetId: JString (required)
  ##            : Required. Dataset ID of the model to patch.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580103 = path.getOrDefault("projectId")
  valid_580103 = validateParameter(valid_580103, JString, required = true,
                                 default = nil)
  if valid_580103 != nil:
    section.add "projectId", valid_580103
  var valid_580104 = path.getOrDefault("modelId")
  valid_580104 = validateParameter(valid_580104, JString, required = true,
                                 default = nil)
  if valid_580104 != nil:
    section.add "modelId", valid_580104
  var valid_580105 = path.getOrDefault("datasetId")
  valid_580105 = validateParameter(valid_580105, JString, required = true,
                                 default = nil)
  if valid_580105 != nil:
    section.add "datasetId", valid_580105
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
  var valid_580108 = query.getOrDefault("oauth_token")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "oauth_token", valid_580108
  var valid_580109 = query.getOrDefault("alt")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = newJString("json"))
  if valid_580109 != nil:
    section.add "alt", valid_580109
  var valid_580110 = query.getOrDefault("userIp")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "userIp", valid_580110
  var valid_580111 = query.getOrDefault("quotaUser")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "quotaUser", valid_580111
  var valid_580112 = query.getOrDefault("fields")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "fields", valid_580112
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

proc call*(call_580114: Call_BigqueryModelsPatch_580100; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch specific fields in the specified model.
  ## 
  let valid = call_580114.validator(path, query, header, formData, body)
  let scheme = call_580114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580114.url(scheme.get, call_580114.host, call_580114.base,
                         call_580114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580114, url, valid)

proc call*(call_580115: Call_BigqueryModelsPatch_580100; projectId: string;
          modelId: string; datasetId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## bigqueryModelsPatch
  ## Patch specific fields in the specified model.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Required. Project ID of the model to patch.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   modelId: string (required)
  ##          : Required. Model ID of the model to patch.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   datasetId: string (required)
  ##            : Required. Dataset ID of the model to patch.
  var path_580116 = newJObject()
  var query_580117 = newJObject()
  var body_580118 = newJObject()
  add(query_580117, "key", newJString(key))
  add(query_580117, "prettyPrint", newJBool(prettyPrint))
  add(query_580117, "oauth_token", newJString(oauthToken))
  add(path_580116, "projectId", newJString(projectId))
  add(query_580117, "alt", newJString(alt))
  add(query_580117, "userIp", newJString(userIp))
  add(query_580117, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580118 = body
  add(path_580116, "modelId", newJString(modelId))
  add(query_580117, "fields", newJString(fields))
  add(path_580116, "datasetId", newJString(datasetId))
  result = call_580115.call(path_580116, query_580117, nil, nil, body_580118)

var bigqueryModelsPatch* = Call_BigqueryModelsPatch_580100(
    name: "bigqueryModelsPatch", meth: HttpMethod.HttpPatch,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/models/{modelId}",
    validator: validate_BigqueryModelsPatch_580101, base: "/bigquery/v2",
    url: url_BigqueryModelsPatch_580102, schemes: {Scheme.Https})
type
  Call_BigqueryModelsDelete_580083 = ref object of OpenApiRestCall_579389
proc url_BigqueryModelsDelete_580085(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigqueryModelsDelete_580084(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the model specified by modelId from the dataset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required. Project ID of the model to delete.
  ##   modelId: JString (required)
  ##          : Required. Model ID of the model to delete.
  ##   datasetId: JString (required)
  ##            : Required. Dataset ID of the model to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580086 = path.getOrDefault("projectId")
  valid_580086 = validateParameter(valid_580086, JString, required = true,
                                 default = nil)
  if valid_580086 != nil:
    section.add "projectId", valid_580086
  var valid_580087 = path.getOrDefault("modelId")
  valid_580087 = validateParameter(valid_580087, JString, required = true,
                                 default = nil)
  if valid_580087 != nil:
    section.add "modelId", valid_580087
  var valid_580088 = path.getOrDefault("datasetId")
  valid_580088 = validateParameter(valid_580088, JString, required = true,
                                 default = nil)
  if valid_580088 != nil:
    section.add "datasetId", valid_580088
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
  var valid_580089 = query.getOrDefault("key")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "key", valid_580089
  var valid_580090 = query.getOrDefault("prettyPrint")
  valid_580090 = validateParameter(valid_580090, JBool, required = false,
                                 default = newJBool(true))
  if valid_580090 != nil:
    section.add "prettyPrint", valid_580090
  var valid_580091 = query.getOrDefault("oauth_token")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "oauth_token", valid_580091
  var valid_580092 = query.getOrDefault("alt")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = newJString("json"))
  if valid_580092 != nil:
    section.add "alt", valid_580092
  var valid_580093 = query.getOrDefault("userIp")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "userIp", valid_580093
  var valid_580094 = query.getOrDefault("quotaUser")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "quotaUser", valid_580094
  var valid_580095 = query.getOrDefault("fields")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "fields", valid_580095
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580096: Call_BigqueryModelsDelete_580083; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the model specified by modelId from the dataset.
  ## 
  let valid = call_580096.validator(path, query, header, formData, body)
  let scheme = call_580096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580096.url(scheme.get, call_580096.host, call_580096.base,
                         call_580096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580096, url, valid)

proc call*(call_580097: Call_BigqueryModelsDelete_580083; projectId: string;
          modelId: string; datasetId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## bigqueryModelsDelete
  ## Deletes the model specified by modelId from the dataset.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Required. Project ID of the model to delete.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   modelId: string (required)
  ##          : Required. Model ID of the model to delete.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   datasetId: string (required)
  ##            : Required. Dataset ID of the model to delete.
  var path_580098 = newJObject()
  var query_580099 = newJObject()
  add(query_580099, "key", newJString(key))
  add(query_580099, "prettyPrint", newJBool(prettyPrint))
  add(query_580099, "oauth_token", newJString(oauthToken))
  add(path_580098, "projectId", newJString(projectId))
  add(query_580099, "alt", newJString(alt))
  add(query_580099, "userIp", newJString(userIp))
  add(query_580099, "quotaUser", newJString(quotaUser))
  add(path_580098, "modelId", newJString(modelId))
  add(query_580099, "fields", newJString(fields))
  add(path_580098, "datasetId", newJString(datasetId))
  result = call_580097.call(path_580098, query_580099, nil, nil, nil)

var bigqueryModelsDelete* = Call_BigqueryModelsDelete_580083(
    name: "bigqueryModelsDelete", meth: HttpMethod.HttpDelete,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/models/{modelId}",
    validator: validate_BigqueryModelsDelete_580084, base: "/bigquery/v2",
    url: url_BigqueryModelsDelete_580085, schemes: {Scheme.Https})
type
  Call_BigqueryRoutinesInsert_580137 = ref object of OpenApiRestCall_579389
proc url_BigqueryRoutinesInsert_580139(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigqueryRoutinesInsert_580138(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new routine in the dataset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required. Project ID of the new routine
  ##   datasetId: JString (required)
  ##            : Required. Dataset ID of the new routine
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580140 = path.getOrDefault("projectId")
  valid_580140 = validateParameter(valid_580140, JString, required = true,
                                 default = nil)
  if valid_580140 != nil:
    section.add "projectId", valid_580140
  var valid_580141 = path.getOrDefault("datasetId")
  valid_580141 = validateParameter(valid_580141, JString, required = true,
                                 default = nil)
  if valid_580141 != nil:
    section.add "datasetId", valid_580141
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
  var valid_580142 = query.getOrDefault("key")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "key", valid_580142
  var valid_580143 = query.getOrDefault("prettyPrint")
  valid_580143 = validateParameter(valid_580143, JBool, required = false,
                                 default = newJBool(true))
  if valid_580143 != nil:
    section.add "prettyPrint", valid_580143
  var valid_580144 = query.getOrDefault("oauth_token")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "oauth_token", valid_580144
  var valid_580145 = query.getOrDefault("alt")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = newJString("json"))
  if valid_580145 != nil:
    section.add "alt", valid_580145
  var valid_580146 = query.getOrDefault("userIp")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "userIp", valid_580146
  var valid_580147 = query.getOrDefault("quotaUser")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "quotaUser", valid_580147
  var valid_580148 = query.getOrDefault("fields")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "fields", valid_580148
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

proc call*(call_580150: Call_BigqueryRoutinesInsert_580137; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new routine in the dataset.
  ## 
  let valid = call_580150.validator(path, query, header, formData, body)
  let scheme = call_580150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580150.url(scheme.get, call_580150.host, call_580150.base,
                         call_580150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580150, url, valid)

proc call*(call_580151: Call_BigqueryRoutinesInsert_580137; projectId: string;
          datasetId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## bigqueryRoutinesInsert
  ## Creates a new routine in the dataset.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Required. Project ID of the new routine
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   datasetId: string (required)
  ##            : Required. Dataset ID of the new routine
  var path_580152 = newJObject()
  var query_580153 = newJObject()
  var body_580154 = newJObject()
  add(query_580153, "key", newJString(key))
  add(query_580153, "prettyPrint", newJBool(prettyPrint))
  add(query_580153, "oauth_token", newJString(oauthToken))
  add(path_580152, "projectId", newJString(projectId))
  add(query_580153, "alt", newJString(alt))
  add(query_580153, "userIp", newJString(userIp))
  add(query_580153, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580154 = body
  add(query_580153, "fields", newJString(fields))
  add(path_580152, "datasetId", newJString(datasetId))
  result = call_580151.call(path_580152, query_580153, nil, nil, body_580154)

var bigqueryRoutinesInsert* = Call_BigqueryRoutinesInsert_580137(
    name: "bigqueryRoutinesInsert", meth: HttpMethod.HttpPost,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/routines",
    validator: validate_BigqueryRoutinesInsert_580138, base: "/bigquery/v2",
    url: url_BigqueryRoutinesInsert_580139, schemes: {Scheme.Https})
type
  Call_BigqueryRoutinesList_580119 = ref object of OpenApiRestCall_579389
proc url_BigqueryRoutinesList_580121(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigqueryRoutinesList_580120(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all routines in the specified dataset. Requires the READER dataset
  ## role.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required. Project ID of the routines to list
  ##   datasetId: JString (required)
  ##            : Required. Dataset ID of the routines to list
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580122 = path.getOrDefault("projectId")
  valid_580122 = validateParameter(valid_580122, JString, required = true,
                                 default = nil)
  if valid_580122 != nil:
    section.add "projectId", valid_580122
  var valid_580123 = path.getOrDefault("datasetId")
  valid_580123 = validateParameter(valid_580123, JString, required = true,
                                 default = nil)
  if valid_580123 != nil:
    section.add "datasetId", valid_580123
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
  ##   pageToken: JString
  ##            : Page token, returned by a previous call, to request the next page of
  ## results
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of results to return in a single response page.
  ## Leverage the page tokens to iterate through the entire collection.
  section = newJObject()
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
  var valid_580126 = query.getOrDefault("oauth_token")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "oauth_token", valid_580126
  var valid_580127 = query.getOrDefault("alt")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = newJString("json"))
  if valid_580127 != nil:
    section.add "alt", valid_580127
  var valid_580128 = query.getOrDefault("userIp")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "userIp", valid_580128
  var valid_580129 = query.getOrDefault("quotaUser")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "quotaUser", valid_580129
  var valid_580130 = query.getOrDefault("pageToken")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "pageToken", valid_580130
  var valid_580131 = query.getOrDefault("fields")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "fields", valid_580131
  var valid_580132 = query.getOrDefault("maxResults")
  valid_580132 = validateParameter(valid_580132, JInt, required = false, default = nil)
  if valid_580132 != nil:
    section.add "maxResults", valid_580132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580133: Call_BigqueryRoutinesList_580119; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all routines in the specified dataset. Requires the READER dataset
  ## role.
  ## 
  let valid = call_580133.validator(path, query, header, formData, body)
  let scheme = call_580133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580133.url(scheme.get, call_580133.host, call_580133.base,
                         call_580133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580133, url, valid)

proc call*(call_580134: Call_BigqueryRoutinesList_580119; projectId: string;
          datasetId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; fields: string = "";
          maxResults: int = 0): Recallable =
  ## bigqueryRoutinesList
  ## Lists all routines in the specified dataset. Requires the READER dataset
  ## role.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Required. Project ID of the routines to list
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : Page token, returned by a previous call, to request the next page of
  ## results
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of results to return in a single response page.
  ## Leverage the page tokens to iterate through the entire collection.
  ##   datasetId: string (required)
  ##            : Required. Dataset ID of the routines to list
  var path_580135 = newJObject()
  var query_580136 = newJObject()
  add(query_580136, "key", newJString(key))
  add(query_580136, "prettyPrint", newJBool(prettyPrint))
  add(query_580136, "oauth_token", newJString(oauthToken))
  add(path_580135, "projectId", newJString(projectId))
  add(query_580136, "alt", newJString(alt))
  add(query_580136, "userIp", newJString(userIp))
  add(query_580136, "quotaUser", newJString(quotaUser))
  add(query_580136, "pageToken", newJString(pageToken))
  add(query_580136, "fields", newJString(fields))
  add(query_580136, "maxResults", newJInt(maxResults))
  add(path_580135, "datasetId", newJString(datasetId))
  result = call_580134.call(path_580135, query_580136, nil, nil, nil)

var bigqueryRoutinesList* = Call_BigqueryRoutinesList_580119(
    name: "bigqueryRoutinesList", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/routines",
    validator: validate_BigqueryRoutinesList_580120, base: "/bigquery/v2",
    url: url_BigqueryRoutinesList_580121, schemes: {Scheme.Https})
type
  Call_BigqueryRoutinesUpdate_580172 = ref object of OpenApiRestCall_579389
proc url_BigqueryRoutinesUpdate_580174(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigqueryRoutinesUpdate_580173(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates information in an existing routine. The update method replaces the
  ## entire Routine resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required. Project ID of the routine to update
  ##   routineId: JString (required)
  ##            : Required. Routine ID of the routine to update
  ##   datasetId: JString (required)
  ##            : Required. Dataset ID of the routine to update
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580175 = path.getOrDefault("projectId")
  valid_580175 = validateParameter(valid_580175, JString, required = true,
                                 default = nil)
  if valid_580175 != nil:
    section.add "projectId", valid_580175
  var valid_580176 = path.getOrDefault("routineId")
  valid_580176 = validateParameter(valid_580176, JString, required = true,
                                 default = nil)
  if valid_580176 != nil:
    section.add "routineId", valid_580176
  var valid_580177 = path.getOrDefault("datasetId")
  valid_580177 = validateParameter(valid_580177, JString, required = true,
                                 default = nil)
  if valid_580177 != nil:
    section.add "datasetId", valid_580177
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
  var valid_580178 = query.getOrDefault("key")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "key", valid_580178
  var valid_580179 = query.getOrDefault("prettyPrint")
  valid_580179 = validateParameter(valid_580179, JBool, required = false,
                                 default = newJBool(true))
  if valid_580179 != nil:
    section.add "prettyPrint", valid_580179
  var valid_580180 = query.getOrDefault("oauth_token")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = nil)
  if valid_580180 != nil:
    section.add "oauth_token", valid_580180
  var valid_580181 = query.getOrDefault("alt")
  valid_580181 = validateParameter(valid_580181, JString, required = false,
                                 default = newJString("json"))
  if valid_580181 != nil:
    section.add "alt", valid_580181
  var valid_580182 = query.getOrDefault("userIp")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = nil)
  if valid_580182 != nil:
    section.add "userIp", valid_580182
  var valid_580183 = query.getOrDefault("quotaUser")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = nil)
  if valid_580183 != nil:
    section.add "quotaUser", valid_580183
  var valid_580184 = query.getOrDefault("fields")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "fields", valid_580184
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

proc call*(call_580186: Call_BigqueryRoutinesUpdate_580172; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates information in an existing routine. The update method replaces the
  ## entire Routine resource.
  ## 
  let valid = call_580186.validator(path, query, header, formData, body)
  let scheme = call_580186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580186.url(scheme.get, call_580186.host, call_580186.base,
                         call_580186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580186, url, valid)

proc call*(call_580187: Call_BigqueryRoutinesUpdate_580172; projectId: string;
          routineId: string; datasetId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## bigqueryRoutinesUpdate
  ## Updates information in an existing routine. The update method replaces the
  ## entire Routine resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Required. Project ID of the routine to update
  ##   routineId: string (required)
  ##            : Required. Routine ID of the routine to update
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   datasetId: string (required)
  ##            : Required. Dataset ID of the routine to update
  var path_580188 = newJObject()
  var query_580189 = newJObject()
  var body_580190 = newJObject()
  add(query_580189, "key", newJString(key))
  add(query_580189, "prettyPrint", newJBool(prettyPrint))
  add(query_580189, "oauth_token", newJString(oauthToken))
  add(path_580188, "projectId", newJString(projectId))
  add(path_580188, "routineId", newJString(routineId))
  add(query_580189, "alt", newJString(alt))
  add(query_580189, "userIp", newJString(userIp))
  add(query_580189, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580190 = body
  add(query_580189, "fields", newJString(fields))
  add(path_580188, "datasetId", newJString(datasetId))
  result = call_580187.call(path_580188, query_580189, nil, nil, body_580190)

var bigqueryRoutinesUpdate* = Call_BigqueryRoutinesUpdate_580172(
    name: "bigqueryRoutinesUpdate", meth: HttpMethod.HttpPut,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/routines/{routineId}",
    validator: validate_BigqueryRoutinesUpdate_580173, base: "/bigquery/v2",
    url: url_BigqueryRoutinesUpdate_580174, schemes: {Scheme.Https})
type
  Call_BigqueryRoutinesGet_580155 = ref object of OpenApiRestCall_579389
proc url_BigqueryRoutinesGet_580157(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigqueryRoutinesGet_580156(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets the specified routine resource by routine ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required. Project ID of the requested routine
  ##   routineId: JString (required)
  ##            : Required. Routine ID of the requested routine
  ##   datasetId: JString (required)
  ##            : Required. Dataset ID of the requested routine
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580158 = path.getOrDefault("projectId")
  valid_580158 = validateParameter(valid_580158, JString, required = true,
                                 default = nil)
  if valid_580158 != nil:
    section.add "projectId", valid_580158
  var valid_580159 = path.getOrDefault("routineId")
  valid_580159 = validateParameter(valid_580159, JString, required = true,
                                 default = nil)
  if valid_580159 != nil:
    section.add "routineId", valid_580159
  var valid_580160 = path.getOrDefault("datasetId")
  valid_580160 = validateParameter(valid_580160, JString, required = true,
                                 default = nil)
  if valid_580160 != nil:
    section.add "datasetId", valid_580160
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
  var valid_580163 = query.getOrDefault("oauth_token")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = nil)
  if valid_580163 != nil:
    section.add "oauth_token", valid_580163
  var valid_580164 = query.getOrDefault("alt")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = newJString("json"))
  if valid_580164 != nil:
    section.add "alt", valid_580164
  var valid_580165 = query.getOrDefault("userIp")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = nil)
  if valid_580165 != nil:
    section.add "userIp", valid_580165
  var valid_580166 = query.getOrDefault("quotaUser")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "quotaUser", valid_580166
  var valid_580167 = query.getOrDefault("fields")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "fields", valid_580167
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580168: Call_BigqueryRoutinesGet_580155; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified routine resource by routine ID.
  ## 
  let valid = call_580168.validator(path, query, header, formData, body)
  let scheme = call_580168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580168.url(scheme.get, call_580168.host, call_580168.base,
                         call_580168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580168, url, valid)

proc call*(call_580169: Call_BigqueryRoutinesGet_580155; projectId: string;
          routineId: string; datasetId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## bigqueryRoutinesGet
  ## Gets the specified routine resource by routine ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Required. Project ID of the requested routine
  ##   routineId: string (required)
  ##            : Required. Routine ID of the requested routine
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   datasetId: string (required)
  ##            : Required. Dataset ID of the requested routine
  var path_580170 = newJObject()
  var query_580171 = newJObject()
  add(query_580171, "key", newJString(key))
  add(query_580171, "prettyPrint", newJBool(prettyPrint))
  add(query_580171, "oauth_token", newJString(oauthToken))
  add(path_580170, "projectId", newJString(projectId))
  add(path_580170, "routineId", newJString(routineId))
  add(query_580171, "alt", newJString(alt))
  add(query_580171, "userIp", newJString(userIp))
  add(query_580171, "quotaUser", newJString(quotaUser))
  add(query_580171, "fields", newJString(fields))
  add(path_580170, "datasetId", newJString(datasetId))
  result = call_580169.call(path_580170, query_580171, nil, nil, nil)

var bigqueryRoutinesGet* = Call_BigqueryRoutinesGet_580155(
    name: "bigqueryRoutinesGet", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/routines/{routineId}",
    validator: validate_BigqueryRoutinesGet_580156, base: "/bigquery/v2",
    url: url_BigqueryRoutinesGet_580157, schemes: {Scheme.Https})
type
  Call_BigqueryRoutinesDelete_580191 = ref object of OpenApiRestCall_579389
proc url_BigqueryRoutinesDelete_580193(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigqueryRoutinesDelete_580192(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the routine specified by routineId from the dataset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required. Project ID of the routine to delete
  ##   routineId: JString (required)
  ##            : Required. Routine ID of the routine to delete
  ##   datasetId: JString (required)
  ##            : Required. Dataset ID of the routine to delete
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580194 = path.getOrDefault("projectId")
  valid_580194 = validateParameter(valid_580194, JString, required = true,
                                 default = nil)
  if valid_580194 != nil:
    section.add "projectId", valid_580194
  var valid_580195 = path.getOrDefault("routineId")
  valid_580195 = validateParameter(valid_580195, JString, required = true,
                                 default = nil)
  if valid_580195 != nil:
    section.add "routineId", valid_580195
  var valid_580196 = path.getOrDefault("datasetId")
  valid_580196 = validateParameter(valid_580196, JString, required = true,
                                 default = nil)
  if valid_580196 != nil:
    section.add "datasetId", valid_580196
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
  var valid_580197 = query.getOrDefault("key")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = nil)
  if valid_580197 != nil:
    section.add "key", valid_580197
  var valid_580198 = query.getOrDefault("prettyPrint")
  valid_580198 = validateParameter(valid_580198, JBool, required = false,
                                 default = newJBool(true))
  if valid_580198 != nil:
    section.add "prettyPrint", valid_580198
  var valid_580199 = query.getOrDefault("oauth_token")
  valid_580199 = validateParameter(valid_580199, JString, required = false,
                                 default = nil)
  if valid_580199 != nil:
    section.add "oauth_token", valid_580199
  var valid_580200 = query.getOrDefault("alt")
  valid_580200 = validateParameter(valid_580200, JString, required = false,
                                 default = newJString("json"))
  if valid_580200 != nil:
    section.add "alt", valid_580200
  var valid_580201 = query.getOrDefault("userIp")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = nil)
  if valid_580201 != nil:
    section.add "userIp", valid_580201
  var valid_580202 = query.getOrDefault("quotaUser")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = nil)
  if valid_580202 != nil:
    section.add "quotaUser", valid_580202
  var valid_580203 = query.getOrDefault("fields")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = nil)
  if valid_580203 != nil:
    section.add "fields", valid_580203
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580204: Call_BigqueryRoutinesDelete_580191; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the routine specified by routineId from the dataset.
  ## 
  let valid = call_580204.validator(path, query, header, formData, body)
  let scheme = call_580204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580204.url(scheme.get, call_580204.host, call_580204.base,
                         call_580204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580204, url, valid)

proc call*(call_580205: Call_BigqueryRoutinesDelete_580191; projectId: string;
          routineId: string; datasetId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## bigqueryRoutinesDelete
  ## Deletes the routine specified by routineId from the dataset.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Required. Project ID of the routine to delete
  ##   routineId: string (required)
  ##            : Required. Routine ID of the routine to delete
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   datasetId: string (required)
  ##            : Required. Dataset ID of the routine to delete
  var path_580206 = newJObject()
  var query_580207 = newJObject()
  add(query_580207, "key", newJString(key))
  add(query_580207, "prettyPrint", newJBool(prettyPrint))
  add(query_580207, "oauth_token", newJString(oauthToken))
  add(path_580206, "projectId", newJString(projectId))
  add(path_580206, "routineId", newJString(routineId))
  add(query_580207, "alt", newJString(alt))
  add(query_580207, "userIp", newJString(userIp))
  add(query_580207, "quotaUser", newJString(quotaUser))
  add(query_580207, "fields", newJString(fields))
  add(path_580206, "datasetId", newJString(datasetId))
  result = call_580205.call(path_580206, query_580207, nil, nil, nil)

var bigqueryRoutinesDelete* = Call_BigqueryRoutinesDelete_580191(
    name: "bigqueryRoutinesDelete", meth: HttpMethod.HttpDelete,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/routines/{routineId}",
    validator: validate_BigqueryRoutinesDelete_580192, base: "/bigquery/v2",
    url: url_BigqueryRoutinesDelete_580193, schemes: {Scheme.Https})
type
  Call_BigqueryTablesInsert_580226 = ref object of OpenApiRestCall_579389
proc url_BigqueryTablesInsert_580228(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigqueryTablesInsert_580227(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new, empty table in the dataset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Project ID of the new table
  ##   datasetId: JString (required)
  ##            : Dataset ID of the new table
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580229 = path.getOrDefault("projectId")
  valid_580229 = validateParameter(valid_580229, JString, required = true,
                                 default = nil)
  if valid_580229 != nil:
    section.add "projectId", valid_580229
  var valid_580230 = path.getOrDefault("datasetId")
  valid_580230 = validateParameter(valid_580230, JString, required = true,
                                 default = nil)
  if valid_580230 != nil:
    section.add "datasetId", valid_580230
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
  var valid_580231 = query.getOrDefault("key")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "key", valid_580231
  var valid_580232 = query.getOrDefault("prettyPrint")
  valid_580232 = validateParameter(valid_580232, JBool, required = false,
                                 default = newJBool(true))
  if valid_580232 != nil:
    section.add "prettyPrint", valid_580232
  var valid_580233 = query.getOrDefault("oauth_token")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = nil)
  if valid_580233 != nil:
    section.add "oauth_token", valid_580233
  var valid_580234 = query.getOrDefault("alt")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = newJString("json"))
  if valid_580234 != nil:
    section.add "alt", valid_580234
  var valid_580235 = query.getOrDefault("userIp")
  valid_580235 = validateParameter(valid_580235, JString, required = false,
                                 default = nil)
  if valid_580235 != nil:
    section.add "userIp", valid_580235
  var valid_580236 = query.getOrDefault("quotaUser")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = nil)
  if valid_580236 != nil:
    section.add "quotaUser", valid_580236
  var valid_580237 = query.getOrDefault("fields")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = nil)
  if valid_580237 != nil:
    section.add "fields", valid_580237
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

proc call*(call_580239: Call_BigqueryTablesInsert_580226; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new, empty table in the dataset.
  ## 
  let valid = call_580239.validator(path, query, header, formData, body)
  let scheme = call_580239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580239.url(scheme.get, call_580239.host, call_580239.base,
                         call_580239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580239, url, valid)

proc call*(call_580240: Call_BigqueryTablesInsert_580226; projectId: string;
          datasetId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## bigqueryTablesInsert
  ## Creates a new, empty table in the dataset.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Project ID of the new table
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   datasetId: string (required)
  ##            : Dataset ID of the new table
  var path_580241 = newJObject()
  var query_580242 = newJObject()
  var body_580243 = newJObject()
  add(query_580242, "key", newJString(key))
  add(query_580242, "prettyPrint", newJBool(prettyPrint))
  add(query_580242, "oauth_token", newJString(oauthToken))
  add(path_580241, "projectId", newJString(projectId))
  add(query_580242, "alt", newJString(alt))
  add(query_580242, "userIp", newJString(userIp))
  add(query_580242, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580243 = body
  add(query_580242, "fields", newJString(fields))
  add(path_580241, "datasetId", newJString(datasetId))
  result = call_580240.call(path_580241, query_580242, nil, nil, body_580243)

var bigqueryTablesInsert* = Call_BigqueryTablesInsert_580226(
    name: "bigqueryTablesInsert", meth: HttpMethod.HttpPost,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/tables",
    validator: validate_BigqueryTablesInsert_580227, base: "/bigquery/v2",
    url: url_BigqueryTablesInsert_580228, schemes: {Scheme.Https})
type
  Call_BigqueryTablesList_580208 = ref object of OpenApiRestCall_579389
proc url_BigqueryTablesList_580210(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigqueryTablesList_580209(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists all tables in the specified dataset. Requires the READER dataset role.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Project ID of the tables to list
  ##   datasetId: JString (required)
  ##            : Dataset ID of the tables to list
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580211 = path.getOrDefault("projectId")
  valid_580211 = validateParameter(valid_580211, JString, required = true,
                                 default = nil)
  if valid_580211 != nil:
    section.add "projectId", valid_580211
  var valid_580212 = path.getOrDefault("datasetId")
  valid_580212 = validateParameter(valid_580212, JString, required = true,
                                 default = nil)
  if valid_580212 != nil:
    section.add "datasetId", valid_580212
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
  ##   pageToken: JString
  ##            : Page token, returned by a previous call, to request the next page of results
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of results to return
  section = newJObject()
  var valid_580213 = query.getOrDefault("key")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = nil)
  if valid_580213 != nil:
    section.add "key", valid_580213
  var valid_580214 = query.getOrDefault("prettyPrint")
  valid_580214 = validateParameter(valid_580214, JBool, required = false,
                                 default = newJBool(true))
  if valid_580214 != nil:
    section.add "prettyPrint", valid_580214
  var valid_580215 = query.getOrDefault("oauth_token")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "oauth_token", valid_580215
  var valid_580216 = query.getOrDefault("alt")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = newJString("json"))
  if valid_580216 != nil:
    section.add "alt", valid_580216
  var valid_580217 = query.getOrDefault("userIp")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = nil)
  if valid_580217 != nil:
    section.add "userIp", valid_580217
  var valid_580218 = query.getOrDefault("quotaUser")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = nil)
  if valid_580218 != nil:
    section.add "quotaUser", valid_580218
  var valid_580219 = query.getOrDefault("pageToken")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = nil)
  if valid_580219 != nil:
    section.add "pageToken", valid_580219
  var valid_580220 = query.getOrDefault("fields")
  valid_580220 = validateParameter(valid_580220, JString, required = false,
                                 default = nil)
  if valid_580220 != nil:
    section.add "fields", valid_580220
  var valid_580221 = query.getOrDefault("maxResults")
  valid_580221 = validateParameter(valid_580221, JInt, required = false, default = nil)
  if valid_580221 != nil:
    section.add "maxResults", valid_580221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580222: Call_BigqueryTablesList_580208; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all tables in the specified dataset. Requires the READER dataset role.
  ## 
  let valid = call_580222.validator(path, query, header, formData, body)
  let scheme = call_580222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580222.url(scheme.get, call_580222.host, call_580222.base,
                         call_580222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580222, url, valid)

proc call*(call_580223: Call_BigqueryTablesList_580208; projectId: string;
          datasetId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; fields: string = "";
          maxResults: int = 0): Recallable =
  ## bigqueryTablesList
  ## Lists all tables in the specified dataset. Requires the READER dataset role.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Project ID of the tables to list
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : Page token, returned by a previous call, to request the next page of results
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum number of results to return
  ##   datasetId: string (required)
  ##            : Dataset ID of the tables to list
  var path_580224 = newJObject()
  var query_580225 = newJObject()
  add(query_580225, "key", newJString(key))
  add(query_580225, "prettyPrint", newJBool(prettyPrint))
  add(query_580225, "oauth_token", newJString(oauthToken))
  add(path_580224, "projectId", newJString(projectId))
  add(query_580225, "alt", newJString(alt))
  add(query_580225, "userIp", newJString(userIp))
  add(query_580225, "quotaUser", newJString(quotaUser))
  add(query_580225, "pageToken", newJString(pageToken))
  add(query_580225, "fields", newJString(fields))
  add(query_580225, "maxResults", newJInt(maxResults))
  add(path_580224, "datasetId", newJString(datasetId))
  result = call_580223.call(path_580224, query_580225, nil, nil, nil)

var bigqueryTablesList* = Call_BigqueryTablesList_580208(
    name: "bigqueryTablesList", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/tables",
    validator: validate_BigqueryTablesList_580209, base: "/bigquery/v2",
    url: url_BigqueryTablesList_580210, schemes: {Scheme.Https})
type
  Call_BigqueryTablesUpdate_580262 = ref object of OpenApiRestCall_579389
proc url_BigqueryTablesUpdate_580264(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigqueryTablesUpdate_580263(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates information in an existing table. The update method replaces the entire table resource, whereas the patch method only replaces fields that are provided in the submitted table resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Project ID of the table to update
  ##   tableId: JString (required)
  ##          : Table ID of the table to update
  ##   datasetId: JString (required)
  ##            : Dataset ID of the table to update
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580265 = path.getOrDefault("projectId")
  valid_580265 = validateParameter(valid_580265, JString, required = true,
                                 default = nil)
  if valid_580265 != nil:
    section.add "projectId", valid_580265
  var valid_580266 = path.getOrDefault("tableId")
  valid_580266 = validateParameter(valid_580266, JString, required = true,
                                 default = nil)
  if valid_580266 != nil:
    section.add "tableId", valid_580266
  var valid_580267 = path.getOrDefault("datasetId")
  valid_580267 = validateParameter(valid_580267, JString, required = true,
                                 default = nil)
  if valid_580267 != nil:
    section.add "datasetId", valid_580267
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
  var valid_580268 = query.getOrDefault("key")
  valid_580268 = validateParameter(valid_580268, JString, required = false,
                                 default = nil)
  if valid_580268 != nil:
    section.add "key", valid_580268
  var valid_580269 = query.getOrDefault("prettyPrint")
  valid_580269 = validateParameter(valid_580269, JBool, required = false,
                                 default = newJBool(true))
  if valid_580269 != nil:
    section.add "prettyPrint", valid_580269
  var valid_580270 = query.getOrDefault("oauth_token")
  valid_580270 = validateParameter(valid_580270, JString, required = false,
                                 default = nil)
  if valid_580270 != nil:
    section.add "oauth_token", valid_580270
  var valid_580271 = query.getOrDefault("alt")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = newJString("json"))
  if valid_580271 != nil:
    section.add "alt", valid_580271
  var valid_580272 = query.getOrDefault("userIp")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = nil)
  if valid_580272 != nil:
    section.add "userIp", valid_580272
  var valid_580273 = query.getOrDefault("quotaUser")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = nil)
  if valid_580273 != nil:
    section.add "quotaUser", valid_580273
  var valid_580274 = query.getOrDefault("fields")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = nil)
  if valid_580274 != nil:
    section.add "fields", valid_580274
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

proc call*(call_580276: Call_BigqueryTablesUpdate_580262; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates information in an existing table. The update method replaces the entire table resource, whereas the patch method only replaces fields that are provided in the submitted table resource.
  ## 
  let valid = call_580276.validator(path, query, header, formData, body)
  let scheme = call_580276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580276.url(scheme.get, call_580276.host, call_580276.base,
                         call_580276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580276, url, valid)

proc call*(call_580277: Call_BigqueryTablesUpdate_580262; projectId: string;
          tableId: string; datasetId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## bigqueryTablesUpdate
  ## Updates information in an existing table. The update method replaces the entire table resource, whereas the patch method only replaces fields that are provided in the submitted table resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Project ID of the table to update
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   tableId: string (required)
  ##          : Table ID of the table to update
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   datasetId: string (required)
  ##            : Dataset ID of the table to update
  var path_580278 = newJObject()
  var query_580279 = newJObject()
  var body_580280 = newJObject()
  add(query_580279, "key", newJString(key))
  add(query_580279, "prettyPrint", newJBool(prettyPrint))
  add(query_580279, "oauth_token", newJString(oauthToken))
  add(path_580278, "projectId", newJString(projectId))
  add(query_580279, "alt", newJString(alt))
  add(query_580279, "userIp", newJString(userIp))
  add(query_580279, "quotaUser", newJString(quotaUser))
  add(path_580278, "tableId", newJString(tableId))
  if body != nil:
    body_580280 = body
  add(query_580279, "fields", newJString(fields))
  add(path_580278, "datasetId", newJString(datasetId))
  result = call_580277.call(path_580278, query_580279, nil, nil, body_580280)

var bigqueryTablesUpdate* = Call_BigqueryTablesUpdate_580262(
    name: "bigqueryTablesUpdate", meth: HttpMethod.HttpPut,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/tables/{tableId}",
    validator: validate_BigqueryTablesUpdate_580263, base: "/bigquery/v2",
    url: url_BigqueryTablesUpdate_580264, schemes: {Scheme.Https})
type
  Call_BigqueryTablesGet_580244 = ref object of OpenApiRestCall_579389
proc url_BigqueryTablesGet_580246(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigqueryTablesGet_580245(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets the specified table resource by table ID. This method does not return the data in the table, it only returns the table resource, which describes the structure of this table.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Project ID of the requested table
  ##   tableId: JString (required)
  ##          : Table ID of the requested table
  ##   datasetId: JString (required)
  ##            : Dataset ID of the requested table
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580247 = path.getOrDefault("projectId")
  valid_580247 = validateParameter(valid_580247, JString, required = true,
                                 default = nil)
  if valid_580247 != nil:
    section.add "projectId", valid_580247
  var valid_580248 = path.getOrDefault("tableId")
  valid_580248 = validateParameter(valid_580248, JString, required = true,
                                 default = nil)
  if valid_580248 != nil:
    section.add "tableId", valid_580248
  var valid_580249 = path.getOrDefault("datasetId")
  valid_580249 = validateParameter(valid_580249, JString, required = true,
                                 default = nil)
  if valid_580249 != nil:
    section.add "datasetId", valid_580249
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
  ##   selectedFields: JString
  ##                 : List of fields to return (comma-separated). If unspecified, all fields are returned
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580250 = query.getOrDefault("key")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = nil)
  if valid_580250 != nil:
    section.add "key", valid_580250
  var valid_580251 = query.getOrDefault("prettyPrint")
  valid_580251 = validateParameter(valid_580251, JBool, required = false,
                                 default = newJBool(true))
  if valid_580251 != nil:
    section.add "prettyPrint", valid_580251
  var valid_580252 = query.getOrDefault("oauth_token")
  valid_580252 = validateParameter(valid_580252, JString, required = false,
                                 default = nil)
  if valid_580252 != nil:
    section.add "oauth_token", valid_580252
  var valid_580253 = query.getOrDefault("alt")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = newJString("json"))
  if valid_580253 != nil:
    section.add "alt", valid_580253
  var valid_580254 = query.getOrDefault("userIp")
  valid_580254 = validateParameter(valid_580254, JString, required = false,
                                 default = nil)
  if valid_580254 != nil:
    section.add "userIp", valid_580254
  var valid_580255 = query.getOrDefault("quotaUser")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = nil)
  if valid_580255 != nil:
    section.add "quotaUser", valid_580255
  var valid_580256 = query.getOrDefault("selectedFields")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = nil)
  if valid_580256 != nil:
    section.add "selectedFields", valid_580256
  var valid_580257 = query.getOrDefault("fields")
  valid_580257 = validateParameter(valid_580257, JString, required = false,
                                 default = nil)
  if valid_580257 != nil:
    section.add "fields", valid_580257
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580258: Call_BigqueryTablesGet_580244; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified table resource by table ID. This method does not return the data in the table, it only returns the table resource, which describes the structure of this table.
  ## 
  let valid = call_580258.validator(path, query, header, formData, body)
  let scheme = call_580258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580258.url(scheme.get, call_580258.host, call_580258.base,
                         call_580258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580258, url, valid)

proc call*(call_580259: Call_BigqueryTablesGet_580244; projectId: string;
          tableId: string; datasetId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; selectedFields: string = "";
          fields: string = ""): Recallable =
  ## bigqueryTablesGet
  ## Gets the specified table resource by table ID. This method does not return the data in the table, it only returns the table resource, which describes the structure of this table.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Project ID of the requested table
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   tableId: string (required)
  ##          : Table ID of the requested table
  ##   selectedFields: string
  ##                 : List of fields to return (comma-separated). If unspecified, all fields are returned
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   datasetId: string (required)
  ##            : Dataset ID of the requested table
  var path_580260 = newJObject()
  var query_580261 = newJObject()
  add(query_580261, "key", newJString(key))
  add(query_580261, "prettyPrint", newJBool(prettyPrint))
  add(query_580261, "oauth_token", newJString(oauthToken))
  add(path_580260, "projectId", newJString(projectId))
  add(query_580261, "alt", newJString(alt))
  add(query_580261, "userIp", newJString(userIp))
  add(query_580261, "quotaUser", newJString(quotaUser))
  add(path_580260, "tableId", newJString(tableId))
  add(query_580261, "selectedFields", newJString(selectedFields))
  add(query_580261, "fields", newJString(fields))
  add(path_580260, "datasetId", newJString(datasetId))
  result = call_580259.call(path_580260, query_580261, nil, nil, nil)

var bigqueryTablesGet* = Call_BigqueryTablesGet_580244(name: "bigqueryTablesGet",
    meth: HttpMethod.HttpGet, host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/tables/{tableId}",
    validator: validate_BigqueryTablesGet_580245, base: "/bigquery/v2",
    url: url_BigqueryTablesGet_580246, schemes: {Scheme.Https})
type
  Call_BigqueryTablesPatch_580298 = ref object of OpenApiRestCall_579389
proc url_BigqueryTablesPatch_580300(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigqueryTablesPatch_580299(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates information in an existing table. The update method replaces the entire table resource, whereas the patch method only replaces fields that are provided in the submitted table resource. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Project ID of the table to update
  ##   tableId: JString (required)
  ##          : Table ID of the table to update
  ##   datasetId: JString (required)
  ##            : Dataset ID of the table to update
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580301 = path.getOrDefault("projectId")
  valid_580301 = validateParameter(valid_580301, JString, required = true,
                                 default = nil)
  if valid_580301 != nil:
    section.add "projectId", valid_580301
  var valid_580302 = path.getOrDefault("tableId")
  valid_580302 = validateParameter(valid_580302, JString, required = true,
                                 default = nil)
  if valid_580302 != nil:
    section.add "tableId", valid_580302
  var valid_580303 = path.getOrDefault("datasetId")
  valid_580303 = validateParameter(valid_580303, JString, required = true,
                                 default = nil)
  if valid_580303 != nil:
    section.add "datasetId", valid_580303
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
  var valid_580304 = query.getOrDefault("key")
  valid_580304 = validateParameter(valid_580304, JString, required = false,
                                 default = nil)
  if valid_580304 != nil:
    section.add "key", valid_580304
  var valid_580305 = query.getOrDefault("prettyPrint")
  valid_580305 = validateParameter(valid_580305, JBool, required = false,
                                 default = newJBool(true))
  if valid_580305 != nil:
    section.add "prettyPrint", valid_580305
  var valid_580306 = query.getOrDefault("oauth_token")
  valid_580306 = validateParameter(valid_580306, JString, required = false,
                                 default = nil)
  if valid_580306 != nil:
    section.add "oauth_token", valid_580306
  var valid_580307 = query.getOrDefault("alt")
  valid_580307 = validateParameter(valid_580307, JString, required = false,
                                 default = newJString("json"))
  if valid_580307 != nil:
    section.add "alt", valid_580307
  var valid_580308 = query.getOrDefault("userIp")
  valid_580308 = validateParameter(valid_580308, JString, required = false,
                                 default = nil)
  if valid_580308 != nil:
    section.add "userIp", valid_580308
  var valid_580309 = query.getOrDefault("quotaUser")
  valid_580309 = validateParameter(valid_580309, JString, required = false,
                                 default = nil)
  if valid_580309 != nil:
    section.add "quotaUser", valid_580309
  var valid_580310 = query.getOrDefault("fields")
  valid_580310 = validateParameter(valid_580310, JString, required = false,
                                 default = nil)
  if valid_580310 != nil:
    section.add "fields", valid_580310
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

proc call*(call_580312: Call_BigqueryTablesPatch_580298; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates information in an existing table. The update method replaces the entire table resource, whereas the patch method only replaces fields that are provided in the submitted table resource. This method supports patch semantics.
  ## 
  let valid = call_580312.validator(path, query, header, formData, body)
  let scheme = call_580312.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580312.url(scheme.get, call_580312.host, call_580312.base,
                         call_580312.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580312, url, valid)

proc call*(call_580313: Call_BigqueryTablesPatch_580298; projectId: string;
          tableId: string; datasetId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## bigqueryTablesPatch
  ## Updates information in an existing table. The update method replaces the entire table resource, whereas the patch method only replaces fields that are provided in the submitted table resource. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Project ID of the table to update
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   tableId: string (required)
  ##          : Table ID of the table to update
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   datasetId: string (required)
  ##            : Dataset ID of the table to update
  var path_580314 = newJObject()
  var query_580315 = newJObject()
  var body_580316 = newJObject()
  add(query_580315, "key", newJString(key))
  add(query_580315, "prettyPrint", newJBool(prettyPrint))
  add(query_580315, "oauth_token", newJString(oauthToken))
  add(path_580314, "projectId", newJString(projectId))
  add(query_580315, "alt", newJString(alt))
  add(query_580315, "userIp", newJString(userIp))
  add(query_580315, "quotaUser", newJString(quotaUser))
  add(path_580314, "tableId", newJString(tableId))
  if body != nil:
    body_580316 = body
  add(query_580315, "fields", newJString(fields))
  add(path_580314, "datasetId", newJString(datasetId))
  result = call_580313.call(path_580314, query_580315, nil, nil, body_580316)

var bigqueryTablesPatch* = Call_BigqueryTablesPatch_580298(
    name: "bigqueryTablesPatch", meth: HttpMethod.HttpPatch,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/tables/{tableId}",
    validator: validate_BigqueryTablesPatch_580299, base: "/bigquery/v2",
    url: url_BigqueryTablesPatch_580300, schemes: {Scheme.Https})
type
  Call_BigqueryTablesDelete_580281 = ref object of OpenApiRestCall_579389
proc url_BigqueryTablesDelete_580283(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigqueryTablesDelete_580282(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the table specified by tableId from the dataset. If the table contains data, all the data will be deleted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Project ID of the table to delete
  ##   tableId: JString (required)
  ##          : Table ID of the table to delete
  ##   datasetId: JString (required)
  ##            : Dataset ID of the table to delete
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580284 = path.getOrDefault("projectId")
  valid_580284 = validateParameter(valid_580284, JString, required = true,
                                 default = nil)
  if valid_580284 != nil:
    section.add "projectId", valid_580284
  var valid_580285 = path.getOrDefault("tableId")
  valid_580285 = validateParameter(valid_580285, JString, required = true,
                                 default = nil)
  if valid_580285 != nil:
    section.add "tableId", valid_580285
  var valid_580286 = path.getOrDefault("datasetId")
  valid_580286 = validateParameter(valid_580286, JString, required = true,
                                 default = nil)
  if valid_580286 != nil:
    section.add "datasetId", valid_580286
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
  var valid_580287 = query.getOrDefault("key")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "key", valid_580287
  var valid_580288 = query.getOrDefault("prettyPrint")
  valid_580288 = validateParameter(valid_580288, JBool, required = false,
                                 default = newJBool(true))
  if valid_580288 != nil:
    section.add "prettyPrint", valid_580288
  var valid_580289 = query.getOrDefault("oauth_token")
  valid_580289 = validateParameter(valid_580289, JString, required = false,
                                 default = nil)
  if valid_580289 != nil:
    section.add "oauth_token", valid_580289
  var valid_580290 = query.getOrDefault("alt")
  valid_580290 = validateParameter(valid_580290, JString, required = false,
                                 default = newJString("json"))
  if valid_580290 != nil:
    section.add "alt", valid_580290
  var valid_580291 = query.getOrDefault("userIp")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = nil)
  if valid_580291 != nil:
    section.add "userIp", valid_580291
  var valid_580292 = query.getOrDefault("quotaUser")
  valid_580292 = validateParameter(valid_580292, JString, required = false,
                                 default = nil)
  if valid_580292 != nil:
    section.add "quotaUser", valid_580292
  var valid_580293 = query.getOrDefault("fields")
  valid_580293 = validateParameter(valid_580293, JString, required = false,
                                 default = nil)
  if valid_580293 != nil:
    section.add "fields", valid_580293
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580294: Call_BigqueryTablesDelete_580281; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the table specified by tableId from the dataset. If the table contains data, all the data will be deleted.
  ## 
  let valid = call_580294.validator(path, query, header, formData, body)
  let scheme = call_580294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580294.url(scheme.get, call_580294.host, call_580294.base,
                         call_580294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580294, url, valid)

proc call*(call_580295: Call_BigqueryTablesDelete_580281; projectId: string;
          tableId: string; datasetId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## bigqueryTablesDelete
  ## Deletes the table specified by tableId from the dataset. If the table contains data, all the data will be deleted.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Project ID of the table to delete
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   tableId: string (required)
  ##          : Table ID of the table to delete
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   datasetId: string (required)
  ##            : Dataset ID of the table to delete
  var path_580296 = newJObject()
  var query_580297 = newJObject()
  add(query_580297, "key", newJString(key))
  add(query_580297, "prettyPrint", newJBool(prettyPrint))
  add(query_580297, "oauth_token", newJString(oauthToken))
  add(path_580296, "projectId", newJString(projectId))
  add(query_580297, "alt", newJString(alt))
  add(query_580297, "userIp", newJString(userIp))
  add(query_580297, "quotaUser", newJString(quotaUser))
  add(path_580296, "tableId", newJString(tableId))
  add(query_580297, "fields", newJString(fields))
  add(path_580296, "datasetId", newJString(datasetId))
  result = call_580295.call(path_580296, query_580297, nil, nil, nil)

var bigqueryTablesDelete* = Call_BigqueryTablesDelete_580281(
    name: "bigqueryTablesDelete", meth: HttpMethod.HttpDelete,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/tables/{tableId}",
    validator: validate_BigqueryTablesDelete_580282, base: "/bigquery/v2",
    url: url_BigqueryTablesDelete_580283, schemes: {Scheme.Https})
type
  Call_BigqueryTabledataList_580317 = ref object of OpenApiRestCall_579389
proc url_BigqueryTabledataList_580319(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigqueryTabledataList_580318(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves table data from a specified set of rows. Requires the READER dataset role.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Project ID of the table to read
  ##   tableId: JString (required)
  ##          : Table ID of the table to read
  ##   datasetId: JString (required)
  ##            : Dataset ID of the table to read
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580320 = path.getOrDefault("projectId")
  valid_580320 = validateParameter(valid_580320, JString, required = true,
                                 default = nil)
  if valid_580320 != nil:
    section.add "projectId", valid_580320
  var valid_580321 = path.getOrDefault("tableId")
  valid_580321 = validateParameter(valid_580321, JString, required = true,
                                 default = nil)
  if valid_580321 != nil:
    section.add "tableId", valid_580321
  var valid_580322 = path.getOrDefault("datasetId")
  valid_580322 = validateParameter(valid_580322, JString, required = true,
                                 default = nil)
  if valid_580322 != nil:
    section.add "datasetId", valid_580322
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
  ##   startIndex: JString
  ##             : Zero-based index of the starting row to read
  ##   pageToken: JString
  ##            : Page token, returned by a previous call, identifying the result set
  ##   selectedFields: JString
  ##                 : List of fields to return (comma-separated). If unspecified, all fields are returned
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of results to return
  section = newJObject()
  var valid_580323 = query.getOrDefault("key")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = nil)
  if valid_580323 != nil:
    section.add "key", valid_580323
  var valid_580324 = query.getOrDefault("prettyPrint")
  valid_580324 = validateParameter(valid_580324, JBool, required = false,
                                 default = newJBool(true))
  if valid_580324 != nil:
    section.add "prettyPrint", valid_580324
  var valid_580325 = query.getOrDefault("oauth_token")
  valid_580325 = validateParameter(valid_580325, JString, required = false,
                                 default = nil)
  if valid_580325 != nil:
    section.add "oauth_token", valid_580325
  var valid_580326 = query.getOrDefault("alt")
  valid_580326 = validateParameter(valid_580326, JString, required = false,
                                 default = newJString("json"))
  if valid_580326 != nil:
    section.add "alt", valid_580326
  var valid_580327 = query.getOrDefault("userIp")
  valid_580327 = validateParameter(valid_580327, JString, required = false,
                                 default = nil)
  if valid_580327 != nil:
    section.add "userIp", valid_580327
  var valid_580328 = query.getOrDefault("quotaUser")
  valid_580328 = validateParameter(valid_580328, JString, required = false,
                                 default = nil)
  if valid_580328 != nil:
    section.add "quotaUser", valid_580328
  var valid_580329 = query.getOrDefault("startIndex")
  valid_580329 = validateParameter(valid_580329, JString, required = false,
                                 default = nil)
  if valid_580329 != nil:
    section.add "startIndex", valid_580329
  var valid_580330 = query.getOrDefault("pageToken")
  valid_580330 = validateParameter(valid_580330, JString, required = false,
                                 default = nil)
  if valid_580330 != nil:
    section.add "pageToken", valid_580330
  var valid_580331 = query.getOrDefault("selectedFields")
  valid_580331 = validateParameter(valid_580331, JString, required = false,
                                 default = nil)
  if valid_580331 != nil:
    section.add "selectedFields", valid_580331
  var valid_580332 = query.getOrDefault("fields")
  valid_580332 = validateParameter(valid_580332, JString, required = false,
                                 default = nil)
  if valid_580332 != nil:
    section.add "fields", valid_580332
  var valid_580333 = query.getOrDefault("maxResults")
  valid_580333 = validateParameter(valid_580333, JInt, required = false, default = nil)
  if valid_580333 != nil:
    section.add "maxResults", valid_580333
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580334: Call_BigqueryTabledataList_580317; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves table data from a specified set of rows. Requires the READER dataset role.
  ## 
  let valid = call_580334.validator(path, query, header, formData, body)
  let scheme = call_580334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580334.url(scheme.get, call_580334.host, call_580334.base,
                         call_580334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580334, url, valid)

proc call*(call_580335: Call_BigqueryTabledataList_580317; projectId: string;
          tableId: string; datasetId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; startIndex: string = "";
          pageToken: string = ""; selectedFields: string = ""; fields: string = "";
          maxResults: int = 0): Recallable =
  ## bigqueryTabledataList
  ## Retrieves table data from a specified set of rows. Requires the READER dataset role.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Project ID of the table to read
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: string
  ##             : Zero-based index of the starting row to read
  ##   pageToken: string
  ##            : Page token, returned by a previous call, identifying the result set
  ##   tableId: string (required)
  ##          : Table ID of the table to read
  ##   selectedFields: string
  ##                 : List of fields to return (comma-separated). If unspecified, all fields are returned
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum number of results to return
  ##   datasetId: string (required)
  ##            : Dataset ID of the table to read
  var path_580336 = newJObject()
  var query_580337 = newJObject()
  add(query_580337, "key", newJString(key))
  add(query_580337, "prettyPrint", newJBool(prettyPrint))
  add(query_580337, "oauth_token", newJString(oauthToken))
  add(path_580336, "projectId", newJString(projectId))
  add(query_580337, "alt", newJString(alt))
  add(query_580337, "userIp", newJString(userIp))
  add(query_580337, "quotaUser", newJString(quotaUser))
  add(query_580337, "startIndex", newJString(startIndex))
  add(query_580337, "pageToken", newJString(pageToken))
  add(path_580336, "tableId", newJString(tableId))
  add(query_580337, "selectedFields", newJString(selectedFields))
  add(query_580337, "fields", newJString(fields))
  add(query_580337, "maxResults", newJInt(maxResults))
  add(path_580336, "datasetId", newJString(datasetId))
  result = call_580335.call(path_580336, query_580337, nil, nil, nil)

var bigqueryTabledataList* = Call_BigqueryTabledataList_580317(
    name: "bigqueryTabledataList", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/tables/{tableId}/data",
    validator: validate_BigqueryTabledataList_580318, base: "/bigquery/v2",
    url: url_BigqueryTabledataList_580319, schemes: {Scheme.Https})
type
  Call_BigqueryTabledataInsertAll_580338 = ref object of OpenApiRestCall_579389
proc url_BigqueryTabledataInsertAll_580340(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigqueryTabledataInsertAll_580339(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Streams data into BigQuery one record at a time without needing to run a load job. Requires the WRITER dataset role.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Project ID of the destination table.
  ##   tableId: JString (required)
  ##          : Table ID of the destination table.
  ##   datasetId: JString (required)
  ##            : Dataset ID of the destination table.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580341 = path.getOrDefault("projectId")
  valid_580341 = validateParameter(valid_580341, JString, required = true,
                                 default = nil)
  if valid_580341 != nil:
    section.add "projectId", valid_580341
  var valid_580342 = path.getOrDefault("tableId")
  valid_580342 = validateParameter(valid_580342, JString, required = true,
                                 default = nil)
  if valid_580342 != nil:
    section.add "tableId", valid_580342
  var valid_580343 = path.getOrDefault("datasetId")
  valid_580343 = validateParameter(valid_580343, JString, required = true,
                                 default = nil)
  if valid_580343 != nil:
    section.add "datasetId", valid_580343
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
  var valid_580344 = query.getOrDefault("key")
  valid_580344 = validateParameter(valid_580344, JString, required = false,
                                 default = nil)
  if valid_580344 != nil:
    section.add "key", valid_580344
  var valid_580345 = query.getOrDefault("prettyPrint")
  valid_580345 = validateParameter(valid_580345, JBool, required = false,
                                 default = newJBool(true))
  if valid_580345 != nil:
    section.add "prettyPrint", valid_580345
  var valid_580346 = query.getOrDefault("oauth_token")
  valid_580346 = validateParameter(valid_580346, JString, required = false,
                                 default = nil)
  if valid_580346 != nil:
    section.add "oauth_token", valid_580346
  var valid_580347 = query.getOrDefault("alt")
  valid_580347 = validateParameter(valid_580347, JString, required = false,
                                 default = newJString("json"))
  if valid_580347 != nil:
    section.add "alt", valid_580347
  var valid_580348 = query.getOrDefault("userIp")
  valid_580348 = validateParameter(valid_580348, JString, required = false,
                                 default = nil)
  if valid_580348 != nil:
    section.add "userIp", valid_580348
  var valid_580349 = query.getOrDefault("quotaUser")
  valid_580349 = validateParameter(valid_580349, JString, required = false,
                                 default = nil)
  if valid_580349 != nil:
    section.add "quotaUser", valid_580349
  var valid_580350 = query.getOrDefault("fields")
  valid_580350 = validateParameter(valid_580350, JString, required = false,
                                 default = nil)
  if valid_580350 != nil:
    section.add "fields", valid_580350
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

proc call*(call_580352: Call_BigqueryTabledataInsertAll_580338; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Streams data into BigQuery one record at a time without needing to run a load job. Requires the WRITER dataset role.
  ## 
  let valid = call_580352.validator(path, query, header, formData, body)
  let scheme = call_580352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580352.url(scheme.get, call_580352.host, call_580352.base,
                         call_580352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580352, url, valid)

proc call*(call_580353: Call_BigqueryTabledataInsertAll_580338; projectId: string;
          tableId: string; datasetId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## bigqueryTabledataInsertAll
  ## Streams data into BigQuery one record at a time without needing to run a load job. Requires the WRITER dataset role.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Project ID of the destination table.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   tableId: string (required)
  ##          : Table ID of the destination table.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   datasetId: string (required)
  ##            : Dataset ID of the destination table.
  var path_580354 = newJObject()
  var query_580355 = newJObject()
  var body_580356 = newJObject()
  add(query_580355, "key", newJString(key))
  add(query_580355, "prettyPrint", newJBool(prettyPrint))
  add(query_580355, "oauth_token", newJString(oauthToken))
  add(path_580354, "projectId", newJString(projectId))
  add(query_580355, "alt", newJString(alt))
  add(query_580355, "userIp", newJString(userIp))
  add(query_580355, "quotaUser", newJString(quotaUser))
  add(path_580354, "tableId", newJString(tableId))
  if body != nil:
    body_580356 = body
  add(query_580355, "fields", newJString(fields))
  add(path_580354, "datasetId", newJString(datasetId))
  result = call_580353.call(path_580354, query_580355, nil, nil, body_580356)

var bigqueryTabledataInsertAll* = Call_BigqueryTabledataInsertAll_580338(
    name: "bigqueryTabledataInsertAll", meth: HttpMethod.HttpPost,
    host: "bigquery.googleapis.com", route: "/projects/{projectId}/datasets/{datasetId}/tables/{tableId}/insertAll",
    validator: validate_BigqueryTabledataInsertAll_580339, base: "/bigquery/v2",
    url: url_BigqueryTabledataInsertAll_580340, schemes: {Scheme.Https})
type
  Call_BigqueryJobsInsert_580380 = ref object of OpenApiRestCall_579389
proc url_BigqueryJobsInsert_580382(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigqueryJobsInsert_580381(path: JsonNode; query: JsonNode;
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
  var valid_580383 = path.getOrDefault("projectId")
  valid_580383 = validateParameter(valid_580383, JString, required = true,
                                 default = nil)
  if valid_580383 != nil:
    section.add "projectId", valid_580383
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
  var valid_580384 = query.getOrDefault("key")
  valid_580384 = validateParameter(valid_580384, JString, required = false,
                                 default = nil)
  if valid_580384 != nil:
    section.add "key", valid_580384
  var valid_580385 = query.getOrDefault("prettyPrint")
  valid_580385 = validateParameter(valid_580385, JBool, required = false,
                                 default = newJBool(true))
  if valid_580385 != nil:
    section.add "prettyPrint", valid_580385
  var valid_580386 = query.getOrDefault("oauth_token")
  valid_580386 = validateParameter(valid_580386, JString, required = false,
                                 default = nil)
  if valid_580386 != nil:
    section.add "oauth_token", valid_580386
  var valid_580387 = query.getOrDefault("alt")
  valid_580387 = validateParameter(valid_580387, JString, required = false,
                                 default = newJString("json"))
  if valid_580387 != nil:
    section.add "alt", valid_580387
  var valid_580388 = query.getOrDefault("userIp")
  valid_580388 = validateParameter(valid_580388, JString, required = false,
                                 default = nil)
  if valid_580388 != nil:
    section.add "userIp", valid_580388
  var valid_580389 = query.getOrDefault("quotaUser")
  valid_580389 = validateParameter(valid_580389, JString, required = false,
                                 default = nil)
  if valid_580389 != nil:
    section.add "quotaUser", valid_580389
  var valid_580390 = query.getOrDefault("fields")
  valid_580390 = validateParameter(valid_580390, JString, required = false,
                                 default = nil)
  if valid_580390 != nil:
    section.add "fields", valid_580390
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

proc call*(call_580392: Call_BigqueryJobsInsert_580380; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a new asynchronous job. Requires the Can View project role.
  ## 
  let valid = call_580392.validator(path, query, header, formData, body)
  let scheme = call_580392.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580392.url(scheme.get, call_580392.host, call_580392.base,
                         call_580392.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580392, url, valid)

proc call*(call_580393: Call_BigqueryJobsInsert_580380; projectId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## bigqueryJobsInsert
  ## Starts a new asynchronous job. Requires the Can View project role.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Project ID of the project that will be billed for the job
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580394 = newJObject()
  var query_580395 = newJObject()
  var body_580396 = newJObject()
  add(query_580395, "key", newJString(key))
  add(query_580395, "prettyPrint", newJBool(prettyPrint))
  add(query_580395, "oauth_token", newJString(oauthToken))
  add(path_580394, "projectId", newJString(projectId))
  add(query_580395, "alt", newJString(alt))
  add(query_580395, "userIp", newJString(userIp))
  add(query_580395, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580396 = body
  add(query_580395, "fields", newJString(fields))
  result = call_580393.call(path_580394, query_580395, nil, nil, body_580396)

var bigqueryJobsInsert* = Call_BigqueryJobsInsert_580380(
    name: "bigqueryJobsInsert", meth: HttpMethod.HttpPost,
    host: "bigquery.googleapis.com", route: "/projects/{projectId}/jobs",
    validator: validate_BigqueryJobsInsert_580381, base: "/bigquery/v2",
    url: url_BigqueryJobsInsert_580382, schemes: {Scheme.Https})
type
  Call_BigqueryJobsList_580357 = ref object of OpenApiRestCall_579389
proc url_BigqueryJobsList_580359(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigqueryJobsList_580358(path: JsonNode; query: JsonNode;
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
  var valid_580360 = path.getOrDefault("projectId")
  valid_580360 = validateParameter(valid_580360, JString, required = true,
                                 default = nil)
  if valid_580360 != nil:
    section.add "projectId", valid_580360
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   minCreationTime: JString
  ##                  : Min value for job creation time, in milliseconds since the POSIX epoch. If set, only jobs created after or at this timestamp are returned
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   parentJobId: JString
  ##              : If set, retrieves only jobs whose parent is this job. Otherwise, retrieves only jobs which have no parent
  ##   pageToken: JString
  ##            : Page token, returned by a previous call, to request the next page of results
  ##   stateFilter: JArray
  ##              : Filter for job state
  ##   allUsers: JBool
  ##           : Whether to display jobs owned by all users in the project. Default false
  ##   projection: JString
  ##             : Restrict information returned to a set of selected fields
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxCreationTime: JString
  ##                  : Max value for job creation time, in milliseconds since the POSIX epoch. If set, only jobs created before or at this timestamp are returned
  ##   maxResults: JInt
  ##             : Maximum number of results to return
  section = newJObject()
  var valid_580361 = query.getOrDefault("key")
  valid_580361 = validateParameter(valid_580361, JString, required = false,
                                 default = nil)
  if valid_580361 != nil:
    section.add "key", valid_580361
  var valid_580362 = query.getOrDefault("prettyPrint")
  valid_580362 = validateParameter(valid_580362, JBool, required = false,
                                 default = newJBool(true))
  if valid_580362 != nil:
    section.add "prettyPrint", valid_580362
  var valid_580363 = query.getOrDefault("oauth_token")
  valid_580363 = validateParameter(valid_580363, JString, required = false,
                                 default = nil)
  if valid_580363 != nil:
    section.add "oauth_token", valid_580363
  var valid_580364 = query.getOrDefault("minCreationTime")
  valid_580364 = validateParameter(valid_580364, JString, required = false,
                                 default = nil)
  if valid_580364 != nil:
    section.add "minCreationTime", valid_580364
  var valid_580365 = query.getOrDefault("alt")
  valid_580365 = validateParameter(valid_580365, JString, required = false,
                                 default = newJString("json"))
  if valid_580365 != nil:
    section.add "alt", valid_580365
  var valid_580366 = query.getOrDefault("userIp")
  valid_580366 = validateParameter(valid_580366, JString, required = false,
                                 default = nil)
  if valid_580366 != nil:
    section.add "userIp", valid_580366
  var valid_580367 = query.getOrDefault("quotaUser")
  valid_580367 = validateParameter(valid_580367, JString, required = false,
                                 default = nil)
  if valid_580367 != nil:
    section.add "quotaUser", valid_580367
  var valid_580368 = query.getOrDefault("parentJobId")
  valid_580368 = validateParameter(valid_580368, JString, required = false,
                                 default = nil)
  if valid_580368 != nil:
    section.add "parentJobId", valid_580368
  var valid_580369 = query.getOrDefault("pageToken")
  valid_580369 = validateParameter(valid_580369, JString, required = false,
                                 default = nil)
  if valid_580369 != nil:
    section.add "pageToken", valid_580369
  var valid_580370 = query.getOrDefault("stateFilter")
  valid_580370 = validateParameter(valid_580370, JArray, required = false,
                                 default = nil)
  if valid_580370 != nil:
    section.add "stateFilter", valid_580370
  var valid_580371 = query.getOrDefault("allUsers")
  valid_580371 = validateParameter(valid_580371, JBool, required = false, default = nil)
  if valid_580371 != nil:
    section.add "allUsers", valid_580371
  var valid_580372 = query.getOrDefault("projection")
  valid_580372 = validateParameter(valid_580372, JString, required = false,
                                 default = newJString("full"))
  if valid_580372 != nil:
    section.add "projection", valid_580372
  var valid_580373 = query.getOrDefault("fields")
  valid_580373 = validateParameter(valid_580373, JString, required = false,
                                 default = nil)
  if valid_580373 != nil:
    section.add "fields", valid_580373
  var valid_580374 = query.getOrDefault("maxCreationTime")
  valid_580374 = validateParameter(valid_580374, JString, required = false,
                                 default = nil)
  if valid_580374 != nil:
    section.add "maxCreationTime", valid_580374
  var valid_580375 = query.getOrDefault("maxResults")
  valid_580375 = validateParameter(valid_580375, JInt, required = false, default = nil)
  if valid_580375 != nil:
    section.add "maxResults", valid_580375
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580376: Call_BigqueryJobsList_580357; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all jobs that you started in the specified project. Job information is available for a six month period after creation. The job list is sorted in reverse chronological order, by job creation time. Requires the Can View project role, or the Is Owner project role if you set the allUsers property.
  ## 
  let valid = call_580376.validator(path, query, header, formData, body)
  let scheme = call_580376.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580376.url(scheme.get, call_580376.host, call_580376.base,
                         call_580376.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580376, url, valid)

proc call*(call_580377: Call_BigqueryJobsList_580357; projectId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          minCreationTime: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; parentJobId: string = ""; pageToken: string = "";
          stateFilter: JsonNode = nil; allUsers: bool = false;
          projection: string = "full"; fields: string = "";
          maxCreationTime: string = ""; maxResults: int = 0): Recallable =
  ## bigqueryJobsList
  ## Lists all jobs that you started in the specified project. Job information is available for a six month period after creation. The job list is sorted in reverse chronological order, by job creation time. Requires the Can View project role, or the Is Owner project role if you set the allUsers property.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Project ID of the jobs to list
  ##   minCreationTime: string
  ##                  : Min value for job creation time, in milliseconds since the POSIX epoch. If set, only jobs created after or at this timestamp are returned
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   parentJobId: string
  ##              : If set, retrieves only jobs whose parent is this job. Otherwise, retrieves only jobs which have no parent
  ##   pageToken: string
  ##            : Page token, returned by a previous call, to request the next page of results
  ##   stateFilter: JArray
  ##              : Filter for job state
  ##   allUsers: bool
  ##           : Whether to display jobs owned by all users in the project. Default false
  ##   projection: string
  ##             : Restrict information returned to a set of selected fields
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxCreationTime: string
  ##                  : Max value for job creation time, in milliseconds since the POSIX epoch. If set, only jobs created before or at this timestamp are returned
  ##   maxResults: int
  ##             : Maximum number of results to return
  var path_580378 = newJObject()
  var query_580379 = newJObject()
  add(query_580379, "key", newJString(key))
  add(query_580379, "prettyPrint", newJBool(prettyPrint))
  add(query_580379, "oauth_token", newJString(oauthToken))
  add(path_580378, "projectId", newJString(projectId))
  add(query_580379, "minCreationTime", newJString(minCreationTime))
  add(query_580379, "alt", newJString(alt))
  add(query_580379, "userIp", newJString(userIp))
  add(query_580379, "quotaUser", newJString(quotaUser))
  add(query_580379, "parentJobId", newJString(parentJobId))
  add(query_580379, "pageToken", newJString(pageToken))
  if stateFilter != nil:
    query_580379.add "stateFilter", stateFilter
  add(query_580379, "allUsers", newJBool(allUsers))
  add(query_580379, "projection", newJString(projection))
  add(query_580379, "fields", newJString(fields))
  add(query_580379, "maxCreationTime", newJString(maxCreationTime))
  add(query_580379, "maxResults", newJInt(maxResults))
  result = call_580377.call(path_580378, query_580379, nil, nil, nil)

var bigqueryJobsList* = Call_BigqueryJobsList_580357(name: "bigqueryJobsList",
    meth: HttpMethod.HttpGet, host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/jobs", validator: validate_BigqueryJobsList_580358,
    base: "/bigquery/v2", url: url_BigqueryJobsList_580359, schemes: {Scheme.Https})
type
  Call_BigqueryJobsGet_580397 = ref object of OpenApiRestCall_579389
proc url_BigqueryJobsGet_580399(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigqueryJobsGet_580398(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Returns information about a specific job. Job information is available for a six month period after creation. Requires that you're the person who ran the job, or have the Is Owner project role.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : [Required] Project ID of the requested job
  ##   jobId: JString (required)
  ##        : [Required] Job ID of the requested job
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580400 = path.getOrDefault("projectId")
  valid_580400 = validateParameter(valid_580400, JString, required = true,
                                 default = nil)
  if valid_580400 != nil:
    section.add "projectId", valid_580400
  var valid_580401 = path.getOrDefault("jobId")
  valid_580401 = validateParameter(valid_580401, JString, required = true,
                                 default = nil)
  if valid_580401 != nil:
    section.add "jobId", valid_580401
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
  ##   location: JString
  ##           : The geographic location of the job. Required except for US and EU. See details at https://cloud.google.com/bigquery/docs/locations#specifying_your_location.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580402 = query.getOrDefault("key")
  valid_580402 = validateParameter(valid_580402, JString, required = false,
                                 default = nil)
  if valid_580402 != nil:
    section.add "key", valid_580402
  var valid_580403 = query.getOrDefault("prettyPrint")
  valid_580403 = validateParameter(valid_580403, JBool, required = false,
                                 default = newJBool(true))
  if valid_580403 != nil:
    section.add "prettyPrint", valid_580403
  var valid_580404 = query.getOrDefault("oauth_token")
  valid_580404 = validateParameter(valid_580404, JString, required = false,
                                 default = nil)
  if valid_580404 != nil:
    section.add "oauth_token", valid_580404
  var valid_580405 = query.getOrDefault("alt")
  valid_580405 = validateParameter(valid_580405, JString, required = false,
                                 default = newJString("json"))
  if valid_580405 != nil:
    section.add "alt", valid_580405
  var valid_580406 = query.getOrDefault("userIp")
  valid_580406 = validateParameter(valid_580406, JString, required = false,
                                 default = nil)
  if valid_580406 != nil:
    section.add "userIp", valid_580406
  var valid_580407 = query.getOrDefault("quotaUser")
  valid_580407 = validateParameter(valid_580407, JString, required = false,
                                 default = nil)
  if valid_580407 != nil:
    section.add "quotaUser", valid_580407
  var valid_580408 = query.getOrDefault("location")
  valid_580408 = validateParameter(valid_580408, JString, required = false,
                                 default = nil)
  if valid_580408 != nil:
    section.add "location", valid_580408
  var valid_580409 = query.getOrDefault("fields")
  valid_580409 = validateParameter(valid_580409, JString, required = false,
                                 default = nil)
  if valid_580409 != nil:
    section.add "fields", valid_580409
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580410: Call_BigqueryJobsGet_580397; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns information about a specific job. Job information is available for a six month period after creation. Requires that you're the person who ran the job, or have the Is Owner project role.
  ## 
  let valid = call_580410.validator(path, query, header, formData, body)
  let scheme = call_580410.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580410.url(scheme.get, call_580410.host, call_580410.base,
                         call_580410.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580410, url, valid)

proc call*(call_580411: Call_BigqueryJobsGet_580397; projectId: string;
          jobId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; location: string = ""; fields: string = ""): Recallable =
  ## bigqueryJobsGet
  ## Returns information about a specific job. Job information is available for a six month period after creation. Requires that you're the person who ran the job, or have the Is Owner project role.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : [Required] Project ID of the requested job
  ##   jobId: string (required)
  ##        : [Required] Job ID of the requested job
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   location: string
  ##           : The geographic location of the job. Required except for US and EU. See details at https://cloud.google.com/bigquery/docs/locations#specifying_your_location.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580412 = newJObject()
  var query_580413 = newJObject()
  add(query_580413, "key", newJString(key))
  add(query_580413, "prettyPrint", newJBool(prettyPrint))
  add(query_580413, "oauth_token", newJString(oauthToken))
  add(path_580412, "projectId", newJString(projectId))
  add(path_580412, "jobId", newJString(jobId))
  add(query_580413, "alt", newJString(alt))
  add(query_580413, "userIp", newJString(userIp))
  add(query_580413, "quotaUser", newJString(quotaUser))
  add(query_580413, "location", newJString(location))
  add(query_580413, "fields", newJString(fields))
  result = call_580411.call(path_580412, query_580413, nil, nil, nil)

var bigqueryJobsGet* = Call_BigqueryJobsGet_580397(name: "bigqueryJobsGet",
    meth: HttpMethod.HttpGet, host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/jobs/{jobId}",
    validator: validate_BigqueryJobsGet_580398, base: "/bigquery/v2",
    url: url_BigqueryJobsGet_580399, schemes: {Scheme.Https})
type
  Call_BigqueryJobsCancel_580414 = ref object of OpenApiRestCall_579389
proc url_BigqueryJobsCancel_580416(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigqueryJobsCancel_580415(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Requests that a job be cancelled. This call will return immediately, and the client will need to poll for the job status to see if the cancel completed successfully. Cancelled jobs may still incur costs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : [Required] Project ID of the job to cancel
  ##   jobId: JString (required)
  ##        : [Required] Job ID of the job to cancel
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580417 = path.getOrDefault("projectId")
  valid_580417 = validateParameter(valid_580417, JString, required = true,
                                 default = nil)
  if valid_580417 != nil:
    section.add "projectId", valid_580417
  var valid_580418 = path.getOrDefault("jobId")
  valid_580418 = validateParameter(valid_580418, JString, required = true,
                                 default = nil)
  if valid_580418 != nil:
    section.add "jobId", valid_580418
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
  ##   location: JString
  ##           : The geographic location of the job. Required except for US and EU. See details at https://cloud.google.com/bigquery/docs/locations#specifying_your_location.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580419 = query.getOrDefault("key")
  valid_580419 = validateParameter(valid_580419, JString, required = false,
                                 default = nil)
  if valid_580419 != nil:
    section.add "key", valid_580419
  var valid_580420 = query.getOrDefault("prettyPrint")
  valid_580420 = validateParameter(valid_580420, JBool, required = false,
                                 default = newJBool(true))
  if valid_580420 != nil:
    section.add "prettyPrint", valid_580420
  var valid_580421 = query.getOrDefault("oauth_token")
  valid_580421 = validateParameter(valid_580421, JString, required = false,
                                 default = nil)
  if valid_580421 != nil:
    section.add "oauth_token", valid_580421
  var valid_580422 = query.getOrDefault("alt")
  valid_580422 = validateParameter(valid_580422, JString, required = false,
                                 default = newJString("json"))
  if valid_580422 != nil:
    section.add "alt", valid_580422
  var valid_580423 = query.getOrDefault("userIp")
  valid_580423 = validateParameter(valid_580423, JString, required = false,
                                 default = nil)
  if valid_580423 != nil:
    section.add "userIp", valid_580423
  var valid_580424 = query.getOrDefault("quotaUser")
  valid_580424 = validateParameter(valid_580424, JString, required = false,
                                 default = nil)
  if valid_580424 != nil:
    section.add "quotaUser", valid_580424
  var valid_580425 = query.getOrDefault("location")
  valid_580425 = validateParameter(valid_580425, JString, required = false,
                                 default = nil)
  if valid_580425 != nil:
    section.add "location", valid_580425
  var valid_580426 = query.getOrDefault("fields")
  valid_580426 = validateParameter(valid_580426, JString, required = false,
                                 default = nil)
  if valid_580426 != nil:
    section.add "fields", valid_580426
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580427: Call_BigqueryJobsCancel_580414; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Requests that a job be cancelled. This call will return immediately, and the client will need to poll for the job status to see if the cancel completed successfully. Cancelled jobs may still incur costs.
  ## 
  let valid = call_580427.validator(path, query, header, formData, body)
  let scheme = call_580427.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580427.url(scheme.get, call_580427.host, call_580427.base,
                         call_580427.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580427, url, valid)

proc call*(call_580428: Call_BigqueryJobsCancel_580414; projectId: string;
          jobId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; location: string = ""; fields: string = ""): Recallable =
  ## bigqueryJobsCancel
  ## Requests that a job be cancelled. This call will return immediately, and the client will need to poll for the job status to see if the cancel completed successfully. Cancelled jobs may still incur costs.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : [Required] Project ID of the job to cancel
  ##   jobId: string (required)
  ##        : [Required] Job ID of the job to cancel
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   location: string
  ##           : The geographic location of the job. Required except for US and EU. See details at https://cloud.google.com/bigquery/docs/locations#specifying_your_location.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580429 = newJObject()
  var query_580430 = newJObject()
  add(query_580430, "key", newJString(key))
  add(query_580430, "prettyPrint", newJBool(prettyPrint))
  add(query_580430, "oauth_token", newJString(oauthToken))
  add(path_580429, "projectId", newJString(projectId))
  add(path_580429, "jobId", newJString(jobId))
  add(query_580430, "alt", newJString(alt))
  add(query_580430, "userIp", newJString(userIp))
  add(query_580430, "quotaUser", newJString(quotaUser))
  add(query_580430, "location", newJString(location))
  add(query_580430, "fields", newJString(fields))
  result = call_580428.call(path_580429, query_580430, nil, nil, nil)

var bigqueryJobsCancel* = Call_BigqueryJobsCancel_580414(
    name: "bigqueryJobsCancel", meth: HttpMethod.HttpPost,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/jobs/{jobId}/cancel",
    validator: validate_BigqueryJobsCancel_580415, base: "/bigquery/v2",
    url: url_BigqueryJobsCancel_580416, schemes: {Scheme.Https})
type
  Call_BigqueryJobsQuery_580431 = ref object of OpenApiRestCall_579389
proc url_BigqueryJobsQuery_580433(protocol: Scheme; host: string; base: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigqueryJobsQuery_580432(path: JsonNode; query: JsonNode;
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
  var valid_580434 = path.getOrDefault("projectId")
  valid_580434 = validateParameter(valid_580434, JString, required = true,
                                 default = nil)
  if valid_580434 != nil:
    section.add "projectId", valid_580434
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
  var valid_580435 = query.getOrDefault("key")
  valid_580435 = validateParameter(valid_580435, JString, required = false,
                                 default = nil)
  if valid_580435 != nil:
    section.add "key", valid_580435
  var valid_580436 = query.getOrDefault("prettyPrint")
  valid_580436 = validateParameter(valid_580436, JBool, required = false,
                                 default = newJBool(true))
  if valid_580436 != nil:
    section.add "prettyPrint", valid_580436
  var valid_580437 = query.getOrDefault("oauth_token")
  valid_580437 = validateParameter(valid_580437, JString, required = false,
                                 default = nil)
  if valid_580437 != nil:
    section.add "oauth_token", valid_580437
  var valid_580438 = query.getOrDefault("alt")
  valid_580438 = validateParameter(valid_580438, JString, required = false,
                                 default = newJString("json"))
  if valid_580438 != nil:
    section.add "alt", valid_580438
  var valid_580439 = query.getOrDefault("userIp")
  valid_580439 = validateParameter(valid_580439, JString, required = false,
                                 default = nil)
  if valid_580439 != nil:
    section.add "userIp", valid_580439
  var valid_580440 = query.getOrDefault("quotaUser")
  valid_580440 = validateParameter(valid_580440, JString, required = false,
                                 default = nil)
  if valid_580440 != nil:
    section.add "quotaUser", valid_580440
  var valid_580441 = query.getOrDefault("fields")
  valid_580441 = validateParameter(valid_580441, JString, required = false,
                                 default = nil)
  if valid_580441 != nil:
    section.add "fields", valid_580441
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

proc call*(call_580443: Call_BigqueryJobsQuery_580431; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Runs a BigQuery SQL query synchronously and returns query results if the query completes within a specified timeout.
  ## 
  let valid = call_580443.validator(path, query, header, formData, body)
  let scheme = call_580443.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580443.url(scheme.get, call_580443.host, call_580443.base,
                         call_580443.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580443, url, valid)

proc call*(call_580444: Call_BigqueryJobsQuery_580431; projectId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## bigqueryJobsQuery
  ## Runs a BigQuery SQL query synchronously and returns query results if the query completes within a specified timeout.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Project ID of the project billed for the query
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580445 = newJObject()
  var query_580446 = newJObject()
  var body_580447 = newJObject()
  add(query_580446, "key", newJString(key))
  add(query_580446, "prettyPrint", newJBool(prettyPrint))
  add(query_580446, "oauth_token", newJString(oauthToken))
  add(path_580445, "projectId", newJString(projectId))
  add(query_580446, "alt", newJString(alt))
  add(query_580446, "userIp", newJString(userIp))
  add(query_580446, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580447 = body
  add(query_580446, "fields", newJString(fields))
  result = call_580444.call(path_580445, query_580446, nil, nil, body_580447)

var bigqueryJobsQuery* = Call_BigqueryJobsQuery_580431(name: "bigqueryJobsQuery",
    meth: HttpMethod.HttpPost, host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/queries", validator: validate_BigqueryJobsQuery_580432,
    base: "/bigquery/v2", url: url_BigqueryJobsQuery_580433, schemes: {Scheme.Https})
type
  Call_BigqueryJobsGetQueryResults_580448 = ref object of OpenApiRestCall_579389
proc url_BigqueryJobsGetQueryResults_580450(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigqueryJobsGetQueryResults_580449(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the results of a query job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : [Required] Project ID of the query job
  ##   jobId: JString (required)
  ##        : [Required] Job ID of the query job
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_580451 = path.getOrDefault("projectId")
  valid_580451 = validateParameter(valid_580451, JString, required = true,
                                 default = nil)
  if valid_580451 != nil:
    section.add "projectId", valid_580451
  var valid_580452 = path.getOrDefault("jobId")
  valid_580452 = validateParameter(valid_580452, JString, required = true,
                                 default = nil)
  if valid_580452 != nil:
    section.add "jobId", valid_580452
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   timeoutMs: JInt
  ##            : How long to wait for the query to complete, in milliseconds, before returning. Default is 10 seconds. If the timeout passes before the job completes, the 'jobComplete' field in the response will be false
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: JString
  ##             : Zero-based index of the starting row
  ##   pageToken: JString
  ##            : Page token, returned by a previous call, to request the next page of results
  ##   location: JString
  ##           : The geographic location where the job should run. Required except for US and EU. See details at https://cloud.google.com/bigquery/docs/locations#specifying_your_location.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of results to read
  section = newJObject()
  var valid_580453 = query.getOrDefault("key")
  valid_580453 = validateParameter(valid_580453, JString, required = false,
                                 default = nil)
  if valid_580453 != nil:
    section.add "key", valid_580453
  var valid_580454 = query.getOrDefault("prettyPrint")
  valid_580454 = validateParameter(valid_580454, JBool, required = false,
                                 default = newJBool(true))
  if valid_580454 != nil:
    section.add "prettyPrint", valid_580454
  var valid_580455 = query.getOrDefault("oauth_token")
  valid_580455 = validateParameter(valid_580455, JString, required = false,
                                 default = nil)
  if valid_580455 != nil:
    section.add "oauth_token", valid_580455
  var valid_580456 = query.getOrDefault("timeoutMs")
  valid_580456 = validateParameter(valid_580456, JInt, required = false, default = nil)
  if valid_580456 != nil:
    section.add "timeoutMs", valid_580456
  var valid_580457 = query.getOrDefault("alt")
  valid_580457 = validateParameter(valid_580457, JString, required = false,
                                 default = newJString("json"))
  if valid_580457 != nil:
    section.add "alt", valid_580457
  var valid_580458 = query.getOrDefault("userIp")
  valid_580458 = validateParameter(valid_580458, JString, required = false,
                                 default = nil)
  if valid_580458 != nil:
    section.add "userIp", valid_580458
  var valid_580459 = query.getOrDefault("quotaUser")
  valid_580459 = validateParameter(valid_580459, JString, required = false,
                                 default = nil)
  if valid_580459 != nil:
    section.add "quotaUser", valid_580459
  var valid_580460 = query.getOrDefault("startIndex")
  valid_580460 = validateParameter(valid_580460, JString, required = false,
                                 default = nil)
  if valid_580460 != nil:
    section.add "startIndex", valid_580460
  var valid_580461 = query.getOrDefault("pageToken")
  valid_580461 = validateParameter(valid_580461, JString, required = false,
                                 default = nil)
  if valid_580461 != nil:
    section.add "pageToken", valid_580461
  var valid_580462 = query.getOrDefault("location")
  valid_580462 = validateParameter(valid_580462, JString, required = false,
                                 default = nil)
  if valid_580462 != nil:
    section.add "location", valid_580462
  var valid_580463 = query.getOrDefault("fields")
  valid_580463 = validateParameter(valid_580463, JString, required = false,
                                 default = nil)
  if valid_580463 != nil:
    section.add "fields", valid_580463
  var valid_580464 = query.getOrDefault("maxResults")
  valid_580464 = validateParameter(valid_580464, JInt, required = false, default = nil)
  if valid_580464 != nil:
    section.add "maxResults", valid_580464
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580465: Call_BigqueryJobsGetQueryResults_580448; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the results of a query job.
  ## 
  let valid = call_580465.validator(path, query, header, formData, body)
  let scheme = call_580465.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580465.url(scheme.get, call_580465.host, call_580465.base,
                         call_580465.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580465, url, valid)

proc call*(call_580466: Call_BigqueryJobsGetQueryResults_580448; projectId: string;
          jobId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; timeoutMs: int = 0; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; startIndex: string = "";
          pageToken: string = ""; location: string = ""; fields: string = "";
          maxResults: int = 0): Recallable =
  ## bigqueryJobsGetQueryResults
  ## Retrieves the results of a query job.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : [Required] Project ID of the query job
  ##   jobId: string (required)
  ##        : [Required] Job ID of the query job
  ##   timeoutMs: int
  ##            : How long to wait for the query to complete, in milliseconds, before returning. Default is 10 seconds. If the timeout passes before the job completes, the 'jobComplete' field in the response will be false
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: string
  ##             : Zero-based index of the starting row
  ##   pageToken: string
  ##            : Page token, returned by a previous call, to request the next page of results
  ##   location: string
  ##           : The geographic location where the job should run. Required except for US and EU. See details at https://cloud.google.com/bigquery/docs/locations#specifying_your_location.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum number of results to read
  var path_580467 = newJObject()
  var query_580468 = newJObject()
  add(query_580468, "key", newJString(key))
  add(query_580468, "prettyPrint", newJBool(prettyPrint))
  add(query_580468, "oauth_token", newJString(oauthToken))
  add(path_580467, "projectId", newJString(projectId))
  add(path_580467, "jobId", newJString(jobId))
  add(query_580468, "timeoutMs", newJInt(timeoutMs))
  add(query_580468, "alt", newJString(alt))
  add(query_580468, "userIp", newJString(userIp))
  add(query_580468, "quotaUser", newJString(quotaUser))
  add(query_580468, "startIndex", newJString(startIndex))
  add(query_580468, "pageToken", newJString(pageToken))
  add(query_580468, "location", newJString(location))
  add(query_580468, "fields", newJString(fields))
  add(query_580468, "maxResults", newJInt(maxResults))
  result = call_580466.call(path_580467, query_580468, nil, nil, nil)

var bigqueryJobsGetQueryResults* = Call_BigqueryJobsGetQueryResults_580448(
    name: "bigqueryJobsGetQueryResults", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/queries/{jobId}",
    validator: validate_BigqueryJobsGetQueryResults_580449, base: "/bigquery/v2",
    url: url_BigqueryJobsGetQueryResults_580450, schemes: {Scheme.Https})
type
  Call_BigqueryProjectsGetServiceAccount_580469 = ref object of OpenApiRestCall_579389
proc url_BigqueryProjectsGetServiceAccount_580471(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_BigqueryProjectsGetServiceAccount_580470(path: JsonNode;
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
  var valid_580472 = path.getOrDefault("projectId")
  valid_580472 = validateParameter(valid_580472, JString, required = true,
                                 default = nil)
  if valid_580472 != nil:
    section.add "projectId", valid_580472
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
  var valid_580473 = query.getOrDefault("key")
  valid_580473 = validateParameter(valid_580473, JString, required = false,
                                 default = nil)
  if valid_580473 != nil:
    section.add "key", valid_580473
  var valid_580474 = query.getOrDefault("prettyPrint")
  valid_580474 = validateParameter(valid_580474, JBool, required = false,
                                 default = newJBool(true))
  if valid_580474 != nil:
    section.add "prettyPrint", valid_580474
  var valid_580475 = query.getOrDefault("oauth_token")
  valid_580475 = validateParameter(valid_580475, JString, required = false,
                                 default = nil)
  if valid_580475 != nil:
    section.add "oauth_token", valid_580475
  var valid_580476 = query.getOrDefault("alt")
  valid_580476 = validateParameter(valid_580476, JString, required = false,
                                 default = newJString("json"))
  if valid_580476 != nil:
    section.add "alt", valid_580476
  var valid_580477 = query.getOrDefault("userIp")
  valid_580477 = validateParameter(valid_580477, JString, required = false,
                                 default = nil)
  if valid_580477 != nil:
    section.add "userIp", valid_580477
  var valid_580478 = query.getOrDefault("quotaUser")
  valid_580478 = validateParameter(valid_580478, JString, required = false,
                                 default = nil)
  if valid_580478 != nil:
    section.add "quotaUser", valid_580478
  var valid_580479 = query.getOrDefault("fields")
  valid_580479 = validateParameter(valid_580479, JString, required = false,
                                 default = nil)
  if valid_580479 != nil:
    section.add "fields", valid_580479
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580480: Call_BigqueryProjectsGetServiceAccount_580469;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the email address of the service account for your project used for interactions with Google Cloud KMS.
  ## 
  let valid = call_580480.validator(path, query, header, formData, body)
  let scheme = call_580480.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580480.url(scheme.get, call_580480.host, call_580480.base,
                         call_580480.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580480, url, valid)

proc call*(call_580481: Call_BigqueryProjectsGetServiceAccount_580469;
          projectId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## bigqueryProjectsGetServiceAccount
  ## Returns the email address of the service account for your project used for interactions with Google Cloud KMS.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   projectId: string (required)
  ##            : Project ID for which the service account is requested.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580482 = newJObject()
  var query_580483 = newJObject()
  add(query_580483, "key", newJString(key))
  add(query_580483, "prettyPrint", newJBool(prettyPrint))
  add(query_580483, "oauth_token", newJString(oauthToken))
  add(path_580482, "projectId", newJString(projectId))
  add(query_580483, "alt", newJString(alt))
  add(query_580483, "userIp", newJString(userIp))
  add(query_580483, "quotaUser", newJString(quotaUser))
  add(query_580483, "fields", newJString(fields))
  result = call_580481.call(path_580482, query_580483, nil, nil, nil)

var bigqueryProjectsGetServiceAccount* = Call_BigqueryProjectsGetServiceAccount_580469(
    name: "bigqueryProjectsGetServiceAccount", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/serviceAccount",
    validator: validate_BigqueryProjectsGetServiceAccount_580470,
    base: "/bigquery/v2", url: url_BigqueryProjectsGetServiceAccount_580471,
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
