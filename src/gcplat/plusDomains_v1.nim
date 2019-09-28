
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google+ Domains
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Builds on top of the Google+ platform for Google Apps Domains.
## 
## https://developers.google.com/+/domains/
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
  gcpServiceName = "plusDomains"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PlusDomainsActivitiesGet_579692 = ref object of OpenApiRestCall_579424
proc url_PlusDomainsActivitiesGet_579694(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
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

proc validate_PlusDomainsActivitiesGet_579693(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_579820 = path.getOrDefault("activityId")
  valid_579820 = validateParameter(valid_579820, JString, required = true,
                                 default = nil)
  if valid_579820 != nil:
    section.add "activityId", valid_579820
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
  var valid_579821 = query.getOrDefault("fields")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = nil)
  if valid_579821 != nil:
    section.add "fields", valid_579821
  var valid_579822 = query.getOrDefault("quotaUser")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = nil)
  if valid_579822 != nil:
    section.add "quotaUser", valid_579822
  var valid_579836 = query.getOrDefault("alt")
  valid_579836 = validateParameter(valid_579836, JString, required = false,
                                 default = newJString("json"))
  if valid_579836 != nil:
    section.add "alt", valid_579836
  var valid_579837 = query.getOrDefault("oauth_token")
  valid_579837 = validateParameter(valid_579837, JString, required = false,
                                 default = nil)
  if valid_579837 != nil:
    section.add "oauth_token", valid_579837
  var valid_579838 = query.getOrDefault("userIp")
  valid_579838 = validateParameter(valid_579838, JString, required = false,
                                 default = nil)
  if valid_579838 != nil:
    section.add "userIp", valid_579838
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

