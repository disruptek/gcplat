
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google+
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Builds on top of the Google+ platform.
## 
## https://developers.google.com/+/api/
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
  gcpServiceName = "plus"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PlusActivitiesSearch_578625 = ref object of OpenApiRestCall_578355
proc url_PlusActivitiesSearch_578627(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PlusActivitiesSearch_578626(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
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
  ##   orderBy: JString
  ##          : Specifies how to order search results.
  ##   pageToken: JString
  ##            : The continuation token, which is used to page through large result sets. To get the next page of results, set this parameter to the value of "nextPageToken" from the previous response. This token can be of any length.
  ##   query: JString (required)
  ##        : Full-text search query string.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: JString
  ##           : Specify the preferred language to search with. See search language codes for available values.
  ##   maxResults: JInt
  ##             : The maximum number of activities to include in the response, which is used for paging. For any response, the actual number returned might be less than the specified maxResults.
  section = newJObject()
  var valid_578739 = query.getOrDefault("key")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "key", valid_578739
  var valid_578753 = query.getOrDefault("prettyPrint")
  valid_578753 = validateParameter(valid_578753, JBool, required = false,
                                 default = newJBool(true))
  if valid_578753 != nil:
    section.add "prettyPrint", valid_578753
  var valid_578754 = query.getOrDefault("oauth_token")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "oauth_token", valid_578754
  var valid_578755 = query.getOrDefault("alt")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = newJString("json"))
  if valid_578755 != nil:
    section.add "alt", valid_578755
  var valid_578756 = query.getOrDefault("userIp")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = nil)
  if valid_578756 != nil:
    section.add "userIp", valid_578756
  var valid_578757 = query.getOrDefault("quotaUser")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "quotaUser", valid_578757
  var valid_578758 = query.getOrDefault("orderBy")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = newJString("recent"))
  if valid_578758 != nil:
    section.add "orderBy", valid_578758
  var valid_578759 = query.getOrDefault("pageToken")
  valid_578759 = validateParameter(valid_578759, JString, required = false,
                                 default = nil)
  if valid_578759 != nil:
    section.add "pageToken", valid_578759
  assert query != nil, "query argument is necessary due to required `query` field"
  var valid_578760 = query.getOrDefault("query")
  valid_578760 = validateParameter(valid_578760, JString, required = true,
                                 default = nil)
  if valid_578760 != nil:
    section.add "query", valid_578760
  var valid_578761 = query.getOrDefault("fields")
  valid_578761 = validateParameter(valid_578761, JString, required = false,
                                 default = nil)
  if valid_578761 != nil:
    section.add "fields", valid_578761
  var valid_578762 = query.getOrDefault("language")
  valid_578762 = validateParameter(valid_578762, JString, required = false,
                                 default = newJString("en-US"))
  if valid_578762 != nil:
    section.add "language", valid_578762
  var valid_578764 = query.getOrDefault("maxResults")
  valid_578764 = validateParameter(valid_578764, JInt, required = false,
                                 default = newJInt(10))
  if valid_578764 != nil:
    section.add "maxResults", valid_578764
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578787: Call_PlusActivitiesSearch_578625; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_578787.validator(path, query, header, formData, body)
  let scheme = call_578787.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578787.url(scheme.get, call_578787.host, call_578787.base,
                         call_578787.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578787, url, valid)

proc call*(call_578858: Call_PlusActivitiesSearch_578625; query: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          orderBy: string = "recent"; pageToken: string = ""; fields: string = "";
          language: string = "en-US"; maxResults: int = 10): Recallable =
  ## plusActivitiesSearch
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
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
  ##          : Specifies how to order search results.
  ##   pageToken: string
  ##            : The continuation token, which is used to page through large result sets. To get the next page of results, set this parameter to the value of "nextPageToken" from the previous response. This token can be of any length.
  ##   query: string (required)
  ##        : Full-text search query string.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: string
  ##           : Specify the preferred language to search with. See search language codes for available values.
  ##   maxResults: int
  ##             : The maximum number of activities to include in the response, which is used for paging. For any response, the actual number returned might be less than the specified maxResults.
  var query_578859 = newJObject()
  add(query_578859, "key", newJString(key))
  add(query_578859, "prettyPrint", newJBool(prettyPrint))
  add(query_578859, "oauth_token", newJString(oauthToken))
  add(query_578859, "alt", newJString(alt))
  add(query_578859, "userIp", newJString(userIp))
  add(query_578859, "quotaUser", newJString(quotaUser))
  add(query_578859, "orderBy", newJString(orderBy))
  add(query_578859, "pageToken", newJString(pageToken))
  add(query_578859, "query", newJString(query))
  add(query_578859, "fields", newJString(fields))
  add(query_578859, "language", newJString(language))
  add(query_578859, "maxResults", newJInt(maxResults))
  result = call_578858.call(nil, query_578859, nil, nil, nil)

