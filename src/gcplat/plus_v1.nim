
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
  gcpServiceName = "plus"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PlusActivitiesSearch_579692 = ref object of OpenApiRestCall_579424
proc url_PlusActivitiesSearch_579694(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PlusActivitiesSearch_579693(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The continuation token, which is used to page through large result sets. To get the next page of results, set this parameter to the value of "nextPageToken" from the previous response. This token can be of any length.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   language: JString
  ##           : Specify the preferred language to search with. See search language codes for available values.
  ##   query: JString (required)
  ##        : Full-text search query string.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of activities to include in the response, which is used for paging. For any response, the actual number returned might be less than the specified maxResults.
  ##   orderBy: JString
  ##          : Specifies how to order search results.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579806 = query.getOrDefault("fields")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "fields", valid_579806
  var valid_579807 = query.getOrDefault("pageToken")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "pageToken", valid_579807
  var valid_579808 = query.getOrDefault("quotaUser")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "quotaUser", valid_579808
  var valid_579822 = query.getOrDefault("alt")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = newJString("json"))
  if valid_579822 != nil:
    section.add "alt", valid_579822
  var valid_579823 = query.getOrDefault("language")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = newJString("en-US"))
  if valid_579823 != nil:
    section.add "language", valid_579823
  assert query != nil, "query argument is necessary due to required `query` field"
  var valid_579824 = query.getOrDefault("query")
  valid_579824 = validateParameter(valid_579824, JString, required = true,
                                 default = nil)
  if valid_579824 != nil:
    section.add "query", valid_579824
  var valid_579825 = query.getOrDefault("oauth_token")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "oauth_token", valid_579825
  var valid_579826 = query.getOrDefault("userIp")
  valid_579826 = validateParameter(valid_579826, JString, required = false,
                                 default = nil)
  if valid_579826 != nil:
    section.add "userIp", valid_579826
  var valid_579828 = query.getOrDefault("maxResults")
  valid_579828 = validateParameter(valid_579828, JInt, required = false,
                                 default = newJInt(10))
  if valid_579828 != nil:
    section.add "maxResults", valid_579828
  var valid_579829 = query.getOrDefault("orderBy")
  valid_579829 = validateParameter(valid_579829, JString, required = false,
                                 default = newJString("recent"))
  if valid_579829 != nil:
    section.add "orderBy", valid_579829
  var valid_579830 = query.getOrDefault("key")
  valid_579830 = validateParameter(valid_579830, JString, required = false,
                                 default = nil)
  if valid_579830 != nil:
    section.add "key", valid_579830
  var valid_579831 = query.getOrDefault("prettyPrint")
  valid_579831 = validateParameter(valid_579831, JBool, required = false,
                                 default = newJBool(true))
  if valid_579831 != nil:
    section.add "prettyPrint", valid_579831
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579854: Call_PlusActivitiesSearch_579692; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_579854.validator(path, query, header, formData, body)
  let scheme = call_579854.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579854.url(scheme.get, call_579854.host, call_579854.base,
                         call_579854.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579854, url, valid)

