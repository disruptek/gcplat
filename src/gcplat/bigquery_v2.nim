
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

  OpenApiRestCall_579437 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579437](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579437): Option[Scheme] {.used.} =
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
  gcpServiceName = "bigquery"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BigqueryProjectsList_579705 = ref object of OpenApiRestCall_579437
proc url_BigqueryProjectsList_579707(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BigqueryProjectsList_579706(path: JsonNode; query: JsonNode;
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
  var valid_579819 = query.getOrDefault("fields")
  valid_579819 = validateParameter(valid_579819, JString, required = false,
                                 default = nil)
  if valid_579819 != nil:
    section.add "fields", valid_579819
  var valid_579820 = query.getOrDefault("pageToken")
  valid_579820 = validateParameter(valid_579820, JString, required = false,
                                 default = nil)
  if valid_579820 != nil:
    section.add "pageToken", valid_579820
  var valid_579821 = query.getOrDefault("quotaUser")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = nil)
  if valid_579821 != nil:
    section.add "quotaUser", valid_579821
  var valid_579835 = query.getOrDefault("alt")
  valid_579835 = validateParameter(valid_579835, JString, required = false,
                                 default = newJString("json"))
  if valid_579835 != nil:
    section.add "alt", valid_579835
  var valid_579836 = query.getOrDefault("oauth_token")
  valid_579836 = validateParameter(valid_579836, JString, required = false,
                                 default = nil)
  if valid_579836 != nil:
    section.add "oauth_token", valid_579836
  var valid_579837 = query.getOrDefault("userIp")
  valid_579837 = validateParameter(valid_579837, JString, required = false,
                                 default = nil)
  if valid_579837 != nil:
    section.add "userIp", valid_579837
  var valid_579838 = query.getOrDefault("maxResults")
  valid_579838 = validateParameter(valid_579838, JInt, required = false, default = nil)
  if valid_579838 != nil:
    section.add "maxResults", valid_579838
  var valid_579839 = query.getOrDefault("key")
  valid_579839 = validateParameter(valid_579839, JString, required = false,
                                 default = nil)
  if valid_579839 != nil:
    section.add "key", valid_579839
  var valid_579840 = query.getOrDefault("prettyPrint")
  valid_579840 = validateParameter(valid_579840, JBool, required = false,
                                 default = newJBool(true))
  if valid_579840 != nil:
    section.add "prettyPrint", valid_579840
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579863: Call_BigqueryProjectsList_579705; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all projects to which you have been granted any project role.
  ## 
  let valid = call_579863.validator(path, query, header, formData, body)
  let scheme = call_579863.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579863.url(scheme.get, call_579863.host, call_579863.base,
                         call_579863.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579863, url, valid)

proc call*(call_579934: Call_BigqueryProjectsList_579705; fields: string = "";
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
  var query_579935 = newJObject()
  add(query_579935, "fields", newJString(fields))
  add(query_579935, "pageToken", newJString(pageToken))
  add(query_579935, "quotaUser", newJString(quotaUser))
  add(query_579935, "alt", newJString(alt))
  add(query_579935, "oauth_token", newJString(oauthToken))
  add(query_579935, "userIp", newJString(userIp))
  add(query_579935, "maxResults", newJInt(maxResults))
  add(query_579935, "key", newJString(key))
  add(query_579935, "prettyPrint", newJBool(prettyPrint))
  result = call_579934.call(nil, query_579935, nil, nil, nil)

var bigqueryProjectsList* = Call_BigqueryProjectsList_579705(
    name: "bigqueryProjectsList", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com", route: "/projects",
    validator: validate_BigqueryProjectsList_579706, base: "/bigquery/v2",
    url: url_BigqueryProjectsList_579707, schemes: {Scheme.Https})
type
  Call_BigqueryDatasetsInsert_580008 = ref object of OpenApiRestCall_579437
proc url_BigqueryDatasetsInsert_580010(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryDatasetsInsert_580009(path: JsonNode; query: JsonNode;
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
  var valid_580011 = path.getOrDefault("projectId")
  valid_580011 = validateParameter(valid_580011, JString, required = true,
                                 default = nil)
  if valid_580011 != nil:
    section.add "projectId", valid_580011
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
  var valid_580012 = query.getOrDefault("fields")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "fields", valid_580012
  var valid_580013 = query.getOrDefault("quotaUser")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "quotaUser", valid_580013
  var valid_580014 = query.getOrDefault("alt")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = newJString("json"))
  if valid_580014 != nil:
    section.add "alt", valid_580014
  var valid_580015 = query.getOrDefault("oauth_token")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "oauth_token", valid_580015
  var valid_580016 = query.getOrDefault("userIp")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "userIp", valid_580016
  var valid_580017 = query.getOrDefault("key")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "key", valid_580017
  var valid_580018 = query.getOrDefault("prettyPrint")
  valid_580018 = validateParameter(valid_580018, JBool, required = false,
                                 default = newJBool(true))
  if valid_580018 != nil:
    section.add "prettyPrint", valid_580018
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

proc call*(call_580020: Call_BigqueryDatasetsInsert_580008; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new empty dataset.
  ## 
  let valid = call_580020.validator(path, query, header, formData, body)
  let scheme = call_580020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580020.url(scheme.get, call_580020.host, call_580020.base,
                         call_580020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580020, url, valid)

proc call*(call_580021: Call_BigqueryDatasetsInsert_580008; projectId: string;
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
  var path_580022 = newJObject()
  var query_580023 = newJObject()
  var body_580024 = newJObject()
  add(query_580023, "fields", newJString(fields))
  add(query_580023, "quotaUser", newJString(quotaUser))
  add(query_580023, "alt", newJString(alt))
  add(query_580023, "oauth_token", newJString(oauthToken))
  add(query_580023, "userIp", newJString(userIp))
  add(query_580023, "key", newJString(key))
  add(path_580022, "projectId", newJString(projectId))
  if body != nil:
    body_580024 = body
  add(query_580023, "prettyPrint", newJBool(prettyPrint))
  result = call_580021.call(path_580022, query_580023, nil, nil, body_580024)

var bigqueryDatasetsInsert* = Call_BigqueryDatasetsInsert_580008(
    name: "bigqueryDatasetsInsert", meth: HttpMethod.HttpPost,
    host: "bigquery.googleapis.com", route: "/projects/{projectId}/datasets",
    validator: validate_BigqueryDatasetsInsert_580009, base: "/bigquery/v2",
    url: url_BigqueryDatasetsInsert_580010, schemes: {Scheme.Https})
type
  Call_BigqueryDatasetsList_579975 = ref object of OpenApiRestCall_579437
proc url_BigqueryDatasetsList_579977(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryDatasetsList_579976(path: JsonNode; query: JsonNode;
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
  var valid_579992 = path.getOrDefault("projectId")
  valid_579992 = validateParameter(valid_579992, JString, required = true,
                                 default = nil)
  if valid_579992 != nil:
    section.add "projectId", valid_579992
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
  var valid_579993 = query.getOrDefault("fields")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "fields", valid_579993
  var valid_579994 = query.getOrDefault("pageToken")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "pageToken", valid_579994
  var valid_579995 = query.getOrDefault("quotaUser")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "quotaUser", valid_579995
  var valid_579996 = query.getOrDefault("alt")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = newJString("json"))
  if valid_579996 != nil:
    section.add "alt", valid_579996
  var valid_579997 = query.getOrDefault("oauth_token")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "oauth_token", valid_579997
  var valid_579998 = query.getOrDefault("userIp")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "userIp", valid_579998
  var valid_579999 = query.getOrDefault("all")
  valid_579999 = validateParameter(valid_579999, JBool, required = false, default = nil)
  if valid_579999 != nil:
    section.add "all", valid_579999
  var valid_580000 = query.getOrDefault("maxResults")
  valid_580000 = validateParameter(valid_580000, JInt, required = false, default = nil)
  if valid_580000 != nil:
    section.add "maxResults", valid_580000
  var valid_580001 = query.getOrDefault("key")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "key", valid_580001
  var valid_580002 = query.getOrDefault("prettyPrint")
  valid_580002 = validateParameter(valid_580002, JBool, required = false,
                                 default = newJBool(true))
  if valid_580002 != nil:
    section.add "prettyPrint", valid_580002
  var valid_580003 = query.getOrDefault("filter")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "filter", valid_580003
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580004: Call_BigqueryDatasetsList_579975; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all datasets in the specified project to which you have been granted the READER dataset role.
  ## 
  let valid = call_580004.validator(path, query, header, formData, body)
  let scheme = call_580004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580004.url(scheme.get, call_580004.host, call_580004.base,
                         call_580004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580004, url, valid)

proc call*(call_580005: Call_BigqueryDatasetsList_579975; projectId: string;
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
  var path_580006 = newJObject()
  var query_580007 = newJObject()
  add(query_580007, "fields", newJString(fields))
  add(query_580007, "pageToken", newJString(pageToken))
  add(query_580007, "quotaUser", newJString(quotaUser))
  add(query_580007, "alt", newJString(alt))
  add(query_580007, "oauth_token", newJString(oauthToken))
  add(query_580007, "userIp", newJString(userIp))
  add(query_580007, "all", newJBool(all))
  add(query_580007, "maxResults", newJInt(maxResults))
  add(query_580007, "key", newJString(key))
  add(path_580006, "projectId", newJString(projectId))
  add(query_580007, "prettyPrint", newJBool(prettyPrint))
  add(query_580007, "filter", newJString(filter))
  result = call_580005.call(path_580006, query_580007, nil, nil, nil)

var bigqueryDatasetsList* = Call_BigqueryDatasetsList_579975(
    name: "bigqueryDatasetsList", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com", route: "/projects/{projectId}/datasets",
    validator: validate_BigqueryDatasetsList_579976, base: "/bigquery/v2",
    url: url_BigqueryDatasetsList_579977, schemes: {Scheme.Https})
type
  Call_BigqueryDatasetsUpdate_580041 = ref object of OpenApiRestCall_579437
proc url_BigqueryDatasetsUpdate_580043(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryDatasetsUpdate_580042(path: JsonNode; query: JsonNode;
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
  var valid_580044 = path.getOrDefault("datasetId")
  valid_580044 = validateParameter(valid_580044, JString, required = true,
                                 default = nil)
  if valid_580044 != nil:
    section.add "datasetId", valid_580044
  var valid_580045 = path.getOrDefault("projectId")
  valid_580045 = validateParameter(valid_580045, JString, required = true,
                                 default = nil)
  if valid_580045 != nil:
    section.add "projectId", valid_580045
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
  var valid_580046 = query.getOrDefault("fields")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "fields", valid_580046
  var valid_580047 = query.getOrDefault("quotaUser")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "quotaUser", valid_580047
  var valid_580048 = query.getOrDefault("alt")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = newJString("json"))
  if valid_580048 != nil:
    section.add "alt", valid_580048
  var valid_580049 = query.getOrDefault("oauth_token")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "oauth_token", valid_580049
  var valid_580050 = query.getOrDefault("userIp")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "userIp", valid_580050
  var valid_580051 = query.getOrDefault("key")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "key", valid_580051
  var valid_580052 = query.getOrDefault("prettyPrint")
  valid_580052 = validateParameter(valid_580052, JBool, required = false,
                                 default = newJBool(true))
  if valid_580052 != nil:
    section.add "prettyPrint", valid_580052
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

proc call*(call_580054: Call_BigqueryDatasetsUpdate_580041; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates information in an existing dataset. The update method replaces the entire dataset resource, whereas the patch method only replaces fields that are provided in the submitted dataset resource.
  ## 
  let valid = call_580054.validator(path, query, header, formData, body)
  let scheme = call_580054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580054.url(scheme.get, call_580054.host, call_580054.base,
                         call_580054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580054, url, valid)

proc call*(call_580055: Call_BigqueryDatasetsUpdate_580041; datasetId: string;
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
  var path_580056 = newJObject()
  var query_580057 = newJObject()
  var body_580058 = newJObject()
  add(query_580057, "fields", newJString(fields))
  add(query_580057, "quotaUser", newJString(quotaUser))
  add(query_580057, "alt", newJString(alt))
  add(query_580057, "oauth_token", newJString(oauthToken))
  add(query_580057, "userIp", newJString(userIp))
  add(path_580056, "datasetId", newJString(datasetId))
  add(query_580057, "key", newJString(key))
  add(path_580056, "projectId", newJString(projectId))
  if body != nil:
    body_580058 = body
  add(query_580057, "prettyPrint", newJBool(prettyPrint))
  result = call_580055.call(path_580056, query_580057, nil, nil, body_580058)

var bigqueryDatasetsUpdate* = Call_BigqueryDatasetsUpdate_580041(
    name: "bigqueryDatasetsUpdate", meth: HttpMethod.HttpPut,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}",
    validator: validate_BigqueryDatasetsUpdate_580042, base: "/bigquery/v2",
    url: url_BigqueryDatasetsUpdate_580043, schemes: {Scheme.Https})
type
  Call_BigqueryDatasetsGet_580025 = ref object of OpenApiRestCall_579437
proc url_BigqueryDatasetsGet_580027(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryDatasetsGet_580026(path: JsonNode; query: JsonNode;
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
  var valid_580028 = path.getOrDefault("datasetId")
  valid_580028 = validateParameter(valid_580028, JString, required = true,
                                 default = nil)
  if valid_580028 != nil:
    section.add "datasetId", valid_580028
  var valid_580029 = path.getOrDefault("projectId")
  valid_580029 = validateParameter(valid_580029, JString, required = true,
                                 default = nil)
  if valid_580029 != nil:
    section.add "projectId", valid_580029
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
  var valid_580030 = query.getOrDefault("fields")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "fields", valid_580030
  var valid_580031 = query.getOrDefault("quotaUser")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "quotaUser", valid_580031
  var valid_580032 = query.getOrDefault("alt")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = newJString("json"))
  if valid_580032 != nil:
    section.add "alt", valid_580032
  var valid_580033 = query.getOrDefault("oauth_token")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "oauth_token", valid_580033
  var valid_580034 = query.getOrDefault("userIp")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "userIp", valid_580034
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580037: Call_BigqueryDatasetsGet_580025; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the dataset specified by datasetID.
  ## 
  let valid = call_580037.validator(path, query, header, formData, body)
  let scheme = call_580037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580037.url(scheme.get, call_580037.host, call_580037.base,
                         call_580037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580037, url, valid)

proc call*(call_580038: Call_BigqueryDatasetsGet_580025; datasetId: string;
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
  var path_580039 = newJObject()
  var query_580040 = newJObject()
  add(query_580040, "fields", newJString(fields))
  add(query_580040, "quotaUser", newJString(quotaUser))
  add(query_580040, "alt", newJString(alt))
  add(query_580040, "oauth_token", newJString(oauthToken))
  add(query_580040, "userIp", newJString(userIp))
  add(path_580039, "datasetId", newJString(datasetId))
  add(query_580040, "key", newJString(key))
  add(path_580039, "projectId", newJString(projectId))
  add(query_580040, "prettyPrint", newJBool(prettyPrint))
  result = call_580038.call(path_580039, query_580040, nil, nil, nil)

var bigqueryDatasetsGet* = Call_BigqueryDatasetsGet_580025(
    name: "bigqueryDatasetsGet", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}",
    validator: validate_BigqueryDatasetsGet_580026, base: "/bigquery/v2",
    url: url_BigqueryDatasetsGet_580027, schemes: {Scheme.Https})
type
  Call_BigqueryDatasetsPatch_580076 = ref object of OpenApiRestCall_579437
proc url_BigqueryDatasetsPatch_580078(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryDatasetsPatch_580077(path: JsonNode; query: JsonNode;
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
  var valid_580079 = path.getOrDefault("datasetId")
  valid_580079 = validateParameter(valid_580079, JString, required = true,
                                 default = nil)
  if valid_580079 != nil:
    section.add "datasetId", valid_580079
  var valid_580080 = path.getOrDefault("projectId")
  valid_580080 = validateParameter(valid_580080, JString, required = true,
                                 default = nil)
  if valid_580080 != nil:
    section.add "projectId", valid_580080
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
  var valid_580081 = query.getOrDefault("fields")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "fields", valid_580081
  var valid_580082 = query.getOrDefault("quotaUser")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "quotaUser", valid_580082
  var valid_580083 = query.getOrDefault("alt")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = newJString("json"))
  if valid_580083 != nil:
    section.add "alt", valid_580083
  var valid_580084 = query.getOrDefault("oauth_token")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "oauth_token", valid_580084
  var valid_580085 = query.getOrDefault("userIp")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "userIp", valid_580085
  var valid_580086 = query.getOrDefault("key")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "key", valid_580086
  var valid_580087 = query.getOrDefault("prettyPrint")
  valid_580087 = validateParameter(valid_580087, JBool, required = false,
                                 default = newJBool(true))
  if valid_580087 != nil:
    section.add "prettyPrint", valid_580087
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

proc call*(call_580089: Call_BigqueryDatasetsPatch_580076; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates information in an existing dataset. The update method replaces the entire dataset resource, whereas the patch method only replaces fields that are provided in the submitted dataset resource. This method supports patch semantics.
  ## 
  let valid = call_580089.validator(path, query, header, formData, body)
  let scheme = call_580089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580089.url(scheme.get, call_580089.host, call_580089.base,
                         call_580089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580089, url, valid)

proc call*(call_580090: Call_BigqueryDatasetsPatch_580076; datasetId: string;
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
  var path_580091 = newJObject()
  var query_580092 = newJObject()
  var body_580093 = newJObject()
  add(query_580092, "fields", newJString(fields))
  add(query_580092, "quotaUser", newJString(quotaUser))
  add(query_580092, "alt", newJString(alt))
  add(query_580092, "oauth_token", newJString(oauthToken))
  add(query_580092, "userIp", newJString(userIp))
  add(path_580091, "datasetId", newJString(datasetId))
  add(query_580092, "key", newJString(key))
  add(path_580091, "projectId", newJString(projectId))
  if body != nil:
    body_580093 = body
  add(query_580092, "prettyPrint", newJBool(prettyPrint))
  result = call_580090.call(path_580091, query_580092, nil, nil, body_580093)

var bigqueryDatasetsPatch* = Call_BigqueryDatasetsPatch_580076(
    name: "bigqueryDatasetsPatch", meth: HttpMethod.HttpPatch,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}",
    validator: validate_BigqueryDatasetsPatch_580077, base: "/bigquery/v2",
    url: url_BigqueryDatasetsPatch_580078, schemes: {Scheme.Https})
type
  Call_BigqueryDatasetsDelete_580059 = ref object of OpenApiRestCall_579437
proc url_BigqueryDatasetsDelete_580061(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryDatasetsDelete_580060(path: JsonNode; query: JsonNode;
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
  var valid_580062 = path.getOrDefault("datasetId")
  valid_580062 = validateParameter(valid_580062, JString, required = true,
                                 default = nil)
  if valid_580062 != nil:
    section.add "datasetId", valid_580062
  var valid_580063 = path.getOrDefault("projectId")
  valid_580063 = validateParameter(valid_580063, JString, required = true,
                                 default = nil)
  if valid_580063 != nil:
    section.add "projectId", valid_580063
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
  var valid_580064 = query.getOrDefault("fields")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "fields", valid_580064
  var valid_580065 = query.getOrDefault("quotaUser")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "quotaUser", valid_580065
  var valid_580066 = query.getOrDefault("alt")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = newJString("json"))
  if valid_580066 != nil:
    section.add "alt", valid_580066
  var valid_580067 = query.getOrDefault("deleteContents")
  valid_580067 = validateParameter(valid_580067, JBool, required = false, default = nil)
  if valid_580067 != nil:
    section.add "deleteContents", valid_580067
  var valid_580068 = query.getOrDefault("oauth_token")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "oauth_token", valid_580068
  var valid_580069 = query.getOrDefault("userIp")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "userIp", valid_580069
  var valid_580070 = query.getOrDefault("key")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "key", valid_580070
  var valid_580071 = query.getOrDefault("prettyPrint")
  valid_580071 = validateParameter(valid_580071, JBool, required = false,
                                 default = newJBool(true))
  if valid_580071 != nil:
    section.add "prettyPrint", valid_580071
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580072: Call_BigqueryDatasetsDelete_580059; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the dataset specified by the datasetId value. Before you can delete a dataset, you must delete all its tables, either manually or by specifying deleteContents. Immediately after deletion, you can create another dataset with the same name.
  ## 
  let valid = call_580072.validator(path, query, header, formData, body)
  let scheme = call_580072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580072.url(scheme.get, call_580072.host, call_580072.base,
                         call_580072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580072, url, valid)

proc call*(call_580073: Call_BigqueryDatasetsDelete_580059; datasetId: string;
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
  var path_580074 = newJObject()
  var query_580075 = newJObject()
  add(query_580075, "fields", newJString(fields))
  add(query_580075, "quotaUser", newJString(quotaUser))
  add(query_580075, "alt", newJString(alt))
  add(query_580075, "deleteContents", newJBool(deleteContents))
  add(query_580075, "oauth_token", newJString(oauthToken))
  add(query_580075, "userIp", newJString(userIp))
  add(path_580074, "datasetId", newJString(datasetId))
  add(query_580075, "key", newJString(key))
  add(path_580074, "projectId", newJString(projectId))
  add(query_580075, "prettyPrint", newJBool(prettyPrint))
  result = call_580073.call(path_580074, query_580075, nil, nil, nil)

var bigqueryDatasetsDelete* = Call_BigqueryDatasetsDelete_580059(
    name: "bigqueryDatasetsDelete", meth: HttpMethod.HttpDelete,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}",
    validator: validate_BigqueryDatasetsDelete_580060, base: "/bigquery/v2",
    url: url_BigqueryDatasetsDelete_580061, schemes: {Scheme.Https})
type
  Call_BigqueryModelsList_580094 = ref object of OpenApiRestCall_579437
proc url_BigqueryModelsList_580096(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryModelsList_580095(path: JsonNode; query: JsonNode;
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
  var valid_580097 = path.getOrDefault("datasetId")
  valid_580097 = validateParameter(valid_580097, JString, required = true,
                                 default = nil)
  if valid_580097 != nil:
    section.add "datasetId", valid_580097
  var valid_580098 = path.getOrDefault("projectId")
  valid_580098 = validateParameter(valid_580098, JString, required = true,
                                 default = nil)
  if valid_580098 != nil:
    section.add "projectId", valid_580098
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
  var valid_580099 = query.getOrDefault("fields")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "fields", valid_580099
  var valid_580100 = query.getOrDefault("pageToken")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "pageToken", valid_580100
  var valid_580101 = query.getOrDefault("quotaUser")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "quotaUser", valid_580101
  var valid_580102 = query.getOrDefault("alt")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = newJString("json"))
  if valid_580102 != nil:
    section.add "alt", valid_580102
  var valid_580103 = query.getOrDefault("oauth_token")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "oauth_token", valid_580103
  var valid_580104 = query.getOrDefault("userIp")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "userIp", valid_580104
  var valid_580105 = query.getOrDefault("maxResults")
  valid_580105 = validateParameter(valid_580105, JInt, required = false, default = nil)
  if valid_580105 != nil:
    section.add "maxResults", valid_580105
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580108: Call_BigqueryModelsList_580094; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all models in the specified dataset. Requires the READER dataset
  ## role.
  ## 
  let valid = call_580108.validator(path, query, header, formData, body)
  let scheme = call_580108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580108.url(scheme.get, call_580108.host, call_580108.base,
                         call_580108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580108, url, valid)

proc call*(call_580109: Call_BigqueryModelsList_580094; datasetId: string;
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
  var path_580110 = newJObject()
  var query_580111 = newJObject()
  add(query_580111, "fields", newJString(fields))
  add(query_580111, "pageToken", newJString(pageToken))
  add(query_580111, "quotaUser", newJString(quotaUser))
  add(query_580111, "alt", newJString(alt))
  add(query_580111, "oauth_token", newJString(oauthToken))
  add(query_580111, "userIp", newJString(userIp))
  add(path_580110, "datasetId", newJString(datasetId))
  add(query_580111, "maxResults", newJInt(maxResults))
  add(query_580111, "key", newJString(key))
  add(path_580110, "projectId", newJString(projectId))
  add(query_580111, "prettyPrint", newJBool(prettyPrint))
  result = call_580109.call(path_580110, query_580111, nil, nil, nil)

var bigqueryModelsList* = Call_BigqueryModelsList_580094(
    name: "bigqueryModelsList", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/models",
    validator: validate_BigqueryModelsList_580095, base: "/bigquery/v2",
    url: url_BigqueryModelsList_580096, schemes: {Scheme.Https})
type
  Call_BigqueryModelsGet_580112 = ref object of OpenApiRestCall_579437
proc url_BigqueryModelsGet_580114(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryModelsGet_580113(path: JsonNode; query: JsonNode;
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
  var valid_580115 = path.getOrDefault("datasetId")
  valid_580115 = validateParameter(valid_580115, JString, required = true,
                                 default = nil)
  if valid_580115 != nil:
    section.add "datasetId", valid_580115
  var valid_580116 = path.getOrDefault("projectId")
  valid_580116 = validateParameter(valid_580116, JString, required = true,
                                 default = nil)
  if valid_580116 != nil:
    section.add "projectId", valid_580116
  var valid_580117 = path.getOrDefault("modelId")
  valid_580117 = validateParameter(valid_580117, JString, required = true,
                                 default = nil)
  if valid_580117 != nil:
    section.add "modelId", valid_580117
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
  var valid_580118 = query.getOrDefault("fields")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "fields", valid_580118
  var valid_580119 = query.getOrDefault("quotaUser")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "quotaUser", valid_580119
  var valid_580120 = query.getOrDefault("alt")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = newJString("json"))
  if valid_580120 != nil:
    section.add "alt", valid_580120
  var valid_580121 = query.getOrDefault("oauth_token")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "oauth_token", valid_580121
  var valid_580122 = query.getOrDefault("userIp")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "userIp", valid_580122
  var valid_580123 = query.getOrDefault("key")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "key", valid_580123
  var valid_580124 = query.getOrDefault("prettyPrint")
  valid_580124 = validateParameter(valid_580124, JBool, required = false,
                                 default = newJBool(true))
  if valid_580124 != nil:
    section.add "prettyPrint", valid_580124
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580125: Call_BigqueryModelsGet_580112; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified model resource by model ID.
  ## 
  let valid = call_580125.validator(path, query, header, formData, body)
  let scheme = call_580125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580125.url(scheme.get, call_580125.host, call_580125.base,
                         call_580125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580125, url, valid)

proc call*(call_580126: Call_BigqueryModelsGet_580112; datasetId: string;
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
  var path_580127 = newJObject()
  var query_580128 = newJObject()
  add(query_580128, "fields", newJString(fields))
  add(query_580128, "quotaUser", newJString(quotaUser))
  add(query_580128, "alt", newJString(alt))
  add(query_580128, "oauth_token", newJString(oauthToken))
  add(query_580128, "userIp", newJString(userIp))
  add(path_580127, "datasetId", newJString(datasetId))
  add(query_580128, "key", newJString(key))
  add(path_580127, "projectId", newJString(projectId))
  add(path_580127, "modelId", newJString(modelId))
  add(query_580128, "prettyPrint", newJBool(prettyPrint))
  result = call_580126.call(path_580127, query_580128, nil, nil, nil)

var bigqueryModelsGet* = Call_BigqueryModelsGet_580112(name: "bigqueryModelsGet",
    meth: HttpMethod.HttpGet, host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/models/{modelId}",
    validator: validate_BigqueryModelsGet_580113, base: "/bigquery/v2",
    url: url_BigqueryModelsGet_580114, schemes: {Scheme.Https})
type
  Call_BigqueryModelsPatch_580146 = ref object of OpenApiRestCall_579437
proc url_BigqueryModelsPatch_580148(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryModelsPatch_580147(path: JsonNode; query: JsonNode;
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
  var valid_580149 = path.getOrDefault("datasetId")
  valid_580149 = validateParameter(valid_580149, JString, required = true,
                                 default = nil)
  if valid_580149 != nil:
    section.add "datasetId", valid_580149
  var valid_580150 = path.getOrDefault("projectId")
  valid_580150 = validateParameter(valid_580150, JString, required = true,
                                 default = nil)
  if valid_580150 != nil:
    section.add "projectId", valid_580150
  var valid_580151 = path.getOrDefault("modelId")
  valid_580151 = validateParameter(valid_580151, JString, required = true,
                                 default = nil)
  if valid_580151 != nil:
    section.add "modelId", valid_580151
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
  var valid_580152 = query.getOrDefault("fields")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "fields", valid_580152
  var valid_580153 = query.getOrDefault("quotaUser")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "quotaUser", valid_580153
  var valid_580154 = query.getOrDefault("alt")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = newJString("json"))
  if valid_580154 != nil:
    section.add "alt", valid_580154
  var valid_580155 = query.getOrDefault("oauth_token")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "oauth_token", valid_580155
  var valid_580156 = query.getOrDefault("userIp")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "userIp", valid_580156
  var valid_580157 = query.getOrDefault("key")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = nil)
  if valid_580157 != nil:
    section.add "key", valid_580157
  var valid_580158 = query.getOrDefault("prettyPrint")
  valid_580158 = validateParameter(valid_580158, JBool, required = false,
                                 default = newJBool(true))
  if valid_580158 != nil:
    section.add "prettyPrint", valid_580158
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

proc call*(call_580160: Call_BigqueryModelsPatch_580146; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch specific fields in the specified model.
  ## 
  let valid = call_580160.validator(path, query, header, formData, body)
  let scheme = call_580160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580160.url(scheme.get, call_580160.host, call_580160.base,
                         call_580160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580160, url, valid)

proc call*(call_580161: Call_BigqueryModelsPatch_580146; datasetId: string;
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
  var path_580162 = newJObject()
  var query_580163 = newJObject()
  var body_580164 = newJObject()
  add(query_580163, "fields", newJString(fields))
  add(query_580163, "quotaUser", newJString(quotaUser))
  add(query_580163, "alt", newJString(alt))
  add(query_580163, "oauth_token", newJString(oauthToken))
  add(query_580163, "userIp", newJString(userIp))
  add(path_580162, "datasetId", newJString(datasetId))
  add(query_580163, "key", newJString(key))
  add(path_580162, "projectId", newJString(projectId))
  add(path_580162, "modelId", newJString(modelId))
  if body != nil:
    body_580164 = body
  add(query_580163, "prettyPrint", newJBool(prettyPrint))
  result = call_580161.call(path_580162, query_580163, nil, nil, body_580164)

var bigqueryModelsPatch* = Call_BigqueryModelsPatch_580146(
    name: "bigqueryModelsPatch", meth: HttpMethod.HttpPatch,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/models/{modelId}",
    validator: validate_BigqueryModelsPatch_580147, base: "/bigquery/v2",
    url: url_BigqueryModelsPatch_580148, schemes: {Scheme.Https})
type
  Call_BigqueryModelsDelete_580129 = ref object of OpenApiRestCall_579437
proc url_BigqueryModelsDelete_580131(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryModelsDelete_580130(path: JsonNode; query: JsonNode;
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
  var valid_580132 = path.getOrDefault("datasetId")
  valid_580132 = validateParameter(valid_580132, JString, required = true,
                                 default = nil)
  if valid_580132 != nil:
    section.add "datasetId", valid_580132
  var valid_580133 = path.getOrDefault("projectId")
  valid_580133 = validateParameter(valid_580133, JString, required = true,
                                 default = nil)
  if valid_580133 != nil:
    section.add "projectId", valid_580133
  var valid_580134 = path.getOrDefault("modelId")
  valid_580134 = validateParameter(valid_580134, JString, required = true,
                                 default = nil)
  if valid_580134 != nil:
    section.add "modelId", valid_580134
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
  var valid_580135 = query.getOrDefault("fields")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "fields", valid_580135
  var valid_580136 = query.getOrDefault("quotaUser")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "quotaUser", valid_580136
  var valid_580137 = query.getOrDefault("alt")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = newJString("json"))
  if valid_580137 != nil:
    section.add "alt", valid_580137
  var valid_580138 = query.getOrDefault("oauth_token")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "oauth_token", valid_580138
  var valid_580139 = query.getOrDefault("userIp")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "userIp", valid_580139
  var valid_580140 = query.getOrDefault("key")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = nil)
  if valid_580140 != nil:
    section.add "key", valid_580140
  var valid_580141 = query.getOrDefault("prettyPrint")
  valid_580141 = validateParameter(valid_580141, JBool, required = false,
                                 default = newJBool(true))
  if valid_580141 != nil:
    section.add "prettyPrint", valid_580141
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580142: Call_BigqueryModelsDelete_580129; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the model specified by modelId from the dataset.
  ## 
  let valid = call_580142.validator(path, query, header, formData, body)
  let scheme = call_580142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580142.url(scheme.get, call_580142.host, call_580142.base,
                         call_580142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580142, url, valid)

proc call*(call_580143: Call_BigqueryModelsDelete_580129; datasetId: string;
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
  var path_580144 = newJObject()
  var query_580145 = newJObject()
  add(query_580145, "fields", newJString(fields))
  add(query_580145, "quotaUser", newJString(quotaUser))
  add(query_580145, "alt", newJString(alt))
  add(query_580145, "oauth_token", newJString(oauthToken))
  add(query_580145, "userIp", newJString(userIp))
  add(path_580144, "datasetId", newJString(datasetId))
  add(query_580145, "key", newJString(key))
  add(path_580144, "projectId", newJString(projectId))
  add(path_580144, "modelId", newJString(modelId))
  add(query_580145, "prettyPrint", newJBool(prettyPrint))
  result = call_580143.call(path_580144, query_580145, nil, nil, nil)

var bigqueryModelsDelete* = Call_BigqueryModelsDelete_580129(
    name: "bigqueryModelsDelete", meth: HttpMethod.HttpDelete,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/models/{modelId}",
    validator: validate_BigqueryModelsDelete_580130, base: "/bigquery/v2",
    url: url_BigqueryModelsDelete_580131, schemes: {Scheme.Https})
type
  Call_BigqueryRoutinesInsert_580183 = ref object of OpenApiRestCall_579437
proc url_BigqueryRoutinesInsert_580185(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryRoutinesInsert_580184(path: JsonNode; query: JsonNode;
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
  var valid_580186 = path.getOrDefault("datasetId")
  valid_580186 = validateParameter(valid_580186, JString, required = true,
                                 default = nil)
  if valid_580186 != nil:
    section.add "datasetId", valid_580186
  var valid_580187 = path.getOrDefault("projectId")
  valid_580187 = validateParameter(valid_580187, JString, required = true,
                                 default = nil)
  if valid_580187 != nil:
    section.add "projectId", valid_580187
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
  var valid_580188 = query.getOrDefault("fields")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "fields", valid_580188
  var valid_580189 = query.getOrDefault("quotaUser")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "quotaUser", valid_580189
  var valid_580190 = query.getOrDefault("alt")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = newJString("json"))
  if valid_580190 != nil:
    section.add "alt", valid_580190
  var valid_580191 = query.getOrDefault("oauth_token")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "oauth_token", valid_580191
  var valid_580192 = query.getOrDefault("userIp")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "userIp", valid_580192
  var valid_580193 = query.getOrDefault("key")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = nil)
  if valid_580193 != nil:
    section.add "key", valid_580193
  var valid_580194 = query.getOrDefault("prettyPrint")
  valid_580194 = validateParameter(valid_580194, JBool, required = false,
                                 default = newJBool(true))
  if valid_580194 != nil:
    section.add "prettyPrint", valid_580194
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

proc call*(call_580196: Call_BigqueryRoutinesInsert_580183; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new routine in the dataset.
  ## 
  let valid = call_580196.validator(path, query, header, formData, body)
  let scheme = call_580196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580196.url(scheme.get, call_580196.host, call_580196.base,
                         call_580196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580196, url, valid)

proc call*(call_580197: Call_BigqueryRoutinesInsert_580183; datasetId: string;
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
  var path_580198 = newJObject()
  var query_580199 = newJObject()
  var body_580200 = newJObject()
  add(query_580199, "fields", newJString(fields))
  add(query_580199, "quotaUser", newJString(quotaUser))
  add(query_580199, "alt", newJString(alt))
  add(query_580199, "oauth_token", newJString(oauthToken))
  add(query_580199, "userIp", newJString(userIp))
  add(path_580198, "datasetId", newJString(datasetId))
  add(query_580199, "key", newJString(key))
  add(path_580198, "projectId", newJString(projectId))
  if body != nil:
    body_580200 = body
  add(query_580199, "prettyPrint", newJBool(prettyPrint))
  result = call_580197.call(path_580198, query_580199, nil, nil, body_580200)

var bigqueryRoutinesInsert* = Call_BigqueryRoutinesInsert_580183(
    name: "bigqueryRoutinesInsert", meth: HttpMethod.HttpPost,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/routines",
    validator: validate_BigqueryRoutinesInsert_580184, base: "/bigquery/v2",
    url: url_BigqueryRoutinesInsert_580185, schemes: {Scheme.Https})
type
  Call_BigqueryRoutinesList_580165 = ref object of OpenApiRestCall_579437
proc url_BigqueryRoutinesList_580167(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryRoutinesList_580166(path: JsonNode; query: JsonNode;
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
  var valid_580168 = path.getOrDefault("datasetId")
  valid_580168 = validateParameter(valid_580168, JString, required = true,
                                 default = nil)
  if valid_580168 != nil:
    section.add "datasetId", valid_580168
  var valid_580169 = path.getOrDefault("projectId")
  valid_580169 = validateParameter(valid_580169, JString, required = true,
                                 default = nil)
  if valid_580169 != nil:
    section.add "projectId", valid_580169
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
  var valid_580170 = query.getOrDefault("fields")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "fields", valid_580170
  var valid_580171 = query.getOrDefault("pageToken")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "pageToken", valid_580171
  var valid_580172 = query.getOrDefault("quotaUser")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "quotaUser", valid_580172
  var valid_580173 = query.getOrDefault("alt")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = newJString("json"))
  if valid_580173 != nil:
    section.add "alt", valid_580173
  var valid_580174 = query.getOrDefault("oauth_token")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "oauth_token", valid_580174
  var valid_580175 = query.getOrDefault("userIp")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "userIp", valid_580175
  var valid_580176 = query.getOrDefault("maxResults")
  valid_580176 = validateParameter(valid_580176, JInt, required = false, default = nil)
  if valid_580176 != nil:
    section.add "maxResults", valid_580176
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
  if body != nil:
    result.add "body", body

proc call*(call_580179: Call_BigqueryRoutinesList_580165; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all routines in the specified dataset. Requires the READER dataset
  ## role.
  ## 
  let valid = call_580179.validator(path, query, header, formData, body)
  let scheme = call_580179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580179.url(scheme.get, call_580179.host, call_580179.base,
                         call_580179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580179, url, valid)

proc call*(call_580180: Call_BigqueryRoutinesList_580165; datasetId: string;
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
  var path_580181 = newJObject()
  var query_580182 = newJObject()
  add(query_580182, "fields", newJString(fields))
  add(query_580182, "pageToken", newJString(pageToken))
  add(query_580182, "quotaUser", newJString(quotaUser))
  add(query_580182, "alt", newJString(alt))
  add(query_580182, "oauth_token", newJString(oauthToken))
  add(query_580182, "userIp", newJString(userIp))
  add(path_580181, "datasetId", newJString(datasetId))
  add(query_580182, "maxResults", newJInt(maxResults))
  add(query_580182, "key", newJString(key))
  add(path_580181, "projectId", newJString(projectId))
  add(query_580182, "prettyPrint", newJBool(prettyPrint))
  result = call_580180.call(path_580181, query_580182, nil, nil, nil)

var bigqueryRoutinesList* = Call_BigqueryRoutinesList_580165(
    name: "bigqueryRoutinesList", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/routines",
    validator: validate_BigqueryRoutinesList_580166, base: "/bigquery/v2",
    url: url_BigqueryRoutinesList_580167, schemes: {Scheme.Https})
type
  Call_BigqueryRoutinesUpdate_580219 = ref object of OpenApiRestCall_579437
proc url_BigqueryRoutinesUpdate_580221(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryRoutinesUpdate_580220(path: JsonNode; query: JsonNode;
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
  var valid_580222 = path.getOrDefault("datasetId")
  valid_580222 = validateParameter(valid_580222, JString, required = true,
                                 default = nil)
  if valid_580222 != nil:
    section.add "datasetId", valid_580222
  var valid_580223 = path.getOrDefault("projectId")
  valid_580223 = validateParameter(valid_580223, JString, required = true,
                                 default = nil)
  if valid_580223 != nil:
    section.add "projectId", valid_580223
  var valid_580224 = path.getOrDefault("routineId")
  valid_580224 = validateParameter(valid_580224, JString, required = true,
                                 default = nil)
  if valid_580224 != nil:
    section.add "routineId", valid_580224
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
  var valid_580225 = query.getOrDefault("fields")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = nil)
  if valid_580225 != nil:
    section.add "fields", valid_580225
  var valid_580226 = query.getOrDefault("quotaUser")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "quotaUser", valid_580226
  var valid_580227 = query.getOrDefault("alt")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = newJString("json"))
  if valid_580227 != nil:
    section.add "alt", valid_580227
  var valid_580228 = query.getOrDefault("oauth_token")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = nil)
  if valid_580228 != nil:
    section.add "oauth_token", valid_580228
  var valid_580229 = query.getOrDefault("userIp")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "userIp", valid_580229
  var valid_580230 = query.getOrDefault("key")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = nil)
  if valid_580230 != nil:
    section.add "key", valid_580230
  var valid_580231 = query.getOrDefault("prettyPrint")
  valid_580231 = validateParameter(valid_580231, JBool, required = false,
                                 default = newJBool(true))
  if valid_580231 != nil:
    section.add "prettyPrint", valid_580231
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

proc call*(call_580233: Call_BigqueryRoutinesUpdate_580219; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates information in an existing routine. The update method replaces the
  ## entire Routine resource.
  ## 
  let valid = call_580233.validator(path, query, header, formData, body)
  let scheme = call_580233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580233.url(scheme.get, call_580233.host, call_580233.base,
                         call_580233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580233, url, valid)

proc call*(call_580234: Call_BigqueryRoutinesUpdate_580219; datasetId: string;
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
  var path_580235 = newJObject()
  var query_580236 = newJObject()
  var body_580237 = newJObject()
  add(query_580236, "fields", newJString(fields))
  add(query_580236, "quotaUser", newJString(quotaUser))
  add(query_580236, "alt", newJString(alt))
  add(query_580236, "oauth_token", newJString(oauthToken))
  add(query_580236, "userIp", newJString(userIp))
  add(path_580235, "datasetId", newJString(datasetId))
  add(query_580236, "key", newJString(key))
  add(path_580235, "projectId", newJString(projectId))
  add(path_580235, "routineId", newJString(routineId))
  if body != nil:
    body_580237 = body
  add(query_580236, "prettyPrint", newJBool(prettyPrint))
  result = call_580234.call(path_580235, query_580236, nil, nil, body_580237)

var bigqueryRoutinesUpdate* = Call_BigqueryRoutinesUpdate_580219(
    name: "bigqueryRoutinesUpdate", meth: HttpMethod.HttpPut,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/routines/{routineId}",
    validator: validate_BigqueryRoutinesUpdate_580220, base: "/bigquery/v2",
    url: url_BigqueryRoutinesUpdate_580221, schemes: {Scheme.Https})
type
  Call_BigqueryRoutinesGet_580201 = ref object of OpenApiRestCall_579437
proc url_BigqueryRoutinesGet_580203(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryRoutinesGet_580202(path: JsonNode; query: JsonNode;
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
  var valid_580204 = path.getOrDefault("datasetId")
  valid_580204 = validateParameter(valid_580204, JString, required = true,
                                 default = nil)
  if valid_580204 != nil:
    section.add "datasetId", valid_580204
  var valid_580205 = path.getOrDefault("projectId")
  valid_580205 = validateParameter(valid_580205, JString, required = true,
                                 default = nil)
  if valid_580205 != nil:
    section.add "projectId", valid_580205
  var valid_580206 = path.getOrDefault("routineId")
  valid_580206 = validateParameter(valid_580206, JString, required = true,
                                 default = nil)
  if valid_580206 != nil:
    section.add "routineId", valid_580206
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
  var valid_580207 = query.getOrDefault("fields")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "fields", valid_580207
  var valid_580208 = query.getOrDefault("quotaUser")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "quotaUser", valid_580208
  var valid_580209 = query.getOrDefault("alt")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = newJString("json"))
  if valid_580209 != nil:
    section.add "alt", valid_580209
  var valid_580210 = query.getOrDefault("oauth_token")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "oauth_token", valid_580210
  var valid_580211 = query.getOrDefault("userIp")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = nil)
  if valid_580211 != nil:
    section.add "userIp", valid_580211
  var valid_580212 = query.getOrDefault("key")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = nil)
  if valid_580212 != nil:
    section.add "key", valid_580212
  var valid_580213 = query.getOrDefault("fieldMask")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = nil)
  if valid_580213 != nil:
    section.add "fieldMask", valid_580213
  var valid_580214 = query.getOrDefault("prettyPrint")
  valid_580214 = validateParameter(valid_580214, JBool, required = false,
                                 default = newJBool(true))
  if valid_580214 != nil:
    section.add "prettyPrint", valid_580214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580215: Call_BigqueryRoutinesGet_580201; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified routine resource by routine ID.
  ## 
  let valid = call_580215.validator(path, query, header, formData, body)
  let scheme = call_580215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580215.url(scheme.get, call_580215.host, call_580215.base,
                         call_580215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580215, url, valid)

proc call*(call_580216: Call_BigqueryRoutinesGet_580201; datasetId: string;
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
  var path_580217 = newJObject()
  var query_580218 = newJObject()
  add(query_580218, "fields", newJString(fields))
  add(query_580218, "quotaUser", newJString(quotaUser))
  add(query_580218, "alt", newJString(alt))
  add(query_580218, "oauth_token", newJString(oauthToken))
  add(query_580218, "userIp", newJString(userIp))
  add(path_580217, "datasetId", newJString(datasetId))
  add(query_580218, "key", newJString(key))
  add(query_580218, "fieldMask", newJString(fieldMask))
  add(path_580217, "projectId", newJString(projectId))
  add(path_580217, "routineId", newJString(routineId))
  add(query_580218, "prettyPrint", newJBool(prettyPrint))
  result = call_580216.call(path_580217, query_580218, nil, nil, nil)

var bigqueryRoutinesGet* = Call_BigqueryRoutinesGet_580201(
    name: "bigqueryRoutinesGet", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/routines/{routineId}",
    validator: validate_BigqueryRoutinesGet_580202, base: "/bigquery/v2",
    url: url_BigqueryRoutinesGet_580203, schemes: {Scheme.Https})
type
  Call_BigqueryRoutinesDelete_580238 = ref object of OpenApiRestCall_579437
proc url_BigqueryRoutinesDelete_580240(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryRoutinesDelete_580239(path: JsonNode; query: JsonNode;
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
  var valid_580241 = path.getOrDefault("datasetId")
  valid_580241 = validateParameter(valid_580241, JString, required = true,
                                 default = nil)
  if valid_580241 != nil:
    section.add "datasetId", valid_580241
  var valid_580242 = path.getOrDefault("projectId")
  valid_580242 = validateParameter(valid_580242, JString, required = true,
                                 default = nil)
  if valid_580242 != nil:
    section.add "projectId", valid_580242
  var valid_580243 = path.getOrDefault("routineId")
  valid_580243 = validateParameter(valid_580243, JString, required = true,
                                 default = nil)
  if valid_580243 != nil:
    section.add "routineId", valid_580243
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
  var valid_580244 = query.getOrDefault("fields")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = nil)
  if valid_580244 != nil:
    section.add "fields", valid_580244
  var valid_580245 = query.getOrDefault("quotaUser")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = nil)
  if valid_580245 != nil:
    section.add "quotaUser", valid_580245
  var valid_580246 = query.getOrDefault("alt")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = newJString("json"))
  if valid_580246 != nil:
    section.add "alt", valid_580246
  var valid_580247 = query.getOrDefault("oauth_token")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = nil)
  if valid_580247 != nil:
    section.add "oauth_token", valid_580247
  var valid_580248 = query.getOrDefault("userIp")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = nil)
  if valid_580248 != nil:
    section.add "userIp", valid_580248
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580251: Call_BigqueryRoutinesDelete_580238; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the routine specified by routineId from the dataset.
  ## 
  let valid = call_580251.validator(path, query, header, formData, body)
  let scheme = call_580251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580251.url(scheme.get, call_580251.host, call_580251.base,
                         call_580251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580251, url, valid)

proc call*(call_580252: Call_BigqueryRoutinesDelete_580238; datasetId: string;
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
  var path_580253 = newJObject()
  var query_580254 = newJObject()
  add(query_580254, "fields", newJString(fields))
  add(query_580254, "quotaUser", newJString(quotaUser))
  add(query_580254, "alt", newJString(alt))
  add(query_580254, "oauth_token", newJString(oauthToken))
  add(query_580254, "userIp", newJString(userIp))
  add(path_580253, "datasetId", newJString(datasetId))
  add(query_580254, "key", newJString(key))
  add(path_580253, "projectId", newJString(projectId))
  add(path_580253, "routineId", newJString(routineId))
  add(query_580254, "prettyPrint", newJBool(prettyPrint))
  result = call_580252.call(path_580253, query_580254, nil, nil, nil)

var bigqueryRoutinesDelete* = Call_BigqueryRoutinesDelete_580238(
    name: "bigqueryRoutinesDelete", meth: HttpMethod.HttpDelete,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/routines/{routineId}",
    validator: validate_BigqueryRoutinesDelete_580239, base: "/bigquery/v2",
    url: url_BigqueryRoutinesDelete_580240, schemes: {Scheme.Https})
type
  Call_BigqueryTablesInsert_580273 = ref object of OpenApiRestCall_579437
proc url_BigqueryTablesInsert_580275(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryTablesInsert_580274(path: JsonNode; query: JsonNode;
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
  var valid_580276 = path.getOrDefault("datasetId")
  valid_580276 = validateParameter(valid_580276, JString, required = true,
                                 default = nil)
  if valid_580276 != nil:
    section.add "datasetId", valid_580276
  var valid_580277 = path.getOrDefault("projectId")
  valid_580277 = validateParameter(valid_580277, JString, required = true,
                                 default = nil)
  if valid_580277 != nil:
    section.add "projectId", valid_580277
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
  var valid_580278 = query.getOrDefault("fields")
  valid_580278 = validateParameter(valid_580278, JString, required = false,
                                 default = nil)
  if valid_580278 != nil:
    section.add "fields", valid_580278
  var valid_580279 = query.getOrDefault("quotaUser")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = nil)
  if valid_580279 != nil:
    section.add "quotaUser", valid_580279
  var valid_580280 = query.getOrDefault("alt")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = newJString("json"))
  if valid_580280 != nil:
    section.add "alt", valid_580280
  var valid_580281 = query.getOrDefault("oauth_token")
  valid_580281 = validateParameter(valid_580281, JString, required = false,
                                 default = nil)
  if valid_580281 != nil:
    section.add "oauth_token", valid_580281
  var valid_580282 = query.getOrDefault("userIp")
  valid_580282 = validateParameter(valid_580282, JString, required = false,
                                 default = nil)
  if valid_580282 != nil:
    section.add "userIp", valid_580282
  var valid_580283 = query.getOrDefault("key")
  valid_580283 = validateParameter(valid_580283, JString, required = false,
                                 default = nil)
  if valid_580283 != nil:
    section.add "key", valid_580283
  var valid_580284 = query.getOrDefault("prettyPrint")
  valid_580284 = validateParameter(valid_580284, JBool, required = false,
                                 default = newJBool(true))
  if valid_580284 != nil:
    section.add "prettyPrint", valid_580284
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

proc call*(call_580286: Call_BigqueryTablesInsert_580273; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new, empty table in the dataset.
  ## 
  let valid = call_580286.validator(path, query, header, formData, body)
  let scheme = call_580286.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580286.url(scheme.get, call_580286.host, call_580286.base,
                         call_580286.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580286, url, valid)

proc call*(call_580287: Call_BigqueryTablesInsert_580273; datasetId: string;
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
  var path_580288 = newJObject()
  var query_580289 = newJObject()
  var body_580290 = newJObject()
  add(query_580289, "fields", newJString(fields))
  add(query_580289, "quotaUser", newJString(quotaUser))
  add(query_580289, "alt", newJString(alt))
  add(query_580289, "oauth_token", newJString(oauthToken))
  add(query_580289, "userIp", newJString(userIp))
  add(path_580288, "datasetId", newJString(datasetId))
  add(query_580289, "key", newJString(key))
  add(path_580288, "projectId", newJString(projectId))
  if body != nil:
    body_580290 = body
  add(query_580289, "prettyPrint", newJBool(prettyPrint))
  result = call_580287.call(path_580288, query_580289, nil, nil, body_580290)

var bigqueryTablesInsert* = Call_BigqueryTablesInsert_580273(
    name: "bigqueryTablesInsert", meth: HttpMethod.HttpPost,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/tables",
    validator: validate_BigqueryTablesInsert_580274, base: "/bigquery/v2",
    url: url_BigqueryTablesInsert_580275, schemes: {Scheme.Https})
type
  Call_BigqueryTablesList_580255 = ref object of OpenApiRestCall_579437
proc url_BigqueryTablesList_580257(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryTablesList_580256(path: JsonNode; query: JsonNode;
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
  var valid_580258 = path.getOrDefault("datasetId")
  valid_580258 = validateParameter(valid_580258, JString, required = true,
                                 default = nil)
  if valid_580258 != nil:
    section.add "datasetId", valid_580258
  var valid_580259 = path.getOrDefault("projectId")
  valid_580259 = validateParameter(valid_580259, JString, required = true,
                                 default = nil)
  if valid_580259 != nil:
    section.add "projectId", valid_580259
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
  var valid_580260 = query.getOrDefault("fields")
  valid_580260 = validateParameter(valid_580260, JString, required = false,
                                 default = nil)
  if valid_580260 != nil:
    section.add "fields", valid_580260
  var valid_580261 = query.getOrDefault("pageToken")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = nil)
  if valid_580261 != nil:
    section.add "pageToken", valid_580261
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
  var valid_580266 = query.getOrDefault("maxResults")
  valid_580266 = validateParameter(valid_580266, JInt, required = false, default = nil)
  if valid_580266 != nil:
    section.add "maxResults", valid_580266
  var valid_580267 = query.getOrDefault("key")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = nil)
  if valid_580267 != nil:
    section.add "key", valid_580267
  var valid_580268 = query.getOrDefault("prettyPrint")
  valid_580268 = validateParameter(valid_580268, JBool, required = false,
                                 default = newJBool(true))
  if valid_580268 != nil:
    section.add "prettyPrint", valid_580268
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580269: Call_BigqueryTablesList_580255; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all tables in the specified dataset. Requires the READER dataset role.
  ## 
  let valid = call_580269.validator(path, query, header, formData, body)
  let scheme = call_580269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580269.url(scheme.get, call_580269.host, call_580269.base,
                         call_580269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580269, url, valid)

proc call*(call_580270: Call_BigqueryTablesList_580255; datasetId: string;
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
  var path_580271 = newJObject()
  var query_580272 = newJObject()
  add(query_580272, "fields", newJString(fields))
  add(query_580272, "pageToken", newJString(pageToken))
  add(query_580272, "quotaUser", newJString(quotaUser))
  add(query_580272, "alt", newJString(alt))
  add(query_580272, "oauth_token", newJString(oauthToken))
  add(query_580272, "userIp", newJString(userIp))
  add(path_580271, "datasetId", newJString(datasetId))
  add(query_580272, "maxResults", newJInt(maxResults))
  add(query_580272, "key", newJString(key))
  add(path_580271, "projectId", newJString(projectId))
  add(query_580272, "prettyPrint", newJBool(prettyPrint))
  result = call_580270.call(path_580271, query_580272, nil, nil, nil)

var bigqueryTablesList* = Call_BigqueryTablesList_580255(
    name: "bigqueryTablesList", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/tables",
    validator: validate_BigqueryTablesList_580256, base: "/bigquery/v2",
    url: url_BigqueryTablesList_580257, schemes: {Scheme.Https})
type
  Call_BigqueryTablesUpdate_580309 = ref object of OpenApiRestCall_579437
proc url_BigqueryTablesUpdate_580311(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryTablesUpdate_580310(path: JsonNode; query: JsonNode;
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
  var valid_580312 = path.getOrDefault("tableId")
  valid_580312 = validateParameter(valid_580312, JString, required = true,
                                 default = nil)
  if valid_580312 != nil:
    section.add "tableId", valid_580312
  var valid_580313 = path.getOrDefault("datasetId")
  valid_580313 = validateParameter(valid_580313, JString, required = true,
                                 default = nil)
  if valid_580313 != nil:
    section.add "datasetId", valid_580313
  var valid_580314 = path.getOrDefault("projectId")
  valid_580314 = validateParameter(valid_580314, JString, required = true,
                                 default = nil)
  if valid_580314 != nil:
    section.add "projectId", valid_580314
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
  var valid_580315 = query.getOrDefault("fields")
  valid_580315 = validateParameter(valid_580315, JString, required = false,
                                 default = nil)
  if valid_580315 != nil:
    section.add "fields", valid_580315
  var valid_580316 = query.getOrDefault("quotaUser")
  valid_580316 = validateParameter(valid_580316, JString, required = false,
                                 default = nil)
  if valid_580316 != nil:
    section.add "quotaUser", valid_580316
  var valid_580317 = query.getOrDefault("alt")
  valid_580317 = validateParameter(valid_580317, JString, required = false,
                                 default = newJString("json"))
  if valid_580317 != nil:
    section.add "alt", valid_580317
  var valid_580318 = query.getOrDefault("oauth_token")
  valid_580318 = validateParameter(valid_580318, JString, required = false,
                                 default = nil)
  if valid_580318 != nil:
    section.add "oauth_token", valid_580318
  var valid_580319 = query.getOrDefault("userIp")
  valid_580319 = validateParameter(valid_580319, JString, required = false,
                                 default = nil)
  if valid_580319 != nil:
    section.add "userIp", valid_580319
  var valid_580320 = query.getOrDefault("key")
  valid_580320 = validateParameter(valid_580320, JString, required = false,
                                 default = nil)
  if valid_580320 != nil:
    section.add "key", valid_580320
  var valid_580321 = query.getOrDefault("prettyPrint")
  valid_580321 = validateParameter(valid_580321, JBool, required = false,
                                 default = newJBool(true))
  if valid_580321 != nil:
    section.add "prettyPrint", valid_580321
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

proc call*(call_580323: Call_BigqueryTablesUpdate_580309; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates information in an existing table. The update method replaces the entire table resource, whereas the patch method only replaces fields that are provided in the submitted table resource.
  ## 
  let valid = call_580323.validator(path, query, header, formData, body)
  let scheme = call_580323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580323.url(scheme.get, call_580323.host, call_580323.base,
                         call_580323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580323, url, valid)

proc call*(call_580324: Call_BigqueryTablesUpdate_580309; tableId: string;
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
  var path_580325 = newJObject()
  var query_580326 = newJObject()
  var body_580327 = newJObject()
  add(path_580325, "tableId", newJString(tableId))
  add(query_580326, "fields", newJString(fields))
  add(query_580326, "quotaUser", newJString(quotaUser))
  add(query_580326, "alt", newJString(alt))
  add(query_580326, "oauth_token", newJString(oauthToken))
  add(query_580326, "userIp", newJString(userIp))
  add(path_580325, "datasetId", newJString(datasetId))
  add(query_580326, "key", newJString(key))
  add(path_580325, "projectId", newJString(projectId))
  if body != nil:
    body_580327 = body
  add(query_580326, "prettyPrint", newJBool(prettyPrint))
  result = call_580324.call(path_580325, query_580326, nil, nil, body_580327)

var bigqueryTablesUpdate* = Call_BigqueryTablesUpdate_580309(
    name: "bigqueryTablesUpdate", meth: HttpMethod.HttpPut,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/tables/{tableId}",
    validator: validate_BigqueryTablesUpdate_580310, base: "/bigquery/v2",
    url: url_BigqueryTablesUpdate_580311, schemes: {Scheme.Https})
type
  Call_BigqueryTablesGet_580291 = ref object of OpenApiRestCall_579437
proc url_BigqueryTablesGet_580293(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryTablesGet_580292(path: JsonNode; query: JsonNode;
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
  var valid_580294 = path.getOrDefault("tableId")
  valid_580294 = validateParameter(valid_580294, JString, required = true,
                                 default = nil)
  if valid_580294 != nil:
    section.add "tableId", valid_580294
  var valid_580295 = path.getOrDefault("datasetId")
  valid_580295 = validateParameter(valid_580295, JString, required = true,
                                 default = nil)
  if valid_580295 != nil:
    section.add "datasetId", valid_580295
  var valid_580296 = path.getOrDefault("projectId")
  valid_580296 = validateParameter(valid_580296, JString, required = true,
                                 default = nil)
  if valid_580296 != nil:
    section.add "projectId", valid_580296
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
  var valid_580297 = query.getOrDefault("fields")
  valid_580297 = validateParameter(valid_580297, JString, required = false,
                                 default = nil)
  if valid_580297 != nil:
    section.add "fields", valid_580297
  var valid_580298 = query.getOrDefault("quotaUser")
  valid_580298 = validateParameter(valid_580298, JString, required = false,
                                 default = nil)
  if valid_580298 != nil:
    section.add "quotaUser", valid_580298
  var valid_580299 = query.getOrDefault("alt")
  valid_580299 = validateParameter(valid_580299, JString, required = false,
                                 default = newJString("json"))
  if valid_580299 != nil:
    section.add "alt", valid_580299
  var valid_580300 = query.getOrDefault("oauth_token")
  valid_580300 = validateParameter(valid_580300, JString, required = false,
                                 default = nil)
  if valid_580300 != nil:
    section.add "oauth_token", valid_580300
  var valid_580301 = query.getOrDefault("userIp")
  valid_580301 = validateParameter(valid_580301, JString, required = false,
                                 default = nil)
  if valid_580301 != nil:
    section.add "userIp", valid_580301
  var valid_580302 = query.getOrDefault("key")
  valid_580302 = validateParameter(valid_580302, JString, required = false,
                                 default = nil)
  if valid_580302 != nil:
    section.add "key", valid_580302
  var valid_580303 = query.getOrDefault("prettyPrint")
  valid_580303 = validateParameter(valid_580303, JBool, required = false,
                                 default = newJBool(true))
  if valid_580303 != nil:
    section.add "prettyPrint", valid_580303
  var valid_580304 = query.getOrDefault("selectedFields")
  valid_580304 = validateParameter(valid_580304, JString, required = false,
                                 default = nil)
  if valid_580304 != nil:
    section.add "selectedFields", valid_580304
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580305: Call_BigqueryTablesGet_580291; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified table resource by table ID. This method does not return the data in the table, it only returns the table resource, which describes the structure of this table.
  ## 
  let valid = call_580305.validator(path, query, header, formData, body)
  let scheme = call_580305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580305.url(scheme.get, call_580305.host, call_580305.base,
                         call_580305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580305, url, valid)

proc call*(call_580306: Call_BigqueryTablesGet_580291; tableId: string;
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
  var path_580307 = newJObject()
  var query_580308 = newJObject()
  add(path_580307, "tableId", newJString(tableId))
  add(query_580308, "fields", newJString(fields))
  add(query_580308, "quotaUser", newJString(quotaUser))
  add(query_580308, "alt", newJString(alt))
  add(query_580308, "oauth_token", newJString(oauthToken))
  add(query_580308, "userIp", newJString(userIp))
  add(path_580307, "datasetId", newJString(datasetId))
  add(query_580308, "key", newJString(key))
  add(path_580307, "projectId", newJString(projectId))
  add(query_580308, "prettyPrint", newJBool(prettyPrint))
  add(query_580308, "selectedFields", newJString(selectedFields))
  result = call_580306.call(path_580307, query_580308, nil, nil, nil)

var bigqueryTablesGet* = Call_BigqueryTablesGet_580291(name: "bigqueryTablesGet",
    meth: HttpMethod.HttpGet, host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/tables/{tableId}",
    validator: validate_BigqueryTablesGet_580292, base: "/bigquery/v2",
    url: url_BigqueryTablesGet_580293, schemes: {Scheme.Https})
type
  Call_BigqueryTablesPatch_580345 = ref object of OpenApiRestCall_579437
proc url_BigqueryTablesPatch_580347(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryTablesPatch_580346(path: JsonNode; query: JsonNode;
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
  var valid_580348 = path.getOrDefault("tableId")
  valid_580348 = validateParameter(valid_580348, JString, required = true,
                                 default = nil)
  if valid_580348 != nil:
    section.add "tableId", valid_580348
  var valid_580349 = path.getOrDefault("datasetId")
  valid_580349 = validateParameter(valid_580349, JString, required = true,
                                 default = nil)
  if valid_580349 != nil:
    section.add "datasetId", valid_580349
  var valid_580350 = path.getOrDefault("projectId")
  valid_580350 = validateParameter(valid_580350, JString, required = true,
                                 default = nil)
  if valid_580350 != nil:
    section.add "projectId", valid_580350
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
  var valid_580351 = query.getOrDefault("fields")
  valid_580351 = validateParameter(valid_580351, JString, required = false,
                                 default = nil)
  if valid_580351 != nil:
    section.add "fields", valid_580351
  var valid_580352 = query.getOrDefault("quotaUser")
  valid_580352 = validateParameter(valid_580352, JString, required = false,
                                 default = nil)
  if valid_580352 != nil:
    section.add "quotaUser", valid_580352
  var valid_580353 = query.getOrDefault("alt")
  valid_580353 = validateParameter(valid_580353, JString, required = false,
                                 default = newJString("json"))
  if valid_580353 != nil:
    section.add "alt", valid_580353
  var valid_580354 = query.getOrDefault("oauth_token")
  valid_580354 = validateParameter(valid_580354, JString, required = false,
                                 default = nil)
  if valid_580354 != nil:
    section.add "oauth_token", valid_580354
  var valid_580355 = query.getOrDefault("userIp")
  valid_580355 = validateParameter(valid_580355, JString, required = false,
                                 default = nil)
  if valid_580355 != nil:
    section.add "userIp", valid_580355
  var valid_580356 = query.getOrDefault("key")
  valid_580356 = validateParameter(valid_580356, JString, required = false,
                                 default = nil)
  if valid_580356 != nil:
    section.add "key", valid_580356
  var valid_580357 = query.getOrDefault("prettyPrint")
  valid_580357 = validateParameter(valid_580357, JBool, required = false,
                                 default = newJBool(true))
  if valid_580357 != nil:
    section.add "prettyPrint", valid_580357
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

proc call*(call_580359: Call_BigqueryTablesPatch_580345; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates information in an existing table. The update method replaces the entire table resource, whereas the patch method only replaces fields that are provided in the submitted table resource. This method supports patch semantics.
  ## 
  let valid = call_580359.validator(path, query, header, formData, body)
  let scheme = call_580359.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580359.url(scheme.get, call_580359.host, call_580359.base,
                         call_580359.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580359, url, valid)

proc call*(call_580360: Call_BigqueryTablesPatch_580345; tableId: string;
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
  var path_580361 = newJObject()
  var query_580362 = newJObject()
  var body_580363 = newJObject()
  add(path_580361, "tableId", newJString(tableId))
  add(query_580362, "fields", newJString(fields))
  add(query_580362, "quotaUser", newJString(quotaUser))
  add(query_580362, "alt", newJString(alt))
  add(query_580362, "oauth_token", newJString(oauthToken))
  add(query_580362, "userIp", newJString(userIp))
  add(path_580361, "datasetId", newJString(datasetId))
  add(query_580362, "key", newJString(key))
  add(path_580361, "projectId", newJString(projectId))
  if body != nil:
    body_580363 = body
  add(query_580362, "prettyPrint", newJBool(prettyPrint))
  result = call_580360.call(path_580361, query_580362, nil, nil, body_580363)

var bigqueryTablesPatch* = Call_BigqueryTablesPatch_580345(
    name: "bigqueryTablesPatch", meth: HttpMethod.HttpPatch,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/tables/{tableId}",
    validator: validate_BigqueryTablesPatch_580346, base: "/bigquery/v2",
    url: url_BigqueryTablesPatch_580347, schemes: {Scheme.Https})
type
  Call_BigqueryTablesDelete_580328 = ref object of OpenApiRestCall_579437
proc url_BigqueryTablesDelete_580330(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryTablesDelete_580329(path: JsonNode; query: JsonNode;
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
  var valid_580331 = path.getOrDefault("tableId")
  valid_580331 = validateParameter(valid_580331, JString, required = true,
                                 default = nil)
  if valid_580331 != nil:
    section.add "tableId", valid_580331
  var valid_580332 = path.getOrDefault("datasetId")
  valid_580332 = validateParameter(valid_580332, JString, required = true,
                                 default = nil)
  if valid_580332 != nil:
    section.add "datasetId", valid_580332
  var valid_580333 = path.getOrDefault("projectId")
  valid_580333 = validateParameter(valid_580333, JString, required = true,
                                 default = nil)
  if valid_580333 != nil:
    section.add "projectId", valid_580333
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
  var valid_580334 = query.getOrDefault("fields")
  valid_580334 = validateParameter(valid_580334, JString, required = false,
                                 default = nil)
  if valid_580334 != nil:
    section.add "fields", valid_580334
  var valid_580335 = query.getOrDefault("quotaUser")
  valid_580335 = validateParameter(valid_580335, JString, required = false,
                                 default = nil)
  if valid_580335 != nil:
    section.add "quotaUser", valid_580335
  var valid_580336 = query.getOrDefault("alt")
  valid_580336 = validateParameter(valid_580336, JString, required = false,
                                 default = newJString("json"))
  if valid_580336 != nil:
    section.add "alt", valid_580336
  var valid_580337 = query.getOrDefault("oauth_token")
  valid_580337 = validateParameter(valid_580337, JString, required = false,
                                 default = nil)
  if valid_580337 != nil:
    section.add "oauth_token", valid_580337
  var valid_580338 = query.getOrDefault("userIp")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = nil)
  if valid_580338 != nil:
    section.add "userIp", valid_580338
  var valid_580339 = query.getOrDefault("key")
  valid_580339 = validateParameter(valid_580339, JString, required = false,
                                 default = nil)
  if valid_580339 != nil:
    section.add "key", valid_580339
  var valid_580340 = query.getOrDefault("prettyPrint")
  valid_580340 = validateParameter(valid_580340, JBool, required = false,
                                 default = newJBool(true))
  if valid_580340 != nil:
    section.add "prettyPrint", valid_580340
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580341: Call_BigqueryTablesDelete_580328; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the table specified by tableId from the dataset. If the table contains data, all the data will be deleted.
  ## 
  let valid = call_580341.validator(path, query, header, formData, body)
  let scheme = call_580341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580341.url(scheme.get, call_580341.host, call_580341.base,
                         call_580341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580341, url, valid)

proc call*(call_580342: Call_BigqueryTablesDelete_580328; tableId: string;
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
  var path_580343 = newJObject()
  var query_580344 = newJObject()
  add(path_580343, "tableId", newJString(tableId))
  add(query_580344, "fields", newJString(fields))
  add(query_580344, "quotaUser", newJString(quotaUser))
  add(query_580344, "alt", newJString(alt))
  add(query_580344, "oauth_token", newJString(oauthToken))
  add(query_580344, "userIp", newJString(userIp))
  add(path_580343, "datasetId", newJString(datasetId))
  add(query_580344, "key", newJString(key))
  add(path_580343, "projectId", newJString(projectId))
  add(query_580344, "prettyPrint", newJBool(prettyPrint))
  result = call_580342.call(path_580343, query_580344, nil, nil, nil)

var bigqueryTablesDelete* = Call_BigqueryTablesDelete_580328(
    name: "bigqueryTablesDelete", meth: HttpMethod.HttpDelete,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/tables/{tableId}",
    validator: validate_BigqueryTablesDelete_580329, base: "/bigquery/v2",
    url: url_BigqueryTablesDelete_580330, schemes: {Scheme.Https})
type
  Call_BigqueryTabledataList_580364 = ref object of OpenApiRestCall_579437
proc url_BigqueryTabledataList_580366(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryTabledataList_580365(path: JsonNode; query: JsonNode;
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
  var valid_580367 = path.getOrDefault("tableId")
  valid_580367 = validateParameter(valid_580367, JString, required = true,
                                 default = nil)
  if valid_580367 != nil:
    section.add "tableId", valid_580367
  var valid_580368 = path.getOrDefault("datasetId")
  valid_580368 = validateParameter(valid_580368, JString, required = true,
                                 default = nil)
  if valid_580368 != nil:
    section.add "datasetId", valid_580368
  var valid_580369 = path.getOrDefault("projectId")
  valid_580369 = validateParameter(valid_580369, JString, required = true,
                                 default = nil)
  if valid_580369 != nil:
    section.add "projectId", valid_580369
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
  var valid_580370 = query.getOrDefault("fields")
  valid_580370 = validateParameter(valid_580370, JString, required = false,
                                 default = nil)
  if valid_580370 != nil:
    section.add "fields", valid_580370
  var valid_580371 = query.getOrDefault("pageToken")
  valid_580371 = validateParameter(valid_580371, JString, required = false,
                                 default = nil)
  if valid_580371 != nil:
    section.add "pageToken", valid_580371
  var valid_580372 = query.getOrDefault("quotaUser")
  valid_580372 = validateParameter(valid_580372, JString, required = false,
                                 default = nil)
  if valid_580372 != nil:
    section.add "quotaUser", valid_580372
  var valid_580373 = query.getOrDefault("alt")
  valid_580373 = validateParameter(valid_580373, JString, required = false,
                                 default = newJString("json"))
  if valid_580373 != nil:
    section.add "alt", valid_580373
  var valid_580374 = query.getOrDefault("oauth_token")
  valid_580374 = validateParameter(valid_580374, JString, required = false,
                                 default = nil)
  if valid_580374 != nil:
    section.add "oauth_token", valid_580374
  var valid_580375 = query.getOrDefault("userIp")
  valid_580375 = validateParameter(valid_580375, JString, required = false,
                                 default = nil)
  if valid_580375 != nil:
    section.add "userIp", valid_580375
  var valid_580376 = query.getOrDefault("maxResults")
  valid_580376 = validateParameter(valid_580376, JInt, required = false, default = nil)
  if valid_580376 != nil:
    section.add "maxResults", valid_580376
  var valid_580377 = query.getOrDefault("key")
  valid_580377 = validateParameter(valid_580377, JString, required = false,
                                 default = nil)
  if valid_580377 != nil:
    section.add "key", valid_580377
  var valid_580378 = query.getOrDefault("prettyPrint")
  valid_580378 = validateParameter(valid_580378, JBool, required = false,
                                 default = newJBool(true))
  if valid_580378 != nil:
    section.add "prettyPrint", valid_580378
  var valid_580379 = query.getOrDefault("selectedFields")
  valid_580379 = validateParameter(valid_580379, JString, required = false,
                                 default = nil)
  if valid_580379 != nil:
    section.add "selectedFields", valid_580379
  var valid_580380 = query.getOrDefault("startIndex")
  valid_580380 = validateParameter(valid_580380, JString, required = false,
                                 default = nil)
  if valid_580380 != nil:
    section.add "startIndex", valid_580380
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580381: Call_BigqueryTabledataList_580364; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves table data from a specified set of rows. Requires the READER dataset role.
  ## 
  let valid = call_580381.validator(path, query, header, formData, body)
  let scheme = call_580381.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580381.url(scheme.get, call_580381.host, call_580381.base,
                         call_580381.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580381, url, valid)

proc call*(call_580382: Call_BigqueryTabledataList_580364; tableId: string;
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
  var path_580383 = newJObject()
  var query_580384 = newJObject()
  add(path_580383, "tableId", newJString(tableId))
  add(query_580384, "fields", newJString(fields))
  add(query_580384, "pageToken", newJString(pageToken))
  add(query_580384, "quotaUser", newJString(quotaUser))
  add(query_580384, "alt", newJString(alt))
  add(query_580384, "oauth_token", newJString(oauthToken))
  add(query_580384, "userIp", newJString(userIp))
  add(path_580383, "datasetId", newJString(datasetId))
  add(query_580384, "maxResults", newJInt(maxResults))
  add(query_580384, "key", newJString(key))
  add(path_580383, "projectId", newJString(projectId))
  add(query_580384, "prettyPrint", newJBool(prettyPrint))
  add(query_580384, "selectedFields", newJString(selectedFields))
  add(query_580384, "startIndex", newJString(startIndex))
  result = call_580382.call(path_580383, query_580384, nil, nil, nil)

var bigqueryTabledataList* = Call_BigqueryTabledataList_580364(
    name: "bigqueryTabledataList", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/tables/{tableId}/data",
    validator: validate_BigqueryTabledataList_580365, base: "/bigquery/v2",
    url: url_BigqueryTabledataList_580366, schemes: {Scheme.Https})
type
  Call_BigqueryTabledataInsertAll_580385 = ref object of OpenApiRestCall_579437
proc url_BigqueryTabledataInsertAll_580387(protocol: Scheme; host: string;
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

proc validate_BigqueryTabledataInsertAll_580386(path: JsonNode; query: JsonNode;
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
  var valid_580388 = path.getOrDefault("tableId")
  valid_580388 = validateParameter(valid_580388, JString, required = true,
                                 default = nil)
  if valid_580388 != nil:
    section.add "tableId", valid_580388
  var valid_580389 = path.getOrDefault("datasetId")
  valid_580389 = validateParameter(valid_580389, JString, required = true,
                                 default = nil)
  if valid_580389 != nil:
    section.add "datasetId", valid_580389
  var valid_580390 = path.getOrDefault("projectId")
  valid_580390 = validateParameter(valid_580390, JString, required = true,
                                 default = nil)
  if valid_580390 != nil:
    section.add "projectId", valid_580390
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
  var valid_580391 = query.getOrDefault("fields")
  valid_580391 = validateParameter(valid_580391, JString, required = false,
                                 default = nil)
  if valid_580391 != nil:
    section.add "fields", valid_580391
  var valid_580392 = query.getOrDefault("quotaUser")
  valid_580392 = validateParameter(valid_580392, JString, required = false,
                                 default = nil)
  if valid_580392 != nil:
    section.add "quotaUser", valid_580392
  var valid_580393 = query.getOrDefault("alt")
  valid_580393 = validateParameter(valid_580393, JString, required = false,
                                 default = newJString("json"))
  if valid_580393 != nil:
    section.add "alt", valid_580393
  var valid_580394 = query.getOrDefault("oauth_token")
  valid_580394 = validateParameter(valid_580394, JString, required = false,
                                 default = nil)
  if valid_580394 != nil:
    section.add "oauth_token", valid_580394
  var valid_580395 = query.getOrDefault("userIp")
  valid_580395 = validateParameter(valid_580395, JString, required = false,
                                 default = nil)
  if valid_580395 != nil:
    section.add "userIp", valid_580395
  var valid_580396 = query.getOrDefault("key")
  valid_580396 = validateParameter(valid_580396, JString, required = false,
                                 default = nil)
  if valid_580396 != nil:
    section.add "key", valid_580396
  var valid_580397 = query.getOrDefault("prettyPrint")
  valid_580397 = validateParameter(valid_580397, JBool, required = false,
                                 default = newJBool(true))
  if valid_580397 != nil:
    section.add "prettyPrint", valid_580397
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

proc call*(call_580399: Call_BigqueryTabledataInsertAll_580385; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Streams data into BigQuery one record at a time without needing to run a load job. Requires the WRITER dataset role.
  ## 
  let valid = call_580399.validator(path, query, header, formData, body)
  let scheme = call_580399.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580399.url(scheme.get, call_580399.host, call_580399.base,
                         call_580399.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580399, url, valid)

proc call*(call_580400: Call_BigqueryTabledataInsertAll_580385; tableId: string;
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
  var path_580401 = newJObject()
  var query_580402 = newJObject()
  var body_580403 = newJObject()
  add(path_580401, "tableId", newJString(tableId))
  add(query_580402, "fields", newJString(fields))
  add(query_580402, "quotaUser", newJString(quotaUser))
  add(query_580402, "alt", newJString(alt))
  add(query_580402, "oauth_token", newJString(oauthToken))
  add(query_580402, "userIp", newJString(userIp))
  add(path_580401, "datasetId", newJString(datasetId))
  add(query_580402, "key", newJString(key))
  add(path_580401, "projectId", newJString(projectId))
  if body != nil:
    body_580403 = body
  add(query_580402, "prettyPrint", newJBool(prettyPrint))
  result = call_580400.call(path_580401, query_580402, nil, nil, body_580403)

var bigqueryTabledataInsertAll* = Call_BigqueryTabledataInsertAll_580385(
    name: "bigqueryTabledataInsertAll", meth: HttpMethod.HttpPost,
    host: "bigquery.googleapis.com", route: "/projects/{projectId}/datasets/{datasetId}/tables/{tableId}/insertAll",
    validator: validate_BigqueryTabledataInsertAll_580386, base: "/bigquery/v2",
    url: url_BigqueryTabledataInsertAll_580387, schemes: {Scheme.Https})
type
  Call_BigqueryJobsInsert_580427 = ref object of OpenApiRestCall_579437
proc url_BigqueryJobsInsert_580429(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryJobsInsert_580428(path: JsonNode; query: JsonNode;
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
  var valid_580430 = path.getOrDefault("projectId")
  valid_580430 = validateParameter(valid_580430, JString, required = true,
                                 default = nil)
  if valid_580430 != nil:
    section.add "projectId", valid_580430
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
  var valid_580431 = query.getOrDefault("fields")
  valid_580431 = validateParameter(valid_580431, JString, required = false,
                                 default = nil)
  if valid_580431 != nil:
    section.add "fields", valid_580431
  var valid_580432 = query.getOrDefault("quotaUser")
  valid_580432 = validateParameter(valid_580432, JString, required = false,
                                 default = nil)
  if valid_580432 != nil:
    section.add "quotaUser", valid_580432
  var valid_580433 = query.getOrDefault("alt")
  valid_580433 = validateParameter(valid_580433, JString, required = false,
                                 default = newJString("json"))
  if valid_580433 != nil:
    section.add "alt", valid_580433
  var valid_580434 = query.getOrDefault("oauth_token")
  valid_580434 = validateParameter(valid_580434, JString, required = false,
                                 default = nil)
  if valid_580434 != nil:
    section.add "oauth_token", valid_580434
  var valid_580435 = query.getOrDefault("userIp")
  valid_580435 = validateParameter(valid_580435, JString, required = false,
                                 default = nil)
  if valid_580435 != nil:
    section.add "userIp", valid_580435
  var valid_580436 = query.getOrDefault("key")
  valid_580436 = validateParameter(valid_580436, JString, required = false,
                                 default = nil)
  if valid_580436 != nil:
    section.add "key", valid_580436
  var valid_580437 = query.getOrDefault("prettyPrint")
  valid_580437 = validateParameter(valid_580437, JBool, required = false,
                                 default = newJBool(true))
  if valid_580437 != nil:
    section.add "prettyPrint", valid_580437
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

proc call*(call_580439: Call_BigqueryJobsInsert_580427; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a new asynchronous job. Requires the Can View project role.
  ## 
  let valid = call_580439.validator(path, query, header, formData, body)
  let scheme = call_580439.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580439.url(scheme.get, call_580439.host, call_580439.base,
                         call_580439.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580439, url, valid)

proc call*(call_580440: Call_BigqueryJobsInsert_580427; projectId: string;
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
  var path_580441 = newJObject()
  var query_580442 = newJObject()
  var body_580443 = newJObject()
  add(query_580442, "fields", newJString(fields))
  add(query_580442, "quotaUser", newJString(quotaUser))
  add(query_580442, "alt", newJString(alt))
  add(query_580442, "oauth_token", newJString(oauthToken))
  add(query_580442, "userIp", newJString(userIp))
  add(query_580442, "key", newJString(key))
  add(path_580441, "projectId", newJString(projectId))
  if body != nil:
    body_580443 = body
  add(query_580442, "prettyPrint", newJBool(prettyPrint))
  result = call_580440.call(path_580441, query_580442, nil, nil, body_580443)

var bigqueryJobsInsert* = Call_BigqueryJobsInsert_580427(
    name: "bigqueryJobsInsert", meth: HttpMethod.HttpPost,
    host: "bigquery.googleapis.com", route: "/projects/{projectId}/jobs",
    validator: validate_BigqueryJobsInsert_580428, base: "/bigquery/v2",
    url: url_BigqueryJobsInsert_580429, schemes: {Scheme.Https})
type
  Call_BigqueryJobsList_580404 = ref object of OpenApiRestCall_579437
proc url_BigqueryJobsList_580406(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryJobsList_580405(path: JsonNode; query: JsonNode;
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
  var valid_580407 = path.getOrDefault("projectId")
  valid_580407 = validateParameter(valid_580407, JString, required = true,
                                 default = nil)
  if valid_580407 != nil:
    section.add "projectId", valid_580407
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
  var valid_580408 = query.getOrDefault("fields")
  valid_580408 = validateParameter(valid_580408, JString, required = false,
                                 default = nil)
  if valid_580408 != nil:
    section.add "fields", valid_580408
  var valid_580409 = query.getOrDefault("pageToken")
  valid_580409 = validateParameter(valid_580409, JString, required = false,
                                 default = nil)
  if valid_580409 != nil:
    section.add "pageToken", valid_580409
  var valid_580410 = query.getOrDefault("quotaUser")
  valid_580410 = validateParameter(valid_580410, JString, required = false,
                                 default = nil)
  if valid_580410 != nil:
    section.add "quotaUser", valid_580410
  var valid_580411 = query.getOrDefault("alt")
  valid_580411 = validateParameter(valid_580411, JString, required = false,
                                 default = newJString("json"))
  if valid_580411 != nil:
    section.add "alt", valid_580411
  var valid_580412 = query.getOrDefault("parentJobId")
  valid_580412 = validateParameter(valid_580412, JString, required = false,
                                 default = nil)
  if valid_580412 != nil:
    section.add "parentJobId", valid_580412
  var valid_580413 = query.getOrDefault("oauth_token")
  valid_580413 = validateParameter(valid_580413, JString, required = false,
                                 default = nil)
  if valid_580413 != nil:
    section.add "oauth_token", valid_580413
  var valid_580414 = query.getOrDefault("userIp")
  valid_580414 = validateParameter(valid_580414, JString, required = false,
                                 default = nil)
  if valid_580414 != nil:
    section.add "userIp", valid_580414
  var valid_580415 = query.getOrDefault("maxResults")
  valid_580415 = validateParameter(valid_580415, JInt, required = false, default = nil)
  if valid_580415 != nil:
    section.add "maxResults", valid_580415
  var valid_580416 = query.getOrDefault("key")
  valid_580416 = validateParameter(valid_580416, JString, required = false,
                                 default = nil)
  if valid_580416 != nil:
    section.add "key", valid_580416
  var valid_580417 = query.getOrDefault("allUsers")
  valid_580417 = validateParameter(valid_580417, JBool, required = false, default = nil)
  if valid_580417 != nil:
    section.add "allUsers", valid_580417
  var valid_580418 = query.getOrDefault("projection")
  valid_580418 = validateParameter(valid_580418, JString, required = false,
                                 default = newJString("full"))
  if valid_580418 != nil:
    section.add "projection", valid_580418
  var valid_580419 = query.getOrDefault("minCreationTime")
  valid_580419 = validateParameter(valid_580419, JString, required = false,
                                 default = nil)
  if valid_580419 != nil:
    section.add "minCreationTime", valid_580419
  var valid_580420 = query.getOrDefault("maxCreationTime")
  valid_580420 = validateParameter(valid_580420, JString, required = false,
                                 default = nil)
  if valid_580420 != nil:
    section.add "maxCreationTime", valid_580420
  var valid_580421 = query.getOrDefault("prettyPrint")
  valid_580421 = validateParameter(valid_580421, JBool, required = false,
                                 default = newJBool(true))
  if valid_580421 != nil:
    section.add "prettyPrint", valid_580421
  var valid_580422 = query.getOrDefault("stateFilter")
  valid_580422 = validateParameter(valid_580422, JArray, required = false,
                                 default = nil)
  if valid_580422 != nil:
    section.add "stateFilter", valid_580422
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580423: Call_BigqueryJobsList_580404; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all jobs that you started in the specified project. Job information is available for a six month period after creation. The job list is sorted in reverse chronological order, by job creation time. Requires the Can View project role, or the Is Owner project role if you set the allUsers property.
  ## 
  let valid = call_580423.validator(path, query, header, formData, body)
  let scheme = call_580423.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580423.url(scheme.get, call_580423.host, call_580423.base,
                         call_580423.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580423, url, valid)

proc call*(call_580424: Call_BigqueryJobsList_580404; projectId: string;
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
  var path_580425 = newJObject()
  var query_580426 = newJObject()
  add(query_580426, "fields", newJString(fields))
  add(query_580426, "pageToken", newJString(pageToken))
  add(query_580426, "quotaUser", newJString(quotaUser))
  add(query_580426, "alt", newJString(alt))
  add(query_580426, "parentJobId", newJString(parentJobId))
  add(query_580426, "oauth_token", newJString(oauthToken))
  add(query_580426, "userIp", newJString(userIp))
  add(query_580426, "maxResults", newJInt(maxResults))
  add(query_580426, "key", newJString(key))
  add(query_580426, "allUsers", newJBool(allUsers))
  add(path_580425, "projectId", newJString(projectId))
  add(query_580426, "projection", newJString(projection))
  add(query_580426, "minCreationTime", newJString(minCreationTime))
  add(query_580426, "maxCreationTime", newJString(maxCreationTime))
  add(query_580426, "prettyPrint", newJBool(prettyPrint))
  if stateFilter != nil:
    query_580426.add "stateFilter", stateFilter
  result = call_580424.call(path_580425, query_580426, nil, nil, nil)

var bigqueryJobsList* = Call_BigqueryJobsList_580404(name: "bigqueryJobsList",
    meth: HttpMethod.HttpGet, host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/jobs", validator: validate_BigqueryJobsList_580405,
    base: "/bigquery/v2", url: url_BigqueryJobsList_580406, schemes: {Scheme.Https})
type
  Call_BigqueryJobsGet_580444 = ref object of OpenApiRestCall_579437
proc url_BigqueryJobsGet_580446(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryJobsGet_580445(path: JsonNode; query: JsonNode;
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
  var valid_580447 = path.getOrDefault("jobId")
  valid_580447 = validateParameter(valid_580447, JString, required = true,
                                 default = nil)
  if valid_580447 != nil:
    section.add "jobId", valid_580447
  var valid_580448 = path.getOrDefault("projectId")
  valid_580448 = validateParameter(valid_580448, JString, required = true,
                                 default = nil)
  if valid_580448 != nil:
    section.add "projectId", valid_580448
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
  var valid_580449 = query.getOrDefault("fields")
  valid_580449 = validateParameter(valid_580449, JString, required = false,
                                 default = nil)
  if valid_580449 != nil:
    section.add "fields", valid_580449
  var valid_580450 = query.getOrDefault("quotaUser")
  valid_580450 = validateParameter(valid_580450, JString, required = false,
                                 default = nil)
  if valid_580450 != nil:
    section.add "quotaUser", valid_580450
  var valid_580451 = query.getOrDefault("alt")
  valid_580451 = validateParameter(valid_580451, JString, required = false,
                                 default = newJString("json"))
  if valid_580451 != nil:
    section.add "alt", valid_580451
  var valid_580452 = query.getOrDefault("oauth_token")
  valid_580452 = validateParameter(valid_580452, JString, required = false,
                                 default = nil)
  if valid_580452 != nil:
    section.add "oauth_token", valid_580452
  var valid_580453 = query.getOrDefault("userIp")
  valid_580453 = validateParameter(valid_580453, JString, required = false,
                                 default = nil)
  if valid_580453 != nil:
    section.add "userIp", valid_580453
  var valid_580454 = query.getOrDefault("location")
  valid_580454 = validateParameter(valid_580454, JString, required = false,
                                 default = nil)
  if valid_580454 != nil:
    section.add "location", valid_580454
  var valid_580455 = query.getOrDefault("key")
  valid_580455 = validateParameter(valid_580455, JString, required = false,
                                 default = nil)
  if valid_580455 != nil:
    section.add "key", valid_580455
  var valid_580456 = query.getOrDefault("prettyPrint")
  valid_580456 = validateParameter(valid_580456, JBool, required = false,
                                 default = newJBool(true))
  if valid_580456 != nil:
    section.add "prettyPrint", valid_580456
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580457: Call_BigqueryJobsGet_580444; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns information about a specific job. Job information is available for a six month period after creation. Requires that you're the person who ran the job, or have the Is Owner project role.
  ## 
  let valid = call_580457.validator(path, query, header, formData, body)
  let scheme = call_580457.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580457.url(scheme.get, call_580457.host, call_580457.base,
                         call_580457.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580457, url, valid)

proc call*(call_580458: Call_BigqueryJobsGet_580444; jobId: string;
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
  var path_580459 = newJObject()
  var query_580460 = newJObject()
  add(query_580460, "fields", newJString(fields))
  add(query_580460, "quotaUser", newJString(quotaUser))
  add(query_580460, "alt", newJString(alt))
  add(path_580459, "jobId", newJString(jobId))
  add(query_580460, "oauth_token", newJString(oauthToken))
  add(query_580460, "userIp", newJString(userIp))
  add(query_580460, "location", newJString(location))
  add(query_580460, "key", newJString(key))
  add(path_580459, "projectId", newJString(projectId))
  add(query_580460, "prettyPrint", newJBool(prettyPrint))
  result = call_580458.call(path_580459, query_580460, nil, nil, nil)

var bigqueryJobsGet* = Call_BigqueryJobsGet_580444(name: "bigqueryJobsGet",
    meth: HttpMethod.HttpGet, host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/jobs/{jobId}",
    validator: validate_BigqueryJobsGet_580445, base: "/bigquery/v2",
    url: url_BigqueryJobsGet_580446, schemes: {Scheme.Https})
type
  Call_BigqueryJobsCancel_580461 = ref object of OpenApiRestCall_579437
proc url_BigqueryJobsCancel_580463(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryJobsCancel_580462(path: JsonNode; query: JsonNode;
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
  var valid_580464 = path.getOrDefault("jobId")
  valid_580464 = validateParameter(valid_580464, JString, required = true,
                                 default = nil)
  if valid_580464 != nil:
    section.add "jobId", valid_580464
  var valid_580465 = path.getOrDefault("projectId")
  valid_580465 = validateParameter(valid_580465, JString, required = true,
                                 default = nil)
  if valid_580465 != nil:
    section.add "projectId", valid_580465
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
  var valid_580466 = query.getOrDefault("fields")
  valid_580466 = validateParameter(valid_580466, JString, required = false,
                                 default = nil)
  if valid_580466 != nil:
    section.add "fields", valid_580466
  var valid_580467 = query.getOrDefault("quotaUser")
  valid_580467 = validateParameter(valid_580467, JString, required = false,
                                 default = nil)
  if valid_580467 != nil:
    section.add "quotaUser", valid_580467
  var valid_580468 = query.getOrDefault("alt")
  valid_580468 = validateParameter(valid_580468, JString, required = false,
                                 default = newJString("json"))
  if valid_580468 != nil:
    section.add "alt", valid_580468
  var valid_580469 = query.getOrDefault("oauth_token")
  valid_580469 = validateParameter(valid_580469, JString, required = false,
                                 default = nil)
  if valid_580469 != nil:
    section.add "oauth_token", valid_580469
  var valid_580470 = query.getOrDefault("userIp")
  valid_580470 = validateParameter(valid_580470, JString, required = false,
                                 default = nil)
  if valid_580470 != nil:
    section.add "userIp", valid_580470
  var valid_580471 = query.getOrDefault("location")
  valid_580471 = validateParameter(valid_580471, JString, required = false,
                                 default = nil)
  if valid_580471 != nil:
    section.add "location", valid_580471
  var valid_580472 = query.getOrDefault("key")
  valid_580472 = validateParameter(valid_580472, JString, required = false,
                                 default = nil)
  if valid_580472 != nil:
    section.add "key", valid_580472
  var valid_580473 = query.getOrDefault("prettyPrint")
  valid_580473 = validateParameter(valid_580473, JBool, required = false,
                                 default = newJBool(true))
  if valid_580473 != nil:
    section.add "prettyPrint", valid_580473
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580474: Call_BigqueryJobsCancel_580461; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Requests that a job be cancelled. This call will return immediately, and the client will need to poll for the job status to see if the cancel completed successfully. Cancelled jobs may still incur costs.
  ## 
  let valid = call_580474.validator(path, query, header, formData, body)
  let scheme = call_580474.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580474.url(scheme.get, call_580474.host, call_580474.base,
                         call_580474.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580474, url, valid)

proc call*(call_580475: Call_BigqueryJobsCancel_580461; jobId: string;
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
  var path_580476 = newJObject()
  var query_580477 = newJObject()
  add(query_580477, "fields", newJString(fields))
  add(query_580477, "quotaUser", newJString(quotaUser))
  add(query_580477, "alt", newJString(alt))
  add(path_580476, "jobId", newJString(jobId))
  add(query_580477, "oauth_token", newJString(oauthToken))
  add(query_580477, "userIp", newJString(userIp))
  add(query_580477, "location", newJString(location))
  add(query_580477, "key", newJString(key))
  add(path_580476, "projectId", newJString(projectId))
  add(query_580477, "prettyPrint", newJBool(prettyPrint))
  result = call_580475.call(path_580476, query_580477, nil, nil, nil)

var bigqueryJobsCancel* = Call_BigqueryJobsCancel_580461(
    name: "bigqueryJobsCancel", meth: HttpMethod.HttpPost,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/jobs/{jobId}/cancel",
    validator: validate_BigqueryJobsCancel_580462, base: "/bigquery/v2",
    url: url_BigqueryJobsCancel_580463, schemes: {Scheme.Https})
type
  Call_BigqueryJobsQuery_580478 = ref object of OpenApiRestCall_579437
proc url_BigqueryJobsQuery_580480(protocol: Scheme; host: string; base: string;
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

proc validate_BigqueryJobsQuery_580479(path: JsonNode; query: JsonNode;
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
  var valid_580481 = path.getOrDefault("projectId")
  valid_580481 = validateParameter(valid_580481, JString, required = true,
                                 default = nil)
  if valid_580481 != nil:
    section.add "projectId", valid_580481
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
  var valid_580482 = query.getOrDefault("fields")
  valid_580482 = validateParameter(valid_580482, JString, required = false,
                                 default = nil)
  if valid_580482 != nil:
    section.add "fields", valid_580482
  var valid_580483 = query.getOrDefault("quotaUser")
  valid_580483 = validateParameter(valid_580483, JString, required = false,
                                 default = nil)
  if valid_580483 != nil:
    section.add "quotaUser", valid_580483
  var valid_580484 = query.getOrDefault("alt")
  valid_580484 = validateParameter(valid_580484, JString, required = false,
                                 default = newJString("json"))
  if valid_580484 != nil:
    section.add "alt", valid_580484
  var valid_580485 = query.getOrDefault("oauth_token")
  valid_580485 = validateParameter(valid_580485, JString, required = false,
                                 default = nil)
  if valid_580485 != nil:
    section.add "oauth_token", valid_580485
  var valid_580486 = query.getOrDefault("userIp")
  valid_580486 = validateParameter(valid_580486, JString, required = false,
                                 default = nil)
  if valid_580486 != nil:
    section.add "userIp", valid_580486
  var valid_580487 = query.getOrDefault("key")
  valid_580487 = validateParameter(valid_580487, JString, required = false,
                                 default = nil)
  if valid_580487 != nil:
    section.add "key", valid_580487
  var valid_580488 = query.getOrDefault("prettyPrint")
  valid_580488 = validateParameter(valid_580488, JBool, required = false,
                                 default = newJBool(true))
  if valid_580488 != nil:
    section.add "prettyPrint", valid_580488
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

proc call*(call_580490: Call_BigqueryJobsQuery_580478; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Runs a BigQuery SQL query synchronously and returns query results if the query completes within a specified timeout.
  ## 
  let valid = call_580490.validator(path, query, header, formData, body)
  let scheme = call_580490.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580490.url(scheme.get, call_580490.host, call_580490.base,
                         call_580490.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580490, url, valid)

proc call*(call_580491: Call_BigqueryJobsQuery_580478; projectId: string;
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
  var path_580492 = newJObject()
  var query_580493 = newJObject()
  var body_580494 = newJObject()
  add(query_580493, "fields", newJString(fields))
  add(query_580493, "quotaUser", newJString(quotaUser))
  add(query_580493, "alt", newJString(alt))
  add(query_580493, "oauth_token", newJString(oauthToken))
  add(query_580493, "userIp", newJString(userIp))
  add(query_580493, "key", newJString(key))
  add(path_580492, "projectId", newJString(projectId))
  if body != nil:
    body_580494 = body
  add(query_580493, "prettyPrint", newJBool(prettyPrint))
  result = call_580491.call(path_580492, query_580493, nil, nil, body_580494)

var bigqueryJobsQuery* = Call_BigqueryJobsQuery_580478(name: "bigqueryJobsQuery",
    meth: HttpMethod.HttpPost, host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/queries", validator: validate_BigqueryJobsQuery_580479,
    base: "/bigquery/v2", url: url_BigqueryJobsQuery_580480, schemes: {Scheme.Https})
type
  Call_BigqueryJobsGetQueryResults_580495 = ref object of OpenApiRestCall_579437
proc url_BigqueryJobsGetQueryResults_580497(protocol: Scheme; host: string;
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

proc validate_BigqueryJobsGetQueryResults_580496(path: JsonNode; query: JsonNode;
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
  var valid_580498 = path.getOrDefault("jobId")
  valid_580498 = validateParameter(valid_580498, JString, required = true,
                                 default = nil)
  if valid_580498 != nil:
    section.add "jobId", valid_580498
  var valid_580499 = path.getOrDefault("projectId")
  valid_580499 = validateParameter(valid_580499, JString, required = true,
                                 default = nil)
  if valid_580499 != nil:
    section.add "projectId", valid_580499
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
  var valid_580500 = query.getOrDefault("fields")
  valid_580500 = validateParameter(valid_580500, JString, required = false,
                                 default = nil)
  if valid_580500 != nil:
    section.add "fields", valid_580500
  var valid_580501 = query.getOrDefault("pageToken")
  valid_580501 = validateParameter(valid_580501, JString, required = false,
                                 default = nil)
  if valid_580501 != nil:
    section.add "pageToken", valid_580501
  var valid_580502 = query.getOrDefault("quotaUser")
  valid_580502 = validateParameter(valid_580502, JString, required = false,
                                 default = nil)
  if valid_580502 != nil:
    section.add "quotaUser", valid_580502
  var valid_580503 = query.getOrDefault("alt")
  valid_580503 = validateParameter(valid_580503, JString, required = false,
                                 default = newJString("json"))
  if valid_580503 != nil:
    section.add "alt", valid_580503
  var valid_580504 = query.getOrDefault("oauth_token")
  valid_580504 = validateParameter(valid_580504, JString, required = false,
                                 default = nil)
  if valid_580504 != nil:
    section.add "oauth_token", valid_580504
  var valid_580505 = query.getOrDefault("userIp")
  valid_580505 = validateParameter(valid_580505, JString, required = false,
                                 default = nil)
  if valid_580505 != nil:
    section.add "userIp", valid_580505
  var valid_580506 = query.getOrDefault("location")
  valid_580506 = validateParameter(valid_580506, JString, required = false,
                                 default = nil)
  if valid_580506 != nil:
    section.add "location", valid_580506
  var valid_580507 = query.getOrDefault("maxResults")
  valid_580507 = validateParameter(valid_580507, JInt, required = false, default = nil)
  if valid_580507 != nil:
    section.add "maxResults", valid_580507
  var valid_580508 = query.getOrDefault("timeoutMs")
  valid_580508 = validateParameter(valid_580508, JInt, required = false, default = nil)
  if valid_580508 != nil:
    section.add "timeoutMs", valid_580508
  var valid_580509 = query.getOrDefault("key")
  valid_580509 = validateParameter(valid_580509, JString, required = false,
                                 default = nil)
  if valid_580509 != nil:
    section.add "key", valid_580509
  var valid_580510 = query.getOrDefault("prettyPrint")
  valid_580510 = validateParameter(valid_580510, JBool, required = false,
                                 default = newJBool(true))
  if valid_580510 != nil:
    section.add "prettyPrint", valid_580510
  var valid_580511 = query.getOrDefault("startIndex")
  valid_580511 = validateParameter(valid_580511, JString, required = false,
                                 default = nil)
  if valid_580511 != nil:
    section.add "startIndex", valid_580511
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580512: Call_BigqueryJobsGetQueryResults_580495; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the results of a query job.
  ## 
  let valid = call_580512.validator(path, query, header, formData, body)
  let scheme = call_580512.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580512.url(scheme.get, call_580512.host, call_580512.base,
                         call_580512.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580512, url, valid)

proc call*(call_580513: Call_BigqueryJobsGetQueryResults_580495; jobId: string;
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
  var path_580514 = newJObject()
  var query_580515 = newJObject()
  add(query_580515, "fields", newJString(fields))
  add(query_580515, "pageToken", newJString(pageToken))
  add(query_580515, "quotaUser", newJString(quotaUser))
  add(query_580515, "alt", newJString(alt))
  add(path_580514, "jobId", newJString(jobId))
  add(query_580515, "oauth_token", newJString(oauthToken))
  add(query_580515, "userIp", newJString(userIp))
  add(query_580515, "location", newJString(location))
  add(query_580515, "maxResults", newJInt(maxResults))
  add(query_580515, "timeoutMs", newJInt(timeoutMs))
  add(query_580515, "key", newJString(key))
  add(path_580514, "projectId", newJString(projectId))
  add(query_580515, "prettyPrint", newJBool(prettyPrint))
  add(query_580515, "startIndex", newJString(startIndex))
  result = call_580513.call(path_580514, query_580515, nil, nil, nil)

var bigqueryJobsGetQueryResults* = Call_BigqueryJobsGetQueryResults_580495(
    name: "bigqueryJobsGetQueryResults", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/queries/{jobId}",
    validator: validate_BigqueryJobsGetQueryResults_580496, base: "/bigquery/v2",
    url: url_BigqueryJobsGetQueryResults_580497, schemes: {Scheme.Https})
type
  Call_BigqueryProjectsGetServiceAccount_580516 = ref object of OpenApiRestCall_579437
proc url_BigqueryProjectsGetServiceAccount_580518(protocol: Scheme; host: string;
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

proc validate_BigqueryProjectsGetServiceAccount_580517(path: JsonNode;
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
  var valid_580519 = path.getOrDefault("projectId")
  valid_580519 = validateParameter(valid_580519, JString, required = true,
                                 default = nil)
  if valid_580519 != nil:
    section.add "projectId", valid_580519
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
  var valid_580520 = query.getOrDefault("fields")
  valid_580520 = validateParameter(valid_580520, JString, required = false,
                                 default = nil)
  if valid_580520 != nil:
    section.add "fields", valid_580520
  var valid_580521 = query.getOrDefault("quotaUser")
  valid_580521 = validateParameter(valid_580521, JString, required = false,
                                 default = nil)
  if valid_580521 != nil:
    section.add "quotaUser", valid_580521
  var valid_580522 = query.getOrDefault("alt")
  valid_580522 = validateParameter(valid_580522, JString, required = false,
                                 default = newJString("json"))
  if valid_580522 != nil:
    section.add "alt", valid_580522
  var valid_580523 = query.getOrDefault("oauth_token")
  valid_580523 = validateParameter(valid_580523, JString, required = false,
                                 default = nil)
  if valid_580523 != nil:
    section.add "oauth_token", valid_580523
  var valid_580524 = query.getOrDefault("userIp")
  valid_580524 = validateParameter(valid_580524, JString, required = false,
                                 default = nil)
  if valid_580524 != nil:
    section.add "userIp", valid_580524
  var valid_580525 = query.getOrDefault("key")
  valid_580525 = validateParameter(valid_580525, JString, required = false,
                                 default = nil)
  if valid_580525 != nil:
    section.add "key", valid_580525
  var valid_580526 = query.getOrDefault("prettyPrint")
  valid_580526 = validateParameter(valid_580526, JBool, required = false,
                                 default = newJBool(true))
  if valid_580526 != nil:
    section.add "prettyPrint", valid_580526
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580527: Call_BigqueryProjectsGetServiceAccount_580516;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the email address of the service account for your project used for interactions with Google Cloud KMS.
  ## 
  let valid = call_580527.validator(path, query, header, formData, body)
  let scheme = call_580527.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580527.url(scheme.get, call_580527.host, call_580527.base,
                         call_580527.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580527, url, valid)

proc call*(call_580528: Call_BigqueryProjectsGetServiceAccount_580516;
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
  var path_580529 = newJObject()
  var query_580530 = newJObject()
  add(query_580530, "fields", newJString(fields))
  add(query_580530, "quotaUser", newJString(quotaUser))
  add(query_580530, "alt", newJString(alt))
  add(query_580530, "oauth_token", newJString(oauthToken))
  add(query_580530, "userIp", newJString(userIp))
  add(query_580530, "key", newJString(key))
  add(path_580529, "projectId", newJString(projectId))
  add(query_580530, "prettyPrint", newJBool(prettyPrint))
  result = call_580528.call(path_580529, query_580530, nil, nil, nil)

var bigqueryProjectsGetServiceAccount* = Call_BigqueryProjectsGetServiceAccount_580516(
    name: "bigqueryProjectsGetServiceAccount", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/serviceAccount",
    validator: validate_BigqueryProjectsGetServiceAccount_580517,
    base: "/bigquery/v2", url: url_BigqueryProjectsGetServiceAccount_580518,
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