var plusActivitiesSearch* = Call_PlusActivitiesSearch_578625(
    name: "plusActivitiesSearch", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/activities",
    validator: validate_PlusActivitiesSearch_578626, base: "/plus/v1",
    url: url_PlusActivitiesSearch_578627, schemes: {Scheme.Https})
type
  Call_PlusActivitiesGet_578899 = ref object of OpenApiRestCall_578355
proc url_PlusActivitiesGet_578901(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "activityId" in path, "`activityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/activities/"),
               (kind: VariableSegment, value: "activityId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PlusActivitiesGet_578900(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   activityId: JString (required)
  ##             : The ID of the activity to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `activityId` field"
  var valid_578916 = path.getOrDefault("activityId")
  valid_578916 = validateParameter(valid_578916, JString, required = true,
                                 default = nil)
  if valid_578916 != nil:
    section.add "activityId", valid_578916
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
  var valid_578917 = query.getOrDefault("key")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "key", valid_578917
  var valid_578918 = query.getOrDefault("prettyPrint")
  valid_578918 = validateParameter(valid_578918, JBool, required = false,
                                 default = newJBool(true))
  if valid_578918 != nil:
    section.add "prettyPrint", valid_578918
  var valid_578919 = query.getOrDefault("oauth_token")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "oauth_token", valid_578919
  var valid_578920 = query.getOrDefault("alt")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = newJString("json"))
  if valid_578920 != nil:
    section.add "alt", valid_578920
  var valid_578921 = query.getOrDefault("userIp")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "userIp", valid_578921
  var valid_578922 = query.getOrDefault("quotaUser")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "quotaUser", valid_578922
  var valid_578923 = query.getOrDefault("fields")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "fields", valid_578923
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578924: Call_PlusActivitiesGet_578899; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_578924.validator(path, query, header, formData, body)
  let scheme = call_578924.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578924.url(scheme.get, call_578924.host, call_578924.base,
                         call_578924.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578924, url, valid)

proc call*(call_578925: Call_PlusActivitiesGet_578899; activityId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## plusActivitiesGet
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
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
  ##   activityId: string (required)
  ##             : The ID of the activity to get.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578926 = newJObject()
  var query_578927 = newJObject()
  add(query_578927, "key", newJString(key))
  add(query_578927, "prettyPrint", newJBool(prettyPrint))
  add(query_578927, "oauth_token", newJString(oauthToken))
  add(query_578927, "alt", newJString(alt))
  add(query_578927, "userIp", newJString(userIp))
  add(query_578927, "quotaUser", newJString(quotaUser))
  add(path_578926, "activityId", newJString(activityId))
  add(query_578927, "fields", newJString(fields))
  result = call_578925.call(path_578926, query_578927, nil, nil, nil)

var plusActivitiesGet* = Call_PlusActivitiesGet_578899(name: "plusActivitiesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/activities/{activityId}", validator: validate_PlusActivitiesGet_578900,
    base: "/plus/v1", url: url_PlusActivitiesGet_578901, schemes: {Scheme.Https})
type
  Call_PlusCommentsList_578928 = ref object of OpenApiRestCall_578355
proc url_PlusCommentsList_578930(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "activityId" in path, "`activityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/activities/"),
               (kind: VariableSegment, value: "activityId"),
               (kind: ConstantSegment, value: "/comments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PlusCommentsList_578929(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   activityId: JString (required)
  ##             : The ID of the activity to get comments for.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `activityId` field"
  var valid_578931 = path.getOrDefault("activityId")
  valid_578931 = validateParameter(valid_578931, JString, required = true,
                                 default = nil)
  if valid_578931 != nil:
    section.add "activityId", valid_578931
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
  ##            : The continuation token, which is used to page through large result sets. To get the next page of results, set this parameter to the value of "nextPageToken" from the previous response.
  ##   sortOrder: JString
  ##            : The order in which to sort the list of comments.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of comments to include in the response, which is used for paging. For any response, the actual number returned might be less than the specified maxResults.
  section = newJObject()
  var valid_578932 = query.getOrDefault("key")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "key", valid_578932
  var valid_578933 = query.getOrDefault("prettyPrint")
  valid_578933 = validateParameter(valid_578933, JBool, required = false,
                                 default = newJBool(true))
  if valid_578933 != nil:
    section.add "prettyPrint", valid_578933
  var valid_578934 = query.getOrDefault("oauth_token")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "oauth_token", valid_578934
  var valid_578935 = query.getOrDefault("alt")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = newJString("json"))
  if valid_578935 != nil:
    section.add "alt", valid_578935
  var valid_578936 = query.getOrDefault("userIp")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "userIp", valid_578936
  var valid_578937 = query.getOrDefault("quotaUser")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "quotaUser", valid_578937
  var valid_578938 = query.getOrDefault("pageToken")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "pageToken", valid_578938
  var valid_578939 = query.getOrDefault("sortOrder")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = newJString("ascending"))
  if valid_578939 != nil:
    section.add "sortOrder", valid_578939
  var valid_578940 = query.getOrDefault("fields")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "fields", valid_578940
  var valid_578941 = query.getOrDefault("maxResults")
  valid_578941 = validateParameter(valid_578941, JInt, required = false,
                                 default = newJInt(20))
  if valid_578941 != nil:
    section.add "maxResults", valid_578941
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578942: Call_PlusCommentsList_578928; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_578942.validator(path, query, header, formData, body)
  let scheme = call_578942.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578942.url(scheme.get, call_578942.host, call_578942.base,
                         call_578942.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578942, url, valid)

