
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Blogger
## version: v3
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## API for access to the data within Blogger.
## 
## https://developers.google.com/blogger/docs/3.0/getting_started
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

  OpenApiRestCall_579408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579408): Option[Scheme] {.used.} =
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
  gcpServiceName = "blogger"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BloggerBlogsGetByUrl_579676 = ref object of OpenApiRestCall_579408
proc url_BloggerBlogsGetByUrl_579678(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BloggerBlogsGetByUrl_579677(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve a Blog by URL.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: JString
  ##       : Access level with which to view the blog. Note that some fields require elevated access.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   url: JString (required)
  ##      : The URL of the blog to retrieve.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579790 = query.getOrDefault("fields")
  valid_579790 = validateParameter(valid_579790, JString, required = false,
                                 default = nil)
  if valid_579790 != nil:
    section.add "fields", valid_579790
  var valid_579804 = query.getOrDefault("view")
  valid_579804 = validateParameter(valid_579804, JString, required = false,
                                 default = newJString("ADMIN"))
  if valid_579804 != nil:
    section.add "view", valid_579804
  var valid_579805 = query.getOrDefault("quotaUser")
  valid_579805 = validateParameter(valid_579805, JString, required = false,
                                 default = nil)
  if valid_579805 != nil:
    section.add "quotaUser", valid_579805
  var valid_579806 = query.getOrDefault("alt")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = newJString("json"))
  if valid_579806 != nil:
    section.add "alt", valid_579806
  var valid_579807 = query.getOrDefault("oauth_token")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "oauth_token", valid_579807
  var valid_579808 = query.getOrDefault("userIp")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "userIp", valid_579808
  assert query != nil, "query argument is necessary due to required `url` field"
  var valid_579809 = query.getOrDefault("url")
  valid_579809 = validateParameter(valid_579809, JString, required = true,
                                 default = nil)
  if valid_579809 != nil:
    section.add "url", valid_579809
  var valid_579810 = query.getOrDefault("key")
  valid_579810 = validateParameter(valid_579810, JString, required = false,
                                 default = nil)
  if valid_579810 != nil:
    section.add "key", valid_579810
  var valid_579811 = query.getOrDefault("prettyPrint")
  valid_579811 = validateParameter(valid_579811, JBool, required = false,
                                 default = newJBool(true))
  if valid_579811 != nil:
    section.add "prettyPrint", valid_579811
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579834: Call_BloggerBlogsGetByUrl_579676; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a Blog by URL.
  ## 
  let valid = call_579834.validator(path, query, header, formData, body)
  let scheme = call_579834.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579834.url(scheme.get, call_579834.host, call_579834.base,
                         call_579834.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579834, url, valid)

proc call*(call_579905: Call_BloggerBlogsGetByUrl_579676; url: string;
          fields: string = ""; view: string = "ADMIN"; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## bloggerBlogsGetByUrl
  ## Retrieve a Blog by URL.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: string
  ##       : Access level with which to view the blog. Note that some fields require elevated access.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   url: string (required)
  ##      : The URL of the blog to retrieve.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_579906 = newJObject()
  add(query_579906, "fields", newJString(fields))
  add(query_579906, "view", newJString(view))
  add(query_579906, "quotaUser", newJString(quotaUser))
  add(query_579906, "alt", newJString(alt))
  add(query_579906, "oauth_token", newJString(oauthToken))
  add(query_579906, "userIp", newJString(userIp))
  add(query_579906, "url", newJString(url))
  add(query_579906, "key", newJString(key))
  add(query_579906, "prettyPrint", newJBool(prettyPrint))
  result = call_579905.call(nil, query_579906, nil, nil, nil)

var bloggerBlogsGetByUrl* = Call_BloggerBlogsGetByUrl_579676(
    name: "bloggerBlogsGetByUrl", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/blogs/byurl",
    validator: validate_BloggerBlogsGetByUrl_579677, base: "/blogger/v3",
    url: url_BloggerBlogsGetByUrl_579678, schemes: {Scheme.Https})
type
  Call_BloggerBlogsGet_579946 = ref object of OpenApiRestCall_579408
proc url_BloggerBlogsGet_579948(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "blogId" in path, "`blogId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerBlogsGet_579947(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets one blog by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blogId: JString (required)
  ##         : The ID of the blog to get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blogId` field"
  var valid_579963 = path.getOrDefault("blogId")
  valid_579963 = validateParameter(valid_579963, JString, required = true,
                                 default = nil)
  if valid_579963 != nil:
    section.add "blogId", valid_579963
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: JString
  ##       : Access level with which to view the blog. Note that some fields require elevated access.
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
  ##   maxPosts: JInt
  ##           : Maximum number of posts to pull back with the blog.
  section = newJObject()
  var valid_579964 = query.getOrDefault("fields")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = nil)
  if valid_579964 != nil:
    section.add "fields", valid_579964
  var valid_579965 = query.getOrDefault("view")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = newJString("ADMIN"))
  if valid_579965 != nil:
    section.add "view", valid_579965
  var valid_579966 = query.getOrDefault("quotaUser")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "quotaUser", valid_579966
  var valid_579967 = query.getOrDefault("alt")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = newJString("json"))
  if valid_579967 != nil:
    section.add "alt", valid_579967
  var valid_579968 = query.getOrDefault("oauth_token")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "oauth_token", valid_579968
  var valid_579969 = query.getOrDefault("userIp")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "userIp", valid_579969
  var valid_579970 = query.getOrDefault("key")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "key", valid_579970
  var valid_579971 = query.getOrDefault("prettyPrint")
  valid_579971 = validateParameter(valid_579971, JBool, required = false,
                                 default = newJBool(true))
  if valid_579971 != nil:
    section.add "prettyPrint", valid_579971
  var valid_579972 = query.getOrDefault("maxPosts")
  valid_579972 = validateParameter(valid_579972, JInt, required = false, default = nil)
  if valid_579972 != nil:
    section.add "maxPosts", valid_579972
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579973: Call_BloggerBlogsGet_579946; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one blog by ID.
  ## 
  let valid = call_579973.validator(path, query, header, formData, body)
  let scheme = call_579973.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579973.url(scheme.get, call_579973.host, call_579973.base,
                         call_579973.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579973, url, valid)

proc call*(call_579974: Call_BloggerBlogsGet_579946; blogId: string;
          fields: string = ""; view: string = "ADMIN"; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true; maxPosts: int = 0): Recallable =
  ## bloggerBlogsGet
  ## Gets one blog by ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: string
  ##       : Access level with which to view the blog. Note that some fields require elevated access.
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
  ##   blogId: string (required)
  ##         : The ID of the blog to get.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   maxPosts: int
  ##           : Maximum number of posts to pull back with the blog.
  var path_579975 = newJObject()
  var query_579976 = newJObject()
  add(query_579976, "fields", newJString(fields))
  add(query_579976, "view", newJString(view))
  add(query_579976, "quotaUser", newJString(quotaUser))
  add(query_579976, "alt", newJString(alt))
  add(query_579976, "oauth_token", newJString(oauthToken))
  add(query_579976, "userIp", newJString(userIp))
  add(query_579976, "key", newJString(key))
  add(path_579975, "blogId", newJString(blogId))
  add(query_579976, "prettyPrint", newJBool(prettyPrint))
  add(query_579976, "maxPosts", newJInt(maxPosts))
  result = call_579974.call(path_579975, query_579976, nil, nil, nil)

var bloggerBlogsGet* = Call_BloggerBlogsGet_579946(name: "bloggerBlogsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/blogs/{blogId}",
    validator: validate_BloggerBlogsGet_579947, base: "/blogger/v3",
    url: url_BloggerBlogsGet_579948, schemes: {Scheme.Https})
type
  Call_BloggerCommentsListByBlog_579977 = ref object of OpenApiRestCall_579408
