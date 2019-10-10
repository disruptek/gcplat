
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

  OpenApiRestCall_588457 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588457](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588457): Option[Scheme] {.used.} =
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
  gcpServiceName = "plusDomains"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PlusDomainsActivitiesGet_588725 = ref object of OpenApiRestCall_588457
proc url_PlusDomainsActivitiesGet_588727(protocol: Scheme; host: string;
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

proc validate_PlusDomainsActivitiesGet_588726(path: JsonNode; query: JsonNode;
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
  var valid_588853 = path.getOrDefault("activityId")
  valid_588853 = validateParameter(valid_588853, JString, required = true,
                                 default = nil)
  if valid_588853 != nil:
    section.add "activityId", valid_588853
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
  var valid_588854 = query.getOrDefault("fields")
  valid_588854 = validateParameter(valid_588854, JString, required = false,
                                 default = nil)
  if valid_588854 != nil:
    section.add "fields", valid_588854
  var valid_588855 = query.getOrDefault("quotaUser")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = nil)
  if valid_588855 != nil:
    section.add "quotaUser", valid_588855
  var valid_588869 = query.getOrDefault("alt")
  valid_588869 = validateParameter(valid_588869, JString, required = false,
                                 default = newJString("json"))
  if valid_588869 != nil:
    section.add "alt", valid_588869
  var valid_588870 = query.getOrDefault("oauth_token")
  valid_588870 = validateParameter(valid_588870, JString, required = false,
                                 default = nil)
  if valid_588870 != nil:
    section.add "oauth_token", valid_588870
  var valid_588871 = query.getOrDefault("userIp")
  valid_588871 = validateParameter(valid_588871, JString, required = false,
                                 default = nil)
  if valid_588871 != nil:
    section.add "userIp", valid_588871
  var valid_588872 = query.getOrDefault("key")
  valid_588872 = validateParameter(valid_588872, JString, required = false,
                                 default = nil)
  if valid_588872 != nil:
    section.add "key", valid_588872
  var valid_588873 = query.getOrDefault("prettyPrint")
  valid_588873 = validateParameter(valid_588873, JBool, required = false,
                                 default = newJBool(true))
  if valid_588873 != nil:
    section.add "prettyPrint", valid_588873
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588896: Call_PlusDomainsActivitiesGet_588725; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_588896.validator(path, query, header, formData, body)
  let scheme = call_588896.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588896.url(scheme.get, call_588896.host, call_588896.base,
                         call_588896.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588896, url, valid)

proc call*(call_588967: Call_PlusDomainsActivitiesGet_588725; activityId: string;
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
  var path_588968 = newJObject()
  var query_588970 = newJObject()
  add(query_588970, "fields", newJString(fields))
  add(query_588970, "quotaUser", newJString(quotaUser))
  add(query_588970, "alt", newJString(alt))
  add(query_588970, "oauth_token", newJString(oauthToken))
  add(path_588968, "activityId", newJString(activityId))
  add(query_588970, "userIp", newJString(userIp))
  add(query_588970, "key", newJString(key))
  add(query_588970, "prettyPrint", newJBool(prettyPrint))
  result = call_588967.call(path_588968, query_588970, nil, nil, nil)

var plusDomainsActivitiesGet* = Call_PlusDomainsActivitiesGet_588725(
    name: "plusDomainsActivitiesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/activities/{activityId}",
    validator: validate_PlusDomainsActivitiesGet_588726, base: "/plusDomains/v1",
    url: url_PlusDomainsActivitiesGet_588727, schemes: {Scheme.Https})
type
  Call_PlusDomainsCommentsList_589009 = ref object of OpenApiRestCall_588457
proc url_PlusDomainsCommentsList_589011(protocol: Scheme; host: string; base: string;
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

proc validate_PlusDomainsCommentsList_589010(path: JsonNode; query: JsonNode;
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
  var valid_589012 = path.getOrDefault("activityId")
  valid_589012 = validateParameter(valid_589012, JString, required = true,
                                 default = nil)
  if valid_589012 != nil:
    section.add "activityId", valid_589012
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
  var valid_589013 = query.getOrDefault("fields")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "fields", valid_589013
  var valid_589014 = query.getOrDefault("pageToken")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "pageToken", valid_589014
  var valid_589015 = query.getOrDefault("quotaUser")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "quotaUser", valid_589015
  var valid_589016 = query.getOrDefault("alt")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = newJString("json"))
  if valid_589016 != nil:
    section.add "alt", valid_589016
  var valid_589017 = query.getOrDefault("oauth_token")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "oauth_token", valid_589017
  var valid_589018 = query.getOrDefault("userIp")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "userIp", valid_589018
  var valid_589020 = query.getOrDefault("maxResults")
  valid_589020 = validateParameter(valid_589020, JInt, required = false,
                                 default = newJInt(20))
  if valid_589020 != nil:
    section.add "maxResults", valid_589020
  var valid_589021 = query.getOrDefault("key")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "key", valid_589021
  var valid_589022 = query.getOrDefault("sortOrder")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = newJString("ascending"))
  if valid_589022 != nil:
    section.add "sortOrder", valid_589022
  var valid_589023 = query.getOrDefault("prettyPrint")
  valid_589023 = validateParameter(valid_589023, JBool, required = false,
                                 default = newJBool(true))
  if valid_589023 != nil:
    section.add "prettyPrint", valid_589023
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589024: Call_PlusDomainsCommentsList_589009; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_589024.validator(path, query, header, formData, body)
  let scheme = call_589024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589024.url(scheme.get, call_589024.host, call_589024.base,
                         call_589024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589024, url, valid)

proc call*(call_589025: Call_PlusDomainsCommentsList_589009; activityId: string;
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
  var path_589026 = newJObject()
  var query_589027 = newJObject()
  add(query_589027, "fields", newJString(fields))
  add(query_589027, "pageToken", newJString(pageToken))
  add(query_589027, "quotaUser", newJString(quotaUser))
  add(query_589027, "alt", newJString(alt))
  add(query_589027, "oauth_token", newJString(oauthToken))
  add(path_589026, "activityId", newJString(activityId))
  add(query_589027, "userIp", newJString(userIp))
  add(query_589027, "maxResults", newJInt(maxResults))
  add(query_589027, "key", newJString(key))
  add(query_589027, "sortOrder", newJString(sortOrder))
  add(query_589027, "prettyPrint", newJBool(prettyPrint))
  result = call_589025.call(path_589026, query_589027, nil, nil, nil)

var plusDomainsCommentsList* = Call_PlusDomainsCommentsList_589009(
    name: "plusDomainsCommentsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/activities/{activityId}/comments",
    validator: validate_PlusDomainsCommentsList_589010, base: "/plusDomains/v1",
    url: url_PlusDomainsCommentsList_589011, schemes: {Scheme.Https})
type
  Call_PlusDomainsPeopleListByActivity_589028 = ref object of OpenApiRestCall_588457
proc url_PlusDomainsPeopleListByActivity_589030(protocol: Scheme; host: string;
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

proc validate_PlusDomainsPeopleListByActivity_589029(path: JsonNode;
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
  var valid_589031 = path.getOrDefault("activityId")
  valid_589031 = validateParameter(valid_589031, JString, required = true,
                                 default = nil)
  if valid_589031 != nil:
    section.add "activityId", valid_589031
  var valid_589032 = path.getOrDefault("collection")
  valid_589032 = validateParameter(valid_589032, JString, required = true,
                                 default = newJString("plusoners"))
  if valid_589032 != nil:
    section.add "collection", valid_589032
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
  var valid_589033 = query.getOrDefault("fields")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "fields", valid_589033
  var valid_589034 = query.getOrDefault("pageToken")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "pageToken", valid_589034
  var valid_589035 = query.getOrDefault("quotaUser")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "quotaUser", valid_589035
  var valid_589036 = query.getOrDefault("alt")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = newJString("json"))
  if valid_589036 != nil:
    section.add "alt", valid_589036
  var valid_589037 = query.getOrDefault("oauth_token")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "oauth_token", valid_589037
  var valid_589038 = query.getOrDefault("userIp")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "userIp", valid_589038
  var valid_589039 = query.getOrDefault("maxResults")
  valid_589039 = validateParameter(valid_589039, JInt, required = false,
                                 default = newJInt(20))
  if valid_589039 != nil:
    section.add "maxResults", valid_589039
  var valid_589040 = query.getOrDefault("key")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "key", valid_589040
  var valid_589041 = query.getOrDefault("prettyPrint")
  valid_589041 = validateParameter(valid_589041, JBool, required = false,
                                 default = newJBool(true))
  if valid_589041 != nil:
    section.add "prettyPrint", valid_589041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589042: Call_PlusDomainsPeopleListByActivity_589028;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_589042.validator(path, query, header, formData, body)
  let scheme = call_589042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589042.url(scheme.get, call_589042.host, call_589042.base,
                         call_589042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589042, url, valid)

proc call*(call_589043: Call_PlusDomainsPeopleListByActivity_589028;
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
  var path_589044 = newJObject()
  var query_589045 = newJObject()
  add(query_589045, "fields", newJString(fields))
  add(query_589045, "pageToken", newJString(pageToken))
  add(query_589045, "quotaUser", newJString(quotaUser))
  add(query_589045, "alt", newJString(alt))
  add(query_589045, "oauth_token", newJString(oauthToken))
  add(path_589044, "activityId", newJString(activityId))
  add(path_589044, "collection", newJString(collection))
  add(query_589045, "userIp", newJString(userIp))
  add(query_589045, "maxResults", newJInt(maxResults))
  add(query_589045, "key", newJString(key))
  add(query_589045, "prettyPrint", newJBool(prettyPrint))
  result = call_589043.call(path_589044, query_589045, nil, nil, nil)

var plusDomainsPeopleListByActivity* = Call_PlusDomainsPeopleListByActivity_589028(
    name: "plusDomainsPeopleListByActivity", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/activities/{activityId}/people/{collection}",
    validator: validate_PlusDomainsPeopleListByActivity_589029,
    base: "/plusDomains/v1", url: url_PlusDomainsPeopleListByActivity_589030,
    schemes: {Scheme.Https})
type
  Call_PlusDomainsCommentsGet_589046 = ref object of OpenApiRestCall_588457
proc url_PlusDomainsCommentsGet_589048(protocol: Scheme; host: string; base: string;
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

proc validate_PlusDomainsCommentsGet_589047(path: JsonNode; query: JsonNode;
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
  var valid_589049 = path.getOrDefault("commentId")
  valid_589049 = validateParameter(valid_589049, JString, required = true,
                                 default = nil)
  if valid_589049 != nil:
    section.add "commentId", valid_589049
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
  var valid_589050 = query.getOrDefault("fields")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "fields", valid_589050
  var valid_589051 = query.getOrDefault("quotaUser")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "quotaUser", valid_589051
  var valid_589052 = query.getOrDefault("alt")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = newJString("json"))
  if valid_589052 != nil:
    section.add "alt", valid_589052
  var valid_589053 = query.getOrDefault("oauth_token")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "oauth_token", valid_589053
  var valid_589054 = query.getOrDefault("userIp")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = nil)
  if valid_589054 != nil:
    section.add "userIp", valid_589054
  var valid_589055 = query.getOrDefault("key")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "key", valid_589055
  var valid_589056 = query.getOrDefault("prettyPrint")
  valid_589056 = validateParameter(valid_589056, JBool, required = false,
                                 default = newJBool(true))
  if valid_589056 != nil:
    section.add "prettyPrint", valid_589056
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589057: Call_PlusDomainsCommentsGet_589046; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_589057.validator(path, query, header, formData, body)
  let scheme = call_589057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589057.url(scheme.get, call_589057.host, call_589057.base,
                         call_589057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589057, url, valid)

proc call*(call_589058: Call_PlusDomainsCommentsGet_589046; commentId: string;
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
  var path_589059 = newJObject()
  var query_589060 = newJObject()
  add(query_589060, "fields", newJString(fields))
  add(query_589060, "quotaUser", newJString(quotaUser))
  add(query_589060, "alt", newJString(alt))
  add(query_589060, "oauth_token", newJString(oauthToken))
  add(query_589060, "userIp", newJString(userIp))
  add(query_589060, "key", newJString(key))
  add(path_589059, "commentId", newJString(commentId))
  add(query_589060, "prettyPrint", newJBool(prettyPrint))
  result = call_589058.call(path_589059, query_589060, nil, nil, nil)

var plusDomainsCommentsGet* = Call_PlusDomainsCommentsGet_589046(
    name: "plusDomainsCommentsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/comments/{commentId}",
    validator: validate_PlusDomainsCommentsGet_589047, base: "/plusDomains/v1",
    url: url_PlusDomainsCommentsGet_589048, schemes: {Scheme.Https})
type
  Call_PlusDomainsPeopleGet_589061 = ref object of OpenApiRestCall_588457
proc url_PlusDomainsPeopleGet_589063(protocol: Scheme; host: string; base: string;
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

proc validate_PlusDomainsPeopleGet_589062(path: JsonNode; query: JsonNode;
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
  var valid_589064 = path.getOrDefault("userId")
  valid_589064 = validateParameter(valid_589064, JString, required = true,
                                 default = nil)
  if valid_589064 != nil:
    section.add "userId", valid_589064
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
  var valid_589065 = query.getOrDefault("fields")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "fields", valid_589065
  var valid_589066 = query.getOrDefault("quotaUser")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "quotaUser", valid_589066
  var valid_589067 = query.getOrDefault("alt")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = newJString("json"))
  if valid_589067 != nil:
    section.add "alt", valid_589067
  var valid_589068 = query.getOrDefault("oauth_token")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "oauth_token", valid_589068
  var valid_589069 = query.getOrDefault("userIp")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "userIp", valid_589069
  var valid_589070 = query.getOrDefault("key")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "key", valid_589070
  var valid_589071 = query.getOrDefault("prettyPrint")
  valid_589071 = validateParameter(valid_589071, JBool, required = false,
                                 default = newJBool(true))
  if valid_589071 != nil:
    section.add "prettyPrint", valid_589071
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589072: Call_PlusDomainsPeopleGet_589061; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a person's profile.
  ## 
  let valid = call_589072.validator(path, query, header, formData, body)
  let scheme = call_589072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589072.url(scheme.get, call_589072.host, call_589072.base,
                         call_589072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589072, url, valid)

proc call*(call_589073: Call_PlusDomainsPeopleGet_589061; userId: string;
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
  var path_589074 = newJObject()
  var query_589075 = newJObject()
  add(query_589075, "fields", newJString(fields))
  add(query_589075, "quotaUser", newJString(quotaUser))
  add(query_589075, "alt", newJString(alt))
  add(query_589075, "oauth_token", newJString(oauthToken))
  add(query_589075, "userIp", newJString(userIp))
  add(query_589075, "key", newJString(key))
  add(query_589075, "prettyPrint", newJBool(prettyPrint))
  add(path_589074, "userId", newJString(userId))
  result = call_589073.call(path_589074, query_589075, nil, nil, nil)

var plusDomainsPeopleGet* = Call_PlusDomainsPeopleGet_589061(
    name: "plusDomainsPeopleGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/people/{userId}",
    validator: validate_PlusDomainsPeopleGet_589062, base: "/plusDomains/v1",
    url: url_PlusDomainsPeopleGet_589063, schemes: {Scheme.Https})
type
  Call_PlusDomainsActivitiesList_589076 = ref object of OpenApiRestCall_588457
proc url_PlusDomainsActivitiesList_589078(protocol: Scheme; host: string;
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

proc validate_PlusDomainsActivitiesList_589077(path: JsonNode; query: JsonNode;
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
  var valid_589079 = path.getOrDefault("collection")
  valid_589079 = validateParameter(valid_589079, JString, required = true,
                                 default = newJString("user"))
  if valid_589079 != nil:
    section.add "collection", valid_589079
  var valid_589080 = path.getOrDefault("userId")
  valid_589080 = validateParameter(valid_589080, JString, required = true,
                                 default = nil)
  if valid_589080 != nil:
    section.add "userId", valid_589080
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
  var valid_589081 = query.getOrDefault("fields")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = nil)
  if valid_589081 != nil:
    section.add "fields", valid_589081
  var valid_589082 = query.getOrDefault("pageToken")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "pageToken", valid_589082
  var valid_589083 = query.getOrDefault("quotaUser")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "quotaUser", valid_589083
  var valid_589084 = query.getOrDefault("alt")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = newJString("json"))
  if valid_589084 != nil:
    section.add "alt", valid_589084
  var valid_589085 = query.getOrDefault("oauth_token")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "oauth_token", valid_589085
  var valid_589086 = query.getOrDefault("userIp")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "userIp", valid_589086
  var valid_589087 = query.getOrDefault("maxResults")
  valid_589087 = validateParameter(valid_589087, JInt, required = false,
                                 default = newJInt(20))
  if valid_589087 != nil:
    section.add "maxResults", valid_589087
  var valid_589088 = query.getOrDefault("key")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "key", valid_589088
  var valid_589089 = query.getOrDefault("prettyPrint")
  valid_589089 = validateParameter(valid_589089, JBool, required = false,
                                 default = newJBool(true))
  if valid_589089 != nil:
    section.add "prettyPrint", valid_589089
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589090: Call_PlusDomainsActivitiesList_589076; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_589090.validator(path, query, header, formData, body)
  let scheme = call_589090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589090.url(scheme.get, call_589090.host, call_589090.base,
                         call_589090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589090, url, valid)

proc call*(call_589091: Call_PlusDomainsActivitiesList_589076; userId: string;
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
  var path_589092 = newJObject()
  var query_589093 = newJObject()
  add(query_589093, "fields", newJString(fields))
  add(query_589093, "pageToken", newJString(pageToken))
  add(query_589093, "quotaUser", newJString(quotaUser))
  add(query_589093, "alt", newJString(alt))
  add(query_589093, "oauth_token", newJString(oauthToken))
  add(path_589092, "collection", newJString(collection))
  add(query_589093, "userIp", newJString(userIp))
  add(query_589093, "maxResults", newJInt(maxResults))
  add(query_589093, "key", newJString(key))
  add(query_589093, "prettyPrint", newJBool(prettyPrint))
  add(path_589092, "userId", newJString(userId))
  result = call_589091.call(path_589092, query_589093, nil, nil, nil)

var plusDomainsActivitiesList* = Call_PlusDomainsActivitiesList_589076(
    name: "plusDomainsActivitiesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/people/{userId}/activities/{collection}",
    validator: validate_PlusDomainsActivitiesList_589077, base: "/plusDomains/v1",
    url: url_PlusDomainsActivitiesList_589078, schemes: {Scheme.Https})
type
  Call_PlusDomainsAudiencesList_589094 = ref object of OpenApiRestCall_588457
proc url_PlusDomainsAudiencesList_589096(protocol: Scheme; host: string;
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

proc validate_PlusDomainsAudiencesList_589095(path: JsonNode; query: JsonNode;
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
  var valid_589097 = path.getOrDefault("userId")
  valid_589097 = validateParameter(valid_589097, JString, required = true,
                                 default = nil)
  if valid_589097 != nil:
    section.add "userId", valid_589097
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
  var valid_589098 = query.getOrDefault("fields")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "fields", valid_589098
  var valid_589099 = query.getOrDefault("pageToken")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = nil)
  if valid_589099 != nil:
    section.add "pageToken", valid_589099
  var valid_589100 = query.getOrDefault("quotaUser")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = nil)
  if valid_589100 != nil:
    section.add "quotaUser", valid_589100
  var valid_589101 = query.getOrDefault("alt")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = newJString("json"))
  if valid_589101 != nil:
    section.add "alt", valid_589101
  var valid_589102 = query.getOrDefault("oauth_token")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "oauth_token", valid_589102
  var valid_589103 = query.getOrDefault("userIp")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "userIp", valid_589103
  var valid_589104 = query.getOrDefault("maxResults")
  valid_589104 = validateParameter(valid_589104, JInt, required = false,
                                 default = newJInt(20))
  if valid_589104 != nil:
    section.add "maxResults", valid_589104
  var valid_589105 = query.getOrDefault("key")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = nil)
  if valid_589105 != nil:
    section.add "key", valid_589105
  var valid_589106 = query.getOrDefault("prettyPrint")
  valid_589106 = validateParameter(valid_589106, JBool, required = false,
                                 default = newJBool(true))
  if valid_589106 != nil:
    section.add "prettyPrint", valid_589106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589107: Call_PlusDomainsAudiencesList_589094; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_589107.validator(path, query, header, formData, body)
  let scheme = call_589107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589107.url(scheme.get, call_589107.host, call_589107.base,
                         call_589107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589107, url, valid)

proc call*(call_589108: Call_PlusDomainsAudiencesList_589094; userId: string;
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
  var path_589109 = newJObject()
  var query_589110 = newJObject()
  add(query_589110, "fields", newJString(fields))
  add(query_589110, "pageToken", newJString(pageToken))
  add(query_589110, "quotaUser", newJString(quotaUser))
  add(query_589110, "alt", newJString(alt))
  add(query_589110, "oauth_token", newJString(oauthToken))
  add(query_589110, "userIp", newJString(userIp))
  add(query_589110, "maxResults", newJInt(maxResults))
  add(query_589110, "key", newJString(key))
  add(query_589110, "prettyPrint", newJBool(prettyPrint))
  add(path_589109, "userId", newJString(userId))
  result = call_589108.call(path_589109, query_589110, nil, nil, nil)

var plusDomainsAudiencesList* = Call_PlusDomainsAudiencesList_589094(
    name: "plusDomainsAudiencesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/people/{userId}/audiences",
    validator: validate_PlusDomainsAudiencesList_589095, base: "/plusDomains/v1",
    url: url_PlusDomainsAudiencesList_589096, schemes: {Scheme.Https})
type
  Call_PlusDomainsCirclesList_589111 = ref object of OpenApiRestCall_588457
proc url_PlusDomainsCirclesList_589113(protocol: Scheme; host: string; base: string;
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

proc validate_PlusDomainsCirclesList_589112(path: JsonNode; query: JsonNode;
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
  var valid_589114 = path.getOrDefault("userId")
  valid_589114 = validateParameter(valid_589114, JString, required = true,
                                 default = nil)
  if valid_589114 != nil:
    section.add "userId", valid_589114
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
  var valid_589115 = query.getOrDefault("fields")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "fields", valid_589115
  var valid_589116 = query.getOrDefault("pageToken")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = nil)
  if valid_589116 != nil:
    section.add "pageToken", valid_589116
  var valid_589117 = query.getOrDefault("quotaUser")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = nil)
  if valid_589117 != nil:
    section.add "quotaUser", valid_589117
  var valid_589118 = query.getOrDefault("alt")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = newJString("json"))
  if valid_589118 != nil:
    section.add "alt", valid_589118
  var valid_589119 = query.getOrDefault("oauth_token")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = nil)
  if valid_589119 != nil:
    section.add "oauth_token", valid_589119
  var valid_589120 = query.getOrDefault("userIp")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = nil)
  if valid_589120 != nil:
    section.add "userIp", valid_589120
  var valid_589121 = query.getOrDefault("maxResults")
  valid_589121 = validateParameter(valid_589121, JInt, required = false,
                                 default = newJInt(20))
  if valid_589121 != nil:
    section.add "maxResults", valid_589121
  var valid_589122 = query.getOrDefault("key")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = nil)
  if valid_589122 != nil:
    section.add "key", valid_589122
  var valid_589123 = query.getOrDefault("prettyPrint")
  valid_589123 = validateParameter(valid_589123, JBool, required = false,
                                 default = newJBool(true))
  if valid_589123 != nil:
    section.add "prettyPrint", valid_589123
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589124: Call_PlusDomainsCirclesList_589111; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_589124.validator(path, query, header, formData, body)
  let scheme = call_589124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589124.url(scheme.get, call_589124.host, call_589124.base,
                         call_589124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589124, url, valid)

proc call*(call_589125: Call_PlusDomainsCirclesList_589111; userId: string;
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
  var path_589126 = newJObject()
  var query_589127 = newJObject()
  add(query_589127, "fields", newJString(fields))
  add(query_589127, "pageToken", newJString(pageToken))
  add(query_589127, "quotaUser", newJString(quotaUser))
  add(query_589127, "alt", newJString(alt))
  add(query_589127, "oauth_token", newJString(oauthToken))
  add(query_589127, "userIp", newJString(userIp))
  add(query_589127, "maxResults", newJInt(maxResults))
  add(query_589127, "key", newJString(key))
  add(query_589127, "prettyPrint", newJBool(prettyPrint))
  add(path_589126, "userId", newJString(userId))
  result = call_589125.call(path_589126, query_589127, nil, nil, nil)

var plusDomainsCirclesList* = Call_PlusDomainsCirclesList_589111(
    name: "plusDomainsCirclesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/people/{userId}/circles",
    validator: validate_PlusDomainsCirclesList_589112, base: "/plusDomains/v1",
    url: url_PlusDomainsCirclesList_589113, schemes: {Scheme.Https})
type
  Call_PlusDomainsMediaInsert_589128 = ref object of OpenApiRestCall_588457
proc url_PlusDomainsMediaInsert_589130(protocol: Scheme; host: string; base: string;
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

proc validate_PlusDomainsMediaInsert_589129(path: JsonNode; query: JsonNode;
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
  var valid_589131 = path.getOrDefault("collection")
  valid_589131 = validateParameter(valid_589131, JString, required = true,
                                 default = newJString("cloud"))
  if valid_589131 != nil:
    section.add "collection", valid_589131
  var valid_589132 = path.getOrDefault("userId")
  valid_589132 = validateParameter(valid_589132, JString, required = true,
                                 default = nil)
  if valid_589132 != nil:
    section.add "userId", valid_589132
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
  var valid_589133 = query.getOrDefault("fields")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = nil)
  if valid_589133 != nil:
    section.add "fields", valid_589133
  var valid_589134 = query.getOrDefault("quotaUser")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "quotaUser", valid_589134
  var valid_589135 = query.getOrDefault("alt")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = newJString("json"))
  if valid_589135 != nil:
    section.add "alt", valid_589135
  var valid_589136 = query.getOrDefault("oauth_token")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = nil)
  if valid_589136 != nil:
    section.add "oauth_token", valid_589136
  var valid_589137 = query.getOrDefault("userIp")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = nil)
  if valid_589137 != nil:
    section.add "userIp", valid_589137
  var valid_589138 = query.getOrDefault("key")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = nil)
  if valid_589138 != nil:
    section.add "key", valid_589138
  var valid_589139 = query.getOrDefault("prettyPrint")
  valid_589139 = validateParameter(valid_589139, JBool, required = false,
                                 default = newJBool(true))
  if valid_589139 != nil:
    section.add "prettyPrint", valid_589139
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

proc call*(call_589141: Call_PlusDomainsMediaInsert_589128; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_589141.validator(path, query, header, formData, body)
  let scheme = call_589141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589141.url(scheme.get, call_589141.host, call_589141.base,
                         call_589141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589141, url, valid)

proc call*(call_589142: Call_PlusDomainsMediaInsert_589128; userId: string;
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
  var path_589143 = newJObject()
  var query_589144 = newJObject()
  var body_589145 = newJObject()
  add(query_589144, "fields", newJString(fields))
  add(query_589144, "quotaUser", newJString(quotaUser))
  add(query_589144, "alt", newJString(alt))
  add(query_589144, "oauth_token", newJString(oauthToken))
  add(path_589143, "collection", newJString(collection))
  add(query_589144, "userIp", newJString(userIp))
  add(query_589144, "key", newJString(key))
  if body != nil:
    body_589145 = body
  add(query_589144, "prettyPrint", newJBool(prettyPrint))
  add(path_589143, "userId", newJString(userId))
  result = call_589142.call(path_589143, query_589144, nil, nil, body_589145)

var plusDomainsMediaInsert* = Call_PlusDomainsMediaInsert_589128(
    name: "plusDomainsMediaInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/people/{userId}/media/{collection}",
    validator: validate_PlusDomainsMediaInsert_589129, base: "/plusDomains/v1",
    url: url_PlusDomainsMediaInsert_589130, schemes: {Scheme.Https})
type
  Call_PlusDomainsPeopleList_589146 = ref object of OpenApiRestCall_588457
proc url_PlusDomainsPeopleList_589148(protocol: Scheme; host: string; base: string;
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

proc validate_PlusDomainsPeopleList_589147(path: JsonNode; query: JsonNode;
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
  var valid_589149 = path.getOrDefault("collection")
  valid_589149 = validateParameter(valid_589149, JString, required = true,
                                 default = newJString("circled"))
  if valid_589149 != nil:
    section.add "collection", valid_589149
  var valid_589150 = path.getOrDefault("userId")
  valid_589150 = validateParameter(valid_589150, JString, required = true,
                                 default = nil)
  if valid_589150 != nil:
    section.add "userId", valid_589150
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
  var valid_589151 = query.getOrDefault("fields")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = nil)
  if valid_589151 != nil:
    section.add "fields", valid_589151
  var valid_589152 = query.getOrDefault("pageToken")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "pageToken", valid_589152
  var valid_589153 = query.getOrDefault("quotaUser")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = nil)
  if valid_589153 != nil:
    section.add "quotaUser", valid_589153
  var valid_589154 = query.getOrDefault("alt")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = newJString("json"))
  if valid_589154 != nil:
    section.add "alt", valid_589154
  var valid_589155 = query.getOrDefault("oauth_token")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = nil)
  if valid_589155 != nil:
    section.add "oauth_token", valid_589155
  var valid_589156 = query.getOrDefault("userIp")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = nil)
  if valid_589156 != nil:
    section.add "userIp", valid_589156
  var valid_589157 = query.getOrDefault("maxResults")
  valid_589157 = validateParameter(valid_589157, JInt, required = false,
                                 default = newJInt(100))
  if valid_589157 != nil:
    section.add "maxResults", valid_589157
  var valid_589158 = query.getOrDefault("orderBy")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = newJString("alphabetical"))
  if valid_589158 != nil:
    section.add "orderBy", valid_589158
  var valid_589159 = query.getOrDefault("key")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = nil)
  if valid_589159 != nil:
    section.add "key", valid_589159
  var valid_589160 = query.getOrDefault("prettyPrint")
  valid_589160 = validateParameter(valid_589160, JBool, required = false,
                                 default = newJBool(true))
  if valid_589160 != nil:
    section.add "prettyPrint", valid_589160
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589161: Call_PlusDomainsPeopleList_589146; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all of the people in the specified collection.
  ## 
  let valid = call_589161.validator(path, query, header, formData, body)
  let scheme = call_589161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589161.url(scheme.get, call_589161.host, call_589161.base,
                         call_589161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589161, url, valid)

proc call*(call_589162: Call_PlusDomainsPeopleList_589146; userId: string;
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
  var path_589163 = newJObject()
  var query_589164 = newJObject()
  add(query_589164, "fields", newJString(fields))
  add(query_589164, "pageToken", newJString(pageToken))
  add(query_589164, "quotaUser", newJString(quotaUser))
  add(query_589164, "alt", newJString(alt))
  add(query_589164, "oauth_token", newJString(oauthToken))
  add(path_589163, "collection", newJString(collection))
  add(query_589164, "userIp", newJString(userIp))
  add(query_589164, "maxResults", newJInt(maxResults))
  add(query_589164, "orderBy", newJString(orderBy))
  add(query_589164, "key", newJString(key))
  add(query_589164, "prettyPrint", newJBool(prettyPrint))
  add(path_589163, "userId", newJString(userId))
  result = call_589162.call(path_589163, query_589164, nil, nil, nil)

var plusDomainsPeopleList* = Call_PlusDomainsPeopleList_589146(
    name: "plusDomainsPeopleList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/people/{userId}/people/{collection}",
    validator: validate_PlusDomainsPeopleList_589147, base: "/plusDomains/v1",
    url: url_PlusDomainsPeopleList_589148, schemes: {Scheme.Https})
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