proc call*(call_578943: Call_PlusCommentsList_578928; activityId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; sortOrder: string = "ascending"; fields: string = "";
          maxResults: int = 20): Recallable =
  ## plusCommentsList
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
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
  ##            : The continuation token, which is used to page through large result sets. To get the next page of results, set this parameter to the value of "nextPageToken" from the previous response.
  ##   sortOrder: string
  ##            : The order in which to sort the list of comments.
  ##   activityId: string (required)
  ##             : The ID of the activity to get comments for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of comments to include in the response, which is used for paging. For any response, the actual number returned might be less than the specified maxResults.
  var path_578944 = newJObject()
  var query_578945 = newJObject()
  add(query_578945, "key", newJString(key))
  add(query_578945, "prettyPrint", newJBool(prettyPrint))
  add(query_578945, "oauth_token", newJString(oauthToken))
  add(query_578945, "alt", newJString(alt))
  add(query_578945, "userIp", newJString(userIp))
  add(query_578945, "quotaUser", newJString(quotaUser))
  add(query_578945, "pageToken", newJString(pageToken))
  add(query_578945, "sortOrder", newJString(sortOrder))
  add(path_578944, "activityId", newJString(activityId))
  add(query_578945, "fields", newJString(fields))
  add(query_578945, "maxResults", newJInt(maxResults))
  result = call_578943.call(path_578944, query_578945, nil, nil, nil)

var plusCommentsList* = Call_PlusCommentsList_578928(name: "plusCommentsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/activities/{activityId}/comments",
    validator: validate_PlusCommentsList_578929, base: "/plus/v1",
    url: url_PlusCommentsList_578930, schemes: {Scheme.Https})
type
  Call_PlusPeopleListByActivity_578946 = ref object of OpenApiRestCall_578355