proc call*(call_579863: Call_PlusDomainsActivitiesGet_579692; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_579863.validator(path, query, header, formData, body)
  let scheme = call_579863.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579863.url(scheme.get, call_579863.host, call_579863.base,
                         call_579863.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579863, url, valid)

proc call*(call_579934: Call_PlusDomainsActivitiesGet_579692; activityId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## plusDomainsActivitiesGet
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
  var path_579935 = newJObject()
  var query_579937 = newJObject()
  add(query_579937, "fields", newJString(fields))
  add(query_579937, "quotaUser", newJString(quotaUser))
  add(query_579937, "alt", newJString(alt))
  add(query_579937, "oauth_token", newJString(oauthToken))
  add(path_579935, "activityId", newJString(activityId))
  add(query_579937, "userIp", newJString(userIp))
  add(query_579937, "key", newJString(key))
  add(query_579937, "prettyPrint", newJBool(prettyPrint))
  result = call_579934.call(path_579935, query_579937, nil, nil, nil)

var plusDomainsActivitiesGet* = Call_PlusDomainsActivitiesGet_579692(
    name: "plusDomainsActivitiesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/activities/{activityId}",
    validator: validate_PlusDomainsActivitiesGet_579693, base: "/plusDomains/v1",
    url: url_PlusDomainsActivitiesGet_579694, schemes: {Scheme.Https})
type
  Call_PlusDomainsCommentsList_579976 = ref object of OpenApiRestCall_579424
proc url_PlusDomainsCommentsList_579978(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
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

proc validate_PlusDomainsCommentsList_579977(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_579979 = path.getOrDefault("activityId")
  valid_579979 = validateParameter(valid_579979, JString, required = true,
                                 default = nil)
  if valid_579979 != nil:
    section.add "activityId", valid_579979
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
  var valid_579980 = query.getOrDefault("fields")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "fields", valid_579980
  var valid_579981 = query.getOrDefault("pageToken")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "pageToken", valid_579981
  var valid_579982 = query.getOrDefault("quotaUser")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "quotaUser", valid_579982
  var valid_579983 = query.getOrDefault("alt")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = newJString("json"))
  if valid_579983 != nil:
    section.add "alt", valid_579983
  var valid_579984 = query.getOrDefault("oauth_token")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "oauth_token", valid_579984
  var valid_579985 = query.getOrDefault("userIp")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "userIp", valid_579985
  var valid_579987 = query.getOrDefault("maxResults")
  valid_579987 = validateParameter(valid_579987, JInt, required = false,
                                 default = newJInt(20))
  if valid_579987 != nil:
    section.add "maxResults", valid_579987
  var valid_579988 = query.getOrDefault("key")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "key", valid_579988
  var valid_579989 = query.getOrDefault("sortOrder")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = newJString("ascending"))
  if valid_579989 != nil:
    section.add "sortOrder", valid_579989
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

proc call*(call_579991: Call_PlusDomainsCommentsList_579976; path: JsonNode;
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

proc call*(call_579992: Call_PlusDomainsCommentsList_579976; activityId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 20; key: string = ""; sortOrder: string = "ascending";
          prettyPrint: bool = true): Recallable =
  ## plusDomainsCommentsList
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
  var path_579993 = newJObject()
  var query_579994 = newJObject()
  add(query_579994, "fields", newJString(fields))
  add(query_579994, "pageToken", newJString(pageToken))
  add(query_579994, "quotaUser", newJString(quotaUser))
  add(query_579994, "alt", newJString(alt))
  add(query_579994, "oauth_token", newJString(oauthToken))
  add(path_579993, "activityId", newJString(activityId))
  add(query_579994, "userIp", newJString(userIp))
  add(query_579994, "maxResults", newJInt(maxResults))
  add(query_579994, "key", newJString(key))
  add(query_579994, "sortOrder", newJString(sortOrder))
  add(query_579994, "prettyPrint", newJBool(prettyPrint))
  result = call_579992.call(path_579993, query_579994, nil, nil, nil)

var plusDomainsCommentsList* = Call_PlusDomainsCommentsList_579976(
    name: "plusDomainsCommentsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/activities/{activityId}/comments",
    validator: validate_PlusDomainsCommentsList_579977, base: "/plusDomains/v1",
    url: url_PlusDomainsCommentsList_579978, schemes: {Scheme.Https})
type
  Call_PlusDomainsPeopleListByActivity_579995 = ref object of OpenApiRestCall_579424
proc url_PlusDomainsPeopleListByActivity_579997(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_PlusDomainsPeopleListByActivity_579996(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_579998 = path.getOrDefault("activityId")
  valid_579998 = validateParameter(valid_579998, JString, required = true,
                                 default = nil)
  if valid_579998 != nil:
    section.add "activityId", valid_579998
  var valid_579999 = path.getOrDefault("collection")
  valid_579999 = validateParameter(valid_579999, JString, required = true,
                                 default = newJString("plusoners"))
  if valid_579999 != nil:
    section.add "collection", valid_579999
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
  var valid_580000 = query.getOrDefault("fields")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "fields", valid_580000
  var valid_580001 = query.getOrDefault("pageToken")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "pageToken", valid_580001
  var valid_580002 = query.getOrDefault("quotaUser")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "quotaUser", valid_580002
  var valid_580003 = query.getOrDefault("alt")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = newJString("json"))
  if valid_580003 != nil:
    section.add "alt", valid_580003
  var valid_580004 = query.getOrDefault("oauth_token")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "oauth_token", valid_580004
  var valid_580005 = query.getOrDefault("userIp")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "userIp", valid_580005
  var valid_580006 = query.getOrDefault("maxResults")
  valid_580006 = validateParameter(valid_580006, JInt, required = false,
                                 default = newJInt(20))
  if valid_580006 != nil:
    section.add "maxResults", valid_580006
  var valid_580007 = query.getOrDefault("key")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "key", valid_580007
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

proc call*(call_580009: Call_PlusDomainsPeopleListByActivity_579995;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
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

proc call*(call_580010: Call_PlusDomainsPeopleListByActivity_579995;
          activityId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          collection: string = "plusoners"; userIp: string = ""; maxResults: int = 20;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## plusDomainsPeopleListByActivity
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
  var path_580011 = newJObject()
  var query_580012 = newJObject()
  add(query_580012, "fields", newJString(fields))
  add(query_580012, "pageToken", newJString(pageToken))
  add(query_580012, "quotaUser", newJString(quotaUser))
  add(query_580012, "alt", newJString(alt))
  add(query_580012, "oauth_token", newJString(oauthToken))
  add(path_580011, "activityId", newJString(activityId))
  add(path_580011, "collection", newJString(collection))
  add(query_580012, "userIp", newJString(userIp))
  add(query_580012, "maxResults", newJInt(maxResults))
  add(query_580012, "key", newJString(key))
  add(query_580012, "prettyPrint", newJBool(prettyPrint))
  result = call_580010.call(path_580011, query_580012, nil, nil, nil)

var plusDomainsPeopleListByActivity* = Call_PlusDomainsPeopleListByActivity_579995(
    name: "plusDomainsPeopleListByActivity", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/activities/{activityId}/people/{collection}",
    validator: validate_PlusDomainsPeopleListByActivity_579996,
    base: "/plusDomains/v1", url: url_PlusDomainsPeopleListByActivity_579997,
    schemes: {Scheme.Https})
type
  Call_PlusDomainsCommentsGet_580013 = ref object of OpenApiRestCall_579424
proc url_PlusDomainsCommentsGet_580015(protocol: Scheme; host: string; base: string;
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

proc validate_PlusDomainsCommentsGet_580014(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   commentId: JString (required)
  ##            : The ID of the comment to get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `commentId` field"
  var valid_580016 = path.getOrDefault("commentId")
  valid_580016 = validateParameter(valid_580016, JString, required = true,
                                 default = nil)
  if valid_580016 != nil:
    section.add "commentId", valid_580016
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
  var valid_580017 = query.getOrDefault("fields")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "fields", valid_580017
  var valid_580018 = query.getOrDefault("quotaUser")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "quotaUser", valid_580018
  var valid_580019 = query.getOrDefault("alt")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = newJString("json"))
  if valid_580019 != nil:
    section.add "alt", valid_580019
  var valid_580020 = query.getOrDefault("oauth_token")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "oauth_token", valid_580020
  var valid_580021 = query.getOrDefault("userIp")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "userIp", valid_580021
  var valid_580022 = query.getOrDefault("key")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "key", valid_580022
  var valid_580023 = query.getOrDefault("prettyPrint")
  valid_580023 = validateParameter(valid_580023, JBool, required = false,
                                 default = newJBool(true))
  if valid_580023 != nil:
    section.add "prettyPrint", valid_580023
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580024: Call_PlusDomainsCommentsGet_580013; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_580024.validator(path, query, header, formData, body)
  let scheme = call_580024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580024.url(scheme.get, call_580024.host, call_580024.base,
                         call_580024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580024, url, valid)

proc call*(call_580025: Call_PlusDomainsCommentsGet_580013; commentId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## plusDomainsCommentsGet
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
  var path_580026 = newJObject()
  var query_580027 = newJObject()
  add(query_580027, "fields", newJString(fields))
  add(query_580027, "quotaUser", newJString(quotaUser))
  add(query_580027, "alt", newJString(alt))
  add(query_580027, "oauth_token", newJString(oauthToken))
  add(query_580027, "userIp", newJString(userIp))
  add(query_580027, "key", newJString(key))
  add(path_580026, "commentId", newJString(commentId))
  add(query_580027, "prettyPrint", newJBool(prettyPrint))
  result = call_580025.call(path_580026, query_580027, nil, nil, nil)

var plusDomainsCommentsGet* = Call_PlusDomainsCommentsGet_580013(
    name: "plusDomainsCommentsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/comments/{commentId}",
    validator: validate_PlusDomainsCommentsGet_580014, base: "/plusDomains/v1",
    url: url_PlusDomainsCommentsGet_580015, schemes: {Scheme.Https})
type
  Call_PlusDomainsPeopleGet_580028 = ref object of OpenApiRestCall_579424
proc url_PlusDomainsPeopleGet_580030(protocol: Scheme; host: string; base: string;
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

proc validate_PlusDomainsPeopleGet_580029(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a person's profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : The ID of the person to get the profile for. The special value "me" can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_580031 = path.getOrDefault("userId")
  valid_580031 = validateParameter(valid_580031, JString, required = true,
                                 default = nil)
  if valid_580031 != nil:
    section.add "userId", valid_580031
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
  var valid_580032 = query.getOrDefault("fields")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "fields", valid_580032
  var valid_580033 = query.getOrDefault("quotaUser")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "quotaUser", valid_580033
  var valid_580034 = query.getOrDefault("alt")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = newJString("json"))
  if valid_580034 != nil:
    section.add "alt", valid_580034
  var valid_580035 = query.getOrDefault("oauth_token")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "oauth_token", valid_580035
  var valid_580036 = query.getOrDefault("userIp")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "userIp", valid_580036
  var valid_580037 = query.getOrDefault("key")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "key", valid_580037
  var valid_580038 = query.getOrDefault("prettyPrint")
  valid_580038 = validateParameter(valid_580038, JBool, required = false,
                                 default = newJBool(true))
  if valid_580038 != nil:
    section.add "prettyPrint", valid_580038
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580039: Call_PlusDomainsPeopleGet_580028; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a person's profile.
  ## 
  let valid = call_580039.validator(path, query, header, formData, body)
  let scheme = call_580039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580039.url(scheme.get, call_580039.host, call_580039.base,
                         call_580039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580039, url, valid)

proc call*(call_580040: Call_PlusDomainsPeopleGet_580028; userId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## plusDomainsPeopleGet
  ## Get a person's profile.
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
  var path_580041 = newJObject()
  var query_580042 = newJObject()
  add(query_580042, "fields", newJString(fields))
  add(query_580042, "quotaUser", newJString(quotaUser))
  add(query_580042, "alt", newJString(alt))
  add(query_580042, "oauth_token", newJString(oauthToken))
  add(query_580042, "userIp", newJString(userIp))
  add(query_580042, "key", newJString(key))
  add(query_580042, "prettyPrint", newJBool(prettyPrint))
  add(path_580041, "userId", newJString(userId))
  result = call_580040.call(path_580041, query_580042, nil, nil, nil)

var plusDomainsPeopleGet* = Call_PlusDomainsPeopleGet_580028(
    name: "plusDomainsPeopleGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/people/{userId}",
    validator: validate_PlusDomainsPeopleGet_580029, base: "/plusDomains/v1",
    url: url_PlusDomainsPeopleGet_580030, schemes: {Scheme.Https})
type
  Call_PlusDomainsActivitiesList_580043 = ref object of OpenApiRestCall_579424
proc url_PlusDomainsActivitiesList_580045(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_PlusDomainsActivitiesList_580044(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_580046 = path.getOrDefault("collection")
  valid_580046 = validateParameter(valid_580046, JString, required = true,
                                 default = newJString("user"))
  if valid_580046 != nil:
    section.add "collection", valid_580046
  var valid_580047 = path.getOrDefault("userId")
  valid_580047 = validateParameter(valid_580047, JString, required = true,
                                 default = nil)
  if valid_580047 != nil:
    section.add "userId", valid_580047
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
  var valid_580048 = query.getOrDefault("fields")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "fields", valid_580048
  var valid_580049 = query.getOrDefault("pageToken")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "pageToken", valid_580049
  var valid_580050 = query.getOrDefault("quotaUser")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "quotaUser", valid_580050
  var valid_580051 = query.getOrDefault("alt")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = newJString("json"))
  if valid_580051 != nil:
    section.add "alt", valid_580051
  var valid_580052 = query.getOrDefault("oauth_token")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "oauth_token", valid_580052
  var valid_580053 = query.getOrDefault("userIp")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "userIp", valid_580053
  var valid_580054 = query.getOrDefault("maxResults")
  valid_580054 = validateParameter(valid_580054, JInt, required = false,
                                 default = newJInt(20))
  if valid_580054 != nil:
    section.add "maxResults", valid_580054
  var valid_580055 = query.getOrDefault("key")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "key", valid_580055
  var valid_580056 = query.getOrDefault("prettyPrint")
  valid_580056 = validateParameter(valid_580056, JBool, required = false,
                                 default = newJBool(true))
  if valid_580056 != nil:
    section.add "prettyPrint", valid_580056
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580057: Call_PlusDomainsActivitiesList_580043; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_580057.validator(path, query, header, formData, body)
  let scheme = call_580057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580057.url(scheme.get, call_580057.host, call_580057.base,
                         call_580057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580057, url, valid)

proc call*(call_580058: Call_PlusDomainsActivitiesList_580043; userId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; collection: string = "user";
          userIp: string = ""; maxResults: int = 20; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## plusDomainsActivitiesList
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
  var path_580059 = newJObject()
  var query_580060 = newJObject()
  add(query_580060, "fields", newJString(fields))
  add(query_580060, "pageToken", newJString(pageToken))
  add(query_580060, "quotaUser", newJString(quotaUser))
  add(query_580060, "alt", newJString(alt))
  add(query_580060, "oauth_token", newJString(oauthToken))
  add(path_580059, "collection", newJString(collection))
  add(query_580060, "userIp", newJString(userIp))
  add(query_580060, "maxResults", newJInt(maxResults))
  add(query_580060, "key", newJString(key))
  add(query_580060, "prettyPrint", newJBool(prettyPrint))
  add(path_580059, "userId", newJString(userId))
  result = call_580058.call(path_580059, query_580060, nil, nil, nil)

var plusDomainsActivitiesList* = Call_PlusDomainsActivitiesList_580043(
    name: "plusDomainsActivitiesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/people/{userId}/activities/{collection}",
    validator: validate_PlusDomainsActivitiesList_580044, base: "/plusDomains/v1",
    url: url_PlusDomainsActivitiesList_580045, schemes: {Scheme.Https})
type
  Call_PlusDomainsAudiencesList_580061 = ref object of OpenApiRestCall_579424
proc url_PlusDomainsAudiencesList_580063(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/people/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/audiences")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PlusDomainsAudiencesList_580062(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : The ID of the user to get audiences for. The special value "me" can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_580064 = path.getOrDefault("userId")
  valid_580064 = validateParameter(valid_580064, JString, required = true,
                                 default = nil)
  if valid_580064 != nil:
    section.add "userId", valid_580064
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
  ##             : The maximum number of circles to include in the response, which is used for paging. For any response, the actual number returned might be less than the specified maxResults.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580065 = query.getOrDefault("fields")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "fields", valid_580065
  var valid_580066 = query.getOrDefault("pageToken")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "pageToken", valid_580066
  var valid_580067 = query.getOrDefault("quotaUser")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "quotaUser", valid_580067
  var valid_580068 = query.getOrDefault("alt")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = newJString("json"))
  if valid_580068 != nil:
    section.add "alt", valid_580068
  var valid_580069 = query.getOrDefault("oauth_token")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "oauth_token", valid_580069
  var valid_580070 = query.getOrDefault("userIp")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "userIp", valid_580070
  var valid_580071 = query.getOrDefault("maxResults")
  valid_580071 = validateParameter(valid_580071, JInt, required = false,
                                 default = newJInt(20))
  if valid_580071 != nil:
    section.add "maxResults", valid_580071
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

proc call*(call_580074: Call_PlusDomainsAudiencesList_580061; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_580074.validator(path, query, header, formData, body)
  let scheme = call_580074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580074.url(scheme.get, call_580074.host, call_580074.base,
                         call_580074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580074, url, valid)

proc call*(call_580075: Call_PlusDomainsAudiencesList_580061; userId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 20; key: string = ""; prettyPrint: bool = true): Recallable =
  ## plusDomainsAudiencesList
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
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of circles to include in the response, which is used for paging. For any response, the actual number returned might be less than the specified maxResults.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The ID of the user to get audiences for. The special value "me" can be used to indicate the authenticated user.
  var path_580076 = newJObject()
  var query_580077 = newJObject()
  add(query_580077, "fields", newJString(fields))
  add(query_580077, "pageToken", newJString(pageToken))
  add(query_580077, "quotaUser", newJString(quotaUser))
  add(query_580077, "alt", newJString(alt))
  add(query_580077, "oauth_token", newJString(oauthToken))
  add(query_580077, "userIp", newJString(userIp))
  add(query_580077, "maxResults", newJInt(maxResults))
  add(query_580077, "key", newJString(key))
  add(query_580077, "prettyPrint", newJBool(prettyPrint))
  add(path_580076, "userId", newJString(userId))
  result = call_580075.call(path_580076, query_580077, nil, nil, nil)

var plusDomainsAudiencesList* = Call_PlusDomainsAudiencesList_580061(
    name: "plusDomainsAudiencesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/people/{userId}/audiences",
    validator: validate_PlusDomainsAudiencesList_580062, base: "/plusDomains/v1",
    url: url_PlusDomainsAudiencesList_580063, schemes: {Scheme.Https})
type
  Call_PlusDomainsCirclesList_580078 = ref object of OpenApiRestCall_579424
proc url_PlusDomainsCirclesList_580080(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/people/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/circles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PlusDomainsCirclesList_580079(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : The ID of the user to get circles for. The special value "me" can be used to indicate the authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_580081 = path.getOrDefault("userId")
  valid_580081 = validateParameter(valid_580081, JString, required = true,
                                 default = nil)
  if valid_580081 != nil:
    section.add "userId", valid_580081
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
  ##             : The maximum number of circles to include in the response, which is used for paging. For any response, the actual number returned might be less than the specified maxResults.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580082 = query.getOrDefault("fields")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "fields", valid_580082
  var valid_580083 = query.getOrDefault("pageToken")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "pageToken", valid_580083
  var valid_580084 = query.getOrDefault("quotaUser")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "quotaUser", valid_580084
  var valid_580085 = query.getOrDefault("alt")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = newJString("json"))
  if valid_580085 != nil:
    section.add "alt", valid_580085
  var valid_580086 = query.getOrDefault("oauth_token")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "oauth_token", valid_580086
  var valid_580087 = query.getOrDefault("userIp")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "userIp", valid_580087
  var valid_580088 = query.getOrDefault("maxResults")
  valid_580088 = validateParameter(valid_580088, JInt, required = false,
                                 default = newJInt(20))
  if valid_580088 != nil:
    section.add "maxResults", valid_580088
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580091: Call_PlusDomainsCirclesList_580078; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_580091.validator(path, query, header, formData, body)
  let scheme = call_580091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580091.url(scheme.get, call_580091.host, call_580091.base,
                         call_580091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580091, url, valid)

proc call*(call_580092: Call_PlusDomainsCirclesList_580078; userId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 20; key: string = ""; prettyPrint: bool = true): Recallable =
  ## plusDomainsCirclesList
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
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maximum number of circles to include in the response, which is used for paging. For any response, the actual number returned might be less than the specified maxResults.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The ID of the user to get circles for. The special value "me" can be used to indicate the authenticated user.
  var path_580093 = newJObject()
  var query_580094 = newJObject()
  add(query_580094, "fields", newJString(fields))
  add(query_580094, "pageToken", newJString(pageToken))
  add(query_580094, "quotaUser", newJString(quotaUser))
  add(query_580094, "alt", newJString(alt))
  add(query_580094, "oauth_token", newJString(oauthToken))
  add(query_580094, "userIp", newJString(userIp))
  add(query_580094, "maxResults", newJInt(maxResults))
  add(query_580094, "key", newJString(key))
  add(query_580094, "prettyPrint", newJBool(prettyPrint))
  add(path_580093, "userId", newJString(userId))
  result = call_580092.call(path_580093, query_580094, nil, nil, nil)

var plusDomainsCirclesList* = Call_PlusDomainsCirclesList_580078(
    name: "plusDomainsCirclesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/people/{userId}/circles",
    validator: validate_PlusDomainsCirclesList_580079, base: "/plusDomains/v1",
    url: url_PlusDomainsCirclesList_580080, schemes: {Scheme.Https})
type
  Call_PlusDomainsMediaInsert_580095 = ref object of OpenApiRestCall_579424
proc url_PlusDomainsMediaInsert_580097(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/media/"),
               (kind: VariableSegment, value: "collection")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PlusDomainsMediaInsert_580096(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   collection: JString (required)
  ##   userId: JString (required)
  ##         : The ID of the user to create the activity on behalf of.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `collection` field"
  var valid_580098 = path.getOrDefault("collection")
  valid_580098 = validateParameter(valid_580098, JString, required = true,
                                 default = newJString("cloud"))
  if valid_580098 != nil:
    section.add "collection", valid_580098
  var valid_580099 = path.getOrDefault("userId")
  valid_580099 = validateParameter(valid_580099, JString, required = true,
                                 default = nil)
  if valid_580099 != nil:
    section.add "userId", valid_580099
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
  var valid_580100 = query.getOrDefault("fields")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "fields", valid_580100
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
  var valid_580105 = query.getOrDefault("key")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "key", valid_580105
  var valid_580106 = query.getOrDefault("prettyPrint")
  valid_580106 = validateParameter(valid_580106, JBool, required = false,
                                 default = newJBool(true))
  if valid_580106 != nil:
    section.add "prettyPrint", valid_580106
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

proc call*(call_580108: Call_PlusDomainsMediaInsert_580095; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_580108.validator(path, query, header, formData, body)
  let scheme = call_580108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580108.url(scheme.get, call_580108.host, call_580108.base,
                         call_580108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580108, url, valid)

proc call*(call_580109: Call_PlusDomainsMediaInsert_580095; userId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; collection: string = "cloud"; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## plusDomainsMediaInsert
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   collection: string (required)
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The ID of the user to create the activity on behalf of.
  var path_580110 = newJObject()
  var query_580111 = newJObject()
  var body_580112 = newJObject()
  add(query_580111, "fields", newJString(fields))
  add(query_580111, "quotaUser", newJString(quotaUser))
  add(query_580111, "alt", newJString(alt))
  add(query_580111, "oauth_token", newJString(oauthToken))
  add(path_580110, "collection", newJString(collection))
  add(query_580111, "userIp", newJString(userIp))
  add(query_580111, "key", newJString(key))
  if body != nil:
    body_580112 = body
  add(query_580111, "prettyPrint", newJBool(prettyPrint))
  add(path_580110, "userId", newJString(userId))
  result = call_580109.call(path_580110, query_580111, nil, nil, body_580112)

var plusDomainsMediaInsert* = Call_PlusDomainsMediaInsert_580095(
    name: "plusDomainsMediaInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/people/{userId}/media/{collection}",
    validator: validate_PlusDomainsMediaInsert_580096, base: "/plusDomains/v1",
    url: url_PlusDomainsMediaInsert_580097, schemes: {Scheme.Https})
type
  Call_PlusDomainsPeopleList_580113 = ref object of OpenApiRestCall_579424
proc url_PlusDomainsPeopleList_580115(protocol: Scheme; host: string; base: string;
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

proc validate_PlusDomainsPeopleList_580114(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_580116 = path.getOrDefault("collection")
  valid_580116 = validateParameter(valid_580116, JString, required = true,
                                 default = newJString("circled"))
  if valid_580116 != nil:
    section.add "collection", valid_580116
  var valid_580117 = path.getOrDefault("userId")
  valid_580117 = validateParameter(valid_580117, JString, required = true,
                                 default = nil)
  if valid_580117 != nil:
    section.add "userId", valid_580117
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
  var valid_580118 = query.getOrDefault("fields")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "fields", valid_580118
  var valid_580119 = query.getOrDefault("pageToken")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "pageToken", valid_580119
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
  var valid_580124 = query.getOrDefault("maxResults")
  valid_580124 = validateParameter(valid_580124, JInt, required = false,
                                 default = newJInt(100))
  if valid_580124 != nil:
    section.add "maxResults", valid_580124
  var valid_580125 = query.getOrDefault("orderBy")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = newJString("alphabetical"))
  if valid_580125 != nil:
    section.add "orderBy", valid_580125
  var valid_580126 = query.getOrDefault("key")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "key", valid_580126
  var valid_580127 = query.getOrDefault("prettyPrint")
  valid_580127 = validateParameter(valid_580127, JBool, required = false,
                                 default = newJBool(true))
  if valid_580127 != nil:
    section.add "prettyPrint", valid_580127
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580128: Call_PlusDomainsPeopleList_580113; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all of the people in the specified collection.
  ## 
  let valid = call_580128.validator(path, query, header, formData, body)
  let scheme = call_580128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580128.url(scheme.get, call_580128.host, call_580128.base,
                         call_580128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580128, url, valid)

proc call*(call_580129: Call_PlusDomainsPeopleList_580113; userId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; collection: string = "circled";
          userIp: string = ""; maxResults: int = 100; orderBy: string = "alphabetical";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## plusDomainsPeopleList
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
  var path_580130 = newJObject()
  var query_580131 = newJObject()
  add(query_580131, "fields", newJString(fields))
  add(query_580131, "pageToken", newJString(pageToken))
  add(query_580131, "quotaUser", newJString(quotaUser))
  add(query_580131, "alt", newJString(alt))
  add(query_580131, "oauth_token", newJString(oauthToken))
  add(path_580130, "collection", newJString(collection))
  add(query_580131, "userIp", newJString(userIp))
  add(query_580131, "maxResults", newJInt(maxResults))
  add(query_580131, "orderBy", newJString(orderBy))
  add(query_580131, "key", newJString(key))
  add(query_580131, "prettyPrint", newJBool(prettyPrint))
  add(path_580130, "userId", newJString(userId))
  result = call_580129.call(path_580130, query_580131, nil, nil, nil)

var plusDomainsPeopleList* = Call_PlusDomainsPeopleList_580113(
    name: "plusDomainsPeopleList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/people/{userId}/people/{collection}",
    validator: validate_PlusDomainsPeopleList_580114, base: "/plusDomains/v1",
    url: url_PlusDomainsPeopleList_580115, schemes: {Scheme.Https})
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
