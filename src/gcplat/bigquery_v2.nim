
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

  OpenApiRestCall_578364 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578364](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578364): Option[Scheme] {.used.} =
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
  Call_BigqueryProjectsList_578634 = ref object of OpenApiRestCall_578364
proc url_BigqueryProjectsList_578636(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BigqueryProjectsList_578635(path: JsonNode; query: JsonNode;
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
  var valid_578748 = query.getOrDefault("key")
  valid_578748 = validateParameter(valid_578748, JString, required = false,
                                 default = nil)
  if valid_578748 != nil:
    section.add "key", valid_578748
  var valid_578762 = query.getOrDefault("prettyPrint")
  valid_578762 = validateParameter(valid_578762, JBool, required = false,
                                 default = newJBool(true))
  if valid_578762 != nil:
    section.add "prettyPrint", valid_578762
  var valid_578763 = query.getOrDefault("oauth_token")
  valid_578763 = validateParameter(valid_578763, JString, required = false,
                                 default = nil)
  if valid_578763 != nil:
    section.add "oauth_token", valid_578763
  var valid_578764 = query.getOrDefault("alt")
  valid_578764 = validateParameter(valid_578764, JString, required = false,
                                 default = newJString("json"))
  if valid_578764 != nil:
    section.add "alt", valid_578764
  var valid_578765 = query.getOrDefault("userIp")
  valid_578765 = validateParameter(valid_578765, JString, required = false,
                                 default = nil)
  if valid_578765 != nil:
    section.add "userIp", valid_578765
  var valid_578766 = query.getOrDefault("quotaUser")
  valid_578766 = validateParameter(valid_578766, JString, required = false,
                                 default = nil)
  if valid_578766 != nil:
    section.add "quotaUser", valid_578766
  var valid_578767 = query.getOrDefault("pageToken")
  valid_578767 = validateParameter(valid_578767, JString, required = false,
                                 default = nil)
  if valid_578767 != nil:
    section.add "pageToken", valid_578767
  var valid_578768 = query.getOrDefault("fields")
  valid_578768 = validateParameter(valid_578768, JString, required = false,
                                 default = nil)
  if valid_578768 != nil:
    section.add "fields", valid_578768
  var valid_578769 = query.getOrDefault("maxResults")
  valid_578769 = validateParameter(valid_578769, JInt, required = false, default = nil)
  if valid_578769 != nil:
    section.add "maxResults", valid_578769
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578792: Call_BigqueryProjectsList_578634; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all projects to which you have been granted any project role.
  ## 
  let valid = call_578792.validator(path, query, header, formData, body)
  let scheme = call_578792.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578792.url(scheme.get, call_578792.host, call_578792.base,
                         call_578792.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578792, url, valid)

proc call*(call_578863: Call_BigqueryProjectsList_578634; key: string = "";
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
  var query_578864 = newJObject()
  add(query_578864, "key", newJString(key))
  add(query_578864, "prettyPrint", newJBool(prettyPrint))
  add(query_578864, "oauth_token", newJString(oauthToken))
  add(query_578864, "alt", newJString(alt))
  add(query_578864, "userIp", newJString(userIp))
  add(query_578864, "quotaUser", newJString(quotaUser))
  add(query_578864, "pageToken", newJString(pageToken))
  add(query_578864, "fields", newJString(fields))
  add(query_578864, "maxResults", newJInt(maxResults))
  result = call_578863.call(nil, query_578864, nil, nil, nil)

var bigqueryProjectsList* = Call_BigqueryProjectsList_578634(
    name: "bigqueryProjectsList", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com", route: "/projects",
    validator: validate_BigqueryProjectsList_578635, base: "/bigquery/v2",
    url: url_BigqueryProjectsList_578636, schemes: {Scheme.Https})
type
  Call_BigqueryDatasetsInsert_578937 = ref object of OpenApiRestCall_578364
proc url_BigqueryDatasetsInsert_578939(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryDatasetsInsert_578938(path: JsonNode; query: JsonNode;
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
  var valid_578940 = path.getOrDefault("projectId")
  valid_578940 = validateParameter(valid_578940, JString, required = true,
                                 default = nil)
  if valid_578940 != nil:
    section.add "projectId", valid_578940
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
  var valid_578941 = query.getOrDefault("key")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "key", valid_578941
  var valid_578942 = query.getOrDefault("prettyPrint")
  valid_578942 = validateParameter(valid_578942, JBool, required = false,
                                 default = newJBool(true))
  if valid_578942 != nil:
    section.add "prettyPrint", valid_578942
  var valid_578943 = query.getOrDefault("oauth_token")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "oauth_token", valid_578943
  var valid_578944 = query.getOrDefault("alt")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = newJString("json"))
  if valid_578944 != nil:
    section.add "alt", valid_578944
  var valid_578945 = query.getOrDefault("userIp")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "userIp", valid_578945
  var valid_578946 = query.getOrDefault("quotaUser")
  valid_578946 = validateParameter(valid_578946, JString, required = false,
                                 default = nil)
  if valid_578946 != nil:
    section.add "quotaUser", valid_578946
  var valid_578947 = query.getOrDefault("fields")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "fields", valid_578947
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

proc call*(call_578949: Call_BigqueryDatasetsInsert_578937; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new empty dataset.
  ## 
  let valid = call_578949.validator(path, query, header, formData, body)
  let scheme = call_578949.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578949.url(scheme.get, call_578949.host, call_578949.base,
                         call_578949.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578949, url, valid)

proc call*(call_578950: Call_BigqueryDatasetsInsert_578937; projectId: string;
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
  var path_578951 = newJObject()
  var query_578952 = newJObject()
  var body_578953 = newJObject()
  add(query_578952, "key", newJString(key))
  add(query_578952, "prettyPrint", newJBool(prettyPrint))
  add(query_578952, "oauth_token", newJString(oauthToken))
  add(path_578951, "projectId", newJString(projectId))
  add(query_578952, "alt", newJString(alt))
  add(query_578952, "userIp", newJString(userIp))
  add(query_578952, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578953 = body
  add(query_578952, "fields", newJString(fields))
  result = call_578950.call(path_578951, query_578952, nil, nil, body_578953)

var bigqueryDatasetsInsert* = Call_BigqueryDatasetsInsert_578937(
    name: "bigqueryDatasetsInsert", meth: HttpMethod.HttpPost,
    host: "bigquery.googleapis.com", route: "/projects/{projectId}/datasets",
    validator: validate_BigqueryDatasetsInsert_578938, base: "/bigquery/v2",
    url: url_BigqueryDatasetsInsert_578939, schemes: {Scheme.Https})
type
  Call_BigqueryDatasetsList_578904 = ref object of OpenApiRestCall_578364
proc url_BigqueryDatasetsList_578906(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryDatasetsList_578905(path: JsonNode; query: JsonNode;
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
  var valid_578921 = path.getOrDefault("projectId")
  valid_578921 = validateParameter(valid_578921, JString, required = true,
                                 default = nil)
  if valid_578921 != nil:
    section.add "projectId", valid_578921
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
  var valid_578922 = query.getOrDefault("key")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "key", valid_578922
  var valid_578923 = query.getOrDefault("prettyPrint")
  valid_578923 = validateParameter(valid_578923, JBool, required = false,
                                 default = newJBool(true))
  if valid_578923 != nil:
    section.add "prettyPrint", valid_578923
  var valid_578924 = query.getOrDefault("oauth_token")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "oauth_token", valid_578924
  var valid_578925 = query.getOrDefault("all")
  valid_578925 = validateParameter(valid_578925, JBool, required = false, default = nil)
  if valid_578925 != nil:
    section.add "all", valid_578925
  var valid_578926 = query.getOrDefault("alt")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = newJString("json"))
  if valid_578926 != nil:
    section.add "alt", valid_578926
  var valid_578927 = query.getOrDefault("userIp")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = nil)
  if valid_578927 != nil:
    section.add "userIp", valid_578927
  var valid_578928 = query.getOrDefault("quotaUser")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = nil)
  if valid_578928 != nil:
    section.add "quotaUser", valid_578928
  var valid_578929 = query.getOrDefault("filter")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "filter", valid_578929
  var valid_578930 = query.getOrDefault("pageToken")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "pageToken", valid_578930
  var valid_578931 = query.getOrDefault("fields")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "fields", valid_578931
  var valid_578932 = query.getOrDefault("maxResults")
  valid_578932 = validateParameter(valid_578932, JInt, required = false, default = nil)
  if valid_578932 != nil:
    section.add "maxResults", valid_578932
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578933: Call_BigqueryDatasetsList_578904; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all datasets in the specified project to which you have been granted the READER dataset role.
  ## 
  let valid = call_578933.validator(path, query, header, formData, body)
  let scheme = call_578933.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578933.url(scheme.get, call_578933.host, call_578933.base,
                         call_578933.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578933, url, valid)

proc call*(call_578934: Call_BigqueryDatasetsList_578904; projectId: string;
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
  var path_578935 = newJObject()
  var query_578936 = newJObject()
  add(query_578936, "key", newJString(key))
  add(query_578936, "prettyPrint", newJBool(prettyPrint))
  add(query_578936, "oauth_token", newJString(oauthToken))
  add(path_578935, "projectId", newJString(projectId))
  add(query_578936, "all", newJBool(all))
  add(query_578936, "alt", newJString(alt))
  add(query_578936, "userIp", newJString(userIp))
  add(query_578936, "quotaUser", newJString(quotaUser))
  add(query_578936, "filter", newJString(filter))
  add(query_578936, "pageToken", newJString(pageToken))
  add(query_578936, "fields", newJString(fields))
  add(query_578936, "maxResults", newJInt(maxResults))
  result = call_578934.call(path_578935, query_578936, nil, nil, nil)

var bigqueryDatasetsList* = Call_BigqueryDatasetsList_578904(
    name: "bigqueryDatasetsList", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com", route: "/projects/{projectId}/datasets",
    validator: validate_BigqueryDatasetsList_578905, base: "/bigquery/v2",
    url: url_BigqueryDatasetsList_578906, schemes: {Scheme.Https})
type
  Call_BigqueryDatasetsUpdate_578970 = ref object of OpenApiRestCall_578364
proc url_BigqueryDatasetsUpdate_578972(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryDatasetsUpdate_578971(path: JsonNode; query: JsonNode;
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
  var valid_578973 = path.getOrDefault("projectId")
  valid_578973 = validateParameter(valid_578973, JString, required = true,
                                 default = nil)
  if valid_578973 != nil:
    section.add "projectId", valid_578973
  var valid_578974 = path.getOrDefault("datasetId")
  valid_578974 = validateParameter(valid_578974, JString, required = true,
                                 default = nil)
  if valid_578974 != nil:
    section.add "datasetId", valid_578974
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
  var valid_578981 = query.getOrDefault("fields")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = nil)
  if valid_578981 != nil:
    section.add "fields", valid_578981
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

proc call*(call_578983: Call_BigqueryDatasetsUpdate_578970; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates information in an existing dataset. The update method replaces the entire dataset resource, whereas the patch method only replaces fields that are provided in the submitted dataset resource.
  ## 
  let valid = call_578983.validator(path, query, header, formData, body)
  let scheme = call_578983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578983.url(scheme.get, call_578983.host, call_578983.base,
                         call_578983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578983, url, valid)

proc call*(call_578984: Call_BigqueryDatasetsUpdate_578970; projectId: string;
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
  var path_578985 = newJObject()
  var query_578986 = newJObject()
  var body_578987 = newJObject()
  add(query_578986, "key", newJString(key))
  add(query_578986, "prettyPrint", newJBool(prettyPrint))
  add(query_578986, "oauth_token", newJString(oauthToken))
  add(path_578985, "projectId", newJString(projectId))
  add(query_578986, "alt", newJString(alt))
  add(query_578986, "userIp", newJString(userIp))
  add(query_578986, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578987 = body
  add(query_578986, "fields", newJString(fields))
  add(path_578985, "datasetId", newJString(datasetId))
  result = call_578984.call(path_578985, query_578986, nil, nil, body_578987)

var bigqueryDatasetsUpdate* = Call_BigqueryDatasetsUpdate_578970(
    name: "bigqueryDatasetsUpdate", meth: HttpMethod.HttpPut,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}",
    validator: validate_BigqueryDatasetsUpdate_578971, base: "/bigquery/v2",
    url: url_BigqueryDatasetsUpdate_578972, schemes: {Scheme.Https})
type
  Call_BigqueryDatasetsGet_578954 = ref object of OpenApiRestCall_578364
proc url_BigqueryDatasetsGet_578956(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryDatasetsGet_578955(path: JsonNode; query: JsonNode;
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
  var valid_578957 = path.getOrDefault("projectId")
  valid_578957 = validateParameter(valid_578957, JString, required = true,
                                 default = nil)
  if valid_578957 != nil:
    section.add "projectId", valid_578957
  var valid_578958 = path.getOrDefault("datasetId")
  valid_578958 = validateParameter(valid_578958, JString, required = true,
                                 default = nil)
  if valid_578958 != nil:
    section.add "datasetId", valid_578958
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
  var valid_578959 = query.getOrDefault("key")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "key", valid_578959
  var valid_578960 = query.getOrDefault("prettyPrint")
  valid_578960 = validateParameter(valid_578960, JBool, required = false,
                                 default = newJBool(true))
  if valid_578960 != nil:
    section.add "prettyPrint", valid_578960
  var valid_578961 = query.getOrDefault("oauth_token")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "oauth_token", valid_578961
  var valid_578962 = query.getOrDefault("alt")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = newJString("json"))
  if valid_578962 != nil:
    section.add "alt", valid_578962
  var valid_578963 = query.getOrDefault("userIp")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "userIp", valid_578963
  var valid_578964 = query.getOrDefault("quotaUser")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "quotaUser", valid_578964
  var valid_578965 = query.getOrDefault("fields")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "fields", valid_578965
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578966: Call_BigqueryDatasetsGet_578954; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the dataset specified by datasetID.
  ## 
  let valid = call_578966.validator(path, query, header, formData, body)
  let scheme = call_578966.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578966.url(scheme.get, call_578966.host, call_578966.base,
                         call_578966.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578966, url, valid)

proc call*(call_578967: Call_BigqueryDatasetsGet_578954; projectId: string;
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
  var path_578968 = newJObject()
  var query_578969 = newJObject()
  add(query_578969, "key", newJString(key))
  add(query_578969, "prettyPrint", newJBool(prettyPrint))
  add(query_578969, "oauth_token", newJString(oauthToken))
  add(path_578968, "projectId", newJString(projectId))
  add(query_578969, "alt", newJString(alt))
  add(query_578969, "userIp", newJString(userIp))
  add(query_578969, "quotaUser", newJString(quotaUser))
  add(query_578969, "fields", newJString(fields))
  add(path_578968, "datasetId", newJString(datasetId))
  result = call_578967.call(path_578968, query_578969, nil, nil, nil)

var bigqueryDatasetsGet* = Call_BigqueryDatasetsGet_578954(
    name: "bigqueryDatasetsGet", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}",
    validator: validate_BigqueryDatasetsGet_578955, base: "/bigquery/v2",
    url: url_BigqueryDatasetsGet_578956, schemes: {Scheme.Https})
type
  Call_BigqueryDatasetsPatch_579005 = ref object of OpenApiRestCall_578364
proc url_BigqueryDatasetsPatch_579007(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryDatasetsPatch_579006(path: JsonNode; query: JsonNode;
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
  var valid_579008 = path.getOrDefault("projectId")
  valid_579008 = validateParameter(valid_579008, JString, required = true,
                                 default = nil)
  if valid_579008 != nil:
    section.add "projectId", valid_579008
  var valid_579009 = path.getOrDefault("datasetId")
  valid_579009 = validateParameter(valid_579009, JString, required = true,
                                 default = nil)
  if valid_579009 != nil:
    section.add "datasetId", valid_579009
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
  var valid_579010 = query.getOrDefault("key")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "key", valid_579010
  var valid_579011 = query.getOrDefault("prettyPrint")
  valid_579011 = validateParameter(valid_579011, JBool, required = false,
                                 default = newJBool(true))
  if valid_579011 != nil:
    section.add "prettyPrint", valid_579011
  var valid_579012 = query.getOrDefault("oauth_token")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = nil)
  if valid_579012 != nil:
    section.add "oauth_token", valid_579012
  var valid_579013 = query.getOrDefault("alt")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = newJString("json"))
  if valid_579013 != nil:
    section.add "alt", valid_579013
  var valid_579014 = query.getOrDefault("userIp")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "userIp", valid_579014
  var valid_579015 = query.getOrDefault("quotaUser")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "quotaUser", valid_579015
  var valid_579016 = query.getOrDefault("fields")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "fields", valid_579016
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

proc call*(call_579018: Call_BigqueryDatasetsPatch_579005; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates information in an existing dataset. The update method replaces the entire dataset resource, whereas the patch method only replaces fields that are provided in the submitted dataset resource. This method supports patch semantics.
  ## 
  let valid = call_579018.validator(path, query, header, formData, body)
  let scheme = call_579018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579018.url(scheme.get, call_579018.host, call_579018.base,
                         call_579018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579018, url, valid)

proc call*(call_579019: Call_BigqueryDatasetsPatch_579005; projectId: string;
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
  var path_579020 = newJObject()
  var query_579021 = newJObject()
  var body_579022 = newJObject()
  add(query_579021, "key", newJString(key))
  add(query_579021, "prettyPrint", newJBool(prettyPrint))
  add(query_579021, "oauth_token", newJString(oauthToken))
  add(path_579020, "projectId", newJString(projectId))
  add(query_579021, "alt", newJString(alt))
  add(query_579021, "userIp", newJString(userIp))
  add(query_579021, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579022 = body
  add(query_579021, "fields", newJString(fields))
  add(path_579020, "datasetId", newJString(datasetId))
  result = call_579019.call(path_579020, query_579021, nil, nil, body_579022)

var bigqueryDatasetsPatch* = Call_BigqueryDatasetsPatch_579005(
    name: "bigqueryDatasetsPatch", meth: HttpMethod.HttpPatch,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}",
    validator: validate_BigqueryDatasetsPatch_579006, base: "/bigquery/v2",
    url: url_BigqueryDatasetsPatch_579007, schemes: {Scheme.Https})
type
  Call_BigqueryDatasetsDelete_578988 = ref object of OpenApiRestCall_578364
proc url_BigqueryDatasetsDelete_578990(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryDatasetsDelete_578989(path: JsonNode; query: JsonNode;
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
  var valid_578991 = path.getOrDefault("projectId")
  valid_578991 = validateParameter(valid_578991, JString, required = true,
                                 default = nil)
  if valid_578991 != nil:
    section.add "projectId", valid_578991
  var valid_578992 = path.getOrDefault("datasetId")
  valid_578992 = validateParameter(valid_578992, JString, required = true,
                                 default = nil)
  if valid_578992 != nil:
    section.add "datasetId", valid_578992
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
  var valid_578993 = query.getOrDefault("key")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "key", valid_578993
  var valid_578994 = query.getOrDefault("prettyPrint")
  valid_578994 = validateParameter(valid_578994, JBool, required = false,
                                 default = newJBool(true))
  if valid_578994 != nil:
    section.add "prettyPrint", valid_578994
  var valid_578995 = query.getOrDefault("oauth_token")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "oauth_token", valid_578995
  var valid_578996 = query.getOrDefault("deleteContents")
  valid_578996 = validateParameter(valid_578996, JBool, required = false, default = nil)
  if valid_578996 != nil:
    section.add "deleteContents", valid_578996
  var valid_578997 = query.getOrDefault("alt")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = newJString("json"))
  if valid_578997 != nil:
    section.add "alt", valid_578997
  var valid_578998 = query.getOrDefault("userIp")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "userIp", valid_578998
  var valid_578999 = query.getOrDefault("quotaUser")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = nil)
  if valid_578999 != nil:
    section.add "quotaUser", valid_578999
  var valid_579000 = query.getOrDefault("fields")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = nil)
  if valid_579000 != nil:
    section.add "fields", valid_579000
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579001: Call_BigqueryDatasetsDelete_578988; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the dataset specified by the datasetId value. Before you can delete a dataset, you must delete all its tables, either manually or by specifying deleteContents. Immediately after deletion, you can create another dataset with the same name.
  ## 
  let valid = call_579001.validator(path, query, header, formData, body)
  let scheme = call_579001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579001.url(scheme.get, call_579001.host, call_579001.base,
                         call_579001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579001, url, valid)

proc call*(call_579002: Call_BigqueryDatasetsDelete_578988; projectId: string;
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
  var path_579003 = newJObject()
  var query_579004 = newJObject()
  add(query_579004, "key", newJString(key))
  add(query_579004, "prettyPrint", newJBool(prettyPrint))
  add(query_579004, "oauth_token", newJString(oauthToken))
  add(path_579003, "projectId", newJString(projectId))
  add(query_579004, "deleteContents", newJBool(deleteContents))
  add(query_579004, "alt", newJString(alt))
  add(query_579004, "userIp", newJString(userIp))
  add(query_579004, "quotaUser", newJString(quotaUser))
  add(query_579004, "fields", newJString(fields))
  add(path_579003, "datasetId", newJString(datasetId))
  result = call_579002.call(path_579003, query_579004, nil, nil, nil)

var bigqueryDatasetsDelete* = Call_BigqueryDatasetsDelete_578988(
    name: "bigqueryDatasetsDelete", meth: HttpMethod.HttpDelete,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}",
    validator: validate_BigqueryDatasetsDelete_578989, base: "/bigquery/v2",
    url: url_BigqueryDatasetsDelete_578990, schemes: {Scheme.Https})
type
  Call_BigqueryModelsList_579023 = ref object of OpenApiRestCall_578364
proc url_BigqueryModelsList_579025(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryModelsList_579024(path: JsonNode; query: JsonNode;
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
  var valid_579026 = path.getOrDefault("projectId")
  valid_579026 = validateParameter(valid_579026, JString, required = true,
                                 default = nil)
  if valid_579026 != nil:
    section.add "projectId", valid_579026
  var valid_579027 = path.getOrDefault("datasetId")
  valid_579027 = validateParameter(valid_579027, JString, required = true,
                                 default = nil)
  if valid_579027 != nil:
    section.add "datasetId", valid_579027
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
  var valid_579028 = query.getOrDefault("key")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "key", valid_579028
  var valid_579029 = query.getOrDefault("prettyPrint")
  valid_579029 = validateParameter(valid_579029, JBool, required = false,
                                 default = newJBool(true))
  if valid_579029 != nil:
    section.add "prettyPrint", valid_579029
  var valid_579030 = query.getOrDefault("oauth_token")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = nil)
  if valid_579030 != nil:
    section.add "oauth_token", valid_579030
  var valid_579031 = query.getOrDefault("alt")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = newJString("json"))
  if valid_579031 != nil:
    section.add "alt", valid_579031
  var valid_579032 = query.getOrDefault("userIp")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = nil)
  if valid_579032 != nil:
    section.add "userIp", valid_579032
  var valid_579033 = query.getOrDefault("quotaUser")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = nil)
  if valid_579033 != nil:
    section.add "quotaUser", valid_579033
  var valid_579034 = query.getOrDefault("pageToken")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "pageToken", valid_579034
  var valid_579035 = query.getOrDefault("fields")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "fields", valid_579035
  var valid_579036 = query.getOrDefault("maxResults")
  valid_579036 = validateParameter(valid_579036, JInt, required = false, default = nil)
  if valid_579036 != nil:
    section.add "maxResults", valid_579036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579037: Call_BigqueryModelsList_579023; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all models in the specified dataset. Requires the READER dataset
  ## role.
  ## 
  let valid = call_579037.validator(path, query, header, formData, body)
  let scheme = call_579037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579037.url(scheme.get, call_579037.host, call_579037.base,
                         call_579037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579037, url, valid)

proc call*(call_579038: Call_BigqueryModelsList_579023; projectId: string;
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
  var path_579039 = newJObject()
  var query_579040 = newJObject()
  add(query_579040, "key", newJString(key))
  add(query_579040, "prettyPrint", newJBool(prettyPrint))
  add(query_579040, "oauth_token", newJString(oauthToken))
  add(path_579039, "projectId", newJString(projectId))
  add(query_579040, "alt", newJString(alt))
  add(query_579040, "userIp", newJString(userIp))
  add(query_579040, "quotaUser", newJString(quotaUser))
  add(query_579040, "pageToken", newJString(pageToken))
  add(query_579040, "fields", newJString(fields))
  add(query_579040, "maxResults", newJInt(maxResults))
  add(path_579039, "datasetId", newJString(datasetId))
  result = call_579038.call(path_579039, query_579040, nil, nil, nil)

var bigqueryModelsList* = Call_BigqueryModelsList_579023(
    name: "bigqueryModelsList", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/models",
    validator: validate_BigqueryModelsList_579024, base: "/bigquery/v2",
    url: url_BigqueryModelsList_579025, schemes: {Scheme.Https})
type
  Call_BigqueryModelsGet_579041 = ref object of OpenApiRestCall_578364
proc url_BigqueryModelsGet_579043(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryModelsGet_579042(path: JsonNode; query: JsonNode;
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
  var valid_579044 = path.getOrDefault("projectId")
  valid_579044 = validateParameter(valid_579044, JString, required = true,
                                 default = nil)
  if valid_579044 != nil:
    section.add "projectId", valid_579044
  var valid_579045 = path.getOrDefault("modelId")
  valid_579045 = validateParameter(valid_579045, JString, required = true,
                                 default = nil)
  if valid_579045 != nil:
    section.add "modelId", valid_579045
  var valid_579046 = path.getOrDefault("datasetId")
  valid_579046 = validateParameter(valid_579046, JString, required = true,
                                 default = nil)
  if valid_579046 != nil:
    section.add "datasetId", valid_579046
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
  var valid_579047 = query.getOrDefault("key")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "key", valid_579047
  var valid_579048 = query.getOrDefault("prettyPrint")
  valid_579048 = validateParameter(valid_579048, JBool, required = false,
                                 default = newJBool(true))
  if valid_579048 != nil:
    section.add "prettyPrint", valid_579048
  var valid_579049 = query.getOrDefault("oauth_token")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = nil)
  if valid_579049 != nil:
    section.add "oauth_token", valid_579049
  var valid_579050 = query.getOrDefault("alt")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = newJString("json"))
  if valid_579050 != nil:
    section.add "alt", valid_579050
  var valid_579051 = query.getOrDefault("userIp")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = nil)
  if valid_579051 != nil:
    section.add "userIp", valid_579051
  var valid_579052 = query.getOrDefault("quotaUser")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = nil)
  if valid_579052 != nil:
    section.add "quotaUser", valid_579052
  var valid_579053 = query.getOrDefault("fields")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = nil)
  if valid_579053 != nil:
    section.add "fields", valid_579053
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579054: Call_BigqueryModelsGet_579041; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified model resource by model ID.
  ## 
  let valid = call_579054.validator(path, query, header, formData, body)
  let scheme = call_579054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579054.url(scheme.get, call_579054.host, call_579054.base,
                         call_579054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579054, url, valid)

proc call*(call_579055: Call_BigqueryModelsGet_579041; projectId: string;
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
  var path_579056 = newJObject()
  var query_579057 = newJObject()
  add(query_579057, "key", newJString(key))
  add(query_579057, "prettyPrint", newJBool(prettyPrint))
  add(query_579057, "oauth_token", newJString(oauthToken))
  add(path_579056, "projectId", newJString(projectId))
  add(query_579057, "alt", newJString(alt))
  add(query_579057, "userIp", newJString(userIp))
  add(query_579057, "quotaUser", newJString(quotaUser))
  add(path_579056, "modelId", newJString(modelId))
  add(query_579057, "fields", newJString(fields))
  add(path_579056, "datasetId", newJString(datasetId))
  result = call_579055.call(path_579056, query_579057, nil, nil, nil)

var bigqueryModelsGet* = Call_BigqueryModelsGet_579041(name: "bigqueryModelsGet",
    meth: HttpMethod.HttpGet, host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/models/{modelId}",
    validator: validate_BigqueryModelsGet_579042, base: "/bigquery/v2",
    url: url_BigqueryModelsGet_579043, schemes: {Scheme.Https})
type
  Call_BigqueryModelsPatch_579075 = ref object of OpenApiRestCall_578364
proc url_BigqueryModelsPatch_579077(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryModelsPatch_579076(path: JsonNode; query: JsonNode;
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
  var valid_579078 = path.getOrDefault("projectId")
  valid_579078 = validateParameter(valid_579078, JString, required = true,
                                 default = nil)
  if valid_579078 != nil:
    section.add "projectId", valid_579078
  var valid_579079 = path.getOrDefault("modelId")
  valid_579079 = validateParameter(valid_579079, JString, required = true,
                                 default = nil)
  if valid_579079 != nil:
    section.add "modelId", valid_579079
  var valid_579080 = path.getOrDefault("datasetId")
  valid_579080 = validateParameter(valid_579080, JString, required = true,
                                 default = nil)
  if valid_579080 != nil:
    section.add "datasetId", valid_579080
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
  var valid_579081 = query.getOrDefault("key")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "key", valid_579081
  var valid_579082 = query.getOrDefault("prettyPrint")
  valid_579082 = validateParameter(valid_579082, JBool, required = false,
                                 default = newJBool(true))
  if valid_579082 != nil:
    section.add "prettyPrint", valid_579082
  var valid_579083 = query.getOrDefault("oauth_token")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = nil)
  if valid_579083 != nil:
    section.add "oauth_token", valid_579083
  var valid_579084 = query.getOrDefault("alt")
  valid_579084 = validateParameter(valid_579084, JString, required = false,
                                 default = newJString("json"))
  if valid_579084 != nil:
    section.add "alt", valid_579084
  var valid_579085 = query.getOrDefault("userIp")
  valid_579085 = validateParameter(valid_579085, JString, required = false,
                                 default = nil)
  if valid_579085 != nil:
    section.add "userIp", valid_579085
  var valid_579086 = query.getOrDefault("quotaUser")
  valid_579086 = validateParameter(valid_579086, JString, required = false,
                                 default = nil)
  if valid_579086 != nil:
    section.add "quotaUser", valid_579086
  var valid_579087 = query.getOrDefault("fields")
  valid_579087 = validateParameter(valid_579087, JString, required = false,
                                 default = nil)
  if valid_579087 != nil:
    section.add "fields", valid_579087
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

proc call*(call_579089: Call_BigqueryModelsPatch_579075; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch specific fields in the specified model.
  ## 
  let valid = call_579089.validator(path, query, header, formData, body)
  let scheme = call_579089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579089.url(scheme.get, call_579089.host, call_579089.base,
                         call_579089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579089, url, valid)

proc call*(call_579090: Call_BigqueryModelsPatch_579075; projectId: string;
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
  var path_579091 = newJObject()
  var query_579092 = newJObject()
  var body_579093 = newJObject()
  add(query_579092, "key", newJString(key))
  add(query_579092, "prettyPrint", newJBool(prettyPrint))
  add(query_579092, "oauth_token", newJString(oauthToken))
  add(path_579091, "projectId", newJString(projectId))
  add(query_579092, "alt", newJString(alt))
  add(query_579092, "userIp", newJString(userIp))
  add(query_579092, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579093 = body
  add(path_579091, "modelId", newJString(modelId))
  add(query_579092, "fields", newJString(fields))
  add(path_579091, "datasetId", newJString(datasetId))
  result = call_579090.call(path_579091, query_579092, nil, nil, body_579093)

var bigqueryModelsPatch* = Call_BigqueryModelsPatch_579075(
    name: "bigqueryModelsPatch", meth: HttpMethod.HttpPatch,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/models/{modelId}",
    validator: validate_BigqueryModelsPatch_579076, base: "/bigquery/v2",
    url: url_BigqueryModelsPatch_579077, schemes: {Scheme.Https})
type
  Call_BigqueryModelsDelete_579058 = ref object of OpenApiRestCall_578364
proc url_BigqueryModelsDelete_579060(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryModelsDelete_579059(path: JsonNode; query: JsonNode;
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
  var valid_579061 = path.getOrDefault("projectId")
  valid_579061 = validateParameter(valid_579061, JString, required = true,
                                 default = nil)
  if valid_579061 != nil:
    section.add "projectId", valid_579061
  var valid_579062 = path.getOrDefault("modelId")
  valid_579062 = validateParameter(valid_579062, JString, required = true,
                                 default = nil)
  if valid_579062 != nil:
    section.add "modelId", valid_579062
  var valid_579063 = path.getOrDefault("datasetId")
  valid_579063 = validateParameter(valid_579063, JString, required = true,
                                 default = nil)
  if valid_579063 != nil:
    section.add "datasetId", valid_579063
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
  var valid_579064 = query.getOrDefault("key")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = nil)
  if valid_579064 != nil:
    section.add "key", valid_579064
  var valid_579065 = query.getOrDefault("prettyPrint")
  valid_579065 = validateParameter(valid_579065, JBool, required = false,
                                 default = newJBool(true))
  if valid_579065 != nil:
    section.add "prettyPrint", valid_579065
  var valid_579066 = query.getOrDefault("oauth_token")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = nil)
  if valid_579066 != nil:
    section.add "oauth_token", valid_579066
  var valid_579067 = query.getOrDefault("alt")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = newJString("json"))
  if valid_579067 != nil:
    section.add "alt", valid_579067
  var valid_579068 = query.getOrDefault("userIp")
  valid_579068 = validateParameter(valid_579068, JString, required = false,
                                 default = nil)
  if valid_579068 != nil:
    section.add "userIp", valid_579068
  var valid_579069 = query.getOrDefault("quotaUser")
  valid_579069 = validateParameter(valid_579069, JString, required = false,
                                 default = nil)
  if valid_579069 != nil:
    section.add "quotaUser", valid_579069
  var valid_579070 = query.getOrDefault("fields")
  valid_579070 = validateParameter(valid_579070, JString, required = false,
                                 default = nil)
  if valid_579070 != nil:
    section.add "fields", valid_579070
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579071: Call_BigqueryModelsDelete_579058; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the model specified by modelId from the dataset.
  ## 
  let valid = call_579071.validator(path, query, header, formData, body)
  let scheme = call_579071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579071.url(scheme.get, call_579071.host, call_579071.base,
                         call_579071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579071, url, valid)

proc call*(call_579072: Call_BigqueryModelsDelete_579058; projectId: string;
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
  var path_579073 = newJObject()
  var query_579074 = newJObject()
  add(query_579074, "key", newJString(key))
  add(query_579074, "prettyPrint", newJBool(prettyPrint))
  add(query_579074, "oauth_token", newJString(oauthToken))
  add(path_579073, "projectId", newJString(projectId))
  add(query_579074, "alt", newJString(alt))
  add(query_579074, "userIp", newJString(userIp))
  add(query_579074, "quotaUser", newJString(quotaUser))
  add(path_579073, "modelId", newJString(modelId))
  add(query_579074, "fields", newJString(fields))
  add(path_579073, "datasetId", newJString(datasetId))
  result = call_579072.call(path_579073, query_579074, nil, nil, nil)

var bigqueryModelsDelete* = Call_BigqueryModelsDelete_579058(
    name: "bigqueryModelsDelete", meth: HttpMethod.HttpDelete,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/models/{modelId}",
    validator: validate_BigqueryModelsDelete_579059, base: "/bigquery/v2",
    url: url_BigqueryModelsDelete_579060, schemes: {Scheme.Https})
type
  Call_BigqueryRoutinesInsert_579112 = ref object of OpenApiRestCall_578364
proc url_BigqueryRoutinesInsert_579114(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryRoutinesInsert_579113(path: JsonNode; query: JsonNode;
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
  var valid_579115 = path.getOrDefault("projectId")
  valid_579115 = validateParameter(valid_579115, JString, required = true,
                                 default = nil)
  if valid_579115 != nil:
    section.add "projectId", valid_579115
  var valid_579116 = path.getOrDefault("datasetId")
  valid_579116 = validateParameter(valid_579116, JString, required = true,
                                 default = nil)
  if valid_579116 != nil:
    section.add "datasetId", valid_579116
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
  var valid_579117 = query.getOrDefault("key")
  valid_579117 = validateParameter(valid_579117, JString, required = false,
                                 default = nil)
  if valid_579117 != nil:
    section.add "key", valid_579117
  var valid_579118 = query.getOrDefault("prettyPrint")
  valid_579118 = validateParameter(valid_579118, JBool, required = false,
                                 default = newJBool(true))
  if valid_579118 != nil:
    section.add "prettyPrint", valid_579118
  var valid_579119 = query.getOrDefault("oauth_token")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = nil)
  if valid_579119 != nil:
    section.add "oauth_token", valid_579119
  var valid_579120 = query.getOrDefault("alt")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = newJString("json"))
  if valid_579120 != nil:
    section.add "alt", valid_579120
  var valid_579121 = query.getOrDefault("userIp")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = nil)
  if valid_579121 != nil:
    section.add "userIp", valid_579121
  var valid_579122 = query.getOrDefault("quotaUser")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = nil)
  if valid_579122 != nil:
    section.add "quotaUser", valid_579122
  var valid_579123 = query.getOrDefault("fields")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = nil)
  if valid_579123 != nil:
    section.add "fields", valid_579123
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

proc call*(call_579125: Call_BigqueryRoutinesInsert_579112; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new routine in the dataset.
  ## 
  let valid = call_579125.validator(path, query, header, formData, body)
  let scheme = call_579125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579125.url(scheme.get, call_579125.host, call_579125.base,
                         call_579125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579125, url, valid)

proc call*(call_579126: Call_BigqueryRoutinesInsert_579112; projectId: string;
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
  var path_579127 = newJObject()
  var query_579128 = newJObject()
  var body_579129 = newJObject()
  add(query_579128, "key", newJString(key))
  add(query_579128, "prettyPrint", newJBool(prettyPrint))
  add(query_579128, "oauth_token", newJString(oauthToken))
  add(path_579127, "projectId", newJString(projectId))
  add(query_579128, "alt", newJString(alt))
  add(query_579128, "userIp", newJString(userIp))
  add(query_579128, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579129 = body
  add(query_579128, "fields", newJString(fields))
  add(path_579127, "datasetId", newJString(datasetId))
  result = call_579126.call(path_579127, query_579128, nil, nil, body_579129)

var bigqueryRoutinesInsert* = Call_BigqueryRoutinesInsert_579112(
    name: "bigqueryRoutinesInsert", meth: HttpMethod.HttpPost,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/routines",
    validator: validate_BigqueryRoutinesInsert_579113, base: "/bigquery/v2",
    url: url_BigqueryRoutinesInsert_579114, schemes: {Scheme.Https})
type
  Call_BigqueryRoutinesList_579094 = ref object of OpenApiRestCall_578364
proc url_BigqueryRoutinesList_579096(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryRoutinesList_579095(path: JsonNode; query: JsonNode;
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
  var valid_579097 = path.getOrDefault("projectId")
  valid_579097 = validateParameter(valid_579097, JString, required = true,
                                 default = nil)
  if valid_579097 != nil:
    section.add "projectId", valid_579097
  var valid_579098 = path.getOrDefault("datasetId")
  valid_579098 = validateParameter(valid_579098, JString, required = true,
                                 default = nil)
  if valid_579098 != nil:
    section.add "datasetId", valid_579098
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
  var valid_579099 = query.getOrDefault("key")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = nil)
  if valid_579099 != nil:
    section.add "key", valid_579099
  var valid_579100 = query.getOrDefault("prettyPrint")
  valid_579100 = validateParameter(valid_579100, JBool, required = false,
                                 default = newJBool(true))
  if valid_579100 != nil:
    section.add "prettyPrint", valid_579100
  var valid_579101 = query.getOrDefault("oauth_token")
  valid_579101 = validateParameter(valid_579101, JString, required = false,
                                 default = nil)
  if valid_579101 != nil:
    section.add "oauth_token", valid_579101
  var valid_579102 = query.getOrDefault("alt")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = newJString("json"))
  if valid_579102 != nil:
    section.add "alt", valid_579102
  var valid_579103 = query.getOrDefault("userIp")
  valid_579103 = validateParameter(valid_579103, JString, required = false,
                                 default = nil)
  if valid_579103 != nil:
    section.add "userIp", valid_579103
  var valid_579104 = query.getOrDefault("quotaUser")
  valid_579104 = validateParameter(valid_579104, JString, required = false,
                                 default = nil)
  if valid_579104 != nil:
    section.add "quotaUser", valid_579104
  var valid_579105 = query.getOrDefault("pageToken")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = nil)
  if valid_579105 != nil:
    section.add "pageToken", valid_579105
  var valid_579106 = query.getOrDefault("fields")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = nil)
  if valid_579106 != nil:
    section.add "fields", valid_579106
  var valid_579107 = query.getOrDefault("maxResults")
  valid_579107 = validateParameter(valid_579107, JInt, required = false, default = nil)
  if valid_579107 != nil:
    section.add "maxResults", valid_579107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579108: Call_BigqueryRoutinesList_579094; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all routines in the specified dataset. Requires the READER dataset
  ## role.
  ## 
  let valid = call_579108.validator(path, query, header, formData, body)
  let scheme = call_579108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579108.url(scheme.get, call_579108.host, call_579108.base,
                         call_579108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579108, url, valid)

proc call*(call_579109: Call_BigqueryRoutinesList_579094; projectId: string;
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
  var path_579110 = newJObject()
  var query_579111 = newJObject()
  add(query_579111, "key", newJString(key))
  add(query_579111, "prettyPrint", newJBool(prettyPrint))
  add(query_579111, "oauth_token", newJString(oauthToken))
  add(path_579110, "projectId", newJString(projectId))
  add(query_579111, "alt", newJString(alt))
  add(query_579111, "userIp", newJString(userIp))
  add(query_579111, "quotaUser", newJString(quotaUser))
  add(query_579111, "pageToken", newJString(pageToken))
  add(query_579111, "fields", newJString(fields))
  add(query_579111, "maxResults", newJInt(maxResults))
  add(path_579110, "datasetId", newJString(datasetId))
  result = call_579109.call(path_579110, query_579111, nil, nil, nil)

var bigqueryRoutinesList* = Call_BigqueryRoutinesList_579094(
    name: "bigqueryRoutinesList", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/routines",
    validator: validate_BigqueryRoutinesList_579095, base: "/bigquery/v2",
    url: url_BigqueryRoutinesList_579096, schemes: {Scheme.Https})
type
  Call_BigqueryRoutinesUpdate_579148 = ref object of OpenApiRestCall_578364
proc url_BigqueryRoutinesUpdate_579150(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryRoutinesUpdate_579149(path: JsonNode; query: JsonNode;
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
  var valid_579151 = path.getOrDefault("projectId")
  valid_579151 = validateParameter(valid_579151, JString, required = true,
                                 default = nil)
  if valid_579151 != nil:
    section.add "projectId", valid_579151
  var valid_579152 = path.getOrDefault("routineId")
  valid_579152 = validateParameter(valid_579152, JString, required = true,
                                 default = nil)
  if valid_579152 != nil:
    section.add "routineId", valid_579152
  var valid_579153 = path.getOrDefault("datasetId")
  valid_579153 = validateParameter(valid_579153, JString, required = true,
                                 default = nil)
  if valid_579153 != nil:
    section.add "datasetId", valid_579153
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
  var valid_579154 = query.getOrDefault("key")
  valid_579154 = validateParameter(valid_579154, JString, required = false,
                                 default = nil)
  if valid_579154 != nil:
    section.add "key", valid_579154
  var valid_579155 = query.getOrDefault("prettyPrint")
  valid_579155 = validateParameter(valid_579155, JBool, required = false,
                                 default = newJBool(true))
  if valid_579155 != nil:
    section.add "prettyPrint", valid_579155
  var valid_579156 = query.getOrDefault("oauth_token")
  valid_579156 = validateParameter(valid_579156, JString, required = false,
                                 default = nil)
  if valid_579156 != nil:
    section.add "oauth_token", valid_579156
  var valid_579157 = query.getOrDefault("alt")
  valid_579157 = validateParameter(valid_579157, JString, required = false,
                                 default = newJString("json"))
  if valid_579157 != nil:
    section.add "alt", valid_579157
  var valid_579158 = query.getOrDefault("userIp")
  valid_579158 = validateParameter(valid_579158, JString, required = false,
                                 default = nil)
  if valid_579158 != nil:
    section.add "userIp", valid_579158
  var valid_579159 = query.getOrDefault("quotaUser")
  valid_579159 = validateParameter(valid_579159, JString, required = false,
                                 default = nil)
  if valid_579159 != nil:
    section.add "quotaUser", valid_579159
  var valid_579160 = query.getOrDefault("fields")
  valid_579160 = validateParameter(valid_579160, JString, required = false,
                                 default = nil)
  if valid_579160 != nil:
    section.add "fields", valid_579160
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

proc call*(call_579162: Call_BigqueryRoutinesUpdate_579148; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates information in an existing routine. The update method replaces the
  ## entire Routine resource.
  ## 
  let valid = call_579162.validator(path, query, header, formData, body)
  let scheme = call_579162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579162.url(scheme.get, call_579162.host, call_579162.base,
                         call_579162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579162, url, valid)

proc call*(call_579163: Call_BigqueryRoutinesUpdate_579148; projectId: string;
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
  var path_579164 = newJObject()
  var query_579165 = newJObject()
  var body_579166 = newJObject()
  add(query_579165, "key", newJString(key))
  add(query_579165, "prettyPrint", newJBool(prettyPrint))
  add(query_579165, "oauth_token", newJString(oauthToken))
  add(path_579164, "projectId", newJString(projectId))
  add(path_579164, "routineId", newJString(routineId))
  add(query_579165, "alt", newJString(alt))
  add(query_579165, "userIp", newJString(userIp))
  add(query_579165, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579166 = body
  add(query_579165, "fields", newJString(fields))
  add(path_579164, "datasetId", newJString(datasetId))
  result = call_579163.call(path_579164, query_579165, nil, nil, body_579166)

var bigqueryRoutinesUpdate* = Call_BigqueryRoutinesUpdate_579148(
    name: "bigqueryRoutinesUpdate", meth: HttpMethod.HttpPut,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/routines/{routineId}",
    validator: validate_BigqueryRoutinesUpdate_579149, base: "/bigquery/v2",
    url: url_BigqueryRoutinesUpdate_579150, schemes: {Scheme.Https})
type
  Call_BigqueryRoutinesGet_579130 = ref object of OpenApiRestCall_578364
proc url_BigqueryRoutinesGet_579132(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryRoutinesGet_579131(path: JsonNode; query: JsonNode;
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
  var valid_579133 = path.getOrDefault("projectId")
  valid_579133 = validateParameter(valid_579133, JString, required = true,
                                 default = nil)
  if valid_579133 != nil:
    section.add "projectId", valid_579133
  var valid_579134 = path.getOrDefault("routineId")
  valid_579134 = validateParameter(valid_579134, JString, required = true,
                                 default = nil)
  if valid_579134 != nil:
    section.add "routineId", valid_579134
  var valid_579135 = path.getOrDefault("datasetId")
  valid_579135 = validateParameter(valid_579135, JString, required = true,
                                 default = nil)
  if valid_579135 != nil:
    section.add "datasetId", valid_579135
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
  ##   fieldMask: JString
  ##            : If set, only the Routine fields in the field mask are returned in the
  ## response. If unset, all Routine fields are returned.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579136 = query.getOrDefault("key")
  valid_579136 = validateParameter(valid_579136, JString, required = false,
                                 default = nil)
  if valid_579136 != nil:
    section.add "key", valid_579136
  var valid_579137 = query.getOrDefault("prettyPrint")
  valid_579137 = validateParameter(valid_579137, JBool, required = false,
                                 default = newJBool(true))
  if valid_579137 != nil:
    section.add "prettyPrint", valid_579137
  var valid_579138 = query.getOrDefault("oauth_token")
  valid_579138 = validateParameter(valid_579138, JString, required = false,
                                 default = nil)
  if valid_579138 != nil:
    section.add "oauth_token", valid_579138
  var valid_579139 = query.getOrDefault("alt")
  valid_579139 = validateParameter(valid_579139, JString, required = false,
                                 default = newJString("json"))
  if valid_579139 != nil:
    section.add "alt", valid_579139
  var valid_579140 = query.getOrDefault("userIp")
  valid_579140 = validateParameter(valid_579140, JString, required = false,
                                 default = nil)
  if valid_579140 != nil:
    section.add "userIp", valid_579140
  var valid_579141 = query.getOrDefault("quotaUser")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = nil)
  if valid_579141 != nil:
    section.add "quotaUser", valid_579141
  var valid_579142 = query.getOrDefault("fieldMask")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = nil)
  if valid_579142 != nil:
    section.add "fieldMask", valid_579142
  var valid_579143 = query.getOrDefault("fields")
  valid_579143 = validateParameter(valid_579143, JString, required = false,
                                 default = nil)
  if valid_579143 != nil:
    section.add "fields", valid_579143
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579144: Call_BigqueryRoutinesGet_579130; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified routine resource by routine ID.
  ## 
  let valid = call_579144.validator(path, query, header, formData, body)
  let scheme = call_579144.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579144.url(scheme.get, call_579144.host, call_579144.base,
                         call_579144.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579144, url, valid)

proc call*(call_579145: Call_BigqueryRoutinesGet_579130; projectId: string;
          routineId: string; datasetId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fieldMask: string = "";
          fields: string = ""): Recallable =
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
  ##   fieldMask: string
  ##            : If set, only the Routine fields in the field mask are returned in the
  ## response. If unset, all Routine fields are returned.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   datasetId: string (required)
  ##            : Required. Dataset ID of the requested routine
  var path_579146 = newJObject()
  var query_579147 = newJObject()
  add(query_579147, "key", newJString(key))
  add(query_579147, "prettyPrint", newJBool(prettyPrint))
  add(query_579147, "oauth_token", newJString(oauthToken))
  add(path_579146, "projectId", newJString(projectId))
  add(path_579146, "routineId", newJString(routineId))
  add(query_579147, "alt", newJString(alt))
  add(query_579147, "userIp", newJString(userIp))
  add(query_579147, "quotaUser", newJString(quotaUser))
  add(query_579147, "fieldMask", newJString(fieldMask))
  add(query_579147, "fields", newJString(fields))
  add(path_579146, "datasetId", newJString(datasetId))
  result = call_579145.call(path_579146, query_579147, nil, nil, nil)

var bigqueryRoutinesGet* = Call_BigqueryRoutinesGet_579130(
    name: "bigqueryRoutinesGet", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/routines/{routineId}",
    validator: validate_BigqueryRoutinesGet_579131, base: "/bigquery/v2",
    url: url_BigqueryRoutinesGet_579132, schemes: {Scheme.Https})
type
  Call_BigqueryRoutinesDelete_579167 = ref object of OpenApiRestCall_578364
proc url_BigqueryRoutinesDelete_579169(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryRoutinesDelete_579168(path: JsonNode; query: JsonNode;
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
  var valid_579170 = path.getOrDefault("projectId")
  valid_579170 = validateParameter(valid_579170, JString, required = true,
                                 default = nil)
  if valid_579170 != nil:
    section.add "projectId", valid_579170
  var valid_579171 = path.getOrDefault("routineId")
  valid_579171 = validateParameter(valid_579171, JString, required = true,
                                 default = nil)
  if valid_579171 != nil:
    section.add "routineId", valid_579171
  var valid_579172 = path.getOrDefault("datasetId")
  valid_579172 = validateParameter(valid_579172, JString, required = true,
                                 default = nil)
  if valid_579172 != nil:
    section.add "datasetId", valid_579172
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
  var valid_579173 = query.getOrDefault("key")
  valid_579173 = validateParameter(valid_579173, JString, required = false,
                                 default = nil)
  if valid_579173 != nil:
    section.add "key", valid_579173
  var valid_579174 = query.getOrDefault("prettyPrint")
  valid_579174 = validateParameter(valid_579174, JBool, required = false,
                                 default = newJBool(true))
  if valid_579174 != nil:
    section.add "prettyPrint", valid_579174
  var valid_579175 = query.getOrDefault("oauth_token")
  valid_579175 = validateParameter(valid_579175, JString, required = false,
                                 default = nil)
  if valid_579175 != nil:
    section.add "oauth_token", valid_579175
  var valid_579176 = query.getOrDefault("alt")
  valid_579176 = validateParameter(valid_579176, JString, required = false,
                                 default = newJString("json"))
  if valid_579176 != nil:
    section.add "alt", valid_579176
  var valid_579177 = query.getOrDefault("userIp")
  valid_579177 = validateParameter(valid_579177, JString, required = false,
                                 default = nil)
  if valid_579177 != nil:
    section.add "userIp", valid_579177
  var valid_579178 = query.getOrDefault("quotaUser")
  valid_579178 = validateParameter(valid_579178, JString, required = false,
                                 default = nil)
  if valid_579178 != nil:
    section.add "quotaUser", valid_579178
  var valid_579179 = query.getOrDefault("fields")
  valid_579179 = validateParameter(valid_579179, JString, required = false,
                                 default = nil)
  if valid_579179 != nil:
    section.add "fields", valid_579179
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579180: Call_BigqueryRoutinesDelete_579167; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the routine specified by routineId from the dataset.
  ## 
  let valid = call_579180.validator(path, query, header, formData, body)
  let scheme = call_579180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579180.url(scheme.get, call_579180.host, call_579180.base,
                         call_579180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579180, url, valid)

proc call*(call_579181: Call_BigqueryRoutinesDelete_579167; projectId: string;
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
  var path_579182 = newJObject()
  var query_579183 = newJObject()
  add(query_579183, "key", newJString(key))
  add(query_579183, "prettyPrint", newJBool(prettyPrint))
  add(query_579183, "oauth_token", newJString(oauthToken))
  add(path_579182, "projectId", newJString(projectId))
  add(path_579182, "routineId", newJString(routineId))
  add(query_579183, "alt", newJString(alt))
  add(query_579183, "userIp", newJString(userIp))
  add(query_579183, "quotaUser", newJString(quotaUser))
  add(query_579183, "fields", newJString(fields))
  add(path_579182, "datasetId", newJString(datasetId))
  result = call_579181.call(path_579182, query_579183, nil, nil, nil)

var bigqueryRoutinesDelete* = Call_BigqueryRoutinesDelete_579167(
    name: "bigqueryRoutinesDelete", meth: HttpMethod.HttpDelete,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/routines/{routineId}",
    validator: validate_BigqueryRoutinesDelete_579168, base: "/bigquery/v2",
    url: url_BigqueryRoutinesDelete_579169, schemes: {Scheme.Https})
type
  Call_BigqueryTablesInsert_579202 = ref object of OpenApiRestCall_578364
proc url_BigqueryTablesInsert_579204(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryTablesInsert_579203(path: JsonNode; query: JsonNode;
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
  var valid_579205 = path.getOrDefault("projectId")
  valid_579205 = validateParameter(valid_579205, JString, required = true,
                                 default = nil)
  if valid_579205 != nil:
    section.add "projectId", valid_579205
  var valid_579206 = path.getOrDefault("datasetId")
  valid_579206 = validateParameter(valid_579206, JString, required = true,
                                 default = nil)
  if valid_579206 != nil:
    section.add "datasetId", valid_579206
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
  var valid_579207 = query.getOrDefault("key")
  valid_579207 = validateParameter(valid_579207, JString, required = false,
                                 default = nil)
  if valid_579207 != nil:
    section.add "key", valid_579207
  var valid_579208 = query.getOrDefault("prettyPrint")
  valid_579208 = validateParameter(valid_579208, JBool, required = false,
                                 default = newJBool(true))
  if valid_579208 != nil:
    section.add "prettyPrint", valid_579208
  var valid_579209 = query.getOrDefault("oauth_token")
  valid_579209 = validateParameter(valid_579209, JString, required = false,
                                 default = nil)
  if valid_579209 != nil:
    section.add "oauth_token", valid_579209
  var valid_579210 = query.getOrDefault("alt")
  valid_579210 = validateParameter(valid_579210, JString, required = false,
                                 default = newJString("json"))
  if valid_579210 != nil:
    section.add "alt", valid_579210
  var valid_579211 = query.getOrDefault("userIp")
  valid_579211 = validateParameter(valid_579211, JString, required = false,
                                 default = nil)
  if valid_579211 != nil:
    section.add "userIp", valid_579211
  var valid_579212 = query.getOrDefault("quotaUser")
  valid_579212 = validateParameter(valid_579212, JString, required = false,
                                 default = nil)
  if valid_579212 != nil:
    section.add "quotaUser", valid_579212
  var valid_579213 = query.getOrDefault("fields")
  valid_579213 = validateParameter(valid_579213, JString, required = false,
                                 default = nil)
  if valid_579213 != nil:
    section.add "fields", valid_579213
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

proc call*(call_579215: Call_BigqueryTablesInsert_579202; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new, empty table in the dataset.
  ## 
  let valid = call_579215.validator(path, query, header, formData, body)
  let scheme = call_579215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579215.url(scheme.get, call_579215.host, call_579215.base,
                         call_579215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579215, url, valid)

proc call*(call_579216: Call_BigqueryTablesInsert_579202; projectId: string;
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
  var path_579217 = newJObject()
  var query_579218 = newJObject()
  var body_579219 = newJObject()
  add(query_579218, "key", newJString(key))
  add(query_579218, "prettyPrint", newJBool(prettyPrint))
  add(query_579218, "oauth_token", newJString(oauthToken))
  add(path_579217, "projectId", newJString(projectId))
  add(query_579218, "alt", newJString(alt))
  add(query_579218, "userIp", newJString(userIp))
  add(query_579218, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579219 = body
  add(query_579218, "fields", newJString(fields))
  add(path_579217, "datasetId", newJString(datasetId))
  result = call_579216.call(path_579217, query_579218, nil, nil, body_579219)

var bigqueryTablesInsert* = Call_BigqueryTablesInsert_579202(
    name: "bigqueryTablesInsert", meth: HttpMethod.HttpPost,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/tables",
    validator: validate_BigqueryTablesInsert_579203, base: "/bigquery/v2",
    url: url_BigqueryTablesInsert_579204, schemes: {Scheme.Https})
type
  Call_BigqueryTablesList_579184 = ref object of OpenApiRestCall_578364
proc url_BigqueryTablesList_579186(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryTablesList_579185(path: JsonNode; query: JsonNode;
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
  var valid_579187 = path.getOrDefault("projectId")
  valid_579187 = validateParameter(valid_579187, JString, required = true,
                                 default = nil)
  if valid_579187 != nil:
    section.add "projectId", valid_579187
  var valid_579188 = path.getOrDefault("datasetId")
  valid_579188 = validateParameter(valid_579188, JString, required = true,
                                 default = nil)
  if valid_579188 != nil:
    section.add "datasetId", valid_579188
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
  var valid_579189 = query.getOrDefault("key")
  valid_579189 = validateParameter(valid_579189, JString, required = false,
                                 default = nil)
  if valid_579189 != nil:
    section.add "key", valid_579189
  var valid_579190 = query.getOrDefault("prettyPrint")
  valid_579190 = validateParameter(valid_579190, JBool, required = false,
                                 default = newJBool(true))
  if valid_579190 != nil:
    section.add "prettyPrint", valid_579190
  var valid_579191 = query.getOrDefault("oauth_token")
  valid_579191 = validateParameter(valid_579191, JString, required = false,
                                 default = nil)
  if valid_579191 != nil:
    section.add "oauth_token", valid_579191
  var valid_579192 = query.getOrDefault("alt")
  valid_579192 = validateParameter(valid_579192, JString, required = false,
                                 default = newJString("json"))
  if valid_579192 != nil:
    section.add "alt", valid_579192
  var valid_579193 = query.getOrDefault("userIp")
  valid_579193 = validateParameter(valid_579193, JString, required = false,
                                 default = nil)
  if valid_579193 != nil:
    section.add "userIp", valid_579193
  var valid_579194 = query.getOrDefault("quotaUser")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = nil)
  if valid_579194 != nil:
    section.add "quotaUser", valid_579194
  var valid_579195 = query.getOrDefault("pageToken")
  valid_579195 = validateParameter(valid_579195, JString, required = false,
                                 default = nil)
  if valid_579195 != nil:
    section.add "pageToken", valid_579195
  var valid_579196 = query.getOrDefault("fields")
  valid_579196 = validateParameter(valid_579196, JString, required = false,
                                 default = nil)
  if valid_579196 != nil:
    section.add "fields", valid_579196
  var valid_579197 = query.getOrDefault("maxResults")
  valid_579197 = validateParameter(valid_579197, JInt, required = false, default = nil)
  if valid_579197 != nil:
    section.add "maxResults", valid_579197
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579198: Call_BigqueryTablesList_579184; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all tables in the specified dataset. Requires the READER dataset role.
  ## 
  let valid = call_579198.validator(path, query, header, formData, body)
  let scheme = call_579198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579198.url(scheme.get, call_579198.host, call_579198.base,
                         call_579198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579198, url, valid)

proc call*(call_579199: Call_BigqueryTablesList_579184; projectId: string;
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
  var path_579200 = newJObject()
  var query_579201 = newJObject()
  add(query_579201, "key", newJString(key))
  add(query_579201, "prettyPrint", newJBool(prettyPrint))
  add(query_579201, "oauth_token", newJString(oauthToken))
  add(path_579200, "projectId", newJString(projectId))
  add(query_579201, "alt", newJString(alt))
  add(query_579201, "userIp", newJString(userIp))
  add(query_579201, "quotaUser", newJString(quotaUser))
  add(query_579201, "pageToken", newJString(pageToken))
  add(query_579201, "fields", newJString(fields))
  add(query_579201, "maxResults", newJInt(maxResults))
  add(path_579200, "datasetId", newJString(datasetId))
  result = call_579199.call(path_579200, query_579201, nil, nil, nil)

var bigqueryTablesList* = Call_BigqueryTablesList_579184(
    name: "bigqueryTablesList", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/tables",
    validator: validate_BigqueryTablesList_579185, base: "/bigquery/v2",
    url: url_BigqueryTablesList_579186, schemes: {Scheme.Https})
type
  Call_BigqueryTablesUpdate_579238 = ref object of OpenApiRestCall_578364
proc url_BigqueryTablesUpdate_579240(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryTablesUpdate_579239(path: JsonNode; query: JsonNode;
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
  var valid_579241 = path.getOrDefault("projectId")
  valid_579241 = validateParameter(valid_579241, JString, required = true,
                                 default = nil)
  if valid_579241 != nil:
    section.add "projectId", valid_579241
  var valid_579242 = path.getOrDefault("tableId")
  valid_579242 = validateParameter(valid_579242, JString, required = true,
                                 default = nil)
  if valid_579242 != nil:
    section.add "tableId", valid_579242
  var valid_579243 = path.getOrDefault("datasetId")
  valid_579243 = validateParameter(valid_579243, JString, required = true,
                                 default = nil)
  if valid_579243 != nil:
    section.add "datasetId", valid_579243
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
  var valid_579244 = query.getOrDefault("key")
  valid_579244 = validateParameter(valid_579244, JString, required = false,
                                 default = nil)
  if valid_579244 != nil:
    section.add "key", valid_579244
  var valid_579245 = query.getOrDefault("prettyPrint")
  valid_579245 = validateParameter(valid_579245, JBool, required = false,
                                 default = newJBool(true))
  if valid_579245 != nil:
    section.add "prettyPrint", valid_579245
  var valid_579246 = query.getOrDefault("oauth_token")
  valid_579246 = validateParameter(valid_579246, JString, required = false,
                                 default = nil)
  if valid_579246 != nil:
    section.add "oauth_token", valid_579246
  var valid_579247 = query.getOrDefault("alt")
  valid_579247 = validateParameter(valid_579247, JString, required = false,
                                 default = newJString("json"))
  if valid_579247 != nil:
    section.add "alt", valid_579247
  var valid_579248 = query.getOrDefault("userIp")
  valid_579248 = validateParameter(valid_579248, JString, required = false,
                                 default = nil)
  if valid_579248 != nil:
    section.add "userIp", valid_579248
  var valid_579249 = query.getOrDefault("quotaUser")
  valid_579249 = validateParameter(valid_579249, JString, required = false,
                                 default = nil)
  if valid_579249 != nil:
    section.add "quotaUser", valid_579249
  var valid_579250 = query.getOrDefault("fields")
  valid_579250 = validateParameter(valid_579250, JString, required = false,
                                 default = nil)
  if valid_579250 != nil:
    section.add "fields", valid_579250
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

proc call*(call_579252: Call_BigqueryTablesUpdate_579238; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates information in an existing table. The update method replaces the entire table resource, whereas the patch method only replaces fields that are provided in the submitted table resource.
  ## 
  let valid = call_579252.validator(path, query, header, formData, body)
  let scheme = call_579252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579252.url(scheme.get, call_579252.host, call_579252.base,
                         call_579252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579252, url, valid)

proc call*(call_579253: Call_BigqueryTablesUpdate_579238; projectId: string;
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
  var path_579254 = newJObject()
  var query_579255 = newJObject()
  var body_579256 = newJObject()
  add(query_579255, "key", newJString(key))
  add(query_579255, "prettyPrint", newJBool(prettyPrint))
  add(query_579255, "oauth_token", newJString(oauthToken))
  add(path_579254, "projectId", newJString(projectId))
  add(query_579255, "alt", newJString(alt))
  add(query_579255, "userIp", newJString(userIp))
  add(query_579255, "quotaUser", newJString(quotaUser))
  add(path_579254, "tableId", newJString(tableId))
  if body != nil:
    body_579256 = body
  add(query_579255, "fields", newJString(fields))
  add(path_579254, "datasetId", newJString(datasetId))
  result = call_579253.call(path_579254, query_579255, nil, nil, body_579256)

var bigqueryTablesUpdate* = Call_BigqueryTablesUpdate_579238(
    name: "bigqueryTablesUpdate", meth: HttpMethod.HttpPut,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/tables/{tableId}",
    validator: validate_BigqueryTablesUpdate_579239, base: "/bigquery/v2",
    url: url_BigqueryTablesUpdate_579240, schemes: {Scheme.Https})
type
  Call_BigqueryTablesGet_579220 = ref object of OpenApiRestCall_578364
proc url_BigqueryTablesGet_579222(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryTablesGet_579221(path: JsonNode; query: JsonNode;
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
  var valid_579223 = path.getOrDefault("projectId")
  valid_579223 = validateParameter(valid_579223, JString, required = true,
                                 default = nil)
  if valid_579223 != nil:
    section.add "projectId", valid_579223
  var valid_579224 = path.getOrDefault("tableId")
  valid_579224 = validateParameter(valid_579224, JString, required = true,
                                 default = nil)
  if valid_579224 != nil:
    section.add "tableId", valid_579224
  var valid_579225 = path.getOrDefault("datasetId")
  valid_579225 = validateParameter(valid_579225, JString, required = true,
                                 default = nil)
  if valid_579225 != nil:
    section.add "datasetId", valid_579225
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
  var valid_579226 = query.getOrDefault("key")
  valid_579226 = validateParameter(valid_579226, JString, required = false,
                                 default = nil)
  if valid_579226 != nil:
    section.add "key", valid_579226
  var valid_579227 = query.getOrDefault("prettyPrint")
  valid_579227 = validateParameter(valid_579227, JBool, required = false,
                                 default = newJBool(true))
  if valid_579227 != nil:
    section.add "prettyPrint", valid_579227
  var valid_579228 = query.getOrDefault("oauth_token")
  valid_579228 = validateParameter(valid_579228, JString, required = false,
                                 default = nil)
  if valid_579228 != nil:
    section.add "oauth_token", valid_579228
  var valid_579229 = query.getOrDefault("alt")
  valid_579229 = validateParameter(valid_579229, JString, required = false,
                                 default = newJString("json"))
  if valid_579229 != nil:
    section.add "alt", valid_579229
  var valid_579230 = query.getOrDefault("userIp")
  valid_579230 = validateParameter(valid_579230, JString, required = false,
                                 default = nil)
  if valid_579230 != nil:
    section.add "userIp", valid_579230
  var valid_579231 = query.getOrDefault("quotaUser")
  valid_579231 = validateParameter(valid_579231, JString, required = false,
                                 default = nil)
  if valid_579231 != nil:
    section.add "quotaUser", valid_579231
  var valid_579232 = query.getOrDefault("selectedFields")
  valid_579232 = validateParameter(valid_579232, JString, required = false,
                                 default = nil)
  if valid_579232 != nil:
    section.add "selectedFields", valid_579232
  var valid_579233 = query.getOrDefault("fields")
  valid_579233 = validateParameter(valid_579233, JString, required = false,
                                 default = nil)
  if valid_579233 != nil:
    section.add "fields", valid_579233
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579234: Call_BigqueryTablesGet_579220; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified table resource by table ID. This method does not return the data in the table, it only returns the table resource, which describes the structure of this table.
  ## 
  let valid = call_579234.validator(path, query, header, formData, body)
  let scheme = call_579234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579234.url(scheme.get, call_579234.host, call_579234.base,
                         call_579234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579234, url, valid)

proc call*(call_579235: Call_BigqueryTablesGet_579220; projectId: string;
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
  var path_579236 = newJObject()
  var query_579237 = newJObject()
  add(query_579237, "key", newJString(key))
  add(query_579237, "prettyPrint", newJBool(prettyPrint))
  add(query_579237, "oauth_token", newJString(oauthToken))
  add(path_579236, "projectId", newJString(projectId))
  add(query_579237, "alt", newJString(alt))
  add(query_579237, "userIp", newJString(userIp))
  add(query_579237, "quotaUser", newJString(quotaUser))
  add(path_579236, "tableId", newJString(tableId))
  add(query_579237, "selectedFields", newJString(selectedFields))
  add(query_579237, "fields", newJString(fields))
  add(path_579236, "datasetId", newJString(datasetId))
  result = call_579235.call(path_579236, query_579237, nil, nil, nil)

var bigqueryTablesGet* = Call_BigqueryTablesGet_579220(name: "bigqueryTablesGet",
    meth: HttpMethod.HttpGet, host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/tables/{tableId}",
    validator: validate_BigqueryTablesGet_579221, base: "/bigquery/v2",
    url: url_BigqueryTablesGet_579222, schemes: {Scheme.Https})
type
  Call_BigqueryTablesPatch_579274 = ref object of OpenApiRestCall_578364
proc url_BigqueryTablesPatch_579276(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryTablesPatch_579275(path: JsonNode; query: JsonNode;
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
  var valid_579277 = path.getOrDefault("projectId")
  valid_579277 = validateParameter(valid_579277, JString, required = true,
                                 default = nil)
  if valid_579277 != nil:
    section.add "projectId", valid_579277
  var valid_579278 = path.getOrDefault("tableId")
  valid_579278 = validateParameter(valid_579278, JString, required = true,
                                 default = nil)
  if valid_579278 != nil:
    section.add "tableId", valid_579278
  var valid_579279 = path.getOrDefault("datasetId")
  valid_579279 = validateParameter(valid_579279, JString, required = true,
                                 default = nil)
  if valid_579279 != nil:
    section.add "datasetId", valid_579279
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
  var valid_579280 = query.getOrDefault("key")
  valid_579280 = validateParameter(valid_579280, JString, required = false,
                                 default = nil)
  if valid_579280 != nil:
    section.add "key", valid_579280
  var valid_579281 = query.getOrDefault("prettyPrint")
  valid_579281 = validateParameter(valid_579281, JBool, required = false,
                                 default = newJBool(true))
  if valid_579281 != nil:
    section.add "prettyPrint", valid_579281
  var valid_579282 = query.getOrDefault("oauth_token")
  valid_579282 = validateParameter(valid_579282, JString, required = false,
                                 default = nil)
  if valid_579282 != nil:
    section.add "oauth_token", valid_579282
  var valid_579283 = query.getOrDefault("alt")
  valid_579283 = validateParameter(valid_579283, JString, required = false,
                                 default = newJString("json"))
  if valid_579283 != nil:
    section.add "alt", valid_579283
  var valid_579284 = query.getOrDefault("userIp")
  valid_579284 = validateParameter(valid_579284, JString, required = false,
                                 default = nil)
  if valid_579284 != nil:
    section.add "userIp", valid_579284
  var valid_579285 = query.getOrDefault("quotaUser")
  valid_579285 = validateParameter(valid_579285, JString, required = false,
                                 default = nil)
  if valid_579285 != nil:
    section.add "quotaUser", valid_579285
  var valid_579286 = query.getOrDefault("fields")
  valid_579286 = validateParameter(valid_579286, JString, required = false,
                                 default = nil)
  if valid_579286 != nil:
    section.add "fields", valid_579286
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

proc call*(call_579288: Call_BigqueryTablesPatch_579274; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates information in an existing table. The update method replaces the entire table resource, whereas the patch method only replaces fields that are provided in the submitted table resource. This method supports patch semantics.
  ## 
  let valid = call_579288.validator(path, query, header, formData, body)
  let scheme = call_579288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579288.url(scheme.get, call_579288.host, call_579288.base,
                         call_579288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579288, url, valid)

proc call*(call_579289: Call_BigqueryTablesPatch_579274; projectId: string;
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
  var path_579290 = newJObject()
  var query_579291 = newJObject()
  var body_579292 = newJObject()
  add(query_579291, "key", newJString(key))
  add(query_579291, "prettyPrint", newJBool(prettyPrint))
  add(query_579291, "oauth_token", newJString(oauthToken))
  add(path_579290, "projectId", newJString(projectId))
  add(query_579291, "alt", newJString(alt))
  add(query_579291, "userIp", newJString(userIp))
  add(query_579291, "quotaUser", newJString(quotaUser))
  add(path_579290, "tableId", newJString(tableId))
  if body != nil:
    body_579292 = body
  add(query_579291, "fields", newJString(fields))
  add(path_579290, "datasetId", newJString(datasetId))
  result = call_579289.call(path_579290, query_579291, nil, nil, body_579292)

var bigqueryTablesPatch* = Call_BigqueryTablesPatch_579274(
    name: "bigqueryTablesPatch", meth: HttpMethod.HttpPatch,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/tables/{tableId}",
    validator: validate_BigqueryTablesPatch_579275, base: "/bigquery/v2",
    url: url_BigqueryTablesPatch_579276, schemes: {Scheme.Https})
type
  Call_BigqueryTablesDelete_579257 = ref object of OpenApiRestCall_578364
proc url_BigqueryTablesDelete_579259(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryTablesDelete_579258(path: JsonNode; query: JsonNode;
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
  var valid_579260 = path.getOrDefault("projectId")
  valid_579260 = validateParameter(valid_579260, JString, required = true,
                                 default = nil)
  if valid_579260 != nil:
    section.add "projectId", valid_579260
  var valid_579261 = path.getOrDefault("tableId")
  valid_579261 = validateParameter(valid_579261, JString, required = true,
                                 default = nil)
  if valid_579261 != nil:
    section.add "tableId", valid_579261
  var valid_579262 = path.getOrDefault("datasetId")
  valid_579262 = validateParameter(valid_579262, JString, required = true,
                                 default = nil)
  if valid_579262 != nil:
    section.add "datasetId", valid_579262
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
  var valid_579263 = query.getOrDefault("key")
  valid_579263 = validateParameter(valid_579263, JString, required = false,
                                 default = nil)
  if valid_579263 != nil:
    section.add "key", valid_579263
  var valid_579264 = query.getOrDefault("prettyPrint")
  valid_579264 = validateParameter(valid_579264, JBool, required = false,
                                 default = newJBool(true))
  if valid_579264 != nil:
    section.add "prettyPrint", valid_579264
  var valid_579265 = query.getOrDefault("oauth_token")
  valid_579265 = validateParameter(valid_579265, JString, required = false,
                                 default = nil)
  if valid_579265 != nil:
    section.add "oauth_token", valid_579265
  var valid_579266 = query.getOrDefault("alt")
  valid_579266 = validateParameter(valid_579266, JString, required = false,
                                 default = newJString("json"))
  if valid_579266 != nil:
    section.add "alt", valid_579266
  var valid_579267 = query.getOrDefault("userIp")
  valid_579267 = validateParameter(valid_579267, JString, required = false,
                                 default = nil)
  if valid_579267 != nil:
    section.add "userIp", valid_579267
  var valid_579268 = query.getOrDefault("quotaUser")
  valid_579268 = validateParameter(valid_579268, JString, required = false,
                                 default = nil)
  if valid_579268 != nil:
    section.add "quotaUser", valid_579268
  var valid_579269 = query.getOrDefault("fields")
  valid_579269 = validateParameter(valid_579269, JString, required = false,
                                 default = nil)
  if valid_579269 != nil:
    section.add "fields", valid_579269
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579270: Call_BigqueryTablesDelete_579257; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the table specified by tableId from the dataset. If the table contains data, all the data will be deleted.
  ## 
  let valid = call_579270.validator(path, query, header, formData, body)
  let scheme = call_579270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579270.url(scheme.get, call_579270.host, call_579270.base,
                         call_579270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579270, url, valid)

proc call*(call_579271: Call_BigqueryTablesDelete_579257; projectId: string;
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
  var path_579272 = newJObject()
  var query_579273 = newJObject()
  add(query_579273, "key", newJString(key))
  add(query_579273, "prettyPrint", newJBool(prettyPrint))
  add(query_579273, "oauth_token", newJString(oauthToken))
  add(path_579272, "projectId", newJString(projectId))
  add(query_579273, "alt", newJString(alt))
  add(query_579273, "userIp", newJString(userIp))
  add(query_579273, "quotaUser", newJString(quotaUser))
  add(path_579272, "tableId", newJString(tableId))
  add(query_579273, "fields", newJString(fields))
  add(path_579272, "datasetId", newJString(datasetId))
  result = call_579271.call(path_579272, query_579273, nil, nil, nil)

var bigqueryTablesDelete* = Call_BigqueryTablesDelete_579257(
    name: "bigqueryTablesDelete", meth: HttpMethod.HttpDelete,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/tables/{tableId}",
    validator: validate_BigqueryTablesDelete_579258, base: "/bigquery/v2",
    url: url_BigqueryTablesDelete_579259, schemes: {Scheme.Https})
type
  Call_BigqueryTabledataList_579293 = ref object of OpenApiRestCall_578364
proc url_BigqueryTabledataList_579295(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryTabledataList_579294(path: JsonNode; query: JsonNode;
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
  var valid_579296 = path.getOrDefault("projectId")
  valid_579296 = validateParameter(valid_579296, JString, required = true,
                                 default = nil)
  if valid_579296 != nil:
    section.add "projectId", valid_579296
  var valid_579297 = path.getOrDefault("tableId")
  valid_579297 = validateParameter(valid_579297, JString, required = true,
                                 default = nil)
  if valid_579297 != nil:
    section.add "tableId", valid_579297
  var valid_579298 = path.getOrDefault("datasetId")
  valid_579298 = validateParameter(valid_579298, JString, required = true,
                                 default = nil)
  if valid_579298 != nil:
    section.add "datasetId", valid_579298
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
  var valid_579299 = query.getOrDefault("key")
  valid_579299 = validateParameter(valid_579299, JString, required = false,
                                 default = nil)
  if valid_579299 != nil:
    section.add "key", valid_579299
  var valid_579300 = query.getOrDefault("prettyPrint")
  valid_579300 = validateParameter(valid_579300, JBool, required = false,
                                 default = newJBool(true))
  if valid_579300 != nil:
    section.add "prettyPrint", valid_579300
  var valid_579301 = query.getOrDefault("oauth_token")
  valid_579301 = validateParameter(valid_579301, JString, required = false,
                                 default = nil)
  if valid_579301 != nil:
    section.add "oauth_token", valid_579301
  var valid_579302 = query.getOrDefault("alt")
  valid_579302 = validateParameter(valid_579302, JString, required = false,
                                 default = newJString("json"))
  if valid_579302 != nil:
    section.add "alt", valid_579302
  var valid_579303 = query.getOrDefault("userIp")
  valid_579303 = validateParameter(valid_579303, JString, required = false,
                                 default = nil)
  if valid_579303 != nil:
    section.add "userIp", valid_579303
  var valid_579304 = query.getOrDefault("quotaUser")
  valid_579304 = validateParameter(valid_579304, JString, required = false,
                                 default = nil)
  if valid_579304 != nil:
    section.add "quotaUser", valid_579304
  var valid_579305 = query.getOrDefault("startIndex")
  valid_579305 = validateParameter(valid_579305, JString, required = false,
                                 default = nil)
  if valid_579305 != nil:
    section.add "startIndex", valid_579305
  var valid_579306 = query.getOrDefault("pageToken")
  valid_579306 = validateParameter(valid_579306, JString, required = false,
                                 default = nil)
  if valid_579306 != nil:
    section.add "pageToken", valid_579306
  var valid_579307 = query.getOrDefault("selectedFields")
  valid_579307 = validateParameter(valid_579307, JString, required = false,
                                 default = nil)
  if valid_579307 != nil:
    section.add "selectedFields", valid_579307
  var valid_579308 = query.getOrDefault("fields")
  valid_579308 = validateParameter(valid_579308, JString, required = false,
                                 default = nil)
  if valid_579308 != nil:
    section.add "fields", valid_579308
  var valid_579309 = query.getOrDefault("maxResults")
  valid_579309 = validateParameter(valid_579309, JInt, required = false, default = nil)
  if valid_579309 != nil:
    section.add "maxResults", valid_579309
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579310: Call_BigqueryTabledataList_579293; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves table data from a specified set of rows. Requires the READER dataset role.
  ## 
  let valid = call_579310.validator(path, query, header, formData, body)
  let scheme = call_579310.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579310.url(scheme.get, call_579310.host, call_579310.base,
                         call_579310.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579310, url, valid)

proc call*(call_579311: Call_BigqueryTabledataList_579293; projectId: string;
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
  var path_579312 = newJObject()
  var query_579313 = newJObject()
  add(query_579313, "key", newJString(key))
  add(query_579313, "prettyPrint", newJBool(prettyPrint))
  add(query_579313, "oauth_token", newJString(oauthToken))
  add(path_579312, "projectId", newJString(projectId))
  add(query_579313, "alt", newJString(alt))
  add(query_579313, "userIp", newJString(userIp))
  add(query_579313, "quotaUser", newJString(quotaUser))
  add(query_579313, "startIndex", newJString(startIndex))
  add(query_579313, "pageToken", newJString(pageToken))
  add(path_579312, "tableId", newJString(tableId))
  add(query_579313, "selectedFields", newJString(selectedFields))
  add(query_579313, "fields", newJString(fields))
  add(query_579313, "maxResults", newJInt(maxResults))
  add(path_579312, "datasetId", newJString(datasetId))
  result = call_579311.call(path_579312, query_579313, nil, nil, nil)

var bigqueryTabledataList* = Call_BigqueryTabledataList_579293(
    name: "bigqueryTabledataList", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/tables/{tableId}/data",
    validator: validate_BigqueryTabledataList_579294, base: "/bigquery/v2",
    url: url_BigqueryTabledataList_579295, schemes: {Scheme.Https})
type
  Call_BigqueryTabledataInsertAll_579314 = ref object of OpenApiRestCall_578364
proc url_BigqueryTabledataInsertAll_579316(protocol: Scheme; host: string;
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

proc validate_BigqueryTabledataInsertAll_579315(path: JsonNode; query: JsonNode;
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
  var valid_579317 = path.getOrDefault("projectId")
  valid_579317 = validateParameter(valid_579317, JString, required = true,
                                 default = nil)
  if valid_579317 != nil:
    section.add "projectId", valid_579317
  var valid_579318 = path.getOrDefault("tableId")
  valid_579318 = validateParameter(valid_579318, JString, required = true,
                                 default = nil)
  if valid_579318 != nil:
    section.add "tableId", valid_579318
  var valid_579319 = path.getOrDefault("datasetId")
  valid_579319 = validateParameter(valid_579319, JString, required = true,
                                 default = nil)
  if valid_579319 != nil:
    section.add "datasetId", valid_579319
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
  var valid_579320 = query.getOrDefault("key")
  valid_579320 = validateParameter(valid_579320, JString, required = false,
                                 default = nil)
  if valid_579320 != nil:
    section.add "key", valid_579320
  var valid_579321 = query.getOrDefault("prettyPrint")
  valid_579321 = validateParameter(valid_579321, JBool, required = false,
                                 default = newJBool(true))
  if valid_579321 != nil:
    section.add "prettyPrint", valid_579321
  var valid_579322 = query.getOrDefault("oauth_token")
  valid_579322 = validateParameter(valid_579322, JString, required = false,
                                 default = nil)
  if valid_579322 != nil:
    section.add "oauth_token", valid_579322
  var valid_579323 = query.getOrDefault("alt")
  valid_579323 = validateParameter(valid_579323, JString, required = false,
                                 default = newJString("json"))
  if valid_579323 != nil:
    section.add "alt", valid_579323
  var valid_579324 = query.getOrDefault("userIp")
  valid_579324 = validateParameter(valid_579324, JString, required = false,
                                 default = nil)
  if valid_579324 != nil:
    section.add "userIp", valid_579324
  var valid_579325 = query.getOrDefault("quotaUser")
  valid_579325 = validateParameter(valid_579325, JString, required = false,
                                 default = nil)
  if valid_579325 != nil:
    section.add "quotaUser", valid_579325
  var valid_579326 = query.getOrDefault("fields")
  valid_579326 = validateParameter(valid_579326, JString, required = false,
                                 default = nil)
  if valid_579326 != nil:
    section.add "fields", valid_579326
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

proc call*(call_579328: Call_BigqueryTabledataInsertAll_579314; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Streams data into BigQuery one record at a time without needing to run a load job. Requires the WRITER dataset role.
  ## 
  let valid = call_579328.validator(path, query, header, formData, body)
  let scheme = call_579328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579328.url(scheme.get, call_579328.host, call_579328.base,
                         call_579328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579328, url, valid)

proc call*(call_579329: Call_BigqueryTabledataInsertAll_579314; projectId: string;
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
  var path_579330 = newJObject()
  var query_579331 = newJObject()
  var body_579332 = newJObject()
  add(query_579331, "key", newJString(key))
  add(query_579331, "prettyPrint", newJBool(prettyPrint))
  add(query_579331, "oauth_token", newJString(oauthToken))
  add(path_579330, "projectId", newJString(projectId))
  add(query_579331, "alt", newJString(alt))
  add(query_579331, "userIp", newJString(userIp))
  add(query_579331, "quotaUser", newJString(quotaUser))
  add(path_579330, "tableId", newJString(tableId))
  if body != nil:
    body_579332 = body
  add(query_579331, "fields", newJString(fields))
  add(path_579330, "datasetId", newJString(datasetId))
  result = call_579329.call(path_579330, query_579331, nil, nil, body_579332)

var bigqueryTabledataInsertAll* = Call_BigqueryTabledataInsertAll_579314(
    name: "bigqueryTabledataInsertAll", meth: HttpMethod.HttpPost,
    host: "bigquery.googleapis.com", route: "/projects/{projectId}/datasets/{datasetId}/tables/{tableId}/insertAll",
    validator: validate_BigqueryTabledataInsertAll_579315, base: "/bigquery/v2",
    url: url_BigqueryTabledataInsertAll_579316, schemes: {Scheme.Https})
type
  Call_BigqueryJobsInsert_579356 = ref object of OpenApiRestCall_578364
proc url_BigqueryJobsInsert_579358(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryJobsInsert_579357(path: JsonNode; query: JsonNode;
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
  var valid_579359 = path.getOrDefault("projectId")
  valid_579359 = validateParameter(valid_579359, JString, required = true,
                                 default = nil)
  if valid_579359 != nil:
    section.add "projectId", valid_579359
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
  var valid_579360 = query.getOrDefault("key")
  valid_579360 = validateParameter(valid_579360, JString, required = false,
                                 default = nil)
  if valid_579360 != nil:
    section.add "key", valid_579360
  var valid_579361 = query.getOrDefault("prettyPrint")
  valid_579361 = validateParameter(valid_579361, JBool, required = false,
                                 default = newJBool(true))
  if valid_579361 != nil:
    section.add "prettyPrint", valid_579361
  var valid_579362 = query.getOrDefault("oauth_token")
  valid_579362 = validateParameter(valid_579362, JString, required = false,
                                 default = nil)
  if valid_579362 != nil:
    section.add "oauth_token", valid_579362
  var valid_579363 = query.getOrDefault("alt")
  valid_579363 = validateParameter(valid_579363, JString, required = false,
                                 default = newJString("json"))
  if valid_579363 != nil:
    section.add "alt", valid_579363
  var valid_579364 = query.getOrDefault("userIp")
  valid_579364 = validateParameter(valid_579364, JString, required = false,
                                 default = nil)
  if valid_579364 != nil:
    section.add "userIp", valid_579364
  var valid_579365 = query.getOrDefault("quotaUser")
  valid_579365 = validateParameter(valid_579365, JString, required = false,
                                 default = nil)
  if valid_579365 != nil:
    section.add "quotaUser", valid_579365
  var valid_579366 = query.getOrDefault("fields")
  valid_579366 = validateParameter(valid_579366, JString, required = false,
                                 default = nil)
  if valid_579366 != nil:
    section.add "fields", valid_579366
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

proc call*(call_579368: Call_BigqueryJobsInsert_579356; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a new asynchronous job. Requires the Can View project role.
  ## 
  let valid = call_579368.validator(path, query, header, formData, body)
  let scheme = call_579368.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579368.url(scheme.get, call_579368.host, call_579368.base,
                         call_579368.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579368, url, valid)

proc call*(call_579369: Call_BigqueryJobsInsert_579356; projectId: string;
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
  var path_579370 = newJObject()
  var query_579371 = newJObject()
  var body_579372 = newJObject()
  add(query_579371, "key", newJString(key))
  add(query_579371, "prettyPrint", newJBool(prettyPrint))
  add(query_579371, "oauth_token", newJString(oauthToken))
  add(path_579370, "projectId", newJString(projectId))
  add(query_579371, "alt", newJString(alt))
  add(query_579371, "userIp", newJString(userIp))
  add(query_579371, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579372 = body
  add(query_579371, "fields", newJString(fields))
  result = call_579369.call(path_579370, query_579371, nil, nil, body_579372)

var bigqueryJobsInsert* = Call_BigqueryJobsInsert_579356(
    name: "bigqueryJobsInsert", meth: HttpMethod.HttpPost,
    host: "bigquery.googleapis.com", route: "/projects/{projectId}/jobs",
    validator: validate_BigqueryJobsInsert_579357, base: "/bigquery/v2",
    url: url_BigqueryJobsInsert_579358, schemes: {Scheme.Https})
type
  Call_BigqueryJobsList_579333 = ref object of OpenApiRestCall_578364
proc url_BigqueryJobsList_579335(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryJobsList_579334(path: JsonNode; query: JsonNode;
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
  var valid_579336 = path.getOrDefault("projectId")
  valid_579336 = validateParameter(valid_579336, JString, required = true,
                                 default = nil)
  if valid_579336 != nil:
    section.add "projectId", valid_579336
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
  var valid_579337 = query.getOrDefault("key")
  valid_579337 = validateParameter(valid_579337, JString, required = false,
                                 default = nil)
  if valid_579337 != nil:
    section.add "key", valid_579337
  var valid_579338 = query.getOrDefault("prettyPrint")
  valid_579338 = validateParameter(valid_579338, JBool, required = false,
                                 default = newJBool(true))
  if valid_579338 != nil:
    section.add "prettyPrint", valid_579338
  var valid_579339 = query.getOrDefault("oauth_token")
  valid_579339 = validateParameter(valid_579339, JString, required = false,
                                 default = nil)
  if valid_579339 != nil:
    section.add "oauth_token", valid_579339
  var valid_579340 = query.getOrDefault("minCreationTime")
  valid_579340 = validateParameter(valid_579340, JString, required = false,
                                 default = nil)
  if valid_579340 != nil:
    section.add "minCreationTime", valid_579340
  var valid_579341 = query.getOrDefault("alt")
  valid_579341 = validateParameter(valid_579341, JString, required = false,
                                 default = newJString("json"))
  if valid_579341 != nil:
    section.add "alt", valid_579341
  var valid_579342 = query.getOrDefault("userIp")
  valid_579342 = validateParameter(valid_579342, JString, required = false,
                                 default = nil)
  if valid_579342 != nil:
    section.add "userIp", valid_579342
  var valid_579343 = query.getOrDefault("quotaUser")
  valid_579343 = validateParameter(valid_579343, JString, required = false,
                                 default = nil)
  if valid_579343 != nil:
    section.add "quotaUser", valid_579343
  var valid_579344 = query.getOrDefault("parentJobId")
  valid_579344 = validateParameter(valid_579344, JString, required = false,
                                 default = nil)
  if valid_579344 != nil:
    section.add "parentJobId", valid_579344
  var valid_579345 = query.getOrDefault("pageToken")
  valid_579345 = validateParameter(valid_579345, JString, required = false,
                                 default = nil)
  if valid_579345 != nil:
    section.add "pageToken", valid_579345
  var valid_579346 = query.getOrDefault("stateFilter")
  valid_579346 = validateParameter(valid_579346, JArray, required = false,
                                 default = nil)
  if valid_579346 != nil:
    section.add "stateFilter", valid_579346
  var valid_579347 = query.getOrDefault("allUsers")
  valid_579347 = validateParameter(valid_579347, JBool, required = false, default = nil)
  if valid_579347 != nil:
    section.add "allUsers", valid_579347
  var valid_579348 = query.getOrDefault("projection")
  valid_579348 = validateParameter(valid_579348, JString, required = false,
                                 default = newJString("full"))
  if valid_579348 != nil:
    section.add "projection", valid_579348
  var valid_579349 = query.getOrDefault("fields")
  valid_579349 = validateParameter(valid_579349, JString, required = false,
                                 default = nil)
  if valid_579349 != nil:
    section.add "fields", valid_579349
  var valid_579350 = query.getOrDefault("maxCreationTime")
  valid_579350 = validateParameter(valid_579350, JString, required = false,
                                 default = nil)
  if valid_579350 != nil:
    section.add "maxCreationTime", valid_579350
  var valid_579351 = query.getOrDefault("maxResults")
  valid_579351 = validateParameter(valid_579351, JInt, required = false, default = nil)
  if valid_579351 != nil:
    section.add "maxResults", valid_579351
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579352: Call_BigqueryJobsList_579333; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all jobs that you started in the specified project. Job information is available for a six month period after creation. The job list is sorted in reverse chronological order, by job creation time. Requires the Can View project role, or the Is Owner project role if you set the allUsers property.
  ## 
  let valid = call_579352.validator(path, query, header, formData, body)
  let scheme = call_579352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579352.url(scheme.get, call_579352.host, call_579352.base,
                         call_579352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579352, url, valid)

proc call*(call_579353: Call_BigqueryJobsList_579333; projectId: string;
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
  var path_579354 = newJObject()
  var query_579355 = newJObject()
  add(query_579355, "key", newJString(key))
  add(query_579355, "prettyPrint", newJBool(prettyPrint))
  add(query_579355, "oauth_token", newJString(oauthToken))
  add(path_579354, "projectId", newJString(projectId))
  add(query_579355, "minCreationTime", newJString(minCreationTime))
  add(query_579355, "alt", newJString(alt))
  add(query_579355, "userIp", newJString(userIp))
  add(query_579355, "quotaUser", newJString(quotaUser))
  add(query_579355, "parentJobId", newJString(parentJobId))
  add(query_579355, "pageToken", newJString(pageToken))
  if stateFilter != nil:
    query_579355.add "stateFilter", stateFilter
  add(query_579355, "allUsers", newJBool(allUsers))
  add(query_579355, "projection", newJString(projection))
  add(query_579355, "fields", newJString(fields))
  add(query_579355, "maxCreationTime", newJString(maxCreationTime))
  add(query_579355, "maxResults", newJInt(maxResults))
  result = call_579353.call(path_579354, query_579355, nil, nil, nil)

var bigqueryJobsList* = Call_BigqueryJobsList_579333(name: "bigqueryJobsList",
    meth: HttpMethod.HttpGet, host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/jobs", validator: validate_BigqueryJobsList_579334,
    base: "/bigquery/v2", url: url_BigqueryJobsList_579335, schemes: {Scheme.Https})
type
  Call_BigqueryJobsGet_579373 = ref object of OpenApiRestCall_578364
proc url_BigqueryJobsGet_579375(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryJobsGet_579374(path: JsonNode; query: JsonNode;
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
  var valid_579376 = path.getOrDefault("projectId")
  valid_579376 = validateParameter(valid_579376, JString, required = true,
                                 default = nil)
  if valid_579376 != nil:
    section.add "projectId", valid_579376
  var valid_579377 = path.getOrDefault("jobId")
  valid_579377 = validateParameter(valid_579377, JString, required = true,
                                 default = nil)
  if valid_579377 != nil:
    section.add "jobId", valid_579377
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
  var valid_579378 = query.getOrDefault("key")
  valid_579378 = validateParameter(valid_579378, JString, required = false,
                                 default = nil)
  if valid_579378 != nil:
    section.add "key", valid_579378
  var valid_579379 = query.getOrDefault("prettyPrint")
  valid_579379 = validateParameter(valid_579379, JBool, required = false,
                                 default = newJBool(true))
  if valid_579379 != nil:
    section.add "prettyPrint", valid_579379
  var valid_579380 = query.getOrDefault("oauth_token")
  valid_579380 = validateParameter(valid_579380, JString, required = false,
                                 default = nil)
  if valid_579380 != nil:
    section.add "oauth_token", valid_579380
  var valid_579381 = query.getOrDefault("alt")
  valid_579381 = validateParameter(valid_579381, JString, required = false,
                                 default = newJString("json"))
  if valid_579381 != nil:
    section.add "alt", valid_579381
  var valid_579382 = query.getOrDefault("userIp")
  valid_579382 = validateParameter(valid_579382, JString, required = false,
                                 default = nil)
  if valid_579382 != nil:
    section.add "userIp", valid_579382
  var valid_579383 = query.getOrDefault("quotaUser")
  valid_579383 = validateParameter(valid_579383, JString, required = false,
                                 default = nil)
  if valid_579383 != nil:
    section.add "quotaUser", valid_579383
  var valid_579384 = query.getOrDefault("location")
  valid_579384 = validateParameter(valid_579384, JString, required = false,
                                 default = nil)
  if valid_579384 != nil:
    section.add "location", valid_579384
  var valid_579385 = query.getOrDefault("fields")
  valid_579385 = validateParameter(valid_579385, JString, required = false,
                                 default = nil)
  if valid_579385 != nil:
    section.add "fields", valid_579385
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579386: Call_BigqueryJobsGet_579373; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns information about a specific job. Job information is available for a six month period after creation. Requires that you're the person who ran the job, or have the Is Owner project role.
  ## 
  let valid = call_579386.validator(path, query, header, formData, body)
  let scheme = call_579386.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579386.url(scheme.get, call_579386.host, call_579386.base,
                         call_579386.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579386, url, valid)

proc call*(call_579387: Call_BigqueryJobsGet_579373; projectId: string;
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
  var path_579388 = newJObject()
  var query_579389 = newJObject()
  add(query_579389, "key", newJString(key))
  add(query_579389, "prettyPrint", newJBool(prettyPrint))
  add(query_579389, "oauth_token", newJString(oauthToken))
  add(path_579388, "projectId", newJString(projectId))
  add(path_579388, "jobId", newJString(jobId))
  add(query_579389, "alt", newJString(alt))
  add(query_579389, "userIp", newJString(userIp))
  add(query_579389, "quotaUser", newJString(quotaUser))
  add(query_579389, "location", newJString(location))
  add(query_579389, "fields", newJString(fields))
  result = call_579387.call(path_579388, query_579389, nil, nil, nil)

var bigqueryJobsGet* = Call_BigqueryJobsGet_579373(name: "bigqueryJobsGet",
    meth: HttpMethod.HttpGet, host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/jobs/{jobId}",
    validator: validate_BigqueryJobsGet_579374, base: "/bigquery/v2",
    url: url_BigqueryJobsGet_579375, schemes: {Scheme.Https})
type
  Call_BigqueryJobsCancel_579390 = ref object of OpenApiRestCall_578364
proc url_BigqueryJobsCancel_579392(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryJobsCancel_579391(path: JsonNode; query: JsonNode;
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
  var valid_579393 = path.getOrDefault("projectId")
  valid_579393 = validateParameter(valid_579393, JString, required = true,
                                 default = nil)
  if valid_579393 != nil:
    section.add "projectId", valid_579393
  var valid_579394 = path.getOrDefault("jobId")
  valid_579394 = validateParameter(valid_579394, JString, required = true,
                                 default = nil)
  if valid_579394 != nil:
    section.add "jobId", valid_579394
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
  var valid_579395 = query.getOrDefault("key")
  valid_579395 = validateParameter(valid_579395, JString, required = false,
                                 default = nil)
  if valid_579395 != nil:
    section.add "key", valid_579395
  var valid_579396 = query.getOrDefault("prettyPrint")
  valid_579396 = validateParameter(valid_579396, JBool, required = false,
                                 default = newJBool(true))
  if valid_579396 != nil:
    section.add "prettyPrint", valid_579396
  var valid_579397 = query.getOrDefault("oauth_token")
  valid_579397 = validateParameter(valid_579397, JString, required = false,
                                 default = nil)
  if valid_579397 != nil:
    section.add "oauth_token", valid_579397
  var valid_579398 = query.getOrDefault("alt")
  valid_579398 = validateParameter(valid_579398, JString, required = false,
                                 default = newJString("json"))
  if valid_579398 != nil:
    section.add "alt", valid_579398
  var valid_579399 = query.getOrDefault("userIp")
  valid_579399 = validateParameter(valid_579399, JString, required = false,
                                 default = nil)
  if valid_579399 != nil:
    section.add "userIp", valid_579399
  var valid_579400 = query.getOrDefault("quotaUser")
  valid_579400 = validateParameter(valid_579400, JString, required = false,
                                 default = nil)
  if valid_579400 != nil:
    section.add "quotaUser", valid_579400
  var valid_579401 = query.getOrDefault("location")
  valid_579401 = validateParameter(valid_579401, JString, required = false,
                                 default = nil)
  if valid_579401 != nil:
    section.add "location", valid_579401
  var valid_579402 = query.getOrDefault("fields")
  valid_579402 = validateParameter(valid_579402, JString, required = false,
                                 default = nil)
  if valid_579402 != nil:
    section.add "fields", valid_579402
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579403: Call_BigqueryJobsCancel_579390; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Requests that a job be cancelled. This call will return immediately, and the client will need to poll for the job status to see if the cancel completed successfully. Cancelled jobs may still incur costs.
  ## 
  let valid = call_579403.validator(path, query, header, formData, body)
  let scheme = call_579403.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579403.url(scheme.get, call_579403.host, call_579403.base,
                         call_579403.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579403, url, valid)

proc call*(call_579404: Call_BigqueryJobsCancel_579390; projectId: string;
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
  var path_579405 = newJObject()
  var query_579406 = newJObject()
  add(query_579406, "key", newJString(key))
  add(query_579406, "prettyPrint", newJBool(prettyPrint))
  add(query_579406, "oauth_token", newJString(oauthToken))
  add(path_579405, "projectId", newJString(projectId))
  add(path_579405, "jobId", newJString(jobId))
  add(query_579406, "alt", newJString(alt))
  add(query_579406, "userIp", newJString(userIp))
  add(query_579406, "quotaUser", newJString(quotaUser))
  add(query_579406, "location", newJString(location))
  add(query_579406, "fields", newJString(fields))
  result = call_579404.call(path_579405, query_579406, nil, nil, nil)

var bigqueryJobsCancel* = Call_BigqueryJobsCancel_579390(
    name: "bigqueryJobsCancel", meth: HttpMethod.HttpPost,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/jobs/{jobId}/cancel",
    validator: validate_BigqueryJobsCancel_579391, base: "/bigquery/v2",
    url: url_BigqueryJobsCancel_579392, schemes: {Scheme.Https})
type
  Call_BigqueryJobsQuery_579407 = ref object of OpenApiRestCall_578364
proc url_BigqueryJobsQuery_579409(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryJobsQuery_579408(path: JsonNode; query: JsonNode;
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
  var valid_579410 = path.getOrDefault("projectId")
  valid_579410 = validateParameter(valid_579410, JString, required = true,
                                 default = nil)
  if valid_579410 != nil:
    section.add "projectId", valid_579410
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
  var valid_579411 = query.getOrDefault("key")
  valid_579411 = validateParameter(valid_579411, JString, required = false,
                                 default = nil)
  if valid_579411 != nil:
    section.add "key", valid_579411
  var valid_579412 = query.getOrDefault("prettyPrint")
  valid_579412 = validateParameter(valid_579412, JBool, required = false,
                                 default = newJBool(true))
  if valid_579412 != nil:
    section.add "prettyPrint", valid_579412
  var valid_579413 = query.getOrDefault("oauth_token")
  valid_579413 = validateParameter(valid_579413, JString, required = false,
                                 default = nil)
  if valid_579413 != nil:
    section.add "oauth_token", valid_579413
  var valid_579414 = query.getOrDefault("alt")
  valid_579414 = validateParameter(valid_579414, JString, required = false,
                                 default = newJString("json"))
  if valid_579414 != nil:
    section.add "alt", valid_579414
  var valid_579415 = query.getOrDefault("userIp")
  valid_579415 = validateParameter(valid_579415, JString, required = false,
                                 default = nil)
  if valid_579415 != nil:
    section.add "userIp", valid_579415
  var valid_579416 = query.getOrDefault("quotaUser")
  valid_579416 = validateParameter(valid_579416, JString, required = false,
                                 default = nil)
  if valid_579416 != nil:
    section.add "quotaUser", valid_579416
  var valid_579417 = query.getOrDefault("fields")
  valid_579417 = validateParameter(valid_579417, JString, required = false,
                                 default = nil)
  if valid_579417 != nil:
    section.add "fields", valid_579417
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

proc call*(call_579419: Call_BigqueryJobsQuery_579407; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Runs a BigQuery SQL query synchronously and returns query results if the query completes within a specified timeout.
  ## 
  let valid = call_579419.validator(path, query, header, formData, body)
  let scheme = call_579419.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579419.url(scheme.get, call_579419.host, call_579419.base,
                         call_579419.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579419, url, valid)

proc call*(call_579420: Call_BigqueryJobsQuery_579407; projectId: string;
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
  var path_579421 = newJObject()
  var query_579422 = newJObject()
  var body_579423 = newJObject()
  add(query_579422, "key", newJString(key))
  add(query_579422, "prettyPrint", newJBool(prettyPrint))
  add(query_579422, "oauth_token", newJString(oauthToken))
  add(path_579421, "projectId", newJString(projectId))
  add(query_579422, "alt", newJString(alt))
  add(query_579422, "userIp", newJString(userIp))
  add(query_579422, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579423 = body
  add(query_579422, "fields", newJString(fields))
  result = call_579420.call(path_579421, query_579422, nil, nil, body_579423)

var bigqueryJobsQuery* = Call_BigqueryJobsQuery_579407(name: "bigqueryJobsQuery",
    meth: HttpMethod.HttpPost, host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/queries", validator: validate_BigqueryJobsQuery_579408,
    base: "/bigquery/v2", url: url_BigqueryJobsQuery_579409, schemes: {Scheme.Https})
type
  Call_BigqueryJobsGetQueryResults_579424 = ref object of OpenApiRestCall_578364
proc url_BigqueryJobsGetQueryResults_579426(protocol: Scheme; host: string;
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

proc validate_BigqueryJobsGetQueryResults_579425(path: JsonNode; query: JsonNode;
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
  var valid_579427 = path.getOrDefault("projectId")
  valid_579427 = validateParameter(valid_579427, JString, required = true,
                                 default = nil)
  if valid_579427 != nil:
    section.add "projectId", valid_579427
  var valid_579428 = path.getOrDefault("jobId")
  valid_579428 = validateParameter(valid_579428, JString, required = true,
                                 default = nil)
  if valid_579428 != nil:
    section.add "jobId", valid_579428
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
  var valid_579429 = query.getOrDefault("key")
  valid_579429 = validateParameter(valid_579429, JString, required = false,
                                 default = nil)
  if valid_579429 != nil:
    section.add "key", valid_579429
  var valid_579430 = query.getOrDefault("prettyPrint")
  valid_579430 = validateParameter(valid_579430, JBool, required = false,
                                 default = newJBool(true))
  if valid_579430 != nil:
    section.add "prettyPrint", valid_579430
  var valid_579431 = query.getOrDefault("oauth_token")
  valid_579431 = validateParameter(valid_579431, JString, required = false,
                                 default = nil)
  if valid_579431 != nil:
    section.add "oauth_token", valid_579431
  var valid_579432 = query.getOrDefault("timeoutMs")
  valid_579432 = validateParameter(valid_579432, JInt, required = false, default = nil)
  if valid_579432 != nil:
    section.add "timeoutMs", valid_579432
  var valid_579433 = query.getOrDefault("alt")
  valid_579433 = validateParameter(valid_579433, JString, required = false,
                                 default = newJString("json"))
  if valid_579433 != nil:
    section.add "alt", valid_579433
  var valid_579434 = query.getOrDefault("userIp")
  valid_579434 = validateParameter(valid_579434, JString, required = false,
                                 default = nil)
  if valid_579434 != nil:
    section.add "userIp", valid_579434
  var valid_579435 = query.getOrDefault("quotaUser")
  valid_579435 = validateParameter(valid_579435, JString, required = false,
                                 default = nil)
  if valid_579435 != nil:
    section.add "quotaUser", valid_579435
  var valid_579436 = query.getOrDefault("startIndex")
  valid_579436 = validateParameter(valid_579436, JString, required = false,
                                 default = nil)
  if valid_579436 != nil:
    section.add "startIndex", valid_579436
  var valid_579437 = query.getOrDefault("pageToken")
  valid_579437 = validateParameter(valid_579437, JString, required = false,
                                 default = nil)
  if valid_579437 != nil:
    section.add "pageToken", valid_579437
  var valid_579438 = query.getOrDefault("location")
  valid_579438 = validateParameter(valid_579438, JString, required = false,
                                 default = nil)
  if valid_579438 != nil:
    section.add "location", valid_579438
  var valid_579439 = query.getOrDefault("fields")
  valid_579439 = validateParameter(valid_579439, JString, required = false,
                                 default = nil)
  if valid_579439 != nil:
    section.add "fields", valid_579439
  var valid_579440 = query.getOrDefault("maxResults")
  valid_579440 = validateParameter(valid_579440, JInt, required = false, default = nil)
  if valid_579440 != nil:
    section.add "maxResults", valid_579440
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579441: Call_BigqueryJobsGetQueryResults_579424; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the results of a query job.
  ## 
  let valid = call_579441.validator(path, query, header, formData, body)
  let scheme = call_579441.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579441.url(scheme.get, call_579441.host, call_579441.base,
                         call_579441.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579441, url, valid)

proc call*(call_579442: Call_BigqueryJobsGetQueryResults_579424; projectId: string;
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
  var path_579443 = newJObject()
  var query_579444 = newJObject()
  add(query_579444, "key", newJString(key))
  add(query_579444, "prettyPrint", newJBool(prettyPrint))
  add(query_579444, "oauth_token", newJString(oauthToken))
  add(path_579443, "projectId", newJString(projectId))
  add(path_579443, "jobId", newJString(jobId))
  add(query_579444, "timeoutMs", newJInt(timeoutMs))
  add(query_579444, "alt", newJString(alt))
  add(query_579444, "userIp", newJString(userIp))
  add(query_579444, "quotaUser", newJString(quotaUser))
  add(query_579444, "startIndex", newJString(startIndex))
  add(query_579444, "pageToken", newJString(pageToken))
  add(query_579444, "location", newJString(location))
  add(query_579444, "fields", newJString(fields))
  add(query_579444, "maxResults", newJInt(maxResults))
  result = call_579442.call(path_579443, query_579444, nil, nil, nil)

var bigqueryJobsGetQueryResults* = Call_BigqueryJobsGetQueryResults_579424(
    name: "bigqueryJobsGetQueryResults", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/queries/{jobId}",
    validator: validate_BigqueryJobsGetQueryResults_579425, base: "/bigquery/v2",
    url: url_BigqueryJobsGetQueryResults_579426, schemes: {Scheme.Https})
type
  Call_BigqueryProjectsGetServiceAccount_579445 = ref object of OpenApiRestCall_578364
proc url_BigqueryProjectsGetServiceAccount_579447(protocol: Scheme; host: string;
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

proc validate_BigqueryProjectsGetServiceAccount_579446(path: JsonNode;
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
  var valid_579448 = path.getOrDefault("projectId")
  valid_579448 = validateParameter(valid_579448, JString, required = true,
                                 default = nil)
  if valid_579448 != nil:
    section.add "projectId", valid_579448
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
  var valid_579449 = query.getOrDefault("key")
  valid_579449 = validateParameter(valid_579449, JString, required = false,
                                 default = nil)
  if valid_579449 != nil:
    section.add "key", valid_579449
  var valid_579450 = query.getOrDefault("prettyPrint")
  valid_579450 = validateParameter(valid_579450, JBool, required = false,
                                 default = newJBool(true))
  if valid_579450 != nil:
    section.add "prettyPrint", valid_579450
  var valid_579451 = query.getOrDefault("oauth_token")
  valid_579451 = validateParameter(valid_579451, JString, required = false,
                                 default = nil)
  if valid_579451 != nil:
    section.add "oauth_token", valid_579451
  var valid_579452 = query.getOrDefault("alt")
  valid_579452 = validateParameter(valid_579452, JString, required = false,
                                 default = newJString("json"))
  if valid_579452 != nil:
    section.add "alt", valid_579452
  var valid_579453 = query.getOrDefault("userIp")
  valid_579453 = validateParameter(valid_579453, JString, required = false,
                                 default = nil)
  if valid_579453 != nil:
    section.add "userIp", valid_579453
  var valid_579454 = query.getOrDefault("quotaUser")
  valid_579454 = validateParameter(valid_579454, JString, required = false,
                                 default = nil)
  if valid_579454 != nil:
    section.add "quotaUser", valid_579454
  var valid_579455 = query.getOrDefault("fields")
  valid_579455 = validateParameter(valid_579455, JString, required = false,
                                 default = nil)
  if valid_579455 != nil:
    section.add "fields", valid_579455
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579456: Call_BigqueryProjectsGetServiceAccount_579445;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the email address of the service account for your project used for interactions with Google Cloud KMS.
  ## 
  let valid = call_579456.validator(path, query, header, formData, body)
  let scheme = call_579456.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579456.url(scheme.get, call_579456.host, call_579456.base,
                         call_579456.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579456, url, valid)

proc call*(call_579457: Call_BigqueryProjectsGetServiceAccount_579445;
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
  var path_579458 = newJObject()
  var query_579459 = newJObject()
  add(query_579459, "key", newJString(key))
  add(query_579459, "prettyPrint", newJBool(prettyPrint))
  add(query_579459, "oauth_token", newJString(oauthToken))
  add(path_579458, "projectId", newJString(projectId))
  add(query_579459, "alt", newJString(alt))
  add(query_579459, "userIp", newJString(userIp))
  add(query_579459, "quotaUser", newJString(quotaUser))
  add(query_579459, "fields", newJString(fields))
  result = call_579457.call(path_579458, query_579459, nil, nil, nil)

var bigqueryProjectsGetServiceAccount* = Call_BigqueryProjectsGetServiceAccount_579445(
    name: "bigqueryProjectsGetServiceAccount", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/serviceAccount",
    validator: validate_BigqueryProjectsGetServiceAccount_579446,
    base: "/bigquery/v2", url: url_BigqueryProjectsGetServiceAccount_579447,
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