proc url_PlusPeopleListByActivity_578948(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "activityId" in path, "`activityId` is a required path parameter"
  assert "collection" in path, "`collection` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/activities/"),
               (kind: VariableSegment, value: "activityId"),
               (kind: ConstantSegment, value: "/people/"),
               (kind: VariableSegment, value: "collection")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PlusPeopleListByActivity_578947(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   activityId: JString (required)
  ##             : The ID of the activity to get the list of people for.
  ##   collection: JString (required)
  ##             : The collection of people to list.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `activityId` field"
  var valid_578949 = path.getOrDefault("activityId")
  valid_578949 = validateParameter(valid_578949, JString, required = true,
                                 default = nil)
  if valid_578949 != nil:
    section.add "activityId", valid_578949
  var valid_578950 = path.getOrDefault("collection")
  valid_578950 = validateParameter(valid_578950, JString, required = true,
                                 default = newJString("plusoners"))
  if valid_578950 != nil:
    section.add "collection", valid_578950
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
  ##            : The continuation token, which is used to page through large result sets. To get the next page of results, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of people to include in the response, which is used for paging. For any response, the actual number returned might be less than the specified maxResults.
  section = newJObject()
  var valid_578951 = query.getOrDefault("key")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "key", valid_578951
  var valid_578952 = query.getOrDefault("prettyPrint")
  valid_578952 = validateParameter(valid_578952, JBool, required = false,
                                 default = newJBool(true))
  if valid_578952 != nil:
    section.add "prettyPrint", valid_578952
  var valid_578953 = query.getOrDefault("oauth_token")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "oauth_token", valid_578953
  var valid_578954 = query.getOrDefault("alt")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = newJString("json"))
  if valid_578954 != nil:
    section.add "alt", valid_578954
  var valid_578955 = query.getOrDefault("userIp")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "userIp", valid_578955
  var valid_578956 = query.getOrDefault("quotaUser")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "quotaUser", valid_578956
  var valid_578957 = query.getOrDefault("pageToken")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "pageToken", valid_578957
  var valid_578958 = query.getOrDefault("fields")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "fields", valid_578958
  var valid_578959 = query.getOrDefault("maxResults")
  valid_578959 = validateParameter(valid_578959, JInt, required = false,
                                 default = newJInt(20))
  if valid_578959 != nil:
    section.add "maxResults", valid_578959
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578960: Call_PlusPeopleListByActivity_578946; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_578960.validator(path, query, header, formData, body)
  let scheme = call_578960.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578960.url(scheme.get, call_578960.host, call_578960.base,
                         call_578960.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578960, url, valid)

proc call*(call_578961: Call_PlusPeopleListByActivity_578946; activityId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; fields: string = ""; collection: string = "plusoners";
          maxResults: int = 20): Recallable =
  ## plusPeopleListByActivity
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
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
  ##            : The continuation token, which is used to page through large result sets. To get the next page of results, set this parameter to the value of "nextPageToken" from the previous response.
  ##   activityId: string (required)
  ##             : The ID of the activity to get the list of people for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   collection: string (required)
  ##             : The collection of people to list.
  ##   maxResults: int
  ##             : The maximum number of people to include in the response, which is used for paging. For any response, the actual number returned might be less than the specified maxResults.
  var path_578962 = newJObject()
  var query_578963 = newJObject()
  add(query_578963, "key", newJString(key))
  add(query_578963, "prettyPrint", newJBool(prettyPrint))
  add(query_578963, "oauth_token", newJString(oauthToken))
  add(query_578963, "alt", newJString(alt))
  add(query_578963, "userIp", newJString(userIp))
  add(query_578963, "quotaUser", newJString(quotaUser))
  add(query_578963, "pageToken", newJString(pageToken))
  add(path_578962, "activityId", newJString(activityId))
  add(query_578963, "fields", newJString(fields))
  add(path_578962, "collection", newJString(collection))
  add(query_578963, "maxResults", newJInt(maxResults))
  result = call_578961.call(path_578962, query_578963, nil, nil, nil)

var plusPeopleListByActivity* = Call_PlusPeopleListByActivity_578946(
    name: "plusPeopleListByActivity", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/activities/{activityId}/people/{collection}",
    validator: validate_PlusPeopleListByActivity_578947, base: "/plus/v1",
    url: url_PlusPeopleListByActivity_578948, schemes: {Scheme.Https})
type
  Call_PlusCommentsGet_578964 = ref object of OpenApiRestCall_578355
proc url_PlusCommentsGet_578966(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "commentId" in path, "`commentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/comments/"),
               (kind: VariableSegment, value: "commentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PlusCommentsGet_578965(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   commentId: JString (required)
  ##            : The ID of the comment to get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `commentId` field"
  var valid_578967 = path.getOrDefault("commentId")
  valid_578967 = validateParameter(valid_578967, JString, required = true,
                                 default = nil)
  if valid_578967 != nil:
    section.add "commentId", valid_578967
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
  var valid_578968 = query.getOrDefault("key")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "key", valid_578968
  var valid_578969 = query.getOrDefault("prettyPrint")
  valid_578969 = validateParameter(valid_578969, JBool, required = false,
                                 default = newJBool(true))
  if valid_578969 != nil:
    section.add "prettyPrint", valid_578969
  var valid_578970 = query.getOrDefault("oauth_token")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "oauth_token", valid_578970
  var valid_578971 = query.getOrDefault("alt")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = newJString("json"))
  if valid_578971 != nil:
    section.add "alt", valid_578971
  var valid_578972 = query.getOrDefault("userIp")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "userIp", valid_578972
  var valid_578973 = query.getOrDefault("quotaUser")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "quotaUser", valid_578973
  var valid_578974 = query.getOrDefault("fields")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "fields", valid_578974
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578975: Call_PlusCommentsGet_578964; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_578975.validator(path, query, header, formData, body)
  let scheme = call_578975.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578975.url(scheme.get, call_578975.host, call_578975.base,
                         call_578975.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578975, url, valid)