proc url_BloggerCommentsListByBlog_579979(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "blogId" in path, "`blogId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId"),
               (kind: ConstantSegment, value: "/comments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerCommentsListByBlog_579978(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the comments for a blog, across all posts, possibly filtered.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blogId: JString (required)
  ##         : ID of the blog to fetch comments from.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blogId` field"
  var valid_579980 = path.getOrDefault("blogId")
  valid_579980 = validateParameter(valid_579980, JString, required = true,
                                 default = nil)
  if valid_579980 != nil:
    section.add "blogId", valid_579980
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Continuation token if request is paged.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   endDate: JString
  ##          : Latest date of comment to fetch, a date-time with RFC 3339 formatting.
  ##   startDate: JString
  ##            : Earliest date of comment to fetch, a date-time with RFC 3339 formatting.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of comments to include in the result.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   status: JArray
  ##   fetchBodies: JBool
  ##              : Whether the body content of the comments is included.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579981 = query.getOrDefault("fields")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "fields", valid_579981
  var valid_579982 = query.getOrDefault("pageToken")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "pageToken", valid_579982
  var valid_579983 = query.getOrDefault("quotaUser")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "quotaUser", valid_579983
  var valid_579984 = query.getOrDefault("alt")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = newJString("json"))
  if valid_579984 != nil:
    section.add "alt", valid_579984
  var valid_579985 = query.getOrDefault("endDate")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "endDate", valid_579985
  var valid_579986 = query.getOrDefault("startDate")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "startDate", valid_579986
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
  var valid_579989 = query.getOrDefault("maxResults")
  valid_579989 = validateParameter(valid_579989, JInt, required = false, default = nil)
  if valid_579989 != nil:
    section.add "maxResults", valid_579989
  var valid_579990 = query.getOrDefault("key")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "key", valid_579990
  var valid_579991 = query.getOrDefault("status")
  valid_579991 = validateParameter(valid_579991, JArray, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "status", valid_579991
  var valid_579992 = query.getOrDefault("fetchBodies")
  valid_579992 = validateParameter(valid_579992, JBool, required = false, default = nil)
  if valid_579992 != nil:
    section.add "fetchBodies", valid_579992
  var valid_579993 = query.getOrDefault("prettyPrint")
  valid_579993 = validateParameter(valid_579993, JBool, required = false,
                                 default = newJBool(true))
  if valid_579993 != nil:
    section.add "prettyPrint", valid_579993
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579994: Call_BloggerCommentsListByBlog_579977; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the comments for a blog, across all posts, possibly filtered.
  ## 
  let valid = call_579994.validator(path, query, header, formData, body)
  let scheme = call_579994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579994.url(scheme.get, call_579994.host, call_579994.base,
                         call_579994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579994, url, valid)

proc call*(call_579995: Call_BloggerCommentsListByBlog_579977; blogId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; endDate: string = ""; startDate: string = "";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; status: JsonNode = nil; fetchBodies: bool = false;
          prettyPrint: bool = true): Recallable =
  ## bloggerCommentsListByBlog
  ## Retrieves the comments for a blog, across all posts, possibly filtered.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Continuation token if request is paged.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   endDate: string
  ##          : Latest date of comment to fetch, a date-time with RFC 3339 formatting.
  ##   startDate: string
  ##            : Earliest date of comment to fetch, a date-time with RFC 3339 formatting.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of comments to include in the result.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   status: JArray
  ##   fetchBodies: bool
  ##              : Whether the body content of the comments is included.
  ##   blogId: string (required)
  ##         : ID of the blog to fetch comments from.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_579996 = newJObject()
  var query_579997 = newJObject()
  add(query_579997, "fields", newJString(fields))
  add(query_579997, "pageToken", newJString(pageToken))
  add(query_579997, "quotaUser", newJString(quotaUser))
  add(query_579997, "alt", newJString(alt))
  add(query_579997, "endDate", newJString(endDate))
  add(query_579997, "startDate", newJString(startDate))
  add(query_579997, "oauth_token", newJString(oauthToken))
  add(query_579997, "userIp", newJString(userIp))
  add(query_579997, "maxResults", newJInt(maxResults))
  add(query_579997, "key", newJString(key))
  if status != nil:
    query_579997.add "status", status
  add(query_579997, "fetchBodies", newJBool(fetchBodies))
  add(path_579996, "blogId", newJString(blogId))
  add(query_579997, "prettyPrint", newJBool(prettyPrint))
  result = call_579995.call(path_579996, query_579997, nil, nil, nil)

var bloggerCommentsListByBlog* = Call_BloggerCommentsListByBlog_579977(
    name: "bloggerCommentsListByBlog", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/blogs/{blogId}/comments",
    validator: validate_BloggerCommentsListByBlog_579978, base: "/blogger/v3",
    url: url_BloggerCommentsListByBlog_579979, schemes: {Scheme.Https})
type
  Call_BloggerPagesInsert_580018 = ref object of OpenApiRestCall_579408
proc url_BloggerPagesInsert_580020(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "blogId" in path, "`blogId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId"),
               (kind: ConstantSegment, value: "/pages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerPagesInsert_580019(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Add a page.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blogId: JString (required)
  ##         : ID of the blog to add the page to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blogId` field"
  var valid_580021 = path.getOrDefault("blogId")
  valid_580021 = validateParameter(valid_580021, JString, required = true,
                                 default = nil)
  if valid_580021 != nil:
    section.add "blogId", valid_580021
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
  ##   isDraft: JBool
  ##          : Whether to create the page as a draft (default: false).
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580022 = query.getOrDefault("fields")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "fields", valid_580022
  var valid_580023 = query.getOrDefault("quotaUser")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "quotaUser", valid_580023
  var valid_580024 = query.getOrDefault("alt")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = newJString("json"))
  if valid_580024 != nil:
    section.add "alt", valid_580024
  var valid_580025 = query.getOrDefault("oauth_token")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "oauth_token", valid_580025
  var valid_580026 = query.getOrDefault("isDraft")
  valid_580026 = validateParameter(valid_580026, JBool, required = false, default = nil)
  if valid_580026 != nil:
    section.add "isDraft", valid_580026
  var valid_580027 = query.getOrDefault("userIp")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "userIp", valid_580027
  var valid_580028 = query.getOrDefault("key")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "key", valid_580028
  var valid_580029 = query.getOrDefault("prettyPrint")
  valid_580029 = validateParameter(valid_580029, JBool, required = false,
                                 default = newJBool(true))
  if valid_580029 != nil:
    section.add "prettyPrint", valid_580029
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

proc call*(call_580031: Call_BloggerPagesInsert_580018; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a page.
  ## 
  let valid = call_580031.validator(path, query, header, formData, body)
  let scheme = call_580031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580031.url(scheme.get, call_580031.host, call_580031.base,
                         call_580031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580031, url, valid)

proc call*(call_580032: Call_BloggerPagesInsert_580018; blogId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; isDraft: bool = false; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## bloggerPagesInsert
  ## Add a page.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   isDraft: bool
  ##          : Whether to create the page as a draft (default: false).
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   blogId: string (required)
  ##         : ID of the blog to add the page to.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580033 = newJObject()
  var query_580034 = newJObject()
  var body_580035 = newJObject()
  add(query_580034, "fields", newJString(fields))
  add(query_580034, "quotaUser", newJString(quotaUser))
  add(query_580034, "alt", newJString(alt))
  add(query_580034, "oauth_token", newJString(oauthToken))
  add(query_580034, "isDraft", newJBool(isDraft))
  add(query_580034, "userIp", newJString(userIp))
  add(query_580034, "key", newJString(key))
  add(path_580033, "blogId", newJString(blogId))
  if body != nil:
    body_580035 = body
  add(query_580034, "prettyPrint", newJBool(prettyPrint))
  result = call_580032.call(path_580033, query_580034, nil, nil, body_580035)

var bloggerPagesInsert* = Call_BloggerPagesInsert_580018(
    name: "bloggerPagesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/blogs/{blogId}/pages",
    validator: validate_BloggerPagesInsert_580019, base: "/blogger/v3",
    url: url_BloggerPagesInsert_580020, schemes: {Scheme.Https})
type
  Call_BloggerPagesList_579998 = ref object of OpenApiRestCall_579408
proc url_BloggerPagesList_580000(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "blogId" in path, "`blogId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId"),
               (kind: ConstantSegment, value: "/pages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerPagesList_579999(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Retrieves the pages for a blog, optionally including non-LIVE statuses.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blogId: JString (required)
  ##         : ID of the blog to fetch Pages from.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blogId` field"
  var valid_580001 = path.getOrDefault("blogId")
  valid_580001 = validateParameter(valid_580001, JString, required = true,
                                 default = nil)
  if valid_580001 != nil:
    section.add "blogId", valid_580001
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Continuation token if the request is paged.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   view: JString
  ##       : Access level with which to view the returned result. Note that some fields require elevated access.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of Pages to fetch.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   status: JArray
  ##   fetchBodies: JBool
  ##              : Whether to retrieve the Page bodies.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580002 = query.getOrDefault("fields")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "fields", valid_580002
  var valid_580003 = query.getOrDefault("pageToken")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "pageToken", valid_580003
  var valid_580004 = query.getOrDefault("quotaUser")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "quotaUser", valid_580004
  var valid_580005 = query.getOrDefault("view")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = newJString("ADMIN"))
  if valid_580005 != nil:
    section.add "view", valid_580005
  var valid_580006 = query.getOrDefault("alt")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = newJString("json"))
  if valid_580006 != nil:
    section.add "alt", valid_580006
  var valid_580007 = query.getOrDefault("oauth_token")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "oauth_token", valid_580007
  var valid_580008 = query.getOrDefault("userIp")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "userIp", valid_580008
  var valid_580009 = query.getOrDefault("maxResults")
  valid_580009 = validateParameter(valid_580009, JInt, required = false, default = nil)
  if valid_580009 != nil:
    section.add "maxResults", valid_580009
  var valid_580010 = query.getOrDefault("key")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "key", valid_580010
  var valid_580011 = query.getOrDefault("status")
  valid_580011 = validateParameter(valid_580011, JArray, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "status", valid_580011
  var valid_580012 = query.getOrDefault("fetchBodies")
  valid_580012 = validateParameter(valid_580012, JBool, required = false, default = nil)
  if valid_580012 != nil:
    section.add "fetchBodies", valid_580012
  var valid_580013 = query.getOrDefault("prettyPrint")
  valid_580013 = validateParameter(valid_580013, JBool, required = false,
                                 default = newJBool(true))
  if valid_580013 != nil:
    section.add "prettyPrint", valid_580013
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580014: Call_BloggerPagesList_579998; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the pages for a blog, optionally including non-LIVE statuses.
  ## 
  let valid = call_580014.validator(path, query, header, formData, body)
  let scheme = call_580014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580014.url(scheme.get, call_580014.host, call_580014.base,
                         call_580014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580014, url, valid)

proc call*(call_580015: Call_BloggerPagesList_579998; blogId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          view: string = "ADMIN"; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          status: JsonNode = nil; fetchBodies: bool = false; prettyPrint: bool = true): Recallable =
  ## bloggerPagesList
  ## Retrieves the pages for a blog, optionally including non-LIVE statuses.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Continuation token if the request is paged.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   view: string
  ##       : Access level with which to view the returned result. Note that some fields require elevated access.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of Pages to fetch.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   status: JArray
  ##   fetchBodies: bool
  ##              : Whether to retrieve the Page bodies.
  ##   blogId: string (required)
  ##         : ID of the blog to fetch Pages from.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580016 = newJObject()
  var query_580017 = newJObject()
  add(query_580017, "fields", newJString(fields))
  add(query_580017, "pageToken", newJString(pageToken))
  add(query_580017, "quotaUser", newJString(quotaUser))
  add(query_580017, "view", newJString(view))
  add(query_580017, "alt", newJString(alt))
  add(query_580017, "oauth_token", newJString(oauthToken))
  add(query_580017, "userIp", newJString(userIp))
  add(query_580017, "maxResults", newJInt(maxResults))
  add(query_580017, "key", newJString(key))
  if status != nil:
    query_580017.add "status", status
  add(query_580017, "fetchBodies", newJBool(fetchBodies))
  add(path_580016, "blogId", newJString(blogId))
  add(query_580017, "prettyPrint", newJBool(prettyPrint))
  result = call_580015.call(path_580016, query_580017, nil, nil, nil)

var bloggerPagesList* = Call_BloggerPagesList_579998(name: "bloggerPagesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/blogs/{blogId}/pages", validator: validate_BloggerPagesList_579999,
    base: "/blogger/v3", url: url_BloggerPagesList_580000, schemes: {Scheme.Https})
type
  Call_BloggerPagesUpdate_580053 = ref object of OpenApiRestCall_579408
proc url_BloggerPagesUpdate_580055(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "blogId" in path, "`blogId` is a required path parameter"
  assert "pageId" in path, "`pageId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId"),
               (kind: ConstantSegment, value: "/pages/"),
               (kind: VariableSegment, value: "pageId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerPagesUpdate_580054(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Update a page.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   pageId: JString (required)
  ##         : The ID of the Page.
  ##   blogId: JString (required)
  ##         : The ID of the Blog.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `pageId` field"
  var valid_580056 = path.getOrDefault("pageId")
  valid_580056 = validateParameter(valid_580056, JString, required = true,
                                 default = nil)
  if valid_580056 != nil:
    section.add "pageId", valid_580056
  var valid_580057 = path.getOrDefault("blogId")
  valid_580057 = validateParameter(valid_580057, JString, required = true,
                                 default = nil)
  if valid_580057 != nil:
    section.add "blogId", valid_580057
  result.add "path", section
  ## parameters in `query` object:
  ##   revert: JBool
  ##         : Whether a revert action should be performed when the page is updated (default: false).
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
  ##   publish: JBool
  ##          : Whether a publish action should be performed when the page is updated (default: false).
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580058 = query.getOrDefault("revert")
  valid_580058 = validateParameter(valid_580058, JBool, required = false, default = nil)
  if valid_580058 != nil:
    section.add "revert", valid_580058
  var valid_580059 = query.getOrDefault("fields")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "fields", valid_580059
  var valid_580060 = query.getOrDefault("quotaUser")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "quotaUser", valid_580060
  var valid_580061 = query.getOrDefault("alt")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = newJString("json"))
  if valid_580061 != nil:
    section.add "alt", valid_580061
  var valid_580062 = query.getOrDefault("oauth_token")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "oauth_token", valid_580062
  var valid_580063 = query.getOrDefault("userIp")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "userIp", valid_580063
  var valid_580064 = query.getOrDefault("key")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "key", valid_580064
  var valid_580065 = query.getOrDefault("publish")
  valid_580065 = validateParameter(valid_580065, JBool, required = false, default = nil)
  if valid_580065 != nil:
    section.add "publish", valid_580065
  var valid_580066 = query.getOrDefault("prettyPrint")
  valid_580066 = validateParameter(valid_580066, JBool, required = false,
                                 default = newJBool(true))
  if valid_580066 != nil:
    section.add "prettyPrint", valid_580066
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

proc call*(call_580068: Call_BloggerPagesUpdate_580053; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a page.
  ## 
  let valid = call_580068.validator(path, query, header, formData, body)
  let scheme = call_580068.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580068.url(scheme.get, call_580068.host, call_580068.base,
                         call_580068.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580068, url, valid)

proc call*(call_580069: Call_BloggerPagesUpdate_580053; pageId: string;
          blogId: string; revert: bool = false; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; publish: bool = false;
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## bloggerPagesUpdate
  ## Update a page.
  ##   revert: bool
  ##         : Whether a revert action should be performed when the page is updated (default: false).
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
  ##   pageId: string (required)
  ##         : The ID of the Page.
  ##   publish: bool
  ##          : Whether a publish action should be performed when the page is updated (default: false).
  ##   blogId: string (required)
  ##         : The ID of the Blog.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580070 = newJObject()
  var query_580071 = newJObject()
  var body_580072 = newJObject()
  add(query_580071, "revert", newJBool(revert))
  add(query_580071, "fields", newJString(fields))
  add(query_580071, "quotaUser", newJString(quotaUser))
  add(query_580071, "alt", newJString(alt))
  add(query_580071, "oauth_token", newJString(oauthToken))
  add(query_580071, "userIp", newJString(userIp))
  add(query_580071, "key", newJString(key))
  add(path_580070, "pageId", newJString(pageId))
  add(query_580071, "publish", newJBool(publish))
  add(path_580070, "blogId", newJString(blogId))
  if body != nil:
    body_580072 = body
  add(query_580071, "prettyPrint", newJBool(prettyPrint))
  result = call_580069.call(path_580070, query_580071, nil, nil, body_580072)

var bloggerPagesUpdate* = Call_BloggerPagesUpdate_580053(
    name: "bloggerPagesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/blogs/{blogId}/pages/{pageId}",
    validator: validate_BloggerPagesUpdate_580054, base: "/blogger/v3",
    url: url_BloggerPagesUpdate_580055, schemes: {Scheme.Https})
type
  Call_BloggerPagesGet_580036 = ref object of OpenApiRestCall_579408
proc url_BloggerPagesGet_580038(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "blogId" in path, "`blogId` is a required path parameter"
  assert "pageId" in path, "`pageId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId"),
               (kind: ConstantSegment, value: "/pages/"),
               (kind: VariableSegment, value: "pageId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerPagesGet_580037(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets one blog page by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   pageId: JString (required)
  ##         : The ID of the page to get.
  ##   blogId: JString (required)
  ##         : ID of the blog containing the page.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `pageId` field"
  var valid_580039 = path.getOrDefault("pageId")
  valid_580039 = validateParameter(valid_580039, JString, required = true,
                                 default = nil)
  if valid_580039 != nil:
    section.add "pageId", valid_580039
  var valid_580040 = path.getOrDefault("blogId")
  valid_580040 = validateParameter(valid_580040, JString, required = true,
                                 default = nil)
  if valid_580040 != nil:
    section.add "blogId", valid_580040
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: JString
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
  var valid_580041 = query.getOrDefault("fields")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "fields", valid_580041
  var valid_580042 = query.getOrDefault("view")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = newJString("ADMIN"))
  if valid_580042 != nil:
    section.add "view", valid_580042
  var valid_580043 = query.getOrDefault("quotaUser")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "quotaUser", valid_580043
  var valid_580044 = query.getOrDefault("alt")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = newJString("json"))
  if valid_580044 != nil:
    section.add "alt", valid_580044
  var valid_580045 = query.getOrDefault("oauth_token")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "oauth_token", valid_580045
  var valid_580046 = query.getOrDefault("userIp")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "userIp", valid_580046
  var valid_580047 = query.getOrDefault("key")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "key", valid_580047
  var valid_580048 = query.getOrDefault("prettyPrint")
  valid_580048 = validateParameter(valid_580048, JBool, required = false,
                                 default = newJBool(true))
  if valid_580048 != nil:
    section.add "prettyPrint", valid_580048
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580049: Call_BloggerPagesGet_580036; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one blog page by ID.
  ## 
  let valid = call_580049.validator(path, query, header, formData, body)
  let scheme = call_580049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580049.url(scheme.get, call_580049.host, call_580049.base,
                         call_580049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580049, url, valid)

proc call*(call_580050: Call_BloggerPagesGet_580036; pageId: string; blogId: string;
          fields: string = ""; view: string = "ADMIN"; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## bloggerPagesGet
  ## Gets one blog page by ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: string
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
  ##   pageId: string (required)
  ##         : The ID of the page to get.
  ##   blogId: string (required)
  ##         : ID of the blog containing the page.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580051 = newJObject()
  var query_580052 = newJObject()
  add(query_580052, "fields", newJString(fields))
  add(query_580052, "view", newJString(view))
  add(query_580052, "quotaUser", newJString(quotaUser))
  add(query_580052, "alt", newJString(alt))
  add(query_580052, "oauth_token", newJString(oauthToken))
  add(query_580052, "userIp", newJString(userIp))
  add(query_580052, "key", newJString(key))
  add(path_580051, "pageId", newJString(pageId))
  add(path_580051, "blogId", newJString(blogId))
  add(query_580052, "prettyPrint", newJBool(prettyPrint))
  result = call_580050.call(path_580051, query_580052, nil, nil, nil)

var bloggerPagesGet* = Call_BloggerPagesGet_580036(name: "bloggerPagesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/blogs/{blogId}/pages/{pageId}", validator: validate_BloggerPagesGet_580037,
    base: "/blogger/v3", url: url_BloggerPagesGet_580038, schemes: {Scheme.Https})
type
  Call_BloggerPagesPatch_580089 = ref object of OpenApiRestCall_579408
proc url_BloggerPagesPatch_580091(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "blogId" in path, "`blogId` is a required path parameter"
  assert "pageId" in path, "`pageId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId"),
               (kind: ConstantSegment, value: "/pages/"),
               (kind: VariableSegment, value: "pageId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerPagesPatch_580090(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Update a page. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   pageId: JString (required)
  ##         : The ID of the Page.
  ##   blogId: JString (required)
  ##         : The ID of the Blog.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `pageId` field"
  var valid_580092 = path.getOrDefault("pageId")
  valid_580092 = validateParameter(valid_580092, JString, required = true,
                                 default = nil)
  if valid_580092 != nil:
    section.add "pageId", valid_580092
  var valid_580093 = path.getOrDefault("blogId")
  valid_580093 = validateParameter(valid_580093, JString, required = true,
                                 default = nil)
  if valid_580093 != nil:
    section.add "blogId", valid_580093
  result.add "path", section
  ## parameters in `query` object:
  ##   revert: JBool
  ##         : Whether a revert action should be performed when the page is updated (default: false).
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
  ##   publish: JBool
  ##          : Whether a publish action should be performed when the page is updated (default: false).
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580094 = query.getOrDefault("revert")
  valid_580094 = validateParameter(valid_580094, JBool, required = false, default = nil)
  if valid_580094 != nil:
    section.add "revert", valid_580094
  var valid_580095 = query.getOrDefault("fields")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "fields", valid_580095
  var valid_580096 = query.getOrDefault("quotaUser")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "quotaUser", valid_580096
  var valid_580097 = query.getOrDefault("alt")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = newJString("json"))
  if valid_580097 != nil:
    section.add "alt", valid_580097
  var valid_580098 = query.getOrDefault("oauth_token")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "oauth_token", valid_580098
  var valid_580099 = query.getOrDefault("userIp")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "userIp", valid_580099
  var valid_580100 = query.getOrDefault("key")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "key", valid_580100
  var valid_580101 = query.getOrDefault("publish")
  valid_580101 = validateParameter(valid_580101, JBool, required = false, default = nil)
  if valid_580101 != nil:
    section.add "publish", valid_580101
  var valid_580102 = query.getOrDefault("prettyPrint")
  valid_580102 = validateParameter(valid_580102, JBool, required = false,
                                 default = newJBool(true))
  if valid_580102 != nil:
    section.add "prettyPrint", valid_580102
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

proc call*(call_580104: Call_BloggerPagesPatch_580089; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a page. This method supports patch semantics.
  ## 
  let valid = call_580104.validator(path, query, header, formData, body)
  let scheme = call_580104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580104.url(scheme.get, call_580104.host, call_580104.base,
                         call_580104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580104, url, valid)

proc call*(call_580105: Call_BloggerPagesPatch_580089; pageId: string;
          blogId: string; revert: bool = false; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; publish: bool = false;
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## bloggerPagesPatch
  ## Update a page. This method supports patch semantics.
  ##   revert: bool
  ##         : Whether a revert action should be performed when the page is updated (default: false).
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
  ##   pageId: string (required)
  ##         : The ID of the Page.
  ##   publish: bool
  ##          : Whether a publish action should be performed when the page is updated (default: false).
  ##   blogId: string (required)
  ##         : The ID of the Blog.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580106 = newJObject()
  var query_580107 = newJObject()
  var body_580108 = newJObject()
  add(query_580107, "revert", newJBool(revert))
  add(query_580107, "fields", newJString(fields))
  add(query_580107, "quotaUser", newJString(quotaUser))
  add(query_580107, "alt", newJString(alt))
  add(query_580107, "oauth_token", newJString(oauthToken))
  add(query_580107, "userIp", newJString(userIp))
  add(query_580107, "key", newJString(key))
  add(path_580106, "pageId", newJString(pageId))
  add(query_580107, "publish", newJBool(publish))
  add(path_580106, "blogId", newJString(blogId))
  if body != nil:
    body_580108 = body
  add(query_580107, "prettyPrint", newJBool(prettyPrint))
  result = call_580105.call(path_580106, query_580107, nil, nil, body_580108)

var bloggerPagesPatch* = Call_BloggerPagesPatch_580089(name: "bloggerPagesPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/blogs/{blogId}/pages/{pageId}",
    validator: validate_BloggerPagesPatch_580090, base: "/blogger/v3",
    url: url_BloggerPagesPatch_580091, schemes: {Scheme.Https})
type
  Call_BloggerPagesDelete_580073 = ref object of OpenApiRestCall_579408
proc url_BloggerPagesDelete_580075(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "blogId" in path, "`blogId` is a required path parameter"
  assert "pageId" in path, "`pageId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId"),
               (kind: ConstantSegment, value: "/pages/"),
               (kind: VariableSegment, value: "pageId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerPagesDelete_580074(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Delete a page by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   pageId: JString (required)
  ##         : The ID of the Page.
  ##   blogId: JString (required)
  ##         : The ID of the Blog.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `pageId` field"
  var valid_580076 = path.getOrDefault("pageId")
  valid_580076 = validateParameter(valid_580076, JString, required = true,
                                 default = nil)
  if valid_580076 != nil:
    section.add "pageId", valid_580076
  var valid_580077 = path.getOrDefault("blogId")
  valid_580077 = validateParameter(valid_580077, JString, required = true,
                                 default = nil)
  if valid_580077 != nil:
    section.add "blogId", valid_580077
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
  var valid_580078 = query.getOrDefault("fields")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "fields", valid_580078
  var valid_580079 = query.getOrDefault("quotaUser")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "quotaUser", valid_580079
  var valid_580080 = query.getOrDefault("alt")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = newJString("json"))
  if valid_580080 != nil:
    section.add "alt", valid_580080
  var valid_580081 = query.getOrDefault("oauth_token")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "oauth_token", valid_580081
  var valid_580082 = query.getOrDefault("userIp")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "userIp", valid_580082
  var valid_580083 = query.getOrDefault("key")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "key", valid_580083
  var valid_580084 = query.getOrDefault("prettyPrint")
  valid_580084 = validateParameter(valid_580084, JBool, required = false,
                                 default = newJBool(true))
  if valid_580084 != nil:
    section.add "prettyPrint", valid_580084
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580085: Call_BloggerPagesDelete_580073; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a page by ID.
  ## 
  let valid = call_580085.validator(path, query, header, formData, body)
  let scheme = call_580085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580085.url(scheme.get, call_580085.host, call_580085.base,
                         call_580085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580085, url, valid)

proc call*(call_580086: Call_BloggerPagesDelete_580073; pageId: string;
          blogId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## bloggerPagesDelete
  ## Delete a page by ID.
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
  ##   pageId: string (required)
  ##         : The ID of the Page.
  ##   blogId: string (required)
  ##         : The ID of the Blog.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580087 = newJObject()
  var query_580088 = newJObject()
  add(query_580088, "fields", newJString(fields))
  add(query_580088, "quotaUser", newJString(quotaUser))
  add(query_580088, "alt", newJString(alt))
  add(query_580088, "oauth_token", newJString(oauthToken))
  add(query_580088, "userIp", newJString(userIp))
  add(query_580088, "key", newJString(key))
  add(path_580087, "pageId", newJString(pageId))
  add(path_580087, "blogId", newJString(blogId))
  add(query_580088, "prettyPrint", newJBool(prettyPrint))
  result = call_580086.call(path_580087, query_580088, nil, nil, nil)

var bloggerPagesDelete* = Call_BloggerPagesDelete_580073(
    name: "bloggerPagesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/blogs/{blogId}/pages/{pageId}",
    validator: validate_BloggerPagesDelete_580074, base: "/blogger/v3",
    url: url_BloggerPagesDelete_580075, schemes: {Scheme.Https})
type
  Call_BloggerPagesPublish_580109 = ref object of OpenApiRestCall_579408
proc url_BloggerPagesPublish_580111(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "blogId" in path, "`blogId` is a required path parameter"
  assert "pageId" in path, "`pageId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId"),
               (kind: ConstantSegment, value: "/pages/"),
               (kind: VariableSegment, value: "pageId"),
               (kind: ConstantSegment, value: "/publish")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerPagesPublish_580110(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Publishes a draft page.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   pageId: JString (required)
  ##         : The ID of the page.
  ##   blogId: JString (required)
  ##         : The ID of the blog.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `pageId` field"
  var valid_580112 = path.getOrDefault("pageId")
  valid_580112 = validateParameter(valid_580112, JString, required = true,
                                 default = nil)
  if valid_580112 != nil:
    section.add "pageId", valid_580112
  var valid_580113 = path.getOrDefault("blogId")
  valid_580113 = validateParameter(valid_580113, JString, required = true,
                                 default = nil)
  if valid_580113 != nil:
    section.add "blogId", valid_580113
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
  var valid_580114 = query.getOrDefault("fields")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "fields", valid_580114
  var valid_580115 = query.getOrDefault("quotaUser")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "quotaUser", valid_580115
  var valid_580116 = query.getOrDefault("alt")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = newJString("json"))
  if valid_580116 != nil:
    section.add "alt", valid_580116
  var valid_580117 = query.getOrDefault("oauth_token")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "oauth_token", valid_580117
  var valid_580118 = query.getOrDefault("userIp")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "userIp", valid_580118
  var valid_580119 = query.getOrDefault("key")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "key", valid_580119
  var valid_580120 = query.getOrDefault("prettyPrint")
  valid_580120 = validateParameter(valid_580120, JBool, required = false,
                                 default = newJBool(true))
  if valid_580120 != nil:
    section.add "prettyPrint", valid_580120
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580121: Call_BloggerPagesPublish_580109; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Publishes a draft page.
  ## 
  let valid = call_580121.validator(path, query, header, formData, body)
  let scheme = call_580121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580121.url(scheme.get, call_580121.host, call_580121.base,
                         call_580121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580121, url, valid)

proc call*(call_580122: Call_BloggerPagesPublish_580109; pageId: string;
          blogId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## bloggerPagesPublish
  ## Publishes a draft page.
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
  ##   pageId: string (required)
  ##         : The ID of the page.
  ##   blogId: string (required)
  ##         : The ID of the blog.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580123 = newJObject()
  var query_580124 = newJObject()
  add(query_580124, "fields", newJString(fields))
  add(query_580124, "quotaUser", newJString(quotaUser))
  add(query_580124, "alt", newJString(alt))
  add(query_580124, "oauth_token", newJString(oauthToken))
  add(query_580124, "userIp", newJString(userIp))
  add(query_580124, "key", newJString(key))
  add(path_580123, "pageId", newJString(pageId))
  add(path_580123, "blogId", newJString(blogId))
  add(query_580124, "prettyPrint", newJBool(prettyPrint))
  result = call_580122.call(path_580123, query_580124, nil, nil, nil)

var bloggerPagesPublish* = Call_BloggerPagesPublish_580109(
    name: "bloggerPagesPublish", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/blogs/{blogId}/pages/{pageId}/publish",
    validator: validate_BloggerPagesPublish_580110, base: "/blogger/v3",
    url: url_BloggerPagesPublish_580111, schemes: {Scheme.Https})
type
  Call_BloggerPagesRevert_580125 = ref object of OpenApiRestCall_579408
proc url_BloggerPagesRevert_580127(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "blogId" in path, "`blogId` is a required path parameter"
  assert "pageId" in path, "`pageId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId"),
               (kind: ConstantSegment, value: "/pages/"),
               (kind: VariableSegment, value: "pageId"),
               (kind: ConstantSegment, value: "/revert")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerPagesRevert_580126(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Revert a published or scheduled page to draft state.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   pageId: JString (required)
  ##         : The ID of the page.
  ##   blogId: JString (required)
  ##         : The ID of the blog.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `pageId` field"
  var valid_580128 = path.getOrDefault("pageId")
  valid_580128 = validateParameter(valid_580128, JString, required = true,
                                 default = nil)
  if valid_580128 != nil:
    section.add "pageId", valid_580128
  var valid_580129 = path.getOrDefault("blogId")
  valid_580129 = validateParameter(valid_580129, JString, required = true,
                                 default = nil)
  if valid_580129 != nil:
    section.add "blogId", valid_580129
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
  var valid_580130 = query.getOrDefault("fields")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "fields", valid_580130
  var valid_580131 = query.getOrDefault("quotaUser")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "quotaUser", valid_580131
  var valid_580132 = query.getOrDefault("alt")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = newJString("json"))
  if valid_580132 != nil:
    section.add "alt", valid_580132
  var valid_580133 = query.getOrDefault("oauth_token")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "oauth_token", valid_580133
  var valid_580134 = query.getOrDefault("userIp")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "userIp", valid_580134
  var valid_580135 = query.getOrDefault("key")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "key", valid_580135
  var valid_580136 = query.getOrDefault("prettyPrint")
  valid_580136 = validateParameter(valid_580136, JBool, required = false,
                                 default = newJBool(true))
  if valid_580136 != nil:
    section.add "prettyPrint", valid_580136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580137: Call_BloggerPagesRevert_580125; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Revert a published or scheduled page to draft state.
  ## 
  let valid = call_580137.validator(path, query, header, formData, body)
  let scheme = call_580137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580137.url(scheme.get, call_580137.host, call_580137.base,
                         call_580137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580137, url, valid)

proc call*(call_580138: Call_BloggerPagesRevert_580125; pageId: string;
          blogId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## bloggerPagesRevert
  ## Revert a published or scheduled page to draft state.
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
  ##   pageId: string (required)
  ##         : The ID of the page.
  ##   blogId: string (required)
  ##         : The ID of the blog.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580139 = newJObject()
  var query_580140 = newJObject()
  add(query_580140, "fields", newJString(fields))
  add(query_580140, "quotaUser", newJString(quotaUser))
  add(query_580140, "alt", newJString(alt))
  add(query_580140, "oauth_token", newJString(oauthToken))
  add(query_580140, "userIp", newJString(userIp))
  add(query_580140, "key", newJString(key))
  add(path_580139, "pageId", newJString(pageId))
  add(path_580139, "blogId", newJString(blogId))
  add(query_580140, "prettyPrint", newJBool(prettyPrint))
  result = call_580138.call(path_580139, query_580140, nil, nil, nil)

var bloggerPagesRevert* = Call_BloggerPagesRevert_580125(
    name: "bloggerPagesRevert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/blogs/{blogId}/pages/{pageId}/revert",
    validator: validate_BloggerPagesRevert_580126, base: "/blogger/v3",
    url: url_BloggerPagesRevert_580127, schemes: {Scheme.Https})
type
  Call_BloggerPageViewsGet_580141 = ref object of OpenApiRestCall_579408
proc url_BloggerPageViewsGet_580143(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "blogId" in path, "`blogId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId"),
               (kind: ConstantSegment, value: "/pageviews")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerPageViewsGet_580142(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieve pageview stats for a Blog.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blogId: JString (required)
  ##         : The ID of the blog to get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blogId` field"
  var valid_580144 = path.getOrDefault("blogId")
  valid_580144 = validateParameter(valid_580144, JString, required = true,
                                 default = nil)
  if valid_580144 != nil:
    section.add "blogId", valid_580144
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   range: JArray
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580145 = query.getOrDefault("fields")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "fields", valid_580145
  var valid_580146 = query.getOrDefault("quotaUser")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "quotaUser", valid_580146
  var valid_580147 = query.getOrDefault("alt")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = newJString("json"))
  if valid_580147 != nil:
    section.add "alt", valid_580147
  var valid_580148 = query.getOrDefault("range")
  valid_580148 = validateParameter(valid_580148, JArray, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "range", valid_580148
  var valid_580149 = query.getOrDefault("oauth_token")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "oauth_token", valid_580149
  var valid_580150 = query.getOrDefault("userIp")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "userIp", valid_580150
  var valid_580151 = query.getOrDefault("key")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "key", valid_580151
  var valid_580152 = query.getOrDefault("prettyPrint")
  valid_580152 = validateParameter(valid_580152, JBool, required = false,
                                 default = newJBool(true))
  if valid_580152 != nil:
    section.add "prettyPrint", valid_580152
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580153: Call_BloggerPageViewsGet_580141; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve pageview stats for a Blog.
  ## 
  let valid = call_580153.validator(path, query, header, formData, body)
  let scheme = call_580153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580153.url(scheme.get, call_580153.host, call_580153.base,
                         call_580153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580153, url, valid)

proc call*(call_580154: Call_BloggerPageViewsGet_580141; blogId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          range: JsonNode = nil; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## bloggerPageViewsGet
  ## Retrieve pageview stats for a Blog.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   range: JArray
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   blogId: string (required)
  ##         : The ID of the blog to get.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580155 = newJObject()
  var query_580156 = newJObject()
  add(query_580156, "fields", newJString(fields))
  add(query_580156, "quotaUser", newJString(quotaUser))
  add(query_580156, "alt", newJString(alt))
  if range != nil:
    query_580156.add "range", range
  add(query_580156, "oauth_token", newJString(oauthToken))
  add(query_580156, "userIp", newJString(userIp))
  add(query_580156, "key", newJString(key))
  add(path_580155, "blogId", newJString(blogId))
  add(query_580156, "prettyPrint", newJBool(prettyPrint))
  result = call_580154.call(path_580155, query_580156, nil, nil, nil)

var bloggerPageViewsGet* = Call_BloggerPageViewsGet_580141(
    name: "bloggerPageViewsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/blogs/{blogId}/pageviews",
    validator: validate_BloggerPageViewsGet_580142, base: "/blogger/v3",
    url: url_BloggerPageViewsGet_580143, schemes: {Scheme.Https})
type
  Call_BloggerPostsInsert_580182 = ref object of OpenApiRestCall_579408
proc url_BloggerPostsInsert_580184(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "blogId" in path, "`blogId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId"),
               (kind: ConstantSegment, value: "/posts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerPostsInsert_580183(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Add a post.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blogId: JString (required)
  ##         : ID of the blog to add the post to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blogId` field"
  var valid_580185 = path.getOrDefault("blogId")
  valid_580185 = validateParameter(valid_580185, JString, required = true,
                                 default = nil)
  if valid_580185 != nil:
    section.add "blogId", valid_580185
  result.add "path", section
  ## parameters in `query` object:
  ##   fetchBody: JBool
  ##            : Whether the body content of the post is included with the result (default: true).
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fetchImages: JBool
  ##              : Whether image URL metadata for each post is included in the returned result (default: false).
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   isDraft: JBool
  ##          : Whether to create the post as a draft (default: false).
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580186 = query.getOrDefault("fetchBody")
  valid_580186 = validateParameter(valid_580186, JBool, required = false,
                                 default = newJBool(true))
  if valid_580186 != nil:
    section.add "fetchBody", valid_580186
  var valid_580187 = query.getOrDefault("fields")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "fields", valid_580187
  var valid_580188 = query.getOrDefault("quotaUser")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "quotaUser", valid_580188
  var valid_580189 = query.getOrDefault("fetchImages")
  valid_580189 = validateParameter(valid_580189, JBool, required = false, default = nil)
  if valid_580189 != nil:
    section.add "fetchImages", valid_580189
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
  var valid_580192 = query.getOrDefault("isDraft")
  valid_580192 = validateParameter(valid_580192, JBool, required = false, default = nil)
  if valid_580192 != nil:
    section.add "isDraft", valid_580192
  var valid_580193 = query.getOrDefault("userIp")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = nil)
  if valid_580193 != nil:
    section.add "userIp", valid_580193
  var valid_580194 = query.getOrDefault("key")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "key", valid_580194
  var valid_580195 = query.getOrDefault("prettyPrint")
  valid_580195 = validateParameter(valid_580195, JBool, required = false,
                                 default = newJBool(true))
  if valid_580195 != nil:
    section.add "prettyPrint", valid_580195
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

proc call*(call_580197: Call_BloggerPostsInsert_580182; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a post.
  ## 
  let valid = call_580197.validator(path, query, header, formData, body)
  let scheme = call_580197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580197.url(scheme.get, call_580197.host, call_580197.base,
                         call_580197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580197, url, valid)

proc call*(call_580198: Call_BloggerPostsInsert_580182; blogId: string;
          fetchBody: bool = true; fields: string = ""; quotaUser: string = "";
          fetchImages: bool = false; alt: string = "json"; oauthToken: string = "";
          isDraft: bool = false; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## bloggerPostsInsert
  ## Add a post.
  ##   fetchBody: bool
  ##            : Whether the body content of the post is included with the result (default: true).
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fetchImages: bool
  ##              : Whether image URL metadata for each post is included in the returned result (default: false).
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   isDraft: bool
  ##          : Whether to create the post as a draft (default: false).
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   blogId: string (required)
  ##         : ID of the blog to add the post to.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580199 = newJObject()
  var query_580200 = newJObject()
  var body_580201 = newJObject()
  add(query_580200, "fetchBody", newJBool(fetchBody))
  add(query_580200, "fields", newJString(fields))
  add(query_580200, "quotaUser", newJString(quotaUser))
  add(query_580200, "fetchImages", newJBool(fetchImages))
  add(query_580200, "alt", newJString(alt))
  add(query_580200, "oauth_token", newJString(oauthToken))
  add(query_580200, "isDraft", newJBool(isDraft))
  add(query_580200, "userIp", newJString(userIp))
  add(query_580200, "key", newJString(key))
  add(path_580199, "blogId", newJString(blogId))
  if body != nil:
    body_580201 = body
  add(query_580200, "prettyPrint", newJBool(prettyPrint))
  result = call_580198.call(path_580199, query_580200, nil, nil, body_580201)

var bloggerPostsInsert* = Call_BloggerPostsInsert_580182(
    name: "bloggerPostsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/blogs/{blogId}/posts",
    validator: validate_BloggerPostsInsert_580183, base: "/blogger/v3",
    url: url_BloggerPostsInsert_580184, schemes: {Scheme.Https})
type
  Call_BloggerPostsList_580157 = ref object of OpenApiRestCall_579408
proc url_BloggerPostsList_580159(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "blogId" in path, "`blogId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId"),
               (kind: ConstantSegment, value: "/posts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerPostsList_580158(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Retrieves a list of posts, possibly filtered.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blogId: JString (required)
  ##         : ID of the blog to fetch posts from.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blogId` field"
  var valid_580160 = path.getOrDefault("blogId")
  valid_580160 = validateParameter(valid_580160, JString, required = true,
                                 default = nil)
  if valid_580160 != nil:
    section.add "blogId", valid_580160
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Continuation token if the request is paged.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   view: JString
  ##       : Access level with which to view the returned result. Note that some fields require escalated access.
  ##   fetchImages: JBool
  ##              : Whether image URL metadata for each post is included.
  ##   alt: JString
  ##      : Data format for the response.
  ##   endDate: JString
  ##          : Latest post date to fetch, a date-time with RFC 3339 formatting.
  ##   startDate: JString
  ##            : Earliest post date to fetch, a date-time with RFC 3339 formatting.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of posts to fetch.
  ##   orderBy: JString
  ##          : Sort search results
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   labels: JString
  ##         : Comma-separated list of labels to search for.
  ##   status: JArray
  ##         : Statuses to include in the results.
  ##   fetchBodies: JBool
  ##              : Whether the body content of posts is included (default: true). This should be set to false when the post bodies are not required, to help minimize traffic.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580161 = query.getOrDefault("fields")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "fields", valid_580161
  var valid_580162 = query.getOrDefault("pageToken")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = nil)
  if valid_580162 != nil:
    section.add "pageToken", valid_580162
  var valid_580163 = query.getOrDefault("quotaUser")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = nil)
  if valid_580163 != nil:
    section.add "quotaUser", valid_580163
  var valid_580164 = query.getOrDefault("view")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = newJString("ADMIN"))
  if valid_580164 != nil:
    section.add "view", valid_580164
  var valid_580165 = query.getOrDefault("fetchImages")
  valid_580165 = validateParameter(valid_580165, JBool, required = false, default = nil)
  if valid_580165 != nil:
    section.add "fetchImages", valid_580165
  var valid_580166 = query.getOrDefault("alt")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = newJString("json"))
  if valid_580166 != nil:
    section.add "alt", valid_580166
  var valid_580167 = query.getOrDefault("endDate")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "endDate", valid_580167
  var valid_580168 = query.getOrDefault("startDate")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "startDate", valid_580168
  var valid_580169 = query.getOrDefault("oauth_token")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "oauth_token", valid_580169
  var valid_580170 = query.getOrDefault("userIp")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "userIp", valid_580170
  var valid_580171 = query.getOrDefault("maxResults")
  valid_580171 = validateParameter(valid_580171, JInt, required = false, default = nil)
  if valid_580171 != nil:
    section.add "maxResults", valid_580171
  var valid_580172 = query.getOrDefault("orderBy")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = newJString("published"))
  if valid_580172 != nil:
    section.add "orderBy", valid_580172
  var valid_580173 = query.getOrDefault("key")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "key", valid_580173
  var valid_580174 = query.getOrDefault("labels")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "labels", valid_580174
  var valid_580175 = query.getOrDefault("status")
  valid_580175 = validateParameter(valid_580175, JArray, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "status", valid_580175
  var valid_580176 = query.getOrDefault("fetchBodies")
  valid_580176 = validateParameter(valid_580176, JBool, required = false,
                                 default = newJBool(true))
  if valid_580176 != nil:
    section.add "fetchBodies", valid_580176
  var valid_580177 = query.getOrDefault("prettyPrint")
  valid_580177 = validateParameter(valid_580177, JBool, required = false,
                                 default = newJBool(true))
  if valid_580177 != nil:
    section.add "prettyPrint", valid_580177
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580178: Call_BloggerPostsList_580157; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of posts, possibly filtered.
  ## 
  let valid = call_580178.validator(path, query, header, formData, body)
  let scheme = call_580178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580178.url(scheme.get, call_580178.host, call_580178.base,
                         call_580178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580178, url, valid)

proc call*(call_580179: Call_BloggerPostsList_580157; blogId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          view: string = "ADMIN"; fetchImages: bool = false; alt: string = "json";
          endDate: string = ""; startDate: string = ""; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; orderBy: string = "published";
          key: string = ""; labels: string = ""; status: JsonNode = nil;
          fetchBodies: bool = true; prettyPrint: bool = true): Recallable =
  ## bloggerPostsList
  ## Retrieves a list of posts, possibly filtered.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Continuation token if the request is paged.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   view: string
  ##       : Access level with which to view the returned result. Note that some fields require escalated access.
  ##   fetchImages: bool
  ##              : Whether image URL metadata for each post is included.
  ##   alt: string
  ##      : Data format for the response.
  ##   endDate: string
  ##          : Latest post date to fetch, a date-time with RFC 3339 formatting.
  ##   startDate: string
  ##            : Earliest post date to fetch, a date-time with RFC 3339 formatting.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of posts to fetch.
  ##   orderBy: string
  ##          : Sort search results
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   labels: string
  ##         : Comma-separated list of labels to search for.
  ##   status: JArray
  ##         : Statuses to include in the results.
  ##   fetchBodies: bool
  ##              : Whether the body content of posts is included (default: true). This should be set to false when the post bodies are not required, to help minimize traffic.
  ##   blogId: string (required)
  ##         : ID of the blog to fetch posts from.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580180 = newJObject()
  var query_580181 = newJObject()
  add(query_580181, "fields", newJString(fields))
  add(query_580181, "pageToken", newJString(pageToken))
  add(query_580181, "quotaUser", newJString(quotaUser))
  add(query_580181, "view", newJString(view))
  add(query_580181, "fetchImages", newJBool(fetchImages))
  add(query_580181, "alt", newJString(alt))
  add(query_580181, "endDate", newJString(endDate))
  add(query_580181, "startDate", newJString(startDate))
  add(query_580181, "oauth_token", newJString(oauthToken))
  add(query_580181, "userIp", newJString(userIp))
  add(query_580181, "maxResults", newJInt(maxResults))
  add(query_580181, "orderBy", newJString(orderBy))
  add(query_580181, "key", newJString(key))
  add(query_580181, "labels", newJString(labels))
  if status != nil:
    query_580181.add "status", status
  add(query_580181, "fetchBodies", newJBool(fetchBodies))
  add(path_580180, "blogId", newJString(blogId))
  add(query_580181, "prettyPrint", newJBool(prettyPrint))
  result = call_580179.call(path_580180, query_580181, nil, nil, nil)

var bloggerPostsList* = Call_BloggerPostsList_580157(name: "bloggerPostsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/blogs/{blogId}/posts", validator: validate_BloggerPostsList_580158,
    base: "/blogger/v3", url: url_BloggerPostsList_580159, schemes: {Scheme.Https})
type
  Call_BloggerPostsGetByPath_580202 = ref object of OpenApiRestCall_579408
proc url_BloggerPostsGetByPath_580204(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "blogId" in path, "`blogId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId"),
               (kind: ConstantSegment, value: "/posts/bypath")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerPostsGetByPath_580203(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve a Post by Path.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blogId: JString (required)
  ##         : ID of the blog to fetch the post from.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blogId` field"
  var valid_580205 = path.getOrDefault("blogId")
  valid_580205 = validateParameter(valid_580205, JString, required = true,
                                 default = nil)
  if valid_580205 != nil:
    section.add "blogId", valid_580205
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: JString
  ##       : Access level with which to view the returned result. Note that some fields require elevated access.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxComments: JInt
  ##              : Maximum number of comments to pull back on a post.
  ##   path: JString (required)
  ##       : Path of the Post to retrieve.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580206 = query.getOrDefault("fields")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "fields", valid_580206
  var valid_580207 = query.getOrDefault("view")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = newJString("ADMIN"))
  if valid_580207 != nil:
    section.add "view", valid_580207
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
  var valid_580212 = query.getOrDefault("maxComments")
  valid_580212 = validateParameter(valid_580212, JInt, required = false, default = nil)
  if valid_580212 != nil:
    section.add "maxComments", valid_580212
  assert query != nil, "query argument is necessary due to required `path` field"
  var valid_580213 = query.getOrDefault("path")
  valid_580213 = validateParameter(valid_580213, JString, required = true,
                                 default = nil)
  if valid_580213 != nil:
    section.add "path", valid_580213
  var valid_580214 = query.getOrDefault("key")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "key", valid_580214
  var valid_580215 = query.getOrDefault("prettyPrint")
  valid_580215 = validateParameter(valid_580215, JBool, required = false,
                                 default = newJBool(true))
  if valid_580215 != nil:
    section.add "prettyPrint", valid_580215
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580216: Call_BloggerPostsGetByPath_580202; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a Post by Path.
  ## 
  let valid = call_580216.validator(path, query, header, formData, body)
  let scheme = call_580216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580216.url(scheme.get, call_580216.host, call_580216.base,
                         call_580216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580216, url, valid)

proc call*(call_580217: Call_BloggerPostsGetByPath_580202; path: string;
          blogId: string; fields: string = ""; view: string = "ADMIN";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxComments: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## bloggerPostsGetByPath
  ## Retrieve a Post by Path.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: string
  ##       : Access level with which to view the returned result. Note that some fields require elevated access.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxComments: int
  ##              : Maximum number of comments to pull back on a post.
  ##   path: string (required)
  ##       : Path of the Post to retrieve.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   blogId: string (required)
  ##         : ID of the blog to fetch the post from.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580218 = newJObject()
  var query_580219 = newJObject()
  add(query_580219, "fields", newJString(fields))
  add(query_580219, "view", newJString(view))
  add(query_580219, "quotaUser", newJString(quotaUser))
  add(query_580219, "alt", newJString(alt))
  add(query_580219, "oauth_token", newJString(oauthToken))
  add(query_580219, "userIp", newJString(userIp))
  add(query_580219, "maxComments", newJInt(maxComments))
  add(query_580219, "path", newJString(path))
  add(query_580219, "key", newJString(key))
  add(path_580218, "blogId", newJString(blogId))
  add(query_580219, "prettyPrint", newJBool(prettyPrint))
  result = call_580217.call(path_580218, query_580219, nil, nil, nil)

var bloggerPostsGetByPath* = Call_BloggerPostsGetByPath_580202(
    name: "bloggerPostsGetByPath", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/blogs/{blogId}/posts/bypath",
    validator: validate_BloggerPostsGetByPath_580203, base: "/blogger/v3",
    url: url_BloggerPostsGetByPath_580204, schemes: {Scheme.Https})
type
  Call_BloggerPostsSearch_580220 = ref object of OpenApiRestCall_579408
proc url_BloggerPostsSearch_580222(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "blogId" in path, "`blogId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId"),
               (kind: ConstantSegment, value: "/posts/search")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerPostsSearch_580221(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Search for a post.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blogId: JString (required)
  ##         : ID of the blog to fetch the post from.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blogId` field"
  var valid_580223 = path.getOrDefault("blogId")
  valid_580223 = validateParameter(valid_580223, JString, required = true,
                                 default = nil)
  if valid_580223 != nil:
    section.add "blogId", valid_580223
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
  ##   orderBy: JString
  ##          : Sort search results
  ##   q: JString (required)
  ##    : Query terms to search this blog for matching posts.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   fetchBodies: JBool
  ##              : Whether the body content of posts is included (default: true). This should be set to false when the post bodies are not required, to help minimize traffic.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580224 = query.getOrDefault("fields")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = nil)
  if valid_580224 != nil:
    section.add "fields", valid_580224
  var valid_580225 = query.getOrDefault("quotaUser")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = nil)
  if valid_580225 != nil:
    section.add "quotaUser", valid_580225
  var valid_580226 = query.getOrDefault("alt")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = newJString("json"))
  if valid_580226 != nil:
    section.add "alt", valid_580226
  var valid_580227 = query.getOrDefault("oauth_token")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = nil)
  if valid_580227 != nil:
    section.add "oauth_token", valid_580227
  var valid_580228 = query.getOrDefault("userIp")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = nil)
  if valid_580228 != nil:
    section.add "userIp", valid_580228
  var valid_580229 = query.getOrDefault("orderBy")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = newJString("published"))
  if valid_580229 != nil:
    section.add "orderBy", valid_580229
  assert query != nil, "query argument is necessary due to required `q` field"
  var valid_580230 = query.getOrDefault("q")
  valid_580230 = validateParameter(valid_580230, JString, required = true,
                                 default = nil)
  if valid_580230 != nil:
    section.add "q", valid_580230
  var valid_580231 = query.getOrDefault("key")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "key", valid_580231
  var valid_580232 = query.getOrDefault("fetchBodies")
  valid_580232 = validateParameter(valid_580232, JBool, required = false,
                                 default = newJBool(true))
  if valid_580232 != nil:
    section.add "fetchBodies", valid_580232
  var valid_580233 = query.getOrDefault("prettyPrint")
  valid_580233 = validateParameter(valid_580233, JBool, required = false,
                                 default = newJBool(true))
  if valid_580233 != nil:
    section.add "prettyPrint", valid_580233
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580234: Call_BloggerPostsSearch_580220; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Search for a post.
  ## 
  let valid = call_580234.validator(path, query, header, formData, body)
  let scheme = call_580234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580234.url(scheme.get, call_580234.host, call_580234.base,
                         call_580234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580234, url, valid)

proc call*(call_580235: Call_BloggerPostsSearch_580220; q: string; blogId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; orderBy: string = "published";
          key: string = ""; fetchBodies: bool = true; prettyPrint: bool = true): Recallable =
  ## bloggerPostsSearch
  ## Search for a post.
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
  ##   orderBy: string
  ##          : Sort search results
  ##   q: string (required)
  ##    : Query terms to search this blog for matching posts.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   fetchBodies: bool
  ##              : Whether the body content of posts is included (default: true). This should be set to false when the post bodies are not required, to help minimize traffic.
  ##   blogId: string (required)
  ##         : ID of the blog to fetch the post from.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580236 = newJObject()
  var query_580237 = newJObject()
  add(query_580237, "fields", newJString(fields))
  add(query_580237, "quotaUser", newJString(quotaUser))
  add(query_580237, "alt", newJString(alt))
  add(query_580237, "oauth_token", newJString(oauthToken))
  add(query_580237, "userIp", newJString(userIp))
  add(query_580237, "orderBy", newJString(orderBy))
  add(query_580237, "q", newJString(q))
  add(query_580237, "key", newJString(key))
  add(query_580237, "fetchBodies", newJBool(fetchBodies))
  add(path_580236, "blogId", newJString(blogId))
  add(query_580237, "prettyPrint", newJBool(prettyPrint))
  result = call_580235.call(path_580236, query_580237, nil, nil, nil)

var bloggerPostsSearch* = Call_BloggerPostsSearch_580220(
    name: "bloggerPostsSearch", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/blogs/{blogId}/posts/search",
    validator: validate_BloggerPostsSearch_580221, base: "/blogger/v3",
    url: url_BloggerPostsSearch_580222, schemes: {Scheme.Https})
type
  Call_BloggerPostsUpdate_580258 = ref object of OpenApiRestCall_579408
proc url_BloggerPostsUpdate_580260(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "blogId" in path, "`blogId` is a required path parameter"
  assert "postId" in path, "`postId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId"),
               (kind: ConstantSegment, value: "/posts/"),
               (kind: VariableSegment, value: "postId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerPostsUpdate_580259(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Update a post.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   postId: JString (required)
  ##         : The ID of the Post.
  ##   blogId: JString (required)
  ##         : The ID of the Blog.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `postId` field"
  var valid_580261 = path.getOrDefault("postId")
  valid_580261 = validateParameter(valid_580261, JString, required = true,
                                 default = nil)
  if valid_580261 != nil:
    section.add "postId", valid_580261
  var valid_580262 = path.getOrDefault("blogId")
  valid_580262 = validateParameter(valid_580262, JString, required = true,
                                 default = nil)
  if valid_580262 != nil:
    section.add "blogId", valid_580262
  result.add "path", section
  ## parameters in `query` object:
  ##   revert: JBool
  ##         : Whether a revert action should be performed when the post is updated (default: false).
  ##   fetchBody: JBool
  ##            : Whether the body content of the post is included with the result (default: true).
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fetchImages: JBool
  ##              : Whether image URL metadata for each post is included in the returned result (default: false).
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxComments: JInt
  ##              : Maximum number of comments to retrieve with the returned post.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   publish: JBool
  ##          : Whether a publish action should be performed when the post is updated (default: false).
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580263 = query.getOrDefault("revert")
  valid_580263 = validateParameter(valid_580263, JBool, required = false, default = nil)
  if valid_580263 != nil:
    section.add "revert", valid_580263
  var valid_580264 = query.getOrDefault("fetchBody")
  valid_580264 = validateParameter(valid_580264, JBool, required = false,
                                 default = newJBool(true))
  if valid_580264 != nil:
    section.add "fetchBody", valid_580264
  var valid_580265 = query.getOrDefault("fields")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = nil)
  if valid_580265 != nil:
    section.add "fields", valid_580265
  var valid_580266 = query.getOrDefault("quotaUser")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = nil)
  if valid_580266 != nil:
    section.add "quotaUser", valid_580266
  var valid_580267 = query.getOrDefault("fetchImages")
  valid_580267 = validateParameter(valid_580267, JBool, required = false, default = nil)
  if valid_580267 != nil:
    section.add "fetchImages", valid_580267
  var valid_580268 = query.getOrDefault("alt")
  valid_580268 = validateParameter(valid_580268, JString, required = false,
                                 default = newJString("json"))
  if valid_580268 != nil:
    section.add "alt", valid_580268
  var valid_580269 = query.getOrDefault("oauth_token")
  valid_580269 = validateParameter(valid_580269, JString, required = false,
                                 default = nil)
  if valid_580269 != nil:
    section.add "oauth_token", valid_580269
  var valid_580270 = query.getOrDefault("userIp")
  valid_580270 = validateParameter(valid_580270, JString, required = false,
                                 default = nil)
  if valid_580270 != nil:
    section.add "userIp", valid_580270
  var valid_580271 = query.getOrDefault("maxComments")
  valid_580271 = validateParameter(valid_580271, JInt, required = false, default = nil)
  if valid_580271 != nil:
    section.add "maxComments", valid_580271
  var valid_580272 = query.getOrDefault("key")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = nil)
  if valid_580272 != nil:
    section.add "key", valid_580272
  var valid_580273 = query.getOrDefault("publish")
  valid_580273 = validateParameter(valid_580273, JBool, required = false, default = nil)
  if valid_580273 != nil:
    section.add "publish", valid_580273
  var valid_580274 = query.getOrDefault("prettyPrint")
  valid_580274 = validateParameter(valid_580274, JBool, required = false,
                                 default = newJBool(true))
  if valid_580274 != nil:
    section.add "prettyPrint", valid_580274
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

proc call*(call_580276: Call_BloggerPostsUpdate_580258; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a post.
  ## 
  let valid = call_580276.validator(path, query, header, formData, body)
  let scheme = call_580276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580276.url(scheme.get, call_580276.host, call_580276.base,
                         call_580276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580276, url, valid)

proc call*(call_580277: Call_BloggerPostsUpdate_580258; postId: string;
          blogId: string; revert: bool = false; fetchBody: bool = true;
          fields: string = ""; quotaUser: string = ""; fetchImages: bool = false;
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxComments: int = 0; key: string = ""; publish: bool = false;
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## bloggerPostsUpdate
  ## Update a post.
  ##   revert: bool
  ##         : Whether a revert action should be performed when the post is updated (default: false).
  ##   fetchBody: bool
  ##            : Whether the body content of the post is included with the result (default: true).
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fetchImages: bool
  ##              : Whether image URL metadata for each post is included in the returned result (default: false).
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxComments: int
  ##              : Maximum number of comments to retrieve with the returned post.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   postId: string (required)
  ##         : The ID of the Post.
  ##   publish: bool
  ##          : Whether a publish action should be performed when the post is updated (default: false).
  ##   blogId: string (required)
  ##         : The ID of the Blog.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580278 = newJObject()
  var query_580279 = newJObject()
  var body_580280 = newJObject()
  add(query_580279, "revert", newJBool(revert))
  add(query_580279, "fetchBody", newJBool(fetchBody))
  add(query_580279, "fields", newJString(fields))
  add(query_580279, "quotaUser", newJString(quotaUser))
  add(query_580279, "fetchImages", newJBool(fetchImages))
  add(query_580279, "alt", newJString(alt))
  add(query_580279, "oauth_token", newJString(oauthToken))
  add(query_580279, "userIp", newJString(userIp))
  add(query_580279, "maxComments", newJInt(maxComments))
  add(query_580279, "key", newJString(key))
  add(path_580278, "postId", newJString(postId))
  add(query_580279, "publish", newJBool(publish))
  add(path_580278, "blogId", newJString(blogId))
  if body != nil:
    body_580280 = body
  add(query_580279, "prettyPrint", newJBool(prettyPrint))
  result = call_580277.call(path_580278, query_580279, nil, nil, body_580280)

var bloggerPostsUpdate* = Call_BloggerPostsUpdate_580258(
    name: "bloggerPostsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/blogs/{blogId}/posts/{postId}",
    validator: validate_BloggerPostsUpdate_580259, base: "/blogger/v3",
    url: url_BloggerPostsUpdate_580260, schemes: {Scheme.Https})
type
  Call_BloggerPostsGet_580238 = ref object of OpenApiRestCall_579408
proc url_BloggerPostsGet_580240(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "blogId" in path, "`blogId` is a required path parameter"
  assert "postId" in path, "`postId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId"),
               (kind: ConstantSegment, value: "/posts/"),
               (kind: VariableSegment, value: "postId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerPostsGet_580239(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get a post by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   postId: JString (required)
  ##         : The ID of the post
  ##   blogId: JString (required)
  ##         : ID of the blog to fetch the post from.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `postId` field"
  var valid_580241 = path.getOrDefault("postId")
  valid_580241 = validateParameter(valid_580241, JString, required = true,
                                 default = nil)
  if valid_580241 != nil:
    section.add "postId", valid_580241
  var valid_580242 = path.getOrDefault("blogId")
  valid_580242 = validateParameter(valid_580242, JString, required = true,
                                 default = nil)
  if valid_580242 != nil:
    section.add "blogId", valid_580242
  result.add "path", section
  ## parameters in `query` object:
  ##   fetchBody: JBool
  ##            : Whether the body content of the post is included (default: true). This should be set to false when the post bodies are not required, to help minimize traffic.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: JString
  ##       : Access level with which to view the returned result. Note that some fields require elevated access.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fetchImages: JBool
  ##              : Whether image URL metadata for each post is included (default: false).
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxComments: JInt
  ##              : Maximum number of comments to pull back on a post.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580243 = query.getOrDefault("fetchBody")
  valid_580243 = validateParameter(valid_580243, JBool, required = false,
                                 default = newJBool(true))
  if valid_580243 != nil:
    section.add "fetchBody", valid_580243
  var valid_580244 = query.getOrDefault("fields")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = nil)
  if valid_580244 != nil:
    section.add "fields", valid_580244
  var valid_580245 = query.getOrDefault("view")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = newJString("ADMIN"))
  if valid_580245 != nil:
    section.add "view", valid_580245
  var valid_580246 = query.getOrDefault("quotaUser")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "quotaUser", valid_580246
  var valid_580247 = query.getOrDefault("fetchImages")
  valid_580247 = validateParameter(valid_580247, JBool, required = false, default = nil)
  if valid_580247 != nil:
    section.add "fetchImages", valid_580247
  var valid_580248 = query.getOrDefault("alt")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = newJString("json"))
  if valid_580248 != nil:
    section.add "alt", valid_580248
  var valid_580249 = query.getOrDefault("oauth_token")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = nil)
  if valid_580249 != nil:
    section.add "oauth_token", valid_580249
  var valid_580250 = query.getOrDefault("userIp")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = nil)
  if valid_580250 != nil:
    section.add "userIp", valid_580250
  var valid_580251 = query.getOrDefault("maxComments")
  valid_580251 = validateParameter(valid_580251, JInt, required = false, default = nil)
  if valid_580251 != nil:
    section.add "maxComments", valid_580251
  var valid_580252 = query.getOrDefault("key")
  valid_580252 = validateParameter(valid_580252, JString, required = false,
                                 default = nil)
  if valid_580252 != nil:
    section.add "key", valid_580252
  var valid_580253 = query.getOrDefault("prettyPrint")
  valid_580253 = validateParameter(valid_580253, JBool, required = false,
                                 default = newJBool(true))
  if valid_580253 != nil:
    section.add "prettyPrint", valid_580253
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580254: Call_BloggerPostsGet_580238; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a post by ID.
  ## 
  let valid = call_580254.validator(path, query, header, formData, body)
  let scheme = call_580254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580254.url(scheme.get, call_580254.host, call_580254.base,
                         call_580254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580254, url, valid)

proc call*(call_580255: Call_BloggerPostsGet_580238; postId: string; blogId: string;
          fetchBody: bool = true; fields: string = ""; view: string = "ADMIN";
          quotaUser: string = ""; fetchImages: bool = false; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxComments: int = 0;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## bloggerPostsGet
  ## Get a post by ID.
  ##   fetchBody: bool
  ##            : Whether the body content of the post is included (default: true). This should be set to false when the post bodies are not required, to help minimize traffic.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: string
  ##       : Access level with which to view the returned result. Note that some fields require elevated access.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fetchImages: bool
  ##              : Whether image URL metadata for each post is included (default: false).
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxComments: int
  ##              : Maximum number of comments to pull back on a post.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   postId: string (required)
  ##         : The ID of the post
  ##   blogId: string (required)
  ##         : ID of the blog to fetch the post from.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580256 = newJObject()
  var query_580257 = newJObject()
  add(query_580257, "fetchBody", newJBool(fetchBody))
  add(query_580257, "fields", newJString(fields))
  add(query_580257, "view", newJString(view))
  add(query_580257, "quotaUser", newJString(quotaUser))
  add(query_580257, "fetchImages", newJBool(fetchImages))
  add(query_580257, "alt", newJString(alt))
  add(query_580257, "oauth_token", newJString(oauthToken))
  add(query_580257, "userIp", newJString(userIp))
  add(query_580257, "maxComments", newJInt(maxComments))
  add(query_580257, "key", newJString(key))
  add(path_580256, "postId", newJString(postId))
  add(path_580256, "blogId", newJString(blogId))
  add(query_580257, "prettyPrint", newJBool(prettyPrint))
  result = call_580255.call(path_580256, query_580257, nil, nil, nil)

var bloggerPostsGet* = Call_BloggerPostsGet_580238(name: "bloggerPostsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/blogs/{blogId}/posts/{postId}", validator: validate_BloggerPostsGet_580239,
    base: "/blogger/v3", url: url_BloggerPostsGet_580240, schemes: {Scheme.Https})
type
  Call_BloggerPostsPatch_580297 = ref object of OpenApiRestCall_579408
proc url_BloggerPostsPatch_580299(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "blogId" in path, "`blogId` is a required path parameter"
  assert "postId" in path, "`postId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId"),
               (kind: ConstantSegment, value: "/posts/"),
               (kind: VariableSegment, value: "postId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerPostsPatch_580298(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Update a post. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   postId: JString (required)
  ##         : The ID of the Post.
  ##   blogId: JString (required)
  ##         : The ID of the Blog.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `postId` field"
  var valid_580300 = path.getOrDefault("postId")
  valid_580300 = validateParameter(valid_580300, JString, required = true,
                                 default = nil)
  if valid_580300 != nil:
    section.add "postId", valid_580300
  var valid_580301 = path.getOrDefault("blogId")
  valid_580301 = validateParameter(valid_580301, JString, required = true,
                                 default = nil)
  if valid_580301 != nil:
    section.add "blogId", valid_580301
  result.add "path", section
  ## parameters in `query` object:
  ##   revert: JBool
  ##         : Whether a revert action should be performed when the post is updated (default: false).
  ##   fetchBody: JBool
  ##            : Whether the body content of the post is included with the result (default: true).
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fetchImages: JBool
  ##              : Whether image URL metadata for each post is included in the returned result (default: false).
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxComments: JInt
  ##              : Maximum number of comments to retrieve with the returned post.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   publish: JBool
  ##          : Whether a publish action should be performed when the post is updated (default: false).
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580302 = query.getOrDefault("revert")
  valid_580302 = validateParameter(valid_580302, JBool, required = false, default = nil)
  if valid_580302 != nil:
    section.add "revert", valid_580302
  var valid_580303 = query.getOrDefault("fetchBody")
  valid_580303 = validateParameter(valid_580303, JBool, required = false,
                                 default = newJBool(true))
  if valid_580303 != nil:
    section.add "fetchBody", valid_580303
  var valid_580304 = query.getOrDefault("fields")
  valid_580304 = validateParameter(valid_580304, JString, required = false,
                                 default = nil)
  if valid_580304 != nil:
    section.add "fields", valid_580304
  var valid_580305 = query.getOrDefault("quotaUser")
  valid_580305 = validateParameter(valid_580305, JString, required = false,
                                 default = nil)
  if valid_580305 != nil:
    section.add "quotaUser", valid_580305
  var valid_580306 = query.getOrDefault("fetchImages")
  valid_580306 = validateParameter(valid_580306, JBool, required = false, default = nil)
  if valid_580306 != nil:
    section.add "fetchImages", valid_580306
  var valid_580307 = query.getOrDefault("alt")
  valid_580307 = validateParameter(valid_580307, JString, required = false,
                                 default = newJString("json"))
  if valid_580307 != nil:
    section.add "alt", valid_580307
  var valid_580308 = query.getOrDefault("oauth_token")
  valid_580308 = validateParameter(valid_580308, JString, required = false,
                                 default = nil)
  if valid_580308 != nil:
    section.add "oauth_token", valid_580308
  var valid_580309 = query.getOrDefault("userIp")
  valid_580309 = validateParameter(valid_580309, JString, required = false,
                                 default = nil)
  if valid_580309 != nil:
    section.add "userIp", valid_580309
  var valid_580310 = query.getOrDefault("maxComments")
  valid_580310 = validateParameter(valid_580310, JInt, required = false, default = nil)
  if valid_580310 != nil:
    section.add "maxComments", valid_580310
  var valid_580311 = query.getOrDefault("key")
  valid_580311 = validateParameter(valid_580311, JString, required = false,
                                 default = nil)
  if valid_580311 != nil:
    section.add "key", valid_580311
  var valid_580312 = query.getOrDefault("publish")
  valid_580312 = validateParameter(valid_580312, JBool, required = false, default = nil)
  if valid_580312 != nil:
    section.add "publish", valid_580312
  var valid_580313 = query.getOrDefault("prettyPrint")
  valid_580313 = validateParameter(valid_580313, JBool, required = false,
                                 default = newJBool(true))
  if valid_580313 != nil:
    section.add "prettyPrint", valid_580313
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

proc call*(call_580315: Call_BloggerPostsPatch_580297; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a post. This method supports patch semantics.
  ## 
  let valid = call_580315.validator(path, query, header, formData, body)
  let scheme = call_580315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580315.url(scheme.get, call_580315.host, call_580315.base,
                         call_580315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580315, url, valid)

proc call*(call_580316: Call_BloggerPostsPatch_580297; postId: string;
          blogId: string; revert: bool = false; fetchBody: bool = true;
          fields: string = ""; quotaUser: string = ""; fetchImages: bool = false;
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxComments: int = 0; key: string = ""; publish: bool = false;
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## bloggerPostsPatch
  ## Update a post. This method supports patch semantics.
  ##   revert: bool
  ##         : Whether a revert action should be performed when the post is updated (default: false).
  ##   fetchBody: bool
  ##            : Whether the body content of the post is included with the result (default: true).
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fetchImages: bool
  ##              : Whether image URL metadata for each post is included in the returned result (default: false).
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxComments: int
  ##              : Maximum number of comments to retrieve with the returned post.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   postId: string (required)
  ##         : The ID of the Post.
  ##   publish: bool
  ##          : Whether a publish action should be performed when the post is updated (default: false).
  ##   blogId: string (required)
  ##         : The ID of the Blog.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580317 = newJObject()
  var query_580318 = newJObject()
  var body_580319 = newJObject()
  add(query_580318, "revert", newJBool(revert))
  add(query_580318, "fetchBody", newJBool(fetchBody))
  add(query_580318, "fields", newJString(fields))
  add(query_580318, "quotaUser", newJString(quotaUser))
  add(query_580318, "fetchImages", newJBool(fetchImages))
  add(query_580318, "alt", newJString(alt))
  add(query_580318, "oauth_token", newJString(oauthToken))
  add(query_580318, "userIp", newJString(userIp))
  add(query_580318, "maxComments", newJInt(maxComments))
  add(query_580318, "key", newJString(key))
  add(path_580317, "postId", newJString(postId))
  add(query_580318, "publish", newJBool(publish))
  add(path_580317, "blogId", newJString(blogId))
  if body != nil:
    body_580319 = body
  add(query_580318, "prettyPrint", newJBool(prettyPrint))
  result = call_580316.call(path_580317, query_580318, nil, nil, body_580319)

var bloggerPostsPatch* = Call_BloggerPostsPatch_580297(name: "bloggerPostsPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/blogs/{blogId}/posts/{postId}",
    validator: validate_BloggerPostsPatch_580298, base: "/blogger/v3",
    url: url_BloggerPostsPatch_580299, schemes: {Scheme.Https})
type
  Call_BloggerPostsDelete_580281 = ref object of OpenApiRestCall_579408
proc url_BloggerPostsDelete_580283(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "blogId" in path, "`blogId` is a required path parameter"
  assert "postId" in path, "`postId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId"),
               (kind: ConstantSegment, value: "/posts/"),
               (kind: VariableSegment, value: "postId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerPostsDelete_580282(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Delete a post by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   postId: JString (required)
  ##         : The ID of the Post.
  ##   blogId: JString (required)
  ##         : The ID of the Blog.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `postId` field"
  var valid_580284 = path.getOrDefault("postId")
  valid_580284 = validateParameter(valid_580284, JString, required = true,
                                 default = nil)
  if valid_580284 != nil:
    section.add "postId", valid_580284
  var valid_580285 = path.getOrDefault("blogId")
  valid_580285 = validateParameter(valid_580285, JString, required = true,
                                 default = nil)
  if valid_580285 != nil:
    section.add "blogId", valid_580285
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
  var valid_580286 = query.getOrDefault("fields")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = nil)
  if valid_580286 != nil:
    section.add "fields", valid_580286
  var valid_580287 = query.getOrDefault("quotaUser")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "quotaUser", valid_580287
  var valid_580288 = query.getOrDefault("alt")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = newJString("json"))
  if valid_580288 != nil:
    section.add "alt", valid_580288
  var valid_580289 = query.getOrDefault("oauth_token")
  valid_580289 = validateParameter(valid_580289, JString, required = false,
                                 default = nil)
  if valid_580289 != nil:
    section.add "oauth_token", valid_580289
  var valid_580290 = query.getOrDefault("userIp")
  valid_580290 = validateParameter(valid_580290, JString, required = false,
                                 default = nil)
  if valid_580290 != nil:
    section.add "userIp", valid_580290
  var valid_580291 = query.getOrDefault("key")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = nil)
  if valid_580291 != nil:
    section.add "key", valid_580291
  var valid_580292 = query.getOrDefault("prettyPrint")
  valid_580292 = validateParameter(valid_580292, JBool, required = false,
                                 default = newJBool(true))
  if valid_580292 != nil:
    section.add "prettyPrint", valid_580292
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580293: Call_BloggerPostsDelete_580281; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a post by ID.
  ## 
  let valid = call_580293.validator(path, query, header, formData, body)
  let scheme = call_580293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580293.url(scheme.get, call_580293.host, call_580293.base,
                         call_580293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580293, url, valid)

proc call*(call_580294: Call_BloggerPostsDelete_580281; postId: string;
          blogId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## bloggerPostsDelete
  ## Delete a post by ID.
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
  ##   postId: string (required)
  ##         : The ID of the Post.
  ##   blogId: string (required)
  ##         : The ID of the Blog.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580295 = newJObject()
  var query_580296 = newJObject()
  add(query_580296, "fields", newJString(fields))
  add(query_580296, "quotaUser", newJString(quotaUser))
  add(query_580296, "alt", newJString(alt))
  add(query_580296, "oauth_token", newJString(oauthToken))
  add(query_580296, "userIp", newJString(userIp))
  add(query_580296, "key", newJString(key))
  add(path_580295, "postId", newJString(postId))
  add(path_580295, "blogId", newJString(blogId))
  add(query_580296, "prettyPrint", newJBool(prettyPrint))
  result = call_580294.call(path_580295, query_580296, nil, nil, nil)

var bloggerPostsDelete* = Call_BloggerPostsDelete_580281(
    name: "bloggerPostsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/blogs/{blogId}/posts/{postId}",
    validator: validate_BloggerPostsDelete_580282, base: "/blogger/v3",
    url: url_BloggerPostsDelete_580283, schemes: {Scheme.Https})
type
  Call_BloggerCommentsList_580320 = ref object of OpenApiRestCall_579408
proc url_BloggerCommentsList_580322(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "blogId" in path, "`blogId` is a required path parameter"
  assert "postId" in path, "`postId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId"),
               (kind: ConstantSegment, value: "/posts/"),
               (kind: VariableSegment, value: "postId"),
               (kind: ConstantSegment, value: "/comments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerCommentsList_580321(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieves the comments for a post, possibly filtered.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   postId: JString (required)
  ##         : ID of the post to fetch posts from.
  ##   blogId: JString (required)
  ##         : ID of the blog to fetch comments from.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `postId` field"
  var valid_580323 = path.getOrDefault("postId")
  valid_580323 = validateParameter(valid_580323, JString, required = true,
                                 default = nil)
  if valid_580323 != nil:
    section.add "postId", valid_580323
  var valid_580324 = path.getOrDefault("blogId")
  valid_580324 = validateParameter(valid_580324, JString, required = true,
                                 default = nil)
  if valid_580324 != nil:
    section.add "blogId", valid_580324
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Continuation token if request is paged.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   view: JString
  ##       : Access level with which to view the returned result. Note that some fields require elevated access.
  ##   alt: JString
  ##      : Data format for the response.
  ##   endDate: JString
  ##          : Latest date of comment to fetch, a date-time with RFC 3339 formatting.
  ##   startDate: JString
  ##            : Earliest date of comment to fetch, a date-time with RFC 3339 formatting.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of comments to include in the result.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   status: JArray
  ##   fetchBodies: JBool
  ##              : Whether the body content of the comments is included.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580325 = query.getOrDefault("fields")
  valid_580325 = validateParameter(valid_580325, JString, required = false,
                                 default = nil)
  if valid_580325 != nil:
    section.add "fields", valid_580325
  var valid_580326 = query.getOrDefault("pageToken")
  valid_580326 = validateParameter(valid_580326, JString, required = false,
                                 default = nil)
  if valid_580326 != nil:
    section.add "pageToken", valid_580326
  var valid_580327 = query.getOrDefault("quotaUser")
  valid_580327 = validateParameter(valid_580327, JString, required = false,
                                 default = nil)
  if valid_580327 != nil:
    section.add "quotaUser", valid_580327
  var valid_580328 = query.getOrDefault("view")
  valid_580328 = validateParameter(valid_580328, JString, required = false,
                                 default = newJString("ADMIN"))
  if valid_580328 != nil:
    section.add "view", valid_580328
  var valid_580329 = query.getOrDefault("alt")
  valid_580329 = validateParameter(valid_580329, JString, required = false,
                                 default = newJString("json"))
  if valid_580329 != nil:
    section.add "alt", valid_580329
  var valid_580330 = query.getOrDefault("endDate")
  valid_580330 = validateParameter(valid_580330, JString, required = false,
                                 default = nil)
  if valid_580330 != nil:
    section.add "endDate", valid_580330
  var valid_580331 = query.getOrDefault("startDate")
  valid_580331 = validateParameter(valid_580331, JString, required = false,
                                 default = nil)
  if valid_580331 != nil:
    section.add "startDate", valid_580331
  var valid_580332 = query.getOrDefault("oauth_token")
  valid_580332 = validateParameter(valid_580332, JString, required = false,
                                 default = nil)
  if valid_580332 != nil:
    section.add "oauth_token", valid_580332
  var valid_580333 = query.getOrDefault("userIp")
  valid_580333 = validateParameter(valid_580333, JString, required = false,
                                 default = nil)
  if valid_580333 != nil:
    section.add "userIp", valid_580333
  var valid_580334 = query.getOrDefault("maxResults")
  valid_580334 = validateParameter(valid_580334, JInt, required = false, default = nil)
  if valid_580334 != nil:
    section.add "maxResults", valid_580334
  var valid_580335 = query.getOrDefault("key")
  valid_580335 = validateParameter(valid_580335, JString, required = false,
                                 default = nil)
  if valid_580335 != nil:
    section.add "key", valid_580335
  var valid_580336 = query.getOrDefault("status")
  valid_580336 = validateParameter(valid_580336, JArray, required = false,
                                 default = nil)
  if valid_580336 != nil:
    section.add "status", valid_580336
  var valid_580337 = query.getOrDefault("fetchBodies")
  valid_580337 = validateParameter(valid_580337, JBool, required = false, default = nil)
  if valid_580337 != nil:
    section.add "fetchBodies", valid_580337
  var valid_580338 = query.getOrDefault("prettyPrint")
  valid_580338 = validateParameter(valid_580338, JBool, required = false,
                                 default = newJBool(true))
  if valid_580338 != nil:
    section.add "prettyPrint", valid_580338
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580339: Call_BloggerCommentsList_580320; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the comments for a post, possibly filtered.
  ## 
  let valid = call_580339.validator(path, query, header, formData, body)
  let scheme = call_580339.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580339.url(scheme.get, call_580339.host, call_580339.base,
                         call_580339.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580339, url, valid)

proc call*(call_580340: Call_BloggerCommentsList_580320; postId: string;
          blogId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; view: string = "ADMIN"; alt: string = "json";
          endDate: string = ""; startDate: string = ""; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          status: JsonNode = nil; fetchBodies: bool = false; prettyPrint: bool = true): Recallable =
  ## bloggerCommentsList
  ## Retrieves the comments for a post, possibly filtered.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Continuation token if request is paged.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   view: string
  ##       : Access level with which to view the returned result. Note that some fields require elevated access.
  ##   alt: string
  ##      : Data format for the response.
  ##   endDate: string
  ##          : Latest date of comment to fetch, a date-time with RFC 3339 formatting.
  ##   startDate: string
  ##            : Earliest date of comment to fetch, a date-time with RFC 3339 formatting.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of comments to include in the result.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   postId: string (required)
  ##         : ID of the post to fetch posts from.
  ##   status: JArray
  ##   fetchBodies: bool
  ##              : Whether the body content of the comments is included.
  ##   blogId: string (required)
  ##         : ID of the blog to fetch comments from.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580341 = newJObject()
  var query_580342 = newJObject()
  add(query_580342, "fields", newJString(fields))
  add(query_580342, "pageToken", newJString(pageToken))
  add(query_580342, "quotaUser", newJString(quotaUser))
  add(query_580342, "view", newJString(view))
  add(query_580342, "alt", newJString(alt))
  add(query_580342, "endDate", newJString(endDate))
  add(query_580342, "startDate", newJString(startDate))
  add(query_580342, "oauth_token", newJString(oauthToken))
  add(query_580342, "userIp", newJString(userIp))
  add(query_580342, "maxResults", newJInt(maxResults))
  add(query_580342, "key", newJString(key))
  add(path_580341, "postId", newJString(postId))
  if status != nil:
    query_580342.add "status", status
  add(query_580342, "fetchBodies", newJBool(fetchBodies))
  add(path_580341, "blogId", newJString(blogId))
  add(query_580342, "prettyPrint", newJBool(prettyPrint))
  result = call_580340.call(path_580341, query_580342, nil, nil, nil)

var bloggerCommentsList* = Call_BloggerCommentsList_580320(
    name: "bloggerCommentsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/blogs/{blogId}/posts/{postId}/comments",
    validator: validate_BloggerCommentsList_580321, base: "/blogger/v3",
    url: url_BloggerCommentsList_580322, schemes: {Scheme.Https})
type
  Call_BloggerCommentsGet_580343 = ref object of OpenApiRestCall_579408
proc url_BloggerCommentsGet_580345(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "blogId" in path, "`blogId` is a required path parameter"
  assert "postId" in path, "`postId` is a required path parameter"
  assert "commentId" in path, "`commentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId"),
               (kind: ConstantSegment, value: "/posts/"),
               (kind: VariableSegment, value: "postId"),
               (kind: ConstantSegment, value: "/comments/"),
               (kind: VariableSegment, value: "commentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerCommentsGet_580344(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets one comment by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   commentId: JString (required)
  ##            : The ID of the comment to get.
  ##   postId: JString (required)
  ##         : ID of the post to fetch posts from.
  ##   blogId: JString (required)
  ##         : ID of the blog to containing the comment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `commentId` field"
  var valid_580346 = path.getOrDefault("commentId")
  valid_580346 = validateParameter(valid_580346, JString, required = true,
                                 default = nil)
  if valid_580346 != nil:
    section.add "commentId", valid_580346
  var valid_580347 = path.getOrDefault("postId")
  valid_580347 = validateParameter(valid_580347, JString, required = true,
                                 default = nil)
  if valid_580347 != nil:
    section.add "postId", valid_580347
  var valid_580348 = path.getOrDefault("blogId")
  valid_580348 = validateParameter(valid_580348, JString, required = true,
                                 default = nil)
  if valid_580348 != nil:
    section.add "blogId", valid_580348
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: JString
  ##       : Access level for the requested comment (default: READER). Note that some comments will require elevated permissions, for example comments where the parent posts which is in a draft state, or comments that are pending moderation.
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
  var valid_580349 = query.getOrDefault("fields")
  valid_580349 = validateParameter(valid_580349, JString, required = false,
                                 default = nil)
  if valid_580349 != nil:
    section.add "fields", valid_580349
  var valid_580350 = query.getOrDefault("view")
  valid_580350 = validateParameter(valid_580350, JString, required = false,
                                 default = newJString("ADMIN"))
  if valid_580350 != nil:
    section.add "view", valid_580350
  var valid_580351 = query.getOrDefault("quotaUser")
  valid_580351 = validateParameter(valid_580351, JString, required = false,
                                 default = nil)
  if valid_580351 != nil:
    section.add "quotaUser", valid_580351
  var valid_580352 = query.getOrDefault("alt")
  valid_580352 = validateParameter(valid_580352, JString, required = false,
                                 default = newJString("json"))
  if valid_580352 != nil:
    section.add "alt", valid_580352
  var valid_580353 = query.getOrDefault("oauth_token")
  valid_580353 = validateParameter(valid_580353, JString, required = false,
                                 default = nil)
  if valid_580353 != nil:
    section.add "oauth_token", valid_580353
  var valid_580354 = query.getOrDefault("userIp")
  valid_580354 = validateParameter(valid_580354, JString, required = false,
                                 default = nil)
  if valid_580354 != nil:
    section.add "userIp", valid_580354
  var valid_580355 = query.getOrDefault("key")
  valid_580355 = validateParameter(valid_580355, JString, required = false,
                                 default = nil)
  if valid_580355 != nil:
    section.add "key", valid_580355
  var valid_580356 = query.getOrDefault("prettyPrint")
  valid_580356 = validateParameter(valid_580356, JBool, required = false,
                                 default = newJBool(true))
  if valid_580356 != nil:
    section.add "prettyPrint", valid_580356
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580357: Call_BloggerCommentsGet_580343; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one comment by ID.
  ## 
  let valid = call_580357.validator(path, query, header, formData, body)
  let scheme = call_580357.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580357.url(scheme.get, call_580357.host, call_580357.base,
                         call_580357.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580357, url, valid)

proc call*(call_580358: Call_BloggerCommentsGet_580343; commentId: string;
          postId: string; blogId: string; fields: string = ""; view: string = "ADMIN";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## bloggerCommentsGet
  ## Gets one comment by ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: string
  ##       : Access level for the requested comment (default: READER). Note that some comments will require elevated permissions, for example comments where the parent posts which is in a draft state, or comments that are pending moderation.
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
  ##   postId: string (required)
  ##         : ID of the post to fetch posts from.
  ##   blogId: string (required)
  ##         : ID of the blog to containing the comment.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580359 = newJObject()
  var query_580360 = newJObject()
  add(query_580360, "fields", newJString(fields))
  add(query_580360, "view", newJString(view))
  add(query_580360, "quotaUser", newJString(quotaUser))
  add(query_580360, "alt", newJString(alt))
  add(query_580360, "oauth_token", newJString(oauthToken))
  add(query_580360, "userIp", newJString(userIp))
  add(query_580360, "key", newJString(key))
  add(path_580359, "commentId", newJString(commentId))
  add(path_580359, "postId", newJString(postId))
  add(path_580359, "blogId", newJString(blogId))
  add(query_580360, "prettyPrint", newJBool(prettyPrint))
  result = call_580358.call(path_580359, query_580360, nil, nil, nil)

var bloggerCommentsGet* = Call_BloggerCommentsGet_580343(
    name: "bloggerCommentsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/blogs/{blogId}/posts/{postId}/comments/{commentId}",
    validator: validate_BloggerCommentsGet_580344, base: "/blogger/v3",
    url: url_BloggerCommentsGet_580345, schemes: {Scheme.Https})
type
  Call_BloggerCommentsDelete_580361 = ref object of OpenApiRestCall_579408
proc url_BloggerCommentsDelete_580363(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "blogId" in path, "`blogId` is a required path parameter"
  assert "postId" in path, "`postId` is a required path parameter"
  assert "commentId" in path, "`commentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId"),
               (kind: ConstantSegment, value: "/posts/"),
               (kind: VariableSegment, value: "postId"),
               (kind: ConstantSegment, value: "/comments/"),
               (kind: VariableSegment, value: "commentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerCommentsDelete_580362(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a comment by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   commentId: JString (required)
  ##            : The ID of the comment to delete.
  ##   postId: JString (required)
  ##         : The ID of the Post.
  ##   blogId: JString (required)
  ##         : The ID of the Blog.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `commentId` field"
  var valid_580364 = path.getOrDefault("commentId")
  valid_580364 = validateParameter(valid_580364, JString, required = true,
                                 default = nil)
  if valid_580364 != nil:
    section.add "commentId", valid_580364
  var valid_580365 = path.getOrDefault("postId")
  valid_580365 = validateParameter(valid_580365, JString, required = true,
                                 default = nil)
  if valid_580365 != nil:
    section.add "postId", valid_580365
  var valid_580366 = path.getOrDefault("blogId")
  valid_580366 = validateParameter(valid_580366, JString, required = true,
                                 default = nil)
  if valid_580366 != nil:
    section.add "blogId", valid_580366
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
  var valid_580367 = query.getOrDefault("fields")
  valid_580367 = validateParameter(valid_580367, JString, required = false,
                                 default = nil)
  if valid_580367 != nil:
    section.add "fields", valid_580367
  var valid_580368 = query.getOrDefault("quotaUser")
  valid_580368 = validateParameter(valid_580368, JString, required = false,
                                 default = nil)
  if valid_580368 != nil:
    section.add "quotaUser", valid_580368
  var valid_580369 = query.getOrDefault("alt")
  valid_580369 = validateParameter(valid_580369, JString, required = false,
                                 default = newJString("json"))
  if valid_580369 != nil:
    section.add "alt", valid_580369
  var valid_580370 = query.getOrDefault("oauth_token")
  valid_580370 = validateParameter(valid_580370, JString, required = false,
                                 default = nil)
  if valid_580370 != nil:
    section.add "oauth_token", valid_580370
  var valid_580371 = query.getOrDefault("userIp")
  valid_580371 = validateParameter(valid_580371, JString, required = false,
                                 default = nil)
  if valid_580371 != nil:
    section.add "userIp", valid_580371
  var valid_580372 = query.getOrDefault("key")
  valid_580372 = validateParameter(valid_580372, JString, required = false,
                                 default = nil)
  if valid_580372 != nil:
    section.add "key", valid_580372
  var valid_580373 = query.getOrDefault("prettyPrint")
  valid_580373 = validateParameter(valid_580373, JBool, required = false,
                                 default = newJBool(true))
  if valid_580373 != nil:
    section.add "prettyPrint", valid_580373
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580374: Call_BloggerCommentsDelete_580361; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a comment by ID.
  ## 
  let valid = call_580374.validator(path, query, header, formData, body)
  let scheme = call_580374.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580374.url(scheme.get, call_580374.host, call_580374.base,
                         call_580374.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580374, url, valid)

proc call*(call_580375: Call_BloggerCommentsDelete_580361; commentId: string;
          postId: string; blogId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## bloggerCommentsDelete
  ## Delete a comment by ID.
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
  ##            : The ID of the comment to delete.
  ##   postId: string (required)
  ##         : The ID of the Post.
  ##   blogId: string (required)
  ##         : The ID of the Blog.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580376 = newJObject()
  var query_580377 = newJObject()
  add(query_580377, "fields", newJString(fields))
  add(query_580377, "quotaUser", newJString(quotaUser))
  add(query_580377, "alt", newJString(alt))
  add(query_580377, "oauth_token", newJString(oauthToken))
  add(query_580377, "userIp", newJString(userIp))
  add(query_580377, "key", newJString(key))
  add(path_580376, "commentId", newJString(commentId))
  add(path_580376, "postId", newJString(postId))
  add(path_580376, "blogId", newJString(blogId))
  add(query_580377, "prettyPrint", newJBool(prettyPrint))
  result = call_580375.call(path_580376, query_580377, nil, nil, nil)

var bloggerCommentsDelete* = Call_BloggerCommentsDelete_580361(
    name: "bloggerCommentsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/blogs/{blogId}/posts/{postId}/comments/{commentId}",
    validator: validate_BloggerCommentsDelete_580362, base: "/blogger/v3",
    url: url_BloggerCommentsDelete_580363, schemes: {Scheme.Https})
type
  Call_BloggerCommentsApprove_580378 = ref object of OpenApiRestCall_579408
proc url_BloggerCommentsApprove_580380(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "blogId" in path, "`blogId` is a required path parameter"
  assert "postId" in path, "`postId` is a required path parameter"
  assert "commentId" in path, "`commentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId"),
               (kind: ConstantSegment, value: "/posts/"),
               (kind: VariableSegment, value: "postId"),
               (kind: ConstantSegment, value: "/comments/"),
               (kind: VariableSegment, value: "commentId"),
               (kind: ConstantSegment, value: "/approve")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerCommentsApprove_580379(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Marks a comment as not spam.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   commentId: JString (required)
  ##            : The ID of the comment to mark as not spam.
  ##   postId: JString (required)
  ##         : The ID of the Post.
  ##   blogId: JString (required)
  ##         : The ID of the Blog.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `commentId` field"
  var valid_580381 = path.getOrDefault("commentId")
  valid_580381 = validateParameter(valid_580381, JString, required = true,
                                 default = nil)
  if valid_580381 != nil:
    section.add "commentId", valid_580381
  var valid_580382 = path.getOrDefault("postId")
  valid_580382 = validateParameter(valid_580382, JString, required = true,
                                 default = nil)
  if valid_580382 != nil:
    section.add "postId", valid_580382
  var valid_580383 = path.getOrDefault("blogId")
  valid_580383 = validateParameter(valid_580383, JString, required = true,
                                 default = nil)
  if valid_580383 != nil:
    section.add "blogId", valid_580383
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
  var valid_580384 = query.getOrDefault("fields")
  valid_580384 = validateParameter(valid_580384, JString, required = false,
                                 default = nil)
  if valid_580384 != nil:
    section.add "fields", valid_580384
  var valid_580385 = query.getOrDefault("quotaUser")
  valid_580385 = validateParameter(valid_580385, JString, required = false,
                                 default = nil)
  if valid_580385 != nil:
    section.add "quotaUser", valid_580385
  var valid_580386 = query.getOrDefault("alt")
  valid_580386 = validateParameter(valid_580386, JString, required = false,
                                 default = newJString("json"))
  if valid_580386 != nil:
    section.add "alt", valid_580386
  var valid_580387 = query.getOrDefault("oauth_token")
  valid_580387 = validateParameter(valid_580387, JString, required = false,
                                 default = nil)
  if valid_580387 != nil:
    section.add "oauth_token", valid_580387
  var valid_580388 = query.getOrDefault("userIp")
  valid_580388 = validateParameter(valid_580388, JString, required = false,
                                 default = nil)
  if valid_580388 != nil:
    section.add "userIp", valid_580388
  var valid_580389 = query.getOrDefault("key")
  valid_580389 = validateParameter(valid_580389, JString, required = false,
                                 default = nil)
  if valid_580389 != nil:
    section.add "key", valid_580389
  var valid_580390 = query.getOrDefault("prettyPrint")
  valid_580390 = validateParameter(valid_580390, JBool, required = false,
                                 default = newJBool(true))
  if valid_580390 != nil:
    section.add "prettyPrint", valid_580390
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580391: Call_BloggerCommentsApprove_580378; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Marks a comment as not spam.
  ## 
  let valid = call_580391.validator(path, query, header, formData, body)
  let scheme = call_580391.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580391.url(scheme.get, call_580391.host, call_580391.base,
                         call_580391.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580391, url, valid)

proc call*(call_580392: Call_BloggerCommentsApprove_580378; commentId: string;
          postId: string; blogId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## bloggerCommentsApprove
  ## Marks a comment as not spam.
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
  ##            : The ID of the comment to mark as not spam.
  ##   postId: string (required)
  ##         : The ID of the Post.
  ##   blogId: string (required)
  ##         : The ID of the Blog.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580393 = newJObject()
  var query_580394 = newJObject()
  add(query_580394, "fields", newJString(fields))
  add(query_580394, "quotaUser", newJString(quotaUser))
  add(query_580394, "alt", newJString(alt))
  add(query_580394, "oauth_token", newJString(oauthToken))
  add(query_580394, "userIp", newJString(userIp))
  add(query_580394, "key", newJString(key))
  add(path_580393, "commentId", newJString(commentId))
  add(path_580393, "postId", newJString(postId))
  add(path_580393, "blogId", newJString(blogId))
  add(query_580394, "prettyPrint", newJBool(prettyPrint))
  result = call_580392.call(path_580393, query_580394, nil, nil, nil)

var bloggerCommentsApprove* = Call_BloggerCommentsApprove_580378(
    name: "bloggerCommentsApprove", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/blogs/{blogId}/posts/{postId}/comments/{commentId}/approve",
    validator: validate_BloggerCommentsApprove_580379, base: "/blogger/v3",
    url: url_BloggerCommentsApprove_580380, schemes: {Scheme.Https})
type
  Call_BloggerCommentsRemoveContent_580395 = ref object of OpenApiRestCall_579408
proc url_BloggerCommentsRemoveContent_580397(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "blogId" in path, "`blogId` is a required path parameter"
  assert "postId" in path, "`postId` is a required path parameter"
  assert "commentId" in path, "`commentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId"),
               (kind: ConstantSegment, value: "/posts/"),
               (kind: VariableSegment, value: "postId"),
               (kind: ConstantSegment, value: "/comments/"),
               (kind: VariableSegment, value: "commentId"),
               (kind: ConstantSegment, value: "/removecontent")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerCommentsRemoveContent_580396(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes the content of a comment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   commentId: JString (required)
  ##            : The ID of the comment to delete content from.
  ##   postId: JString (required)
  ##         : The ID of the Post.
  ##   blogId: JString (required)
  ##         : The ID of the Blog.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `commentId` field"
  var valid_580398 = path.getOrDefault("commentId")
  valid_580398 = validateParameter(valid_580398, JString, required = true,
                                 default = nil)
  if valid_580398 != nil:
    section.add "commentId", valid_580398
  var valid_580399 = path.getOrDefault("postId")
  valid_580399 = validateParameter(valid_580399, JString, required = true,
                                 default = nil)
  if valid_580399 != nil:
    section.add "postId", valid_580399
  var valid_580400 = path.getOrDefault("blogId")
  valid_580400 = validateParameter(valid_580400, JString, required = true,
                                 default = nil)
  if valid_580400 != nil:
    section.add "blogId", valid_580400
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
  var valid_580401 = query.getOrDefault("fields")
  valid_580401 = validateParameter(valid_580401, JString, required = false,
                                 default = nil)
  if valid_580401 != nil:
    section.add "fields", valid_580401
  var valid_580402 = query.getOrDefault("quotaUser")
  valid_580402 = validateParameter(valid_580402, JString, required = false,
                                 default = nil)
  if valid_580402 != nil:
    section.add "quotaUser", valid_580402
  var valid_580403 = query.getOrDefault("alt")
  valid_580403 = validateParameter(valid_580403, JString, required = false,
                                 default = newJString("json"))
  if valid_580403 != nil:
    section.add "alt", valid_580403
  var valid_580404 = query.getOrDefault("oauth_token")
  valid_580404 = validateParameter(valid_580404, JString, required = false,
                                 default = nil)
  if valid_580404 != nil:
    section.add "oauth_token", valid_580404
  var valid_580405 = query.getOrDefault("userIp")
  valid_580405 = validateParameter(valid_580405, JString, required = false,
                                 default = nil)
  if valid_580405 != nil:
    section.add "userIp", valid_580405
  var valid_580406 = query.getOrDefault("key")
  valid_580406 = validateParameter(valid_580406, JString, required = false,
                                 default = nil)
  if valid_580406 != nil:
    section.add "key", valid_580406
  var valid_580407 = query.getOrDefault("prettyPrint")
  valid_580407 = validateParameter(valid_580407, JBool, required = false,
                                 default = newJBool(true))
  if valid_580407 != nil:
    section.add "prettyPrint", valid_580407
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580408: Call_BloggerCommentsRemoveContent_580395; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes the content of a comment.
  ## 
  let valid = call_580408.validator(path, query, header, formData, body)
  let scheme = call_580408.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580408.url(scheme.get, call_580408.host, call_580408.base,
                         call_580408.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580408, url, valid)

proc call*(call_580409: Call_BloggerCommentsRemoveContent_580395;
          commentId: string; postId: string; blogId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## bloggerCommentsRemoveContent
  ## Removes the content of a comment.
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
  ##            : The ID of the comment to delete content from.
  ##   postId: string (required)
  ##         : The ID of the Post.
  ##   blogId: string (required)
  ##         : The ID of the Blog.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580410 = newJObject()
  var query_580411 = newJObject()
  add(query_580411, "fields", newJString(fields))
  add(query_580411, "quotaUser", newJString(quotaUser))
  add(query_580411, "alt", newJString(alt))
  add(query_580411, "oauth_token", newJString(oauthToken))
  add(query_580411, "userIp", newJString(userIp))
  add(query_580411, "key", newJString(key))
  add(path_580410, "commentId", newJString(commentId))
  add(path_580410, "postId", newJString(postId))
  add(path_580410, "blogId", newJString(blogId))
  add(query_580411, "prettyPrint", newJBool(prettyPrint))
  result = call_580409.call(path_580410, query_580411, nil, nil, nil)

var bloggerCommentsRemoveContent* = Call_BloggerCommentsRemoveContent_580395(
    name: "bloggerCommentsRemoveContent", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/blogs/{blogId}/posts/{postId}/comments/{commentId}/removecontent",
    validator: validate_BloggerCommentsRemoveContent_580396, base: "/blogger/v3",
    url: url_BloggerCommentsRemoveContent_580397, schemes: {Scheme.Https})
type
  Call_BloggerCommentsMarkAsSpam_580412 = ref object of OpenApiRestCall_579408
proc url_BloggerCommentsMarkAsSpam_580414(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "blogId" in path, "`blogId` is a required path parameter"
  assert "postId" in path, "`postId` is a required path parameter"
  assert "commentId" in path, "`commentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId"),
               (kind: ConstantSegment, value: "/posts/"),
               (kind: VariableSegment, value: "postId"),
               (kind: ConstantSegment, value: "/comments/"),
               (kind: VariableSegment, value: "commentId"),
               (kind: ConstantSegment, value: "/spam")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerCommentsMarkAsSpam_580413(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Marks a comment as spam.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   commentId: JString (required)
  ##            : The ID of the comment to mark as spam.
  ##   postId: JString (required)
  ##         : The ID of the Post.
  ##   blogId: JString (required)
  ##         : The ID of the Blog.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `commentId` field"
  var valid_580415 = path.getOrDefault("commentId")
  valid_580415 = validateParameter(valid_580415, JString, required = true,
                                 default = nil)
  if valid_580415 != nil:
    section.add "commentId", valid_580415
  var valid_580416 = path.getOrDefault("postId")
  valid_580416 = validateParameter(valid_580416, JString, required = true,
                                 default = nil)
  if valid_580416 != nil:
    section.add "postId", valid_580416
  var valid_580417 = path.getOrDefault("blogId")
  valid_580417 = validateParameter(valid_580417, JString, required = true,
                                 default = nil)
  if valid_580417 != nil:
    section.add "blogId", valid_580417
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
  var valid_580418 = query.getOrDefault("fields")
  valid_580418 = validateParameter(valid_580418, JString, required = false,
                                 default = nil)
  if valid_580418 != nil:
    section.add "fields", valid_580418
  var valid_580419 = query.getOrDefault("quotaUser")
  valid_580419 = validateParameter(valid_580419, JString, required = false,
                                 default = nil)
  if valid_580419 != nil:
    section.add "quotaUser", valid_580419
  var valid_580420 = query.getOrDefault("alt")
  valid_580420 = validateParameter(valid_580420, JString, required = false,
                                 default = newJString("json"))
  if valid_580420 != nil:
    section.add "alt", valid_580420
  var valid_580421 = query.getOrDefault("oauth_token")
  valid_580421 = validateParameter(valid_580421, JString, required = false,
                                 default = nil)
  if valid_580421 != nil:
    section.add "oauth_token", valid_580421
  var valid_580422 = query.getOrDefault("userIp")
  valid_580422 = validateParameter(valid_580422, JString, required = false,
                                 default = nil)
  if valid_580422 != nil:
    section.add "userIp", valid_580422
  var valid_580423 = query.getOrDefault("key")
  valid_580423 = validateParameter(valid_580423, JString, required = false,
                                 default = nil)
  if valid_580423 != nil:
    section.add "key", valid_580423
  var valid_580424 = query.getOrDefault("prettyPrint")
  valid_580424 = validateParameter(valid_580424, JBool, required = false,
                                 default = newJBool(true))
  if valid_580424 != nil:
    section.add "prettyPrint", valid_580424
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580425: Call_BloggerCommentsMarkAsSpam_580412; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Marks a comment as spam.
  ## 
  let valid = call_580425.validator(path, query, header, formData, body)
  let scheme = call_580425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580425.url(scheme.get, call_580425.host, call_580425.base,
                         call_580425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580425, url, valid)

proc call*(call_580426: Call_BloggerCommentsMarkAsSpam_580412; commentId: string;
          postId: string; blogId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## bloggerCommentsMarkAsSpam
  ## Marks a comment as spam.
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
  ##            : The ID of the comment to mark as spam.
  ##   postId: string (required)
  ##         : The ID of the Post.
  ##   blogId: string (required)
  ##         : The ID of the Blog.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580427 = newJObject()
  var query_580428 = newJObject()
  add(query_580428, "fields", newJString(fields))
  add(query_580428, "quotaUser", newJString(quotaUser))
  add(query_580428, "alt", newJString(alt))
  add(query_580428, "oauth_token", newJString(oauthToken))
  add(query_580428, "userIp", newJString(userIp))
  add(query_580428, "key", newJString(key))
  add(path_580427, "commentId", newJString(commentId))
  add(path_580427, "postId", newJString(postId))
  add(path_580427, "blogId", newJString(blogId))
  add(query_580428, "prettyPrint", newJBool(prettyPrint))
  result = call_580426.call(path_580427, query_580428, nil, nil, nil)

var bloggerCommentsMarkAsSpam* = Call_BloggerCommentsMarkAsSpam_580412(
    name: "bloggerCommentsMarkAsSpam", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/blogs/{blogId}/posts/{postId}/comments/{commentId}/spam",
    validator: validate_BloggerCommentsMarkAsSpam_580413, base: "/blogger/v3",
    url: url_BloggerCommentsMarkAsSpam_580414, schemes: {Scheme.Https})
type
  Call_BloggerPostsPublish_580429 = ref object of OpenApiRestCall_579408
proc url_BloggerPostsPublish_580431(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "blogId" in path, "`blogId` is a required path parameter"
  assert "postId" in path, "`postId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId"),
               (kind: ConstantSegment, value: "/posts/"),
               (kind: VariableSegment, value: "postId"),
               (kind: ConstantSegment, value: "/publish")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerPostsPublish_580430(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Publishes a draft post, optionally at the specific time of the given publishDate parameter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   postId: JString (required)
  ##         : The ID of the Post.
  ##   blogId: JString (required)
  ##         : The ID of the Blog.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `postId` field"
  var valid_580432 = path.getOrDefault("postId")
  valid_580432 = validateParameter(valid_580432, JString, required = true,
                                 default = nil)
  if valid_580432 != nil:
    section.add "postId", valid_580432
  var valid_580433 = path.getOrDefault("blogId")
  valid_580433 = validateParameter(valid_580433, JString, required = true,
                                 default = nil)
  if valid_580433 != nil:
    section.add "blogId", valid_580433
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   publishDate: JString
  ##              : Optional date and time to schedule the publishing of the Blog. If no publishDate parameter is given, the post is either published at the a previously saved schedule date (if present), or the current time. If a future date is given, the post will be scheduled to be published.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580434 = query.getOrDefault("fields")
  valid_580434 = validateParameter(valid_580434, JString, required = false,
                                 default = nil)
  if valid_580434 != nil:
    section.add "fields", valid_580434
  var valid_580435 = query.getOrDefault("quotaUser")
  valid_580435 = validateParameter(valid_580435, JString, required = false,
                                 default = nil)
  if valid_580435 != nil:
    section.add "quotaUser", valid_580435
  var valid_580436 = query.getOrDefault("alt")
  valid_580436 = validateParameter(valid_580436, JString, required = false,
                                 default = newJString("json"))
  if valid_580436 != nil:
    section.add "alt", valid_580436
  var valid_580437 = query.getOrDefault("publishDate")
  valid_580437 = validateParameter(valid_580437, JString, required = false,
                                 default = nil)
  if valid_580437 != nil:
    section.add "publishDate", valid_580437
  var valid_580438 = query.getOrDefault("oauth_token")
  valid_580438 = validateParameter(valid_580438, JString, required = false,
                                 default = nil)
  if valid_580438 != nil:
    section.add "oauth_token", valid_580438
  var valid_580439 = query.getOrDefault("userIp")
  valid_580439 = validateParameter(valid_580439, JString, required = false,
                                 default = nil)
  if valid_580439 != nil:
    section.add "userIp", valid_580439
  var valid_580440 = query.getOrDefault("key")
  valid_580440 = validateParameter(valid_580440, JString, required = false,
                                 default = nil)
  if valid_580440 != nil:
    section.add "key", valid_580440
  var valid_580441 = query.getOrDefault("prettyPrint")
  valid_580441 = validateParameter(valid_580441, JBool, required = false,
                                 default = newJBool(true))
  if valid_580441 != nil:
    section.add "prettyPrint", valid_580441
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580442: Call_BloggerPostsPublish_580429; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Publishes a draft post, optionally at the specific time of the given publishDate parameter.
  ## 
  let valid = call_580442.validator(path, query, header, formData, body)
  let scheme = call_580442.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580442.url(scheme.get, call_580442.host, call_580442.base,
                         call_580442.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580442, url, valid)

proc call*(call_580443: Call_BloggerPostsPublish_580429; postId: string;
          blogId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; publishDate: string = ""; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## bloggerPostsPublish
  ## Publishes a draft post, optionally at the specific time of the given publishDate parameter.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   publishDate: string
  ##              : Optional date and time to schedule the publishing of the Blog. If no publishDate parameter is given, the post is either published at the a previously saved schedule date (if present), or the current time. If a future date is given, the post will be scheduled to be published.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   postId: string (required)
  ##         : The ID of the Post.
  ##   blogId: string (required)
  ##         : The ID of the Blog.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580444 = newJObject()
  var query_580445 = newJObject()
  add(query_580445, "fields", newJString(fields))
  add(query_580445, "quotaUser", newJString(quotaUser))
  add(query_580445, "alt", newJString(alt))
  add(query_580445, "publishDate", newJString(publishDate))
  add(query_580445, "oauth_token", newJString(oauthToken))
  add(query_580445, "userIp", newJString(userIp))
  add(query_580445, "key", newJString(key))
  add(path_580444, "postId", newJString(postId))
  add(path_580444, "blogId", newJString(blogId))
  add(query_580445, "prettyPrint", newJBool(prettyPrint))
  result = call_580443.call(path_580444, query_580445, nil, nil, nil)

var bloggerPostsPublish* = Call_BloggerPostsPublish_580429(
    name: "bloggerPostsPublish", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/blogs/{blogId}/posts/{postId}/publish",
    validator: validate_BloggerPostsPublish_580430, base: "/blogger/v3",
    url: url_BloggerPostsPublish_580431, schemes: {Scheme.Https})
type
  Call_BloggerPostsRevert_580446 = ref object of OpenApiRestCall_579408
proc url_BloggerPostsRevert_580448(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "blogId" in path, "`blogId` is a required path parameter"
  assert "postId" in path, "`postId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId"),
               (kind: ConstantSegment, value: "/posts/"),
               (kind: VariableSegment, value: "postId"),
               (kind: ConstantSegment, value: "/revert")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerPostsRevert_580447(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Revert a published or scheduled post to draft state.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   postId: JString (required)
  ##         : The ID of the Post.
  ##   blogId: JString (required)
  ##         : The ID of the Blog.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `postId` field"
  var valid_580449 = path.getOrDefault("postId")
  valid_580449 = validateParameter(valid_580449, JString, required = true,
                                 default = nil)
  if valid_580449 != nil:
    section.add "postId", valid_580449
  var valid_580450 = path.getOrDefault("blogId")
  valid_580450 = validateParameter(valid_580450, JString, required = true,
                                 default = nil)
  if valid_580450 != nil:
    section.add "blogId", valid_580450
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
  var valid_580451 = query.getOrDefault("fields")
  valid_580451 = validateParameter(valid_580451, JString, required = false,
                                 default = nil)
  if valid_580451 != nil:
    section.add "fields", valid_580451
  var valid_580452 = query.getOrDefault("quotaUser")
  valid_580452 = validateParameter(valid_580452, JString, required = false,
                                 default = nil)
  if valid_580452 != nil:
    section.add "quotaUser", valid_580452
  var valid_580453 = query.getOrDefault("alt")
  valid_580453 = validateParameter(valid_580453, JString, required = false,
                                 default = newJString("json"))
  if valid_580453 != nil:
    section.add "alt", valid_580453
  var valid_580454 = query.getOrDefault("oauth_token")
  valid_580454 = validateParameter(valid_580454, JString, required = false,
                                 default = nil)
  if valid_580454 != nil:
    section.add "oauth_token", valid_580454
  var valid_580455 = query.getOrDefault("userIp")
  valid_580455 = validateParameter(valid_580455, JString, required = false,
                                 default = nil)
  if valid_580455 != nil:
    section.add "userIp", valid_580455
  var valid_580456 = query.getOrDefault("key")
  valid_580456 = validateParameter(valid_580456, JString, required = false,
                                 default = nil)
  if valid_580456 != nil:
    section.add "key", valid_580456
  var valid_580457 = query.getOrDefault("prettyPrint")
  valid_580457 = validateParameter(valid_580457, JBool, required = false,
                                 default = newJBool(true))
  if valid_580457 != nil:
    section.add "prettyPrint", valid_580457
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580458: Call_BloggerPostsRevert_580446; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Revert a published or scheduled post to draft state.
  ## 
  let valid = call_580458.validator(path, query, header, formData, body)
  let scheme = call_580458.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580458.url(scheme.get, call_580458.host, call_580458.base,
                         call_580458.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580458, url, valid)

proc call*(call_580459: Call_BloggerPostsRevert_580446; postId: string;
          blogId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## bloggerPostsRevert
  ## Revert a published or scheduled post to draft state.
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
  ##   postId: string (required)
  ##         : The ID of the Post.
  ##   blogId: string (required)
  ##         : The ID of the Blog.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580460 = newJObject()
  var query_580461 = newJObject()
  add(query_580461, "fields", newJString(fields))
  add(query_580461, "quotaUser", newJString(quotaUser))
  add(query_580461, "alt", newJString(alt))
  add(query_580461, "oauth_token", newJString(oauthToken))
  add(query_580461, "userIp", newJString(userIp))
  add(query_580461, "key", newJString(key))
  add(path_580460, "postId", newJString(postId))
  add(path_580460, "blogId", newJString(blogId))
  add(query_580461, "prettyPrint", newJBool(prettyPrint))
  result = call_580459.call(path_580460, query_580461, nil, nil, nil)

var bloggerPostsRevert* = Call_BloggerPostsRevert_580446(
    name: "bloggerPostsRevert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/blogs/{blogId}/posts/{postId}/revert",
    validator: validate_BloggerPostsRevert_580447, base: "/blogger/v3",
    url: url_BloggerPostsRevert_580448, schemes: {Scheme.Https})
type
  Call_BloggerUsersGet_580462 = ref object of OpenApiRestCall_579408
proc url_BloggerUsersGet_580464(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerUsersGet_580463(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets one user by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : The ID of the user to get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_580465 = path.getOrDefault("userId")
  valid_580465 = validateParameter(valid_580465, JString, required = true,
                                 default = nil)
  if valid_580465 != nil:
    section.add "userId", valid_580465
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
  var valid_580471 = query.getOrDefault("key")
  valid_580471 = validateParameter(valid_580471, JString, required = false,
                                 default = nil)
  if valid_580471 != nil:
    section.add "key", valid_580471
  var valid_580472 = query.getOrDefault("prettyPrint")
  valid_580472 = validateParameter(valid_580472, JBool, required = false,
                                 default = newJBool(true))
  if valid_580472 != nil:
    section.add "prettyPrint", valid_580472
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580473: Call_BloggerUsersGet_580462; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one user by ID.
  ## 
  let valid = call_580473.validator(path, query, header, formData, body)
  let scheme = call_580473.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580473.url(scheme.get, call_580473.host, call_580473.base,
                         call_580473.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580473, url, valid)

proc call*(call_580474: Call_BloggerUsersGet_580462; userId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## bloggerUsersGet
  ## Gets one user by ID.
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
  ##         : The ID of the user to get.
  var path_580475 = newJObject()
  var query_580476 = newJObject()
  add(query_580476, "fields", newJString(fields))
  add(query_580476, "quotaUser", newJString(quotaUser))
  add(query_580476, "alt", newJString(alt))
  add(query_580476, "oauth_token", newJString(oauthToken))
  add(query_580476, "userIp", newJString(userIp))
  add(query_580476, "key", newJString(key))
  add(query_580476, "prettyPrint", newJBool(prettyPrint))
  add(path_580475, "userId", newJString(userId))
  result = call_580474.call(path_580475, query_580476, nil, nil, nil)

var bloggerUsersGet* = Call_BloggerUsersGet_580462(name: "bloggerUsersGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/users/{userId}",
    validator: validate_BloggerUsersGet_580463, base: "/blogger/v3",
    url: url_BloggerUsersGet_580464, schemes: {Scheme.Https})
type
  Call_BloggerBlogsListByUser_580477 = ref object of OpenApiRestCall_579408
proc url_BloggerBlogsListByUser_580479(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/blogs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerBlogsListByUser_580478(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of blogs, possibly filtered.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : ID of the user whose blogs are to be fetched. Either the word 'self' (sans quote marks) or the user's profile identifier.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_580480 = path.getOrDefault("userId")
  valid_580480 = validateParameter(valid_580480, JString, required = true,
                                 default = nil)
  if valid_580480 != nil:
    section.add "userId", valid_580480
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: JString
  ##       : Access level with which to view the blogs. Note that some fields require elevated access.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   fetchUserInfo: JBool
  ##                : Whether the response is a list of blogs with per-user information instead of just blogs.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   role: JArray
  ##       : User access types for blogs to include in the results, e.g. AUTHOR will return blogs where the user has author level access. If no roles are specified, defaults to ADMIN and AUTHOR roles.
  ##   status: JArray
  ##         : Blog statuses to include in the result (default: Live blogs only). Note that ADMIN access is required to view deleted blogs.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580481 = query.getOrDefault("fields")
  valid_580481 = validateParameter(valid_580481, JString, required = false,
                                 default = nil)
  if valid_580481 != nil:
    section.add "fields", valid_580481
  var valid_580482 = query.getOrDefault("view")
  valid_580482 = validateParameter(valid_580482, JString, required = false,
                                 default = newJString("ADMIN"))
  if valid_580482 != nil:
    section.add "view", valid_580482
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
  var valid_580486 = query.getOrDefault("fetchUserInfo")
  valid_580486 = validateParameter(valid_580486, JBool, required = false, default = nil)
  if valid_580486 != nil:
    section.add "fetchUserInfo", valid_580486
  var valid_580487 = query.getOrDefault("userIp")
  valid_580487 = validateParameter(valid_580487, JString, required = false,
                                 default = nil)
  if valid_580487 != nil:
    section.add "userIp", valid_580487
  var valid_580488 = query.getOrDefault("key")
  valid_580488 = validateParameter(valid_580488, JString, required = false,
                                 default = nil)
  if valid_580488 != nil:
    section.add "key", valid_580488
  var valid_580489 = query.getOrDefault("role")
  valid_580489 = validateParameter(valid_580489, JArray, required = false,
                                 default = nil)
  if valid_580489 != nil:
    section.add "role", valid_580489
  var valid_580490 = query.getOrDefault("status")
  valid_580490 = validateParameter(valid_580490, JArray, required = false,
                                 default = nil)
  if valid_580490 != nil:
    section.add "status", valid_580490
  var valid_580491 = query.getOrDefault("prettyPrint")
  valid_580491 = validateParameter(valid_580491, JBool, required = false,
                                 default = newJBool(true))
  if valid_580491 != nil:
    section.add "prettyPrint", valid_580491
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580492: Call_BloggerBlogsListByUser_580477; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of blogs, possibly filtered.
  ## 
  let valid = call_580492.validator(path, query, header, formData, body)
  let scheme = call_580492.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580492.url(scheme.get, call_580492.host, call_580492.base,
                         call_580492.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580492, url, valid)

proc call*(call_580493: Call_BloggerBlogsListByUser_580477; userId: string;
          fields: string = ""; view: string = "ADMIN"; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; fetchUserInfo: bool = false;
          userIp: string = ""; key: string = ""; role: JsonNode = nil;
          status: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## bloggerBlogsListByUser
  ## Retrieves a list of blogs, possibly filtered.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: string
  ##       : Access level with which to view the blogs. Note that some fields require elevated access.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   fetchUserInfo: bool
  ##                : Whether the response is a list of blogs with per-user information instead of just blogs.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   role: JArray
  ##       : User access types for blogs to include in the results, e.g. AUTHOR will return blogs where the user has author level access. If no roles are specified, defaults to ADMIN and AUTHOR roles.
  ##   status: JArray
  ##         : Blog statuses to include in the result (default: Live blogs only). Note that ADMIN access is required to view deleted blogs.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : ID of the user whose blogs are to be fetched. Either the word 'self' (sans quote marks) or the user's profile identifier.
  var path_580494 = newJObject()
  var query_580495 = newJObject()
  add(query_580495, "fields", newJString(fields))
  add(query_580495, "view", newJString(view))
  add(query_580495, "quotaUser", newJString(quotaUser))
  add(query_580495, "alt", newJString(alt))
  add(query_580495, "oauth_token", newJString(oauthToken))
  add(query_580495, "fetchUserInfo", newJBool(fetchUserInfo))
  add(query_580495, "userIp", newJString(userIp))
  add(query_580495, "key", newJString(key))
  if role != nil:
    query_580495.add "role", role
  if status != nil:
    query_580495.add "status", status
  add(query_580495, "prettyPrint", newJBool(prettyPrint))
  add(path_580494, "userId", newJString(userId))
  result = call_580493.call(path_580494, query_580495, nil, nil, nil)

var bloggerBlogsListByUser* = Call_BloggerBlogsListByUser_580477(
    name: "bloggerBlogsListByUser", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userId}/blogs",
    validator: validate_BloggerBlogsListByUser_580478, base: "/blogger/v3",
    url: url_BloggerBlogsListByUser_580479, schemes: {Scheme.Https})
type
  Call_BloggerBlogUserInfosGet_580496 = ref object of OpenApiRestCall_579408
proc url_BloggerBlogUserInfosGet_580498(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "blogId" in path, "`blogId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerBlogUserInfosGet_580497(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets one blog and user info pair by blogId and userId.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blogId: JString (required)
  ##         : The ID of the blog to get.
  ##   userId: JString (required)
  ##         : ID of the user whose blogs are to be fetched. Either the word 'self' (sans quote marks) or the user's profile identifier.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blogId` field"
  var valid_580499 = path.getOrDefault("blogId")
  valid_580499 = validateParameter(valid_580499, JString, required = true,
                                 default = nil)
  if valid_580499 != nil:
    section.add "blogId", valid_580499
  var valid_580500 = path.getOrDefault("userId")
  valid_580500 = validateParameter(valid_580500, JString, required = true,
                                 default = nil)
  if valid_580500 != nil:
    section.add "userId", valid_580500
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
  ##   maxPosts: JInt
  ##           : Maximum number of posts to pull back with the blog.
  section = newJObject()
  var valid_580501 = query.getOrDefault("fields")
  valid_580501 = validateParameter(valid_580501, JString, required = false,
                                 default = nil)
  if valid_580501 != nil:
    section.add "fields", valid_580501
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
  var valid_580506 = query.getOrDefault("key")
  valid_580506 = validateParameter(valid_580506, JString, required = false,
                                 default = nil)
  if valid_580506 != nil:
    section.add "key", valid_580506
  var valid_580507 = query.getOrDefault("prettyPrint")
  valid_580507 = validateParameter(valid_580507, JBool, required = false,
                                 default = newJBool(true))
  if valid_580507 != nil:
    section.add "prettyPrint", valid_580507
  var valid_580508 = query.getOrDefault("maxPosts")
  valid_580508 = validateParameter(valid_580508, JInt, required = false, default = nil)
  if valid_580508 != nil:
    section.add "maxPosts", valid_580508
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580509: Call_BloggerBlogUserInfosGet_580496; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one blog and user info pair by blogId and userId.
  ## 
  let valid = call_580509.validator(path, query, header, formData, body)
  let scheme = call_580509.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580509.url(scheme.get, call_580509.host, call_580509.base,
                         call_580509.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580509, url, valid)

proc call*(call_580510: Call_BloggerBlogUserInfosGet_580496; blogId: string;
          userId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true; maxPosts: int = 0): Recallable =
  ## bloggerBlogUserInfosGet
  ## Gets one blog and user info pair by blogId and userId.
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
  ##   blogId: string (required)
  ##         : The ID of the blog to get.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   maxPosts: int
  ##           : Maximum number of posts to pull back with the blog.
  ##   userId: string (required)
  ##         : ID of the user whose blogs are to be fetched. Either the word 'self' (sans quote marks) or the user's profile identifier.
  var path_580511 = newJObject()
  var query_580512 = newJObject()
  add(query_580512, "fields", newJString(fields))
  add(query_580512, "quotaUser", newJString(quotaUser))
  add(query_580512, "alt", newJString(alt))
  add(query_580512, "oauth_token", newJString(oauthToken))
  add(query_580512, "userIp", newJString(userIp))
  add(query_580512, "key", newJString(key))
  add(path_580511, "blogId", newJString(blogId))
  add(query_580512, "prettyPrint", newJBool(prettyPrint))
  add(query_580512, "maxPosts", newJInt(maxPosts))
  add(path_580511, "userId", newJString(userId))
  result = call_580510.call(path_580511, query_580512, nil, nil, nil)

var bloggerBlogUserInfosGet* = Call_BloggerBlogUserInfosGet_580496(
    name: "bloggerBlogUserInfosGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userId}/blogs/{blogId}",
    validator: validate_BloggerBlogUserInfosGet_580497, base: "/blogger/v3",
    url: url_BloggerBlogUserInfosGet_580498, schemes: {Scheme.Https})
type
  Call_BloggerPostUserInfosList_580513 = ref object of OpenApiRestCall_579408
proc url_BloggerPostUserInfosList_580515(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "blogId" in path, "`blogId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId"),
               (kind: ConstantSegment, value: "/posts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerPostUserInfosList_580514(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of post and post user info pairs, possibly filtered. The post user info contains per-user information about the post, such as access rights, specific to the user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blogId: JString (required)
  ##         : ID of the blog to fetch posts from.
  ##   userId: JString (required)
  ##         : ID of the user for the per-user information to be fetched. Either the word 'self' (sans quote marks) or the user's profile identifier.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blogId` field"
  var valid_580516 = path.getOrDefault("blogId")
  valid_580516 = validateParameter(valid_580516, JString, required = true,
                                 default = nil)
  if valid_580516 != nil:
    section.add "blogId", valid_580516
  var valid_580517 = path.getOrDefault("userId")
  valid_580517 = validateParameter(valid_580517, JString, required = true,
                                 default = nil)
  if valid_580517 != nil:
    section.add "userId", valid_580517
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Continuation token if the request is paged.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   view: JString
  ##       : Access level with which to view the returned result. Note that some fields require elevated access.
  ##   alt: JString
  ##      : Data format for the response.
  ##   endDate: JString
  ##          : Latest post date to fetch, a date-time with RFC 3339 formatting.
  ##   startDate: JString
  ##            : Earliest post date to fetch, a date-time with RFC 3339 formatting.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of posts to fetch.
  ##   orderBy: JString
  ##          : Sort order applied to search results. Default is published.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   labels: JString
  ##         : Comma-separated list of labels to search for.
  ##   status: JArray
  ##   fetchBodies: JBool
  ##              : Whether the body content of posts is included. Default is false.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580518 = query.getOrDefault("fields")
  valid_580518 = validateParameter(valid_580518, JString, required = false,
                                 default = nil)
  if valid_580518 != nil:
    section.add "fields", valid_580518
  var valid_580519 = query.getOrDefault("pageToken")
  valid_580519 = validateParameter(valid_580519, JString, required = false,
                                 default = nil)
  if valid_580519 != nil:
    section.add "pageToken", valid_580519
  var valid_580520 = query.getOrDefault("quotaUser")
  valid_580520 = validateParameter(valid_580520, JString, required = false,
                                 default = nil)
  if valid_580520 != nil:
    section.add "quotaUser", valid_580520
  var valid_580521 = query.getOrDefault("view")
  valid_580521 = validateParameter(valid_580521, JString, required = false,
                                 default = newJString("ADMIN"))
  if valid_580521 != nil:
    section.add "view", valid_580521
  var valid_580522 = query.getOrDefault("alt")
  valid_580522 = validateParameter(valid_580522, JString, required = false,
                                 default = newJString("json"))
  if valid_580522 != nil:
    section.add "alt", valid_580522
  var valid_580523 = query.getOrDefault("endDate")
  valid_580523 = validateParameter(valid_580523, JString, required = false,
                                 default = nil)
  if valid_580523 != nil:
    section.add "endDate", valid_580523
  var valid_580524 = query.getOrDefault("startDate")
  valid_580524 = validateParameter(valid_580524, JString, required = false,
                                 default = nil)
  if valid_580524 != nil:
    section.add "startDate", valid_580524
  var valid_580525 = query.getOrDefault("oauth_token")
  valid_580525 = validateParameter(valid_580525, JString, required = false,
                                 default = nil)
  if valid_580525 != nil:
    section.add "oauth_token", valid_580525
  var valid_580526 = query.getOrDefault("userIp")
  valid_580526 = validateParameter(valid_580526, JString, required = false,
                                 default = nil)
  if valid_580526 != nil:
    section.add "userIp", valid_580526
  var valid_580527 = query.getOrDefault("maxResults")
  valid_580527 = validateParameter(valid_580527, JInt, required = false, default = nil)
  if valid_580527 != nil:
    section.add "maxResults", valid_580527
  var valid_580528 = query.getOrDefault("orderBy")
  valid_580528 = validateParameter(valid_580528, JString, required = false,
                                 default = newJString("published"))
  if valid_580528 != nil:
    section.add "orderBy", valid_580528
  var valid_580529 = query.getOrDefault("key")
  valid_580529 = validateParameter(valid_580529, JString, required = false,
                                 default = nil)
  if valid_580529 != nil:
    section.add "key", valid_580529
  var valid_580530 = query.getOrDefault("labels")
  valid_580530 = validateParameter(valid_580530, JString, required = false,
                                 default = nil)
  if valid_580530 != nil:
    section.add "labels", valid_580530
  var valid_580531 = query.getOrDefault("status")
  valid_580531 = validateParameter(valid_580531, JArray, required = false,
                                 default = nil)
  if valid_580531 != nil:
    section.add "status", valid_580531
  var valid_580532 = query.getOrDefault("fetchBodies")
  valid_580532 = validateParameter(valid_580532, JBool, required = false,
                                 default = newJBool(false))
  if valid_580532 != nil:
    section.add "fetchBodies", valid_580532
  var valid_580533 = query.getOrDefault("prettyPrint")
  valid_580533 = validateParameter(valid_580533, JBool, required = false,
                                 default = newJBool(true))
  if valid_580533 != nil:
    section.add "prettyPrint", valid_580533
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580534: Call_BloggerPostUserInfosList_580513; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of post and post user info pairs, possibly filtered. The post user info contains per-user information about the post, such as access rights, specific to the user.
  ## 
  let valid = call_580534.validator(path, query, header, formData, body)
  let scheme = call_580534.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580534.url(scheme.get, call_580534.host, call_580534.base,
                         call_580534.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580534, url, valid)

proc call*(call_580535: Call_BloggerPostUserInfosList_580513; blogId: string;
          userId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; view: string = "ADMIN"; alt: string = "json";
          endDate: string = ""; startDate: string = ""; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; orderBy: string = "published";
          key: string = ""; labels: string = ""; status: JsonNode = nil;
          fetchBodies: bool = false; prettyPrint: bool = true): Recallable =
  ## bloggerPostUserInfosList
  ## Retrieves a list of post and post user info pairs, possibly filtered. The post user info contains per-user information about the post, such as access rights, specific to the user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Continuation token if the request is paged.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   view: string
  ##       : Access level with which to view the returned result. Note that some fields require elevated access.
  ##   alt: string
  ##      : Data format for the response.
  ##   endDate: string
  ##          : Latest post date to fetch, a date-time with RFC 3339 formatting.
  ##   startDate: string
  ##            : Earliest post date to fetch, a date-time with RFC 3339 formatting.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of posts to fetch.
  ##   orderBy: string
  ##          : Sort order applied to search results. Default is published.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   labels: string
  ##         : Comma-separated list of labels to search for.
  ##   status: JArray
  ##   fetchBodies: bool
  ##              : Whether the body content of posts is included. Default is false.
  ##   blogId: string (required)
  ##         : ID of the blog to fetch posts from.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : ID of the user for the per-user information to be fetched. Either the word 'self' (sans quote marks) or the user's profile identifier.
  var path_580536 = newJObject()
  var query_580537 = newJObject()
  add(query_580537, "fields", newJString(fields))
  add(query_580537, "pageToken", newJString(pageToken))
  add(query_580537, "quotaUser", newJString(quotaUser))
  add(query_580537, "view", newJString(view))
  add(query_580537, "alt", newJString(alt))
  add(query_580537, "endDate", newJString(endDate))
  add(query_580537, "startDate", newJString(startDate))
  add(query_580537, "oauth_token", newJString(oauthToken))
  add(query_580537, "userIp", newJString(userIp))
  add(query_580537, "maxResults", newJInt(maxResults))
  add(query_580537, "orderBy", newJString(orderBy))
  add(query_580537, "key", newJString(key))
  add(query_580537, "labels", newJString(labels))
  if status != nil:
    query_580537.add "status", status
  add(query_580537, "fetchBodies", newJBool(fetchBodies))
  add(path_580536, "blogId", newJString(blogId))
  add(query_580537, "prettyPrint", newJBool(prettyPrint))
  add(path_580536, "userId", newJString(userId))
  result = call_580535.call(path_580536, query_580537, nil, nil, nil)

var bloggerPostUserInfosList* = Call_BloggerPostUserInfosList_580513(
    name: "bloggerPostUserInfosList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userId}/blogs/{blogId}/posts",
    validator: validate_BloggerPostUserInfosList_580514, base: "/blogger/v3",
    url: url_BloggerPostUserInfosList_580515, schemes: {Scheme.Https})
type
  Call_BloggerPostUserInfosGet_580538 = ref object of OpenApiRestCall_579408
proc url_BloggerPostUserInfosGet_580540(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "blogId" in path, "`blogId` is a required path parameter"
  assert "postId" in path, "`postId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId"),
               (kind: ConstantSegment, value: "/posts/"),
               (kind: VariableSegment, value: "postId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerPostUserInfosGet_580539(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets one post and user info pair, by post ID and user ID. The post user info contains per-user information about the post, such as access rights, specific to the user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   postId: JString (required)
  ##         : The ID of the post to get.
  ##   blogId: JString (required)
  ##         : The ID of the blog.
  ##   userId: JString (required)
  ##         : ID of the user for the per-user information to be fetched. Either the word 'self' (sans quote marks) or the user's profile identifier.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `postId` field"
  var valid_580541 = path.getOrDefault("postId")
  valid_580541 = validateParameter(valid_580541, JString, required = true,
                                 default = nil)
  if valid_580541 != nil:
    section.add "postId", valid_580541
  var valid_580542 = path.getOrDefault("blogId")
  valid_580542 = validateParameter(valid_580542, JString, required = true,
                                 default = nil)
  if valid_580542 != nil:
    section.add "blogId", valid_580542
  var valid_580543 = path.getOrDefault("userId")
  valid_580543 = validateParameter(valid_580543, JString, required = true,
                                 default = nil)
  if valid_580543 != nil:
    section.add "userId", valid_580543
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
  ##   maxComments: JInt
  ##              : Maximum number of comments to pull back on a post.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580544 = query.getOrDefault("fields")
  valid_580544 = validateParameter(valid_580544, JString, required = false,
                                 default = nil)
  if valid_580544 != nil:
    section.add "fields", valid_580544
  var valid_580545 = query.getOrDefault("quotaUser")
  valid_580545 = validateParameter(valid_580545, JString, required = false,
                                 default = nil)
  if valid_580545 != nil:
    section.add "quotaUser", valid_580545
  var valid_580546 = query.getOrDefault("alt")
  valid_580546 = validateParameter(valid_580546, JString, required = false,
                                 default = newJString("json"))
  if valid_580546 != nil:
    section.add "alt", valid_580546
  var valid_580547 = query.getOrDefault("oauth_token")
  valid_580547 = validateParameter(valid_580547, JString, required = false,
                                 default = nil)
  if valid_580547 != nil:
    section.add "oauth_token", valid_580547
  var valid_580548 = query.getOrDefault("userIp")
  valid_580548 = validateParameter(valid_580548, JString, required = false,
                                 default = nil)
  if valid_580548 != nil:
    section.add "userIp", valid_580548
  var valid_580549 = query.getOrDefault("maxComments")
  valid_580549 = validateParameter(valid_580549, JInt, required = false, default = nil)
  if valid_580549 != nil:
    section.add "maxComments", valid_580549
  var valid_580550 = query.getOrDefault("key")
  valid_580550 = validateParameter(valid_580550, JString, required = false,
                                 default = nil)
  if valid_580550 != nil:
    section.add "key", valid_580550
  var valid_580551 = query.getOrDefault("prettyPrint")
  valid_580551 = validateParameter(valid_580551, JBool, required = false,
                                 default = newJBool(true))
  if valid_580551 != nil:
    section.add "prettyPrint", valid_580551
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580552: Call_BloggerPostUserInfosGet_580538; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one post and user info pair, by post ID and user ID. The post user info contains per-user information about the post, such as access rights, specific to the user.
  ## 
  let valid = call_580552.validator(path, query, header, formData, body)
  let scheme = call_580552.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580552.url(scheme.get, call_580552.host, call_580552.base,
                         call_580552.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580552, url, valid)

proc call*(call_580553: Call_BloggerPostUserInfosGet_580538; postId: string;
          blogId: string; userId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxComments: int = 0; key: string = ""; prettyPrint: bool = true): Recallable =
  ## bloggerPostUserInfosGet
  ## Gets one post and user info pair, by post ID and user ID. The post user info contains per-user information about the post, such as access rights, specific to the user.
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
  ##   maxComments: int
  ##              : Maximum number of comments to pull back on a post.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   postId: string (required)
  ##         : The ID of the post to get.
  ##   blogId: string (required)
  ##         : The ID of the blog.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : ID of the user for the per-user information to be fetched. Either the word 'self' (sans quote marks) or the user's profile identifier.
  var path_580554 = newJObject()
  var query_580555 = newJObject()
  add(query_580555, "fields", newJString(fields))
  add(query_580555, "quotaUser", newJString(quotaUser))
  add(query_580555, "alt", newJString(alt))
  add(query_580555, "oauth_token", newJString(oauthToken))
  add(query_580555, "userIp", newJString(userIp))
  add(query_580555, "maxComments", newJInt(maxComments))
  add(query_580555, "key", newJString(key))
  add(path_580554, "postId", newJString(postId))
  add(path_580554, "blogId", newJString(blogId))
  add(query_580555, "prettyPrint", newJBool(prettyPrint))
  add(path_580554, "userId", newJString(userId))
  result = call_580553.call(path_580554, query_580555, nil, nil, nil)

var bloggerPostUserInfosGet* = Call_BloggerPostUserInfosGet_580538(
    name: "bloggerPostUserInfosGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/users/{userId}/blogs/{blogId}/posts/{postId}",
    validator: validate_BloggerPostUserInfosGet_580539, base: "/blogger/v3",
    url: url_BloggerPostUserInfosGet_580540, schemes: {Scheme.Https})
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
