
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
  gcpServiceName = "plusDomains"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PlusDomainsActivitiesGet_578625 = ref object of OpenApiRestCall_578355
proc url_PlusDomainsActivitiesGet_578627(protocol: Scheme; host: string;
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

proc validate_PlusDomainsActivitiesGet_578626(path: JsonNode; query: JsonNode;
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
  var valid_578753 = path.getOrDefault("activityId")
  valid_578753 = validateParameter(valid_578753, JString, required = true,
                                 default = nil)
  if valid_578753 != nil:
    section.add "activityId", valid_578753
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
  var valid_578754 = query.getOrDefault("key")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "key", valid_578754
  var valid_578768 = query.getOrDefault("prettyPrint")
  valid_578768 = validateParameter(valid_578768, JBool, required = false,
                                 default = newJBool(true))
  if valid_578768 != nil:
    section.add "prettyPrint", valid_578768
  var valid_578769 = query.getOrDefault("oauth_token")
  valid_578769 = validateParameter(valid_578769, JString, required = false,
                                 default = nil)
  if valid_578769 != nil:
    section.add "oauth_token", valid_578769
  var valid_578770 = query.getOrDefault("alt")
  valid_578770 = validateParameter(valid_578770, JString, required = false,
                                 default = newJString("json"))
  if valid_578770 != nil:
    section.add "alt", valid_578770
  var valid_578771 = query.getOrDefault("userIp")
  valid_578771 = validateParameter(valid_578771, JString, required = false,
                                 default = nil)
  if valid_578771 != nil:
    section.add "userIp", valid_578771
  var valid_578772 = query.getOrDefault("quotaUser")
  valid_578772 = validateParameter(valid_578772, JString, required = false,
                                 default = nil)
  if valid_578772 != nil:
    section.add "quotaUser", valid_578772
  var valid_578773 = query.getOrDefault("fields")
  valid_578773 = validateParameter(valid_578773, JString, required = false,
                                 default = nil)
  if valid_578773 != nil:
    section.add "fields", valid_578773
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578796: Call_PlusDomainsActivitiesGet_578625; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_578796.validator(path, query, header, formData, body)
  let scheme = call_578796.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578796.url(scheme.get, call_578796.host, call_578796.base,
                         call_578796.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578796, url, valid)

proc call*(call_578867: Call_PlusDomainsActivitiesGet_578625; activityId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## plusDomainsActivitiesGet
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
  var path_578868 = newJObject()
  var query_578870 = newJObject()
  add(query_578870, "key", newJString(key))
  add(query_578870, "prettyPrint", newJBool(prettyPrint))
  add(query_578870, "oauth_token", newJString(oauthToken))
  add(query_578870, "alt", newJString(alt))
  add(query_578870, "userIp", newJString(userIp))
  add(query_578870, "quotaUser", newJString(quotaUser))
  add(path_578868, "activityId", newJString(activityId))
  add(query_578870, "fields", newJString(fields))
  result = call_578867.call(path_578868, query_578870, nil, nil, nil)

var plusDomainsActivitiesGet* = Call_PlusDomainsActivitiesGet_578625(
    name: "plusDomainsActivitiesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/activities/{activityId}",
    validator: validate_PlusDomainsActivitiesGet_578626, base: "/plusDomains/v1",
    url: url_PlusDomainsActivitiesGet_578627, schemes: {Scheme.Https})
type
  Call_PlusDomainsCommentsList_578909 = ref object of OpenApiRestCall_578355
proc url_PlusDomainsCommentsList_578911(protocol: Scheme; host: string; base: string;
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

proc validate_PlusDomainsCommentsList_578910(path: JsonNode; query: JsonNode;
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
  var valid_578912 = path.getOrDefault("activityId")
  valid_578912 = validateParameter(valid_578912, JString, required = true,
                                 default = nil)
  if valid_578912 != nil:
    section.add "activityId", valid_578912
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
  var valid_578913 = query.getOrDefault("key")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "key", valid_578913
  var valid_578914 = query.getOrDefault("prettyPrint")
  valid_578914 = validateParameter(valid_578914, JBool, required = false,
                                 default = newJBool(true))
  if valid_578914 != nil:
    section.add "prettyPrint", valid_578914
  var valid_578915 = query.getOrDefault("oauth_token")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "oauth_token", valid_578915
  var valid_578916 = query.getOrDefault("alt")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = newJString("json"))
  if valid_578916 != nil:
    section.add "alt", valid_578916
  var valid_578917 = query.getOrDefault("userIp")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "userIp", valid_578917
  var valid_578918 = query.getOrDefault("quotaUser")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "quotaUser", valid_578918
  var valid_578919 = query.getOrDefault("pageToken")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "pageToken", valid_578919
  var valid_578920 = query.getOrDefault("sortOrder")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = newJString("ascending"))
  if valid_578920 != nil:
    section.add "sortOrder", valid_578920
  var valid_578921 = query.getOrDefault("fields")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "fields", valid_578921
  var valid_578923 = query.getOrDefault("maxResults")
  valid_578923 = validateParameter(valid_578923, JInt, required = false,
                                 default = newJInt(20))
  if valid_578923 != nil:
    section.add "maxResults", valid_578923
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578924: Call_PlusDomainsCommentsList_578909; path: JsonNode;
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

proc call*(call_578925: Call_PlusDomainsCommentsList_578909; activityId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; sortOrder: string = "ascending"; fields: string = "";
          maxResults: int = 20): Recallable =
  ## plusDomainsCommentsList
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
  var path_578926 = newJObject()
  var query_578927 = newJObject()
  add(query_578927, "key", newJString(key))
  add(query_578927, "prettyPrint", newJBool(prettyPrint))
  add(query_578927, "oauth_token", newJString(oauthToken))
  add(query_578927, "alt", newJString(alt))
  add(query_578927, "userIp", newJString(userIp))
  add(query_578927, "quotaUser", newJString(quotaUser))
  add(query_578927, "pageToken", newJString(pageToken))
  add(query_578927, "sortOrder", newJString(sortOrder))
  add(path_578926, "activityId", newJString(activityId))
  add(query_578927, "fields", newJString(fields))
  add(query_578927, "maxResults", newJInt(maxResults))
  result = call_578925.call(path_578926, query_578927, nil, nil, nil)

var plusDomainsCommentsList* = Call_PlusDomainsCommentsList_578909(
    name: "plusDomainsCommentsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/activities/{activityId}/comments",
    validator: validate_PlusDomainsCommentsList_578910, base: "/plusDomains/v1",
    url: url_PlusDomainsCommentsList_578911, schemes: {Scheme.Https})
type
  Call_PlusDomainsPeopleListByActivity_578928 = ref object of OpenApiRestCall_578355
proc url_PlusDomainsPeopleListByActivity_578930(protocol: Scheme; host: string;
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

proc validate_PlusDomainsPeopleListByActivity_578929(path: JsonNode;
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
  var valid_578931 = path.getOrDefault("activityId")
  valid_578931 = validateParameter(valid_578931, JString, required = true,
                                 default = nil)
  if valid_578931 != nil:
    section.add "activityId", valid_578931
  var valid_578932 = path.getOrDefault("collection")
  valid_578932 = validateParameter(valid_578932, JString, required = true,
                                 default = newJString("plusoners"))
  if valid_578932 != nil:
    section.add "collection", valid_578932
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
  var valid_578933 = query.getOrDefault("key")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "key", valid_578933
  var valid_578934 = query.getOrDefault("prettyPrint")
  valid_578934 = validateParameter(valid_578934, JBool, required = false,
                                 default = newJBool(true))
  if valid_578934 != nil:
    section.add "prettyPrint", valid_578934
  var valid_578935 = query.getOrDefault("oauth_token")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "oauth_token", valid_578935
  var valid_578936 = query.getOrDefault("alt")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = newJString("json"))
  if valid_578936 != nil:
    section.add "alt", valid_578936
  var valid_578937 = query.getOrDefault("userIp")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "userIp", valid_578937
  var valid_578938 = query.getOrDefault("quotaUser")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "quotaUser", valid_578938
  var valid_578939 = query.getOrDefault("pageToken")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "pageToken", valid_578939
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

proc call*(call_578942: Call_PlusDomainsPeopleListByActivity_578928;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
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

proc call*(call_578943: Call_PlusDomainsPeopleListByActivity_578928;
          activityId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; fields: string = "";
          collection: string = "plusoners"; maxResults: int = 20): Recallable =
  ## plusDomainsPeopleListByActivity
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
  var path_578944 = newJObject()
  var query_578945 = newJObject()
  add(query_578945, "key", newJString(key))
  add(query_578945, "prettyPrint", newJBool(prettyPrint))
  add(query_578945, "oauth_token", newJString(oauthToken))
  add(query_578945, "alt", newJString(alt))
  add(query_578945, "userIp", newJString(userIp))
  add(query_578945, "quotaUser", newJString(quotaUser))
  add(query_578945, "pageToken", newJString(pageToken))
  add(path_578944, "activityId", newJString(activityId))
  add(query_578945, "fields", newJString(fields))
  add(path_578944, "collection", newJString(collection))
  add(query_578945, "maxResults", newJInt(maxResults))
  result = call_578943.call(path_578944, query_578945, nil, nil, nil)

var plusDomainsPeopleListByActivity* = Call_PlusDomainsPeopleListByActivity_578928(
    name: "plusDomainsPeopleListByActivity", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/activities/{activityId}/people/{collection}",
    validator: validate_PlusDomainsPeopleListByActivity_578929,
    base: "/plusDomains/v1", url: url_PlusDomainsPeopleListByActivity_578930,
    schemes: {Scheme.Https})
type
  Call_PlusDomainsCommentsGet_578946 = ref object of OpenApiRestCall_578355
proc url_PlusDomainsCommentsGet_578948(protocol: Scheme; host: string; base: string;
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

proc validate_PlusDomainsCommentsGet_578947(path: JsonNode; query: JsonNode;
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
  var valid_578949 = path.getOrDefault("commentId")
  valid_578949 = validateParameter(valid_578949, JString, required = true,
                                 default = nil)
  if valid_578949 != nil:
    section.add "commentId", valid_578949
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
  var valid_578950 = query.getOrDefault("key")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "key", valid_578950
  var valid_578951 = query.getOrDefault("prettyPrint")
  valid_578951 = validateParameter(valid_578951, JBool, required = false,
                                 default = newJBool(true))
  if valid_578951 != nil:
    section.add "prettyPrint", valid_578951
  var valid_578952 = query.getOrDefault("oauth_token")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "oauth_token", valid_578952
  var valid_578953 = query.getOrDefault("alt")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = newJString("json"))
  if valid_578953 != nil:
    section.add "alt", valid_578953
  var valid_578954 = query.getOrDefault("userIp")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "userIp", valid_578954
  var valid_578955 = query.getOrDefault("quotaUser")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "quotaUser", valid_578955
  var valid_578956 = query.getOrDefault("fields")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "fields", valid_578956
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578957: Call_PlusDomainsCommentsGet_578946; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_578957.validator(path, query, header, formData, body)
  let scheme = call_578957.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578957.url(scheme.get, call_578957.host, call_578957.base,
                         call_578957.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578957, url, valid)

proc call*(call_578958: Call_PlusDomainsCommentsGet_578946; commentId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## plusDomainsCommentsGet
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
  var path_578959 = newJObject()
  var query_578960 = newJObject()
  add(query_578960, "key", newJString(key))
  add(query_578960, "prettyPrint", newJBool(prettyPrint))
  add(query_578960, "oauth_token", newJString(oauthToken))
  add(query_578960, "alt", newJString(alt))
  add(query_578960, "userIp", newJString(userIp))
  add(query_578960, "quotaUser", newJString(quotaUser))
  add(path_578959, "commentId", newJString(commentId))
  add(query_578960, "fields", newJString(fields))
  result = call_578958.call(path_578959, query_578960, nil, nil, nil)

var plusDomainsCommentsGet* = Call_PlusDomainsCommentsGet_578946(
    name: "plusDomainsCommentsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/comments/{commentId}",
    validator: validate_PlusDomainsCommentsGet_578947, base: "/plusDomains/v1",
    url: url_PlusDomainsCommentsGet_578948, schemes: {Scheme.Https})
type
  Call_PlusDomainsPeopleGet_578961 = ref object of OpenApiRestCall_578355
proc url_PlusDomainsPeopleGet_578963(protocol: Scheme; host: string; base: string;
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

proc validate_PlusDomainsPeopleGet_578962(path: JsonNode; query: JsonNode;
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
  var valid_578964 = path.getOrDefault("userId")
  valid_578964 = validateParameter(valid_578964, JString, required = true,
                                 default = nil)
  if valid_578964 != nil:
    section.add "userId", valid_578964
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
  var valid_578965 = query.getOrDefault("key")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "key", valid_578965
  var valid_578966 = query.getOrDefault("prettyPrint")
  valid_578966 = validateParameter(valid_578966, JBool, required = false,
                                 default = newJBool(true))
  if valid_578966 != nil:
    section.add "prettyPrint", valid_578966
  var valid_578967 = query.getOrDefault("oauth_token")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "oauth_token", valid_578967
  var valid_578968 = query.getOrDefault("alt")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = newJString("json"))
  if valid_578968 != nil:
    section.add "alt", valid_578968
  var valid_578969 = query.getOrDefault("userIp")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "userIp", valid_578969
  var valid_578970 = query.getOrDefault("quotaUser")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "quotaUser", valid_578970
  var valid_578971 = query.getOrDefault("fields")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "fields", valid_578971
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578972: Call_PlusDomainsPeopleGet_578961; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a person's profile.
  ## 
  let valid = call_578972.validator(path, query, header, formData, body)
  let scheme = call_578972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578972.url(scheme.get, call_578972.host, call_578972.base,
                         call_578972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578972, url, valid)

proc call*(call_578973: Call_PlusDomainsPeopleGet_578961; userId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## plusDomainsPeopleGet
  ## Get a person's profile.
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
  var path_578974 = newJObject()
  var query_578975 = newJObject()
  add(query_578975, "key", newJString(key))
  add(query_578975, "prettyPrint", newJBool(prettyPrint))
  add(query_578975, "oauth_token", newJString(oauthToken))
  add(query_578975, "alt", newJString(alt))
  add(query_578975, "userIp", newJString(userIp))
  add(query_578975, "quotaUser", newJString(quotaUser))
  add(path_578974, "userId", newJString(userId))
  add(query_578975, "fields", newJString(fields))
  result = call_578973.call(path_578974, query_578975, nil, nil, nil)

var plusDomainsPeopleGet* = Call_PlusDomainsPeopleGet_578961(
    name: "plusDomainsPeopleGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/people/{userId}",
    validator: validate_PlusDomainsPeopleGet_578962, base: "/plusDomains/v1",
    url: url_PlusDomainsPeopleGet_578963, schemes: {Scheme.Https})
type
  Call_PlusDomainsActivitiesList_578976 = ref object of OpenApiRestCall_578355
proc url_PlusDomainsActivitiesList_578978(protocol: Scheme; host: string;
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

proc validate_PlusDomainsActivitiesList_578977(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_578979 = path.getOrDefault("userId")
  valid_578979 = validateParameter(valid_578979, JString, required = true,
                                 default = nil)
  if valid_578979 != nil:
    section.add "userId", valid_578979
  var valid_578980 = path.getOrDefault("collection")
  valid_578980 = validateParameter(valid_578980, JString, required = true,
                                 default = newJString("user"))
  if valid_578980 != nil:
    section.add "collection", valid_578980
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
  var valid_578981 = query.getOrDefault("key")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = nil)
  if valid_578981 != nil:
    section.add "key", valid_578981
  var valid_578982 = query.getOrDefault("prettyPrint")
  valid_578982 = validateParameter(valid_578982, JBool, required = false,
                                 default = newJBool(true))
  if valid_578982 != nil:
    section.add "prettyPrint", valid_578982
  var valid_578983 = query.getOrDefault("oauth_token")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "oauth_token", valid_578983
  var valid_578984 = query.getOrDefault("alt")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = newJString("json"))
  if valid_578984 != nil:
    section.add "alt", valid_578984
  var valid_578985 = query.getOrDefault("userIp")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "userIp", valid_578985
  var valid_578986 = query.getOrDefault("quotaUser")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = nil)
  if valid_578986 != nil:
    section.add "quotaUser", valid_578986
  var valid_578987 = query.getOrDefault("pageToken")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "pageToken", valid_578987
  var valid_578988 = query.getOrDefault("fields")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = nil)
  if valid_578988 != nil:
    section.add "fields", valid_578988
  var valid_578989 = query.getOrDefault("maxResults")
  valid_578989 = validateParameter(valid_578989, JInt, required = false,
                                 default = newJInt(20))
  if valid_578989 != nil:
    section.add "maxResults", valid_578989
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578990: Call_PlusDomainsActivitiesList_578976; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_578990.validator(path, query, header, formData, body)
  let scheme = call_578990.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578990.url(scheme.get, call_578990.host, call_578990.base,
                         call_578990.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578990, url, valid)

proc call*(call_578991: Call_PlusDomainsActivitiesList_578976; userId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; fields: string = ""; collection: string = "user";
          maxResults: int = 20): Recallable =
  ## plusDomainsActivitiesList
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
  var path_578992 = newJObject()
  var query_578993 = newJObject()
  add(query_578993, "key", newJString(key))
  add(query_578993, "prettyPrint", newJBool(prettyPrint))
  add(query_578993, "oauth_token", newJString(oauthToken))
  add(query_578993, "alt", newJString(alt))
  add(query_578993, "userIp", newJString(userIp))
  add(query_578993, "quotaUser", newJString(quotaUser))
  add(query_578993, "pageToken", newJString(pageToken))
  add(path_578992, "userId", newJString(userId))
  add(query_578993, "fields", newJString(fields))
  add(path_578992, "collection", newJString(collection))
  add(query_578993, "maxResults", newJInt(maxResults))
  result = call_578991.call(path_578992, query_578993, nil, nil, nil)

var plusDomainsActivitiesList* = Call_PlusDomainsActivitiesList_578976(
    name: "plusDomainsActivitiesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/people/{userId}/activities/{collection}",
    validator: validate_PlusDomainsActivitiesList_578977, base: "/plusDomains/v1",
    url: url_PlusDomainsActivitiesList_578978, schemes: {Scheme.Https})
type
  Call_PlusDomainsAudiencesList_578994 = ref object of OpenApiRestCall_578355
proc url_PlusDomainsAudiencesList_578996(protocol: Scheme; host: string;
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

proc validate_PlusDomainsAudiencesList_578995(path: JsonNode; query: JsonNode;
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
  var valid_578997 = path.getOrDefault("userId")
  valid_578997 = validateParameter(valid_578997, JString, required = true,
                                 default = nil)
  if valid_578997 != nil:
    section.add "userId", valid_578997
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
  ##             : The maximum number of circles to include in the response, which is used for paging. For any response, the actual number returned might be less than the specified maxResults.
  section = newJObject()
  var valid_578998 = query.getOrDefault("key")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "key", valid_578998
  var valid_578999 = query.getOrDefault("prettyPrint")
  valid_578999 = validateParameter(valid_578999, JBool, required = false,
                                 default = newJBool(true))
  if valid_578999 != nil:
    section.add "prettyPrint", valid_578999
  var valid_579000 = query.getOrDefault("oauth_token")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = nil)
  if valid_579000 != nil:
    section.add "oauth_token", valid_579000
  var valid_579001 = query.getOrDefault("alt")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = newJString("json"))
  if valid_579001 != nil:
    section.add "alt", valid_579001
  var valid_579002 = query.getOrDefault("userIp")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = nil)
  if valid_579002 != nil:
    section.add "userIp", valid_579002
  var valid_579003 = query.getOrDefault("quotaUser")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "quotaUser", valid_579003
  var valid_579004 = query.getOrDefault("pageToken")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "pageToken", valid_579004
  var valid_579005 = query.getOrDefault("fields")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "fields", valid_579005
  var valid_579006 = query.getOrDefault("maxResults")
  valid_579006 = validateParameter(valid_579006, JInt, required = false,
                                 default = newJInt(20))
  if valid_579006 != nil:
    section.add "maxResults", valid_579006
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579007: Call_PlusDomainsAudiencesList_578994; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_579007.validator(path, query, header, formData, body)
  let scheme = call_579007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579007.url(scheme.get, call_579007.host, call_579007.base,
                         call_579007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579007, url, valid)

proc call*(call_579008: Call_PlusDomainsAudiencesList_578994; userId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; fields: string = ""; maxResults: int = 20): Recallable =
  ## plusDomainsAudiencesList
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
  ##         : The ID of the user to get audiences for. The special value "me" can be used to indicate the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of circles to include in the response, which is used for paging. For any response, the actual number returned might be less than the specified maxResults.
  var path_579009 = newJObject()
  var query_579010 = newJObject()
  add(query_579010, "key", newJString(key))
  add(query_579010, "prettyPrint", newJBool(prettyPrint))
  add(query_579010, "oauth_token", newJString(oauthToken))
  add(query_579010, "alt", newJString(alt))
  add(query_579010, "userIp", newJString(userIp))
  add(query_579010, "quotaUser", newJString(quotaUser))
  add(query_579010, "pageToken", newJString(pageToken))
  add(path_579009, "userId", newJString(userId))
  add(query_579010, "fields", newJString(fields))
  add(query_579010, "maxResults", newJInt(maxResults))
  result = call_579008.call(path_579009, query_579010, nil, nil, nil)

var plusDomainsAudiencesList* = Call_PlusDomainsAudiencesList_578994(
    name: "plusDomainsAudiencesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/people/{userId}/audiences",
    validator: validate_PlusDomainsAudiencesList_578995, base: "/plusDomains/v1",
    url: url_PlusDomainsAudiencesList_578996, schemes: {Scheme.Https})
type
  Call_PlusDomainsCirclesList_579011 = ref object of OpenApiRestCall_578355
proc url_PlusDomainsCirclesList_579013(protocol: Scheme; host: string; base: string;
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

proc validate_PlusDomainsCirclesList_579012(path: JsonNode; query: JsonNode;
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
  var valid_579014 = path.getOrDefault("userId")
  valid_579014 = validateParameter(valid_579014, JString, required = true,
                                 default = nil)
  if valid_579014 != nil:
    section.add "userId", valid_579014
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
  ##             : The maximum number of circles to include in the response, which is used for paging. For any response, the actual number returned might be less than the specified maxResults.
  section = newJObject()
  var valid_579015 = query.getOrDefault("key")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "key", valid_579015
  var valid_579016 = query.getOrDefault("prettyPrint")
  valid_579016 = validateParameter(valid_579016, JBool, required = false,
                                 default = newJBool(true))
  if valid_579016 != nil:
    section.add "prettyPrint", valid_579016
  var valid_579017 = query.getOrDefault("oauth_token")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "oauth_token", valid_579017
  var valid_579018 = query.getOrDefault("alt")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = newJString("json"))
  if valid_579018 != nil:
    section.add "alt", valid_579018
  var valid_579019 = query.getOrDefault("userIp")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "userIp", valid_579019
  var valid_579020 = query.getOrDefault("quotaUser")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "quotaUser", valid_579020
  var valid_579021 = query.getOrDefault("pageToken")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = nil)
  if valid_579021 != nil:
    section.add "pageToken", valid_579021
  var valid_579022 = query.getOrDefault("fields")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "fields", valid_579022
  var valid_579023 = query.getOrDefault("maxResults")
  valid_579023 = validateParameter(valid_579023, JInt, required = false,
                                 default = newJInt(20))
  if valid_579023 != nil:
    section.add "maxResults", valid_579023
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579024: Call_PlusDomainsCirclesList_579011; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_579024.validator(path, query, header, formData, body)
  let scheme = call_579024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579024.url(scheme.get, call_579024.host, call_579024.base,
                         call_579024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579024, url, valid)

proc call*(call_579025: Call_PlusDomainsCirclesList_579011; userId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; fields: string = ""; maxResults: int = 20): Recallable =
  ## plusDomainsCirclesList
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
  ##         : The ID of the user to get circles for. The special value "me" can be used to indicate the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : The maximum number of circles to include in the response, which is used for paging. For any response, the actual number returned might be less than the specified maxResults.
  var path_579026 = newJObject()
  var query_579027 = newJObject()
  add(query_579027, "key", newJString(key))
  add(query_579027, "prettyPrint", newJBool(prettyPrint))
  add(query_579027, "oauth_token", newJString(oauthToken))
  add(query_579027, "alt", newJString(alt))
  add(query_579027, "userIp", newJString(userIp))
  add(query_579027, "quotaUser", newJString(quotaUser))
  add(query_579027, "pageToken", newJString(pageToken))
  add(path_579026, "userId", newJString(userId))
  add(query_579027, "fields", newJString(fields))
  add(query_579027, "maxResults", newJInt(maxResults))
  result = call_579025.call(path_579026, query_579027, nil, nil, nil)

var plusDomainsCirclesList* = Call_PlusDomainsCirclesList_579011(
    name: "plusDomainsCirclesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/people/{userId}/circles",
    validator: validate_PlusDomainsCirclesList_579012, base: "/plusDomains/v1",
    url: url_PlusDomainsCirclesList_579013, schemes: {Scheme.Https})
type
  Call_PlusDomainsMediaInsert_579028 = ref object of OpenApiRestCall_578355
proc url_PlusDomainsMediaInsert_579030(protocol: Scheme; host: string; base: string;
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

proc validate_PlusDomainsMediaInsert_579029(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : The ID of the user to create the activity on behalf of.
  ##   collection: JString (required)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_579031 = path.getOrDefault("userId")
  valid_579031 = validateParameter(valid_579031, JString, required = true,
                                 default = nil)
  if valid_579031 != nil:
    section.add "userId", valid_579031
  var valid_579032 = path.getOrDefault("collection")
  valid_579032 = validateParameter(valid_579032, JString, required = true,
                                 default = newJString("cloud"))
  if valid_579032 != nil:
    section.add "collection", valid_579032
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
  var valid_579033 = query.getOrDefault("key")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = nil)
  if valid_579033 != nil:
    section.add "key", valid_579033
  var valid_579034 = query.getOrDefault("prettyPrint")
  valid_579034 = validateParameter(valid_579034, JBool, required = false,
                                 default = newJBool(true))
  if valid_579034 != nil:
    section.add "prettyPrint", valid_579034
  var valid_579035 = query.getOrDefault("oauth_token")
  valid_579035 = validateParameter(valid_579035, JString, required = false,
                                 default = nil)
  if valid_579035 != nil:
    section.add "oauth_token", valid_579035
  var valid_579036 = query.getOrDefault("alt")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = newJString("json"))
  if valid_579036 != nil:
    section.add "alt", valid_579036
  var valid_579037 = query.getOrDefault("userIp")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = nil)
  if valid_579037 != nil:
    section.add "userIp", valid_579037
  var valid_579038 = query.getOrDefault("quotaUser")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = nil)
  if valid_579038 != nil:
    section.add "quotaUser", valid_579038
  var valid_579039 = query.getOrDefault("fields")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "fields", valid_579039
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

proc call*(call_579041: Call_PlusDomainsMediaInsert_579028; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down. See https://developers.google.com/+/api-shutdown for more details.
  ## 
  let valid = call_579041.validator(path, query, header, formData, body)
  let scheme = call_579041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579041.url(scheme.get, call_579041.host, call_579041.base,
                         call_579041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579041, url, valid)

proc call*(call_579042: Call_PlusDomainsMediaInsert_579028; userId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""; collection: string = "cloud"): Recallable =
  ## plusDomainsMediaInsert
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
  ##   userId: string (required)
  ##         : The ID of the user to create the activity on behalf of.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   collection: string (required)
  var path_579043 = newJObject()
  var query_579044 = newJObject()
  var body_579045 = newJObject()
  add(query_579044, "key", newJString(key))
  add(query_579044, "prettyPrint", newJBool(prettyPrint))
  add(query_579044, "oauth_token", newJString(oauthToken))
  add(query_579044, "alt", newJString(alt))
  add(query_579044, "userIp", newJString(userIp))
  add(query_579044, "quotaUser", newJString(quotaUser))
  add(path_579043, "userId", newJString(userId))
  if body != nil:
    body_579045 = body
  add(query_579044, "fields", newJString(fields))
  add(path_579043, "collection", newJString(collection))
  result = call_579042.call(path_579043, query_579044, nil, nil, body_579045)

var plusDomainsMediaInsert* = Call_PlusDomainsMediaInsert_579028(
    name: "plusDomainsMediaInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/people/{userId}/media/{collection}",
    validator: validate_PlusDomainsMediaInsert_579029, base: "/plusDomains/v1",
    url: url_PlusDomainsMediaInsert_579030, schemes: {Scheme.Https})
type
  Call_PlusDomainsPeopleList_579046 = ref object of OpenApiRestCall_578355
proc url_PlusDomainsPeopleList_579048(protocol: Scheme; host: string; base: string;
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

proc validate_PlusDomainsPeopleList_579047(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_579049 = path.getOrDefault("userId")
  valid_579049 = validateParameter(valid_579049, JString, required = true,
                                 default = nil)
  if valid_579049 != nil:
    section.add "userId", valid_579049
  var valid_579050 = path.getOrDefault("collection")
  valid_579050 = validateParameter(valid_579050, JString, required = true,
                                 default = newJString("circled"))
  if valid_579050 != nil:
    section.add "collection", valid_579050
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
  var valid_579051 = query.getOrDefault("key")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = nil)
  if valid_579051 != nil:
    section.add "key", valid_579051
  var valid_579052 = query.getOrDefault("prettyPrint")
  valid_579052 = validateParameter(valid_579052, JBool, required = false,
                                 default = newJBool(true))
  if valid_579052 != nil:
    section.add "prettyPrint", valid_579052
  var valid_579053 = query.getOrDefault("oauth_token")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = nil)
  if valid_579053 != nil:
    section.add "oauth_token", valid_579053
  var valid_579054 = query.getOrDefault("alt")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = newJString("json"))
  if valid_579054 != nil:
    section.add "alt", valid_579054
  var valid_579055 = query.getOrDefault("userIp")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "userIp", valid_579055
  var valid_579056 = query.getOrDefault("quotaUser")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "quotaUser", valid_579056
  var valid_579057 = query.getOrDefault("orderBy")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = newJString("alphabetical"))
  if valid_579057 != nil:
    section.add "orderBy", valid_579057
  var valid_579058 = query.getOrDefault("pageToken")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "pageToken", valid_579058
  var valid_579059 = query.getOrDefault("fields")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = nil)
  if valid_579059 != nil:
    section.add "fields", valid_579059
  var valid_579060 = query.getOrDefault("maxResults")
  valid_579060 = validateParameter(valid_579060, JInt, required = false,
                                 default = newJInt(100))
  if valid_579060 != nil:
    section.add "maxResults", valid_579060
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579061: Call_PlusDomainsPeopleList_579046; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all of the people in the specified collection.
  ## 
  let valid = call_579061.validator(path, query, header, formData, body)
  let scheme = call_579061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579061.url(scheme.get, call_579061.host, call_579061.base,
                         call_579061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579061, url, valid)

proc call*(call_579062: Call_PlusDomainsPeopleList_579046; userId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          orderBy: string = "alphabetical"; pageToken: string = ""; fields: string = "";
          collection: string = "circled"; maxResults: int = 100): Recallable =
  ## plusDomainsPeopleList
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
  var path_579063 = newJObject()
  var query_579064 = newJObject()
  add(query_579064, "key", newJString(key))
  add(query_579064, "prettyPrint", newJBool(prettyPrint))
  add(query_579064, "oauth_token", newJString(oauthToken))
  add(query_579064, "alt", newJString(alt))
  add(query_579064, "userIp", newJString(userIp))
  add(query_579064, "quotaUser", newJString(quotaUser))
  add(query_579064, "orderBy", newJString(orderBy))
  add(query_579064, "pageToken", newJString(pageToken))
  add(path_579063, "userId", newJString(userId))
  add(query_579064, "fields", newJString(fields))
  add(path_579063, "collection", newJString(collection))
  add(query_579064, "maxResults", newJInt(maxResults))
  result = call_579062.call(path_579063, query_579064, nil, nil, nil)

var plusDomainsPeopleList* = Call_PlusDomainsPeopleList_579046(
    name: "plusDomainsPeopleList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/people/{userId}/people/{collection}",
    validator: validate_PlusDomainsPeopleList_579047, base: "/plusDomains/v1",
    url: url_PlusDomainsPeopleList_579048, schemes: {Scheme.Https})
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