proc call*(call_578976: Call_PlusCommentsGet_578964; commentId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## plusCommentsGet
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
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
  ##   commentId: string (required)
  ##            : The ID of the comment to get.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578977 = newJObject()
  var query_578978 = newJObject()
  add(query_578978, "key", newJString(key))
  add(query_578978, "prettyPrint", newJBool(prettyPrint))
  add(query_578978, "oauth_token", newJString(oauthToken))
  add(query_578978, "alt", newJString(alt))
  add(query_578978, "userIp", newJString(userIp))
  add(query_578978, "quotaUser", newJString(quotaUser))
  add(path_578977, "commentId", newJString(commentId))
  add(query_578978, "fields", newJString(fields))
  result = call_578976.call(path_578977, query_578978, nil, nil, nil)

var plusCommentsGet* = Call_PlusCommentsGet_578964(name: "plusCommentsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/comments/{commentId}", validator: validate_PlusCommentsGet_578965,
    base: "/plus/v1", url: url_PlusCommentsGet_578966, schemes: {Scheme.Https})
type
  Call_PlusPeopleSearch_578979 = ref object of OpenApiRestCall_578355
proc url_PlusPeopleSearch_578981(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PlusPeopleSearch_578980(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
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
  ##            : The continuation token, which is used to page through large result sets. To get the next page of results, set this parameter to the value of "nextPageToken" from the previous response. This token can be of any length.
  ##   query: JString (required)
  ##        : Specify a query string for full text search of public text in all profiles.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: JString
  ##           : Specify the preferred language to search with. See search language codes for available values.
  ##   maxResults: JInt
  ##             : The maximum number of people to include in the response, which is used for paging. For any response, the actual number returned might be less than the specified maxResults.
  section = newJObject()
  var valid_578982 = query.getOrDefault("key")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = nil)
  if valid_578982 != nil:
    section.add "key", valid_578982
  var valid_578983 = query.getOrDefault("prettyPrint")
  valid_578983 = validateParameter(valid_578983, JBool, required = false,
                                 default = newJBool(true))
  if valid_578983 != nil:
    section.add "prettyPrint", valid_578983
  var valid_578984 = query.getOrDefault("oauth_token")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "oauth_token", valid_578984
  var valid_578985 = query.getOrDefault("alt")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = newJString("json"))
  if valid_578985 != nil:
    section.add "alt", valid_578985
  var valid_578986 = query.getOrDefault("userIp")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = nil)
  if valid_578986 != nil:
    section.add "userIp", valid_578986
  var valid_578987 = query.getOrDefault("quotaUser")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "quotaUser", valid_578987
  var valid_578988 = query.getOrDefault("pageToken")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = nil)
  if valid_578988 != nil:
    section.add "pageToken", valid_578988
  assert query != nil, "query argument is necessary due to required `query` field"
  var valid_578989 = query.getOrDefault("query")
  valid_578989 = validateParameter(valid_578989, JString, required = true,
                                 default = nil)
  if valid_578989 != nil:
    section.add "query", valid_578989
  var valid_578990 = query.getOrDefault("fields")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "fields", valid_578990
  var valid_578991 = query.getOrDefault("language")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = newJString("en-US"))
  if valid_578991 != nil:
    section.add "language", valid_578991
  var valid_578992 = query.getOrDefault("maxResults")
  valid_578992 = validateParameter(valid_578992, JInt, required = false,
                                 default = newJInt(25))
  if valid_578992 != nil:
    section.add "maxResults", valid_578992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578993: Call_PlusPeopleSearch_578979; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_578993.validator(path, query, header, formData, body)
  let scheme = call_578993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578993.url(scheme.get, call_578993.host, call_578993.base,
                         call_578993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578993, url, valid)

