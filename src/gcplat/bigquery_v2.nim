
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_597437 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597437](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597437): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BigqueryProjectsList_597705 = ref object of OpenApiRestCall_597437
proc url_BigqueryProjectsList_597707(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_BigqueryProjectsList_597706(path: JsonNode; query: JsonNode;
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
  var valid_597819 = query.getOrDefault("fields")
  valid_597819 = validateParameter(valid_597819, JString, required = false,
                                 default = nil)
  if valid_597819 != nil:
    section.add "fields", valid_597819
  var valid_597820 = query.getOrDefault("pageToken")
  valid_597820 = validateParameter(valid_597820, JString, required = false,
                                 default = nil)
  if valid_597820 != nil:
    section.add "pageToken", valid_597820
  var valid_597821 = query.getOrDefault("quotaUser")
  valid_597821 = validateParameter(valid_597821, JString, required = false,
                                 default = nil)
  if valid_597821 != nil:
    section.add "quotaUser", valid_597821
  var valid_597835 = query.getOrDefault("alt")
  valid_597835 = validateParameter(valid_597835, JString, required = false,
                                 default = newJString("json"))
  if valid_597835 != nil:
    section.add "alt", valid_597835
  var valid_597836 = query.getOrDefault("oauth_token")
  valid_597836 = validateParameter(valid_597836, JString, required = false,
                                 default = nil)
  if valid_597836 != nil:
    section.add "oauth_token", valid_597836
  var valid_597837 = query.getOrDefault("userIp")
  valid_597837 = validateParameter(valid_597837, JString, required = false,
                                 default = nil)
  if valid_597837 != nil:
    section.add "userIp", valid_597837
  var valid_597838 = query.getOrDefault("maxResults")
  valid_597838 = validateParameter(valid_597838, JInt, required = false, default = nil)
  if valid_597838 != nil:
    section.add "maxResults", valid_597838
  var valid_597839 = query.getOrDefault("key")
  valid_597839 = validateParameter(valid_597839, JString, required = false,
                                 default = nil)
  if valid_597839 != nil:
    section.add "key", valid_597839
  var valid_597840 = query.getOrDefault("prettyPrint")
  valid_597840 = validateParameter(valid_597840, JBool, required = false,
                                 default = newJBool(true))
  if valid_597840 != nil:
    section.add "prettyPrint", valid_597840
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597863: Call_BigqueryProjectsList_597705; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all projects to which you have been granted any project role.
  ## 
  let valid = call_597863.validator(path, query, header, formData, body)
  let scheme = call_597863.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597863.url(scheme.get, call_597863.host, call_597863.base,
                         call_597863.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597863, url, valid)

proc call*(call_597934: Call_BigqueryProjectsList_597705; fields: string = "";
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
  var query_597935 = newJObject()
  add(query_597935, "fields", newJString(fields))
  add(query_597935, "pageToken", newJString(pageToken))
  add(query_597935, "quotaUser", newJString(quotaUser))
  add(query_597935, "alt", newJString(alt))
  add(query_597935, "oauth_token", newJString(oauthToken))
  add(query_597935, "userIp", newJString(userIp))
  add(query_597935, "maxResults", newJInt(maxResults))
  add(query_597935, "key", newJString(key))
  add(query_597935, "prettyPrint", newJBool(prettyPrint))
  result = call_597934.call(nil, query_597935, nil, nil, nil)

var bigqueryProjectsList* = Call_BigqueryProjectsList_597705(
    name: "bigqueryProjectsList", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com", route: "/projects",
    validator: validate_BigqueryProjectsList_597706, base: "/bigquery/v2",
    url: url_BigqueryProjectsList_597707, schemes: {Scheme.Https})
type
  Call_BigqueryDatasetsInsert_598008 = ref object of OpenApiRestCall_597437
proc url_BigqueryDatasetsInsert_598010(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigqueryDatasetsInsert_598009(path: JsonNode; query: JsonNode;
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
  var valid_598011 = path.getOrDefault("projectId")
  valid_598011 = validateParameter(valid_598011, JString, required = true,
                                 default = nil)
  if valid_598011 != nil:
    section.add "projectId", valid_598011
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
  var valid_598012 = query.getOrDefault("fields")
  valid_598012 = validateParameter(valid_598012, JString, required = false,
                                 default = nil)
  if valid_598012 != nil:
    section.add "fields", valid_598012
  var valid_598013 = query.getOrDefault("quotaUser")
  valid_598013 = validateParameter(valid_598013, JString, required = false,
                                 default = nil)
  if valid_598013 != nil:
    section.add "quotaUser", valid_598013
  var valid_598014 = query.getOrDefault("alt")
  valid_598014 = validateParameter(valid_598014, JString, required = false,
                                 default = newJString("json"))
  if valid_598014 != nil:
    section.add "alt", valid_598014
  var valid_598015 = query.getOrDefault("oauth_token")
  valid_598015 = validateParameter(valid_598015, JString, required = false,
                                 default = nil)
  if valid_598015 != nil:
    section.add "oauth_token", valid_598015
  var valid_598016 = query.getOrDefault("userIp")
  valid_598016 = validateParameter(valid_598016, JString, required = false,
                                 default = nil)
  if valid_598016 != nil:
    section.add "userIp", valid_598016
  var valid_598017 = query.getOrDefault("key")
  valid_598017 = validateParameter(valid_598017, JString, required = false,
                                 default = nil)
  if valid_598017 != nil:
    section.add "key", valid_598017
  var valid_598018 = query.getOrDefault("prettyPrint")
  valid_598018 = validateParameter(valid_598018, JBool, required = false,
                                 default = newJBool(true))
  if valid_598018 != nil:
    section.add "prettyPrint", valid_598018
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

proc call*(call_598020: Call_BigqueryDatasetsInsert_598008; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new empty dataset.
  ## 
  let valid = call_598020.validator(path, query, header, formData, body)
  let scheme = call_598020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598020.url(scheme.get, call_598020.host, call_598020.base,
                         call_598020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598020, url, valid)

proc call*(call_598021: Call_BigqueryDatasetsInsert_598008; projectId: string;
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
  var path_598022 = newJObject()
  var query_598023 = newJObject()
  var body_598024 = newJObject()
  add(query_598023, "fields", newJString(fields))
  add(query_598023, "quotaUser", newJString(quotaUser))
  add(query_598023, "alt", newJString(alt))
  add(query_598023, "oauth_token", newJString(oauthToken))
  add(query_598023, "userIp", newJString(userIp))
  add(query_598023, "key", newJString(key))
  add(path_598022, "projectId", newJString(projectId))
  if body != nil:
    body_598024 = body
  add(query_598023, "prettyPrint", newJBool(prettyPrint))
  result = call_598021.call(path_598022, query_598023, nil, nil, body_598024)

var bigqueryDatasetsInsert* = Call_BigqueryDatasetsInsert_598008(
    name: "bigqueryDatasetsInsert", meth: HttpMethod.HttpPost,
    host: "bigquery.googleapis.com", route: "/projects/{projectId}/datasets",
    validator: validate_BigqueryDatasetsInsert_598009, base: "/bigquery/v2",
    url: url_BigqueryDatasetsInsert_598010, schemes: {Scheme.Https})
type
  Call_BigqueryDatasetsList_597975 = ref object of OpenApiRestCall_597437
proc url_BigqueryDatasetsList_597977(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigqueryDatasetsList_597976(path: JsonNode; query: JsonNode;
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
  var valid_597992 = path.getOrDefault("projectId")
  valid_597992 = validateParameter(valid_597992, JString, required = true,
                                 default = nil)
  if valid_597992 != nil:
    section.add "projectId", valid_597992
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
  var valid_597993 = query.getOrDefault("fields")
  valid_597993 = validateParameter(valid_597993, JString, required = false,
                                 default = nil)
  if valid_597993 != nil:
    section.add "fields", valid_597993
  var valid_597994 = query.getOrDefault("pageToken")
  valid_597994 = validateParameter(valid_597994, JString, required = false,
                                 default = nil)
  if valid_597994 != nil:
    section.add "pageToken", valid_597994
  var valid_597995 = query.getOrDefault("quotaUser")
  valid_597995 = validateParameter(valid_597995, JString, required = false,
                                 default = nil)
  if valid_597995 != nil:
    section.add "quotaUser", valid_597995
  var valid_597996 = query.getOrDefault("alt")
  valid_597996 = validateParameter(valid_597996, JString, required = false,
                                 default = newJString("json"))
  if valid_597996 != nil:
    section.add "alt", valid_597996
  var valid_597997 = query.getOrDefault("oauth_token")
  valid_597997 = validateParameter(valid_597997, JString, required = false,
                                 default = nil)
  if valid_597997 != nil:
    section.add "oauth_token", valid_597997
  var valid_597998 = query.getOrDefault("userIp")
  valid_597998 = validateParameter(valid_597998, JString, required = false,
                                 default = nil)
  if valid_597998 != nil:
    section.add "userIp", valid_597998
  var valid_597999 = query.getOrDefault("all")
  valid_597999 = validateParameter(valid_597999, JBool, required = false, default = nil)
  if valid_597999 != nil:
    section.add "all", valid_597999
  var valid_598000 = query.getOrDefault("maxResults")
  valid_598000 = validateParameter(valid_598000, JInt, required = false, default = nil)
  if valid_598000 != nil:
    section.add "maxResults", valid_598000
  var valid_598001 = query.getOrDefault("key")
  valid_598001 = validateParameter(valid_598001, JString, required = false,
                                 default = nil)
  if valid_598001 != nil:
    section.add "key", valid_598001
  var valid_598002 = query.getOrDefault("prettyPrint")
  valid_598002 = validateParameter(valid_598002, JBool, required = false,
                                 default = newJBool(true))
  if valid_598002 != nil:
    section.add "prettyPrint", valid_598002
  var valid_598003 = query.getOrDefault("filter")
  valid_598003 = validateParameter(valid_598003, JString, required = false,
                                 default = nil)
  if valid_598003 != nil:
    section.add "filter", valid_598003
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598004: Call_BigqueryDatasetsList_597975; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all datasets in the specified project to which you have been granted the READER dataset role.
  ## 
  let valid = call_598004.validator(path, query, header, formData, body)
  let scheme = call_598004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598004.url(scheme.get, call_598004.host, call_598004.base,
                         call_598004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598004, url, valid)

proc call*(call_598005: Call_BigqueryDatasetsList_597975; projectId: string;
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
  var path_598006 = newJObject()
  var query_598007 = newJObject()
  add(query_598007, "fields", newJString(fields))
  add(query_598007, "pageToken", newJString(pageToken))
  add(query_598007, "quotaUser", newJString(quotaUser))
  add(query_598007, "alt", newJString(alt))
  add(query_598007, "oauth_token", newJString(oauthToken))
  add(query_598007, "userIp", newJString(userIp))
  add(query_598007, "all", newJBool(all))
  add(query_598007, "maxResults", newJInt(maxResults))
  add(query_598007, "key", newJString(key))
  add(path_598006, "projectId", newJString(projectId))
  add(query_598007, "prettyPrint", newJBool(prettyPrint))
  add(query_598007, "filter", newJString(filter))
  result = call_598005.call(path_598006, query_598007, nil, nil, nil)

var bigqueryDatasetsList* = Call_BigqueryDatasetsList_597975(
    name: "bigqueryDatasetsList", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com", route: "/projects/{projectId}/datasets",
    validator: validate_BigqueryDatasetsList_597976, base: "/bigquery/v2",
    url: url_BigqueryDatasetsList_597977, schemes: {Scheme.Https})
type
  Call_BigqueryDatasetsUpdate_598041 = ref object of OpenApiRestCall_597437
proc url_BigqueryDatasetsUpdate_598043(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigqueryDatasetsUpdate_598042(path: JsonNode; query: JsonNode;
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
  var valid_598044 = path.getOrDefault("datasetId")
  valid_598044 = validateParameter(valid_598044, JString, required = true,
                                 default = nil)
  if valid_598044 != nil:
    section.add "datasetId", valid_598044
  var valid_598045 = path.getOrDefault("projectId")
  valid_598045 = validateParameter(valid_598045, JString, required = true,
                                 default = nil)
  if valid_598045 != nil:
    section.add "projectId", valid_598045
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
  var valid_598046 = query.getOrDefault("fields")
  valid_598046 = validateParameter(valid_598046, JString, required = false,
                                 default = nil)
  if valid_598046 != nil:
    section.add "fields", valid_598046
  var valid_598047 = query.getOrDefault("quotaUser")
  valid_598047 = validateParameter(valid_598047, JString, required = false,
                                 default = nil)
  if valid_598047 != nil:
    section.add "quotaUser", valid_598047
  var valid_598048 = query.getOrDefault("alt")
  valid_598048 = validateParameter(valid_598048, JString, required = false,
                                 default = newJString("json"))
  if valid_598048 != nil:
    section.add "alt", valid_598048
  var valid_598049 = query.getOrDefault("oauth_token")
  valid_598049 = validateParameter(valid_598049, JString, required = false,
                                 default = nil)
  if valid_598049 != nil:
    section.add "oauth_token", valid_598049
  var valid_598050 = query.getOrDefault("userIp")
  valid_598050 = validateParameter(valid_598050, JString, required = false,
                                 default = nil)
  if valid_598050 != nil:
    section.add "userIp", valid_598050
  var valid_598051 = query.getOrDefault("key")
  valid_598051 = validateParameter(valid_598051, JString, required = false,
                                 default = nil)
  if valid_598051 != nil:
    section.add "key", valid_598051
  var valid_598052 = query.getOrDefault("prettyPrint")
  valid_598052 = validateParameter(valid_598052, JBool, required = false,
                                 default = newJBool(true))
  if valid_598052 != nil:
    section.add "prettyPrint", valid_598052
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

proc call*(call_598054: Call_BigqueryDatasetsUpdate_598041; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates information in an existing dataset. The update method replaces the entire dataset resource, whereas the patch method only replaces fields that are provided in the submitted dataset resource.
  ## 
  let valid = call_598054.validator(path, query, header, formData, body)
  let scheme = call_598054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598054.url(scheme.get, call_598054.host, call_598054.base,
                         call_598054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598054, url, valid)

proc call*(call_598055: Call_BigqueryDatasetsUpdate_598041; datasetId: string;
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
  var path_598056 = newJObject()
  var query_598057 = newJObject()
  var body_598058 = newJObject()
  add(query_598057, "fields", newJString(fields))
  add(query_598057, "quotaUser", newJString(quotaUser))
  add(query_598057, "alt", newJString(alt))
  add(query_598057, "oauth_token", newJString(oauthToken))
  add(query_598057, "userIp", newJString(userIp))
  add(path_598056, "datasetId", newJString(datasetId))
  add(query_598057, "key", newJString(key))
  add(path_598056, "projectId", newJString(projectId))
  if body != nil:
    body_598058 = body
  add(query_598057, "prettyPrint", newJBool(prettyPrint))
  result = call_598055.call(path_598056, query_598057, nil, nil, body_598058)

var bigqueryDatasetsUpdate* = Call_BigqueryDatasetsUpdate_598041(
    name: "bigqueryDatasetsUpdate", meth: HttpMethod.HttpPut,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}",
    validator: validate_BigqueryDatasetsUpdate_598042, base: "/bigquery/v2",
    url: url_BigqueryDatasetsUpdate_598043, schemes: {Scheme.Https})
type
  Call_BigqueryDatasetsGet_598025 = ref object of OpenApiRestCall_597437
proc url_BigqueryDatasetsGet_598027(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigqueryDatasetsGet_598026(path: JsonNode; query: JsonNode;
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
  var valid_598028 = path.getOrDefault("datasetId")
  valid_598028 = validateParameter(valid_598028, JString, required = true,
                                 default = nil)
  if valid_598028 != nil:
    section.add "datasetId", valid_598028
  var valid_598029 = path.getOrDefault("projectId")
  valid_598029 = validateParameter(valid_598029, JString, required = true,
                                 default = nil)
  if valid_598029 != nil:
    section.add "projectId", valid_598029
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
  var valid_598030 = query.getOrDefault("fields")
  valid_598030 = validateParameter(valid_598030, JString, required = false,
                                 default = nil)
  if valid_598030 != nil:
    section.add "fields", valid_598030
  var valid_598031 = query.getOrDefault("quotaUser")
  valid_598031 = validateParameter(valid_598031, JString, required = false,
                                 default = nil)
  if valid_598031 != nil:
    section.add "quotaUser", valid_598031
  var valid_598032 = query.getOrDefault("alt")
  valid_598032 = validateParameter(valid_598032, JString, required = false,
                                 default = newJString("json"))
  if valid_598032 != nil:
    section.add "alt", valid_598032
  var valid_598033 = query.getOrDefault("oauth_token")
  valid_598033 = validateParameter(valid_598033, JString, required = false,
                                 default = nil)
  if valid_598033 != nil:
    section.add "oauth_token", valid_598033
  var valid_598034 = query.getOrDefault("userIp")
  valid_598034 = validateParameter(valid_598034, JString, required = false,
                                 default = nil)
  if valid_598034 != nil:
    section.add "userIp", valid_598034
  var valid_598035 = query.getOrDefault("key")
  valid_598035 = validateParameter(valid_598035, JString, required = false,
                                 default = nil)
  if valid_598035 != nil:
    section.add "key", valid_598035
  var valid_598036 = query.getOrDefault("prettyPrint")
  valid_598036 = validateParameter(valid_598036, JBool, required = false,
                                 default = newJBool(true))
  if valid_598036 != nil:
    section.add "prettyPrint", valid_598036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598037: Call_BigqueryDatasetsGet_598025; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the dataset specified by datasetID.
  ## 
  let valid = call_598037.validator(path, query, header, formData, body)
  let scheme = call_598037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598037.url(scheme.get, call_598037.host, call_598037.base,
                         call_598037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598037, url, valid)

proc call*(call_598038: Call_BigqueryDatasetsGet_598025; datasetId: string;
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
  var path_598039 = newJObject()
  var query_598040 = newJObject()
  add(query_598040, "fields", newJString(fields))
  add(query_598040, "quotaUser", newJString(quotaUser))
  add(query_598040, "alt", newJString(alt))
  add(query_598040, "oauth_token", newJString(oauthToken))
  add(query_598040, "userIp", newJString(userIp))
  add(path_598039, "datasetId", newJString(datasetId))
  add(query_598040, "key", newJString(key))
  add(path_598039, "projectId", newJString(projectId))
  add(query_598040, "prettyPrint", newJBool(prettyPrint))
  result = call_598038.call(path_598039, query_598040, nil, nil, nil)

var bigqueryDatasetsGet* = Call_BigqueryDatasetsGet_598025(
    name: "bigqueryDatasetsGet", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}",
    validator: validate_BigqueryDatasetsGet_598026, base: "/bigquery/v2",
    url: url_BigqueryDatasetsGet_598027, schemes: {Scheme.Https})
type
  Call_BigqueryDatasetsPatch_598076 = ref object of OpenApiRestCall_597437
proc url_BigqueryDatasetsPatch_598078(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigqueryDatasetsPatch_598077(path: JsonNode; query: JsonNode;
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
  var valid_598079 = path.getOrDefault("datasetId")
  valid_598079 = validateParameter(valid_598079, JString, required = true,
                                 default = nil)
  if valid_598079 != nil:
    section.add "datasetId", valid_598079
  var valid_598080 = path.getOrDefault("projectId")
  valid_598080 = validateParameter(valid_598080, JString, required = true,
                                 default = nil)
  if valid_598080 != nil:
    section.add "projectId", valid_598080
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
  var valid_598081 = query.getOrDefault("fields")
  valid_598081 = validateParameter(valid_598081, JString, required = false,
                                 default = nil)
  if valid_598081 != nil:
    section.add "fields", valid_598081
  var valid_598082 = query.getOrDefault("quotaUser")
  valid_598082 = validateParameter(valid_598082, JString, required = false,
                                 default = nil)
  if valid_598082 != nil:
    section.add "quotaUser", valid_598082
  var valid_598083 = query.getOrDefault("alt")
  valid_598083 = validateParameter(valid_598083, JString, required = false,
                                 default = newJString("json"))
  if valid_598083 != nil:
    section.add "alt", valid_598083
  var valid_598084 = query.getOrDefault("oauth_token")
  valid_598084 = validateParameter(valid_598084, JString, required = false,
                                 default = nil)
  if valid_598084 != nil:
    section.add "oauth_token", valid_598084
  var valid_598085 = query.getOrDefault("userIp")
  valid_598085 = validateParameter(valid_598085, JString, required = false,
                                 default = nil)
  if valid_598085 != nil:
    section.add "userIp", valid_598085
  var valid_598086 = query.getOrDefault("key")
  valid_598086 = validateParameter(valid_598086, JString, required = false,
                                 default = nil)
  if valid_598086 != nil:
    section.add "key", valid_598086
  var valid_598087 = query.getOrDefault("prettyPrint")
  valid_598087 = validateParameter(valid_598087, JBool, required = false,
                                 default = newJBool(true))
  if valid_598087 != nil:
    section.add "prettyPrint", valid_598087
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

proc call*(call_598089: Call_BigqueryDatasetsPatch_598076; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates information in an existing dataset. The update method replaces the entire dataset resource, whereas the patch method only replaces fields that are provided in the submitted dataset resource. This method supports patch semantics.
  ## 
  let valid = call_598089.validator(path, query, header, formData, body)
  let scheme = call_598089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598089.url(scheme.get, call_598089.host, call_598089.base,
                         call_598089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598089, url, valid)

proc call*(call_598090: Call_BigqueryDatasetsPatch_598076; datasetId: string;
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
  var path_598091 = newJObject()
  var query_598092 = newJObject()
  var body_598093 = newJObject()
  add(query_598092, "fields", newJString(fields))
  add(query_598092, "quotaUser", newJString(quotaUser))
  add(query_598092, "alt", newJString(alt))
  add(query_598092, "oauth_token", newJString(oauthToken))
  add(query_598092, "userIp", newJString(userIp))
  add(path_598091, "datasetId", newJString(datasetId))
  add(query_598092, "key", newJString(key))
  add(path_598091, "projectId", newJString(projectId))
  if body != nil:
    body_598093 = body
  add(query_598092, "prettyPrint", newJBool(prettyPrint))
  result = call_598090.call(path_598091, query_598092, nil, nil, body_598093)

var bigqueryDatasetsPatch* = Call_BigqueryDatasetsPatch_598076(
    name: "bigqueryDatasetsPatch", meth: HttpMethod.HttpPatch,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}",
    validator: validate_BigqueryDatasetsPatch_598077, base: "/bigquery/v2",
    url: url_BigqueryDatasetsPatch_598078, schemes: {Scheme.Https})
type
  Call_BigqueryDatasetsDelete_598059 = ref object of OpenApiRestCall_597437
proc url_BigqueryDatasetsDelete_598061(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigqueryDatasetsDelete_598060(path: JsonNode; query: JsonNode;
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
  var valid_598062 = path.getOrDefault("datasetId")
  valid_598062 = validateParameter(valid_598062, JString, required = true,
                                 default = nil)
  if valid_598062 != nil:
    section.add "datasetId", valid_598062
  var valid_598063 = path.getOrDefault("projectId")
  valid_598063 = validateParameter(valid_598063, JString, required = true,
                                 default = nil)
  if valid_598063 != nil:
    section.add "projectId", valid_598063
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
  var valid_598064 = query.getOrDefault("fields")
  valid_598064 = validateParameter(valid_598064, JString, required = false,
                                 default = nil)
  if valid_598064 != nil:
    section.add "fields", valid_598064
  var valid_598065 = query.getOrDefault("quotaUser")
  valid_598065 = validateParameter(valid_598065, JString, required = false,
                                 default = nil)
  if valid_598065 != nil:
    section.add "quotaUser", valid_598065
  var valid_598066 = query.getOrDefault("alt")
  valid_598066 = validateParameter(valid_598066, JString, required = false,
                                 default = newJString("json"))
  if valid_598066 != nil:
    section.add "alt", valid_598066
  var valid_598067 = query.getOrDefault("deleteContents")
  valid_598067 = validateParameter(valid_598067, JBool, required = false, default = nil)
  if valid_598067 != nil:
    section.add "deleteContents", valid_598067
  var valid_598068 = query.getOrDefault("oauth_token")
  valid_598068 = validateParameter(valid_598068, JString, required = false,
                                 default = nil)
  if valid_598068 != nil:
    section.add "oauth_token", valid_598068
  var valid_598069 = query.getOrDefault("userIp")
  valid_598069 = validateParameter(valid_598069, JString, required = false,
                                 default = nil)
  if valid_598069 != nil:
    section.add "userIp", valid_598069
  var valid_598070 = query.getOrDefault("key")
  valid_598070 = validateParameter(valid_598070, JString, required = false,
                                 default = nil)
  if valid_598070 != nil:
    section.add "key", valid_598070
  var valid_598071 = query.getOrDefault("prettyPrint")
  valid_598071 = validateParameter(valid_598071, JBool, required = false,
                                 default = newJBool(true))
  if valid_598071 != nil:
    section.add "prettyPrint", valid_598071
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598072: Call_BigqueryDatasetsDelete_598059; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the dataset specified by the datasetId value. Before you can delete a dataset, you must delete all its tables, either manually or by specifying deleteContents. Immediately after deletion, you can create another dataset with the same name.
  ## 
  let valid = call_598072.validator(path, query, header, formData, body)
  let scheme = call_598072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598072.url(scheme.get, call_598072.host, call_598072.base,
                         call_598072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598072, url, valid)

proc call*(call_598073: Call_BigqueryDatasetsDelete_598059; datasetId: string;
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
  var path_598074 = newJObject()
  var query_598075 = newJObject()
  add(query_598075, "fields", newJString(fields))
  add(query_598075, "quotaUser", newJString(quotaUser))
  add(query_598075, "alt", newJString(alt))
  add(query_598075, "deleteContents", newJBool(deleteContents))
  add(query_598075, "oauth_token", newJString(oauthToken))
  add(query_598075, "userIp", newJString(userIp))
  add(path_598074, "datasetId", newJString(datasetId))
  add(query_598075, "key", newJString(key))
  add(path_598074, "projectId", newJString(projectId))
  add(query_598075, "prettyPrint", newJBool(prettyPrint))
  result = call_598073.call(path_598074, query_598075, nil, nil, nil)

var bigqueryDatasetsDelete* = Call_BigqueryDatasetsDelete_598059(
    name: "bigqueryDatasetsDelete", meth: HttpMethod.HttpDelete,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}",
    validator: validate_BigqueryDatasetsDelete_598060, base: "/bigquery/v2",
    url: url_BigqueryDatasetsDelete_598061, schemes: {Scheme.Https})
type
  Call_BigqueryModelsList_598094 = ref object of OpenApiRestCall_597437
proc url_BigqueryModelsList_598096(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigqueryModelsList_598095(path: JsonNode; query: JsonNode;
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
  var valid_598097 = path.getOrDefault("datasetId")
  valid_598097 = validateParameter(valid_598097, JString, required = true,
                                 default = nil)
  if valid_598097 != nil:
    section.add "datasetId", valid_598097
  var valid_598098 = path.getOrDefault("projectId")
  valid_598098 = validateParameter(valid_598098, JString, required = true,
                                 default = nil)
  if valid_598098 != nil:
    section.add "projectId", valid_598098
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
  var valid_598099 = query.getOrDefault("fields")
  valid_598099 = validateParameter(valid_598099, JString, required = false,
                                 default = nil)
  if valid_598099 != nil:
    section.add "fields", valid_598099
  var valid_598100 = query.getOrDefault("pageToken")
  valid_598100 = validateParameter(valid_598100, JString, required = false,
                                 default = nil)
  if valid_598100 != nil:
    section.add "pageToken", valid_598100
  var valid_598101 = query.getOrDefault("quotaUser")
  valid_598101 = validateParameter(valid_598101, JString, required = false,
                                 default = nil)
  if valid_598101 != nil:
    section.add "quotaUser", valid_598101
  var valid_598102 = query.getOrDefault("alt")
  valid_598102 = validateParameter(valid_598102, JString, required = false,
                                 default = newJString("json"))
  if valid_598102 != nil:
    section.add "alt", valid_598102
  var valid_598103 = query.getOrDefault("oauth_token")
  valid_598103 = validateParameter(valid_598103, JString, required = false,
                                 default = nil)
  if valid_598103 != nil:
    section.add "oauth_token", valid_598103
  var valid_598104 = query.getOrDefault("userIp")
  valid_598104 = validateParameter(valid_598104, JString, required = false,
                                 default = nil)
  if valid_598104 != nil:
    section.add "userIp", valid_598104
  var valid_598105 = query.getOrDefault("maxResults")
  valid_598105 = validateParameter(valid_598105, JInt, required = false, default = nil)
  if valid_598105 != nil:
    section.add "maxResults", valid_598105
  var valid_598106 = query.getOrDefault("key")
  valid_598106 = validateParameter(valid_598106, JString, required = false,
                                 default = nil)
  if valid_598106 != nil:
    section.add "key", valid_598106
  var valid_598107 = query.getOrDefault("prettyPrint")
  valid_598107 = validateParameter(valid_598107, JBool, required = false,
                                 default = newJBool(true))
  if valid_598107 != nil:
    section.add "prettyPrint", valid_598107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598108: Call_BigqueryModelsList_598094; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all models in the specified dataset. Requires the READER dataset
  ## role.
  ## 
  let valid = call_598108.validator(path, query, header, formData, body)
  let scheme = call_598108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598108.url(scheme.get, call_598108.host, call_598108.base,
                         call_598108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598108, url, valid)

proc call*(call_598109: Call_BigqueryModelsList_598094; datasetId: string;
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
  var path_598110 = newJObject()
  var query_598111 = newJObject()
  add(query_598111, "fields", newJString(fields))
  add(query_598111, "pageToken", newJString(pageToken))
  add(query_598111, "quotaUser", newJString(quotaUser))
  add(query_598111, "alt", newJString(alt))
  add(query_598111, "oauth_token", newJString(oauthToken))
  add(query_598111, "userIp", newJString(userIp))
  add(path_598110, "datasetId", newJString(datasetId))
  add(query_598111, "maxResults", newJInt(maxResults))
  add(query_598111, "key", newJString(key))
  add(path_598110, "projectId", newJString(projectId))
  add(query_598111, "prettyPrint", newJBool(prettyPrint))
  result = call_598109.call(path_598110, query_598111, nil, nil, nil)

var bigqueryModelsList* = Call_BigqueryModelsList_598094(
    name: "bigqueryModelsList", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/models",
    validator: validate_BigqueryModelsList_598095, base: "/bigquery/v2",
    url: url_BigqueryModelsList_598096, schemes: {Scheme.Https})
type
  Call_BigqueryModelsGet_598112 = ref object of OpenApiRestCall_597437
proc url_BigqueryModelsGet_598114(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigqueryModelsGet_598113(path: JsonNode; query: JsonNode;
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
  var valid_598115 = path.getOrDefault("datasetId")
  valid_598115 = validateParameter(valid_598115, JString, required = true,
                                 default = nil)
  if valid_598115 != nil:
    section.add "datasetId", valid_598115
  var valid_598116 = path.getOrDefault("projectId")
  valid_598116 = validateParameter(valid_598116, JString, required = true,
                                 default = nil)
  if valid_598116 != nil:
    section.add "projectId", valid_598116
  var valid_598117 = path.getOrDefault("modelId")
  valid_598117 = validateParameter(valid_598117, JString, required = true,
                                 default = nil)
  if valid_598117 != nil:
    section.add "modelId", valid_598117
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
  var valid_598118 = query.getOrDefault("fields")
  valid_598118 = validateParameter(valid_598118, JString, required = false,
                                 default = nil)
  if valid_598118 != nil:
    section.add "fields", valid_598118
  var valid_598119 = query.getOrDefault("quotaUser")
  valid_598119 = validateParameter(valid_598119, JString, required = false,
                                 default = nil)
  if valid_598119 != nil:
    section.add "quotaUser", valid_598119
  var valid_598120 = query.getOrDefault("alt")
  valid_598120 = validateParameter(valid_598120, JString, required = false,
                                 default = newJString("json"))
  if valid_598120 != nil:
    section.add "alt", valid_598120
  var valid_598121 = query.getOrDefault("oauth_token")
  valid_598121 = validateParameter(valid_598121, JString, required = false,
                                 default = nil)
  if valid_598121 != nil:
    section.add "oauth_token", valid_598121
  var valid_598122 = query.getOrDefault("userIp")
  valid_598122 = validateParameter(valid_598122, JString, required = false,
                                 default = nil)
  if valid_598122 != nil:
    section.add "userIp", valid_598122
  var valid_598123 = query.getOrDefault("key")
  valid_598123 = validateParameter(valid_598123, JString, required = false,
                                 default = nil)
  if valid_598123 != nil:
    section.add "key", valid_598123
  var valid_598124 = query.getOrDefault("prettyPrint")
  valid_598124 = validateParameter(valid_598124, JBool, required = false,
                                 default = newJBool(true))
  if valid_598124 != nil:
    section.add "prettyPrint", valid_598124
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598125: Call_BigqueryModelsGet_598112; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified model resource by model ID.
  ## 
  let valid = call_598125.validator(path, query, header, formData, body)
  let scheme = call_598125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598125.url(scheme.get, call_598125.host, call_598125.base,
                         call_598125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598125, url, valid)

proc call*(call_598126: Call_BigqueryModelsGet_598112; datasetId: string;
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
  var path_598127 = newJObject()
  var query_598128 = newJObject()
  add(query_598128, "fields", newJString(fields))
  add(query_598128, "quotaUser", newJString(quotaUser))
  add(query_598128, "alt", newJString(alt))
  add(query_598128, "oauth_token", newJString(oauthToken))
  add(query_598128, "userIp", newJString(userIp))
  add(path_598127, "datasetId", newJString(datasetId))
  add(query_598128, "key", newJString(key))
  add(path_598127, "projectId", newJString(projectId))
  add(path_598127, "modelId", newJString(modelId))
  add(query_598128, "prettyPrint", newJBool(prettyPrint))
  result = call_598126.call(path_598127, query_598128, nil, nil, nil)

var bigqueryModelsGet* = Call_BigqueryModelsGet_598112(name: "bigqueryModelsGet",
    meth: HttpMethod.HttpGet, host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/models/{modelId}",
    validator: validate_BigqueryModelsGet_598113, base: "/bigquery/v2",
    url: url_BigqueryModelsGet_598114, schemes: {Scheme.Https})
type
  Call_BigqueryModelsPatch_598146 = ref object of OpenApiRestCall_597437
proc url_BigqueryModelsPatch_598148(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigqueryModelsPatch_598147(path: JsonNode; query: JsonNode;
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
  var valid_598149 = path.getOrDefault("datasetId")
  valid_598149 = validateParameter(valid_598149, JString, required = true,
                                 default = nil)
  if valid_598149 != nil:
    section.add "datasetId", valid_598149
  var valid_598150 = path.getOrDefault("projectId")
  valid_598150 = validateParameter(valid_598150, JString, required = true,
                                 default = nil)
  if valid_598150 != nil:
    section.add "projectId", valid_598150
  var valid_598151 = path.getOrDefault("modelId")
  valid_598151 = validateParameter(valid_598151, JString, required = true,
                                 default = nil)
  if valid_598151 != nil:
    section.add "modelId", valid_598151
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
  var valid_598152 = query.getOrDefault("fields")
  valid_598152 = validateParameter(valid_598152, JString, required = false,
                                 default = nil)
  if valid_598152 != nil:
    section.add "fields", valid_598152
  var valid_598153 = query.getOrDefault("quotaUser")
  valid_598153 = validateParameter(valid_598153, JString, required = false,
                                 default = nil)
  if valid_598153 != nil:
    section.add "quotaUser", valid_598153
  var valid_598154 = query.getOrDefault("alt")
  valid_598154 = validateParameter(valid_598154, JString, required = false,
                                 default = newJString("json"))
  if valid_598154 != nil:
    section.add "alt", valid_598154
  var valid_598155 = query.getOrDefault("oauth_token")
  valid_598155 = validateParameter(valid_598155, JString, required = false,
                                 default = nil)
  if valid_598155 != nil:
    section.add "oauth_token", valid_598155
  var valid_598156 = query.getOrDefault("userIp")
  valid_598156 = validateParameter(valid_598156, JString, required = false,
                                 default = nil)
  if valid_598156 != nil:
    section.add "userIp", valid_598156
  var valid_598157 = query.getOrDefault("key")
  valid_598157 = validateParameter(valid_598157, JString, required = false,
                                 default = nil)
  if valid_598157 != nil:
    section.add "key", valid_598157
  var valid_598158 = query.getOrDefault("prettyPrint")
  valid_598158 = validateParameter(valid_598158, JBool, required = false,
                                 default = newJBool(true))
  if valid_598158 != nil:
    section.add "prettyPrint", valid_598158
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

proc call*(call_598160: Call_BigqueryModelsPatch_598146; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patch specific fields in the specified model.
  ## 
  let valid = call_598160.validator(path, query, header, formData, body)
  let scheme = call_598160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598160.url(scheme.get, call_598160.host, call_598160.base,
                         call_598160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598160, url, valid)

proc call*(call_598161: Call_BigqueryModelsPatch_598146; datasetId: string;
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
  var path_598162 = newJObject()
  var query_598163 = newJObject()
  var body_598164 = newJObject()
  add(query_598163, "fields", newJString(fields))
  add(query_598163, "quotaUser", newJString(quotaUser))
  add(query_598163, "alt", newJString(alt))
  add(query_598163, "oauth_token", newJString(oauthToken))
  add(query_598163, "userIp", newJString(userIp))
  add(path_598162, "datasetId", newJString(datasetId))
  add(query_598163, "key", newJString(key))
  add(path_598162, "projectId", newJString(projectId))
  add(path_598162, "modelId", newJString(modelId))
  if body != nil:
    body_598164 = body
  add(query_598163, "prettyPrint", newJBool(prettyPrint))
  result = call_598161.call(path_598162, query_598163, nil, nil, body_598164)

var bigqueryModelsPatch* = Call_BigqueryModelsPatch_598146(
    name: "bigqueryModelsPatch", meth: HttpMethod.HttpPatch,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/models/{modelId}",
    validator: validate_BigqueryModelsPatch_598147, base: "/bigquery/v2",
    url: url_BigqueryModelsPatch_598148, schemes: {Scheme.Https})
type
  Call_BigqueryModelsDelete_598129 = ref object of OpenApiRestCall_597437
proc url_BigqueryModelsDelete_598131(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigqueryModelsDelete_598130(path: JsonNode; query: JsonNode;
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
  var valid_598132 = path.getOrDefault("datasetId")
  valid_598132 = validateParameter(valid_598132, JString, required = true,
                                 default = nil)
  if valid_598132 != nil:
    section.add "datasetId", valid_598132
  var valid_598133 = path.getOrDefault("projectId")
  valid_598133 = validateParameter(valid_598133, JString, required = true,
                                 default = nil)
  if valid_598133 != nil:
    section.add "projectId", valid_598133
  var valid_598134 = path.getOrDefault("modelId")
  valid_598134 = validateParameter(valid_598134, JString, required = true,
                                 default = nil)
  if valid_598134 != nil:
    section.add "modelId", valid_598134
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
  var valid_598135 = query.getOrDefault("fields")
  valid_598135 = validateParameter(valid_598135, JString, required = false,
                                 default = nil)
  if valid_598135 != nil:
    section.add "fields", valid_598135
  var valid_598136 = query.getOrDefault("quotaUser")
  valid_598136 = validateParameter(valid_598136, JString, required = false,
                                 default = nil)
  if valid_598136 != nil:
    section.add "quotaUser", valid_598136
  var valid_598137 = query.getOrDefault("alt")
  valid_598137 = validateParameter(valid_598137, JString, required = false,
                                 default = newJString("json"))
  if valid_598137 != nil:
    section.add "alt", valid_598137
  var valid_598138 = query.getOrDefault("oauth_token")
  valid_598138 = validateParameter(valid_598138, JString, required = false,
                                 default = nil)
  if valid_598138 != nil:
    section.add "oauth_token", valid_598138
  var valid_598139 = query.getOrDefault("userIp")
  valid_598139 = validateParameter(valid_598139, JString, required = false,
                                 default = nil)
  if valid_598139 != nil:
    section.add "userIp", valid_598139
  var valid_598140 = query.getOrDefault("key")
  valid_598140 = validateParameter(valid_598140, JString, required = false,
                                 default = nil)
  if valid_598140 != nil:
    section.add "key", valid_598140
  var valid_598141 = query.getOrDefault("prettyPrint")
  valid_598141 = validateParameter(valid_598141, JBool, required = false,
                                 default = newJBool(true))
  if valid_598141 != nil:
    section.add "prettyPrint", valid_598141
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598142: Call_BigqueryModelsDelete_598129; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the model specified by modelId from the dataset.
  ## 
  let valid = call_598142.validator(path, query, header, formData, body)
  let scheme = call_598142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598142.url(scheme.get, call_598142.host, call_598142.base,
                         call_598142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598142, url, valid)

proc call*(call_598143: Call_BigqueryModelsDelete_598129; datasetId: string;
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
  var path_598144 = newJObject()
  var query_598145 = newJObject()
  add(query_598145, "fields", newJString(fields))
  add(query_598145, "quotaUser", newJString(quotaUser))
  add(query_598145, "alt", newJString(alt))
  add(query_598145, "oauth_token", newJString(oauthToken))
  add(query_598145, "userIp", newJString(userIp))
  add(path_598144, "datasetId", newJString(datasetId))
  add(query_598145, "key", newJString(key))
  add(path_598144, "projectId", newJString(projectId))
  add(path_598144, "modelId", newJString(modelId))
  add(query_598145, "prettyPrint", newJBool(prettyPrint))
  result = call_598143.call(path_598144, query_598145, nil, nil, nil)

var bigqueryModelsDelete* = Call_BigqueryModelsDelete_598129(
    name: "bigqueryModelsDelete", meth: HttpMethod.HttpDelete,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/models/{modelId}",
    validator: validate_BigqueryModelsDelete_598130, base: "/bigquery/v2",
    url: url_BigqueryModelsDelete_598131, schemes: {Scheme.Https})
type
  Call_BigqueryRoutinesInsert_598183 = ref object of OpenApiRestCall_597437
proc url_BigqueryRoutinesInsert_598185(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigqueryRoutinesInsert_598184(path: JsonNode; query: JsonNode;
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
  var valid_598186 = path.getOrDefault("datasetId")
  valid_598186 = validateParameter(valid_598186, JString, required = true,
                                 default = nil)
  if valid_598186 != nil:
    section.add "datasetId", valid_598186
  var valid_598187 = path.getOrDefault("projectId")
  valid_598187 = validateParameter(valid_598187, JString, required = true,
                                 default = nil)
  if valid_598187 != nil:
    section.add "projectId", valid_598187
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
  var valid_598188 = query.getOrDefault("fields")
  valid_598188 = validateParameter(valid_598188, JString, required = false,
                                 default = nil)
  if valid_598188 != nil:
    section.add "fields", valid_598188
  var valid_598189 = query.getOrDefault("quotaUser")
  valid_598189 = validateParameter(valid_598189, JString, required = false,
                                 default = nil)
  if valid_598189 != nil:
    section.add "quotaUser", valid_598189
  var valid_598190 = query.getOrDefault("alt")
  valid_598190 = validateParameter(valid_598190, JString, required = false,
                                 default = newJString("json"))
  if valid_598190 != nil:
    section.add "alt", valid_598190
  var valid_598191 = query.getOrDefault("oauth_token")
  valid_598191 = validateParameter(valid_598191, JString, required = false,
                                 default = nil)
  if valid_598191 != nil:
    section.add "oauth_token", valid_598191
  var valid_598192 = query.getOrDefault("userIp")
  valid_598192 = validateParameter(valid_598192, JString, required = false,
                                 default = nil)
  if valid_598192 != nil:
    section.add "userIp", valid_598192
  var valid_598193 = query.getOrDefault("key")
  valid_598193 = validateParameter(valid_598193, JString, required = false,
                                 default = nil)
  if valid_598193 != nil:
    section.add "key", valid_598193
  var valid_598194 = query.getOrDefault("prettyPrint")
  valid_598194 = validateParameter(valid_598194, JBool, required = false,
                                 default = newJBool(true))
  if valid_598194 != nil:
    section.add "prettyPrint", valid_598194
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

proc call*(call_598196: Call_BigqueryRoutinesInsert_598183; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new routine in the dataset.
  ## 
  let valid = call_598196.validator(path, query, header, formData, body)
  let scheme = call_598196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598196.url(scheme.get, call_598196.host, call_598196.base,
                         call_598196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598196, url, valid)

proc call*(call_598197: Call_BigqueryRoutinesInsert_598183; datasetId: string;
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
  var path_598198 = newJObject()
  var query_598199 = newJObject()
  var body_598200 = newJObject()
  add(query_598199, "fields", newJString(fields))
  add(query_598199, "quotaUser", newJString(quotaUser))
  add(query_598199, "alt", newJString(alt))
  add(query_598199, "oauth_token", newJString(oauthToken))
  add(query_598199, "userIp", newJString(userIp))
  add(path_598198, "datasetId", newJString(datasetId))
  add(query_598199, "key", newJString(key))
  add(path_598198, "projectId", newJString(projectId))
  if body != nil:
    body_598200 = body
  add(query_598199, "prettyPrint", newJBool(prettyPrint))
  result = call_598197.call(path_598198, query_598199, nil, nil, body_598200)

var bigqueryRoutinesInsert* = Call_BigqueryRoutinesInsert_598183(
    name: "bigqueryRoutinesInsert", meth: HttpMethod.HttpPost,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/routines",
    validator: validate_BigqueryRoutinesInsert_598184, base: "/bigquery/v2",
    url: url_BigqueryRoutinesInsert_598185, schemes: {Scheme.Https})
type
  Call_BigqueryRoutinesList_598165 = ref object of OpenApiRestCall_597437
proc url_BigqueryRoutinesList_598167(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigqueryRoutinesList_598166(path: JsonNode; query: JsonNode;
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
  var valid_598168 = path.getOrDefault("datasetId")
  valid_598168 = validateParameter(valid_598168, JString, required = true,
                                 default = nil)
  if valid_598168 != nil:
    section.add "datasetId", valid_598168
  var valid_598169 = path.getOrDefault("projectId")
  valid_598169 = validateParameter(valid_598169, JString, required = true,
                                 default = nil)
  if valid_598169 != nil:
    section.add "projectId", valid_598169
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
  var valid_598170 = query.getOrDefault("fields")
  valid_598170 = validateParameter(valid_598170, JString, required = false,
                                 default = nil)
  if valid_598170 != nil:
    section.add "fields", valid_598170
  var valid_598171 = query.getOrDefault("pageToken")
  valid_598171 = validateParameter(valid_598171, JString, required = false,
                                 default = nil)
  if valid_598171 != nil:
    section.add "pageToken", valid_598171
  var valid_598172 = query.getOrDefault("quotaUser")
  valid_598172 = validateParameter(valid_598172, JString, required = false,
                                 default = nil)
  if valid_598172 != nil:
    section.add "quotaUser", valid_598172
  var valid_598173 = query.getOrDefault("alt")
  valid_598173 = validateParameter(valid_598173, JString, required = false,
                                 default = newJString("json"))
  if valid_598173 != nil:
    section.add "alt", valid_598173
  var valid_598174 = query.getOrDefault("oauth_token")
  valid_598174 = validateParameter(valid_598174, JString, required = false,
                                 default = nil)
  if valid_598174 != nil:
    section.add "oauth_token", valid_598174
  var valid_598175 = query.getOrDefault("userIp")
  valid_598175 = validateParameter(valid_598175, JString, required = false,
                                 default = nil)
  if valid_598175 != nil:
    section.add "userIp", valid_598175
  var valid_598176 = query.getOrDefault("maxResults")
  valid_598176 = validateParameter(valid_598176, JInt, required = false, default = nil)
  if valid_598176 != nil:
    section.add "maxResults", valid_598176
  var valid_598177 = query.getOrDefault("key")
  valid_598177 = validateParameter(valid_598177, JString, required = false,
                                 default = nil)
  if valid_598177 != nil:
    section.add "key", valid_598177
  var valid_598178 = query.getOrDefault("prettyPrint")
  valid_598178 = validateParameter(valid_598178, JBool, required = false,
                                 default = newJBool(true))
  if valid_598178 != nil:
    section.add "prettyPrint", valid_598178
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598179: Call_BigqueryRoutinesList_598165; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all routines in the specified dataset. Requires the READER dataset
  ## role.
  ## 
  let valid = call_598179.validator(path, query, header, formData, body)
  let scheme = call_598179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598179.url(scheme.get, call_598179.host, call_598179.base,
                         call_598179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598179, url, valid)

proc call*(call_598180: Call_BigqueryRoutinesList_598165; datasetId: string;
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
  var path_598181 = newJObject()
  var query_598182 = newJObject()
  add(query_598182, "fields", newJString(fields))
  add(query_598182, "pageToken", newJString(pageToken))
  add(query_598182, "quotaUser", newJString(quotaUser))
  add(query_598182, "alt", newJString(alt))
  add(query_598182, "oauth_token", newJString(oauthToken))
  add(query_598182, "userIp", newJString(userIp))
  add(path_598181, "datasetId", newJString(datasetId))
  add(query_598182, "maxResults", newJInt(maxResults))
  add(query_598182, "key", newJString(key))
  add(path_598181, "projectId", newJString(projectId))
  add(query_598182, "prettyPrint", newJBool(prettyPrint))
  result = call_598180.call(path_598181, query_598182, nil, nil, nil)

var bigqueryRoutinesList* = Call_BigqueryRoutinesList_598165(
    name: "bigqueryRoutinesList", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/routines",
    validator: validate_BigqueryRoutinesList_598166, base: "/bigquery/v2",
    url: url_BigqueryRoutinesList_598167, schemes: {Scheme.Https})
type
  Call_BigqueryRoutinesUpdate_598219 = ref object of OpenApiRestCall_597437
proc url_BigqueryRoutinesUpdate_598221(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigqueryRoutinesUpdate_598220(path: JsonNode; query: JsonNode;
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
  var valid_598222 = path.getOrDefault("datasetId")
  valid_598222 = validateParameter(valid_598222, JString, required = true,
                                 default = nil)
  if valid_598222 != nil:
    section.add "datasetId", valid_598222
  var valid_598223 = path.getOrDefault("projectId")
  valid_598223 = validateParameter(valid_598223, JString, required = true,
                                 default = nil)
  if valid_598223 != nil:
    section.add "projectId", valid_598223
  var valid_598224 = path.getOrDefault("routineId")
  valid_598224 = validateParameter(valid_598224, JString, required = true,
                                 default = nil)
  if valid_598224 != nil:
    section.add "routineId", valid_598224
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
  var valid_598225 = query.getOrDefault("fields")
  valid_598225 = validateParameter(valid_598225, JString, required = false,
                                 default = nil)
  if valid_598225 != nil:
    section.add "fields", valid_598225
  var valid_598226 = query.getOrDefault("quotaUser")
  valid_598226 = validateParameter(valid_598226, JString, required = false,
                                 default = nil)
  if valid_598226 != nil:
    section.add "quotaUser", valid_598226
  var valid_598227 = query.getOrDefault("alt")
  valid_598227 = validateParameter(valid_598227, JString, required = false,
                                 default = newJString("json"))
  if valid_598227 != nil:
    section.add "alt", valid_598227
  var valid_598228 = query.getOrDefault("oauth_token")
  valid_598228 = validateParameter(valid_598228, JString, required = false,
                                 default = nil)
  if valid_598228 != nil:
    section.add "oauth_token", valid_598228
  var valid_598229 = query.getOrDefault("userIp")
  valid_598229 = validateParameter(valid_598229, JString, required = false,
                                 default = nil)
  if valid_598229 != nil:
    section.add "userIp", valid_598229
  var valid_598230 = query.getOrDefault("key")
  valid_598230 = validateParameter(valid_598230, JString, required = false,
                                 default = nil)
  if valid_598230 != nil:
    section.add "key", valid_598230
  var valid_598231 = query.getOrDefault("prettyPrint")
  valid_598231 = validateParameter(valid_598231, JBool, required = false,
                                 default = newJBool(true))
  if valid_598231 != nil:
    section.add "prettyPrint", valid_598231
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

proc call*(call_598233: Call_BigqueryRoutinesUpdate_598219; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates information in an existing routine. The update method replaces the
  ## entire Routine resource.
  ## 
  let valid = call_598233.validator(path, query, header, formData, body)
  let scheme = call_598233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598233.url(scheme.get, call_598233.host, call_598233.base,
                         call_598233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598233, url, valid)

proc call*(call_598234: Call_BigqueryRoutinesUpdate_598219; datasetId: string;
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
  var path_598235 = newJObject()
  var query_598236 = newJObject()
  var body_598237 = newJObject()
  add(query_598236, "fields", newJString(fields))
  add(query_598236, "quotaUser", newJString(quotaUser))
  add(query_598236, "alt", newJString(alt))
  add(query_598236, "oauth_token", newJString(oauthToken))
  add(query_598236, "userIp", newJString(userIp))
  add(path_598235, "datasetId", newJString(datasetId))
  add(query_598236, "key", newJString(key))
  add(path_598235, "projectId", newJString(projectId))
  add(path_598235, "routineId", newJString(routineId))
  if body != nil:
    body_598237 = body
  add(query_598236, "prettyPrint", newJBool(prettyPrint))
  result = call_598234.call(path_598235, query_598236, nil, nil, body_598237)

var bigqueryRoutinesUpdate* = Call_BigqueryRoutinesUpdate_598219(
    name: "bigqueryRoutinesUpdate", meth: HttpMethod.HttpPut,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/routines/{routineId}",
    validator: validate_BigqueryRoutinesUpdate_598220, base: "/bigquery/v2",
    url: url_BigqueryRoutinesUpdate_598221, schemes: {Scheme.Https})
type
  Call_BigqueryRoutinesGet_598201 = ref object of OpenApiRestCall_597437
proc url_BigqueryRoutinesGet_598203(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigqueryRoutinesGet_598202(path: JsonNode; query: JsonNode;
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
  var valid_598204 = path.getOrDefault("datasetId")
  valid_598204 = validateParameter(valid_598204, JString, required = true,
                                 default = nil)
  if valid_598204 != nil:
    section.add "datasetId", valid_598204
  var valid_598205 = path.getOrDefault("projectId")
  valid_598205 = validateParameter(valid_598205, JString, required = true,
                                 default = nil)
  if valid_598205 != nil:
    section.add "projectId", valid_598205
  var valid_598206 = path.getOrDefault("routineId")
  valid_598206 = validateParameter(valid_598206, JString, required = true,
                                 default = nil)
  if valid_598206 != nil:
    section.add "routineId", valid_598206
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
  var valid_598207 = query.getOrDefault("fields")
  valid_598207 = validateParameter(valid_598207, JString, required = false,
                                 default = nil)
  if valid_598207 != nil:
    section.add "fields", valid_598207
  var valid_598208 = query.getOrDefault("quotaUser")
  valid_598208 = validateParameter(valid_598208, JString, required = false,
                                 default = nil)
  if valid_598208 != nil:
    section.add "quotaUser", valid_598208
  var valid_598209 = query.getOrDefault("alt")
  valid_598209 = validateParameter(valid_598209, JString, required = false,
                                 default = newJString("json"))
  if valid_598209 != nil:
    section.add "alt", valid_598209
  var valid_598210 = query.getOrDefault("oauth_token")
  valid_598210 = validateParameter(valid_598210, JString, required = false,
                                 default = nil)
  if valid_598210 != nil:
    section.add "oauth_token", valid_598210
  var valid_598211 = query.getOrDefault("userIp")
  valid_598211 = validateParameter(valid_598211, JString, required = false,
                                 default = nil)
  if valid_598211 != nil:
    section.add "userIp", valid_598211
  var valid_598212 = query.getOrDefault("key")
  valid_598212 = validateParameter(valid_598212, JString, required = false,
                                 default = nil)
  if valid_598212 != nil:
    section.add "key", valid_598212
  var valid_598213 = query.getOrDefault("fieldMask")
  valid_598213 = validateParameter(valid_598213, JString, required = false,
                                 default = nil)
  if valid_598213 != nil:
    section.add "fieldMask", valid_598213
  var valid_598214 = query.getOrDefault("prettyPrint")
  valid_598214 = validateParameter(valid_598214, JBool, required = false,
                                 default = newJBool(true))
  if valid_598214 != nil:
    section.add "prettyPrint", valid_598214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598215: Call_BigqueryRoutinesGet_598201; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified routine resource by routine ID.
  ## 
  let valid = call_598215.validator(path, query, header, formData, body)
  let scheme = call_598215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598215.url(scheme.get, call_598215.host, call_598215.base,
                         call_598215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598215, url, valid)

proc call*(call_598216: Call_BigqueryRoutinesGet_598201; datasetId: string;
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
  var path_598217 = newJObject()
  var query_598218 = newJObject()
  add(query_598218, "fields", newJString(fields))
  add(query_598218, "quotaUser", newJString(quotaUser))
  add(query_598218, "alt", newJString(alt))
  add(query_598218, "oauth_token", newJString(oauthToken))
  add(query_598218, "userIp", newJString(userIp))
  add(path_598217, "datasetId", newJString(datasetId))
  add(query_598218, "key", newJString(key))
  add(query_598218, "fieldMask", newJString(fieldMask))
  add(path_598217, "projectId", newJString(projectId))
  add(path_598217, "routineId", newJString(routineId))
  add(query_598218, "prettyPrint", newJBool(prettyPrint))
  result = call_598216.call(path_598217, query_598218, nil, nil, nil)

var bigqueryRoutinesGet* = Call_BigqueryRoutinesGet_598201(
    name: "bigqueryRoutinesGet", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/routines/{routineId}",
    validator: validate_BigqueryRoutinesGet_598202, base: "/bigquery/v2",
    url: url_BigqueryRoutinesGet_598203, schemes: {Scheme.Https})
type
  Call_BigqueryRoutinesDelete_598238 = ref object of OpenApiRestCall_597437
proc url_BigqueryRoutinesDelete_598240(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigqueryRoutinesDelete_598239(path: JsonNode; query: JsonNode;
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
  var valid_598241 = path.getOrDefault("datasetId")
  valid_598241 = validateParameter(valid_598241, JString, required = true,
                                 default = nil)
  if valid_598241 != nil:
    section.add "datasetId", valid_598241
  var valid_598242 = path.getOrDefault("projectId")
  valid_598242 = validateParameter(valid_598242, JString, required = true,
                                 default = nil)
  if valid_598242 != nil:
    section.add "projectId", valid_598242
  var valid_598243 = path.getOrDefault("routineId")
  valid_598243 = validateParameter(valid_598243, JString, required = true,
                                 default = nil)
  if valid_598243 != nil:
    section.add "routineId", valid_598243
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
  var valid_598244 = query.getOrDefault("fields")
  valid_598244 = validateParameter(valid_598244, JString, required = false,
                                 default = nil)
  if valid_598244 != nil:
    section.add "fields", valid_598244
  var valid_598245 = query.getOrDefault("quotaUser")
  valid_598245 = validateParameter(valid_598245, JString, required = false,
                                 default = nil)
  if valid_598245 != nil:
    section.add "quotaUser", valid_598245
  var valid_598246 = query.getOrDefault("alt")
  valid_598246 = validateParameter(valid_598246, JString, required = false,
                                 default = newJString("json"))
  if valid_598246 != nil:
    section.add "alt", valid_598246
  var valid_598247 = query.getOrDefault("oauth_token")
  valid_598247 = validateParameter(valid_598247, JString, required = false,
                                 default = nil)
  if valid_598247 != nil:
    section.add "oauth_token", valid_598247
  var valid_598248 = query.getOrDefault("userIp")
  valid_598248 = validateParameter(valid_598248, JString, required = false,
                                 default = nil)
  if valid_598248 != nil:
    section.add "userIp", valid_598248
  var valid_598249 = query.getOrDefault("key")
  valid_598249 = validateParameter(valid_598249, JString, required = false,
                                 default = nil)
  if valid_598249 != nil:
    section.add "key", valid_598249
  var valid_598250 = query.getOrDefault("prettyPrint")
  valid_598250 = validateParameter(valid_598250, JBool, required = false,
                                 default = newJBool(true))
  if valid_598250 != nil:
    section.add "prettyPrint", valid_598250
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598251: Call_BigqueryRoutinesDelete_598238; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the routine specified by routineId from the dataset.
  ## 
  let valid = call_598251.validator(path, query, header, formData, body)
  let scheme = call_598251.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598251.url(scheme.get, call_598251.host, call_598251.base,
                         call_598251.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598251, url, valid)

proc call*(call_598252: Call_BigqueryRoutinesDelete_598238; datasetId: string;
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
  var path_598253 = newJObject()
  var query_598254 = newJObject()
  add(query_598254, "fields", newJString(fields))
  add(query_598254, "quotaUser", newJString(quotaUser))
  add(query_598254, "alt", newJString(alt))
  add(query_598254, "oauth_token", newJString(oauthToken))
  add(query_598254, "userIp", newJString(userIp))
  add(path_598253, "datasetId", newJString(datasetId))
  add(query_598254, "key", newJString(key))
  add(path_598253, "projectId", newJString(projectId))
  add(path_598253, "routineId", newJString(routineId))
  add(query_598254, "prettyPrint", newJBool(prettyPrint))
  result = call_598252.call(path_598253, query_598254, nil, nil, nil)

var bigqueryRoutinesDelete* = Call_BigqueryRoutinesDelete_598238(
    name: "bigqueryRoutinesDelete", meth: HttpMethod.HttpDelete,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/routines/{routineId}",
    validator: validate_BigqueryRoutinesDelete_598239, base: "/bigquery/v2",
    url: url_BigqueryRoutinesDelete_598240, schemes: {Scheme.Https})
type
  Call_BigqueryTablesInsert_598273 = ref object of OpenApiRestCall_597437
proc url_BigqueryTablesInsert_598275(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigqueryTablesInsert_598274(path: JsonNode; query: JsonNode;
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
  var valid_598276 = path.getOrDefault("datasetId")
  valid_598276 = validateParameter(valid_598276, JString, required = true,
                                 default = nil)
  if valid_598276 != nil:
    section.add "datasetId", valid_598276
  var valid_598277 = path.getOrDefault("projectId")
  valid_598277 = validateParameter(valid_598277, JString, required = true,
                                 default = nil)
  if valid_598277 != nil:
    section.add "projectId", valid_598277
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
  var valid_598278 = query.getOrDefault("fields")
  valid_598278 = validateParameter(valid_598278, JString, required = false,
                                 default = nil)
  if valid_598278 != nil:
    section.add "fields", valid_598278
  var valid_598279 = query.getOrDefault("quotaUser")
  valid_598279 = validateParameter(valid_598279, JString, required = false,
                                 default = nil)
  if valid_598279 != nil:
    section.add "quotaUser", valid_598279
  var valid_598280 = query.getOrDefault("alt")
  valid_598280 = validateParameter(valid_598280, JString, required = false,
                                 default = newJString("json"))
  if valid_598280 != nil:
    section.add "alt", valid_598280
  var valid_598281 = query.getOrDefault("oauth_token")
  valid_598281 = validateParameter(valid_598281, JString, required = false,
                                 default = nil)
  if valid_598281 != nil:
    section.add "oauth_token", valid_598281
  var valid_598282 = query.getOrDefault("userIp")
  valid_598282 = validateParameter(valid_598282, JString, required = false,
                                 default = nil)
  if valid_598282 != nil:
    section.add "userIp", valid_598282
  var valid_598283 = query.getOrDefault("key")
  valid_598283 = validateParameter(valid_598283, JString, required = false,
                                 default = nil)
  if valid_598283 != nil:
    section.add "key", valid_598283
  var valid_598284 = query.getOrDefault("prettyPrint")
  valid_598284 = validateParameter(valid_598284, JBool, required = false,
                                 default = newJBool(true))
  if valid_598284 != nil:
    section.add "prettyPrint", valid_598284
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

proc call*(call_598286: Call_BigqueryTablesInsert_598273; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new, empty table in the dataset.
  ## 
  let valid = call_598286.validator(path, query, header, formData, body)
  let scheme = call_598286.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598286.url(scheme.get, call_598286.host, call_598286.base,
                         call_598286.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598286, url, valid)

proc call*(call_598287: Call_BigqueryTablesInsert_598273; datasetId: string;
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
  var path_598288 = newJObject()
  var query_598289 = newJObject()
  var body_598290 = newJObject()
  add(query_598289, "fields", newJString(fields))
  add(query_598289, "quotaUser", newJString(quotaUser))
  add(query_598289, "alt", newJString(alt))
  add(query_598289, "oauth_token", newJString(oauthToken))
  add(query_598289, "userIp", newJString(userIp))
  add(path_598288, "datasetId", newJString(datasetId))
  add(query_598289, "key", newJString(key))
  add(path_598288, "projectId", newJString(projectId))
  if body != nil:
    body_598290 = body
  add(query_598289, "prettyPrint", newJBool(prettyPrint))
  result = call_598287.call(path_598288, query_598289, nil, nil, body_598290)

var bigqueryTablesInsert* = Call_BigqueryTablesInsert_598273(
    name: "bigqueryTablesInsert", meth: HttpMethod.HttpPost,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/tables",
    validator: validate_BigqueryTablesInsert_598274, base: "/bigquery/v2",
    url: url_BigqueryTablesInsert_598275, schemes: {Scheme.Https})
type
  Call_BigqueryTablesList_598255 = ref object of OpenApiRestCall_597437
proc url_BigqueryTablesList_598257(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigqueryTablesList_598256(path: JsonNode; query: JsonNode;
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
  var valid_598258 = path.getOrDefault("datasetId")
  valid_598258 = validateParameter(valid_598258, JString, required = true,
                                 default = nil)
  if valid_598258 != nil:
    section.add "datasetId", valid_598258
  var valid_598259 = path.getOrDefault("projectId")
  valid_598259 = validateParameter(valid_598259, JString, required = true,
                                 default = nil)
  if valid_598259 != nil:
    section.add "projectId", valid_598259
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
  var valid_598260 = query.getOrDefault("fields")
  valid_598260 = validateParameter(valid_598260, JString, required = false,
                                 default = nil)
  if valid_598260 != nil:
    section.add "fields", valid_598260
  var valid_598261 = query.getOrDefault("pageToken")
  valid_598261 = validateParameter(valid_598261, JString, required = false,
                                 default = nil)
  if valid_598261 != nil:
    section.add "pageToken", valid_598261
  var valid_598262 = query.getOrDefault("quotaUser")
  valid_598262 = validateParameter(valid_598262, JString, required = false,
                                 default = nil)
  if valid_598262 != nil:
    section.add "quotaUser", valid_598262
  var valid_598263 = query.getOrDefault("alt")
  valid_598263 = validateParameter(valid_598263, JString, required = false,
                                 default = newJString("json"))
  if valid_598263 != nil:
    section.add "alt", valid_598263
  var valid_598264 = query.getOrDefault("oauth_token")
  valid_598264 = validateParameter(valid_598264, JString, required = false,
                                 default = nil)
  if valid_598264 != nil:
    section.add "oauth_token", valid_598264
  var valid_598265 = query.getOrDefault("userIp")
  valid_598265 = validateParameter(valid_598265, JString, required = false,
                                 default = nil)
  if valid_598265 != nil:
    section.add "userIp", valid_598265
  var valid_598266 = query.getOrDefault("maxResults")
  valid_598266 = validateParameter(valid_598266, JInt, required = false, default = nil)
  if valid_598266 != nil:
    section.add "maxResults", valid_598266
  var valid_598267 = query.getOrDefault("key")
  valid_598267 = validateParameter(valid_598267, JString, required = false,
                                 default = nil)
  if valid_598267 != nil:
    section.add "key", valid_598267
  var valid_598268 = query.getOrDefault("prettyPrint")
  valid_598268 = validateParameter(valid_598268, JBool, required = false,
                                 default = newJBool(true))
  if valid_598268 != nil:
    section.add "prettyPrint", valid_598268
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598269: Call_BigqueryTablesList_598255; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all tables in the specified dataset. Requires the READER dataset role.
  ## 
  let valid = call_598269.validator(path, query, header, formData, body)
  let scheme = call_598269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598269.url(scheme.get, call_598269.host, call_598269.base,
                         call_598269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598269, url, valid)

proc call*(call_598270: Call_BigqueryTablesList_598255; datasetId: string;
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
  var path_598271 = newJObject()
  var query_598272 = newJObject()
  add(query_598272, "fields", newJString(fields))
  add(query_598272, "pageToken", newJString(pageToken))
  add(query_598272, "quotaUser", newJString(quotaUser))
  add(query_598272, "alt", newJString(alt))
  add(query_598272, "oauth_token", newJString(oauthToken))
  add(query_598272, "userIp", newJString(userIp))
  add(path_598271, "datasetId", newJString(datasetId))
  add(query_598272, "maxResults", newJInt(maxResults))
  add(query_598272, "key", newJString(key))
  add(path_598271, "projectId", newJString(projectId))
  add(query_598272, "prettyPrint", newJBool(prettyPrint))
  result = call_598270.call(path_598271, query_598272, nil, nil, nil)

var bigqueryTablesList* = Call_BigqueryTablesList_598255(
    name: "bigqueryTablesList", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/tables",
    validator: validate_BigqueryTablesList_598256, base: "/bigquery/v2",
    url: url_BigqueryTablesList_598257, schemes: {Scheme.Https})
type
  Call_BigqueryTablesUpdate_598309 = ref object of OpenApiRestCall_597437
proc url_BigqueryTablesUpdate_598311(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigqueryTablesUpdate_598310(path: JsonNode; query: JsonNode;
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
  var valid_598312 = path.getOrDefault("tableId")
  valid_598312 = validateParameter(valid_598312, JString, required = true,
                                 default = nil)
  if valid_598312 != nil:
    section.add "tableId", valid_598312
  var valid_598313 = path.getOrDefault("datasetId")
  valid_598313 = validateParameter(valid_598313, JString, required = true,
                                 default = nil)
  if valid_598313 != nil:
    section.add "datasetId", valid_598313
  var valid_598314 = path.getOrDefault("projectId")
  valid_598314 = validateParameter(valid_598314, JString, required = true,
                                 default = nil)
  if valid_598314 != nil:
    section.add "projectId", valid_598314
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
  var valid_598315 = query.getOrDefault("fields")
  valid_598315 = validateParameter(valid_598315, JString, required = false,
                                 default = nil)
  if valid_598315 != nil:
    section.add "fields", valid_598315
  var valid_598316 = query.getOrDefault("quotaUser")
  valid_598316 = validateParameter(valid_598316, JString, required = false,
                                 default = nil)
  if valid_598316 != nil:
    section.add "quotaUser", valid_598316
  var valid_598317 = query.getOrDefault("alt")
  valid_598317 = validateParameter(valid_598317, JString, required = false,
                                 default = newJString("json"))
  if valid_598317 != nil:
    section.add "alt", valid_598317
  var valid_598318 = query.getOrDefault("oauth_token")
  valid_598318 = validateParameter(valid_598318, JString, required = false,
                                 default = nil)
  if valid_598318 != nil:
    section.add "oauth_token", valid_598318
  var valid_598319 = query.getOrDefault("userIp")
  valid_598319 = validateParameter(valid_598319, JString, required = false,
                                 default = nil)
  if valid_598319 != nil:
    section.add "userIp", valid_598319
  var valid_598320 = query.getOrDefault("key")
  valid_598320 = validateParameter(valid_598320, JString, required = false,
                                 default = nil)
  if valid_598320 != nil:
    section.add "key", valid_598320
  var valid_598321 = query.getOrDefault("prettyPrint")
  valid_598321 = validateParameter(valid_598321, JBool, required = false,
                                 default = newJBool(true))
  if valid_598321 != nil:
    section.add "prettyPrint", valid_598321
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

proc call*(call_598323: Call_BigqueryTablesUpdate_598309; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates information in an existing table. The update method replaces the entire table resource, whereas the patch method only replaces fields that are provided in the submitted table resource.
  ## 
  let valid = call_598323.validator(path, query, header, formData, body)
  let scheme = call_598323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598323.url(scheme.get, call_598323.host, call_598323.base,
                         call_598323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598323, url, valid)

proc call*(call_598324: Call_BigqueryTablesUpdate_598309; tableId: string;
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
  var path_598325 = newJObject()
  var query_598326 = newJObject()
  var body_598327 = newJObject()
  add(path_598325, "tableId", newJString(tableId))
  add(query_598326, "fields", newJString(fields))
  add(query_598326, "quotaUser", newJString(quotaUser))
  add(query_598326, "alt", newJString(alt))
  add(query_598326, "oauth_token", newJString(oauthToken))
  add(query_598326, "userIp", newJString(userIp))
  add(path_598325, "datasetId", newJString(datasetId))
  add(query_598326, "key", newJString(key))
  add(path_598325, "projectId", newJString(projectId))
  if body != nil:
    body_598327 = body
  add(query_598326, "prettyPrint", newJBool(prettyPrint))
  result = call_598324.call(path_598325, query_598326, nil, nil, body_598327)

var bigqueryTablesUpdate* = Call_BigqueryTablesUpdate_598309(
    name: "bigqueryTablesUpdate", meth: HttpMethod.HttpPut,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/tables/{tableId}",
    validator: validate_BigqueryTablesUpdate_598310, base: "/bigquery/v2",
    url: url_BigqueryTablesUpdate_598311, schemes: {Scheme.Https})
type
  Call_BigqueryTablesGet_598291 = ref object of OpenApiRestCall_597437
proc url_BigqueryTablesGet_598293(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigqueryTablesGet_598292(path: JsonNode; query: JsonNode;
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
  var valid_598294 = path.getOrDefault("tableId")
  valid_598294 = validateParameter(valid_598294, JString, required = true,
                                 default = nil)
  if valid_598294 != nil:
    section.add "tableId", valid_598294
  var valid_598295 = path.getOrDefault("datasetId")
  valid_598295 = validateParameter(valid_598295, JString, required = true,
                                 default = nil)
  if valid_598295 != nil:
    section.add "datasetId", valid_598295
  var valid_598296 = path.getOrDefault("projectId")
  valid_598296 = validateParameter(valid_598296, JString, required = true,
                                 default = nil)
  if valid_598296 != nil:
    section.add "projectId", valid_598296
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
  var valid_598297 = query.getOrDefault("fields")
  valid_598297 = validateParameter(valid_598297, JString, required = false,
                                 default = nil)
  if valid_598297 != nil:
    section.add "fields", valid_598297
  var valid_598298 = query.getOrDefault("quotaUser")
  valid_598298 = validateParameter(valid_598298, JString, required = false,
                                 default = nil)
  if valid_598298 != nil:
    section.add "quotaUser", valid_598298
  var valid_598299 = query.getOrDefault("alt")
  valid_598299 = validateParameter(valid_598299, JString, required = false,
                                 default = newJString("json"))
  if valid_598299 != nil:
    section.add "alt", valid_598299
  var valid_598300 = query.getOrDefault("oauth_token")
  valid_598300 = validateParameter(valid_598300, JString, required = false,
                                 default = nil)
  if valid_598300 != nil:
    section.add "oauth_token", valid_598300
  var valid_598301 = query.getOrDefault("userIp")
  valid_598301 = validateParameter(valid_598301, JString, required = false,
                                 default = nil)
  if valid_598301 != nil:
    section.add "userIp", valid_598301
  var valid_598302 = query.getOrDefault("key")
  valid_598302 = validateParameter(valid_598302, JString, required = false,
                                 default = nil)
  if valid_598302 != nil:
    section.add "key", valid_598302
  var valid_598303 = query.getOrDefault("prettyPrint")
  valid_598303 = validateParameter(valid_598303, JBool, required = false,
                                 default = newJBool(true))
  if valid_598303 != nil:
    section.add "prettyPrint", valid_598303
  var valid_598304 = query.getOrDefault("selectedFields")
  valid_598304 = validateParameter(valid_598304, JString, required = false,
                                 default = nil)
  if valid_598304 != nil:
    section.add "selectedFields", valid_598304
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598305: Call_BigqueryTablesGet_598291; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified table resource by table ID. This method does not return the data in the table, it only returns the table resource, which describes the structure of this table.
  ## 
  let valid = call_598305.validator(path, query, header, formData, body)
  let scheme = call_598305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598305.url(scheme.get, call_598305.host, call_598305.base,
                         call_598305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598305, url, valid)

proc call*(call_598306: Call_BigqueryTablesGet_598291; tableId: string;
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
  var path_598307 = newJObject()
  var query_598308 = newJObject()
  add(path_598307, "tableId", newJString(tableId))
  add(query_598308, "fields", newJString(fields))
  add(query_598308, "quotaUser", newJString(quotaUser))
  add(query_598308, "alt", newJString(alt))
  add(query_598308, "oauth_token", newJString(oauthToken))
  add(query_598308, "userIp", newJString(userIp))
  add(path_598307, "datasetId", newJString(datasetId))
  add(query_598308, "key", newJString(key))
  add(path_598307, "projectId", newJString(projectId))
  add(query_598308, "prettyPrint", newJBool(prettyPrint))
  add(query_598308, "selectedFields", newJString(selectedFields))
  result = call_598306.call(path_598307, query_598308, nil, nil, nil)

var bigqueryTablesGet* = Call_BigqueryTablesGet_598291(name: "bigqueryTablesGet",
    meth: HttpMethod.HttpGet, host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/tables/{tableId}",
    validator: validate_BigqueryTablesGet_598292, base: "/bigquery/v2",
    url: url_BigqueryTablesGet_598293, schemes: {Scheme.Https})
type
  Call_BigqueryTablesPatch_598345 = ref object of OpenApiRestCall_597437
proc url_BigqueryTablesPatch_598347(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigqueryTablesPatch_598346(path: JsonNode; query: JsonNode;
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
  var valid_598348 = path.getOrDefault("tableId")
  valid_598348 = validateParameter(valid_598348, JString, required = true,
                                 default = nil)
  if valid_598348 != nil:
    section.add "tableId", valid_598348
  var valid_598349 = path.getOrDefault("datasetId")
  valid_598349 = validateParameter(valid_598349, JString, required = true,
                                 default = nil)
  if valid_598349 != nil:
    section.add "datasetId", valid_598349
  var valid_598350 = path.getOrDefault("projectId")
  valid_598350 = validateParameter(valid_598350, JString, required = true,
                                 default = nil)
  if valid_598350 != nil:
    section.add "projectId", valid_598350
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
  var valid_598351 = query.getOrDefault("fields")
  valid_598351 = validateParameter(valid_598351, JString, required = false,
                                 default = nil)
  if valid_598351 != nil:
    section.add "fields", valid_598351
  var valid_598352 = query.getOrDefault("quotaUser")
  valid_598352 = validateParameter(valid_598352, JString, required = false,
                                 default = nil)
  if valid_598352 != nil:
    section.add "quotaUser", valid_598352
  var valid_598353 = query.getOrDefault("alt")
  valid_598353 = validateParameter(valid_598353, JString, required = false,
                                 default = newJString("json"))
  if valid_598353 != nil:
    section.add "alt", valid_598353
  var valid_598354 = query.getOrDefault("oauth_token")
  valid_598354 = validateParameter(valid_598354, JString, required = false,
                                 default = nil)
  if valid_598354 != nil:
    section.add "oauth_token", valid_598354
  var valid_598355 = query.getOrDefault("userIp")
  valid_598355 = validateParameter(valid_598355, JString, required = false,
                                 default = nil)
  if valid_598355 != nil:
    section.add "userIp", valid_598355
  var valid_598356 = query.getOrDefault("key")
  valid_598356 = validateParameter(valid_598356, JString, required = false,
                                 default = nil)
  if valid_598356 != nil:
    section.add "key", valid_598356
  var valid_598357 = query.getOrDefault("prettyPrint")
  valid_598357 = validateParameter(valid_598357, JBool, required = false,
                                 default = newJBool(true))
  if valid_598357 != nil:
    section.add "prettyPrint", valid_598357
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

proc call*(call_598359: Call_BigqueryTablesPatch_598345; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates information in an existing table. The update method replaces the entire table resource, whereas the patch method only replaces fields that are provided in the submitted table resource. This method supports patch semantics.
  ## 
  let valid = call_598359.validator(path, query, header, formData, body)
  let scheme = call_598359.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598359.url(scheme.get, call_598359.host, call_598359.base,
                         call_598359.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598359, url, valid)

proc call*(call_598360: Call_BigqueryTablesPatch_598345; tableId: string;
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
  var path_598361 = newJObject()
  var query_598362 = newJObject()
  var body_598363 = newJObject()
  add(path_598361, "tableId", newJString(tableId))
  add(query_598362, "fields", newJString(fields))
  add(query_598362, "quotaUser", newJString(quotaUser))
  add(query_598362, "alt", newJString(alt))
  add(query_598362, "oauth_token", newJString(oauthToken))
  add(query_598362, "userIp", newJString(userIp))
  add(path_598361, "datasetId", newJString(datasetId))
  add(query_598362, "key", newJString(key))
  add(path_598361, "projectId", newJString(projectId))
  if body != nil:
    body_598363 = body
  add(query_598362, "prettyPrint", newJBool(prettyPrint))
  result = call_598360.call(path_598361, query_598362, nil, nil, body_598363)

var bigqueryTablesPatch* = Call_BigqueryTablesPatch_598345(
    name: "bigqueryTablesPatch", meth: HttpMethod.HttpPatch,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/tables/{tableId}",
    validator: validate_BigqueryTablesPatch_598346, base: "/bigquery/v2",
    url: url_BigqueryTablesPatch_598347, schemes: {Scheme.Https})
type
  Call_BigqueryTablesDelete_598328 = ref object of OpenApiRestCall_597437
proc url_BigqueryTablesDelete_598330(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigqueryTablesDelete_598329(path: JsonNode; query: JsonNode;
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
  var valid_598331 = path.getOrDefault("tableId")
  valid_598331 = validateParameter(valid_598331, JString, required = true,
                                 default = nil)
  if valid_598331 != nil:
    section.add "tableId", valid_598331
  var valid_598332 = path.getOrDefault("datasetId")
  valid_598332 = validateParameter(valid_598332, JString, required = true,
                                 default = nil)
  if valid_598332 != nil:
    section.add "datasetId", valid_598332
  var valid_598333 = path.getOrDefault("projectId")
  valid_598333 = validateParameter(valid_598333, JString, required = true,
                                 default = nil)
  if valid_598333 != nil:
    section.add "projectId", valid_598333
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
  var valid_598334 = query.getOrDefault("fields")
  valid_598334 = validateParameter(valid_598334, JString, required = false,
                                 default = nil)
  if valid_598334 != nil:
    section.add "fields", valid_598334
  var valid_598335 = query.getOrDefault("quotaUser")
  valid_598335 = validateParameter(valid_598335, JString, required = false,
                                 default = nil)
  if valid_598335 != nil:
    section.add "quotaUser", valid_598335
  var valid_598336 = query.getOrDefault("alt")
  valid_598336 = validateParameter(valid_598336, JString, required = false,
                                 default = newJString("json"))
  if valid_598336 != nil:
    section.add "alt", valid_598336
  var valid_598337 = query.getOrDefault("oauth_token")
  valid_598337 = validateParameter(valid_598337, JString, required = false,
                                 default = nil)
  if valid_598337 != nil:
    section.add "oauth_token", valid_598337
  var valid_598338 = query.getOrDefault("userIp")
  valid_598338 = validateParameter(valid_598338, JString, required = false,
                                 default = nil)
  if valid_598338 != nil:
    section.add "userIp", valid_598338
  var valid_598339 = query.getOrDefault("key")
  valid_598339 = validateParameter(valid_598339, JString, required = false,
                                 default = nil)
  if valid_598339 != nil:
    section.add "key", valid_598339
  var valid_598340 = query.getOrDefault("prettyPrint")
  valid_598340 = validateParameter(valid_598340, JBool, required = false,
                                 default = newJBool(true))
  if valid_598340 != nil:
    section.add "prettyPrint", valid_598340
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598341: Call_BigqueryTablesDelete_598328; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the table specified by tableId from the dataset. If the table contains data, all the data will be deleted.
  ## 
  let valid = call_598341.validator(path, query, header, formData, body)
  let scheme = call_598341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598341.url(scheme.get, call_598341.host, call_598341.base,
                         call_598341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598341, url, valid)

proc call*(call_598342: Call_BigqueryTablesDelete_598328; tableId: string;
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
  var path_598343 = newJObject()
  var query_598344 = newJObject()
  add(path_598343, "tableId", newJString(tableId))
  add(query_598344, "fields", newJString(fields))
  add(query_598344, "quotaUser", newJString(quotaUser))
  add(query_598344, "alt", newJString(alt))
  add(query_598344, "oauth_token", newJString(oauthToken))
  add(query_598344, "userIp", newJString(userIp))
  add(path_598343, "datasetId", newJString(datasetId))
  add(query_598344, "key", newJString(key))
  add(path_598343, "projectId", newJString(projectId))
  add(query_598344, "prettyPrint", newJBool(prettyPrint))
  result = call_598342.call(path_598343, query_598344, nil, nil, nil)

var bigqueryTablesDelete* = Call_BigqueryTablesDelete_598328(
    name: "bigqueryTablesDelete", meth: HttpMethod.HttpDelete,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/tables/{tableId}",
    validator: validate_BigqueryTablesDelete_598329, base: "/bigquery/v2",
    url: url_BigqueryTablesDelete_598330, schemes: {Scheme.Https})
type
  Call_BigqueryTabledataList_598364 = ref object of OpenApiRestCall_597437
proc url_BigqueryTabledataList_598366(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigqueryTabledataList_598365(path: JsonNode; query: JsonNode;
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
  var valid_598367 = path.getOrDefault("tableId")
  valid_598367 = validateParameter(valid_598367, JString, required = true,
                                 default = nil)
  if valid_598367 != nil:
    section.add "tableId", valid_598367
  var valid_598368 = path.getOrDefault("datasetId")
  valid_598368 = validateParameter(valid_598368, JString, required = true,
                                 default = nil)
  if valid_598368 != nil:
    section.add "datasetId", valid_598368
  var valid_598369 = path.getOrDefault("projectId")
  valid_598369 = validateParameter(valid_598369, JString, required = true,
                                 default = nil)
  if valid_598369 != nil:
    section.add "projectId", valid_598369
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
  var valid_598370 = query.getOrDefault("fields")
  valid_598370 = validateParameter(valid_598370, JString, required = false,
                                 default = nil)
  if valid_598370 != nil:
    section.add "fields", valid_598370
  var valid_598371 = query.getOrDefault("pageToken")
  valid_598371 = validateParameter(valid_598371, JString, required = false,
                                 default = nil)
  if valid_598371 != nil:
    section.add "pageToken", valid_598371
  var valid_598372 = query.getOrDefault("quotaUser")
  valid_598372 = validateParameter(valid_598372, JString, required = false,
                                 default = nil)
  if valid_598372 != nil:
    section.add "quotaUser", valid_598372
  var valid_598373 = query.getOrDefault("alt")
  valid_598373 = validateParameter(valid_598373, JString, required = false,
                                 default = newJString("json"))
  if valid_598373 != nil:
    section.add "alt", valid_598373
  var valid_598374 = query.getOrDefault("oauth_token")
  valid_598374 = validateParameter(valid_598374, JString, required = false,
                                 default = nil)
  if valid_598374 != nil:
    section.add "oauth_token", valid_598374
  var valid_598375 = query.getOrDefault("userIp")
  valid_598375 = validateParameter(valid_598375, JString, required = false,
                                 default = nil)
  if valid_598375 != nil:
    section.add "userIp", valid_598375
  var valid_598376 = query.getOrDefault("maxResults")
  valid_598376 = validateParameter(valid_598376, JInt, required = false, default = nil)
  if valid_598376 != nil:
    section.add "maxResults", valid_598376
  var valid_598377 = query.getOrDefault("key")
  valid_598377 = validateParameter(valid_598377, JString, required = false,
                                 default = nil)
  if valid_598377 != nil:
    section.add "key", valid_598377
  var valid_598378 = query.getOrDefault("prettyPrint")
  valid_598378 = validateParameter(valid_598378, JBool, required = false,
                                 default = newJBool(true))
  if valid_598378 != nil:
    section.add "prettyPrint", valid_598378
  var valid_598379 = query.getOrDefault("selectedFields")
  valid_598379 = validateParameter(valid_598379, JString, required = false,
                                 default = nil)
  if valid_598379 != nil:
    section.add "selectedFields", valid_598379
  var valid_598380 = query.getOrDefault("startIndex")
  valid_598380 = validateParameter(valid_598380, JString, required = false,
                                 default = nil)
  if valid_598380 != nil:
    section.add "startIndex", valid_598380
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598381: Call_BigqueryTabledataList_598364; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves table data from a specified set of rows. Requires the READER dataset role.
  ## 
  let valid = call_598381.validator(path, query, header, formData, body)
  let scheme = call_598381.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598381.url(scheme.get, call_598381.host, call_598381.base,
                         call_598381.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598381, url, valid)

proc call*(call_598382: Call_BigqueryTabledataList_598364; tableId: string;
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
  var path_598383 = newJObject()
  var query_598384 = newJObject()
  add(path_598383, "tableId", newJString(tableId))
  add(query_598384, "fields", newJString(fields))
  add(query_598384, "pageToken", newJString(pageToken))
  add(query_598384, "quotaUser", newJString(quotaUser))
  add(query_598384, "alt", newJString(alt))
  add(query_598384, "oauth_token", newJString(oauthToken))
  add(query_598384, "userIp", newJString(userIp))
  add(path_598383, "datasetId", newJString(datasetId))
  add(query_598384, "maxResults", newJInt(maxResults))
  add(query_598384, "key", newJString(key))
  add(path_598383, "projectId", newJString(projectId))
  add(query_598384, "prettyPrint", newJBool(prettyPrint))
  add(query_598384, "selectedFields", newJString(selectedFields))
  add(query_598384, "startIndex", newJString(startIndex))
  result = call_598382.call(path_598383, query_598384, nil, nil, nil)

var bigqueryTabledataList* = Call_BigqueryTabledataList_598364(
    name: "bigqueryTabledataList", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/datasets/{datasetId}/tables/{tableId}/data",
    validator: validate_BigqueryTabledataList_598365, base: "/bigquery/v2",
    url: url_BigqueryTabledataList_598366, schemes: {Scheme.Https})
type
  Call_BigqueryTabledataInsertAll_598385 = ref object of OpenApiRestCall_597437
proc url_BigqueryTabledataInsertAll_598387(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigqueryTabledataInsertAll_598386(path: JsonNode; query: JsonNode;
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
  var valid_598388 = path.getOrDefault("tableId")
  valid_598388 = validateParameter(valid_598388, JString, required = true,
                                 default = nil)
  if valid_598388 != nil:
    section.add "tableId", valid_598388
  var valid_598389 = path.getOrDefault("datasetId")
  valid_598389 = validateParameter(valid_598389, JString, required = true,
                                 default = nil)
  if valid_598389 != nil:
    section.add "datasetId", valid_598389
  var valid_598390 = path.getOrDefault("projectId")
  valid_598390 = validateParameter(valid_598390, JString, required = true,
                                 default = nil)
  if valid_598390 != nil:
    section.add "projectId", valid_598390
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
  var valid_598391 = query.getOrDefault("fields")
  valid_598391 = validateParameter(valid_598391, JString, required = false,
                                 default = nil)
  if valid_598391 != nil:
    section.add "fields", valid_598391
  var valid_598392 = query.getOrDefault("quotaUser")
  valid_598392 = validateParameter(valid_598392, JString, required = false,
                                 default = nil)
  if valid_598392 != nil:
    section.add "quotaUser", valid_598392
  var valid_598393 = query.getOrDefault("alt")
  valid_598393 = validateParameter(valid_598393, JString, required = false,
                                 default = newJString("json"))
  if valid_598393 != nil:
    section.add "alt", valid_598393
  var valid_598394 = query.getOrDefault("oauth_token")
  valid_598394 = validateParameter(valid_598394, JString, required = false,
                                 default = nil)
  if valid_598394 != nil:
    section.add "oauth_token", valid_598394
  var valid_598395 = query.getOrDefault("userIp")
  valid_598395 = validateParameter(valid_598395, JString, required = false,
                                 default = nil)
  if valid_598395 != nil:
    section.add "userIp", valid_598395
  var valid_598396 = query.getOrDefault("key")
  valid_598396 = validateParameter(valid_598396, JString, required = false,
                                 default = nil)
  if valid_598396 != nil:
    section.add "key", valid_598396
  var valid_598397 = query.getOrDefault("prettyPrint")
  valid_598397 = validateParameter(valid_598397, JBool, required = false,
                                 default = newJBool(true))
  if valid_598397 != nil:
    section.add "prettyPrint", valid_598397
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

proc call*(call_598399: Call_BigqueryTabledataInsertAll_598385; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Streams data into BigQuery one record at a time without needing to run a load job. Requires the WRITER dataset role.
  ## 
  let valid = call_598399.validator(path, query, header, formData, body)
  let scheme = call_598399.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598399.url(scheme.get, call_598399.host, call_598399.base,
                         call_598399.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598399, url, valid)

proc call*(call_598400: Call_BigqueryTabledataInsertAll_598385; tableId: string;
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
  var path_598401 = newJObject()
  var query_598402 = newJObject()
  var body_598403 = newJObject()
  add(path_598401, "tableId", newJString(tableId))
  add(query_598402, "fields", newJString(fields))
  add(query_598402, "quotaUser", newJString(quotaUser))
  add(query_598402, "alt", newJString(alt))
  add(query_598402, "oauth_token", newJString(oauthToken))
  add(query_598402, "userIp", newJString(userIp))
  add(path_598401, "datasetId", newJString(datasetId))
  add(query_598402, "key", newJString(key))
  add(path_598401, "projectId", newJString(projectId))
  if body != nil:
    body_598403 = body
  add(query_598402, "prettyPrint", newJBool(prettyPrint))
  result = call_598400.call(path_598401, query_598402, nil, nil, body_598403)

var bigqueryTabledataInsertAll* = Call_BigqueryTabledataInsertAll_598385(
    name: "bigqueryTabledataInsertAll", meth: HttpMethod.HttpPost,
    host: "bigquery.googleapis.com", route: "/projects/{projectId}/datasets/{datasetId}/tables/{tableId}/insertAll",
    validator: validate_BigqueryTabledataInsertAll_598386, base: "/bigquery/v2",
    url: url_BigqueryTabledataInsertAll_598387, schemes: {Scheme.Https})
type
  Call_BigqueryJobsInsert_598427 = ref object of OpenApiRestCall_597437
proc url_BigqueryJobsInsert_598429(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigqueryJobsInsert_598428(path: JsonNode; query: JsonNode;
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
  var valid_598430 = path.getOrDefault("projectId")
  valid_598430 = validateParameter(valid_598430, JString, required = true,
                                 default = nil)
  if valid_598430 != nil:
    section.add "projectId", valid_598430
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
  var valid_598431 = query.getOrDefault("fields")
  valid_598431 = validateParameter(valid_598431, JString, required = false,
                                 default = nil)
  if valid_598431 != nil:
    section.add "fields", valid_598431
  var valid_598432 = query.getOrDefault("quotaUser")
  valid_598432 = validateParameter(valid_598432, JString, required = false,
                                 default = nil)
  if valid_598432 != nil:
    section.add "quotaUser", valid_598432
  var valid_598433 = query.getOrDefault("alt")
  valid_598433 = validateParameter(valid_598433, JString, required = false,
                                 default = newJString("json"))
  if valid_598433 != nil:
    section.add "alt", valid_598433
  var valid_598434 = query.getOrDefault("oauth_token")
  valid_598434 = validateParameter(valid_598434, JString, required = false,
                                 default = nil)
  if valid_598434 != nil:
    section.add "oauth_token", valid_598434
  var valid_598435 = query.getOrDefault("userIp")
  valid_598435 = validateParameter(valid_598435, JString, required = false,
                                 default = nil)
  if valid_598435 != nil:
    section.add "userIp", valid_598435
  var valid_598436 = query.getOrDefault("key")
  valid_598436 = validateParameter(valid_598436, JString, required = false,
                                 default = nil)
  if valid_598436 != nil:
    section.add "key", valid_598436
  var valid_598437 = query.getOrDefault("prettyPrint")
  valid_598437 = validateParameter(valid_598437, JBool, required = false,
                                 default = newJBool(true))
  if valid_598437 != nil:
    section.add "prettyPrint", valid_598437
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

proc call*(call_598439: Call_BigqueryJobsInsert_598427; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a new asynchronous job. Requires the Can View project role.
  ## 
  let valid = call_598439.validator(path, query, header, formData, body)
  let scheme = call_598439.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598439.url(scheme.get, call_598439.host, call_598439.base,
                         call_598439.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598439, url, valid)

proc call*(call_598440: Call_BigqueryJobsInsert_598427; projectId: string;
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
  var path_598441 = newJObject()
  var query_598442 = newJObject()
  var body_598443 = newJObject()
  add(query_598442, "fields", newJString(fields))
  add(query_598442, "quotaUser", newJString(quotaUser))
  add(query_598442, "alt", newJString(alt))
  add(query_598442, "oauth_token", newJString(oauthToken))
  add(query_598442, "userIp", newJString(userIp))
  add(query_598442, "key", newJString(key))
  add(path_598441, "projectId", newJString(projectId))
  if body != nil:
    body_598443 = body
  add(query_598442, "prettyPrint", newJBool(prettyPrint))
  result = call_598440.call(path_598441, query_598442, nil, nil, body_598443)

var bigqueryJobsInsert* = Call_BigqueryJobsInsert_598427(
    name: "bigqueryJobsInsert", meth: HttpMethod.HttpPost,
    host: "bigquery.googleapis.com", route: "/projects/{projectId}/jobs",
    validator: validate_BigqueryJobsInsert_598428, base: "/bigquery/v2",
    url: url_BigqueryJobsInsert_598429, schemes: {Scheme.Https})
type
  Call_BigqueryJobsList_598404 = ref object of OpenApiRestCall_597437
proc url_BigqueryJobsList_598406(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigqueryJobsList_598405(path: JsonNode; query: JsonNode;
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
  var valid_598407 = path.getOrDefault("projectId")
  valid_598407 = validateParameter(valid_598407, JString, required = true,
                                 default = nil)
  if valid_598407 != nil:
    section.add "projectId", valid_598407
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
  var valid_598408 = query.getOrDefault("fields")
  valid_598408 = validateParameter(valid_598408, JString, required = false,
                                 default = nil)
  if valid_598408 != nil:
    section.add "fields", valid_598408
  var valid_598409 = query.getOrDefault("pageToken")
  valid_598409 = validateParameter(valid_598409, JString, required = false,
                                 default = nil)
  if valid_598409 != nil:
    section.add "pageToken", valid_598409
  var valid_598410 = query.getOrDefault("quotaUser")
  valid_598410 = validateParameter(valid_598410, JString, required = false,
                                 default = nil)
  if valid_598410 != nil:
    section.add "quotaUser", valid_598410
  var valid_598411 = query.getOrDefault("alt")
  valid_598411 = validateParameter(valid_598411, JString, required = false,
                                 default = newJString("json"))
  if valid_598411 != nil:
    section.add "alt", valid_598411
  var valid_598412 = query.getOrDefault("parentJobId")
  valid_598412 = validateParameter(valid_598412, JString, required = false,
                                 default = nil)
  if valid_598412 != nil:
    section.add "parentJobId", valid_598412
  var valid_598413 = query.getOrDefault("oauth_token")
  valid_598413 = validateParameter(valid_598413, JString, required = false,
                                 default = nil)
  if valid_598413 != nil:
    section.add "oauth_token", valid_598413
  var valid_598414 = query.getOrDefault("userIp")
  valid_598414 = validateParameter(valid_598414, JString, required = false,
                                 default = nil)
  if valid_598414 != nil:
    section.add "userIp", valid_598414
  var valid_598415 = query.getOrDefault("maxResults")
  valid_598415 = validateParameter(valid_598415, JInt, required = false, default = nil)
  if valid_598415 != nil:
    section.add "maxResults", valid_598415
  var valid_598416 = query.getOrDefault("key")
  valid_598416 = validateParameter(valid_598416, JString, required = false,
                                 default = nil)
  if valid_598416 != nil:
    section.add "key", valid_598416
  var valid_598417 = query.getOrDefault("allUsers")
  valid_598417 = validateParameter(valid_598417, JBool, required = false, default = nil)
  if valid_598417 != nil:
    section.add "allUsers", valid_598417
  var valid_598418 = query.getOrDefault("projection")
  valid_598418 = validateParameter(valid_598418, JString, required = false,
                                 default = newJString("full"))
  if valid_598418 != nil:
    section.add "projection", valid_598418
  var valid_598419 = query.getOrDefault("minCreationTime")
  valid_598419 = validateParameter(valid_598419, JString, required = false,
                                 default = nil)
  if valid_598419 != nil:
    section.add "minCreationTime", valid_598419
  var valid_598420 = query.getOrDefault("maxCreationTime")
  valid_598420 = validateParameter(valid_598420, JString, required = false,
                                 default = nil)
  if valid_598420 != nil:
    section.add "maxCreationTime", valid_598420
  var valid_598421 = query.getOrDefault("prettyPrint")
  valid_598421 = validateParameter(valid_598421, JBool, required = false,
                                 default = newJBool(true))
  if valid_598421 != nil:
    section.add "prettyPrint", valid_598421
  var valid_598422 = query.getOrDefault("stateFilter")
  valid_598422 = validateParameter(valid_598422, JArray, required = false,
                                 default = nil)
  if valid_598422 != nil:
    section.add "stateFilter", valid_598422
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598423: Call_BigqueryJobsList_598404; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all jobs that you started in the specified project. Job information is available for a six month period after creation. The job list is sorted in reverse chronological order, by job creation time. Requires the Can View project role, or the Is Owner project role if you set the allUsers property.
  ## 
  let valid = call_598423.validator(path, query, header, formData, body)
  let scheme = call_598423.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598423.url(scheme.get, call_598423.host, call_598423.base,
                         call_598423.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598423, url, valid)

proc call*(call_598424: Call_BigqueryJobsList_598404; projectId: string;
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
  var path_598425 = newJObject()
  var query_598426 = newJObject()
  add(query_598426, "fields", newJString(fields))
  add(query_598426, "pageToken", newJString(pageToken))
  add(query_598426, "quotaUser", newJString(quotaUser))
  add(query_598426, "alt", newJString(alt))
  add(query_598426, "parentJobId", newJString(parentJobId))
  add(query_598426, "oauth_token", newJString(oauthToken))
  add(query_598426, "userIp", newJString(userIp))
  add(query_598426, "maxResults", newJInt(maxResults))
  add(query_598426, "key", newJString(key))
  add(query_598426, "allUsers", newJBool(allUsers))
  add(path_598425, "projectId", newJString(projectId))
  add(query_598426, "projection", newJString(projection))
  add(query_598426, "minCreationTime", newJString(minCreationTime))
  add(query_598426, "maxCreationTime", newJString(maxCreationTime))
  add(query_598426, "prettyPrint", newJBool(prettyPrint))
  if stateFilter != nil:
    query_598426.add "stateFilter", stateFilter
  result = call_598424.call(path_598425, query_598426, nil, nil, nil)

var bigqueryJobsList* = Call_BigqueryJobsList_598404(name: "bigqueryJobsList",
    meth: HttpMethod.HttpGet, host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/jobs", validator: validate_BigqueryJobsList_598405,
    base: "/bigquery/v2", url: url_BigqueryJobsList_598406, schemes: {Scheme.Https})
type
  Call_BigqueryJobsGet_598444 = ref object of OpenApiRestCall_597437
proc url_BigqueryJobsGet_598446(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigqueryJobsGet_598445(path: JsonNode; query: JsonNode;
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
  var valid_598447 = path.getOrDefault("jobId")
  valid_598447 = validateParameter(valid_598447, JString, required = true,
                                 default = nil)
  if valid_598447 != nil:
    section.add "jobId", valid_598447
  var valid_598448 = path.getOrDefault("projectId")
  valid_598448 = validateParameter(valid_598448, JString, required = true,
                                 default = nil)
  if valid_598448 != nil:
    section.add "projectId", valid_598448
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
  var valid_598449 = query.getOrDefault("fields")
  valid_598449 = validateParameter(valid_598449, JString, required = false,
                                 default = nil)
  if valid_598449 != nil:
    section.add "fields", valid_598449
  var valid_598450 = query.getOrDefault("quotaUser")
  valid_598450 = validateParameter(valid_598450, JString, required = false,
                                 default = nil)
  if valid_598450 != nil:
    section.add "quotaUser", valid_598450
  var valid_598451 = query.getOrDefault("alt")
  valid_598451 = validateParameter(valid_598451, JString, required = false,
                                 default = newJString("json"))
  if valid_598451 != nil:
    section.add "alt", valid_598451
  var valid_598452 = query.getOrDefault("oauth_token")
  valid_598452 = validateParameter(valid_598452, JString, required = false,
                                 default = nil)
  if valid_598452 != nil:
    section.add "oauth_token", valid_598452
  var valid_598453 = query.getOrDefault("userIp")
  valid_598453 = validateParameter(valid_598453, JString, required = false,
                                 default = nil)
  if valid_598453 != nil:
    section.add "userIp", valid_598453
  var valid_598454 = query.getOrDefault("location")
  valid_598454 = validateParameter(valid_598454, JString, required = false,
                                 default = nil)
  if valid_598454 != nil:
    section.add "location", valid_598454
  var valid_598455 = query.getOrDefault("key")
  valid_598455 = validateParameter(valid_598455, JString, required = false,
                                 default = nil)
  if valid_598455 != nil:
    section.add "key", valid_598455
  var valid_598456 = query.getOrDefault("prettyPrint")
  valid_598456 = validateParameter(valid_598456, JBool, required = false,
                                 default = newJBool(true))
  if valid_598456 != nil:
    section.add "prettyPrint", valid_598456
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598457: Call_BigqueryJobsGet_598444; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns information about a specific job. Job information is available for a six month period after creation. Requires that you're the person who ran the job, or have the Is Owner project role.
  ## 
  let valid = call_598457.validator(path, query, header, formData, body)
  let scheme = call_598457.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598457.url(scheme.get, call_598457.host, call_598457.base,
                         call_598457.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598457, url, valid)

proc call*(call_598458: Call_BigqueryJobsGet_598444; jobId: string;
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
  var path_598459 = newJObject()
  var query_598460 = newJObject()
  add(query_598460, "fields", newJString(fields))
  add(query_598460, "quotaUser", newJString(quotaUser))
  add(query_598460, "alt", newJString(alt))
  add(path_598459, "jobId", newJString(jobId))
  add(query_598460, "oauth_token", newJString(oauthToken))
  add(query_598460, "userIp", newJString(userIp))
  add(query_598460, "location", newJString(location))
  add(query_598460, "key", newJString(key))
  add(path_598459, "projectId", newJString(projectId))
  add(query_598460, "prettyPrint", newJBool(prettyPrint))
  result = call_598458.call(path_598459, query_598460, nil, nil, nil)

var bigqueryJobsGet* = Call_BigqueryJobsGet_598444(name: "bigqueryJobsGet",
    meth: HttpMethod.HttpGet, host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/jobs/{jobId}",
    validator: validate_BigqueryJobsGet_598445, base: "/bigquery/v2",
    url: url_BigqueryJobsGet_598446, schemes: {Scheme.Https})
type
  Call_BigqueryJobsCancel_598461 = ref object of OpenApiRestCall_597437
proc url_BigqueryJobsCancel_598463(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigqueryJobsCancel_598462(path: JsonNode; query: JsonNode;
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
  var valid_598464 = path.getOrDefault("jobId")
  valid_598464 = validateParameter(valid_598464, JString, required = true,
                                 default = nil)
  if valid_598464 != nil:
    section.add "jobId", valid_598464
  var valid_598465 = path.getOrDefault("projectId")
  valid_598465 = validateParameter(valid_598465, JString, required = true,
                                 default = nil)
  if valid_598465 != nil:
    section.add "projectId", valid_598465
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
  var valid_598466 = query.getOrDefault("fields")
  valid_598466 = validateParameter(valid_598466, JString, required = false,
                                 default = nil)
  if valid_598466 != nil:
    section.add "fields", valid_598466
  var valid_598467 = query.getOrDefault("quotaUser")
  valid_598467 = validateParameter(valid_598467, JString, required = false,
                                 default = nil)
  if valid_598467 != nil:
    section.add "quotaUser", valid_598467
  var valid_598468 = query.getOrDefault("alt")
  valid_598468 = validateParameter(valid_598468, JString, required = false,
                                 default = newJString("json"))
  if valid_598468 != nil:
    section.add "alt", valid_598468
  var valid_598469 = query.getOrDefault("oauth_token")
  valid_598469 = validateParameter(valid_598469, JString, required = false,
                                 default = nil)
  if valid_598469 != nil:
    section.add "oauth_token", valid_598469
  var valid_598470 = query.getOrDefault("userIp")
  valid_598470 = validateParameter(valid_598470, JString, required = false,
                                 default = nil)
  if valid_598470 != nil:
    section.add "userIp", valid_598470
  var valid_598471 = query.getOrDefault("location")
  valid_598471 = validateParameter(valid_598471, JString, required = false,
                                 default = nil)
  if valid_598471 != nil:
    section.add "location", valid_598471
  var valid_598472 = query.getOrDefault("key")
  valid_598472 = validateParameter(valid_598472, JString, required = false,
                                 default = nil)
  if valid_598472 != nil:
    section.add "key", valid_598472
  var valid_598473 = query.getOrDefault("prettyPrint")
  valid_598473 = validateParameter(valid_598473, JBool, required = false,
                                 default = newJBool(true))
  if valid_598473 != nil:
    section.add "prettyPrint", valid_598473
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598474: Call_BigqueryJobsCancel_598461; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Requests that a job be cancelled. This call will return immediately, and the client will need to poll for the job status to see if the cancel completed successfully. Cancelled jobs may still incur costs.
  ## 
  let valid = call_598474.validator(path, query, header, formData, body)
  let scheme = call_598474.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598474.url(scheme.get, call_598474.host, call_598474.base,
                         call_598474.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598474, url, valid)

proc call*(call_598475: Call_BigqueryJobsCancel_598461; jobId: string;
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
  var path_598476 = newJObject()
  var query_598477 = newJObject()
  add(query_598477, "fields", newJString(fields))
  add(query_598477, "quotaUser", newJString(quotaUser))
  add(query_598477, "alt", newJString(alt))
  add(path_598476, "jobId", newJString(jobId))
  add(query_598477, "oauth_token", newJString(oauthToken))
  add(query_598477, "userIp", newJString(userIp))
  add(query_598477, "location", newJString(location))
  add(query_598477, "key", newJString(key))
  add(path_598476, "projectId", newJString(projectId))
  add(query_598477, "prettyPrint", newJBool(prettyPrint))
  result = call_598475.call(path_598476, query_598477, nil, nil, nil)

var bigqueryJobsCancel* = Call_BigqueryJobsCancel_598461(
    name: "bigqueryJobsCancel", meth: HttpMethod.HttpPost,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/jobs/{jobId}/cancel",
    validator: validate_BigqueryJobsCancel_598462, base: "/bigquery/v2",
    url: url_BigqueryJobsCancel_598463, schemes: {Scheme.Https})
type
  Call_BigqueryJobsQuery_598478 = ref object of OpenApiRestCall_597437
proc url_BigqueryJobsQuery_598480(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigqueryJobsQuery_598479(path: JsonNode; query: JsonNode;
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
  var valid_598481 = path.getOrDefault("projectId")
  valid_598481 = validateParameter(valid_598481, JString, required = true,
                                 default = nil)
  if valid_598481 != nil:
    section.add "projectId", valid_598481
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
  var valid_598482 = query.getOrDefault("fields")
  valid_598482 = validateParameter(valid_598482, JString, required = false,
                                 default = nil)
  if valid_598482 != nil:
    section.add "fields", valid_598482
  var valid_598483 = query.getOrDefault("quotaUser")
  valid_598483 = validateParameter(valid_598483, JString, required = false,
                                 default = nil)
  if valid_598483 != nil:
    section.add "quotaUser", valid_598483
  var valid_598484 = query.getOrDefault("alt")
  valid_598484 = validateParameter(valid_598484, JString, required = false,
                                 default = newJString("json"))
  if valid_598484 != nil:
    section.add "alt", valid_598484
  var valid_598485 = query.getOrDefault("oauth_token")
  valid_598485 = validateParameter(valid_598485, JString, required = false,
                                 default = nil)
  if valid_598485 != nil:
    section.add "oauth_token", valid_598485
  var valid_598486 = query.getOrDefault("userIp")
  valid_598486 = validateParameter(valid_598486, JString, required = false,
                                 default = nil)
  if valid_598486 != nil:
    section.add "userIp", valid_598486
  var valid_598487 = query.getOrDefault("key")
  valid_598487 = validateParameter(valid_598487, JString, required = false,
                                 default = nil)
  if valid_598487 != nil:
    section.add "key", valid_598487
  var valid_598488 = query.getOrDefault("prettyPrint")
  valid_598488 = validateParameter(valid_598488, JBool, required = false,
                                 default = newJBool(true))
  if valid_598488 != nil:
    section.add "prettyPrint", valid_598488
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

proc call*(call_598490: Call_BigqueryJobsQuery_598478; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Runs a BigQuery SQL query synchronously and returns query results if the query completes within a specified timeout.
  ## 
  let valid = call_598490.validator(path, query, header, formData, body)
  let scheme = call_598490.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598490.url(scheme.get, call_598490.host, call_598490.base,
                         call_598490.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598490, url, valid)

proc call*(call_598491: Call_BigqueryJobsQuery_598478; projectId: string;
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
  var path_598492 = newJObject()
  var query_598493 = newJObject()
  var body_598494 = newJObject()
  add(query_598493, "fields", newJString(fields))
  add(query_598493, "quotaUser", newJString(quotaUser))
  add(query_598493, "alt", newJString(alt))
  add(query_598493, "oauth_token", newJString(oauthToken))
  add(query_598493, "userIp", newJString(userIp))
  add(query_598493, "key", newJString(key))
  add(path_598492, "projectId", newJString(projectId))
  if body != nil:
    body_598494 = body
  add(query_598493, "prettyPrint", newJBool(prettyPrint))
  result = call_598491.call(path_598492, query_598493, nil, nil, body_598494)

var bigqueryJobsQuery* = Call_BigqueryJobsQuery_598478(name: "bigqueryJobsQuery",
    meth: HttpMethod.HttpPost, host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/queries", validator: validate_BigqueryJobsQuery_598479,
    base: "/bigquery/v2", url: url_BigqueryJobsQuery_598480, schemes: {Scheme.Https})
type
  Call_BigqueryJobsGetQueryResults_598495 = ref object of OpenApiRestCall_597437
proc url_BigqueryJobsGetQueryResults_598497(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigqueryJobsGetQueryResults_598496(path: JsonNode; query: JsonNode;
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
  var valid_598498 = path.getOrDefault("jobId")
  valid_598498 = validateParameter(valid_598498, JString, required = true,
                                 default = nil)
  if valid_598498 != nil:
    section.add "jobId", valid_598498
  var valid_598499 = path.getOrDefault("projectId")
  valid_598499 = validateParameter(valid_598499, JString, required = true,
                                 default = nil)
  if valid_598499 != nil:
    section.add "projectId", valid_598499
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
  var valid_598500 = query.getOrDefault("fields")
  valid_598500 = validateParameter(valid_598500, JString, required = false,
                                 default = nil)
  if valid_598500 != nil:
    section.add "fields", valid_598500
  var valid_598501 = query.getOrDefault("pageToken")
  valid_598501 = validateParameter(valid_598501, JString, required = false,
                                 default = nil)
  if valid_598501 != nil:
    section.add "pageToken", valid_598501
  var valid_598502 = query.getOrDefault("quotaUser")
  valid_598502 = validateParameter(valid_598502, JString, required = false,
                                 default = nil)
  if valid_598502 != nil:
    section.add "quotaUser", valid_598502
  var valid_598503 = query.getOrDefault("alt")
  valid_598503 = validateParameter(valid_598503, JString, required = false,
                                 default = newJString("json"))
  if valid_598503 != nil:
    section.add "alt", valid_598503
  var valid_598504 = query.getOrDefault("oauth_token")
  valid_598504 = validateParameter(valid_598504, JString, required = false,
                                 default = nil)
  if valid_598504 != nil:
    section.add "oauth_token", valid_598504
  var valid_598505 = query.getOrDefault("userIp")
  valid_598505 = validateParameter(valid_598505, JString, required = false,
                                 default = nil)
  if valid_598505 != nil:
    section.add "userIp", valid_598505
  var valid_598506 = query.getOrDefault("location")
  valid_598506 = validateParameter(valid_598506, JString, required = false,
                                 default = nil)
  if valid_598506 != nil:
    section.add "location", valid_598506
  var valid_598507 = query.getOrDefault("maxResults")
  valid_598507 = validateParameter(valid_598507, JInt, required = false, default = nil)
  if valid_598507 != nil:
    section.add "maxResults", valid_598507
  var valid_598508 = query.getOrDefault("timeoutMs")
  valid_598508 = validateParameter(valid_598508, JInt, required = false, default = nil)
  if valid_598508 != nil:
    section.add "timeoutMs", valid_598508
  var valid_598509 = query.getOrDefault("key")
  valid_598509 = validateParameter(valid_598509, JString, required = false,
                                 default = nil)
  if valid_598509 != nil:
    section.add "key", valid_598509
  var valid_598510 = query.getOrDefault("prettyPrint")
  valid_598510 = validateParameter(valid_598510, JBool, required = false,
                                 default = newJBool(true))
  if valid_598510 != nil:
    section.add "prettyPrint", valid_598510
  var valid_598511 = query.getOrDefault("startIndex")
  valid_598511 = validateParameter(valid_598511, JString, required = false,
                                 default = nil)
  if valid_598511 != nil:
    section.add "startIndex", valid_598511
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598512: Call_BigqueryJobsGetQueryResults_598495; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the results of a query job.
  ## 
  let valid = call_598512.validator(path, query, header, formData, body)
  let scheme = call_598512.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598512.url(scheme.get, call_598512.host, call_598512.base,
                         call_598512.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598512, url, valid)

proc call*(call_598513: Call_BigqueryJobsGetQueryResults_598495; jobId: string;
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
  var path_598514 = newJObject()
  var query_598515 = newJObject()
  add(query_598515, "fields", newJString(fields))
  add(query_598515, "pageToken", newJString(pageToken))
  add(query_598515, "quotaUser", newJString(quotaUser))
  add(query_598515, "alt", newJString(alt))
  add(path_598514, "jobId", newJString(jobId))
  add(query_598515, "oauth_token", newJString(oauthToken))
  add(query_598515, "userIp", newJString(userIp))
  add(query_598515, "location", newJString(location))
  add(query_598515, "maxResults", newJInt(maxResults))
  add(query_598515, "timeoutMs", newJInt(timeoutMs))
  add(query_598515, "key", newJString(key))
  add(path_598514, "projectId", newJString(projectId))
  add(query_598515, "prettyPrint", newJBool(prettyPrint))
  add(query_598515, "startIndex", newJString(startIndex))
  result = call_598513.call(path_598514, query_598515, nil, nil, nil)

var bigqueryJobsGetQueryResults* = Call_BigqueryJobsGetQueryResults_598495(
    name: "bigqueryJobsGetQueryResults", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/queries/{jobId}",
    validator: validate_BigqueryJobsGetQueryResults_598496, base: "/bigquery/v2",
    url: url_BigqueryJobsGetQueryResults_598497, schemes: {Scheme.Https})
type
  Call_BigqueryProjectsGetServiceAccount_598516 = ref object of OpenApiRestCall_597437
proc url_BigqueryProjectsGetServiceAccount_598518(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BigqueryProjectsGetServiceAccount_598517(path: JsonNode;
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
  var valid_598519 = path.getOrDefault("projectId")
  valid_598519 = validateParameter(valid_598519, JString, required = true,
                                 default = nil)
  if valid_598519 != nil:
    section.add "projectId", valid_598519
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
  var valid_598520 = query.getOrDefault("fields")
  valid_598520 = validateParameter(valid_598520, JString, required = false,
                                 default = nil)
  if valid_598520 != nil:
    section.add "fields", valid_598520
  var valid_598521 = query.getOrDefault("quotaUser")
  valid_598521 = validateParameter(valid_598521, JString, required = false,
                                 default = nil)
  if valid_598521 != nil:
    section.add "quotaUser", valid_598521
  var valid_598522 = query.getOrDefault("alt")
  valid_598522 = validateParameter(valid_598522, JString, required = false,
                                 default = newJString("json"))
  if valid_598522 != nil:
    section.add "alt", valid_598522
  var valid_598523 = query.getOrDefault("oauth_token")
  valid_598523 = validateParameter(valid_598523, JString, required = false,
                                 default = nil)
  if valid_598523 != nil:
    section.add "oauth_token", valid_598523
  var valid_598524 = query.getOrDefault("userIp")
  valid_598524 = validateParameter(valid_598524, JString, required = false,
                                 default = nil)
  if valid_598524 != nil:
    section.add "userIp", valid_598524
  var valid_598525 = query.getOrDefault("key")
  valid_598525 = validateParameter(valid_598525, JString, required = false,
                                 default = nil)
  if valid_598525 != nil:
    section.add "key", valid_598525
  var valid_598526 = query.getOrDefault("prettyPrint")
  valid_598526 = validateParameter(valid_598526, JBool, required = false,
                                 default = newJBool(true))
  if valid_598526 != nil:
    section.add "prettyPrint", valid_598526
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598527: Call_BigqueryProjectsGetServiceAccount_598516;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the email address of the service account for your project used for interactions with Google Cloud KMS.
  ## 
  let valid = call_598527.validator(path, query, header, formData, body)
  let scheme = call_598527.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598527.url(scheme.get, call_598527.host, call_598527.base,
                         call_598527.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598527, url, valid)

proc call*(call_598528: Call_BigqueryProjectsGetServiceAccount_598516;
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
  var path_598529 = newJObject()
  var query_598530 = newJObject()
  add(query_598530, "fields", newJString(fields))
  add(query_598530, "quotaUser", newJString(quotaUser))
  add(query_598530, "alt", newJString(alt))
  add(query_598530, "oauth_token", newJString(oauthToken))
  add(query_598530, "userIp", newJString(userIp))
  add(query_598530, "key", newJString(key))
  add(path_598529, "projectId", newJString(projectId))
  add(query_598530, "prettyPrint", newJBool(prettyPrint))
  result = call_598528.call(path_598529, query_598530, nil, nil, nil)

var bigqueryProjectsGetServiceAccount* = Call_BigqueryProjectsGetServiceAccount_598516(
    name: "bigqueryProjectsGetServiceAccount", meth: HttpMethod.HttpGet,
    host: "bigquery.googleapis.com",
    route: "/projects/{projectId}/serviceAccount",
    validator: validate_BigqueryProjectsGetServiceAccount_598517,
    base: "/bigquery/v2", url: url_BigqueryProjectsGetServiceAccount_598518,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
