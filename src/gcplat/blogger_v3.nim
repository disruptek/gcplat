
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_597408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597408): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BloggerBlogsGetByUrl_597676 = ref object of OpenApiRestCall_597408
proc url_BloggerBlogsGetByUrl_597678(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_BloggerBlogsGetByUrl_597677(path: JsonNode; query: JsonNode;
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
  var valid_597790 = query.getOrDefault("fields")
  valid_597790 = validateParameter(valid_597790, JString, required = false,
                                 default = nil)
  if valid_597790 != nil:
    section.add "fields", valid_597790
  var valid_597804 = query.getOrDefault("view")
  valid_597804 = validateParameter(valid_597804, JString, required = false,
                                 default = newJString("ADMIN"))
  if valid_597804 != nil:
    section.add "view", valid_597804
  var valid_597805 = query.getOrDefault("quotaUser")
  valid_597805 = validateParameter(valid_597805, JString, required = false,
                                 default = nil)
  if valid_597805 != nil:
    section.add "quotaUser", valid_597805
  var valid_597806 = query.getOrDefault("alt")
  valid_597806 = validateParameter(valid_597806, JString, required = false,
                                 default = newJString("json"))
  if valid_597806 != nil:
    section.add "alt", valid_597806
  var valid_597807 = query.getOrDefault("oauth_token")
  valid_597807 = validateParameter(valid_597807, JString, required = false,
                                 default = nil)
  if valid_597807 != nil:
    section.add "oauth_token", valid_597807
  var valid_597808 = query.getOrDefault("userIp")
  valid_597808 = validateParameter(valid_597808, JString, required = false,
                                 default = nil)
  if valid_597808 != nil:
    section.add "userIp", valid_597808
  assert query != nil, "query argument is necessary due to required `url` field"
  var valid_597809 = query.getOrDefault("url")
  valid_597809 = validateParameter(valid_597809, JString, required = true,
                                 default = nil)
  if valid_597809 != nil:
    section.add "url", valid_597809
  var valid_597810 = query.getOrDefault("key")
  valid_597810 = validateParameter(valid_597810, JString, required = false,
                                 default = nil)
  if valid_597810 != nil:
    section.add "key", valid_597810
  var valid_597811 = query.getOrDefault("prettyPrint")
  valid_597811 = validateParameter(valid_597811, JBool, required = false,
                                 default = newJBool(true))
  if valid_597811 != nil:
    section.add "prettyPrint", valid_597811
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597834: Call_BloggerBlogsGetByUrl_597676; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a Blog by URL.
  ## 
  let valid = call_597834.validator(path, query, header, formData, body)
  let scheme = call_597834.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597834.url(scheme.get, call_597834.host, call_597834.base,
                         call_597834.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597834, url, valid)

proc call*(call_597905: Call_BloggerBlogsGetByUrl_597676; url: string;
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
  var query_597906 = newJObject()
  add(query_597906, "fields", newJString(fields))
  add(query_597906, "view", newJString(view))
  add(query_597906, "quotaUser", newJString(quotaUser))
  add(query_597906, "alt", newJString(alt))
  add(query_597906, "oauth_token", newJString(oauthToken))
  add(query_597906, "userIp", newJString(userIp))
  add(query_597906, "url", newJString(url))
  add(query_597906, "key", newJString(key))
  add(query_597906, "prettyPrint", newJBool(prettyPrint))
  result = call_597905.call(nil, query_597906, nil, nil, nil)

var bloggerBlogsGetByUrl* = Call_BloggerBlogsGetByUrl_597676(
    name: "bloggerBlogsGetByUrl", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/blogs/byurl",
    validator: validate_BloggerBlogsGetByUrl_597677, base: "/blogger/v3",
    url: url_BloggerBlogsGetByUrl_597678, schemes: {Scheme.Https})
type
  Call_BloggerBlogsGet_597946 = ref object of OpenApiRestCall_597408
proc url_BloggerBlogsGet_597948(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "blogId" in path, "`blogId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerBlogsGet_597947(path: JsonNode; query: JsonNode;
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
  var valid_597963 = path.getOrDefault("blogId")
  valid_597963 = validateParameter(valid_597963, JString, required = true,
                                 default = nil)
  if valid_597963 != nil:
    section.add "blogId", valid_597963
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
  var valid_597964 = query.getOrDefault("fields")
  valid_597964 = validateParameter(valid_597964, JString, required = false,
                                 default = nil)
  if valid_597964 != nil:
    section.add "fields", valid_597964
  var valid_597965 = query.getOrDefault("view")
  valid_597965 = validateParameter(valid_597965, JString, required = false,
                                 default = newJString("ADMIN"))
  if valid_597965 != nil:
    section.add "view", valid_597965
  var valid_597966 = query.getOrDefault("quotaUser")
  valid_597966 = validateParameter(valid_597966, JString, required = false,
                                 default = nil)
  if valid_597966 != nil:
    section.add "quotaUser", valid_597966
  var valid_597967 = query.getOrDefault("alt")
  valid_597967 = validateParameter(valid_597967, JString, required = false,
                                 default = newJString("json"))
  if valid_597967 != nil:
    section.add "alt", valid_597967
  var valid_597968 = query.getOrDefault("oauth_token")
  valid_597968 = validateParameter(valid_597968, JString, required = false,
                                 default = nil)
  if valid_597968 != nil:
    section.add "oauth_token", valid_597968
  var valid_597969 = query.getOrDefault("userIp")
  valid_597969 = validateParameter(valid_597969, JString, required = false,
                                 default = nil)
  if valid_597969 != nil:
    section.add "userIp", valid_597969
  var valid_597970 = query.getOrDefault("key")
  valid_597970 = validateParameter(valid_597970, JString, required = false,
                                 default = nil)
  if valid_597970 != nil:
    section.add "key", valid_597970
  var valid_597971 = query.getOrDefault("prettyPrint")
  valid_597971 = validateParameter(valid_597971, JBool, required = false,
                                 default = newJBool(true))
  if valid_597971 != nil:
    section.add "prettyPrint", valid_597971
  var valid_597972 = query.getOrDefault("maxPosts")
  valid_597972 = validateParameter(valid_597972, JInt, required = false, default = nil)
  if valid_597972 != nil:
    section.add "maxPosts", valid_597972
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597973: Call_BloggerBlogsGet_597946; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one blog by ID.
  ## 
  let valid = call_597973.validator(path, query, header, formData, body)
  let scheme = call_597973.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597973.url(scheme.get, call_597973.host, call_597973.base,
                         call_597973.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597973, url, valid)

proc call*(call_597974: Call_BloggerBlogsGet_597946; blogId: string;
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
  var path_597975 = newJObject()
  var query_597976 = newJObject()
  add(query_597976, "fields", newJString(fields))
  add(query_597976, "view", newJString(view))
  add(query_597976, "quotaUser", newJString(quotaUser))
  add(query_597976, "alt", newJString(alt))
  add(query_597976, "oauth_token", newJString(oauthToken))
  add(query_597976, "userIp", newJString(userIp))
  add(query_597976, "key", newJString(key))
  add(path_597975, "blogId", newJString(blogId))
  add(query_597976, "prettyPrint", newJBool(prettyPrint))
  add(query_597976, "maxPosts", newJInt(maxPosts))
  result = call_597974.call(path_597975, query_597976, nil, nil, nil)

var bloggerBlogsGet* = Call_BloggerBlogsGet_597946(name: "bloggerBlogsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/blogs/{blogId}",
    validator: validate_BloggerBlogsGet_597947, base: "/blogger/v3",
    url: url_BloggerBlogsGet_597948, schemes: {Scheme.Https})
type
  Call_BloggerCommentsListByBlog_597977 = ref object of OpenApiRestCall_597408
proc url_BloggerCommentsListByBlog_597979(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BloggerCommentsListByBlog_597978(path: JsonNode; query: JsonNode;
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
  var valid_597980 = path.getOrDefault("blogId")
  valid_597980 = validateParameter(valid_597980, JString, required = true,
                                 default = nil)
  if valid_597980 != nil:
    section.add "blogId", valid_597980
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
  var valid_597981 = query.getOrDefault("fields")
  valid_597981 = validateParameter(valid_597981, JString, required = false,
                                 default = nil)
  if valid_597981 != nil:
    section.add "fields", valid_597981
  var valid_597982 = query.getOrDefault("pageToken")
  valid_597982 = validateParameter(valid_597982, JString, required = false,
                                 default = nil)
  if valid_597982 != nil:
    section.add "pageToken", valid_597982
  var valid_597983 = query.getOrDefault("quotaUser")
  valid_597983 = validateParameter(valid_597983, JString, required = false,
                                 default = nil)
  if valid_597983 != nil:
    section.add "quotaUser", valid_597983
  var valid_597984 = query.getOrDefault("alt")
  valid_597984 = validateParameter(valid_597984, JString, required = false,
                                 default = newJString("json"))
  if valid_597984 != nil:
    section.add "alt", valid_597984
  var valid_597985 = query.getOrDefault("endDate")
  valid_597985 = validateParameter(valid_597985, JString, required = false,
                                 default = nil)
  if valid_597985 != nil:
    section.add "endDate", valid_597985
  var valid_597986 = query.getOrDefault("startDate")
  valid_597986 = validateParameter(valid_597986, JString, required = false,
                                 default = nil)
  if valid_597986 != nil:
    section.add "startDate", valid_597986
  var valid_597987 = query.getOrDefault("oauth_token")
  valid_597987 = validateParameter(valid_597987, JString, required = false,
                                 default = nil)
  if valid_597987 != nil:
    section.add "oauth_token", valid_597987
  var valid_597988 = query.getOrDefault("userIp")
  valid_597988 = validateParameter(valid_597988, JString, required = false,
                                 default = nil)
  if valid_597988 != nil:
    section.add "userIp", valid_597988
  var valid_597989 = query.getOrDefault("maxResults")
  valid_597989 = validateParameter(valid_597989, JInt, required = false, default = nil)
  if valid_597989 != nil:
    section.add "maxResults", valid_597989
  var valid_597990 = query.getOrDefault("key")
  valid_597990 = validateParameter(valid_597990, JString, required = false,
                                 default = nil)
  if valid_597990 != nil:
    section.add "key", valid_597990
  var valid_597991 = query.getOrDefault("status")
  valid_597991 = validateParameter(valid_597991, JArray, required = false,
                                 default = nil)
  if valid_597991 != nil:
    section.add "status", valid_597991
  var valid_597992 = query.getOrDefault("fetchBodies")
  valid_597992 = validateParameter(valid_597992, JBool, required = false, default = nil)
  if valid_597992 != nil:
    section.add "fetchBodies", valid_597992
  var valid_597993 = query.getOrDefault("prettyPrint")
  valid_597993 = validateParameter(valid_597993, JBool, required = false,
                                 default = newJBool(true))
  if valid_597993 != nil:
    section.add "prettyPrint", valid_597993
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597994: Call_BloggerCommentsListByBlog_597977; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the comments for a blog, across all posts, possibly filtered.
  ## 
  let valid = call_597994.validator(path, query, header, formData, body)
  let scheme = call_597994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597994.url(scheme.get, call_597994.host, call_597994.base,
                         call_597994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597994, url, valid)

proc call*(call_597995: Call_BloggerCommentsListByBlog_597977; blogId: string;
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
  var path_597996 = newJObject()
  var query_597997 = newJObject()
  add(query_597997, "fields", newJString(fields))
  add(query_597997, "pageToken", newJString(pageToken))
  add(query_597997, "quotaUser", newJString(quotaUser))
  add(query_597997, "alt", newJString(alt))
  add(query_597997, "endDate", newJString(endDate))
  add(query_597997, "startDate", newJString(startDate))
  add(query_597997, "oauth_token", newJString(oauthToken))
  add(query_597997, "userIp", newJString(userIp))
  add(query_597997, "maxResults", newJInt(maxResults))
  add(query_597997, "key", newJString(key))
  if status != nil:
    query_597997.add "status", status
  add(query_597997, "fetchBodies", newJBool(fetchBodies))
  add(path_597996, "blogId", newJString(blogId))
  add(query_597997, "prettyPrint", newJBool(prettyPrint))
  result = call_597995.call(path_597996, query_597997, nil, nil, nil)

var bloggerCommentsListByBlog* = Call_BloggerCommentsListByBlog_597977(
    name: "bloggerCommentsListByBlog", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/blogs/{blogId}/comments",
    validator: validate_BloggerCommentsListByBlog_597978, base: "/blogger/v3",
    url: url_BloggerCommentsListByBlog_597979, schemes: {Scheme.Https})
type
  Call_BloggerPagesInsert_598018 = ref object of OpenApiRestCall_597408
proc url_BloggerPagesInsert_598020(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BloggerPagesInsert_598019(path: JsonNode; query: JsonNode;
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
  var valid_598021 = path.getOrDefault("blogId")
  valid_598021 = validateParameter(valid_598021, JString, required = true,
                                 default = nil)
  if valid_598021 != nil:
    section.add "blogId", valid_598021
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
  var valid_598022 = query.getOrDefault("fields")
  valid_598022 = validateParameter(valid_598022, JString, required = false,
                                 default = nil)
  if valid_598022 != nil:
    section.add "fields", valid_598022
  var valid_598023 = query.getOrDefault("quotaUser")
  valid_598023 = validateParameter(valid_598023, JString, required = false,
                                 default = nil)
  if valid_598023 != nil:
    section.add "quotaUser", valid_598023
  var valid_598024 = query.getOrDefault("alt")
  valid_598024 = validateParameter(valid_598024, JString, required = false,
                                 default = newJString("json"))
  if valid_598024 != nil:
    section.add "alt", valid_598024
  var valid_598025 = query.getOrDefault("oauth_token")
  valid_598025 = validateParameter(valid_598025, JString, required = false,
                                 default = nil)
  if valid_598025 != nil:
    section.add "oauth_token", valid_598025
  var valid_598026 = query.getOrDefault("isDraft")
  valid_598026 = validateParameter(valid_598026, JBool, required = false, default = nil)
  if valid_598026 != nil:
    section.add "isDraft", valid_598026
  var valid_598027 = query.getOrDefault("userIp")
  valid_598027 = validateParameter(valid_598027, JString, required = false,
                                 default = nil)
  if valid_598027 != nil:
    section.add "userIp", valid_598027
  var valid_598028 = query.getOrDefault("key")
  valid_598028 = validateParameter(valid_598028, JString, required = false,
                                 default = nil)
  if valid_598028 != nil:
    section.add "key", valid_598028
  var valid_598029 = query.getOrDefault("prettyPrint")
  valid_598029 = validateParameter(valid_598029, JBool, required = false,
                                 default = newJBool(true))
  if valid_598029 != nil:
    section.add "prettyPrint", valid_598029
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

proc call*(call_598031: Call_BloggerPagesInsert_598018; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a page.
  ## 
  let valid = call_598031.validator(path, query, header, formData, body)
  let scheme = call_598031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598031.url(scheme.get, call_598031.host, call_598031.base,
                         call_598031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598031, url, valid)

proc call*(call_598032: Call_BloggerPagesInsert_598018; blogId: string;
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
  var path_598033 = newJObject()
  var query_598034 = newJObject()
  var body_598035 = newJObject()
  add(query_598034, "fields", newJString(fields))
  add(query_598034, "quotaUser", newJString(quotaUser))
  add(query_598034, "alt", newJString(alt))
  add(query_598034, "oauth_token", newJString(oauthToken))
  add(query_598034, "isDraft", newJBool(isDraft))
  add(query_598034, "userIp", newJString(userIp))
  add(query_598034, "key", newJString(key))
  add(path_598033, "blogId", newJString(blogId))
  if body != nil:
    body_598035 = body
  add(query_598034, "prettyPrint", newJBool(prettyPrint))
  result = call_598032.call(path_598033, query_598034, nil, nil, body_598035)

var bloggerPagesInsert* = Call_BloggerPagesInsert_598018(
    name: "bloggerPagesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/blogs/{blogId}/pages",
    validator: validate_BloggerPagesInsert_598019, base: "/blogger/v3",
    url: url_BloggerPagesInsert_598020, schemes: {Scheme.Https})
type
  Call_BloggerPagesList_597998 = ref object of OpenApiRestCall_597408
proc url_BloggerPagesList_598000(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BloggerPagesList_597999(path: JsonNode; query: JsonNode;
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
  var valid_598001 = path.getOrDefault("blogId")
  valid_598001 = validateParameter(valid_598001, JString, required = true,
                                 default = nil)
  if valid_598001 != nil:
    section.add "blogId", valid_598001
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
  var valid_598002 = query.getOrDefault("fields")
  valid_598002 = validateParameter(valid_598002, JString, required = false,
                                 default = nil)
  if valid_598002 != nil:
    section.add "fields", valid_598002
  var valid_598003 = query.getOrDefault("pageToken")
  valid_598003 = validateParameter(valid_598003, JString, required = false,
                                 default = nil)
  if valid_598003 != nil:
    section.add "pageToken", valid_598003
  var valid_598004 = query.getOrDefault("quotaUser")
  valid_598004 = validateParameter(valid_598004, JString, required = false,
                                 default = nil)
  if valid_598004 != nil:
    section.add "quotaUser", valid_598004
  var valid_598005 = query.getOrDefault("view")
  valid_598005 = validateParameter(valid_598005, JString, required = false,
                                 default = newJString("ADMIN"))
  if valid_598005 != nil:
    section.add "view", valid_598005
  var valid_598006 = query.getOrDefault("alt")
  valid_598006 = validateParameter(valid_598006, JString, required = false,
                                 default = newJString("json"))
  if valid_598006 != nil:
    section.add "alt", valid_598006
  var valid_598007 = query.getOrDefault("oauth_token")
  valid_598007 = validateParameter(valid_598007, JString, required = false,
                                 default = nil)
  if valid_598007 != nil:
    section.add "oauth_token", valid_598007
  var valid_598008 = query.getOrDefault("userIp")
  valid_598008 = validateParameter(valid_598008, JString, required = false,
                                 default = nil)
  if valid_598008 != nil:
    section.add "userIp", valid_598008
  var valid_598009 = query.getOrDefault("maxResults")
  valid_598009 = validateParameter(valid_598009, JInt, required = false, default = nil)
  if valid_598009 != nil:
    section.add "maxResults", valid_598009
  var valid_598010 = query.getOrDefault("key")
  valid_598010 = validateParameter(valid_598010, JString, required = false,
                                 default = nil)
  if valid_598010 != nil:
    section.add "key", valid_598010
  var valid_598011 = query.getOrDefault("status")
  valid_598011 = validateParameter(valid_598011, JArray, required = false,
                                 default = nil)
  if valid_598011 != nil:
    section.add "status", valid_598011
  var valid_598012 = query.getOrDefault("fetchBodies")
  valid_598012 = validateParameter(valid_598012, JBool, required = false, default = nil)
  if valid_598012 != nil:
    section.add "fetchBodies", valid_598012
  var valid_598013 = query.getOrDefault("prettyPrint")
  valid_598013 = validateParameter(valid_598013, JBool, required = false,
                                 default = newJBool(true))
  if valid_598013 != nil:
    section.add "prettyPrint", valid_598013
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598014: Call_BloggerPagesList_597998; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the pages for a blog, optionally including non-LIVE statuses.
  ## 
  let valid = call_598014.validator(path, query, header, formData, body)
  let scheme = call_598014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598014.url(scheme.get, call_598014.host, call_598014.base,
                         call_598014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598014, url, valid)

proc call*(call_598015: Call_BloggerPagesList_597998; blogId: string;
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
  var path_598016 = newJObject()
  var query_598017 = newJObject()
  add(query_598017, "fields", newJString(fields))
  add(query_598017, "pageToken", newJString(pageToken))
  add(query_598017, "quotaUser", newJString(quotaUser))
  add(query_598017, "view", newJString(view))
  add(query_598017, "alt", newJString(alt))
  add(query_598017, "oauth_token", newJString(oauthToken))
  add(query_598017, "userIp", newJString(userIp))
  add(query_598017, "maxResults", newJInt(maxResults))
  add(query_598017, "key", newJString(key))
  if status != nil:
    query_598017.add "status", status
  add(query_598017, "fetchBodies", newJBool(fetchBodies))
  add(path_598016, "blogId", newJString(blogId))
  add(query_598017, "prettyPrint", newJBool(prettyPrint))
  result = call_598015.call(path_598016, query_598017, nil, nil, nil)

var bloggerPagesList* = Call_BloggerPagesList_597998(name: "bloggerPagesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/blogs/{blogId}/pages", validator: validate_BloggerPagesList_597999,
    base: "/blogger/v3", url: url_BloggerPagesList_598000, schemes: {Scheme.Https})
type
  Call_BloggerPagesUpdate_598053 = ref object of OpenApiRestCall_597408
proc url_BloggerPagesUpdate_598055(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BloggerPagesUpdate_598054(path: JsonNode; query: JsonNode;
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
  var valid_598056 = path.getOrDefault("pageId")
  valid_598056 = validateParameter(valid_598056, JString, required = true,
                                 default = nil)
  if valid_598056 != nil:
    section.add "pageId", valid_598056
  var valid_598057 = path.getOrDefault("blogId")
  valid_598057 = validateParameter(valid_598057, JString, required = true,
                                 default = nil)
  if valid_598057 != nil:
    section.add "blogId", valid_598057
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
  var valid_598058 = query.getOrDefault("revert")
  valid_598058 = validateParameter(valid_598058, JBool, required = false, default = nil)
  if valid_598058 != nil:
    section.add "revert", valid_598058
  var valid_598059 = query.getOrDefault("fields")
  valid_598059 = validateParameter(valid_598059, JString, required = false,
                                 default = nil)
  if valid_598059 != nil:
    section.add "fields", valid_598059
  var valid_598060 = query.getOrDefault("quotaUser")
  valid_598060 = validateParameter(valid_598060, JString, required = false,
                                 default = nil)
  if valid_598060 != nil:
    section.add "quotaUser", valid_598060
  var valid_598061 = query.getOrDefault("alt")
  valid_598061 = validateParameter(valid_598061, JString, required = false,
                                 default = newJString("json"))
  if valid_598061 != nil:
    section.add "alt", valid_598061
  var valid_598062 = query.getOrDefault("oauth_token")
  valid_598062 = validateParameter(valid_598062, JString, required = false,
                                 default = nil)
  if valid_598062 != nil:
    section.add "oauth_token", valid_598062
  var valid_598063 = query.getOrDefault("userIp")
  valid_598063 = validateParameter(valid_598063, JString, required = false,
                                 default = nil)
  if valid_598063 != nil:
    section.add "userIp", valid_598063
  var valid_598064 = query.getOrDefault("key")
  valid_598064 = validateParameter(valid_598064, JString, required = false,
                                 default = nil)
  if valid_598064 != nil:
    section.add "key", valid_598064
  var valid_598065 = query.getOrDefault("publish")
  valid_598065 = validateParameter(valid_598065, JBool, required = false, default = nil)
  if valid_598065 != nil:
    section.add "publish", valid_598065
  var valid_598066 = query.getOrDefault("prettyPrint")
  valid_598066 = validateParameter(valid_598066, JBool, required = false,
                                 default = newJBool(true))
  if valid_598066 != nil:
    section.add "prettyPrint", valid_598066
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

proc call*(call_598068: Call_BloggerPagesUpdate_598053; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a page.
  ## 
  let valid = call_598068.validator(path, query, header, formData, body)
  let scheme = call_598068.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598068.url(scheme.get, call_598068.host, call_598068.base,
                         call_598068.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598068, url, valid)

proc call*(call_598069: Call_BloggerPagesUpdate_598053; pageId: string;
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
  var path_598070 = newJObject()
  var query_598071 = newJObject()
  var body_598072 = newJObject()
  add(query_598071, "revert", newJBool(revert))
  add(query_598071, "fields", newJString(fields))
  add(query_598071, "quotaUser", newJString(quotaUser))
  add(query_598071, "alt", newJString(alt))
  add(query_598071, "oauth_token", newJString(oauthToken))
  add(query_598071, "userIp", newJString(userIp))
  add(query_598071, "key", newJString(key))
  add(path_598070, "pageId", newJString(pageId))
  add(query_598071, "publish", newJBool(publish))
  add(path_598070, "blogId", newJString(blogId))
  if body != nil:
    body_598072 = body
  add(query_598071, "prettyPrint", newJBool(prettyPrint))
  result = call_598069.call(path_598070, query_598071, nil, nil, body_598072)

var bloggerPagesUpdate* = Call_BloggerPagesUpdate_598053(
    name: "bloggerPagesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/blogs/{blogId}/pages/{pageId}",
    validator: validate_BloggerPagesUpdate_598054, base: "/blogger/v3",
    url: url_BloggerPagesUpdate_598055, schemes: {Scheme.Https})
type
  Call_BloggerPagesGet_598036 = ref object of OpenApiRestCall_597408
proc url_BloggerPagesGet_598038(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BloggerPagesGet_598037(path: JsonNode; query: JsonNode;
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
  var valid_598039 = path.getOrDefault("pageId")
  valid_598039 = validateParameter(valid_598039, JString, required = true,
                                 default = nil)
  if valid_598039 != nil:
    section.add "pageId", valid_598039
  var valid_598040 = path.getOrDefault("blogId")
  valid_598040 = validateParameter(valid_598040, JString, required = true,
                                 default = nil)
  if valid_598040 != nil:
    section.add "blogId", valid_598040
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
  var valid_598041 = query.getOrDefault("fields")
  valid_598041 = validateParameter(valid_598041, JString, required = false,
                                 default = nil)
  if valid_598041 != nil:
    section.add "fields", valid_598041
  var valid_598042 = query.getOrDefault("view")
  valid_598042 = validateParameter(valid_598042, JString, required = false,
                                 default = newJString("ADMIN"))
  if valid_598042 != nil:
    section.add "view", valid_598042
  var valid_598043 = query.getOrDefault("quotaUser")
  valid_598043 = validateParameter(valid_598043, JString, required = false,
                                 default = nil)
  if valid_598043 != nil:
    section.add "quotaUser", valid_598043
  var valid_598044 = query.getOrDefault("alt")
  valid_598044 = validateParameter(valid_598044, JString, required = false,
                                 default = newJString("json"))
  if valid_598044 != nil:
    section.add "alt", valid_598044
  var valid_598045 = query.getOrDefault("oauth_token")
  valid_598045 = validateParameter(valid_598045, JString, required = false,
                                 default = nil)
  if valid_598045 != nil:
    section.add "oauth_token", valid_598045
  var valid_598046 = query.getOrDefault("userIp")
  valid_598046 = validateParameter(valid_598046, JString, required = false,
                                 default = nil)
  if valid_598046 != nil:
    section.add "userIp", valid_598046
  var valid_598047 = query.getOrDefault("key")
  valid_598047 = validateParameter(valid_598047, JString, required = false,
                                 default = nil)
  if valid_598047 != nil:
    section.add "key", valid_598047
  var valid_598048 = query.getOrDefault("prettyPrint")
  valid_598048 = validateParameter(valid_598048, JBool, required = false,
                                 default = newJBool(true))
  if valid_598048 != nil:
    section.add "prettyPrint", valid_598048
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598049: Call_BloggerPagesGet_598036; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one blog page by ID.
  ## 
  let valid = call_598049.validator(path, query, header, formData, body)
  let scheme = call_598049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598049.url(scheme.get, call_598049.host, call_598049.base,
                         call_598049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598049, url, valid)

proc call*(call_598050: Call_BloggerPagesGet_598036; pageId: string; blogId: string;
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
  var path_598051 = newJObject()
  var query_598052 = newJObject()
  add(query_598052, "fields", newJString(fields))
  add(query_598052, "view", newJString(view))
  add(query_598052, "quotaUser", newJString(quotaUser))
  add(query_598052, "alt", newJString(alt))
  add(query_598052, "oauth_token", newJString(oauthToken))
  add(query_598052, "userIp", newJString(userIp))
  add(query_598052, "key", newJString(key))
  add(path_598051, "pageId", newJString(pageId))
  add(path_598051, "blogId", newJString(blogId))
  add(query_598052, "prettyPrint", newJBool(prettyPrint))
  result = call_598050.call(path_598051, query_598052, nil, nil, nil)

var bloggerPagesGet* = Call_BloggerPagesGet_598036(name: "bloggerPagesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/blogs/{blogId}/pages/{pageId}", validator: validate_BloggerPagesGet_598037,
    base: "/blogger/v3", url: url_BloggerPagesGet_598038, schemes: {Scheme.Https})
type
  Call_BloggerPagesPatch_598089 = ref object of OpenApiRestCall_597408
proc url_BloggerPagesPatch_598091(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BloggerPagesPatch_598090(path: JsonNode; query: JsonNode;
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
  var valid_598092 = path.getOrDefault("pageId")
  valid_598092 = validateParameter(valid_598092, JString, required = true,
                                 default = nil)
  if valid_598092 != nil:
    section.add "pageId", valid_598092
  var valid_598093 = path.getOrDefault("blogId")
  valid_598093 = validateParameter(valid_598093, JString, required = true,
                                 default = nil)
  if valid_598093 != nil:
    section.add "blogId", valid_598093
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
  var valid_598094 = query.getOrDefault("revert")
  valid_598094 = validateParameter(valid_598094, JBool, required = false, default = nil)
  if valid_598094 != nil:
    section.add "revert", valid_598094
  var valid_598095 = query.getOrDefault("fields")
  valid_598095 = validateParameter(valid_598095, JString, required = false,
                                 default = nil)
  if valid_598095 != nil:
    section.add "fields", valid_598095
  var valid_598096 = query.getOrDefault("quotaUser")
  valid_598096 = validateParameter(valid_598096, JString, required = false,
                                 default = nil)
  if valid_598096 != nil:
    section.add "quotaUser", valid_598096
  var valid_598097 = query.getOrDefault("alt")
  valid_598097 = validateParameter(valid_598097, JString, required = false,
                                 default = newJString("json"))
  if valid_598097 != nil:
    section.add "alt", valid_598097
  var valid_598098 = query.getOrDefault("oauth_token")
  valid_598098 = validateParameter(valid_598098, JString, required = false,
                                 default = nil)
  if valid_598098 != nil:
    section.add "oauth_token", valid_598098
  var valid_598099 = query.getOrDefault("userIp")
  valid_598099 = validateParameter(valid_598099, JString, required = false,
                                 default = nil)
  if valid_598099 != nil:
    section.add "userIp", valid_598099
  var valid_598100 = query.getOrDefault("key")
  valid_598100 = validateParameter(valid_598100, JString, required = false,
                                 default = nil)
  if valid_598100 != nil:
    section.add "key", valid_598100
  var valid_598101 = query.getOrDefault("publish")
  valid_598101 = validateParameter(valid_598101, JBool, required = false, default = nil)
  if valid_598101 != nil:
    section.add "publish", valid_598101
  var valid_598102 = query.getOrDefault("prettyPrint")
  valid_598102 = validateParameter(valid_598102, JBool, required = false,
                                 default = newJBool(true))
  if valid_598102 != nil:
    section.add "prettyPrint", valid_598102
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

proc call*(call_598104: Call_BloggerPagesPatch_598089; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a page. This method supports patch semantics.
  ## 
  let valid = call_598104.validator(path, query, header, formData, body)
  let scheme = call_598104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598104.url(scheme.get, call_598104.host, call_598104.base,
                         call_598104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598104, url, valid)

proc call*(call_598105: Call_BloggerPagesPatch_598089; pageId: string;
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
  var path_598106 = newJObject()
  var query_598107 = newJObject()
  var body_598108 = newJObject()
  add(query_598107, "revert", newJBool(revert))
  add(query_598107, "fields", newJString(fields))
  add(query_598107, "quotaUser", newJString(quotaUser))
  add(query_598107, "alt", newJString(alt))
  add(query_598107, "oauth_token", newJString(oauthToken))
  add(query_598107, "userIp", newJString(userIp))
  add(query_598107, "key", newJString(key))
  add(path_598106, "pageId", newJString(pageId))
  add(query_598107, "publish", newJBool(publish))
  add(path_598106, "blogId", newJString(blogId))
  if body != nil:
    body_598108 = body
  add(query_598107, "prettyPrint", newJBool(prettyPrint))
  result = call_598105.call(path_598106, query_598107, nil, nil, body_598108)

var bloggerPagesPatch* = Call_BloggerPagesPatch_598089(name: "bloggerPagesPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/blogs/{blogId}/pages/{pageId}",
    validator: validate_BloggerPagesPatch_598090, base: "/blogger/v3",
    url: url_BloggerPagesPatch_598091, schemes: {Scheme.Https})
type
  Call_BloggerPagesDelete_598073 = ref object of OpenApiRestCall_597408
proc url_BloggerPagesDelete_598075(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BloggerPagesDelete_598074(path: JsonNode; query: JsonNode;
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
  var valid_598076 = path.getOrDefault("pageId")
  valid_598076 = validateParameter(valid_598076, JString, required = true,
                                 default = nil)
  if valid_598076 != nil:
    section.add "pageId", valid_598076
  var valid_598077 = path.getOrDefault("blogId")
  valid_598077 = validateParameter(valid_598077, JString, required = true,
                                 default = nil)
  if valid_598077 != nil:
    section.add "blogId", valid_598077
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
  var valid_598078 = query.getOrDefault("fields")
  valid_598078 = validateParameter(valid_598078, JString, required = false,
                                 default = nil)
  if valid_598078 != nil:
    section.add "fields", valid_598078
  var valid_598079 = query.getOrDefault("quotaUser")
  valid_598079 = validateParameter(valid_598079, JString, required = false,
                                 default = nil)
  if valid_598079 != nil:
    section.add "quotaUser", valid_598079
  var valid_598080 = query.getOrDefault("alt")
  valid_598080 = validateParameter(valid_598080, JString, required = false,
                                 default = newJString("json"))
  if valid_598080 != nil:
    section.add "alt", valid_598080
  var valid_598081 = query.getOrDefault("oauth_token")
  valid_598081 = validateParameter(valid_598081, JString, required = false,
                                 default = nil)
  if valid_598081 != nil:
    section.add "oauth_token", valid_598081
  var valid_598082 = query.getOrDefault("userIp")
  valid_598082 = validateParameter(valid_598082, JString, required = false,
                                 default = nil)
  if valid_598082 != nil:
    section.add "userIp", valid_598082
  var valid_598083 = query.getOrDefault("key")
  valid_598083 = validateParameter(valid_598083, JString, required = false,
                                 default = nil)
  if valid_598083 != nil:
    section.add "key", valid_598083
  var valid_598084 = query.getOrDefault("prettyPrint")
  valid_598084 = validateParameter(valid_598084, JBool, required = false,
                                 default = newJBool(true))
  if valid_598084 != nil:
    section.add "prettyPrint", valid_598084
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598085: Call_BloggerPagesDelete_598073; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a page by ID.
  ## 
  let valid = call_598085.validator(path, query, header, formData, body)
  let scheme = call_598085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598085.url(scheme.get, call_598085.host, call_598085.base,
                         call_598085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598085, url, valid)

proc call*(call_598086: Call_BloggerPagesDelete_598073; pageId: string;
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
  var path_598087 = newJObject()
  var query_598088 = newJObject()
  add(query_598088, "fields", newJString(fields))
  add(query_598088, "quotaUser", newJString(quotaUser))
  add(query_598088, "alt", newJString(alt))
  add(query_598088, "oauth_token", newJString(oauthToken))
  add(query_598088, "userIp", newJString(userIp))
  add(query_598088, "key", newJString(key))
  add(path_598087, "pageId", newJString(pageId))
  add(path_598087, "blogId", newJString(blogId))
  add(query_598088, "prettyPrint", newJBool(prettyPrint))
  result = call_598086.call(path_598087, query_598088, nil, nil, nil)

var bloggerPagesDelete* = Call_BloggerPagesDelete_598073(
    name: "bloggerPagesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/blogs/{blogId}/pages/{pageId}",
    validator: validate_BloggerPagesDelete_598074, base: "/blogger/v3",
    url: url_BloggerPagesDelete_598075, schemes: {Scheme.Https})
type
  Call_BloggerPagesPublish_598109 = ref object of OpenApiRestCall_597408
proc url_BloggerPagesPublish_598111(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BloggerPagesPublish_598110(path: JsonNode; query: JsonNode;
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
  var valid_598112 = path.getOrDefault("pageId")
  valid_598112 = validateParameter(valid_598112, JString, required = true,
                                 default = nil)
  if valid_598112 != nil:
    section.add "pageId", valid_598112
  var valid_598113 = path.getOrDefault("blogId")
  valid_598113 = validateParameter(valid_598113, JString, required = true,
                                 default = nil)
  if valid_598113 != nil:
    section.add "blogId", valid_598113
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
  var valid_598114 = query.getOrDefault("fields")
  valid_598114 = validateParameter(valid_598114, JString, required = false,
                                 default = nil)
  if valid_598114 != nil:
    section.add "fields", valid_598114
  var valid_598115 = query.getOrDefault("quotaUser")
  valid_598115 = validateParameter(valid_598115, JString, required = false,
                                 default = nil)
  if valid_598115 != nil:
    section.add "quotaUser", valid_598115
  var valid_598116 = query.getOrDefault("alt")
  valid_598116 = validateParameter(valid_598116, JString, required = false,
                                 default = newJString("json"))
  if valid_598116 != nil:
    section.add "alt", valid_598116
  var valid_598117 = query.getOrDefault("oauth_token")
  valid_598117 = validateParameter(valid_598117, JString, required = false,
                                 default = nil)
  if valid_598117 != nil:
    section.add "oauth_token", valid_598117
  var valid_598118 = query.getOrDefault("userIp")
  valid_598118 = validateParameter(valid_598118, JString, required = false,
                                 default = nil)
  if valid_598118 != nil:
    section.add "userIp", valid_598118
  var valid_598119 = query.getOrDefault("key")
  valid_598119 = validateParameter(valid_598119, JString, required = false,
                                 default = nil)
  if valid_598119 != nil:
    section.add "key", valid_598119
  var valid_598120 = query.getOrDefault("prettyPrint")
  valid_598120 = validateParameter(valid_598120, JBool, required = false,
                                 default = newJBool(true))
  if valid_598120 != nil:
    section.add "prettyPrint", valid_598120
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598121: Call_BloggerPagesPublish_598109; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Publishes a draft page.
  ## 
  let valid = call_598121.validator(path, query, header, formData, body)
  let scheme = call_598121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598121.url(scheme.get, call_598121.host, call_598121.base,
                         call_598121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598121, url, valid)

proc call*(call_598122: Call_BloggerPagesPublish_598109; pageId: string;
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
  var path_598123 = newJObject()
  var query_598124 = newJObject()
  add(query_598124, "fields", newJString(fields))
  add(query_598124, "quotaUser", newJString(quotaUser))
  add(query_598124, "alt", newJString(alt))
  add(query_598124, "oauth_token", newJString(oauthToken))
  add(query_598124, "userIp", newJString(userIp))
  add(query_598124, "key", newJString(key))
  add(path_598123, "pageId", newJString(pageId))
  add(path_598123, "blogId", newJString(blogId))
  add(query_598124, "prettyPrint", newJBool(prettyPrint))
  result = call_598122.call(path_598123, query_598124, nil, nil, nil)

var bloggerPagesPublish* = Call_BloggerPagesPublish_598109(
    name: "bloggerPagesPublish", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/blogs/{blogId}/pages/{pageId}/publish",
    validator: validate_BloggerPagesPublish_598110, base: "/blogger/v3",
    url: url_BloggerPagesPublish_598111, schemes: {Scheme.Https})
type
  Call_BloggerPagesRevert_598125 = ref object of OpenApiRestCall_597408
proc url_BloggerPagesRevert_598127(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BloggerPagesRevert_598126(path: JsonNode; query: JsonNode;
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
  var valid_598128 = path.getOrDefault("pageId")
  valid_598128 = validateParameter(valid_598128, JString, required = true,
                                 default = nil)
  if valid_598128 != nil:
    section.add "pageId", valid_598128
  var valid_598129 = path.getOrDefault("blogId")
  valid_598129 = validateParameter(valid_598129, JString, required = true,
                                 default = nil)
  if valid_598129 != nil:
    section.add "blogId", valid_598129
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
  var valid_598130 = query.getOrDefault("fields")
  valid_598130 = validateParameter(valid_598130, JString, required = false,
                                 default = nil)
  if valid_598130 != nil:
    section.add "fields", valid_598130
  var valid_598131 = query.getOrDefault("quotaUser")
  valid_598131 = validateParameter(valid_598131, JString, required = false,
                                 default = nil)
  if valid_598131 != nil:
    section.add "quotaUser", valid_598131
  var valid_598132 = query.getOrDefault("alt")
  valid_598132 = validateParameter(valid_598132, JString, required = false,
                                 default = newJString("json"))
  if valid_598132 != nil:
    section.add "alt", valid_598132
  var valid_598133 = query.getOrDefault("oauth_token")
  valid_598133 = validateParameter(valid_598133, JString, required = false,
                                 default = nil)
  if valid_598133 != nil:
    section.add "oauth_token", valid_598133
  var valid_598134 = query.getOrDefault("userIp")
  valid_598134 = validateParameter(valid_598134, JString, required = false,
                                 default = nil)
  if valid_598134 != nil:
    section.add "userIp", valid_598134
  var valid_598135 = query.getOrDefault("key")
  valid_598135 = validateParameter(valid_598135, JString, required = false,
                                 default = nil)
  if valid_598135 != nil:
    section.add "key", valid_598135
  var valid_598136 = query.getOrDefault("prettyPrint")
  valid_598136 = validateParameter(valid_598136, JBool, required = false,
                                 default = newJBool(true))
  if valid_598136 != nil:
    section.add "prettyPrint", valid_598136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598137: Call_BloggerPagesRevert_598125; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Revert a published or scheduled page to draft state.
  ## 
  let valid = call_598137.validator(path, query, header, formData, body)
  let scheme = call_598137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598137.url(scheme.get, call_598137.host, call_598137.base,
                         call_598137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598137, url, valid)

proc call*(call_598138: Call_BloggerPagesRevert_598125; pageId: string;
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
  var path_598139 = newJObject()
  var query_598140 = newJObject()
  add(query_598140, "fields", newJString(fields))
  add(query_598140, "quotaUser", newJString(quotaUser))
  add(query_598140, "alt", newJString(alt))
  add(query_598140, "oauth_token", newJString(oauthToken))
  add(query_598140, "userIp", newJString(userIp))
  add(query_598140, "key", newJString(key))
  add(path_598139, "pageId", newJString(pageId))
  add(path_598139, "blogId", newJString(blogId))
  add(query_598140, "prettyPrint", newJBool(prettyPrint))
  result = call_598138.call(path_598139, query_598140, nil, nil, nil)

var bloggerPagesRevert* = Call_BloggerPagesRevert_598125(
    name: "bloggerPagesRevert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/blogs/{blogId}/pages/{pageId}/revert",
    validator: validate_BloggerPagesRevert_598126, base: "/blogger/v3",
    url: url_BloggerPagesRevert_598127, schemes: {Scheme.Https})
type
  Call_BloggerPageViewsGet_598141 = ref object of OpenApiRestCall_597408
proc url_BloggerPageViewsGet_598143(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BloggerPageViewsGet_598142(path: JsonNode; query: JsonNode;
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
  var valid_598144 = path.getOrDefault("blogId")
  valid_598144 = validateParameter(valid_598144, JString, required = true,
                                 default = nil)
  if valid_598144 != nil:
    section.add "blogId", valid_598144
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
  var valid_598145 = query.getOrDefault("fields")
  valid_598145 = validateParameter(valid_598145, JString, required = false,
                                 default = nil)
  if valid_598145 != nil:
    section.add "fields", valid_598145
  var valid_598146 = query.getOrDefault("quotaUser")
  valid_598146 = validateParameter(valid_598146, JString, required = false,
                                 default = nil)
  if valid_598146 != nil:
    section.add "quotaUser", valid_598146
  var valid_598147 = query.getOrDefault("alt")
  valid_598147 = validateParameter(valid_598147, JString, required = false,
                                 default = newJString("json"))
  if valid_598147 != nil:
    section.add "alt", valid_598147
  var valid_598148 = query.getOrDefault("range")
  valid_598148 = validateParameter(valid_598148, JArray, required = false,
                                 default = nil)
  if valid_598148 != nil:
    section.add "range", valid_598148
  var valid_598149 = query.getOrDefault("oauth_token")
  valid_598149 = validateParameter(valid_598149, JString, required = false,
                                 default = nil)
  if valid_598149 != nil:
    section.add "oauth_token", valid_598149
  var valid_598150 = query.getOrDefault("userIp")
  valid_598150 = validateParameter(valid_598150, JString, required = false,
                                 default = nil)
  if valid_598150 != nil:
    section.add "userIp", valid_598150
  var valid_598151 = query.getOrDefault("key")
  valid_598151 = validateParameter(valid_598151, JString, required = false,
                                 default = nil)
  if valid_598151 != nil:
    section.add "key", valid_598151
  var valid_598152 = query.getOrDefault("prettyPrint")
  valid_598152 = validateParameter(valid_598152, JBool, required = false,
                                 default = newJBool(true))
  if valid_598152 != nil:
    section.add "prettyPrint", valid_598152
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598153: Call_BloggerPageViewsGet_598141; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve pageview stats for a Blog.
  ## 
  let valid = call_598153.validator(path, query, header, formData, body)
  let scheme = call_598153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598153.url(scheme.get, call_598153.host, call_598153.base,
                         call_598153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598153, url, valid)

proc call*(call_598154: Call_BloggerPageViewsGet_598141; blogId: string;
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
  var path_598155 = newJObject()
  var query_598156 = newJObject()
  add(query_598156, "fields", newJString(fields))
  add(query_598156, "quotaUser", newJString(quotaUser))
  add(query_598156, "alt", newJString(alt))
  if range != nil:
    query_598156.add "range", range
  add(query_598156, "oauth_token", newJString(oauthToken))
  add(query_598156, "userIp", newJString(userIp))
  add(query_598156, "key", newJString(key))
  add(path_598155, "blogId", newJString(blogId))
  add(query_598156, "prettyPrint", newJBool(prettyPrint))
  result = call_598154.call(path_598155, query_598156, nil, nil, nil)

var bloggerPageViewsGet* = Call_BloggerPageViewsGet_598141(
    name: "bloggerPageViewsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/blogs/{blogId}/pageviews",
    validator: validate_BloggerPageViewsGet_598142, base: "/blogger/v3",
    url: url_BloggerPageViewsGet_598143, schemes: {Scheme.Https})
type
  Call_BloggerPostsInsert_598182 = ref object of OpenApiRestCall_597408
proc url_BloggerPostsInsert_598184(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BloggerPostsInsert_598183(path: JsonNode; query: JsonNode;
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
  var valid_598185 = path.getOrDefault("blogId")
  valid_598185 = validateParameter(valid_598185, JString, required = true,
                                 default = nil)
  if valid_598185 != nil:
    section.add "blogId", valid_598185
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
  var valid_598186 = query.getOrDefault("fetchBody")
  valid_598186 = validateParameter(valid_598186, JBool, required = false,
                                 default = newJBool(true))
  if valid_598186 != nil:
    section.add "fetchBody", valid_598186
  var valid_598187 = query.getOrDefault("fields")
  valid_598187 = validateParameter(valid_598187, JString, required = false,
                                 default = nil)
  if valid_598187 != nil:
    section.add "fields", valid_598187
  var valid_598188 = query.getOrDefault("quotaUser")
  valid_598188 = validateParameter(valid_598188, JString, required = false,
                                 default = nil)
  if valid_598188 != nil:
    section.add "quotaUser", valid_598188
  var valid_598189 = query.getOrDefault("fetchImages")
  valid_598189 = validateParameter(valid_598189, JBool, required = false, default = nil)
  if valid_598189 != nil:
    section.add "fetchImages", valid_598189
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
  var valid_598192 = query.getOrDefault("isDraft")
  valid_598192 = validateParameter(valid_598192, JBool, required = false, default = nil)
  if valid_598192 != nil:
    section.add "isDraft", valid_598192
  var valid_598193 = query.getOrDefault("userIp")
  valid_598193 = validateParameter(valid_598193, JString, required = false,
                                 default = nil)
  if valid_598193 != nil:
    section.add "userIp", valid_598193
  var valid_598194 = query.getOrDefault("key")
  valid_598194 = validateParameter(valid_598194, JString, required = false,
                                 default = nil)
  if valid_598194 != nil:
    section.add "key", valid_598194
  var valid_598195 = query.getOrDefault("prettyPrint")
  valid_598195 = validateParameter(valid_598195, JBool, required = false,
                                 default = newJBool(true))
  if valid_598195 != nil:
    section.add "prettyPrint", valid_598195
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

proc call*(call_598197: Call_BloggerPostsInsert_598182; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a post.
  ## 
  let valid = call_598197.validator(path, query, header, formData, body)
  let scheme = call_598197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598197.url(scheme.get, call_598197.host, call_598197.base,
                         call_598197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598197, url, valid)

proc call*(call_598198: Call_BloggerPostsInsert_598182; blogId: string;
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
  var path_598199 = newJObject()
  var query_598200 = newJObject()
  var body_598201 = newJObject()
  add(query_598200, "fetchBody", newJBool(fetchBody))
  add(query_598200, "fields", newJString(fields))
  add(query_598200, "quotaUser", newJString(quotaUser))
  add(query_598200, "fetchImages", newJBool(fetchImages))
  add(query_598200, "alt", newJString(alt))
  add(query_598200, "oauth_token", newJString(oauthToken))
  add(query_598200, "isDraft", newJBool(isDraft))
  add(query_598200, "userIp", newJString(userIp))
  add(query_598200, "key", newJString(key))
  add(path_598199, "blogId", newJString(blogId))
  if body != nil:
    body_598201 = body
  add(query_598200, "prettyPrint", newJBool(prettyPrint))
  result = call_598198.call(path_598199, query_598200, nil, nil, body_598201)

var bloggerPostsInsert* = Call_BloggerPostsInsert_598182(
    name: "bloggerPostsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/blogs/{blogId}/posts",
    validator: validate_BloggerPostsInsert_598183, base: "/blogger/v3",
    url: url_BloggerPostsInsert_598184, schemes: {Scheme.Https})
type
  Call_BloggerPostsList_598157 = ref object of OpenApiRestCall_597408
proc url_BloggerPostsList_598159(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BloggerPostsList_598158(path: JsonNode; query: JsonNode;
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
  var valid_598160 = path.getOrDefault("blogId")
  valid_598160 = validateParameter(valid_598160, JString, required = true,
                                 default = nil)
  if valid_598160 != nil:
    section.add "blogId", valid_598160
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
  var valid_598161 = query.getOrDefault("fields")
  valid_598161 = validateParameter(valid_598161, JString, required = false,
                                 default = nil)
  if valid_598161 != nil:
    section.add "fields", valid_598161
  var valid_598162 = query.getOrDefault("pageToken")
  valid_598162 = validateParameter(valid_598162, JString, required = false,
                                 default = nil)
  if valid_598162 != nil:
    section.add "pageToken", valid_598162
  var valid_598163 = query.getOrDefault("quotaUser")
  valid_598163 = validateParameter(valid_598163, JString, required = false,
                                 default = nil)
  if valid_598163 != nil:
    section.add "quotaUser", valid_598163
  var valid_598164 = query.getOrDefault("view")
  valid_598164 = validateParameter(valid_598164, JString, required = false,
                                 default = newJString("ADMIN"))
  if valid_598164 != nil:
    section.add "view", valid_598164
  var valid_598165 = query.getOrDefault("fetchImages")
  valid_598165 = validateParameter(valid_598165, JBool, required = false, default = nil)
  if valid_598165 != nil:
    section.add "fetchImages", valid_598165
  var valid_598166 = query.getOrDefault("alt")
  valid_598166 = validateParameter(valid_598166, JString, required = false,
                                 default = newJString("json"))
  if valid_598166 != nil:
    section.add "alt", valid_598166
  var valid_598167 = query.getOrDefault("endDate")
  valid_598167 = validateParameter(valid_598167, JString, required = false,
                                 default = nil)
  if valid_598167 != nil:
    section.add "endDate", valid_598167
  var valid_598168 = query.getOrDefault("startDate")
  valid_598168 = validateParameter(valid_598168, JString, required = false,
                                 default = nil)
  if valid_598168 != nil:
    section.add "startDate", valid_598168
  var valid_598169 = query.getOrDefault("oauth_token")
  valid_598169 = validateParameter(valid_598169, JString, required = false,
                                 default = nil)
  if valid_598169 != nil:
    section.add "oauth_token", valid_598169
  var valid_598170 = query.getOrDefault("userIp")
  valid_598170 = validateParameter(valid_598170, JString, required = false,
                                 default = nil)
  if valid_598170 != nil:
    section.add "userIp", valid_598170
  var valid_598171 = query.getOrDefault("maxResults")
  valid_598171 = validateParameter(valid_598171, JInt, required = false, default = nil)
  if valid_598171 != nil:
    section.add "maxResults", valid_598171
  var valid_598172 = query.getOrDefault("orderBy")
  valid_598172 = validateParameter(valid_598172, JString, required = false,
                                 default = newJString("published"))
  if valid_598172 != nil:
    section.add "orderBy", valid_598172
  var valid_598173 = query.getOrDefault("key")
  valid_598173 = validateParameter(valid_598173, JString, required = false,
                                 default = nil)
  if valid_598173 != nil:
    section.add "key", valid_598173
  var valid_598174 = query.getOrDefault("labels")
  valid_598174 = validateParameter(valid_598174, JString, required = false,
                                 default = nil)
  if valid_598174 != nil:
    section.add "labels", valid_598174
  var valid_598175 = query.getOrDefault("status")
  valid_598175 = validateParameter(valid_598175, JArray, required = false,
                                 default = nil)
  if valid_598175 != nil:
    section.add "status", valid_598175
  var valid_598176 = query.getOrDefault("fetchBodies")
  valid_598176 = validateParameter(valid_598176, JBool, required = false,
                                 default = newJBool(true))
  if valid_598176 != nil:
    section.add "fetchBodies", valid_598176
  var valid_598177 = query.getOrDefault("prettyPrint")
  valid_598177 = validateParameter(valid_598177, JBool, required = false,
                                 default = newJBool(true))
  if valid_598177 != nil:
    section.add "prettyPrint", valid_598177
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598178: Call_BloggerPostsList_598157; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of posts, possibly filtered.
  ## 
  let valid = call_598178.validator(path, query, header, formData, body)
  let scheme = call_598178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598178.url(scheme.get, call_598178.host, call_598178.base,
                         call_598178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598178, url, valid)

proc call*(call_598179: Call_BloggerPostsList_598157; blogId: string;
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
  var path_598180 = newJObject()
  var query_598181 = newJObject()
  add(query_598181, "fields", newJString(fields))
  add(query_598181, "pageToken", newJString(pageToken))
  add(query_598181, "quotaUser", newJString(quotaUser))
  add(query_598181, "view", newJString(view))
  add(query_598181, "fetchImages", newJBool(fetchImages))
  add(query_598181, "alt", newJString(alt))
  add(query_598181, "endDate", newJString(endDate))
  add(query_598181, "startDate", newJString(startDate))
  add(query_598181, "oauth_token", newJString(oauthToken))
  add(query_598181, "userIp", newJString(userIp))
  add(query_598181, "maxResults", newJInt(maxResults))
  add(query_598181, "orderBy", newJString(orderBy))
  add(query_598181, "key", newJString(key))
  add(query_598181, "labels", newJString(labels))
  if status != nil:
    query_598181.add "status", status
  add(query_598181, "fetchBodies", newJBool(fetchBodies))
  add(path_598180, "blogId", newJString(blogId))
  add(query_598181, "prettyPrint", newJBool(prettyPrint))
  result = call_598179.call(path_598180, query_598181, nil, nil, nil)

var bloggerPostsList* = Call_BloggerPostsList_598157(name: "bloggerPostsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/blogs/{blogId}/posts", validator: validate_BloggerPostsList_598158,
    base: "/blogger/v3", url: url_BloggerPostsList_598159, schemes: {Scheme.Https})
type
  Call_BloggerPostsGetByPath_598202 = ref object of OpenApiRestCall_597408
proc url_BloggerPostsGetByPath_598204(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BloggerPostsGetByPath_598203(path: JsonNode; query: JsonNode;
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
  var valid_598205 = path.getOrDefault("blogId")
  valid_598205 = validateParameter(valid_598205, JString, required = true,
                                 default = nil)
  if valid_598205 != nil:
    section.add "blogId", valid_598205
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
  var valid_598206 = query.getOrDefault("fields")
  valid_598206 = validateParameter(valid_598206, JString, required = false,
                                 default = nil)
  if valid_598206 != nil:
    section.add "fields", valid_598206
  var valid_598207 = query.getOrDefault("view")
  valid_598207 = validateParameter(valid_598207, JString, required = false,
                                 default = newJString("ADMIN"))
  if valid_598207 != nil:
    section.add "view", valid_598207
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
  var valid_598212 = query.getOrDefault("maxComments")
  valid_598212 = validateParameter(valid_598212, JInt, required = false, default = nil)
  if valid_598212 != nil:
    section.add "maxComments", valid_598212
  assert query != nil, "query argument is necessary due to required `path` field"
  var valid_598213 = query.getOrDefault("path")
  valid_598213 = validateParameter(valid_598213, JString, required = true,
                                 default = nil)
  if valid_598213 != nil:
    section.add "path", valid_598213
  var valid_598214 = query.getOrDefault("key")
  valid_598214 = validateParameter(valid_598214, JString, required = false,
                                 default = nil)
  if valid_598214 != nil:
    section.add "key", valid_598214
  var valid_598215 = query.getOrDefault("prettyPrint")
  valid_598215 = validateParameter(valid_598215, JBool, required = false,
                                 default = newJBool(true))
  if valid_598215 != nil:
    section.add "prettyPrint", valid_598215
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598216: Call_BloggerPostsGetByPath_598202; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a Post by Path.
  ## 
  let valid = call_598216.validator(path, query, header, formData, body)
  let scheme = call_598216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598216.url(scheme.get, call_598216.host, call_598216.base,
                         call_598216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598216, url, valid)

proc call*(call_598217: Call_BloggerPostsGetByPath_598202; path: string;
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
  var path_598218 = newJObject()
  var query_598219 = newJObject()
  add(query_598219, "fields", newJString(fields))
  add(query_598219, "view", newJString(view))
  add(query_598219, "quotaUser", newJString(quotaUser))
  add(query_598219, "alt", newJString(alt))
  add(query_598219, "oauth_token", newJString(oauthToken))
  add(query_598219, "userIp", newJString(userIp))
  add(query_598219, "maxComments", newJInt(maxComments))
  add(query_598219, "path", newJString(path))
  add(query_598219, "key", newJString(key))
  add(path_598218, "blogId", newJString(blogId))
  add(query_598219, "prettyPrint", newJBool(prettyPrint))
  result = call_598217.call(path_598218, query_598219, nil, nil, nil)

var bloggerPostsGetByPath* = Call_BloggerPostsGetByPath_598202(
    name: "bloggerPostsGetByPath", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/blogs/{blogId}/posts/bypath",
    validator: validate_BloggerPostsGetByPath_598203, base: "/blogger/v3",
    url: url_BloggerPostsGetByPath_598204, schemes: {Scheme.Https})
type
  Call_BloggerPostsSearch_598220 = ref object of OpenApiRestCall_597408
proc url_BloggerPostsSearch_598222(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BloggerPostsSearch_598221(path: JsonNode; query: JsonNode;
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
  var valid_598223 = path.getOrDefault("blogId")
  valid_598223 = validateParameter(valid_598223, JString, required = true,
                                 default = nil)
  if valid_598223 != nil:
    section.add "blogId", valid_598223
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
  var valid_598224 = query.getOrDefault("fields")
  valid_598224 = validateParameter(valid_598224, JString, required = false,
                                 default = nil)
  if valid_598224 != nil:
    section.add "fields", valid_598224
  var valid_598225 = query.getOrDefault("quotaUser")
  valid_598225 = validateParameter(valid_598225, JString, required = false,
                                 default = nil)
  if valid_598225 != nil:
    section.add "quotaUser", valid_598225
  var valid_598226 = query.getOrDefault("alt")
  valid_598226 = validateParameter(valid_598226, JString, required = false,
                                 default = newJString("json"))
  if valid_598226 != nil:
    section.add "alt", valid_598226
  var valid_598227 = query.getOrDefault("oauth_token")
  valid_598227 = validateParameter(valid_598227, JString, required = false,
                                 default = nil)
  if valid_598227 != nil:
    section.add "oauth_token", valid_598227
  var valid_598228 = query.getOrDefault("userIp")
  valid_598228 = validateParameter(valid_598228, JString, required = false,
                                 default = nil)
  if valid_598228 != nil:
    section.add "userIp", valid_598228
  var valid_598229 = query.getOrDefault("orderBy")
  valid_598229 = validateParameter(valid_598229, JString, required = false,
                                 default = newJString("published"))
  if valid_598229 != nil:
    section.add "orderBy", valid_598229
  assert query != nil, "query argument is necessary due to required `q` field"
  var valid_598230 = query.getOrDefault("q")
  valid_598230 = validateParameter(valid_598230, JString, required = true,
                                 default = nil)
  if valid_598230 != nil:
    section.add "q", valid_598230
  var valid_598231 = query.getOrDefault("key")
  valid_598231 = validateParameter(valid_598231, JString, required = false,
                                 default = nil)
  if valid_598231 != nil:
    section.add "key", valid_598231
  var valid_598232 = query.getOrDefault("fetchBodies")
  valid_598232 = validateParameter(valid_598232, JBool, required = false,
                                 default = newJBool(true))
  if valid_598232 != nil:
    section.add "fetchBodies", valid_598232
  var valid_598233 = query.getOrDefault("prettyPrint")
  valid_598233 = validateParameter(valid_598233, JBool, required = false,
                                 default = newJBool(true))
  if valid_598233 != nil:
    section.add "prettyPrint", valid_598233
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598234: Call_BloggerPostsSearch_598220; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Search for a post.
  ## 
  let valid = call_598234.validator(path, query, header, formData, body)
  let scheme = call_598234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598234.url(scheme.get, call_598234.host, call_598234.base,
                         call_598234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598234, url, valid)

proc call*(call_598235: Call_BloggerPostsSearch_598220; q: string; blogId: string;
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
  var path_598236 = newJObject()
  var query_598237 = newJObject()
  add(query_598237, "fields", newJString(fields))
  add(query_598237, "quotaUser", newJString(quotaUser))
  add(query_598237, "alt", newJString(alt))
  add(query_598237, "oauth_token", newJString(oauthToken))
  add(query_598237, "userIp", newJString(userIp))
  add(query_598237, "orderBy", newJString(orderBy))
  add(query_598237, "q", newJString(q))
  add(query_598237, "key", newJString(key))
  add(query_598237, "fetchBodies", newJBool(fetchBodies))
  add(path_598236, "blogId", newJString(blogId))
  add(query_598237, "prettyPrint", newJBool(prettyPrint))
  result = call_598235.call(path_598236, query_598237, nil, nil, nil)

var bloggerPostsSearch* = Call_BloggerPostsSearch_598220(
    name: "bloggerPostsSearch", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/blogs/{blogId}/posts/search",
    validator: validate_BloggerPostsSearch_598221, base: "/blogger/v3",
    url: url_BloggerPostsSearch_598222, schemes: {Scheme.Https})
type
  Call_BloggerPostsUpdate_598258 = ref object of OpenApiRestCall_597408
proc url_BloggerPostsUpdate_598260(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BloggerPostsUpdate_598259(path: JsonNode; query: JsonNode;
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
  var valid_598261 = path.getOrDefault("postId")
  valid_598261 = validateParameter(valid_598261, JString, required = true,
                                 default = nil)
  if valid_598261 != nil:
    section.add "postId", valid_598261
  var valid_598262 = path.getOrDefault("blogId")
  valid_598262 = validateParameter(valid_598262, JString, required = true,
                                 default = nil)
  if valid_598262 != nil:
    section.add "blogId", valid_598262
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
  var valid_598263 = query.getOrDefault("revert")
  valid_598263 = validateParameter(valid_598263, JBool, required = false, default = nil)
  if valid_598263 != nil:
    section.add "revert", valid_598263
  var valid_598264 = query.getOrDefault("fetchBody")
  valid_598264 = validateParameter(valid_598264, JBool, required = false,
                                 default = newJBool(true))
  if valid_598264 != nil:
    section.add "fetchBody", valid_598264
  var valid_598265 = query.getOrDefault("fields")
  valid_598265 = validateParameter(valid_598265, JString, required = false,
                                 default = nil)
  if valid_598265 != nil:
    section.add "fields", valid_598265
  var valid_598266 = query.getOrDefault("quotaUser")
  valid_598266 = validateParameter(valid_598266, JString, required = false,
                                 default = nil)
  if valid_598266 != nil:
    section.add "quotaUser", valid_598266
  var valid_598267 = query.getOrDefault("fetchImages")
  valid_598267 = validateParameter(valid_598267, JBool, required = false, default = nil)
  if valid_598267 != nil:
    section.add "fetchImages", valid_598267
  var valid_598268 = query.getOrDefault("alt")
  valid_598268 = validateParameter(valid_598268, JString, required = false,
                                 default = newJString("json"))
  if valid_598268 != nil:
    section.add "alt", valid_598268
  var valid_598269 = query.getOrDefault("oauth_token")
  valid_598269 = validateParameter(valid_598269, JString, required = false,
                                 default = nil)
  if valid_598269 != nil:
    section.add "oauth_token", valid_598269
  var valid_598270 = query.getOrDefault("userIp")
  valid_598270 = validateParameter(valid_598270, JString, required = false,
                                 default = nil)
  if valid_598270 != nil:
    section.add "userIp", valid_598270
  var valid_598271 = query.getOrDefault("maxComments")
  valid_598271 = validateParameter(valid_598271, JInt, required = false, default = nil)
  if valid_598271 != nil:
    section.add "maxComments", valid_598271
  var valid_598272 = query.getOrDefault("key")
  valid_598272 = validateParameter(valid_598272, JString, required = false,
                                 default = nil)
  if valid_598272 != nil:
    section.add "key", valid_598272
  var valid_598273 = query.getOrDefault("publish")
  valid_598273 = validateParameter(valid_598273, JBool, required = false, default = nil)
  if valid_598273 != nil:
    section.add "publish", valid_598273
  var valid_598274 = query.getOrDefault("prettyPrint")
  valid_598274 = validateParameter(valid_598274, JBool, required = false,
                                 default = newJBool(true))
  if valid_598274 != nil:
    section.add "prettyPrint", valid_598274
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

proc call*(call_598276: Call_BloggerPostsUpdate_598258; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a post.
  ## 
  let valid = call_598276.validator(path, query, header, formData, body)
  let scheme = call_598276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598276.url(scheme.get, call_598276.host, call_598276.base,
                         call_598276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598276, url, valid)

proc call*(call_598277: Call_BloggerPostsUpdate_598258; postId: string;
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
  var path_598278 = newJObject()
  var query_598279 = newJObject()
  var body_598280 = newJObject()
  add(query_598279, "revert", newJBool(revert))
  add(query_598279, "fetchBody", newJBool(fetchBody))
  add(query_598279, "fields", newJString(fields))
  add(query_598279, "quotaUser", newJString(quotaUser))
  add(query_598279, "fetchImages", newJBool(fetchImages))
  add(query_598279, "alt", newJString(alt))
  add(query_598279, "oauth_token", newJString(oauthToken))
  add(query_598279, "userIp", newJString(userIp))
  add(query_598279, "maxComments", newJInt(maxComments))
  add(query_598279, "key", newJString(key))
  add(path_598278, "postId", newJString(postId))
  add(query_598279, "publish", newJBool(publish))
  add(path_598278, "blogId", newJString(blogId))
  if body != nil:
    body_598280 = body
  add(query_598279, "prettyPrint", newJBool(prettyPrint))
  result = call_598277.call(path_598278, query_598279, nil, nil, body_598280)

var bloggerPostsUpdate* = Call_BloggerPostsUpdate_598258(
    name: "bloggerPostsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/blogs/{blogId}/posts/{postId}",
    validator: validate_BloggerPostsUpdate_598259, base: "/blogger/v3",
    url: url_BloggerPostsUpdate_598260, schemes: {Scheme.Https})
type
  Call_BloggerPostsGet_598238 = ref object of OpenApiRestCall_597408
proc url_BloggerPostsGet_598240(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BloggerPostsGet_598239(path: JsonNode; query: JsonNode;
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
  var valid_598241 = path.getOrDefault("postId")
  valid_598241 = validateParameter(valid_598241, JString, required = true,
                                 default = nil)
  if valid_598241 != nil:
    section.add "postId", valid_598241
  var valid_598242 = path.getOrDefault("blogId")
  valid_598242 = validateParameter(valid_598242, JString, required = true,
                                 default = nil)
  if valid_598242 != nil:
    section.add "blogId", valid_598242
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
  var valid_598243 = query.getOrDefault("fetchBody")
  valid_598243 = validateParameter(valid_598243, JBool, required = false,
                                 default = newJBool(true))
  if valid_598243 != nil:
    section.add "fetchBody", valid_598243
  var valid_598244 = query.getOrDefault("fields")
  valid_598244 = validateParameter(valid_598244, JString, required = false,
                                 default = nil)
  if valid_598244 != nil:
    section.add "fields", valid_598244
  var valid_598245 = query.getOrDefault("view")
  valid_598245 = validateParameter(valid_598245, JString, required = false,
                                 default = newJString("ADMIN"))
  if valid_598245 != nil:
    section.add "view", valid_598245
  var valid_598246 = query.getOrDefault("quotaUser")
  valid_598246 = validateParameter(valid_598246, JString, required = false,
                                 default = nil)
  if valid_598246 != nil:
    section.add "quotaUser", valid_598246
  var valid_598247 = query.getOrDefault("fetchImages")
  valid_598247 = validateParameter(valid_598247, JBool, required = false, default = nil)
  if valid_598247 != nil:
    section.add "fetchImages", valid_598247
  var valid_598248 = query.getOrDefault("alt")
  valid_598248 = validateParameter(valid_598248, JString, required = false,
                                 default = newJString("json"))
  if valid_598248 != nil:
    section.add "alt", valid_598248
  var valid_598249 = query.getOrDefault("oauth_token")
  valid_598249 = validateParameter(valid_598249, JString, required = false,
                                 default = nil)
  if valid_598249 != nil:
    section.add "oauth_token", valid_598249
  var valid_598250 = query.getOrDefault("userIp")
  valid_598250 = validateParameter(valid_598250, JString, required = false,
                                 default = nil)
  if valid_598250 != nil:
    section.add "userIp", valid_598250
  var valid_598251 = query.getOrDefault("maxComments")
  valid_598251 = validateParameter(valid_598251, JInt, required = false, default = nil)
  if valid_598251 != nil:
    section.add "maxComments", valid_598251
  var valid_598252 = query.getOrDefault("key")
  valid_598252 = validateParameter(valid_598252, JString, required = false,
                                 default = nil)
  if valid_598252 != nil:
    section.add "key", valid_598252
  var valid_598253 = query.getOrDefault("prettyPrint")
  valid_598253 = validateParameter(valid_598253, JBool, required = false,
                                 default = newJBool(true))
  if valid_598253 != nil:
    section.add "prettyPrint", valid_598253
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598254: Call_BloggerPostsGet_598238; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a post by ID.
  ## 
  let valid = call_598254.validator(path, query, header, formData, body)
  let scheme = call_598254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598254.url(scheme.get, call_598254.host, call_598254.base,
                         call_598254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598254, url, valid)

proc call*(call_598255: Call_BloggerPostsGet_598238; postId: string; blogId: string;
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
  var path_598256 = newJObject()
  var query_598257 = newJObject()
  add(query_598257, "fetchBody", newJBool(fetchBody))
  add(query_598257, "fields", newJString(fields))
  add(query_598257, "view", newJString(view))
  add(query_598257, "quotaUser", newJString(quotaUser))
  add(query_598257, "fetchImages", newJBool(fetchImages))
  add(query_598257, "alt", newJString(alt))
  add(query_598257, "oauth_token", newJString(oauthToken))
  add(query_598257, "userIp", newJString(userIp))
  add(query_598257, "maxComments", newJInt(maxComments))
  add(query_598257, "key", newJString(key))
  add(path_598256, "postId", newJString(postId))
  add(path_598256, "blogId", newJString(blogId))
  add(query_598257, "prettyPrint", newJBool(prettyPrint))
  result = call_598255.call(path_598256, query_598257, nil, nil, nil)

var bloggerPostsGet* = Call_BloggerPostsGet_598238(name: "bloggerPostsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/blogs/{blogId}/posts/{postId}", validator: validate_BloggerPostsGet_598239,
    base: "/blogger/v3", url: url_BloggerPostsGet_598240, schemes: {Scheme.Https})
type
  Call_BloggerPostsPatch_598297 = ref object of OpenApiRestCall_597408
proc url_BloggerPostsPatch_598299(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BloggerPostsPatch_598298(path: JsonNode; query: JsonNode;
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
  var valid_598300 = path.getOrDefault("postId")
  valid_598300 = validateParameter(valid_598300, JString, required = true,
                                 default = nil)
  if valid_598300 != nil:
    section.add "postId", valid_598300
  var valid_598301 = path.getOrDefault("blogId")
  valid_598301 = validateParameter(valid_598301, JString, required = true,
                                 default = nil)
  if valid_598301 != nil:
    section.add "blogId", valid_598301
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
  var valid_598302 = query.getOrDefault("revert")
  valid_598302 = validateParameter(valid_598302, JBool, required = false, default = nil)
  if valid_598302 != nil:
    section.add "revert", valid_598302
  var valid_598303 = query.getOrDefault("fetchBody")
  valid_598303 = validateParameter(valid_598303, JBool, required = false,
                                 default = newJBool(true))
  if valid_598303 != nil:
    section.add "fetchBody", valid_598303
  var valid_598304 = query.getOrDefault("fields")
  valid_598304 = validateParameter(valid_598304, JString, required = false,
                                 default = nil)
  if valid_598304 != nil:
    section.add "fields", valid_598304
  var valid_598305 = query.getOrDefault("quotaUser")
  valid_598305 = validateParameter(valid_598305, JString, required = false,
                                 default = nil)
  if valid_598305 != nil:
    section.add "quotaUser", valid_598305
  var valid_598306 = query.getOrDefault("fetchImages")
  valid_598306 = validateParameter(valid_598306, JBool, required = false, default = nil)
  if valid_598306 != nil:
    section.add "fetchImages", valid_598306
  var valid_598307 = query.getOrDefault("alt")
  valid_598307 = validateParameter(valid_598307, JString, required = false,
                                 default = newJString("json"))
  if valid_598307 != nil:
    section.add "alt", valid_598307
  var valid_598308 = query.getOrDefault("oauth_token")
  valid_598308 = validateParameter(valid_598308, JString, required = false,
                                 default = nil)
  if valid_598308 != nil:
    section.add "oauth_token", valid_598308
  var valid_598309 = query.getOrDefault("userIp")
  valid_598309 = validateParameter(valid_598309, JString, required = false,
                                 default = nil)
  if valid_598309 != nil:
    section.add "userIp", valid_598309
  var valid_598310 = query.getOrDefault("maxComments")
  valid_598310 = validateParameter(valid_598310, JInt, required = false, default = nil)
  if valid_598310 != nil:
    section.add "maxComments", valid_598310
  var valid_598311 = query.getOrDefault("key")
  valid_598311 = validateParameter(valid_598311, JString, required = false,
                                 default = nil)
  if valid_598311 != nil:
    section.add "key", valid_598311
  var valid_598312 = query.getOrDefault("publish")
  valid_598312 = validateParameter(valid_598312, JBool, required = false, default = nil)
  if valid_598312 != nil:
    section.add "publish", valid_598312
  var valid_598313 = query.getOrDefault("prettyPrint")
  valid_598313 = validateParameter(valid_598313, JBool, required = false,
                                 default = newJBool(true))
  if valid_598313 != nil:
    section.add "prettyPrint", valid_598313
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

proc call*(call_598315: Call_BloggerPostsPatch_598297; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a post. This method supports patch semantics.
  ## 
  let valid = call_598315.validator(path, query, header, formData, body)
  let scheme = call_598315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598315.url(scheme.get, call_598315.host, call_598315.base,
                         call_598315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598315, url, valid)

proc call*(call_598316: Call_BloggerPostsPatch_598297; postId: string;
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
  var path_598317 = newJObject()
  var query_598318 = newJObject()
  var body_598319 = newJObject()
  add(query_598318, "revert", newJBool(revert))
  add(query_598318, "fetchBody", newJBool(fetchBody))
  add(query_598318, "fields", newJString(fields))
  add(query_598318, "quotaUser", newJString(quotaUser))
  add(query_598318, "fetchImages", newJBool(fetchImages))
  add(query_598318, "alt", newJString(alt))
  add(query_598318, "oauth_token", newJString(oauthToken))
  add(query_598318, "userIp", newJString(userIp))
  add(query_598318, "maxComments", newJInt(maxComments))
  add(query_598318, "key", newJString(key))
  add(path_598317, "postId", newJString(postId))
  add(query_598318, "publish", newJBool(publish))
  add(path_598317, "blogId", newJString(blogId))
  if body != nil:
    body_598319 = body
  add(query_598318, "prettyPrint", newJBool(prettyPrint))
  result = call_598316.call(path_598317, query_598318, nil, nil, body_598319)

var bloggerPostsPatch* = Call_BloggerPostsPatch_598297(name: "bloggerPostsPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/blogs/{blogId}/posts/{postId}",
    validator: validate_BloggerPostsPatch_598298, base: "/blogger/v3",
    url: url_BloggerPostsPatch_598299, schemes: {Scheme.Https})
type
  Call_BloggerPostsDelete_598281 = ref object of OpenApiRestCall_597408
proc url_BloggerPostsDelete_598283(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BloggerPostsDelete_598282(path: JsonNode; query: JsonNode;
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
  var valid_598284 = path.getOrDefault("postId")
  valid_598284 = validateParameter(valid_598284, JString, required = true,
                                 default = nil)
  if valid_598284 != nil:
    section.add "postId", valid_598284
  var valid_598285 = path.getOrDefault("blogId")
  valid_598285 = validateParameter(valid_598285, JString, required = true,
                                 default = nil)
  if valid_598285 != nil:
    section.add "blogId", valid_598285
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
  var valid_598286 = query.getOrDefault("fields")
  valid_598286 = validateParameter(valid_598286, JString, required = false,
                                 default = nil)
  if valid_598286 != nil:
    section.add "fields", valid_598286
  var valid_598287 = query.getOrDefault("quotaUser")
  valid_598287 = validateParameter(valid_598287, JString, required = false,
                                 default = nil)
  if valid_598287 != nil:
    section.add "quotaUser", valid_598287
  var valid_598288 = query.getOrDefault("alt")
  valid_598288 = validateParameter(valid_598288, JString, required = false,
                                 default = newJString("json"))
  if valid_598288 != nil:
    section.add "alt", valid_598288
  var valid_598289 = query.getOrDefault("oauth_token")
  valid_598289 = validateParameter(valid_598289, JString, required = false,
                                 default = nil)
  if valid_598289 != nil:
    section.add "oauth_token", valid_598289
  var valid_598290 = query.getOrDefault("userIp")
  valid_598290 = validateParameter(valid_598290, JString, required = false,
                                 default = nil)
  if valid_598290 != nil:
    section.add "userIp", valid_598290
  var valid_598291 = query.getOrDefault("key")
  valid_598291 = validateParameter(valid_598291, JString, required = false,
                                 default = nil)
  if valid_598291 != nil:
    section.add "key", valid_598291
  var valid_598292 = query.getOrDefault("prettyPrint")
  valid_598292 = validateParameter(valid_598292, JBool, required = false,
                                 default = newJBool(true))
  if valid_598292 != nil:
    section.add "prettyPrint", valid_598292
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598293: Call_BloggerPostsDelete_598281; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a post by ID.
  ## 
  let valid = call_598293.validator(path, query, header, formData, body)
  let scheme = call_598293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598293.url(scheme.get, call_598293.host, call_598293.base,
                         call_598293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598293, url, valid)

proc call*(call_598294: Call_BloggerPostsDelete_598281; postId: string;
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
  var path_598295 = newJObject()
  var query_598296 = newJObject()
  add(query_598296, "fields", newJString(fields))
  add(query_598296, "quotaUser", newJString(quotaUser))
  add(query_598296, "alt", newJString(alt))
  add(query_598296, "oauth_token", newJString(oauthToken))
  add(query_598296, "userIp", newJString(userIp))
  add(query_598296, "key", newJString(key))
  add(path_598295, "postId", newJString(postId))
  add(path_598295, "blogId", newJString(blogId))
  add(query_598296, "prettyPrint", newJBool(prettyPrint))
  result = call_598294.call(path_598295, query_598296, nil, nil, nil)

var bloggerPostsDelete* = Call_BloggerPostsDelete_598281(
    name: "bloggerPostsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/blogs/{blogId}/posts/{postId}",
    validator: validate_BloggerPostsDelete_598282, base: "/blogger/v3",
    url: url_BloggerPostsDelete_598283, schemes: {Scheme.Https})
type
  Call_BloggerCommentsList_598320 = ref object of OpenApiRestCall_597408
proc url_BloggerCommentsList_598322(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BloggerCommentsList_598321(path: JsonNode; query: JsonNode;
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
  var valid_598323 = path.getOrDefault("postId")
  valid_598323 = validateParameter(valid_598323, JString, required = true,
                                 default = nil)
  if valid_598323 != nil:
    section.add "postId", valid_598323
  var valid_598324 = path.getOrDefault("blogId")
  valid_598324 = validateParameter(valid_598324, JString, required = true,
                                 default = nil)
  if valid_598324 != nil:
    section.add "blogId", valid_598324
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
  var valid_598325 = query.getOrDefault("fields")
  valid_598325 = validateParameter(valid_598325, JString, required = false,
                                 default = nil)
  if valid_598325 != nil:
    section.add "fields", valid_598325
  var valid_598326 = query.getOrDefault("pageToken")
  valid_598326 = validateParameter(valid_598326, JString, required = false,
                                 default = nil)
  if valid_598326 != nil:
    section.add "pageToken", valid_598326
  var valid_598327 = query.getOrDefault("quotaUser")
  valid_598327 = validateParameter(valid_598327, JString, required = false,
                                 default = nil)
  if valid_598327 != nil:
    section.add "quotaUser", valid_598327
  var valid_598328 = query.getOrDefault("view")
  valid_598328 = validateParameter(valid_598328, JString, required = false,
                                 default = newJString("ADMIN"))
  if valid_598328 != nil:
    section.add "view", valid_598328
  var valid_598329 = query.getOrDefault("alt")
  valid_598329 = validateParameter(valid_598329, JString, required = false,
                                 default = newJString("json"))
  if valid_598329 != nil:
    section.add "alt", valid_598329
  var valid_598330 = query.getOrDefault("endDate")
  valid_598330 = validateParameter(valid_598330, JString, required = false,
                                 default = nil)
  if valid_598330 != nil:
    section.add "endDate", valid_598330
  var valid_598331 = query.getOrDefault("startDate")
  valid_598331 = validateParameter(valid_598331, JString, required = false,
                                 default = nil)
  if valid_598331 != nil:
    section.add "startDate", valid_598331
  var valid_598332 = query.getOrDefault("oauth_token")
  valid_598332 = validateParameter(valid_598332, JString, required = false,
                                 default = nil)
  if valid_598332 != nil:
    section.add "oauth_token", valid_598332
  var valid_598333 = query.getOrDefault("userIp")
  valid_598333 = validateParameter(valid_598333, JString, required = false,
                                 default = nil)
  if valid_598333 != nil:
    section.add "userIp", valid_598333
  var valid_598334 = query.getOrDefault("maxResults")
  valid_598334 = validateParameter(valid_598334, JInt, required = false, default = nil)
  if valid_598334 != nil:
    section.add "maxResults", valid_598334
  var valid_598335 = query.getOrDefault("key")
  valid_598335 = validateParameter(valid_598335, JString, required = false,
                                 default = nil)
  if valid_598335 != nil:
    section.add "key", valid_598335
  var valid_598336 = query.getOrDefault("status")
  valid_598336 = validateParameter(valid_598336, JArray, required = false,
                                 default = nil)
  if valid_598336 != nil:
    section.add "status", valid_598336
  var valid_598337 = query.getOrDefault("fetchBodies")
  valid_598337 = validateParameter(valid_598337, JBool, required = false, default = nil)
  if valid_598337 != nil:
    section.add "fetchBodies", valid_598337
  var valid_598338 = query.getOrDefault("prettyPrint")
  valid_598338 = validateParameter(valid_598338, JBool, required = false,
                                 default = newJBool(true))
  if valid_598338 != nil:
    section.add "prettyPrint", valid_598338
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598339: Call_BloggerCommentsList_598320; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the comments for a post, possibly filtered.
  ## 
  let valid = call_598339.validator(path, query, header, formData, body)
  let scheme = call_598339.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598339.url(scheme.get, call_598339.host, call_598339.base,
                         call_598339.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598339, url, valid)

proc call*(call_598340: Call_BloggerCommentsList_598320; postId: string;
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
  var path_598341 = newJObject()
  var query_598342 = newJObject()
  add(query_598342, "fields", newJString(fields))
  add(query_598342, "pageToken", newJString(pageToken))
  add(query_598342, "quotaUser", newJString(quotaUser))
  add(query_598342, "view", newJString(view))
  add(query_598342, "alt", newJString(alt))
  add(query_598342, "endDate", newJString(endDate))
  add(query_598342, "startDate", newJString(startDate))
  add(query_598342, "oauth_token", newJString(oauthToken))
  add(query_598342, "userIp", newJString(userIp))
  add(query_598342, "maxResults", newJInt(maxResults))
  add(query_598342, "key", newJString(key))
  add(path_598341, "postId", newJString(postId))
  if status != nil:
    query_598342.add "status", status
  add(query_598342, "fetchBodies", newJBool(fetchBodies))
  add(path_598341, "blogId", newJString(blogId))
  add(query_598342, "prettyPrint", newJBool(prettyPrint))
  result = call_598340.call(path_598341, query_598342, nil, nil, nil)

var bloggerCommentsList* = Call_BloggerCommentsList_598320(
    name: "bloggerCommentsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/blogs/{blogId}/posts/{postId}/comments",
    validator: validate_BloggerCommentsList_598321, base: "/blogger/v3",
    url: url_BloggerCommentsList_598322, schemes: {Scheme.Https})
type
  Call_BloggerCommentsGet_598343 = ref object of OpenApiRestCall_597408
proc url_BloggerCommentsGet_598345(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BloggerCommentsGet_598344(path: JsonNode; query: JsonNode;
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
  var valid_598346 = path.getOrDefault("commentId")
  valid_598346 = validateParameter(valid_598346, JString, required = true,
                                 default = nil)
  if valid_598346 != nil:
    section.add "commentId", valid_598346
  var valid_598347 = path.getOrDefault("postId")
  valid_598347 = validateParameter(valid_598347, JString, required = true,
                                 default = nil)
  if valid_598347 != nil:
    section.add "postId", valid_598347
  var valid_598348 = path.getOrDefault("blogId")
  valid_598348 = validateParameter(valid_598348, JString, required = true,
                                 default = nil)
  if valid_598348 != nil:
    section.add "blogId", valid_598348
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
  var valid_598349 = query.getOrDefault("fields")
  valid_598349 = validateParameter(valid_598349, JString, required = false,
                                 default = nil)
  if valid_598349 != nil:
    section.add "fields", valid_598349
  var valid_598350 = query.getOrDefault("view")
  valid_598350 = validateParameter(valid_598350, JString, required = false,
                                 default = newJString("ADMIN"))
  if valid_598350 != nil:
    section.add "view", valid_598350
  var valid_598351 = query.getOrDefault("quotaUser")
  valid_598351 = validateParameter(valid_598351, JString, required = false,
                                 default = nil)
  if valid_598351 != nil:
    section.add "quotaUser", valid_598351
  var valid_598352 = query.getOrDefault("alt")
  valid_598352 = validateParameter(valid_598352, JString, required = false,
                                 default = newJString("json"))
  if valid_598352 != nil:
    section.add "alt", valid_598352
  var valid_598353 = query.getOrDefault("oauth_token")
  valid_598353 = validateParameter(valid_598353, JString, required = false,
                                 default = nil)
  if valid_598353 != nil:
    section.add "oauth_token", valid_598353
  var valid_598354 = query.getOrDefault("userIp")
  valid_598354 = validateParameter(valid_598354, JString, required = false,
                                 default = nil)
  if valid_598354 != nil:
    section.add "userIp", valid_598354
  var valid_598355 = query.getOrDefault("key")
  valid_598355 = validateParameter(valid_598355, JString, required = false,
                                 default = nil)
  if valid_598355 != nil:
    section.add "key", valid_598355
  var valid_598356 = query.getOrDefault("prettyPrint")
  valid_598356 = validateParameter(valid_598356, JBool, required = false,
                                 default = newJBool(true))
  if valid_598356 != nil:
    section.add "prettyPrint", valid_598356
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598357: Call_BloggerCommentsGet_598343; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one comment by ID.
  ## 
  let valid = call_598357.validator(path, query, header, formData, body)
  let scheme = call_598357.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598357.url(scheme.get, call_598357.host, call_598357.base,
                         call_598357.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598357, url, valid)

proc call*(call_598358: Call_BloggerCommentsGet_598343; commentId: string;
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
  var path_598359 = newJObject()
  var query_598360 = newJObject()
  add(query_598360, "fields", newJString(fields))
  add(query_598360, "view", newJString(view))
  add(query_598360, "quotaUser", newJString(quotaUser))
  add(query_598360, "alt", newJString(alt))
  add(query_598360, "oauth_token", newJString(oauthToken))
  add(query_598360, "userIp", newJString(userIp))
  add(query_598360, "key", newJString(key))
  add(path_598359, "commentId", newJString(commentId))
  add(path_598359, "postId", newJString(postId))
  add(path_598359, "blogId", newJString(blogId))
  add(query_598360, "prettyPrint", newJBool(prettyPrint))
  result = call_598358.call(path_598359, query_598360, nil, nil, nil)

var bloggerCommentsGet* = Call_BloggerCommentsGet_598343(
    name: "bloggerCommentsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/blogs/{blogId}/posts/{postId}/comments/{commentId}",
    validator: validate_BloggerCommentsGet_598344, base: "/blogger/v3",
    url: url_BloggerCommentsGet_598345, schemes: {Scheme.Https})
type
  Call_BloggerCommentsDelete_598361 = ref object of OpenApiRestCall_597408
proc url_BloggerCommentsDelete_598363(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BloggerCommentsDelete_598362(path: JsonNode; query: JsonNode;
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
  var valid_598364 = path.getOrDefault("commentId")
  valid_598364 = validateParameter(valid_598364, JString, required = true,
                                 default = nil)
  if valid_598364 != nil:
    section.add "commentId", valid_598364
  var valid_598365 = path.getOrDefault("postId")
  valid_598365 = validateParameter(valid_598365, JString, required = true,
                                 default = nil)
  if valid_598365 != nil:
    section.add "postId", valid_598365
  var valid_598366 = path.getOrDefault("blogId")
  valid_598366 = validateParameter(valid_598366, JString, required = true,
                                 default = nil)
  if valid_598366 != nil:
    section.add "blogId", valid_598366
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
  var valid_598367 = query.getOrDefault("fields")
  valid_598367 = validateParameter(valid_598367, JString, required = false,
                                 default = nil)
  if valid_598367 != nil:
    section.add "fields", valid_598367
  var valid_598368 = query.getOrDefault("quotaUser")
  valid_598368 = validateParameter(valid_598368, JString, required = false,
                                 default = nil)
  if valid_598368 != nil:
    section.add "quotaUser", valid_598368
  var valid_598369 = query.getOrDefault("alt")
  valid_598369 = validateParameter(valid_598369, JString, required = false,
                                 default = newJString("json"))
  if valid_598369 != nil:
    section.add "alt", valid_598369
  var valid_598370 = query.getOrDefault("oauth_token")
  valid_598370 = validateParameter(valid_598370, JString, required = false,
                                 default = nil)
  if valid_598370 != nil:
    section.add "oauth_token", valid_598370
  var valid_598371 = query.getOrDefault("userIp")
  valid_598371 = validateParameter(valid_598371, JString, required = false,
                                 default = nil)
  if valid_598371 != nil:
    section.add "userIp", valid_598371
  var valid_598372 = query.getOrDefault("key")
  valid_598372 = validateParameter(valid_598372, JString, required = false,
                                 default = nil)
  if valid_598372 != nil:
    section.add "key", valid_598372
  var valid_598373 = query.getOrDefault("prettyPrint")
  valid_598373 = validateParameter(valid_598373, JBool, required = false,
                                 default = newJBool(true))
  if valid_598373 != nil:
    section.add "prettyPrint", valid_598373
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598374: Call_BloggerCommentsDelete_598361; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a comment by ID.
  ## 
  let valid = call_598374.validator(path, query, header, formData, body)
  let scheme = call_598374.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598374.url(scheme.get, call_598374.host, call_598374.base,
                         call_598374.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598374, url, valid)

proc call*(call_598375: Call_BloggerCommentsDelete_598361; commentId: string;
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
  var path_598376 = newJObject()
  var query_598377 = newJObject()
  add(query_598377, "fields", newJString(fields))
  add(query_598377, "quotaUser", newJString(quotaUser))
  add(query_598377, "alt", newJString(alt))
  add(query_598377, "oauth_token", newJString(oauthToken))
  add(query_598377, "userIp", newJString(userIp))
  add(query_598377, "key", newJString(key))
  add(path_598376, "commentId", newJString(commentId))
  add(path_598376, "postId", newJString(postId))
  add(path_598376, "blogId", newJString(blogId))
  add(query_598377, "prettyPrint", newJBool(prettyPrint))
  result = call_598375.call(path_598376, query_598377, nil, nil, nil)

var bloggerCommentsDelete* = Call_BloggerCommentsDelete_598361(
    name: "bloggerCommentsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/blogs/{blogId}/posts/{postId}/comments/{commentId}",
    validator: validate_BloggerCommentsDelete_598362, base: "/blogger/v3",
    url: url_BloggerCommentsDelete_598363, schemes: {Scheme.Https})
type
  Call_BloggerCommentsApprove_598378 = ref object of OpenApiRestCall_597408
proc url_BloggerCommentsApprove_598380(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BloggerCommentsApprove_598379(path: JsonNode; query: JsonNode;
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
  var valid_598381 = path.getOrDefault("commentId")
  valid_598381 = validateParameter(valid_598381, JString, required = true,
                                 default = nil)
  if valid_598381 != nil:
    section.add "commentId", valid_598381
  var valid_598382 = path.getOrDefault("postId")
  valid_598382 = validateParameter(valid_598382, JString, required = true,
                                 default = nil)
  if valid_598382 != nil:
    section.add "postId", valid_598382
  var valid_598383 = path.getOrDefault("blogId")
  valid_598383 = validateParameter(valid_598383, JString, required = true,
                                 default = nil)
  if valid_598383 != nil:
    section.add "blogId", valid_598383
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
  var valid_598384 = query.getOrDefault("fields")
  valid_598384 = validateParameter(valid_598384, JString, required = false,
                                 default = nil)
  if valid_598384 != nil:
    section.add "fields", valid_598384
  var valid_598385 = query.getOrDefault("quotaUser")
  valid_598385 = validateParameter(valid_598385, JString, required = false,
                                 default = nil)
  if valid_598385 != nil:
    section.add "quotaUser", valid_598385
  var valid_598386 = query.getOrDefault("alt")
  valid_598386 = validateParameter(valid_598386, JString, required = false,
                                 default = newJString("json"))
  if valid_598386 != nil:
    section.add "alt", valid_598386
  var valid_598387 = query.getOrDefault("oauth_token")
  valid_598387 = validateParameter(valid_598387, JString, required = false,
                                 default = nil)
  if valid_598387 != nil:
    section.add "oauth_token", valid_598387
  var valid_598388 = query.getOrDefault("userIp")
  valid_598388 = validateParameter(valid_598388, JString, required = false,
                                 default = nil)
  if valid_598388 != nil:
    section.add "userIp", valid_598388
  var valid_598389 = query.getOrDefault("key")
  valid_598389 = validateParameter(valid_598389, JString, required = false,
                                 default = nil)
  if valid_598389 != nil:
    section.add "key", valid_598389
  var valid_598390 = query.getOrDefault("prettyPrint")
  valid_598390 = validateParameter(valid_598390, JBool, required = false,
                                 default = newJBool(true))
  if valid_598390 != nil:
    section.add "prettyPrint", valid_598390
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598391: Call_BloggerCommentsApprove_598378; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Marks a comment as not spam.
  ## 
  let valid = call_598391.validator(path, query, header, formData, body)
  let scheme = call_598391.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598391.url(scheme.get, call_598391.host, call_598391.base,
                         call_598391.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598391, url, valid)

proc call*(call_598392: Call_BloggerCommentsApprove_598378; commentId: string;
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
  var path_598393 = newJObject()
  var query_598394 = newJObject()
  add(query_598394, "fields", newJString(fields))
  add(query_598394, "quotaUser", newJString(quotaUser))
  add(query_598394, "alt", newJString(alt))
  add(query_598394, "oauth_token", newJString(oauthToken))
  add(query_598394, "userIp", newJString(userIp))
  add(query_598394, "key", newJString(key))
  add(path_598393, "commentId", newJString(commentId))
  add(path_598393, "postId", newJString(postId))
  add(path_598393, "blogId", newJString(blogId))
  add(query_598394, "prettyPrint", newJBool(prettyPrint))
  result = call_598392.call(path_598393, query_598394, nil, nil, nil)

var bloggerCommentsApprove* = Call_BloggerCommentsApprove_598378(
    name: "bloggerCommentsApprove", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/blogs/{blogId}/posts/{postId}/comments/{commentId}/approve",
    validator: validate_BloggerCommentsApprove_598379, base: "/blogger/v3",
    url: url_BloggerCommentsApprove_598380, schemes: {Scheme.Https})
type
  Call_BloggerCommentsRemoveContent_598395 = ref object of OpenApiRestCall_597408
proc url_BloggerCommentsRemoveContent_598397(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BloggerCommentsRemoveContent_598396(path: JsonNode; query: JsonNode;
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
  var valid_598398 = path.getOrDefault("commentId")
  valid_598398 = validateParameter(valid_598398, JString, required = true,
                                 default = nil)
  if valid_598398 != nil:
    section.add "commentId", valid_598398
  var valid_598399 = path.getOrDefault("postId")
  valid_598399 = validateParameter(valid_598399, JString, required = true,
                                 default = nil)
  if valid_598399 != nil:
    section.add "postId", valid_598399
  var valid_598400 = path.getOrDefault("blogId")
  valid_598400 = validateParameter(valid_598400, JString, required = true,
                                 default = nil)
  if valid_598400 != nil:
    section.add "blogId", valid_598400
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
  var valid_598401 = query.getOrDefault("fields")
  valid_598401 = validateParameter(valid_598401, JString, required = false,
                                 default = nil)
  if valid_598401 != nil:
    section.add "fields", valid_598401
  var valid_598402 = query.getOrDefault("quotaUser")
  valid_598402 = validateParameter(valid_598402, JString, required = false,
                                 default = nil)
  if valid_598402 != nil:
    section.add "quotaUser", valid_598402
  var valid_598403 = query.getOrDefault("alt")
  valid_598403 = validateParameter(valid_598403, JString, required = false,
                                 default = newJString("json"))
  if valid_598403 != nil:
    section.add "alt", valid_598403
  var valid_598404 = query.getOrDefault("oauth_token")
  valid_598404 = validateParameter(valid_598404, JString, required = false,
                                 default = nil)
  if valid_598404 != nil:
    section.add "oauth_token", valid_598404
  var valid_598405 = query.getOrDefault("userIp")
  valid_598405 = validateParameter(valid_598405, JString, required = false,
                                 default = nil)
  if valid_598405 != nil:
    section.add "userIp", valid_598405
  var valid_598406 = query.getOrDefault("key")
  valid_598406 = validateParameter(valid_598406, JString, required = false,
                                 default = nil)
  if valid_598406 != nil:
    section.add "key", valid_598406
  var valid_598407 = query.getOrDefault("prettyPrint")
  valid_598407 = validateParameter(valid_598407, JBool, required = false,
                                 default = newJBool(true))
  if valid_598407 != nil:
    section.add "prettyPrint", valid_598407
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598408: Call_BloggerCommentsRemoveContent_598395; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes the content of a comment.
  ## 
  let valid = call_598408.validator(path, query, header, formData, body)
  let scheme = call_598408.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598408.url(scheme.get, call_598408.host, call_598408.base,
                         call_598408.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598408, url, valid)

proc call*(call_598409: Call_BloggerCommentsRemoveContent_598395;
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
  var path_598410 = newJObject()
  var query_598411 = newJObject()
  add(query_598411, "fields", newJString(fields))
  add(query_598411, "quotaUser", newJString(quotaUser))
  add(query_598411, "alt", newJString(alt))
  add(query_598411, "oauth_token", newJString(oauthToken))
  add(query_598411, "userIp", newJString(userIp))
  add(query_598411, "key", newJString(key))
  add(path_598410, "commentId", newJString(commentId))
  add(path_598410, "postId", newJString(postId))
  add(path_598410, "blogId", newJString(blogId))
  add(query_598411, "prettyPrint", newJBool(prettyPrint))
  result = call_598409.call(path_598410, query_598411, nil, nil, nil)

var bloggerCommentsRemoveContent* = Call_BloggerCommentsRemoveContent_598395(
    name: "bloggerCommentsRemoveContent", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/blogs/{blogId}/posts/{postId}/comments/{commentId}/removecontent",
    validator: validate_BloggerCommentsRemoveContent_598396, base: "/blogger/v3",
    url: url_BloggerCommentsRemoveContent_598397, schemes: {Scheme.Https})
type
  Call_BloggerCommentsMarkAsSpam_598412 = ref object of OpenApiRestCall_597408
proc url_BloggerCommentsMarkAsSpam_598414(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BloggerCommentsMarkAsSpam_598413(path: JsonNode; query: JsonNode;
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
  var valid_598415 = path.getOrDefault("commentId")
  valid_598415 = validateParameter(valid_598415, JString, required = true,
                                 default = nil)
  if valid_598415 != nil:
    section.add "commentId", valid_598415
  var valid_598416 = path.getOrDefault("postId")
  valid_598416 = validateParameter(valid_598416, JString, required = true,
                                 default = nil)
  if valid_598416 != nil:
    section.add "postId", valid_598416
  var valid_598417 = path.getOrDefault("blogId")
  valid_598417 = validateParameter(valid_598417, JString, required = true,
                                 default = nil)
  if valid_598417 != nil:
    section.add "blogId", valid_598417
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
  var valid_598418 = query.getOrDefault("fields")
  valid_598418 = validateParameter(valid_598418, JString, required = false,
                                 default = nil)
  if valid_598418 != nil:
    section.add "fields", valid_598418
  var valid_598419 = query.getOrDefault("quotaUser")
  valid_598419 = validateParameter(valid_598419, JString, required = false,
                                 default = nil)
  if valid_598419 != nil:
    section.add "quotaUser", valid_598419
  var valid_598420 = query.getOrDefault("alt")
  valid_598420 = validateParameter(valid_598420, JString, required = false,
                                 default = newJString("json"))
  if valid_598420 != nil:
    section.add "alt", valid_598420
  var valid_598421 = query.getOrDefault("oauth_token")
  valid_598421 = validateParameter(valid_598421, JString, required = false,
                                 default = nil)
  if valid_598421 != nil:
    section.add "oauth_token", valid_598421
  var valid_598422 = query.getOrDefault("userIp")
  valid_598422 = validateParameter(valid_598422, JString, required = false,
                                 default = nil)
  if valid_598422 != nil:
    section.add "userIp", valid_598422
  var valid_598423 = query.getOrDefault("key")
  valid_598423 = validateParameter(valid_598423, JString, required = false,
                                 default = nil)
  if valid_598423 != nil:
    section.add "key", valid_598423
  var valid_598424 = query.getOrDefault("prettyPrint")
  valid_598424 = validateParameter(valid_598424, JBool, required = false,
                                 default = newJBool(true))
  if valid_598424 != nil:
    section.add "prettyPrint", valid_598424
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598425: Call_BloggerCommentsMarkAsSpam_598412; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Marks a comment as spam.
  ## 
  let valid = call_598425.validator(path, query, header, formData, body)
  let scheme = call_598425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598425.url(scheme.get, call_598425.host, call_598425.base,
                         call_598425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598425, url, valid)

proc call*(call_598426: Call_BloggerCommentsMarkAsSpam_598412; commentId: string;
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
  var path_598427 = newJObject()
  var query_598428 = newJObject()
  add(query_598428, "fields", newJString(fields))
  add(query_598428, "quotaUser", newJString(quotaUser))
  add(query_598428, "alt", newJString(alt))
  add(query_598428, "oauth_token", newJString(oauthToken))
  add(query_598428, "userIp", newJString(userIp))
  add(query_598428, "key", newJString(key))
  add(path_598427, "commentId", newJString(commentId))
  add(path_598427, "postId", newJString(postId))
  add(path_598427, "blogId", newJString(blogId))
  add(query_598428, "prettyPrint", newJBool(prettyPrint))
  result = call_598426.call(path_598427, query_598428, nil, nil, nil)

var bloggerCommentsMarkAsSpam* = Call_BloggerCommentsMarkAsSpam_598412(
    name: "bloggerCommentsMarkAsSpam", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/blogs/{blogId}/posts/{postId}/comments/{commentId}/spam",
    validator: validate_BloggerCommentsMarkAsSpam_598413, base: "/blogger/v3",
    url: url_BloggerCommentsMarkAsSpam_598414, schemes: {Scheme.Https})
type
  Call_BloggerPostsPublish_598429 = ref object of OpenApiRestCall_597408
proc url_BloggerPostsPublish_598431(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BloggerPostsPublish_598430(path: JsonNode; query: JsonNode;
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
  var valid_598432 = path.getOrDefault("postId")
  valid_598432 = validateParameter(valid_598432, JString, required = true,
                                 default = nil)
  if valid_598432 != nil:
    section.add "postId", valid_598432
  var valid_598433 = path.getOrDefault("blogId")
  valid_598433 = validateParameter(valid_598433, JString, required = true,
                                 default = nil)
  if valid_598433 != nil:
    section.add "blogId", valid_598433
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
  var valid_598434 = query.getOrDefault("fields")
  valid_598434 = validateParameter(valid_598434, JString, required = false,
                                 default = nil)
  if valid_598434 != nil:
    section.add "fields", valid_598434
  var valid_598435 = query.getOrDefault("quotaUser")
  valid_598435 = validateParameter(valid_598435, JString, required = false,
                                 default = nil)
  if valid_598435 != nil:
    section.add "quotaUser", valid_598435
  var valid_598436 = query.getOrDefault("alt")
  valid_598436 = validateParameter(valid_598436, JString, required = false,
                                 default = newJString("json"))
  if valid_598436 != nil:
    section.add "alt", valid_598436
  var valid_598437 = query.getOrDefault("publishDate")
  valid_598437 = validateParameter(valid_598437, JString, required = false,
                                 default = nil)
  if valid_598437 != nil:
    section.add "publishDate", valid_598437
  var valid_598438 = query.getOrDefault("oauth_token")
  valid_598438 = validateParameter(valid_598438, JString, required = false,
                                 default = nil)
  if valid_598438 != nil:
    section.add "oauth_token", valid_598438
  var valid_598439 = query.getOrDefault("userIp")
  valid_598439 = validateParameter(valid_598439, JString, required = false,
                                 default = nil)
  if valid_598439 != nil:
    section.add "userIp", valid_598439
  var valid_598440 = query.getOrDefault("key")
  valid_598440 = validateParameter(valid_598440, JString, required = false,
                                 default = nil)
  if valid_598440 != nil:
    section.add "key", valid_598440
  var valid_598441 = query.getOrDefault("prettyPrint")
  valid_598441 = validateParameter(valid_598441, JBool, required = false,
                                 default = newJBool(true))
  if valid_598441 != nil:
    section.add "prettyPrint", valid_598441
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598442: Call_BloggerPostsPublish_598429; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Publishes a draft post, optionally at the specific time of the given publishDate parameter.
  ## 
  let valid = call_598442.validator(path, query, header, formData, body)
  let scheme = call_598442.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598442.url(scheme.get, call_598442.host, call_598442.base,
                         call_598442.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598442, url, valid)

proc call*(call_598443: Call_BloggerPostsPublish_598429; postId: string;
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
  var path_598444 = newJObject()
  var query_598445 = newJObject()
  add(query_598445, "fields", newJString(fields))
  add(query_598445, "quotaUser", newJString(quotaUser))
  add(query_598445, "alt", newJString(alt))
  add(query_598445, "publishDate", newJString(publishDate))
  add(query_598445, "oauth_token", newJString(oauthToken))
  add(query_598445, "userIp", newJString(userIp))
  add(query_598445, "key", newJString(key))
  add(path_598444, "postId", newJString(postId))
  add(path_598444, "blogId", newJString(blogId))
  add(query_598445, "prettyPrint", newJBool(prettyPrint))
  result = call_598443.call(path_598444, query_598445, nil, nil, nil)

var bloggerPostsPublish* = Call_BloggerPostsPublish_598429(
    name: "bloggerPostsPublish", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/blogs/{blogId}/posts/{postId}/publish",
    validator: validate_BloggerPostsPublish_598430, base: "/blogger/v3",
    url: url_BloggerPostsPublish_598431, schemes: {Scheme.Https})
type
  Call_BloggerPostsRevert_598446 = ref object of OpenApiRestCall_597408
proc url_BloggerPostsRevert_598448(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BloggerPostsRevert_598447(path: JsonNode; query: JsonNode;
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
  var valid_598449 = path.getOrDefault("postId")
  valid_598449 = validateParameter(valid_598449, JString, required = true,
                                 default = nil)
  if valid_598449 != nil:
    section.add "postId", valid_598449
  var valid_598450 = path.getOrDefault("blogId")
  valid_598450 = validateParameter(valid_598450, JString, required = true,
                                 default = nil)
  if valid_598450 != nil:
    section.add "blogId", valid_598450
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
  var valid_598451 = query.getOrDefault("fields")
  valid_598451 = validateParameter(valid_598451, JString, required = false,
                                 default = nil)
  if valid_598451 != nil:
    section.add "fields", valid_598451
  var valid_598452 = query.getOrDefault("quotaUser")
  valid_598452 = validateParameter(valid_598452, JString, required = false,
                                 default = nil)
  if valid_598452 != nil:
    section.add "quotaUser", valid_598452
  var valid_598453 = query.getOrDefault("alt")
  valid_598453 = validateParameter(valid_598453, JString, required = false,
                                 default = newJString("json"))
  if valid_598453 != nil:
    section.add "alt", valid_598453
  var valid_598454 = query.getOrDefault("oauth_token")
  valid_598454 = validateParameter(valid_598454, JString, required = false,
                                 default = nil)
  if valid_598454 != nil:
    section.add "oauth_token", valid_598454
  var valid_598455 = query.getOrDefault("userIp")
  valid_598455 = validateParameter(valid_598455, JString, required = false,
                                 default = nil)
  if valid_598455 != nil:
    section.add "userIp", valid_598455
  var valid_598456 = query.getOrDefault("key")
  valid_598456 = validateParameter(valid_598456, JString, required = false,
                                 default = nil)
  if valid_598456 != nil:
    section.add "key", valid_598456
  var valid_598457 = query.getOrDefault("prettyPrint")
  valid_598457 = validateParameter(valid_598457, JBool, required = false,
                                 default = newJBool(true))
  if valid_598457 != nil:
    section.add "prettyPrint", valid_598457
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598458: Call_BloggerPostsRevert_598446; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Revert a published or scheduled post to draft state.
  ## 
  let valid = call_598458.validator(path, query, header, formData, body)
  let scheme = call_598458.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598458.url(scheme.get, call_598458.host, call_598458.base,
                         call_598458.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598458, url, valid)

proc call*(call_598459: Call_BloggerPostsRevert_598446; postId: string;
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
  var path_598460 = newJObject()
  var query_598461 = newJObject()
  add(query_598461, "fields", newJString(fields))
  add(query_598461, "quotaUser", newJString(quotaUser))
  add(query_598461, "alt", newJString(alt))
  add(query_598461, "oauth_token", newJString(oauthToken))
  add(query_598461, "userIp", newJString(userIp))
  add(query_598461, "key", newJString(key))
  add(path_598460, "postId", newJString(postId))
  add(path_598460, "blogId", newJString(blogId))
  add(query_598461, "prettyPrint", newJBool(prettyPrint))
  result = call_598459.call(path_598460, query_598461, nil, nil, nil)

var bloggerPostsRevert* = Call_BloggerPostsRevert_598446(
    name: "bloggerPostsRevert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/blogs/{blogId}/posts/{postId}/revert",
    validator: validate_BloggerPostsRevert_598447, base: "/blogger/v3",
    url: url_BloggerPostsRevert_598448, schemes: {Scheme.Https})
type
  Call_BloggerUsersGet_598462 = ref object of OpenApiRestCall_597408
proc url_BloggerUsersGet_598464(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerUsersGet_598463(path: JsonNode; query: JsonNode;
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
  var valid_598465 = path.getOrDefault("userId")
  valid_598465 = validateParameter(valid_598465, JString, required = true,
                                 default = nil)
  if valid_598465 != nil:
    section.add "userId", valid_598465
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
  var valid_598471 = query.getOrDefault("key")
  valid_598471 = validateParameter(valid_598471, JString, required = false,
                                 default = nil)
  if valid_598471 != nil:
    section.add "key", valid_598471
  var valid_598472 = query.getOrDefault("prettyPrint")
  valid_598472 = validateParameter(valid_598472, JBool, required = false,
                                 default = newJBool(true))
  if valid_598472 != nil:
    section.add "prettyPrint", valid_598472
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598473: Call_BloggerUsersGet_598462; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one user by ID.
  ## 
  let valid = call_598473.validator(path, query, header, formData, body)
  let scheme = call_598473.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598473.url(scheme.get, call_598473.host, call_598473.base,
                         call_598473.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598473, url, valid)

proc call*(call_598474: Call_BloggerUsersGet_598462; userId: string;
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
  var path_598475 = newJObject()
  var query_598476 = newJObject()
  add(query_598476, "fields", newJString(fields))
  add(query_598476, "quotaUser", newJString(quotaUser))
  add(query_598476, "alt", newJString(alt))
  add(query_598476, "oauth_token", newJString(oauthToken))
  add(query_598476, "userIp", newJString(userIp))
  add(query_598476, "key", newJString(key))
  add(query_598476, "prettyPrint", newJBool(prettyPrint))
  add(path_598475, "userId", newJString(userId))
  result = call_598474.call(path_598475, query_598476, nil, nil, nil)

var bloggerUsersGet* = Call_BloggerUsersGet_598462(name: "bloggerUsersGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/users/{userId}",
    validator: validate_BloggerUsersGet_598463, base: "/blogger/v3",
    url: url_BloggerUsersGet_598464, schemes: {Scheme.Https})
type
  Call_BloggerBlogsListByUser_598477 = ref object of OpenApiRestCall_597408
proc url_BloggerBlogsListByUser_598479(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BloggerBlogsListByUser_598478(path: JsonNode; query: JsonNode;
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
  var valid_598480 = path.getOrDefault("userId")
  valid_598480 = validateParameter(valid_598480, JString, required = true,
                                 default = nil)
  if valid_598480 != nil:
    section.add "userId", valid_598480
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
  var valid_598481 = query.getOrDefault("fields")
  valid_598481 = validateParameter(valid_598481, JString, required = false,
                                 default = nil)
  if valid_598481 != nil:
    section.add "fields", valid_598481
  var valid_598482 = query.getOrDefault("view")
  valid_598482 = validateParameter(valid_598482, JString, required = false,
                                 default = newJString("ADMIN"))
  if valid_598482 != nil:
    section.add "view", valid_598482
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
  var valid_598486 = query.getOrDefault("fetchUserInfo")
  valid_598486 = validateParameter(valid_598486, JBool, required = false, default = nil)
  if valid_598486 != nil:
    section.add "fetchUserInfo", valid_598486
  var valid_598487 = query.getOrDefault("userIp")
  valid_598487 = validateParameter(valid_598487, JString, required = false,
                                 default = nil)
  if valid_598487 != nil:
    section.add "userIp", valid_598487
  var valid_598488 = query.getOrDefault("key")
  valid_598488 = validateParameter(valid_598488, JString, required = false,
                                 default = nil)
  if valid_598488 != nil:
    section.add "key", valid_598488
  var valid_598489 = query.getOrDefault("role")
  valid_598489 = validateParameter(valid_598489, JArray, required = false,
                                 default = nil)
  if valid_598489 != nil:
    section.add "role", valid_598489
  var valid_598490 = query.getOrDefault("status")
  valid_598490 = validateParameter(valid_598490, JArray, required = false,
                                 default = nil)
  if valid_598490 != nil:
    section.add "status", valid_598490
  var valid_598491 = query.getOrDefault("prettyPrint")
  valid_598491 = validateParameter(valid_598491, JBool, required = false,
                                 default = newJBool(true))
  if valid_598491 != nil:
    section.add "prettyPrint", valid_598491
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598492: Call_BloggerBlogsListByUser_598477; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of blogs, possibly filtered.
  ## 
  let valid = call_598492.validator(path, query, header, formData, body)
  let scheme = call_598492.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598492.url(scheme.get, call_598492.host, call_598492.base,
                         call_598492.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598492, url, valid)

proc call*(call_598493: Call_BloggerBlogsListByUser_598477; userId: string;
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
  var path_598494 = newJObject()
  var query_598495 = newJObject()
  add(query_598495, "fields", newJString(fields))
  add(query_598495, "view", newJString(view))
  add(query_598495, "quotaUser", newJString(quotaUser))
  add(query_598495, "alt", newJString(alt))
  add(query_598495, "oauth_token", newJString(oauthToken))
  add(query_598495, "fetchUserInfo", newJBool(fetchUserInfo))
  add(query_598495, "userIp", newJString(userIp))
  add(query_598495, "key", newJString(key))
  if role != nil:
    query_598495.add "role", role
  if status != nil:
    query_598495.add "status", status
  add(query_598495, "prettyPrint", newJBool(prettyPrint))
  add(path_598494, "userId", newJString(userId))
  result = call_598493.call(path_598494, query_598495, nil, nil, nil)

var bloggerBlogsListByUser* = Call_BloggerBlogsListByUser_598477(
    name: "bloggerBlogsListByUser", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userId}/blogs",
    validator: validate_BloggerBlogsListByUser_598478, base: "/blogger/v3",
    url: url_BloggerBlogsListByUser_598479, schemes: {Scheme.Https})
type
  Call_BloggerBlogUserInfosGet_598496 = ref object of OpenApiRestCall_597408
proc url_BloggerBlogUserInfosGet_598498(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BloggerBlogUserInfosGet_598497(path: JsonNode; query: JsonNode;
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
  var valid_598499 = path.getOrDefault("blogId")
  valid_598499 = validateParameter(valid_598499, JString, required = true,
                                 default = nil)
  if valid_598499 != nil:
    section.add "blogId", valid_598499
  var valid_598500 = path.getOrDefault("userId")
  valid_598500 = validateParameter(valid_598500, JString, required = true,
                                 default = nil)
  if valid_598500 != nil:
    section.add "userId", valid_598500
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
  var valid_598501 = query.getOrDefault("fields")
  valid_598501 = validateParameter(valid_598501, JString, required = false,
                                 default = nil)
  if valid_598501 != nil:
    section.add "fields", valid_598501
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
  var valid_598506 = query.getOrDefault("key")
  valid_598506 = validateParameter(valid_598506, JString, required = false,
                                 default = nil)
  if valid_598506 != nil:
    section.add "key", valid_598506
  var valid_598507 = query.getOrDefault("prettyPrint")
  valid_598507 = validateParameter(valid_598507, JBool, required = false,
                                 default = newJBool(true))
  if valid_598507 != nil:
    section.add "prettyPrint", valid_598507
  var valid_598508 = query.getOrDefault("maxPosts")
  valid_598508 = validateParameter(valid_598508, JInt, required = false, default = nil)
  if valid_598508 != nil:
    section.add "maxPosts", valid_598508
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598509: Call_BloggerBlogUserInfosGet_598496; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one blog and user info pair by blogId and userId.
  ## 
  let valid = call_598509.validator(path, query, header, formData, body)
  let scheme = call_598509.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598509.url(scheme.get, call_598509.host, call_598509.base,
                         call_598509.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598509, url, valid)

proc call*(call_598510: Call_BloggerBlogUserInfosGet_598496; blogId: string;
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
  var path_598511 = newJObject()
  var query_598512 = newJObject()
  add(query_598512, "fields", newJString(fields))
  add(query_598512, "quotaUser", newJString(quotaUser))
  add(query_598512, "alt", newJString(alt))
  add(query_598512, "oauth_token", newJString(oauthToken))
  add(query_598512, "userIp", newJString(userIp))
  add(query_598512, "key", newJString(key))
  add(path_598511, "blogId", newJString(blogId))
  add(query_598512, "prettyPrint", newJBool(prettyPrint))
  add(query_598512, "maxPosts", newJInt(maxPosts))
  add(path_598511, "userId", newJString(userId))
  result = call_598510.call(path_598511, query_598512, nil, nil, nil)

var bloggerBlogUserInfosGet* = Call_BloggerBlogUserInfosGet_598496(
    name: "bloggerBlogUserInfosGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userId}/blogs/{blogId}",
    validator: validate_BloggerBlogUserInfosGet_598497, base: "/blogger/v3",
    url: url_BloggerBlogUserInfosGet_598498, schemes: {Scheme.Https})
type
  Call_BloggerPostUserInfosList_598513 = ref object of OpenApiRestCall_597408
proc url_BloggerPostUserInfosList_598515(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BloggerPostUserInfosList_598514(path: JsonNode; query: JsonNode;
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
  var valid_598516 = path.getOrDefault("blogId")
  valid_598516 = validateParameter(valid_598516, JString, required = true,
                                 default = nil)
  if valid_598516 != nil:
    section.add "blogId", valid_598516
  var valid_598517 = path.getOrDefault("userId")
  valid_598517 = validateParameter(valid_598517, JString, required = true,
                                 default = nil)
  if valid_598517 != nil:
    section.add "userId", valid_598517
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
  var valid_598518 = query.getOrDefault("fields")
  valid_598518 = validateParameter(valid_598518, JString, required = false,
                                 default = nil)
  if valid_598518 != nil:
    section.add "fields", valid_598518
  var valid_598519 = query.getOrDefault("pageToken")
  valid_598519 = validateParameter(valid_598519, JString, required = false,
                                 default = nil)
  if valid_598519 != nil:
    section.add "pageToken", valid_598519
  var valid_598520 = query.getOrDefault("quotaUser")
  valid_598520 = validateParameter(valid_598520, JString, required = false,
                                 default = nil)
  if valid_598520 != nil:
    section.add "quotaUser", valid_598520
  var valid_598521 = query.getOrDefault("view")
  valid_598521 = validateParameter(valid_598521, JString, required = false,
                                 default = newJString("ADMIN"))
  if valid_598521 != nil:
    section.add "view", valid_598521
  var valid_598522 = query.getOrDefault("alt")
  valid_598522 = validateParameter(valid_598522, JString, required = false,
                                 default = newJString("json"))
  if valid_598522 != nil:
    section.add "alt", valid_598522
  var valid_598523 = query.getOrDefault("endDate")
  valid_598523 = validateParameter(valid_598523, JString, required = false,
                                 default = nil)
  if valid_598523 != nil:
    section.add "endDate", valid_598523
  var valid_598524 = query.getOrDefault("startDate")
  valid_598524 = validateParameter(valid_598524, JString, required = false,
                                 default = nil)
  if valid_598524 != nil:
    section.add "startDate", valid_598524
  var valid_598525 = query.getOrDefault("oauth_token")
  valid_598525 = validateParameter(valid_598525, JString, required = false,
                                 default = nil)
  if valid_598525 != nil:
    section.add "oauth_token", valid_598525
  var valid_598526 = query.getOrDefault("userIp")
  valid_598526 = validateParameter(valid_598526, JString, required = false,
                                 default = nil)
  if valid_598526 != nil:
    section.add "userIp", valid_598526
  var valid_598527 = query.getOrDefault("maxResults")
  valid_598527 = validateParameter(valid_598527, JInt, required = false, default = nil)
  if valid_598527 != nil:
    section.add "maxResults", valid_598527
  var valid_598528 = query.getOrDefault("orderBy")
  valid_598528 = validateParameter(valid_598528, JString, required = false,
                                 default = newJString("published"))
  if valid_598528 != nil:
    section.add "orderBy", valid_598528
  var valid_598529 = query.getOrDefault("key")
  valid_598529 = validateParameter(valid_598529, JString, required = false,
                                 default = nil)
  if valid_598529 != nil:
    section.add "key", valid_598529
  var valid_598530 = query.getOrDefault("labels")
  valid_598530 = validateParameter(valid_598530, JString, required = false,
                                 default = nil)
  if valid_598530 != nil:
    section.add "labels", valid_598530
  var valid_598531 = query.getOrDefault("status")
  valid_598531 = validateParameter(valid_598531, JArray, required = false,
                                 default = nil)
  if valid_598531 != nil:
    section.add "status", valid_598531
  var valid_598532 = query.getOrDefault("fetchBodies")
  valid_598532 = validateParameter(valid_598532, JBool, required = false,
                                 default = newJBool(false))
  if valid_598532 != nil:
    section.add "fetchBodies", valid_598532
  var valid_598533 = query.getOrDefault("prettyPrint")
  valid_598533 = validateParameter(valid_598533, JBool, required = false,
                                 default = newJBool(true))
  if valid_598533 != nil:
    section.add "prettyPrint", valid_598533
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598534: Call_BloggerPostUserInfosList_598513; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of post and post user info pairs, possibly filtered. The post user info contains per-user information about the post, such as access rights, specific to the user.
  ## 
  let valid = call_598534.validator(path, query, header, formData, body)
  let scheme = call_598534.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598534.url(scheme.get, call_598534.host, call_598534.base,
                         call_598534.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598534, url, valid)

proc call*(call_598535: Call_BloggerPostUserInfosList_598513; blogId: string;
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
  var path_598536 = newJObject()
  var query_598537 = newJObject()
  add(query_598537, "fields", newJString(fields))
  add(query_598537, "pageToken", newJString(pageToken))
  add(query_598537, "quotaUser", newJString(quotaUser))
  add(query_598537, "view", newJString(view))
  add(query_598537, "alt", newJString(alt))
  add(query_598537, "endDate", newJString(endDate))
  add(query_598537, "startDate", newJString(startDate))
  add(query_598537, "oauth_token", newJString(oauthToken))
  add(query_598537, "userIp", newJString(userIp))
  add(query_598537, "maxResults", newJInt(maxResults))
  add(query_598537, "orderBy", newJString(orderBy))
  add(query_598537, "key", newJString(key))
  add(query_598537, "labels", newJString(labels))
  if status != nil:
    query_598537.add "status", status
  add(query_598537, "fetchBodies", newJBool(fetchBodies))
  add(path_598536, "blogId", newJString(blogId))
  add(query_598537, "prettyPrint", newJBool(prettyPrint))
  add(path_598536, "userId", newJString(userId))
  result = call_598535.call(path_598536, query_598537, nil, nil, nil)

var bloggerPostUserInfosList* = Call_BloggerPostUserInfosList_598513(
    name: "bloggerPostUserInfosList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userId}/blogs/{blogId}/posts",
    validator: validate_BloggerPostUserInfosList_598514, base: "/blogger/v3",
    url: url_BloggerPostUserInfosList_598515, schemes: {Scheme.Https})
type
  Call_BloggerPostUserInfosGet_598538 = ref object of OpenApiRestCall_597408
proc url_BloggerPostUserInfosGet_598540(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_BloggerPostUserInfosGet_598539(path: JsonNode; query: JsonNode;
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
  var valid_598541 = path.getOrDefault("postId")
  valid_598541 = validateParameter(valid_598541, JString, required = true,
                                 default = nil)
  if valid_598541 != nil:
    section.add "postId", valid_598541
  var valid_598542 = path.getOrDefault("blogId")
  valid_598542 = validateParameter(valid_598542, JString, required = true,
                                 default = nil)
  if valid_598542 != nil:
    section.add "blogId", valid_598542
  var valid_598543 = path.getOrDefault("userId")
  valid_598543 = validateParameter(valid_598543, JString, required = true,
                                 default = nil)
  if valid_598543 != nil:
    section.add "userId", valid_598543
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
  var valid_598544 = query.getOrDefault("fields")
  valid_598544 = validateParameter(valid_598544, JString, required = false,
                                 default = nil)
  if valid_598544 != nil:
    section.add "fields", valid_598544
  var valid_598545 = query.getOrDefault("quotaUser")
  valid_598545 = validateParameter(valid_598545, JString, required = false,
                                 default = nil)
  if valid_598545 != nil:
    section.add "quotaUser", valid_598545
  var valid_598546 = query.getOrDefault("alt")
  valid_598546 = validateParameter(valid_598546, JString, required = false,
                                 default = newJString("json"))
  if valid_598546 != nil:
    section.add "alt", valid_598546
  var valid_598547 = query.getOrDefault("oauth_token")
  valid_598547 = validateParameter(valid_598547, JString, required = false,
                                 default = nil)
  if valid_598547 != nil:
    section.add "oauth_token", valid_598547
  var valid_598548 = query.getOrDefault("userIp")
  valid_598548 = validateParameter(valid_598548, JString, required = false,
                                 default = nil)
  if valid_598548 != nil:
    section.add "userIp", valid_598548
  var valid_598549 = query.getOrDefault("maxComments")
  valid_598549 = validateParameter(valid_598549, JInt, required = false, default = nil)
  if valid_598549 != nil:
    section.add "maxComments", valid_598549
  var valid_598550 = query.getOrDefault("key")
  valid_598550 = validateParameter(valid_598550, JString, required = false,
                                 default = nil)
  if valid_598550 != nil:
    section.add "key", valid_598550
  var valid_598551 = query.getOrDefault("prettyPrint")
  valid_598551 = validateParameter(valid_598551, JBool, required = false,
                                 default = newJBool(true))
  if valid_598551 != nil:
    section.add "prettyPrint", valid_598551
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598552: Call_BloggerPostUserInfosGet_598538; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one post and user info pair, by post ID and user ID. The post user info contains per-user information about the post, such as access rights, specific to the user.
  ## 
  let valid = call_598552.validator(path, query, header, formData, body)
  let scheme = call_598552.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598552.url(scheme.get, call_598552.host, call_598552.base,
                         call_598552.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598552, url, valid)

proc call*(call_598553: Call_BloggerPostUserInfosGet_598538; postId: string;
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
  var path_598554 = newJObject()
  var query_598555 = newJObject()
  add(query_598555, "fields", newJString(fields))
  add(query_598555, "quotaUser", newJString(quotaUser))
  add(query_598555, "alt", newJString(alt))
  add(query_598555, "oauth_token", newJString(oauthToken))
  add(query_598555, "userIp", newJString(userIp))
  add(query_598555, "maxComments", newJInt(maxComments))
  add(query_598555, "key", newJString(key))
  add(path_598554, "postId", newJString(postId))
  add(path_598554, "blogId", newJString(blogId))
  add(query_598555, "prettyPrint", newJBool(prettyPrint))
  add(path_598554, "userId", newJString(userId))
  result = call_598553.call(path_598554, query_598555, nil, nil, nil)

var bloggerPostUserInfosGet* = Call_BloggerPostUserInfosGet_598538(
    name: "bloggerPostUserInfosGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/users/{userId}/blogs/{blogId}/posts/{postId}",
    validator: validate_BloggerPostUserInfosGet_598539, base: "/blogger/v3",
    url: url_BloggerPostUserInfosGet_598540, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
