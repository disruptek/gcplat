
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  gcpServiceName = "plusDomains"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PlusDomainsActivitiesGet_593692 = ref object of OpenApiRestCall_593424
proc url_PlusDomainsActivitiesGet_593694(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
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

proc validate_PlusDomainsActivitiesGet_593693(path: JsonNode; query: JsonNode;
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
  var valid_593820 = path.getOrDefault("activityId")
  valid_593820 = validateParameter(valid_593820, JString, required = true,
                                 default = nil)
  if valid_593820 != nil:
    section.add "activityId", valid_593820
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
  var valid_593821 = query.getOrDefault("fields")
  valid_593821 = validateParameter(valid_593821, JString, required = false,
                                 default = nil)
  if valid_593821 != nil:
    section.add "fields", valid_593821
  var valid_593822 = query.getOrDefault("quotaUser")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = nil)
  if valid_593822 != nil:
    section.add "quotaUser", valid_593822
  var valid_593836 = query.getOrDefault("alt")
  valid_593836 = validateParameter(valid_593836, JString, required = false,
                                 default = newJString("json"))
  if valid_593836 != nil:
    section.add "alt", valid_593836
  var valid_593837 = query.getOrDefault("oauth_token")
  valid_593837 = validateParameter(valid_593837, JString, required = false,
                                 default = nil)
  if valid_593837 != nil:
    section.add "oauth_token", valid_593837
  var valid_593838 = query.getOrDefault("userIp")
  valid_593838 = validateParameter(valid_593838, JString, required = false,
                                 default = nil)
  if valid_593838 != nil:
    section.add "userIp", valid_593838
  var valid_593839 = query.getOrDefault("key")
  valid_593839 = validateParameter(valid_593839, JString, required = false,
                                 default = nil)
  if valid_593839 != nil:
    section.add "key", valid_593839
  var valid_593840 = query.getOrDefault("prettyPrint")
  valid_593840 = validateParameter(valid_593840, JBool, required = false,
                                 default = newJBool(true))
  if valid_593840 != nil:
    section.add "prettyPrint", valid_593840
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593863: Call_PlusDomainsActivitiesGet_593692; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_593863.validator(path, query, header, formData, body)
  let scheme = call_593863.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593863.url(scheme.get, call_593863.host, call_593863.base,
                         call_593863.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593863, url, valid)

proc call*(call_593934: Call_PlusDomainsActivitiesGet_593692; activityId: string;
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
  var path_593935 = newJObject()
  var query_593937 = newJObject()
  add(query_593937, "fields", newJString(fields))
  add(query_593937, "quotaUser", newJString(quotaUser))
  add(query_593937, "alt", newJString(alt))
  add(query_593937, "oauth_token", newJString(oauthToken))
  add(path_593935, "activityId", newJString(activityId))
  add(query_593937, "userIp", newJString(userIp))
  add(query_593937, "key", newJString(key))
  add(query_593937, "prettyPrint", newJBool(prettyPrint))
  result = call_593934.call(path_593935, query_593937, nil, nil, nil)

var plusDomainsActivitiesGet* = Call_PlusDomainsActivitiesGet_593692(
    name: "plusDomainsActivitiesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/activities/{activityId}",
    validator: validate_PlusDomainsActivitiesGet_593693, base: "/plusDomains/v1",
    url: url_PlusDomainsActivitiesGet_593694, schemes: {Scheme.Https})
type
  Call_PlusDomainsCommentsList_593976 = ref object of OpenApiRestCall_593424
proc url_PlusDomainsCommentsList_593978(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
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

proc validate_PlusDomainsCommentsList_593977(path: JsonNode; query: JsonNode;
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
  var valid_593979 = path.getOrDefault("activityId")
  valid_593979 = validateParameter(valid_593979, JString, required = true,
                                 default = nil)
  if valid_593979 != nil:
    section.add "activityId", valid_593979
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
  var valid_593980 = query.getOrDefault("fields")
  valid_593980 = validateParameter(valid_593980, JString, required = false,
                                 default = nil)
  if valid_593980 != nil:
    section.add "fields", valid_593980
  var valid_593981 = query.getOrDefault("pageToken")
  valid_593981 = validateParameter(valid_593981, JString, required = false,
                                 default = nil)
  if valid_593981 != nil:
    section.add "pageToken", valid_593981
  var valid_593982 = query.getOrDefault("quotaUser")
  valid_593982 = validateParameter(valid_593982, JString, required = false,
                                 default = nil)
  if valid_593982 != nil:
    section.add "quotaUser", valid_593982
  var valid_593983 = query.getOrDefault("alt")
  valid_593983 = validateParameter(valid_593983, JString, required = false,
                                 default = newJString("json"))
  if valid_593983 != nil:
    section.add "alt", valid_593983
  var valid_593984 = query.getOrDefault("oauth_token")
  valid_593984 = validateParameter(valid_593984, JString, required = false,
                                 default = nil)
  if valid_593984 != nil:
    section.add "oauth_token", valid_593984
  var valid_593985 = query.getOrDefault("userIp")
  valid_593985 = validateParameter(valid_593985, JString, required = false,
                                 default = nil)
  if valid_593985 != nil:
    section.add "userIp", valid_593985
  var valid_593987 = query.getOrDefault("maxResults")
  valid_593987 = validateParameter(valid_593987, JInt, required = false,
                                 default = newJInt(20))
  if valid_593987 != nil:
    section.add "maxResults", valid_593987
  var valid_593988 = query.getOrDefault("key")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "key", valid_593988
  var valid_593989 = query.getOrDefault("sortOrder")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = newJString("ascending"))
  if valid_593989 != nil:
    section.add "sortOrder", valid_593989
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

proc call*(call_593991: Call_PlusDomainsCommentsList_593976; path: JsonNode;
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

proc call*(call_593992: Call_PlusDomainsCommentsList_593976; activityId: string;
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
  var path_593993 = newJObject()
  var query_593994 = newJObject()
  add(query_593994, "fields", newJString(fields))
  add(query_593994, "pageToken", newJString(pageToken))
  add(query_593994, "quotaUser", newJString(quotaUser))
  add(query_593994, "alt", newJString(alt))
  add(query_593994, "oauth_token", newJString(oauthToken))
  add(path_593993, "activityId", newJString(activityId))
  add(query_593994, "userIp", newJString(userIp))
  add(query_593994, "maxResults", newJInt(maxResults))
  add(query_593994, "key", newJString(key))
  add(query_593994, "sortOrder", newJString(sortOrder))
  add(query_593994, "prettyPrint", newJBool(prettyPrint))
  result = call_593992.call(path_593993, query_593994, nil, nil, nil)

var plusDomainsCommentsList* = Call_PlusDomainsCommentsList_593976(
    name: "plusDomainsCommentsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/activities/{activityId}/comments",
    validator: validate_PlusDomainsCommentsList_593977, base: "/plusDomains/v1",
    url: url_PlusDomainsCommentsList_593978, schemes: {Scheme.Https})
type
  Call_PlusDomainsPeopleListByActivity_593995 = ref object of OpenApiRestCall_593424
proc url_PlusDomainsPeopleListByActivity_593997(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_PlusDomainsPeopleListByActivity_593996(path: JsonNode;
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
  var valid_593998 = path.getOrDefault("activityId")
  valid_593998 = validateParameter(valid_593998, JString, required = true,
                                 default = nil)
  if valid_593998 != nil:
    section.add "activityId", valid_593998
  var valid_593999 = path.getOrDefault("collection")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = newJString("plusoners"))
  if valid_593999 != nil:
    section.add "collection", valid_593999
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
  var valid_594000 = query.getOrDefault("fields")
  valid_594000 = validateParameter(valid_594000, JString, required = false,
                                 default = nil)
  if valid_594000 != nil:
    section.add "fields", valid_594000
  var valid_594001 = query.getOrDefault("pageToken")
  valid_594001 = validateParameter(valid_594001, JString, required = false,
                                 default = nil)
  if valid_594001 != nil:
    section.add "pageToken", valid_594001
  var valid_594002 = query.getOrDefault("quotaUser")
  valid_594002 = validateParameter(valid_594002, JString, required = false,
                                 default = nil)
  if valid_594002 != nil:
    section.add "quotaUser", valid_594002
  var valid_594003 = query.getOrDefault("alt")
  valid_594003 = validateParameter(valid_594003, JString, required = false,
                                 default = newJString("json"))
  if valid_594003 != nil:
    section.add "alt", valid_594003
  var valid_594004 = query.getOrDefault("oauth_token")
  valid_594004 = validateParameter(valid_594004, JString, required = false,
                                 default = nil)
  if valid_594004 != nil:
    section.add "oauth_token", valid_594004
  var valid_594005 = query.getOrDefault("userIp")
  valid_594005 = validateParameter(valid_594005, JString, required = false,
                                 default = nil)
  if valid_594005 != nil:
    section.add "userIp", valid_594005
  var valid_594006 = query.getOrDefault("maxResults")
  valid_594006 = validateParameter(valid_594006, JInt, required = false,
                                 default = newJInt(20))
  if valid_594006 != nil:
    section.add "maxResults", valid_594006
  var valid_594007 = query.getOrDefault("key")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = nil)
  if valid_594007 != nil:
    section.add "key", valid_594007
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

proc call*(call_594009: Call_PlusDomainsPeopleListByActivity_593995;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
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

proc call*(call_594010: Call_PlusDomainsPeopleListByActivity_593995;
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
  var path_594011 = newJObject()
  var query_594012 = newJObject()
  add(query_594012, "fields", newJString(fields))
  add(query_594012, "pageToken", newJString(pageToken))
  add(query_594012, "quotaUser", newJString(quotaUser))
  add(query_594012, "alt", newJString(alt))
  add(query_594012, "oauth_token", newJString(oauthToken))
  add(path_594011, "activityId", newJString(activityId))
  add(path_594011, "collection", newJString(collection))
  add(query_594012, "userIp", newJString(userIp))
  add(query_594012, "maxResults", newJInt(maxResults))
  add(query_594012, "key", newJString(key))
  add(query_594012, "prettyPrint", newJBool(prettyPrint))
  result = call_594010.call(path_594011, query_594012, nil, nil, nil)

var plusDomainsPeopleListByActivity* = Call_PlusDomainsPeopleListByActivity_593995(
    name: "plusDomainsPeopleListByActivity", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/activities/{activityId}/people/{collection}",
    validator: validate_PlusDomainsPeopleListByActivity_593996,
    base: "/plusDomains/v1", url: url_PlusDomainsPeopleListByActivity_593997,
    schemes: {Scheme.Https})
type
  Call_PlusDomainsCommentsGet_594013 = ref object of OpenApiRestCall_593424
proc url_PlusDomainsCommentsGet_594015(protocol: Scheme; host: string; base: string;
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

proc validate_PlusDomainsCommentsGet_594014(path: JsonNode; query: JsonNode;
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
  var valid_594016 = path.getOrDefault("commentId")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = nil)
  if valid_594016 != nil:
    section.add "commentId", valid_594016
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
  var valid_594017 = query.getOrDefault("fields")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = nil)
  if valid_594017 != nil:
    section.add "fields", valid_594017
  var valid_594018 = query.getOrDefault("quotaUser")
  valid_594018 = validateParameter(valid_594018, JString, required = false,
                                 default = nil)
  if valid_594018 != nil:
    section.add "quotaUser", valid_594018
  var valid_594019 = query.getOrDefault("alt")
  valid_594019 = validateParameter(valid_594019, JString, required = false,
                                 default = newJString("json"))
  if valid_594019 != nil:
    section.add "alt", valid_594019
  var valid_594020 = query.getOrDefault("oauth_token")
  valid_594020 = validateParameter(valid_594020, JString, required = false,
                                 default = nil)
  if valid_594020 != nil:
    section.add "oauth_token", valid_594020
  var valid_594021 = query.getOrDefault("userIp")
  valid_594021 = validateParameter(valid_594021, JString, required = false,
                                 default = nil)
  if valid_594021 != nil:
    section.add "userIp", valid_594021
  var valid_594022 = query.getOrDefault("key")
  valid_594022 = validateParameter(valid_594022, JString, required = false,
                                 default = nil)
  if valid_594022 != nil:
    section.add "key", valid_594022
  var valid_594023 = query.getOrDefault("prettyPrint")
  valid_594023 = validateParameter(valid_594023, JBool, required = false,
                                 default = newJBool(true))
  if valid_594023 != nil:
    section.add "prettyPrint", valid_594023
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594024: Call_PlusDomainsCommentsGet_594013; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_594024.validator(path, query, header, formData, body)
  let scheme = call_594024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594024.url(scheme.get, call_594024.host, call_594024.base,
                         call_594024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594024, url, valid)

proc call*(call_594025: Call_PlusDomainsCommentsGet_594013; commentId: string;
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
  var path_594026 = newJObject()
  var query_594027 = newJObject()
  add(query_594027, "fields", newJString(fields))
  add(query_594027, "quotaUser", newJString(quotaUser))
  add(query_594027, "alt", newJString(alt))
  add(query_594027, "oauth_token", newJString(oauthToken))
  add(query_594027, "userIp", newJString(userIp))
  add(query_594027, "key", newJString(key))
  add(path_594026, "commentId", newJString(commentId))
  add(query_594027, "prettyPrint", newJBool(prettyPrint))
  result = call_594025.call(path_594026, query_594027, nil, nil, nil)

var plusDomainsCommentsGet* = Call_PlusDomainsCommentsGet_594013(
    name: "plusDomainsCommentsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/comments/{commentId}",
    validator: validate_PlusDomainsCommentsGet_594014, base: "/plusDomains/v1",
    url: url_PlusDomainsCommentsGet_594015, schemes: {Scheme.Https})
type
  Call_PlusDomainsPeopleGet_594028 = ref object of OpenApiRestCall_593424
proc url_PlusDomainsPeopleGet_594030(protocol: Scheme; host: string; base: string;
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

proc validate_PlusDomainsPeopleGet_594029(path: JsonNode; query: JsonNode;
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
  var valid_594031 = path.getOrDefault("userId")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "userId", valid_594031
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
  var valid_594032 = query.getOrDefault("fields")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = nil)
  if valid_594032 != nil:
    section.add "fields", valid_594032
  var valid_594033 = query.getOrDefault("quotaUser")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = nil)
  if valid_594033 != nil:
    section.add "quotaUser", valid_594033
  var valid_594034 = query.getOrDefault("alt")
  valid_594034 = validateParameter(valid_594034, JString, required = false,
                                 default = newJString("json"))
  if valid_594034 != nil:
    section.add "alt", valid_594034
  var valid_594035 = query.getOrDefault("oauth_token")
  valid_594035 = validateParameter(valid_594035, JString, required = false,
                                 default = nil)
  if valid_594035 != nil:
    section.add "oauth_token", valid_594035
  var valid_594036 = query.getOrDefault("userIp")
  valid_594036 = validateParameter(valid_594036, JString, required = false,
                                 default = nil)
  if valid_594036 != nil:
    section.add "userIp", valid_594036
  var valid_594037 = query.getOrDefault("key")
  valid_594037 = validateParameter(valid_594037, JString, required = false,
                                 default = nil)
  if valid_594037 != nil:
    section.add "key", valid_594037
  var valid_594038 = query.getOrDefault("prettyPrint")
  valid_594038 = validateParameter(valid_594038, JBool, required = false,
                                 default = newJBool(true))
  if valid_594038 != nil:
    section.add "prettyPrint", valid_594038
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594039: Call_PlusDomainsPeopleGet_594028; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a person's profile.
  ## 
  let valid = call_594039.validator(path, query, header, formData, body)
  let scheme = call_594039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594039.url(scheme.get, call_594039.host, call_594039.base,
                         call_594039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594039, url, valid)

proc call*(call_594040: Call_PlusDomainsPeopleGet_594028; userId: string;
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
  var path_594041 = newJObject()
  var query_594042 = newJObject()
  add(query_594042, "fields", newJString(fields))
  add(query_594042, "quotaUser", newJString(quotaUser))
  add(query_594042, "alt", newJString(alt))
  add(query_594042, "oauth_token", newJString(oauthToken))
  add(query_594042, "userIp", newJString(userIp))
  add(query_594042, "key", newJString(key))
  add(query_594042, "prettyPrint", newJBool(prettyPrint))
  add(path_594041, "userId", newJString(userId))
  result = call_594040.call(path_594041, query_594042, nil, nil, nil)

var plusDomainsPeopleGet* = Call_PlusDomainsPeopleGet_594028(
    name: "plusDomainsPeopleGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/people/{userId}",
    validator: validate_PlusDomainsPeopleGet_594029, base: "/plusDomains/v1",
    url: url_PlusDomainsPeopleGet_594030, schemes: {Scheme.Https})
type
  Call_PlusDomainsActivitiesList_594043 = ref object of OpenApiRestCall_593424
proc url_PlusDomainsActivitiesList_594045(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_PlusDomainsActivitiesList_594044(path: JsonNode; query: JsonNode;
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
  var valid_594046 = path.getOrDefault("collection")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = newJString("user"))
  if valid_594046 != nil:
    section.add "collection", valid_594046
  var valid_594047 = path.getOrDefault("userId")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "userId", valid_594047
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
  var valid_594048 = query.getOrDefault("fields")
  valid_594048 = validateParameter(valid_594048, JString, required = false,
                                 default = nil)
  if valid_594048 != nil:
    section.add "fields", valid_594048
  var valid_594049 = query.getOrDefault("pageToken")
  valid_594049 = validateParameter(valid_594049, JString, required = false,
                                 default = nil)
  if valid_594049 != nil:
    section.add "pageToken", valid_594049
  var valid_594050 = query.getOrDefault("quotaUser")
  valid_594050 = validateParameter(valid_594050, JString, required = false,
                                 default = nil)
  if valid_594050 != nil:
    section.add "quotaUser", valid_594050
  var valid_594051 = query.getOrDefault("alt")
  valid_594051 = validateParameter(valid_594051, JString, required = false,
                                 default = newJString("json"))
  if valid_594051 != nil:
    section.add "alt", valid_594051
  var valid_594052 = query.getOrDefault("oauth_token")
  valid_594052 = validateParameter(valid_594052, JString, required = false,
                                 default = nil)
  if valid_594052 != nil:
    section.add "oauth_token", valid_594052
  var valid_594053 = query.getOrDefault("userIp")
  valid_594053 = validateParameter(valid_594053, JString, required = false,
                                 default = nil)
  if valid_594053 != nil:
    section.add "userIp", valid_594053
  var valid_594054 = query.getOrDefault("maxResults")
  valid_594054 = validateParameter(valid_594054, JInt, required = false,
                                 default = newJInt(20))
  if valid_594054 != nil:
    section.add "maxResults", valid_594054
  var valid_594055 = query.getOrDefault("key")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = nil)
  if valid_594055 != nil:
    section.add "key", valid_594055
  var valid_594056 = query.getOrDefault("prettyPrint")
  valid_594056 = validateParameter(valid_594056, JBool, required = false,
                                 default = newJBool(true))
  if valid_594056 != nil:
    section.add "prettyPrint", valid_594056
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594057: Call_PlusDomainsActivitiesList_594043; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_594057.validator(path, query, header, formData, body)
  let scheme = call_594057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594057.url(scheme.get, call_594057.host, call_594057.base,
                         call_594057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594057, url, valid)

proc call*(call_594058: Call_PlusDomainsActivitiesList_594043; userId: string;
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
  var path_594059 = newJObject()
  var query_594060 = newJObject()
  add(query_594060, "fields", newJString(fields))
  add(query_594060, "pageToken", newJString(pageToken))
  add(query_594060, "quotaUser", newJString(quotaUser))
  add(query_594060, "alt", newJString(alt))
  add(query_594060, "oauth_token", newJString(oauthToken))
  add(path_594059, "collection", newJString(collection))
  add(query_594060, "userIp", newJString(userIp))
  add(query_594060, "maxResults", newJInt(maxResults))
  add(query_594060, "key", newJString(key))
  add(query_594060, "prettyPrint", newJBool(prettyPrint))
  add(path_594059, "userId", newJString(userId))
  result = call_594058.call(path_594059, query_594060, nil, nil, nil)

var plusDomainsActivitiesList* = Call_PlusDomainsActivitiesList_594043(
    name: "plusDomainsActivitiesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/people/{userId}/activities/{collection}",
    validator: validate_PlusDomainsActivitiesList_594044, base: "/plusDomains/v1",
    url: url_PlusDomainsActivitiesList_594045, schemes: {Scheme.Https})
type
  Call_PlusDomainsAudiencesList_594061 = ref object of OpenApiRestCall_593424
proc url_PlusDomainsAudiencesList_594063(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_PlusDomainsAudiencesList_594062(path: JsonNode; query: JsonNode;
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
  var valid_594064 = path.getOrDefault("userId")
  valid_594064 = validateParameter(valid_594064, JString, required = true,
                                 default = nil)
  if valid_594064 != nil:
    section.add "userId", valid_594064
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
  var valid_594065 = query.getOrDefault("fields")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = nil)
  if valid_594065 != nil:
    section.add "fields", valid_594065
  var valid_594066 = query.getOrDefault("pageToken")
  valid_594066 = validateParameter(valid_594066, JString, required = false,
                                 default = nil)
  if valid_594066 != nil:
    section.add "pageToken", valid_594066
  var valid_594067 = query.getOrDefault("quotaUser")
  valid_594067 = validateParameter(valid_594067, JString, required = false,
                                 default = nil)
  if valid_594067 != nil:
    section.add "quotaUser", valid_594067
  var valid_594068 = query.getOrDefault("alt")
  valid_594068 = validateParameter(valid_594068, JString, required = false,
                                 default = newJString("json"))
  if valid_594068 != nil:
    section.add "alt", valid_594068
  var valid_594069 = query.getOrDefault("oauth_token")
  valid_594069 = validateParameter(valid_594069, JString, required = false,
                                 default = nil)
  if valid_594069 != nil:
    section.add "oauth_token", valid_594069
  var valid_594070 = query.getOrDefault("userIp")
  valid_594070 = validateParameter(valid_594070, JString, required = false,
                                 default = nil)
  if valid_594070 != nil:
    section.add "userIp", valid_594070
  var valid_594071 = query.getOrDefault("maxResults")
  valid_594071 = validateParameter(valid_594071, JInt, required = false,
                                 default = newJInt(20))
  if valid_594071 != nil:
    section.add "maxResults", valid_594071
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

proc call*(call_594074: Call_PlusDomainsAudiencesList_594061; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_594074.validator(path, query, header, formData, body)
  let scheme = call_594074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594074.url(scheme.get, call_594074.host, call_594074.base,
                         call_594074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594074, url, valid)

proc call*(call_594075: Call_PlusDomainsAudiencesList_594061; userId: string;
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
  var path_594076 = newJObject()
  var query_594077 = newJObject()
  add(query_594077, "fields", newJString(fields))
  add(query_594077, "pageToken", newJString(pageToken))
  add(query_594077, "quotaUser", newJString(quotaUser))
  add(query_594077, "alt", newJString(alt))
  add(query_594077, "oauth_token", newJString(oauthToken))
  add(query_594077, "userIp", newJString(userIp))
  add(query_594077, "maxResults", newJInt(maxResults))
  add(query_594077, "key", newJString(key))
  add(query_594077, "prettyPrint", newJBool(prettyPrint))
  add(path_594076, "userId", newJString(userId))
  result = call_594075.call(path_594076, query_594077, nil, nil, nil)

var plusDomainsAudiencesList* = Call_PlusDomainsAudiencesList_594061(
    name: "plusDomainsAudiencesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/people/{userId}/audiences",
    validator: validate_PlusDomainsAudiencesList_594062, base: "/plusDomains/v1",
    url: url_PlusDomainsAudiencesList_594063, schemes: {Scheme.Https})
type
  Call_PlusDomainsCirclesList_594078 = ref object of OpenApiRestCall_593424
proc url_PlusDomainsCirclesList_594080(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_PlusDomainsCirclesList_594079(path: JsonNode; query: JsonNode;
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
  var valid_594081 = path.getOrDefault("userId")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = nil)
  if valid_594081 != nil:
    section.add "userId", valid_594081
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
  var valid_594082 = query.getOrDefault("fields")
  valid_594082 = validateParameter(valid_594082, JString, required = false,
                                 default = nil)
  if valid_594082 != nil:
    section.add "fields", valid_594082
  var valid_594083 = query.getOrDefault("pageToken")
  valid_594083 = validateParameter(valid_594083, JString, required = false,
                                 default = nil)
  if valid_594083 != nil:
    section.add "pageToken", valid_594083
  var valid_594084 = query.getOrDefault("quotaUser")
  valid_594084 = validateParameter(valid_594084, JString, required = false,
                                 default = nil)
  if valid_594084 != nil:
    section.add "quotaUser", valid_594084
  var valid_594085 = query.getOrDefault("alt")
  valid_594085 = validateParameter(valid_594085, JString, required = false,
                                 default = newJString("json"))
  if valid_594085 != nil:
    section.add "alt", valid_594085
  var valid_594086 = query.getOrDefault("oauth_token")
  valid_594086 = validateParameter(valid_594086, JString, required = false,
                                 default = nil)
  if valid_594086 != nil:
    section.add "oauth_token", valid_594086
  var valid_594087 = query.getOrDefault("userIp")
  valid_594087 = validateParameter(valid_594087, JString, required = false,
                                 default = nil)
  if valid_594087 != nil:
    section.add "userIp", valid_594087
  var valid_594088 = query.getOrDefault("maxResults")
  valid_594088 = validateParameter(valid_594088, JInt, required = false,
                                 default = newJInt(20))
  if valid_594088 != nil:
    section.add "maxResults", valid_594088
  var valid_594089 = query.getOrDefault("key")
  valid_594089 = validateParameter(valid_594089, JString, required = false,
                                 default = nil)
  if valid_594089 != nil:
    section.add "key", valid_594089
  var valid_594090 = query.getOrDefault("prettyPrint")
  valid_594090 = validateParameter(valid_594090, JBool, required = false,
                                 default = newJBool(true))
  if valid_594090 != nil:
    section.add "prettyPrint", valid_594090
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594091: Call_PlusDomainsCirclesList_594078; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_594091.validator(path, query, header, formData, body)
  let scheme = call_594091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594091.url(scheme.get, call_594091.host, call_594091.base,
                         call_594091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594091, url, valid)

proc call*(call_594092: Call_PlusDomainsCirclesList_594078; userId: string;
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
  var path_594093 = newJObject()
  var query_594094 = newJObject()
  add(query_594094, "fields", newJString(fields))
  add(query_594094, "pageToken", newJString(pageToken))
  add(query_594094, "quotaUser", newJString(quotaUser))
  add(query_594094, "alt", newJString(alt))
  add(query_594094, "oauth_token", newJString(oauthToken))
  add(query_594094, "userIp", newJString(userIp))
  add(query_594094, "maxResults", newJInt(maxResults))
  add(query_594094, "key", newJString(key))
  add(query_594094, "prettyPrint", newJBool(prettyPrint))
  add(path_594093, "userId", newJString(userId))
  result = call_594092.call(path_594093, query_594094, nil, nil, nil)

var plusDomainsCirclesList* = Call_PlusDomainsCirclesList_594078(
    name: "plusDomainsCirclesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/people/{userId}/circles",
    validator: validate_PlusDomainsCirclesList_594079, base: "/plusDomains/v1",
    url: url_PlusDomainsCirclesList_594080, schemes: {Scheme.Https})
type
  Call_PlusDomainsMediaInsert_594095 = ref object of OpenApiRestCall_593424
proc url_PlusDomainsMediaInsert_594097(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/media/"),
               (kind: VariableSegment, value: "collection")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PlusDomainsMediaInsert_594096(path: JsonNode; query: JsonNode;
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
  var valid_594098 = path.getOrDefault("collection")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = newJString("cloud"))
  if valid_594098 != nil:
    section.add "collection", valid_594098
  var valid_594099 = path.getOrDefault("userId")
  valid_594099 = validateParameter(valid_594099, JString, required = true,
                                 default = nil)
  if valid_594099 != nil:
    section.add "userId", valid_594099
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
  var valid_594100 = query.getOrDefault("fields")
  valid_594100 = validateParameter(valid_594100, JString, required = false,
                                 default = nil)
  if valid_594100 != nil:
    section.add "fields", valid_594100
  var valid_594101 = query.getOrDefault("quotaUser")
  valid_594101 = validateParameter(valid_594101, JString, required = false,
                                 default = nil)
  if valid_594101 != nil:
    section.add "quotaUser", valid_594101
  var valid_594102 = query.getOrDefault("alt")
  valid_594102 = validateParameter(valid_594102, JString, required = false,
                                 default = newJString("json"))
  if valid_594102 != nil:
    section.add "alt", valid_594102
  var valid_594103 = query.getOrDefault("oauth_token")
  valid_594103 = validateParameter(valid_594103, JString, required = false,
                                 default = nil)
  if valid_594103 != nil:
    section.add "oauth_token", valid_594103
  var valid_594104 = query.getOrDefault("userIp")
  valid_594104 = validateParameter(valid_594104, JString, required = false,
                                 default = nil)
  if valid_594104 != nil:
    section.add "userIp", valid_594104
  var valid_594105 = query.getOrDefault("key")
  valid_594105 = validateParameter(valid_594105, JString, required = false,
                                 default = nil)
  if valid_594105 != nil:
    section.add "key", valid_594105
  var valid_594106 = query.getOrDefault("prettyPrint")
  valid_594106 = validateParameter(valid_594106, JBool, required = false,
                                 default = newJBool(true))
  if valid_594106 != nil:
    section.add "prettyPrint", valid_594106
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

proc call*(call_594108: Call_PlusDomainsMediaInsert_594095; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_594108.validator(path, query, header, formData, body)
  let scheme = call_594108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594108.url(scheme.get, call_594108.host, call_594108.base,
                         call_594108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594108, url, valid)

proc call*(call_594109: Call_PlusDomainsMediaInsert_594095; userId: string;
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
  var path_594110 = newJObject()
  var query_594111 = newJObject()
  var body_594112 = newJObject()
  add(query_594111, "fields", newJString(fields))
  add(query_594111, "quotaUser", newJString(quotaUser))
  add(query_594111, "alt", newJString(alt))
  add(query_594111, "oauth_token", newJString(oauthToken))
  add(path_594110, "collection", newJString(collection))
  add(query_594111, "userIp", newJString(userIp))
  add(query_594111, "key", newJString(key))
  if body != nil:
    body_594112 = body
  add(query_594111, "prettyPrint", newJBool(prettyPrint))
  add(path_594110, "userId", newJString(userId))
  result = call_594109.call(path_594110, query_594111, nil, nil, body_594112)

var plusDomainsMediaInsert* = Call_PlusDomainsMediaInsert_594095(
    name: "plusDomainsMediaInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/people/{userId}/media/{collection}",
    validator: validate_PlusDomainsMediaInsert_594096, base: "/plusDomains/v1",
    url: url_PlusDomainsMediaInsert_594097, schemes: {Scheme.Https})
type
  Call_PlusDomainsPeopleList_594113 = ref object of OpenApiRestCall_593424
proc url_PlusDomainsPeopleList_594115(protocol: Scheme; host: string; base: string;
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

proc validate_PlusDomainsPeopleList_594114(path: JsonNode; query: JsonNode;
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
  var valid_594116 = path.getOrDefault("collection")
  valid_594116 = validateParameter(valid_594116, JString, required = true,
                                 default = newJString("circled"))
  if valid_594116 != nil:
    section.add "collection", valid_594116
  var valid_594117 = path.getOrDefault("userId")
  valid_594117 = validateParameter(valid_594117, JString, required = true,
                                 default = nil)
  if valid_594117 != nil:
    section.add "userId", valid_594117
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
  var valid_594118 = query.getOrDefault("fields")
  valid_594118 = validateParameter(valid_594118, JString, required = false,
                                 default = nil)
  if valid_594118 != nil:
    section.add "fields", valid_594118
  var valid_594119 = query.getOrDefault("pageToken")
  valid_594119 = validateParameter(valid_594119, JString, required = false,
                                 default = nil)
  if valid_594119 != nil:
    section.add "pageToken", valid_594119
  var valid_594120 = query.getOrDefault("quotaUser")
  valid_594120 = validateParameter(valid_594120, JString, required = false,
                                 default = nil)
  if valid_594120 != nil:
    section.add "quotaUser", valid_594120
  var valid_594121 = query.getOrDefault("alt")
  valid_594121 = validateParameter(valid_594121, JString, required = false,
                                 default = newJString("json"))
  if valid_594121 != nil:
    section.add "alt", valid_594121
  var valid_594122 = query.getOrDefault("oauth_token")
  valid_594122 = validateParameter(valid_594122, JString, required = false,
                                 default = nil)
  if valid_594122 != nil:
    section.add "oauth_token", valid_594122
  var valid_594123 = query.getOrDefault("userIp")
  valid_594123 = validateParameter(valid_594123, JString, required = false,
                                 default = nil)
  if valid_594123 != nil:
    section.add "userIp", valid_594123
  var valid_594124 = query.getOrDefault("maxResults")
  valid_594124 = validateParameter(valid_594124, JInt, required = false,
                                 default = newJInt(100))
  if valid_594124 != nil:
    section.add "maxResults", valid_594124
  var valid_594125 = query.getOrDefault("orderBy")
  valid_594125 = validateParameter(valid_594125, JString, required = false,
                                 default = newJString("alphabetical"))
  if valid_594125 != nil:
    section.add "orderBy", valid_594125
  var valid_594126 = query.getOrDefault("key")
  valid_594126 = validateParameter(valid_594126, JString, required = false,
                                 default = nil)
  if valid_594126 != nil:
    section.add "key", valid_594126
  var valid_594127 = query.getOrDefault("prettyPrint")
  valid_594127 = validateParameter(valid_594127, JBool, required = false,
                                 default = newJBool(true))
  if valid_594127 != nil:
    section.add "prettyPrint", valid_594127
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594128: Call_PlusDomainsPeopleList_594113; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all of the people in the specified collection.
  ## 
  let valid = call_594128.validator(path, query, header, formData, body)
  let scheme = call_594128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594128.url(scheme.get, call_594128.host, call_594128.base,
                         call_594128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594128, url, valid)

proc call*(call_594129: Call_PlusDomainsPeopleList_594113; userId: string;
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
  var path_594130 = newJObject()
  var query_594131 = newJObject()
  add(query_594131, "fields", newJString(fields))
  add(query_594131, "pageToken", newJString(pageToken))
  add(query_594131, "quotaUser", newJString(quotaUser))
  add(query_594131, "alt", newJString(alt))
  add(query_594131, "oauth_token", newJString(oauthToken))
  add(path_594130, "collection", newJString(collection))
  add(query_594131, "userIp", newJString(userIp))
  add(query_594131, "maxResults", newJInt(maxResults))
  add(query_594131, "orderBy", newJString(orderBy))
  add(query_594131, "key", newJString(key))
  add(query_594131, "prettyPrint", newJBool(prettyPrint))
  add(path_594130, "userId", newJString(userId))
  result = call_594129.call(path_594130, query_594131, nil, nil, nil)

var plusDomainsPeopleList* = Call_PlusDomainsPeopleList_594113(
    name: "plusDomainsPeopleList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/people/{userId}/people/{collection}",
    validator: validate_PlusDomainsPeopleList_594114, base: "/plusDomains/v1",
    url: url_PlusDomainsPeopleList_594115, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