proc call*(call_579925: Call_PlusActivitiesSearch_579692; query: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; language: string = "en-US"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 10; orderBy: string = "recent";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## plusActivitiesSearch
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The continuation token, which is used to page through large result sets. To get the next page of results, set this parameter to the value of "nextPageToken" from the previous response. This token can be of any length.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : Specify the preferred language to search with. See search language codes for available values.
  ##   query: string (required)
  ##        : Full-text search query string.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of activities to include in the response, which is used for paging. For any response, the actual number returned might be less than the specified maxResults.
  ##   orderBy: string
  ##          : Specifies how to order search results.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_579926 = newJObject()
  add(query_579926, "fields", newJString(fields))
  add(query_579926, "pageToken", newJString(pageToken))
  add(query_579926, "quotaUser", newJString(quotaUser))
  add(query_579926, "alt", newJString(alt))
  add(query_579926, "language", newJString(language))
  add(query_579926, "query", newJString(query))
  add(query_579926, "oauth_token", newJString(oauthToken))
  add(query_579926, "userIp", newJString(userIp))
  add(query_579926, "maxResults", newJInt(maxResults))
  add(query_579926, "orderBy", newJString(orderBy))
  add(query_579926, "key", newJString(key))
  add(query_579926, "prettyPrint", newJBool(prettyPrint))
  result = call_579925.call(nil, query_579926, nil, nil, nil)

var plusActivitiesSearch* = Call_PlusActivitiesSearch_579692(
    name: "plusActivitiesSearch", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/activities",
    validator: validate_PlusActivitiesSearch_579693, base: "/plus/v1",
    url: url_PlusActivitiesSearch_579694, schemes: {Scheme.Https})
type
  Call_PlusActivitiesGet_579966 = ref object of OpenApiRestCall_579424
proc url_PlusActivitiesGet_579968(protocol: Scheme; host: string; base: string;
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

proc validate_PlusActivitiesGet_579967(path: JsonNode; query: JsonNode;
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
  var valid_579983 = path.getOrDefault("activityId")
  valid_579983 = validateParameter(valid_579983, JString, required = true,
                                 default = nil)
  if valid_579983 != nil:
    section.add "activityId", valid_579983
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
  var valid_579984 = query.getOrDefault("fields")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "fields", valid_579984
  var valid_579985 = query.getOrDefault("quotaUser")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "quotaUser", valid_579985
  var valid_579986 = query.getOrDefault("alt")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = newJString("json"))
  if valid_579986 != nil:
    section.add "alt", valid_579986
  var valid_579987 = query.getOrDefault("oauth_token")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "oauth_token", valid_579987
  var valid_579988 = query.getOrDefault("userIp")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "userIp", valid_579988
  var valid_579989 = query.getOrDefault("key")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "key", valid_579989
  var valid_579990 = query.getOrDefault("prettyPrint")
  valid_579990 = validateParameter(valid_579990, JBool, required = false,
                                 default = newJBool(true))
  if valid_579990 != nil:
    section.add "prettyPrint", valid_579990
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579991: Call_PlusActivitiesGet_579966; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_579991.validator(path, query, header, formData, body)
  let scheme = call_579991.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579991.url(scheme.get, call_579991.host, call_579991.base,
                         call_579991.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579991, url, valid)

proc call*(call_579992: Call_PlusActivitiesGet_579966; activityId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## plusActivitiesGet
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   activityId: string (required)
  ##             : The ID of the activity to get.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_579993 = newJObject()
  var query_579994 = newJObject()
  add(query_579994, "fields", newJString(fields))
  add(query_579994, "quotaUser", newJString(quotaUser))
  add(query_579994, "alt", newJString(alt))
  add(query_579994, "oauth_token", newJString(oauthToken))
  add(path_579993, "activityId", newJString(activityId))
  add(query_579994, "userIp", newJString(userIp))
  add(query_579994, "key", newJString(key))
  add(query_579994, "prettyPrint", newJBool(prettyPrint))
  result = call_579992.call(path_579993, query_579994, nil, nil, nil)

var plusActivitiesGet* = Call_PlusActivitiesGet_579966(name: "plusActivitiesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/activities/{activityId}", validator: validate_PlusActivitiesGet_579967,
    base: "/plus/v1", url: url_PlusActivitiesGet_579968, schemes: {Scheme.Https})
type
  Call_PlusCommentsList_579995 = ref object of OpenApiRestCall_579424
proc url_PlusCommentsList_579997(protocol: Scheme; host: string; base: string;
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

proc validate_PlusCommentsList_579996(path: JsonNode; query: JsonNode;
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
  var valid_579998 = path.getOrDefault("activityId")
  valid_579998 = validateParameter(valid_579998, JString, required = true,
                                 default = nil)
  if valid_579998 != nil:
    section.add "activityId", valid_579998
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The continuation token, which is used to page through large result sets. To get the next page of results, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of comments to include in the response, which is used for paging. For any response, the actual number returned might be less than the specified maxResults.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   sortOrder: JString
  ##            : The order in which to sort the list of comments.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579999 = query.getOrDefault("fields")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "fields", valid_579999
  var valid_580000 = query.getOrDefault("pageToken")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "pageToken", valid_580000
  var valid_580001 = query.getOrDefault("quotaUser")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "quotaUser", valid_580001
  var valid_580002 = query.getOrDefault("alt")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = newJString("json"))
  if valid_580002 != nil:
    section.add "alt", valid_580002
  var valid_580003 = query.getOrDefault("oauth_token")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "oauth_token", valid_580003
  var valid_580004 = query.getOrDefault("userIp")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "userIp", valid_580004
  var valid_580005 = query.getOrDefault("maxResults")
  valid_580005 = validateParameter(valid_580005, JInt, required = false,
                                 default = newJInt(20))
  if valid_580005 != nil:
    section.add "maxResults", valid_580005
  var valid_580006 = query.getOrDefault("key")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "key", valid_580006
  var valid_580007 = query.getOrDefault("sortOrder")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = newJString("ascending"))
  if valid_580007 != nil:
    section.add "sortOrder", valid_580007
  var valid_580008 = query.getOrDefault("prettyPrint")
  valid_580008 = validateParameter(valid_580008, JBool, required = false,
                                 default = newJBool(true))
  if valid_580008 != nil:
    section.add "prettyPrint", valid_580008
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580009: Call_PlusCommentsList_579995; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_580009.validator(path, query, header, formData, body)
  let scheme = call_580009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580009.url(scheme.get, call_580009.host, call_580009.base,
                         call_580009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580009, url, valid)

proc call*(call_580010: Call_PlusCommentsList_579995; activityId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 20; key: string = ""; sortOrder: string = "ascending";
          prettyPrint: bool = true): Recallable =
  ## plusCommentsList
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The continuation token, which is used to page through large result sets. To get the next page of results, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   activityId: string (required)
  ##             : The ID of the activity to get comments for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of comments to include in the response, which is used for paging. For any response, the actual number returned might be less than the specified maxResults.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   sortOrder: string
  ##            : The order in which to sort the list of comments.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580011 = newJObject()
  var query_580012 = newJObject()
  add(query_580012, "fields", newJString(fields))
  add(query_580012, "pageToken", newJString(pageToken))
  add(query_580012, "quotaUser", newJString(quotaUser))
  add(query_580012, "alt", newJString(alt))
  add(query_580012, "oauth_token", newJString(oauthToken))
  add(path_580011, "activityId", newJString(activityId))
  add(query_580012, "userIp", newJString(userIp))
  add(query_580012, "maxResults", newJInt(maxResults))
  add(query_580012, "key", newJString(key))
  add(query_580012, "sortOrder", newJString(sortOrder))
  add(query_580012, "prettyPrint", newJBool(prettyPrint))
  result = call_580010.call(path_580011, query_580012, nil, nil, nil)

var plusCommentsList* = Call_PlusCommentsList_579995(name: "plusCommentsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/activities/{activityId}/comments",
    validator: validate_PlusCommentsList_579996, base: "/plus/v1",
    url: url_PlusCommentsList_579997, schemes: {Scheme.Https})
type
  Call_PlusPeopleListByActivity_580013 = ref object of OpenApiRestCall_579424
proc url_PlusPeopleListByActivity_580015(protocol: Scheme; host: string;
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

proc validate_PlusPeopleListByActivity_580014(path: JsonNode; query: JsonNode;
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
  var valid_580016 = path.getOrDefault("activityId")
  valid_580016 = validateParameter(valid_580016, JString, required = true,
                                 default = nil)
  if valid_580016 != nil:
    section.add "activityId", valid_580016
  var valid_580017 = path.getOrDefault("collection")
  valid_580017 = validateParameter(valid_580017, JString, required = true,
                                 default = newJString("plusoners"))
  if valid_580017 != nil:
    section.add "collection", valid_580017
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The continuation token, which is used to page through large result sets. To get the next page of results, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of people to include in the response, which is used for paging. For any response, the actual number returned might be less than the specified maxResults.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580018 = query.getOrDefault("fields")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "fields", valid_580018
  var valid_580019 = query.getOrDefault("pageToken")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "pageToken", valid_580019
  var valid_580020 = query.getOrDefault("quotaUser")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "quotaUser", valid_580020
  var valid_580021 = query.getOrDefault("alt")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = newJString("json"))
  if valid_580021 != nil:
    section.add "alt", valid_580021
  var valid_580022 = query.getOrDefault("oauth_token")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "oauth_token", valid_580022
  var valid_580023 = query.getOrDefault("userIp")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "userIp", valid_580023
  var valid_580024 = query.getOrDefault("maxResults")
  valid_580024 = validateParameter(valid_580024, JInt, required = false,
                                 default = newJInt(20))
  if valid_580024 != nil:
    section.add "maxResults", valid_580024
  var valid_580025 = query.getOrDefault("key")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "key", valid_580025
  var valid_580026 = query.getOrDefault("prettyPrint")
  valid_580026 = validateParameter(valid_580026, JBool, required = false,
                                 default = newJBool(true))
  if valid_580026 != nil:
    section.add "prettyPrint", valid_580026
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580027: Call_PlusPeopleListByActivity_580013; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_580027.validator(path, query, header, formData, body)
  let scheme = call_580027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580027.url(scheme.get, call_580027.host, call_580027.base,
                         call_580027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580027, url, valid)

proc call*(call_580028: Call_PlusPeopleListByActivity_580013; activityId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = "";
          collection: string = "plusoners"; userIp: string = ""; maxResults: int = 20;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## plusPeopleListByActivity
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The continuation token, which is used to page through large result sets. To get the next page of results, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   activityId: string (required)
  ##             : The ID of the activity to get the list of people for.
  ##   collection: string (required)
  ##             : The collection of people to list.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of people to include in the response, which is used for paging. For any response, the actual number returned might be less than the specified maxResults.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580029 = newJObject()
  var query_580030 = newJObject()
  add(query_580030, "fields", newJString(fields))
  add(query_580030, "pageToken", newJString(pageToken))
  add(query_580030, "quotaUser", newJString(quotaUser))
  add(query_580030, "alt", newJString(alt))
  add(query_580030, "oauth_token", newJString(oauthToken))
  add(path_580029, "activityId", newJString(activityId))
  add(path_580029, "collection", newJString(collection))
  add(query_580030, "userIp", newJString(userIp))
  add(query_580030, "maxResults", newJInt(maxResults))
  add(query_580030, "key", newJString(key))
  add(query_580030, "prettyPrint", newJBool(prettyPrint))
  result = call_580028.call(path_580029, query_580030, nil, nil, nil)

var plusPeopleListByActivity* = Call_PlusPeopleListByActivity_580013(
    name: "plusPeopleListByActivity", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/activities/{activityId}/people/{collection}",
    validator: validate_PlusPeopleListByActivity_580014, base: "/plus/v1",
    url: url_PlusPeopleListByActivity_580015, schemes: {Scheme.Https})
type
  Call_PlusCommentsGet_580031 = ref object of OpenApiRestCall_579424
proc url_PlusCommentsGet_580033(protocol: Scheme; host: string; base: string;
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

proc validate_PlusCommentsGet_580032(path: JsonNode; query: JsonNode;
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
  var valid_580034 = path.getOrDefault("commentId")
  valid_580034 = validateParameter(valid_580034, JString, required = true,
                                 default = nil)
  if valid_580034 != nil:
    section.add "commentId", valid_580034
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
  var valid_580035 = query.getOrDefault("fields")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "fields", valid_580035
  var valid_580036 = query.getOrDefault("quotaUser")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "quotaUser", valid_580036
  var valid_580037 = query.getOrDefault("alt")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = newJString("json"))
  if valid_580037 != nil:
    section.add "alt", valid_580037
  var valid_580038 = query.getOrDefault("oauth_token")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "oauth_token", valid_580038
  var valid_580039 = query.getOrDefault("userIp")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "userIp", valid_580039
  var valid_580040 = query.getOrDefault("key")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "key", valid_580040
  var valid_580041 = query.getOrDefault("prettyPrint")
  valid_580041 = validateParameter(valid_580041, JBool, required = false,
                                 default = newJBool(true))
  if valid_580041 != nil:
    section.add "prettyPrint", valid_580041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580042: Call_PlusCommentsGet_580031; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_580042.validator(path, query, header, formData, body)
  let scheme = call_580042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580042.url(scheme.get, call_580042.host, call_580042.base,
                         call_580042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580042, url, valid)

proc call*(call_580043: Call_PlusCommentsGet_580031; commentId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## plusCommentsGet
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
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
  ##   commentId: string (required)
  ##            : The ID of the comment to get.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580044 = newJObject()
  var query_580045 = newJObject()
  add(query_580045, "fields", newJString(fields))
  add(query_580045, "quotaUser", newJString(quotaUser))
  add(query_580045, "alt", newJString(alt))
  add(query_580045, "oauth_token", newJString(oauthToken))
  add(query_580045, "userIp", newJString(userIp))
  add(query_580045, "key", newJString(key))
  add(path_580044, "commentId", newJString(commentId))
  add(query_580045, "prettyPrint", newJBool(prettyPrint))
  result = call_580043.call(path_580044, query_580045, nil, nil, nil)

var plusCommentsGet* = Call_PlusCommentsGet_580031(name: "plusCommentsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/comments/{commentId}", validator: validate_PlusCommentsGet_580032,
    base: "/plus/v1", url: url_PlusCommentsGet_580033, schemes: {Scheme.Https})
type
  Call_PlusPeopleSearch_580046 = ref object of OpenApiRestCall_579424
proc url_PlusPeopleSearch_580048(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PlusPeopleSearch_580047(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The continuation token, which is used to page through large result sets. To get the next page of results, set this parameter to the value of "nextPageToken" from the previous response. This token can be of any length.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   language: JString
  ##           : Specify the preferred language to search with. See search language codes for available values.
  ##   query: JString (required)
  ##        : Specify a query string for full text search of public text in all profiles.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of people to include in the response, which is used for paging. For any response, the actual number returned might be less than the specified maxResults.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580049 = query.getOrDefault("fields")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "fields", valid_580049
  var valid_580050 = query.getOrDefault("pageToken")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "pageToken", valid_580050
  var valid_580051 = query.getOrDefault("quotaUser")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "quotaUser", valid_580051
  var valid_580052 = query.getOrDefault("alt")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = newJString("json"))
  if valid_580052 != nil:
    section.add "alt", valid_580052
  var valid_580053 = query.getOrDefault("language")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = newJString("en-US"))
  if valid_580053 != nil:
    section.add "language", valid_580053
  assert query != nil, "query argument is necessary due to required `query` field"
  var valid_580054 = query.getOrDefault("query")
  valid_580054 = validateParameter(valid_580054, JString, required = true,
                                 default = nil)
  if valid_580054 != nil:
    section.add "query", valid_580054
  var valid_580055 = query.getOrDefault("oauth_token")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "oauth_token", valid_580055
  var valid_580056 = query.getOrDefault("userIp")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "userIp", valid_580056
  var valid_580057 = query.getOrDefault("maxResults")
  valid_580057 = validateParameter(valid_580057, JInt, required = false,
                                 default = newJInt(25))
  if valid_580057 != nil:
    section.add "maxResults", valid_580057
  var valid_580058 = query.getOrDefault("key")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "key", valid_580058
  var valid_580059 = query.getOrDefault("prettyPrint")
  valid_580059 = validateParameter(valid_580059, JBool, required = false,
                                 default = newJBool(true))
  if valid_580059 != nil:
    section.add "prettyPrint", valid_580059
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580060: Call_PlusPeopleSearch_580046; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_580060.validator(path, query, header, formData, body)
  let scheme = call_580060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580060.url(scheme.get, call_580060.host, call_580060.base,
                         call_580060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580060, url, valid)

proc call*(call_580061: Call_PlusPeopleSearch_580046; query: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; language: string = "en-US"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 25; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## plusPeopleSearch
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The continuation token, which is used to page through large result sets. To get the next page of results, set this parameter to the value of "nextPageToken" from the previous response. This token can be of any length.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : Specify the preferred language to search with. See search language codes for available values.
  ##   query: string (required)
  ##        : Specify a query string for full text search of public text in all profiles.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of people to include in the response, which is used for paging. For any response, the actual number returned might be less than the specified maxResults.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580062 = newJObject()
  add(query_580062, "fields", newJString(fields))
  add(query_580062, "pageToken", newJString(pageToken))
  add(query_580062, "quotaUser", newJString(quotaUser))
  add(query_580062, "alt", newJString(alt))
  add(query_580062, "language", newJString(language))
  add(query_580062, "query", newJString(query))
  add(query_580062, "oauth_token", newJString(oauthToken))
  add(query_580062, "userIp", newJString(userIp))
  add(query_580062, "maxResults", newJInt(maxResults))
  add(query_580062, "key", newJString(key))
  add(query_580062, "prettyPrint", newJBool(prettyPrint))
  result = call_580061.call(nil, query_580062, nil, nil, nil)

var plusPeopleSearch* = Call_PlusPeopleSearch_580046(name: "plusPeopleSearch",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/people",
    validator: validate_PlusPeopleSearch_580047, base: "/plus/v1",
    url: url_PlusPeopleSearch_580048, schemes: {Scheme.Https})
type
  Call_PlusPeopleGet_580063 = ref object of OpenApiRestCall_579424
proc url_PlusPeopleGet_580065(protocol: Scheme; host: string; base: string;
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

proc validate_PlusPeopleGet_580064(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_580066 = path.getOrDefault("userId")
  valid_580066 = validateParameter(valid_580066, JString, required = true,
                                 default = nil)
  if valid_580066 != nil:
    section.add "userId", valid_580066
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
  var valid_580067 = query.getOrDefault("fields")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "fields", valid_580067
  var valid_580068 = query.getOrDefault("quotaUser")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "quotaUser", valid_580068
  var valid_580069 = query.getOrDefault("alt")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = newJString("json"))
  if valid_580069 != nil:
    section.add "alt", valid_580069
  var valid_580070 = query.getOrDefault("oauth_token")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "oauth_token", valid_580070
  var valid_580071 = query.getOrDefault("userIp")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "userIp", valid_580071
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580074: Call_PlusPeopleGet_580063; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a person's profile. If your app uses scope https://www.googleapis.com/auth/plus.login, this method is guaranteed to return ageRange and language.
  ## 
  let valid = call_580074.validator(path, query, header, formData, body)
  let scheme = call_580074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580074.url(scheme.get, call_580074.host, call_580074.base,
                         call_580074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580074, url, valid)

proc call*(call_580075: Call_PlusPeopleGet_580063; userId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## plusPeopleGet
  ## Get a person's profile. If your app uses scope https://www.googleapis.com/auth/plus.login, this method is guaranteed to return ageRange and language.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The ID of the person to get the profile for. The special value "me" can be used to indicate the authenticated user.
  var path_580076 = newJObject()
  var query_580077 = newJObject()
  add(query_580077, "fields", newJString(fields))
  add(query_580077, "quotaUser", newJString(quotaUser))
  add(query_580077, "alt", newJString(alt))
  add(query_580077, "oauth_token", newJString(oauthToken))
  add(query_580077, "userIp", newJString(userIp))
  add(query_580077, "key", newJString(key))
  add(query_580077, "prettyPrint", newJBool(prettyPrint))
  add(path_580076, "userId", newJString(userId))
  result = call_580075.call(path_580076, query_580077, nil, nil, nil)

var plusPeopleGet* = Call_PlusPeopleGet_580063(name: "plusPeopleGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/people/{userId}",
    validator: validate_PlusPeopleGet_580064, base: "/plus/v1",
    url: url_PlusPeopleGet_580065, schemes: {Scheme.Https})
type
  Call_PlusActivitiesList_580078 = ref object of OpenApiRestCall_579424
proc url_PlusActivitiesList_580080(protocol: Scheme; host: string; base: string;
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

proc validate_PlusActivitiesList_580079(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   collection: JString (required)
  ##             : The collection of activities to list.
  ##   userId: JString (required)
  ##         : The ID of the user to get activities for. The special value "me" can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `collection` field"
  var valid_580081 = path.getOrDefault("collection")
  valid_580081 = validateParameter(valid_580081, JString, required = true,
                                 default = newJString("public"))
  if valid_580081 != nil:
    section.add "collection", valid_580081
  var valid_580082 = path.getOrDefault("userId")
  valid_580082 = validateParameter(valid_580082, JString, required = true,
                                 default = nil)
  if valid_580082 != nil:
    section.add "userId", valid_580082
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The continuation token, which is used to page through large result sets. To get the next page of results, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of activities to include in the response, which is used for paging. For any response, the actual number returned might be less than the specified maxResults.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580083 = query.getOrDefault("fields")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "fields", valid_580083
  var valid_580084 = query.getOrDefault("pageToken")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "pageToken", valid_580084
  var valid_580085 = query.getOrDefault("quotaUser")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "quotaUser", valid_580085
  var valid_580086 = query.getOrDefault("alt")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = newJString("json"))
  if valid_580086 != nil:
    section.add "alt", valid_580086
  var valid_580087 = query.getOrDefault("oauth_token")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "oauth_token", valid_580087
  var valid_580088 = query.getOrDefault("userIp")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = nil)
  if valid_580088 != nil:
    section.add "userIp", valid_580088
  var valid_580089 = query.getOrDefault("maxResults")
  valid_580089 = validateParameter(valid_580089, JInt, required = false,
                                 default = newJInt(20))
  if valid_580089 != nil:
    section.add "maxResults", valid_580089
  var valid_580090 = query.getOrDefault("key")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "key", valid_580090
  var valid_580091 = query.getOrDefault("prettyPrint")
  valid_580091 = validateParameter(valid_580091, JBool, required = false,
                                 default = newJBool(true))
  if valid_580091 != nil:
    section.add "prettyPrint", valid_580091
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580092: Call_PlusActivitiesList_580078; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_580092.validator(path, query, header, formData, body)
  let scheme = call_580092.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580092.url(scheme.get, call_580092.host, call_580092.base,
                         call_580092.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580092, url, valid)

proc call*(call_580093: Call_PlusActivitiesList_580078; userId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; collection: string = "public";
          userIp: string = ""; maxResults: int = 20; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## plusActivitiesList
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The continuation token, which is used to page through large result sets. To get the next page of results, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   collection: string (required)
  ##             : The collection of activities to list.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of activities to include in the response, which is used for paging. For any response, the actual number returned might be less than the specified maxResults.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The ID of the user to get activities for. The special value "me" can be used to indicate the authenticated user.
  var path_580094 = newJObject()
  var query_580095 = newJObject()
  add(query_580095, "fields", newJString(fields))
  add(query_580095, "pageToken", newJString(pageToken))
  add(query_580095, "quotaUser", newJString(quotaUser))
  add(query_580095, "alt", newJString(alt))
  add(query_580095, "oauth_token", newJString(oauthToken))
  add(path_580094, "collection", newJString(collection))
  add(query_580095, "userIp", newJString(userIp))
  add(query_580095, "maxResults", newJInt(maxResults))
  add(query_580095, "key", newJString(key))
  add(query_580095, "prettyPrint", newJBool(prettyPrint))
  add(path_580094, "userId", newJString(userId))
  result = call_580093.call(path_580094, query_580095, nil, nil, nil)

var plusActivitiesList* = Call_PlusActivitiesList_580078(
    name: "plusActivitiesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/people/{userId}/activities/{collection}",
    validator: validate_PlusActivitiesList_580079, base: "/plus/v1",
    url: url_PlusActivitiesList_580080, schemes: {Scheme.Https})
type
  Call_PlusPeopleList_580096 = ref object of OpenApiRestCall_579424
proc url_PlusPeopleList_580098(protocol: Scheme; host: string; base: string;
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

proc validate_PlusPeopleList_580097(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## List all of the people in the specified collection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   collection: JString (required)
  ##             : The collection of people to list.
  ##   userId: JString (required)
  ##         : Get the collection of people for the person identified. Use "me" to indicate the authenticated user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `collection` field"
  var valid_580099 = path.getOrDefault("collection")
  valid_580099 = validateParameter(valid_580099, JString, required = true,
                                 default = newJString("connected"))
  if valid_580099 != nil:
    section.add "collection", valid_580099
  var valid_580100 = path.getOrDefault("userId")
  valid_580100 = validateParameter(valid_580100, JString, required = true,
                                 default = nil)
  if valid_580100 != nil:
    section.add "userId", valid_580100
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The continuation token, which is used to page through large result sets. To get the next page of results, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maximum number of people to include in the response, which is used for paging. For any response, the actual number returned might be less than the specified maxResults.
  ##   orderBy: JString
  ##          : The order to return people in.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580101 = query.getOrDefault("fields")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "fields", valid_580101
  var valid_580102 = query.getOrDefault("pageToken")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "pageToken", valid_580102
  var valid_580103 = query.getOrDefault("quotaUser")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "quotaUser", valid_580103
  var valid_580104 = query.getOrDefault("alt")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = newJString("json"))
  if valid_580104 != nil:
    section.add "alt", valid_580104
  var valid_580105 = query.getOrDefault("oauth_token")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "oauth_token", valid_580105
  var valid_580106 = query.getOrDefault("userIp")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "userIp", valid_580106
  var valid_580107 = query.getOrDefault("maxResults")
  valid_580107 = validateParameter(valid_580107, JInt, required = false,
                                 default = newJInt(100))
  if valid_580107 != nil:
    section.add "maxResults", valid_580107
  var valid_580108 = query.getOrDefault("orderBy")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = newJString("alphabetical"))
  if valid_580108 != nil:
    section.add "orderBy", valid_580108
  var valid_580109 = query.getOrDefault("key")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "key", valid_580109
  var valid_580110 = query.getOrDefault("prettyPrint")
  valid_580110 = validateParameter(valid_580110, JBool, required = false,
                                 default = newJBool(true))
  if valid_580110 != nil:
    section.add "prettyPrint", valid_580110
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580111: Call_PlusPeopleList_580096; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all of the people in the specified collection.
  ## 
  let valid = call_580111.validator(path, query, header, formData, body)
  let scheme = call_580111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580111.url(scheme.get, call_580111.host, call_580111.base,
                         call_580111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580111, url, valid)

proc call*(call_580112: Call_PlusPeopleList_580096; userId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = "";
          collection: string = "connected"; userIp: string = ""; maxResults: int = 100;
          orderBy: string = "alphabetical"; key: string = ""; prettyPrint: bool = true): Recallable =
  ## plusPeopleList
  ## List all of the people in the specified collection.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The continuation token, which is used to page through large result sets. To get the next page of results, set this parameter to the value of "nextPageToken" from the previous response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   collection: string (required)
  ##             : The collection of people to list.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of people to include in the response, which is used for paging. For any response, the actual number returned might be less than the specified maxResults.
  ##   orderBy: string
  ##          : The order to return people in.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : Get the collection of people for the person identified. Use "me" to indicate the authenticated user.
  var path_580113 = newJObject()
  var query_580114 = newJObject()
  add(query_580114, "fields", newJString(fields))
  add(query_580114, "pageToken", newJString(pageToken))
  add(query_580114, "quotaUser", newJString(quotaUser))
  add(query_580114, "alt", newJString(alt))
  add(query_580114, "oauth_token", newJString(oauthToken))
  add(path_580113, "collection", newJString(collection))
  add(query_580114, "userIp", newJString(userIp))
  add(query_580114, "maxResults", newJInt(maxResults))
  add(query_580114, "orderBy", newJString(orderBy))
  add(query_580114, "key", newJString(key))
  add(query_580114, "prettyPrint", newJBool(prettyPrint))
  add(path_580113, "userId", newJString(userId))
  result = call_580112.call(path_580113, query_580114, nil, nil, nil)

var plusPeopleList* = Call_PlusPeopleList_580096(name: "plusPeopleList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/people/{userId}/people/{collection}",
    validator: validate_PlusPeopleList_580097, base: "/plus/v1",
    url: url_PlusPeopleList_580098, schemes: {Scheme.Https})
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
