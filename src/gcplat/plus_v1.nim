
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PlusActivitiesSearch_593692 = ref object of OpenApiRestCall_593424
proc url_PlusActivitiesSearch_593694(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PlusActivitiesSearch_593693(path: JsonNode; query: JsonNode;
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
  var valid_593806 = query.getOrDefault("fields")
  valid_593806 = validateParameter(valid_593806, JString, required = false,
                                 default = nil)
  if valid_593806 != nil:
    section.add "fields", valid_593806
  var valid_593807 = query.getOrDefault("pageToken")
  valid_593807 = validateParameter(valid_593807, JString, required = false,
                                 default = nil)
  if valid_593807 != nil:
    section.add "pageToken", valid_593807
  var valid_593808 = query.getOrDefault("quotaUser")
  valid_593808 = validateParameter(valid_593808, JString, required = false,
                                 default = nil)
  if valid_593808 != nil:
    section.add "quotaUser", valid_593808
  var valid_593822 = query.getOrDefault("alt")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = newJString("json"))
  if valid_593822 != nil:
    section.add "alt", valid_593822
  var valid_593823 = query.getOrDefault("language")
  valid_593823 = validateParameter(valid_593823, JString, required = false,
                                 default = newJString("en-US"))
  if valid_593823 != nil:
    section.add "language", valid_593823
  assert query != nil, "query argument is necessary due to required `query` field"
  var valid_593824 = query.getOrDefault("query")
  valid_593824 = validateParameter(valid_593824, JString, required = true,
                                 default = nil)
  if valid_593824 != nil:
    section.add "query", valid_593824
  var valid_593825 = query.getOrDefault("oauth_token")
  valid_593825 = validateParameter(valid_593825, JString, required = false,
                                 default = nil)
  if valid_593825 != nil:
    section.add "oauth_token", valid_593825
  var valid_593826 = query.getOrDefault("userIp")
  valid_593826 = validateParameter(valid_593826, JString, required = false,
                                 default = nil)
  if valid_593826 != nil:
    section.add "userIp", valid_593826
  var valid_593828 = query.getOrDefault("maxResults")
  valid_593828 = validateParameter(valid_593828, JInt, required = false,
                                 default = newJInt(10))
  if valid_593828 != nil:
    section.add "maxResults", valid_593828
  var valid_593829 = query.getOrDefault("orderBy")
  valid_593829 = validateParameter(valid_593829, JString, required = false,
                                 default = newJString("recent"))
  if valid_593829 != nil:
    section.add "orderBy", valid_593829
  var valid_593830 = query.getOrDefault("key")
  valid_593830 = validateParameter(valid_593830, JString, required = false,
                                 default = nil)
  if valid_593830 != nil:
    section.add "key", valid_593830
  var valid_593831 = query.getOrDefault("prettyPrint")
  valid_593831 = validateParameter(valid_593831, JBool, required = false,
                                 default = newJBool(true))
  if valid_593831 != nil:
    section.add "prettyPrint", valid_593831
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593854: Call_PlusActivitiesSearch_593692; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_593854.validator(path, query, header, formData, body)
  let scheme = call_593854.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593854.url(scheme.get, call_593854.host, call_593854.base,
                         call_593854.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593854, url, valid)

proc call*(call_593925: Call_PlusActivitiesSearch_593692; query: string;
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
  var query_593926 = newJObject()
  add(query_593926, "fields", newJString(fields))
  add(query_593926, "pageToken", newJString(pageToken))
  add(query_593926, "quotaUser", newJString(quotaUser))
  add(query_593926, "alt", newJString(alt))
  add(query_593926, "language", newJString(language))
  add(query_593926, "query", newJString(query))
  add(query_593926, "oauth_token", newJString(oauthToken))
  add(query_593926, "userIp", newJString(userIp))
  add(query_593926, "maxResults", newJInt(maxResults))
  add(query_593926, "orderBy", newJString(orderBy))
  add(query_593926, "key", newJString(key))
  add(query_593926, "prettyPrint", newJBool(prettyPrint))
  result = call_593925.call(nil, query_593926, nil, nil, nil)

var plusActivitiesSearch* = Call_PlusActivitiesSearch_593692(
    name: "plusActivitiesSearch", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/activities",
    validator: validate_PlusActivitiesSearch_593693, base: "/plus/v1",
    url: url_PlusActivitiesSearch_593694, schemes: {Scheme.Https})
type
  Call_PlusActivitiesGet_593966 = ref object of OpenApiRestCall_593424
proc url_PlusActivitiesGet_593968(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "activityId" in path, "`activityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/activities/"),
               (kind: VariableSegment, value: "activityId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PlusActivitiesGet_593967(path: JsonNode; query: JsonNode;
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
  var valid_593983 = path.getOrDefault("activityId")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "activityId", valid_593983
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
  var valid_593984 = query.getOrDefault("fields")
  valid_593984 = validateParameter(valid_593984, JString, required = false,
                                 default = nil)
  if valid_593984 != nil:
    section.add "fields", valid_593984
  var valid_593985 = query.getOrDefault("quotaUser")
  valid_593985 = validateParameter(valid_593985, JString, required = false,
                                 default = nil)
  if valid_593985 != nil:
    section.add "quotaUser", valid_593985
  var valid_593986 = query.getOrDefault("alt")
  valid_593986 = validateParameter(valid_593986, JString, required = false,
                                 default = newJString("json"))
  if valid_593986 != nil:
    section.add "alt", valid_593986
  var valid_593987 = query.getOrDefault("oauth_token")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = nil)
  if valid_593987 != nil:
    section.add "oauth_token", valid_593987
  var valid_593988 = query.getOrDefault("userIp")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "userIp", valid_593988
  var valid_593989 = query.getOrDefault("key")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "key", valid_593989
  var valid_593990 = query.getOrDefault("prettyPrint")
  valid_593990 = validateParameter(valid_593990, JBool, required = false,
                                 default = newJBool(true))
  if valid_593990 != nil:
    section.add "prettyPrint", valid_593990
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593991: Call_PlusActivitiesGet_593966; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_593991.validator(path, query, header, formData, body)
  let scheme = call_593991.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593991.url(scheme.get, call_593991.host, call_593991.base,
                         call_593991.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593991, url, valid)

proc call*(call_593992: Call_PlusActivitiesGet_593966; activityId: string;
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
  var path_593993 = newJObject()
  var query_593994 = newJObject()
  add(query_593994, "fields", newJString(fields))
  add(query_593994, "quotaUser", newJString(quotaUser))
  add(query_593994, "alt", newJString(alt))
  add(query_593994, "oauth_token", newJString(oauthToken))
  add(path_593993, "activityId", newJString(activityId))
  add(query_593994, "userIp", newJString(userIp))
  add(query_593994, "key", newJString(key))
  add(query_593994, "prettyPrint", newJBool(prettyPrint))
  result = call_593992.call(path_593993, query_593994, nil, nil, nil)

var plusActivitiesGet* = Call_PlusActivitiesGet_593966(name: "plusActivitiesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/activities/{activityId}", validator: validate_PlusActivitiesGet_593967,
    base: "/plus/v1", url: url_PlusActivitiesGet_593968, schemes: {Scheme.Https})
type
  Call_PlusCommentsList_593995 = ref object of OpenApiRestCall_593424
proc url_PlusCommentsList_593997(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_PlusCommentsList_593996(path: JsonNode; query: JsonNode;
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
  var valid_593998 = path.getOrDefault("activityId")
  valid_593998 = validateParameter(valid_593998, JString, required = true,
                                 default = nil)
  if valid_593998 != nil:
    section.add "activityId", valid_593998
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
  var valid_593999 = query.getOrDefault("fields")
  valid_593999 = validateParameter(valid_593999, JString, required = false,
                                 default = nil)
  if valid_593999 != nil:
    section.add "fields", valid_593999
  var valid_594000 = query.getOrDefault("pageToken")
  valid_594000 = validateParameter(valid_594000, JString, required = false,
                                 default = nil)
  if valid_594000 != nil:
    section.add "pageToken", valid_594000
  var valid_594001 = query.getOrDefault("quotaUser")
  valid_594001 = validateParameter(valid_594001, JString, required = false,
                                 default = nil)
  if valid_594001 != nil:
    section.add "quotaUser", valid_594001
  var valid_594002 = query.getOrDefault("alt")
  valid_594002 = validateParameter(valid_594002, JString, required = false,
                                 default = newJString("json"))
  if valid_594002 != nil:
    section.add "alt", valid_594002
  var valid_594003 = query.getOrDefault("oauth_token")
  valid_594003 = validateParameter(valid_594003, JString, required = false,
                                 default = nil)
  if valid_594003 != nil:
    section.add "oauth_token", valid_594003
  var valid_594004 = query.getOrDefault("userIp")
  valid_594004 = validateParameter(valid_594004, JString, required = false,
                                 default = nil)
  if valid_594004 != nil:
    section.add "userIp", valid_594004
  var valid_594005 = query.getOrDefault("maxResults")
  valid_594005 = validateParameter(valid_594005, JInt, required = false,
                                 default = newJInt(20))
  if valid_594005 != nil:
    section.add "maxResults", valid_594005
  var valid_594006 = query.getOrDefault("key")
  valid_594006 = validateParameter(valid_594006, JString, required = false,
                                 default = nil)
  if valid_594006 != nil:
    section.add "key", valid_594006
  var valid_594007 = query.getOrDefault("sortOrder")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = newJString("ascending"))
  if valid_594007 != nil:
    section.add "sortOrder", valid_594007
  var valid_594008 = query.getOrDefault("prettyPrint")
  valid_594008 = validateParameter(valid_594008, JBool, required = false,
                                 default = newJBool(true))
  if valid_594008 != nil:
    section.add "prettyPrint", valid_594008
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594009: Call_PlusCommentsList_593995; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_594009.validator(path, query, header, formData, body)
  let scheme = call_594009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594009.url(scheme.get, call_594009.host, call_594009.base,
                         call_594009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594009, url, valid)

proc call*(call_594010: Call_PlusCommentsList_593995; activityId: string;
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
  var path_594011 = newJObject()
  var query_594012 = newJObject()
  add(query_594012, "fields", newJString(fields))
  add(query_594012, "pageToken", newJString(pageToken))
  add(query_594012, "quotaUser", newJString(quotaUser))
  add(query_594012, "alt", newJString(alt))
  add(query_594012, "oauth_token", newJString(oauthToken))
  add(path_594011, "activityId", newJString(activityId))
  add(query_594012, "userIp", newJString(userIp))
  add(query_594012, "maxResults", newJInt(maxResults))
  add(query_594012, "key", newJString(key))
  add(query_594012, "sortOrder", newJString(sortOrder))
  add(query_594012, "prettyPrint", newJBool(prettyPrint))
  result = call_594010.call(path_594011, query_594012, nil, nil, nil)

var plusCommentsList* = Call_PlusCommentsList_593995(name: "plusCommentsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/activities/{activityId}/comments",
    validator: validate_PlusCommentsList_593996, base: "/plus/v1",
    url: url_PlusCommentsList_593997, schemes: {Scheme.Https})
type
  Call_PlusPeopleListByActivity_594013 = ref object of OpenApiRestCall_593424
proc url_PlusPeopleListByActivity_594015(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_PlusPeopleListByActivity_594014(path: JsonNode; query: JsonNode;
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
  var valid_594016 = path.getOrDefault("activityId")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = nil)
  if valid_594016 != nil:
    section.add "activityId", valid_594016
  var valid_594017 = path.getOrDefault("collection")
  valid_594017 = validateParameter(valid_594017, JString, required = true,
                                 default = newJString("plusoners"))
  if valid_594017 != nil:
    section.add "collection", valid_594017
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
  var valid_594018 = query.getOrDefault("fields")
  valid_594018 = validateParameter(valid_594018, JString, required = false,
                                 default = nil)
  if valid_594018 != nil:
    section.add "fields", valid_594018
  var valid_594019 = query.getOrDefault("pageToken")
  valid_594019 = validateParameter(valid_594019, JString, required = false,
                                 default = nil)
  if valid_594019 != nil:
    section.add "pageToken", valid_594019
  var valid_594020 = query.getOrDefault("quotaUser")
  valid_594020 = validateParameter(valid_594020, JString, required = false,
                                 default = nil)
  if valid_594020 != nil:
    section.add "quotaUser", valid_594020
  var valid_594021 = query.getOrDefault("alt")
  valid_594021 = validateParameter(valid_594021, JString, required = false,
                                 default = newJString("json"))
  if valid_594021 != nil:
    section.add "alt", valid_594021
  var valid_594022 = query.getOrDefault("oauth_token")
  valid_594022 = validateParameter(valid_594022, JString, required = false,
                                 default = nil)
  if valid_594022 != nil:
    section.add "oauth_token", valid_594022
  var valid_594023 = query.getOrDefault("userIp")
  valid_594023 = validateParameter(valid_594023, JString, required = false,
                                 default = nil)
  if valid_594023 != nil:
    section.add "userIp", valid_594023
  var valid_594024 = query.getOrDefault("maxResults")
  valid_594024 = validateParameter(valid_594024, JInt, required = false,
                                 default = newJInt(20))
  if valid_594024 != nil:
    section.add "maxResults", valid_594024
  var valid_594025 = query.getOrDefault("key")
  valid_594025 = validateParameter(valid_594025, JString, required = false,
                                 default = nil)
  if valid_594025 != nil:
    section.add "key", valid_594025
  var valid_594026 = query.getOrDefault("prettyPrint")
  valid_594026 = validateParameter(valid_594026, JBool, required = false,
                                 default = newJBool(true))
  if valid_594026 != nil:
    section.add "prettyPrint", valid_594026
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594027: Call_PlusPeopleListByActivity_594013; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_594027.validator(path, query, header, formData, body)
  let scheme = call_594027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594027.url(scheme.get, call_594027.host, call_594027.base,
                         call_594027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594027, url, valid)

proc call*(call_594028: Call_PlusPeopleListByActivity_594013; activityId: string;
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
  var path_594029 = newJObject()
  var query_594030 = newJObject()
  add(query_594030, "fields", newJString(fields))
  add(query_594030, "pageToken", newJString(pageToken))
  add(query_594030, "quotaUser", newJString(quotaUser))
  add(query_594030, "alt", newJString(alt))
  add(query_594030, "oauth_token", newJString(oauthToken))
  add(path_594029, "activityId", newJString(activityId))
  add(path_594029, "collection", newJString(collection))
  add(query_594030, "userIp", newJString(userIp))
  add(query_594030, "maxResults", newJInt(maxResults))
  add(query_594030, "key", newJString(key))
  add(query_594030, "prettyPrint", newJBool(prettyPrint))
  result = call_594028.call(path_594029, query_594030, nil, nil, nil)

var plusPeopleListByActivity* = Call_PlusPeopleListByActivity_594013(
    name: "plusPeopleListByActivity", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/activities/{activityId}/people/{collection}",
    validator: validate_PlusPeopleListByActivity_594014, base: "/plus/v1",
    url: url_PlusPeopleListByActivity_594015, schemes: {Scheme.Https})
type
  Call_PlusCommentsGet_594031 = ref object of OpenApiRestCall_593424
proc url_PlusCommentsGet_594033(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "commentId" in path, "`commentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/comments/"),
               (kind: VariableSegment, value: "commentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PlusCommentsGet_594032(path: JsonNode; query: JsonNode;
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
  var valid_594034 = path.getOrDefault("commentId")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "commentId", valid_594034
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
  var valid_594035 = query.getOrDefault("fields")
  valid_594035 = validateParameter(valid_594035, JString, required = false,
                                 default = nil)
  if valid_594035 != nil:
    section.add "fields", valid_594035
  var valid_594036 = query.getOrDefault("quotaUser")
  valid_594036 = validateParameter(valid_594036, JString, required = false,
                                 default = nil)
  if valid_594036 != nil:
    section.add "quotaUser", valid_594036
  var valid_594037 = query.getOrDefault("alt")
  valid_594037 = validateParameter(valid_594037, JString, required = false,
                                 default = newJString("json"))
  if valid_594037 != nil:
    section.add "alt", valid_594037
  var valid_594038 = query.getOrDefault("oauth_token")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = nil)
  if valid_594038 != nil:
    section.add "oauth_token", valid_594038
  var valid_594039 = query.getOrDefault("userIp")
  valid_594039 = validateParameter(valid_594039, JString, required = false,
                                 default = nil)
  if valid_594039 != nil:
    section.add "userIp", valid_594039
  var valid_594040 = query.getOrDefault("key")
  valid_594040 = validateParameter(valid_594040, JString, required = false,
                                 default = nil)
  if valid_594040 != nil:
    section.add "key", valid_594040
  var valid_594041 = query.getOrDefault("prettyPrint")
  valid_594041 = validateParameter(valid_594041, JBool, required = false,
                                 default = newJBool(true))
  if valid_594041 != nil:
    section.add "prettyPrint", valid_594041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594042: Call_PlusCommentsGet_594031; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_594042.validator(path, query, header, formData, body)
  let scheme = call_594042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594042.url(scheme.get, call_594042.host, call_594042.base,
                         call_594042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594042, url, valid)

proc call*(call_594043: Call_PlusCommentsGet_594031; commentId: string;
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
  var path_594044 = newJObject()
  var query_594045 = newJObject()
  add(query_594045, "fields", newJString(fields))
  add(query_594045, "quotaUser", newJString(quotaUser))
  add(query_594045, "alt", newJString(alt))
  add(query_594045, "oauth_token", newJString(oauthToken))
  add(query_594045, "userIp", newJString(userIp))
  add(query_594045, "key", newJString(key))
  add(path_594044, "commentId", newJString(commentId))
  add(query_594045, "prettyPrint", newJBool(prettyPrint))
  result = call_594043.call(path_594044, query_594045, nil, nil, nil)

var plusCommentsGet* = Call_PlusCommentsGet_594031(name: "plusCommentsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/comments/{commentId}", validator: validate_PlusCommentsGet_594032,
    base: "/plus/v1", url: url_PlusCommentsGet_594033, schemes: {Scheme.Https})
type
  Call_PlusPeopleSearch_594046 = ref object of OpenApiRestCall_593424
proc url_PlusPeopleSearch_594048(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PlusPeopleSearch_594047(path: JsonNode; query: JsonNode;
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
  var valid_594049 = query.getOrDefault("fields")
  valid_594049 = validateParameter(valid_594049, JString, required = false,
                                 default = nil)
  if valid_594049 != nil:
    section.add "fields", valid_594049
  var valid_594050 = query.getOrDefault("pageToken")
  valid_594050 = validateParameter(valid_594050, JString, required = false,
                                 default = nil)
  if valid_594050 != nil:
    section.add "pageToken", valid_594050
  var valid_594051 = query.getOrDefault("quotaUser")
  valid_594051 = validateParameter(valid_594051, JString, required = false,
                                 default = nil)
  if valid_594051 != nil:
    section.add "quotaUser", valid_594051
  var valid_594052 = query.getOrDefault("alt")
  valid_594052 = validateParameter(valid_594052, JString, required = false,
                                 default = newJString("json"))
  if valid_594052 != nil:
    section.add "alt", valid_594052
  var valid_594053 = query.getOrDefault("language")
  valid_594053 = validateParameter(valid_594053, JString, required = false,
                                 default = newJString("en-US"))
  if valid_594053 != nil:
    section.add "language", valid_594053
  assert query != nil, "query argument is necessary due to required `query` field"
  var valid_594054 = query.getOrDefault("query")
  valid_594054 = validateParameter(valid_594054, JString, required = true,
                                 default = nil)
  if valid_594054 != nil:
    section.add "query", valid_594054
  var valid_594055 = query.getOrDefault("oauth_token")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = nil)
  if valid_594055 != nil:
    section.add "oauth_token", valid_594055
  var valid_594056 = query.getOrDefault("userIp")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = nil)
  if valid_594056 != nil:
    section.add "userIp", valid_594056
  var valid_594057 = query.getOrDefault("maxResults")
  valid_594057 = validateParameter(valid_594057, JInt, required = false,
                                 default = newJInt(25))
  if valid_594057 != nil:
    section.add "maxResults", valid_594057
  var valid_594058 = query.getOrDefault("key")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = nil)
  if valid_594058 != nil:
    section.add "key", valid_594058
  var valid_594059 = query.getOrDefault("prettyPrint")
  valid_594059 = validateParameter(valid_594059, JBool, required = false,
                                 default = newJBool(true))
  if valid_594059 != nil:
    section.add "prettyPrint", valid_594059
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594060: Call_PlusPeopleSearch_594046; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_594060.validator(path, query, header, formData, body)
  let scheme = call_594060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594060.url(scheme.get, call_594060.host, call_594060.base,
                         call_594060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594060, url, valid)

proc call*(call_594061: Call_PlusPeopleSearch_594046; query: string;
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
  var query_594062 = newJObject()
  add(query_594062, "fields", newJString(fields))
  add(query_594062, "pageToken", newJString(pageToken))
  add(query_594062, "quotaUser", newJString(quotaUser))
  add(query_594062, "alt", newJString(alt))
  add(query_594062, "language", newJString(language))
  add(query_594062, "query", newJString(query))
  add(query_594062, "oauth_token", newJString(oauthToken))
  add(query_594062, "userIp", newJString(userIp))
  add(query_594062, "maxResults", newJInt(maxResults))
  add(query_594062, "key", newJString(key))
  add(query_594062, "prettyPrint", newJBool(prettyPrint))
  result = call_594061.call(nil, query_594062, nil, nil, nil)

var plusPeopleSearch* = Call_PlusPeopleSearch_594046(name: "plusPeopleSearch",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/people",
    validator: validate_PlusPeopleSearch_594047, base: "/plus/v1",
    url: url_PlusPeopleSearch_594048, schemes: {Scheme.Https})
type
  Call_PlusPeopleGet_594063 = ref object of OpenApiRestCall_593424
proc url_PlusPeopleGet_594065(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/people/"),
               (kind: VariableSegment, value: "userId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PlusPeopleGet_594064(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594066 = path.getOrDefault("userId")
  valid_594066 = validateParameter(valid_594066, JString, required = true,
                                 default = nil)
  if valid_594066 != nil:
    section.add "userId", valid_594066
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
  var valid_594067 = query.getOrDefault("fields")
  valid_594067 = validateParameter(valid_594067, JString, required = false,
                                 default = nil)
  if valid_594067 != nil:
    section.add "fields", valid_594067
  var valid_594068 = query.getOrDefault("quotaUser")
  valid_594068 = validateParameter(valid_594068, JString, required = false,
                                 default = nil)
  if valid_594068 != nil:
    section.add "quotaUser", valid_594068
  var valid_594069 = query.getOrDefault("alt")
  valid_594069 = validateParameter(valid_594069, JString, required = false,
                                 default = newJString("json"))
  if valid_594069 != nil:
    section.add "alt", valid_594069
  var valid_594070 = query.getOrDefault("oauth_token")
  valid_594070 = validateParameter(valid_594070, JString, required = false,
                                 default = nil)
  if valid_594070 != nil:
    section.add "oauth_token", valid_594070
  var valid_594071 = query.getOrDefault("userIp")
  valid_594071 = validateParameter(valid_594071, JString, required = false,
                                 default = nil)
  if valid_594071 != nil:
    section.add "userIp", valid_594071
  var valid_594072 = query.getOrDefault("key")
  valid_594072 = validateParameter(valid_594072, JString, required = false,
                                 default = nil)
  if valid_594072 != nil:
    section.add "key", valid_594072
  var valid_594073 = query.getOrDefault("prettyPrint")
  valid_594073 = validateParameter(valid_594073, JBool, required = false,
                                 default = newJBool(true))
  if valid_594073 != nil:
    section.add "prettyPrint", valid_594073
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594074: Call_PlusPeopleGet_594063; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a person's profile. If your app uses scope https://www.googleapis.com/auth/plus.login, this method is guaranteed to return ageRange and language.
  ## 
  let valid = call_594074.validator(path, query, header, formData, body)
  let scheme = call_594074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594074.url(scheme.get, call_594074.host, call_594074.base,
                         call_594074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594074, url, valid)

proc call*(call_594075: Call_PlusPeopleGet_594063; userId: string;
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
  var path_594076 = newJObject()
  var query_594077 = newJObject()
  add(query_594077, "fields", newJString(fields))
  add(query_594077, "quotaUser", newJString(quotaUser))
  add(query_594077, "alt", newJString(alt))
  add(query_594077, "oauth_token", newJString(oauthToken))
  add(query_594077, "userIp", newJString(userIp))
  add(query_594077, "key", newJString(key))
  add(query_594077, "prettyPrint", newJBool(prettyPrint))
  add(path_594076, "userId", newJString(userId))
  result = call_594075.call(path_594076, query_594077, nil, nil, nil)

var plusPeopleGet* = Call_PlusPeopleGet_594063(name: "plusPeopleGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/people/{userId}",
    validator: validate_PlusPeopleGet_594064, base: "/plus/v1",
    url: url_PlusPeopleGet_594065, schemes: {Scheme.Https})
type
  Call_PlusActivitiesList_594078 = ref object of OpenApiRestCall_593424
proc url_PlusActivitiesList_594080(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_PlusActivitiesList_594079(path: JsonNode; query: JsonNode;
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
  var valid_594081 = path.getOrDefault("collection")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = newJString("public"))
  if valid_594081 != nil:
    section.add "collection", valid_594081
  var valid_594082 = path.getOrDefault("userId")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "userId", valid_594082
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
  var valid_594083 = query.getOrDefault("fields")
  valid_594083 = validateParameter(valid_594083, JString, required = false,
                                 default = nil)
  if valid_594083 != nil:
    section.add "fields", valid_594083
  var valid_594084 = query.getOrDefault("pageToken")
  valid_594084 = validateParameter(valid_594084, JString, required = false,
                                 default = nil)
  if valid_594084 != nil:
    section.add "pageToken", valid_594084
  var valid_594085 = query.getOrDefault("quotaUser")
  valid_594085 = validateParameter(valid_594085, JString, required = false,
                                 default = nil)
  if valid_594085 != nil:
    section.add "quotaUser", valid_594085
  var valid_594086 = query.getOrDefault("alt")
  valid_594086 = validateParameter(valid_594086, JString, required = false,
                                 default = newJString("json"))
  if valid_594086 != nil:
    section.add "alt", valid_594086
  var valid_594087 = query.getOrDefault("oauth_token")
  valid_594087 = validateParameter(valid_594087, JString, required = false,
                                 default = nil)
  if valid_594087 != nil:
    section.add "oauth_token", valid_594087
  var valid_594088 = query.getOrDefault("userIp")
  valid_594088 = validateParameter(valid_594088, JString, required = false,
                                 default = nil)
  if valid_594088 != nil:
    section.add "userIp", valid_594088
  var valid_594089 = query.getOrDefault("maxResults")
  valid_594089 = validateParameter(valid_594089, JInt, required = false,
                                 default = newJInt(20))
  if valid_594089 != nil:
    section.add "maxResults", valid_594089
  var valid_594090 = query.getOrDefault("key")
  valid_594090 = validateParameter(valid_594090, JString, required = false,
                                 default = nil)
  if valid_594090 != nil:
    section.add "key", valid_594090
  var valid_594091 = query.getOrDefault("prettyPrint")
  valid_594091 = validateParameter(valid_594091, JBool, required = false,
                                 default = newJBool(true))
  if valid_594091 != nil:
    section.add "prettyPrint", valid_594091
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594092: Call_PlusActivitiesList_594078; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_594092.validator(path, query, header, formData, body)
  let scheme = call_594092.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594092.url(scheme.get, call_594092.host, call_594092.base,
                         call_594092.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594092, url, valid)

proc call*(call_594093: Call_PlusActivitiesList_594078; userId: string;
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
  var path_594094 = newJObject()
  var query_594095 = newJObject()
  add(query_594095, "fields", newJString(fields))
  add(query_594095, "pageToken", newJString(pageToken))
  add(query_594095, "quotaUser", newJString(quotaUser))
  add(query_594095, "alt", newJString(alt))
  add(query_594095, "oauth_token", newJString(oauthToken))
  add(path_594094, "collection", newJString(collection))
  add(query_594095, "userIp", newJString(userIp))
  add(query_594095, "maxResults", newJInt(maxResults))
  add(query_594095, "key", newJString(key))
  add(query_594095, "prettyPrint", newJBool(prettyPrint))
  add(path_594094, "userId", newJString(userId))
  result = call_594093.call(path_594094, query_594095, nil, nil, nil)

var plusActivitiesList* = Call_PlusActivitiesList_594078(
    name: "plusActivitiesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/people/{userId}/activities/{collection}",
    validator: validate_PlusActivitiesList_594079, base: "/plus/v1",
    url: url_PlusActivitiesList_594080, schemes: {Scheme.Https})
type
  Call_PlusPeopleList_594096 = ref object of OpenApiRestCall_593424
proc url_PlusPeopleList_594098(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_PlusPeopleList_594097(path: JsonNode; query: JsonNode;
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
  var valid_594099 = path.getOrDefault("collection")
  valid_594099 = validateParameter(valid_594099, JString, required = true,
                                 default = newJString("connected"))
  if valid_594099 != nil:
    section.add "collection", valid_594099
  var valid_594100 = path.getOrDefault("userId")
  valid_594100 = validateParameter(valid_594100, JString, required = true,
                                 default = nil)
  if valid_594100 != nil:
    section.add "userId", valid_594100
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
  var valid_594101 = query.getOrDefault("fields")
  valid_594101 = validateParameter(valid_594101, JString, required = false,
                                 default = nil)
  if valid_594101 != nil:
    section.add "fields", valid_594101
  var valid_594102 = query.getOrDefault("pageToken")
  valid_594102 = validateParameter(valid_594102, JString, required = false,
                                 default = nil)
  if valid_594102 != nil:
    section.add "pageToken", valid_594102
  var valid_594103 = query.getOrDefault("quotaUser")
  valid_594103 = validateParameter(valid_594103, JString, required = false,
                                 default = nil)
  if valid_594103 != nil:
    section.add "quotaUser", valid_594103
  var valid_594104 = query.getOrDefault("alt")
  valid_594104 = validateParameter(valid_594104, JString, required = false,
                                 default = newJString("json"))
  if valid_594104 != nil:
    section.add "alt", valid_594104
  var valid_594105 = query.getOrDefault("oauth_token")
  valid_594105 = validateParameter(valid_594105, JString, required = false,
                                 default = nil)
  if valid_594105 != nil:
    section.add "oauth_token", valid_594105
  var valid_594106 = query.getOrDefault("userIp")
  valid_594106 = validateParameter(valid_594106, JString, required = false,
                                 default = nil)
  if valid_594106 != nil:
    section.add "userIp", valid_594106
  var valid_594107 = query.getOrDefault("maxResults")
  valid_594107 = validateParameter(valid_594107, JInt, required = false,
                                 default = newJInt(100))
  if valid_594107 != nil:
    section.add "maxResults", valid_594107
  var valid_594108 = query.getOrDefault("orderBy")
  valid_594108 = validateParameter(valid_594108, JString, required = false,
                                 default = newJString("alphabetical"))
  if valid_594108 != nil:
    section.add "orderBy", valid_594108
  var valid_594109 = query.getOrDefault("key")
  valid_594109 = validateParameter(valid_594109, JString, required = false,
                                 default = nil)
  if valid_594109 != nil:
    section.add "key", valid_594109
  var valid_594110 = query.getOrDefault("prettyPrint")
  valid_594110 = validateParameter(valid_594110, JBool, required = false,
                                 default = newJBool(true))
  if valid_594110 != nil:
    section.add "prettyPrint", valid_594110
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594111: Call_PlusPeopleList_594096; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all of the people in the specified collection.
  ## 
  let valid = call_594111.validator(path, query, header, formData, body)
  let scheme = call_594111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594111.url(scheme.get, call_594111.host, call_594111.base,
                         call_594111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594111, url, valid)

proc call*(call_594112: Call_PlusPeopleList_594096; userId: string;
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
  var path_594113 = newJObject()
  var query_594114 = newJObject()
  add(query_594114, "fields", newJString(fields))
  add(query_594114, "pageToken", newJString(pageToken))
  add(query_594114, "quotaUser", newJString(quotaUser))
  add(query_594114, "alt", newJString(alt))
  add(query_594114, "oauth_token", newJString(oauthToken))
  add(path_594113, "collection", newJString(collection))
  add(query_594114, "userIp", newJString(userIp))
  add(query_594114, "maxResults", newJInt(maxResults))
  add(query_594114, "orderBy", newJString(orderBy))
  add(query_594114, "key", newJString(key))
  add(query_594114, "prettyPrint", newJBool(prettyPrint))
  add(path_594113, "userId", newJString(userId))
  result = call_594112.call(path_594113, query_594114, nil, nil, nil)

var plusPeopleList* = Call_PlusPeopleList_594096(name: "plusPeopleList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/people/{userId}/people/{collection}",
    validator: validate_PlusPeopleList_594097, base: "/plus/v1",
    url: url_PlusPeopleList_594098, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