proc call*(call_578994: Call_PlusPeopleSearch_578979; query: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; fields: string = ""; language: string = "en-US";
          maxResults: int = 25): Recallable =
  ## plusPeopleSearch
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
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
  ##            : The continuation token, which is used to page through large result sets. To get the next page of results, set this parameter to the value of "nextPageToken" from the previous response. This token can be of any length.
  ##   query: string (required)
  ##        : Specify a query string for full text search of public text in all profiles.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: string
  ##           : Specify the preferred language to search with. See search language codes for available values.
  ##   maxResults: int
  ##             : The maximum number of people to include in the response, which is used for paging. For any response, the actual number returned might be less than the specified maxResults.
  var query_578995 = newJObject()
  add(query_578995, "key", newJString(key))
  add(query_578995, "prettyPrint", newJBool(prettyPrint))
  add(query_578995, "oauth_token", newJString(oauthToken))
  add(query_578995, "alt", newJString(alt))
  add(query_578995, "userIp", newJString(userIp))
  add(query_578995, "quotaUser", newJString(quotaUser))
  add(query_578995, "pageToken", newJString(pageToken))
  add(query_578995, "query", newJString(query))
  add(query_578995, "fields", newJString(fields))
  add(query_578995, "language", newJString(language))
  add(query_578995, "maxResults", newJInt(maxResults))
  result = call_578994.call(nil, query_578995, nil, nil, nil)

var plusPeopleSearch* = Call_PlusPeopleSearch_578979(name: "plusPeopleSearch",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/people",
    validator: validate_PlusPeopleSearch_578980, base: "/plus/v1",
    url: url_PlusPeopleSearch_578981, schemes: {Scheme.Https})
type
  Call_PlusPeopleGet_578996 = ref object of OpenApiRestCall_578355
proc url_PlusPeopleGet_578998(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/people/"),
               (kind: VariableSegment, value: "userId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PlusPeopleGet_578997(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a person's profile. If your app uses scope https://www.googleapis.com/auth/plus.login, this method is guaranteed to return ageRange and language.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : The ID of the person to get the profile for. The special value "me" can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_578999 = path.getOrDefault("userId")
  valid_578999 = validateParameter(valid_578999, JString, required = true,
                                 default = nil)
  if valid_578999 != nil:
    section.add "userId", valid_578999
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
  var valid_579000 = query.getOrDefault("key")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = nil)
  if valid_579000 != nil:
    section.add "key", valid_579000
  var valid_579001 = query.getOrDefault("prettyPrint")
  valid_579001 = validateParameter(valid_579001, JBool, required = false,
                                 default = newJBool(true))
  if valid_579001 != nil:
    section.add "prettyPrint", valid_579001
  var valid_579002 = query.getOrDefault("oauth_token")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = nil)
  if valid_579002 != nil:
    section.add "oauth_token", valid_579002
  var valid_579003 = query.getOrDefault("alt")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = newJString("json"))
  if valid_579003 != nil:
    section.add "alt", valid_579003
  var valid_579004 = query.getOrDefault("userIp")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "userIp", valid_579004
  var valid_579005 = query.getOrDefault("quotaUser")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "quotaUser", valid_579005
  var valid_579006 = query.getOrDefault("fields")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "fields", valid_579006
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579007: Call_PlusPeopleGet_578996; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a person's profile. If your app uses scope https://www.googleapis.com/auth/plus.login, this method is guaranteed to return ageRange and language.
  ## 
  let valid = call_579007.validator(path, query, header, formData, body)
  let scheme = call_579007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579007.url(scheme.get, call_579007.host, call_579007.base,
                         call_579007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579007, url, valid)

proc call*(call_579008: Call_PlusPeopleGet_578996; userId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## plusPeopleGet
  ## Get a person's profile. If your app uses scope https://www.googleapis.com/auth/plus.login, this method is guaranteed to return ageRange and language.
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
  ##   userId: string (required)
  ##         : The ID of the person to get the profile for. The special value "me" can be used to indicate the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579009 = newJObject()
  var query_579010 = newJObject()
  add(query_579010, "key", newJString(key))
  add(query_579010, "prettyPrint", newJBool(prettyPrint))
  add(query_579010, "oauth_token", newJString(oauthToken))
  add(query_579010, "alt", newJString(alt))
  add(query_579010, "userIp", newJString(userIp))
  add(query_579010, "quotaUser", newJString(quotaUser))
  add(path_579009, "userId", newJString(userId))
  add(query_579010, "fields", newJString(fields))
  result = call_579008.call(path_579009, query_579010, nil, nil, nil)

var plusPeopleGet* = Call_PlusPeopleGet_578996(name: "plusPeopleGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/people/{userId}",
    validator: validate_PlusPeopleGet_578997, base: "/plus/v1",
    url: url_PlusPeopleGet_578998, schemes: {Scheme.Https})
type
  Call_PlusActivitiesList_579011 = ref object of OpenApiRestCall_578355
proc url_PlusActivitiesList_579013(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "collection" in path, "`collection` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/people/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/activities/"),
               (kind: VariableSegment, value: "collection")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PlusActivitiesList_579012(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : The ID of the user to get activities for. The special value "me" can be used to indicate the authenticated user.
  ##   collection: JString (required)
  ##             : The collection of activities to list.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_579014 = path.getOrDefault("userId")
  valid_579014 = validateParameter(valid_579014, JString, required = true,
                                 default = nil)
  if valid_579014 != nil:
    section.add "userId", valid_579014
  var valid_579015 = path.getOrDefault("collection")
  valid_579015 = validateParameter(valid_579015, JString, required = true,
                                 default = newJString("public"))
  if valid_579015 != nil:
    section.add "collection", valid_579015
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
  ##            : The continuation token, which is used to page through large result sets. To get the next page of results, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of activities to include in the response, which is used for paging. For any response, the actual number returned might be less than the specified maxResults.
  section = newJObject()
  var valid_579016 = query.getOrDefault("key")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "key", valid_579016
  var valid_579017 = query.getOrDefault("prettyPrint")
  valid_579017 = validateParameter(valid_579017, JBool, required = false,
                                 default = newJBool(true))
  if valid_579017 != nil:
    section.add "prettyPrint", valid_579017
  var valid_579018 = query.getOrDefault("oauth_token")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "oauth_token", valid_579018
  var valid_579019 = query.getOrDefault("alt")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = newJString("json"))
  if valid_579019 != nil:
    section.add "alt", valid_579019
  var valid_579020 = query.getOrDefault("userIp")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "userIp", valid_579020
  var valid_579021 = query.getOrDefault("quotaUser")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = nil)
  if valid_579021 != nil:
    section.add "quotaUser", valid_579021
  var valid_579022 = query.getOrDefault("pageToken")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "pageToken", valid_579022
  var valid_579023 = query.getOrDefault("fields")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "fields", valid_579023
  var valid_579024 = query.getOrDefault("maxResults")
  valid_579024 = validateParameter(valid_579024, JInt, required = false,
                                 default = newJInt(20))
  if valid_579024 != nil:
    section.add "maxResults", valid_579024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579025: Call_PlusActivitiesList_579011; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_579025.validator(path, query, header, formData, body)
  let scheme = call_579025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579025.url(scheme.get, call_579025.host, call_579025.base,
                         call_579025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579025, url, valid)

proc call*(call_579026: Call_PlusActivitiesList_579011; userId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; fields: string = ""; collection: string = "public";
          maxResults: int = 20): Recallable =
  ## plusActivitiesList
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
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
  ##            : The continuation token, which is used to page through large result sets. To get the next page of results, set this parameter to the value of "nextPageToken" from the previous response.
  ##   userId: string (required)
  ##         : The ID of the user to get activities for. The special value "me" can be used to indicate the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   collection: string (required)
  ##             : The collection of activities to list.
  ##   maxResults: int
  ##             : The maximum number of activities to include in the response, which is used for paging. For any response, the actual number returned might be less than the specified maxResults.
  var path_579027 = newJObject()
  var query_579028 = newJObject()
  add(query_579028, "key", newJString(key))
  add(query_579028, "prettyPrint", newJBool(prettyPrint))
  add(query_579028, "oauth_token", newJString(oauthToken))
  add(query_579028, "alt", newJString(alt))
  add(query_579028, "userIp", newJString(userIp))
  add(query_579028, "quotaUser", newJString(quotaUser))
  add(query_579028, "pageToken", newJString(pageToken))
  add(path_579027, "userId", newJString(userId))
  add(query_579028, "fields", newJString(fields))
  add(path_579027, "collection", newJString(collection))
  add(query_579028, "maxResults", newJInt(maxResults))
  result = call_579026.call(path_579027, query_579028, nil, nil, nil)

var plusActivitiesList* = Call_PlusActivitiesList_579011(
    name: "plusActivitiesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/people/{userId}/activities/{collection}",
    validator: validate_PlusActivitiesList_579012, base: "/plus/v1",
    url: url_PlusActivitiesList_579013, schemes: {Scheme.Https})
type
  Call_PlusPeopleList_579029 = ref object of OpenApiRestCall_578355
proc url_PlusPeopleList_579031(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "collection" in path, "`collection` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/people/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/people/"),
               (kind: VariableSegment, value: "collection")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PlusPeopleList_579030(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## List all of the people in the specified collection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : Get the collection of people for the person identified. Use "me" to indicate the authenticated user.
  ##   collection: JString (required)
  ##             : The collection of people to list.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_579032 = path.getOrDefault("userId")
  valid_579032 = validateParameter(valid_579032, JString, required = true,
                                 default = nil)
  if valid_579032 != nil:
    section.add "userId", valid_579032
  var valid_579033 = path.getOrDefault("collection")
  valid_579033 = validateParameter(valid_579033, JString, required = true,
                                 default = newJString("connected"))
  if valid_579033 != nil:
    section.add "collection", valid_579033
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
  ##          : The order to return people in.
  ##   pageToken: JString
  ##            : The continuation token, which is used to page through large result sets. To get the next page of results, set this parameter to the value of "nextPageToken" from the previous response.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : The maximum number of people to include in the response, which is used for paging. For any response, the actual number returned might be less than the specified maxResults.
  section = newJObject()
  var valid_579034 = query.getOrDefault("key")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "key", valid_579034
  var valid_579035 = query.getOrDefault("prettyPrint")
  valid_579035 = validateParameter(valid_579035, JBool, required = false,
                                 default = newJBool(true))
  if valid_579035 != nil:
    section.add "prettyPrint", valid_579035
  var valid_579036 = query.getOrDefault("oauth_token")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "oauth_token", valid_579036
  var valid_579037 = query.getOrDefault("alt")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = newJString("json"))
  if valid_579037 != nil:
    section.add "alt", valid_579037
  var valid_579038 = query.getOrDefault("userIp")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = nil)
  if valid_579038 != nil:
    section.add "userIp", valid_579038
  var valid_579039 = query.getOrDefault("quotaUser")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "quotaUser", valid_579039
  var valid_579040 = query.getOrDefault("orderBy")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = newJString("alphabetical"))
  if valid_579040 != nil:
    section.add "orderBy", valid_579040
  var valid_579041 = query.getOrDefault("pageToken")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = nil)
  if valid_579041 != nil:
    section.add "pageToken", valid_579041
  var valid_579042 = query.getOrDefault("fields")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = nil)
  if valid_579042 != nil:
    section.add "fields", valid_579042
  var valid_579043 = query.getOrDefault("maxResults")
  valid_579043 = validateParameter(valid_579043, JInt, required = false,
                                 default = newJInt(100))
  if valid_579043 != nil:
    section.add "maxResults", valid_579043
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579044: Call_PlusPeopleList_579029; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all of the people in the specified collection.
  ## 
  let valid = call_579044.validator(path, query, header, formData, body)
  let scheme = call_579044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579044.url(scheme.get, call_579044.host, call_579044.base,
                         call_579044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579044, url, valid)

proc call*(call_579045: Call_PlusPeopleList_579029; userId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; orderBy: string = "alphabetical";
          pageToken: string = ""; fields: string = ""; collection: string = "connected";
          maxResults: int = 100): Recallable =
  ## plusPeopleList
  ## List all of the people in the specified collection.
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
  ##          : The order to return people in.
  ##   pageToken: string
  ##            : The continuation token, which is used to page through large result sets. To get the next page of results, set this parameter to the value of "nextPageToken" from the previous response.
  ##   userId: string (required)
  ##         : Get the collection of people for the person identified. Use "me" to indicate the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   collection: string (required)
  ##             : The collection of people to list.
  ##   maxResults: int
  ##             : The maximum number of people to include in the response, which is used for paging. For any response, the actual number returned might be less than the specified maxResults.
  var path_579046 = newJObject()
  var query_579047 = newJObject()
  add(query_579047, "key", newJString(key))
  add(query_579047, "prettyPrint", newJBool(prettyPrint))
  add(query_579047, "oauth_token", newJString(oauthToken))
  add(query_579047, "alt", newJString(alt))
  add(query_579047, "userIp", newJString(userIp))
  add(query_579047, "quotaUser", newJString(quotaUser))
  add(query_579047, "orderBy", newJString(orderBy))
  add(query_579047, "pageToken", newJString(pageToken))
  add(path_579046, "userId", newJString(userId))
  add(query_579047, "fields", newJString(fields))
  add(path_579046, "collection", newJString(collection))
  add(query_579047, "maxResults", newJInt(maxResults))
  result = call_579045.call(path_579046, query_579047, nil, nil, nil)

var plusPeopleList* = Call_PlusPeopleList_579029(name: "plusPeopleList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/people/{userId}/people/{collection}",
    validator: validate_PlusPeopleList_579030, base: "/plus/v1",
    url: url_PlusPeopleList_579031, schemes: {Scheme.Https})
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
