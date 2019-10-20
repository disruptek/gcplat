
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

  OpenApiRestCall_578339 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578339](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578339): Option[Scheme] {.used.} =
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
  gcpServiceName = "blogger"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BloggerBlogsGetByUrl_578609 = ref object of OpenApiRestCall_578339
proc url_BloggerBlogsGetByUrl_578611(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BloggerBlogsGetByUrl_578610(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve a Blog by URL.
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: JString
  ##       : Access level with which to view the blog. Note that some fields require elevated access.
  ##   url: JString (required)
  ##      : The URL of the blog to retrieve.
  section = newJObject()
  var valid_578723 = query.getOrDefault("key")
  valid_578723 = validateParameter(valid_578723, JString, required = false,
                                 default = nil)
  if valid_578723 != nil:
    section.add "key", valid_578723
  var valid_578737 = query.getOrDefault("prettyPrint")
  valid_578737 = validateParameter(valid_578737, JBool, required = false,
                                 default = newJBool(true))
  if valid_578737 != nil:
    section.add "prettyPrint", valid_578737
  var valid_578738 = query.getOrDefault("oauth_token")
  valid_578738 = validateParameter(valid_578738, JString, required = false,
                                 default = nil)
  if valid_578738 != nil:
    section.add "oauth_token", valid_578738
  var valid_578739 = query.getOrDefault("alt")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = newJString("json"))
  if valid_578739 != nil:
    section.add "alt", valid_578739
  var valid_578740 = query.getOrDefault("userIp")
  valid_578740 = validateParameter(valid_578740, JString, required = false,
                                 default = nil)
  if valid_578740 != nil:
    section.add "userIp", valid_578740
  var valid_578741 = query.getOrDefault("quotaUser")
  valid_578741 = validateParameter(valid_578741, JString, required = false,
                                 default = nil)
  if valid_578741 != nil:
    section.add "quotaUser", valid_578741
  var valid_578742 = query.getOrDefault("fields")
  valid_578742 = validateParameter(valid_578742, JString, required = false,
                                 default = nil)
  if valid_578742 != nil:
    section.add "fields", valid_578742
  var valid_578743 = query.getOrDefault("view")
  valid_578743 = validateParameter(valid_578743, JString, required = false,
                                 default = newJString("ADMIN"))
  if valid_578743 != nil:
    section.add "view", valid_578743
  assert query != nil, "query argument is necessary due to required `url` field"
  var valid_578744 = query.getOrDefault("url")
  valid_578744 = validateParameter(valid_578744, JString, required = true,
                                 default = nil)
  if valid_578744 != nil:
    section.add "url", valid_578744
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578767: Call_BloggerBlogsGetByUrl_578609; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a Blog by URL.
  ## 
  let valid = call_578767.validator(path, query, header, formData, body)
  let scheme = call_578767.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578767.url(scheme.get, call_578767.host, call_578767.base,
                         call_578767.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578767, url, valid)

proc call*(call_578838: Call_BloggerBlogsGetByUrl_578609; url: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""; view: string = "ADMIN"): Recallable =
  ## bloggerBlogsGetByUrl
  ## Retrieve a Blog by URL.
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
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: string
  ##       : Access level with which to view the blog. Note that some fields require elevated access.
  ##   url: string (required)
  ##      : The URL of the blog to retrieve.
  var query_578839 = newJObject()
  add(query_578839, "key", newJString(key))
  add(query_578839, "prettyPrint", newJBool(prettyPrint))
  add(query_578839, "oauth_token", newJString(oauthToken))
  add(query_578839, "alt", newJString(alt))
  add(query_578839, "userIp", newJString(userIp))
  add(query_578839, "quotaUser", newJString(quotaUser))
  add(query_578839, "fields", newJString(fields))
  add(query_578839, "view", newJString(view))
  add(query_578839, "url", newJString(url))
  result = call_578838.call(nil, query_578839, nil, nil, nil)

var bloggerBlogsGetByUrl* = Call_BloggerBlogsGetByUrl_578609(
    name: "bloggerBlogsGetByUrl", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/blogs/byurl",
    validator: validate_BloggerBlogsGetByUrl_578610, base: "/blogger/v3",
    url: url_BloggerBlogsGetByUrl_578611, schemes: {Scheme.Https})
type
  Call_BloggerBlogsGet_578879 = ref object of OpenApiRestCall_578339
proc url_BloggerBlogsGet_578881(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerBlogsGet_578880(path: JsonNode; query: JsonNode;
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
  var valid_578896 = path.getOrDefault("blogId")
  valid_578896 = validateParameter(valid_578896, JString, required = true,
                                 default = nil)
  if valid_578896 != nil:
    section.add "blogId", valid_578896
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
  ##   maxPosts: JInt
  ##           : Maximum number of posts to pull back with the blog.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: JString
  ##       : Access level with which to view the blog. Note that some fields require elevated access.
  section = newJObject()
  var valid_578897 = query.getOrDefault("key")
  valid_578897 = validateParameter(valid_578897, JString, required = false,
                                 default = nil)
  if valid_578897 != nil:
    section.add "key", valid_578897
  var valid_578898 = query.getOrDefault("prettyPrint")
  valid_578898 = validateParameter(valid_578898, JBool, required = false,
                                 default = newJBool(true))
  if valid_578898 != nil:
    section.add "prettyPrint", valid_578898
  var valid_578899 = query.getOrDefault("oauth_token")
  valid_578899 = validateParameter(valid_578899, JString, required = false,
                                 default = nil)
  if valid_578899 != nil:
    section.add "oauth_token", valid_578899
  var valid_578900 = query.getOrDefault("alt")
  valid_578900 = validateParameter(valid_578900, JString, required = false,
                                 default = newJString("json"))
  if valid_578900 != nil:
    section.add "alt", valid_578900
  var valid_578901 = query.getOrDefault("userIp")
  valid_578901 = validateParameter(valid_578901, JString, required = false,
                                 default = nil)
  if valid_578901 != nil:
    section.add "userIp", valid_578901
  var valid_578902 = query.getOrDefault("quotaUser")
  valid_578902 = validateParameter(valid_578902, JString, required = false,
                                 default = nil)
  if valid_578902 != nil:
    section.add "quotaUser", valid_578902
  var valid_578903 = query.getOrDefault("maxPosts")
  valid_578903 = validateParameter(valid_578903, JInt, required = false, default = nil)
  if valid_578903 != nil:
    section.add "maxPosts", valid_578903
  var valid_578904 = query.getOrDefault("fields")
  valid_578904 = validateParameter(valid_578904, JString, required = false,
                                 default = nil)
  if valid_578904 != nil:
    section.add "fields", valid_578904
  var valid_578905 = query.getOrDefault("view")
  valid_578905 = validateParameter(valid_578905, JString, required = false,
                                 default = newJString("ADMIN"))
  if valid_578905 != nil:
    section.add "view", valid_578905
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578906: Call_BloggerBlogsGet_578879; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one blog by ID.
  ## 
  let valid = call_578906.validator(path, query, header, formData, body)
  let scheme = call_578906.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578906.url(scheme.get, call_578906.host, call_578906.base,
                         call_578906.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578906, url, valid)

proc call*(call_578907: Call_BloggerBlogsGet_578879; blogId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          maxPosts: int = 0; fields: string = ""; view: string = "ADMIN"): Recallable =
  ## bloggerBlogsGet
  ## Gets one blog by ID.
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
  ##   maxPosts: int
  ##           : Maximum number of posts to pull back with the blog.
  ##   blogId: string (required)
  ##         : The ID of the blog to get.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: string
  ##       : Access level with which to view the blog. Note that some fields require elevated access.
  var path_578908 = newJObject()
  var query_578909 = newJObject()
  add(query_578909, "key", newJString(key))
  add(query_578909, "prettyPrint", newJBool(prettyPrint))
  add(query_578909, "oauth_token", newJString(oauthToken))
  add(query_578909, "alt", newJString(alt))
  add(query_578909, "userIp", newJString(userIp))
  add(query_578909, "quotaUser", newJString(quotaUser))
  add(query_578909, "maxPosts", newJInt(maxPosts))
  add(path_578908, "blogId", newJString(blogId))
  add(query_578909, "fields", newJString(fields))
  add(query_578909, "view", newJString(view))
  result = call_578907.call(path_578908, query_578909, nil, nil, nil)

var bloggerBlogsGet* = Call_BloggerBlogsGet_578879(name: "bloggerBlogsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/blogs/{blogId}",
    validator: validate_BloggerBlogsGet_578880, base: "/blogger/v3",
    url: url_BloggerBlogsGet_578881, schemes: {Scheme.Https})
type
  Call_BloggerCommentsListByBlog_578910 = ref object of OpenApiRestCall_578339
proc url_BloggerCommentsListByBlog_578912(protocol: Scheme; host: string;
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

proc validate_BloggerCommentsListByBlog_578911(path: JsonNode; query: JsonNode;
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
  var valid_578913 = path.getOrDefault("blogId")
  valid_578913 = validateParameter(valid_578913, JString, required = true,
                                 default = nil)
  if valid_578913 != nil:
    section.add "blogId", valid_578913
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
  ##   endDate: JString
  ##          : Latest date of comment to fetch, a date-time with RFC 3339 formatting.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : Continuation token if request is paged.
  ##   status: JArray
  ##   fetchBodies: JBool
  ##              : Whether the body content of the comments is included.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   startDate: JString
  ##            : Earliest date of comment to fetch, a date-time with RFC 3339 formatting.
  ##   maxResults: JInt
  ##             : Maximum number of comments to include in the result.
  section = newJObject()
  var valid_578914 = query.getOrDefault("key")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "key", valid_578914
  var valid_578915 = query.getOrDefault("prettyPrint")
  valid_578915 = validateParameter(valid_578915, JBool, required = false,
                                 default = newJBool(true))
  if valid_578915 != nil:
    section.add "prettyPrint", valid_578915
  var valid_578916 = query.getOrDefault("oauth_token")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "oauth_token", valid_578916
  var valid_578917 = query.getOrDefault("alt")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = newJString("json"))
  if valid_578917 != nil:
    section.add "alt", valid_578917
  var valid_578918 = query.getOrDefault("userIp")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "userIp", valid_578918
  var valid_578919 = query.getOrDefault("endDate")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "endDate", valid_578919
  var valid_578920 = query.getOrDefault("quotaUser")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "quotaUser", valid_578920
  var valid_578921 = query.getOrDefault("pageToken")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "pageToken", valid_578921
  var valid_578922 = query.getOrDefault("status")
  valid_578922 = validateParameter(valid_578922, JArray, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "status", valid_578922
  var valid_578923 = query.getOrDefault("fetchBodies")
  valid_578923 = validateParameter(valid_578923, JBool, required = false, default = nil)
  if valid_578923 != nil:
    section.add "fetchBodies", valid_578923
  var valid_578924 = query.getOrDefault("fields")
  valid_578924 = validateParameter(valid_578924, JString, required = false,
                                 default = nil)
  if valid_578924 != nil:
    section.add "fields", valid_578924
  var valid_578925 = query.getOrDefault("startDate")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = nil)
  if valid_578925 != nil:
    section.add "startDate", valid_578925
  var valid_578926 = query.getOrDefault("maxResults")
  valid_578926 = validateParameter(valid_578926, JInt, required = false, default = nil)
  if valid_578926 != nil:
    section.add "maxResults", valid_578926
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578927: Call_BloggerCommentsListByBlog_578910; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the comments for a blog, across all posts, possibly filtered.
  ## 
  let valid = call_578927.validator(path, query, header, formData, body)
  let scheme = call_578927.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578927.url(scheme.get, call_578927.host, call_578927.base,
                         call_578927.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578927, url, valid)

proc call*(call_578928: Call_BloggerCommentsListByBlog_578910; blogId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; endDate: string = "";
          quotaUser: string = ""; pageToken: string = ""; status: JsonNode = nil;
          fetchBodies: bool = false; fields: string = ""; startDate: string = "";
          maxResults: int = 0): Recallable =
  ## bloggerCommentsListByBlog
  ## Retrieves the comments for a blog, across all posts, possibly filtered.
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
  ##   endDate: string
  ##          : Latest date of comment to fetch, a date-time with RFC 3339 formatting.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : Continuation token if request is paged.
  ##   blogId: string (required)
  ##         : ID of the blog to fetch comments from.
  ##   status: JArray
  ##   fetchBodies: bool
  ##              : Whether the body content of the comments is included.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   startDate: string
  ##            : Earliest date of comment to fetch, a date-time with RFC 3339 formatting.
  ##   maxResults: int
  ##             : Maximum number of comments to include in the result.
  var path_578929 = newJObject()
  var query_578930 = newJObject()
  add(query_578930, "key", newJString(key))
  add(query_578930, "prettyPrint", newJBool(prettyPrint))
  add(query_578930, "oauth_token", newJString(oauthToken))
  add(query_578930, "alt", newJString(alt))
  add(query_578930, "userIp", newJString(userIp))
  add(query_578930, "endDate", newJString(endDate))
  add(query_578930, "quotaUser", newJString(quotaUser))
  add(query_578930, "pageToken", newJString(pageToken))
  add(path_578929, "blogId", newJString(blogId))
  if status != nil:
    query_578930.add "status", status
  add(query_578930, "fetchBodies", newJBool(fetchBodies))
  add(query_578930, "fields", newJString(fields))
  add(query_578930, "startDate", newJString(startDate))
  add(query_578930, "maxResults", newJInt(maxResults))
  result = call_578928.call(path_578929, query_578930, nil, nil, nil)

var bloggerCommentsListByBlog* = Call_BloggerCommentsListByBlog_578910(
    name: "bloggerCommentsListByBlog", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/blogs/{blogId}/comments",
    validator: validate_BloggerCommentsListByBlog_578911, base: "/blogger/v3",
    url: url_BloggerCommentsListByBlog_578912, schemes: {Scheme.Https})
type
  Call_BloggerPagesInsert_578951 = ref object of OpenApiRestCall_578339
proc url_BloggerPagesInsert_578953(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerPagesInsert_578952(path: JsonNode; query: JsonNode;
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
  var valid_578954 = path.getOrDefault("blogId")
  valid_578954 = validateParameter(valid_578954, JString, required = true,
                                 default = nil)
  if valid_578954 != nil:
    section.add "blogId", valid_578954
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   isDraft: JBool
  ##          : Whether to create the page as a draft (default: false).
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578955 = query.getOrDefault("key")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "key", valid_578955
  var valid_578956 = query.getOrDefault("prettyPrint")
  valid_578956 = validateParameter(valid_578956, JBool, required = false,
                                 default = newJBool(true))
  if valid_578956 != nil:
    section.add "prettyPrint", valid_578956
  var valid_578957 = query.getOrDefault("oauth_token")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "oauth_token", valid_578957
  var valid_578958 = query.getOrDefault("isDraft")
  valid_578958 = validateParameter(valid_578958, JBool, required = false, default = nil)
  if valid_578958 != nil:
    section.add "isDraft", valid_578958
  var valid_578959 = query.getOrDefault("alt")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = newJString("json"))
  if valid_578959 != nil:
    section.add "alt", valid_578959
  var valid_578960 = query.getOrDefault("userIp")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "userIp", valid_578960
  var valid_578961 = query.getOrDefault("quotaUser")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "quotaUser", valid_578961
  var valid_578962 = query.getOrDefault("fields")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "fields", valid_578962
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

proc call*(call_578964: Call_BloggerPagesInsert_578951; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a page.
  ## 
  let valid = call_578964.validator(path, query, header, formData, body)
  let scheme = call_578964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578964.url(scheme.get, call_578964.host, call_578964.base,
                         call_578964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578964, url, valid)

proc call*(call_578965: Call_BloggerPagesInsert_578951; blogId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          isDraft: bool = false; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## bloggerPagesInsert
  ## Add a page.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   isDraft: bool
  ##          : Whether to create the page as a draft (default: false).
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   blogId: string (required)
  ##         : ID of the blog to add the page to.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578966 = newJObject()
  var query_578967 = newJObject()
  var body_578968 = newJObject()
  add(query_578967, "key", newJString(key))
  add(query_578967, "prettyPrint", newJBool(prettyPrint))
  add(query_578967, "oauth_token", newJString(oauthToken))
  add(query_578967, "isDraft", newJBool(isDraft))
  add(query_578967, "alt", newJString(alt))
  add(query_578967, "userIp", newJString(userIp))
  add(query_578967, "quotaUser", newJString(quotaUser))
  add(path_578966, "blogId", newJString(blogId))
  if body != nil:
    body_578968 = body
  add(query_578967, "fields", newJString(fields))
  result = call_578965.call(path_578966, query_578967, nil, nil, body_578968)

var bloggerPagesInsert* = Call_BloggerPagesInsert_578951(
    name: "bloggerPagesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/blogs/{blogId}/pages",
    validator: validate_BloggerPagesInsert_578952, base: "/blogger/v3",
    url: url_BloggerPagesInsert_578953, schemes: {Scheme.Https})
type
  Call_BloggerPagesList_578931 = ref object of OpenApiRestCall_578339
proc url_BloggerPagesList_578933(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerPagesList_578932(path: JsonNode; query: JsonNode;
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
  var valid_578934 = path.getOrDefault("blogId")
  valid_578934 = validateParameter(valid_578934, JString, required = true,
                                 default = nil)
  if valid_578934 != nil:
    section.add "blogId", valid_578934
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
  ##            : Continuation token if the request is paged.
  ##   status: JArray
  ##   fetchBodies: JBool
  ##              : Whether to retrieve the Page bodies.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: JString
  ##       : Access level with which to view the returned result. Note that some fields require elevated access.
  ##   maxResults: JInt
  ##             : Maximum number of Pages to fetch.
  section = newJObject()
  var valid_578935 = query.getOrDefault("key")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "key", valid_578935
  var valid_578936 = query.getOrDefault("prettyPrint")
  valid_578936 = validateParameter(valid_578936, JBool, required = false,
                                 default = newJBool(true))
  if valid_578936 != nil:
    section.add "prettyPrint", valid_578936
  var valid_578937 = query.getOrDefault("oauth_token")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "oauth_token", valid_578937
  var valid_578938 = query.getOrDefault("alt")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = newJString("json"))
  if valid_578938 != nil:
    section.add "alt", valid_578938
  var valid_578939 = query.getOrDefault("userIp")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "userIp", valid_578939
  var valid_578940 = query.getOrDefault("quotaUser")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "quotaUser", valid_578940
  var valid_578941 = query.getOrDefault("pageToken")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "pageToken", valid_578941
  var valid_578942 = query.getOrDefault("status")
  valid_578942 = validateParameter(valid_578942, JArray, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "status", valid_578942
  var valid_578943 = query.getOrDefault("fetchBodies")
  valid_578943 = validateParameter(valid_578943, JBool, required = false, default = nil)
  if valid_578943 != nil:
    section.add "fetchBodies", valid_578943
  var valid_578944 = query.getOrDefault("fields")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "fields", valid_578944
  var valid_578945 = query.getOrDefault("view")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = newJString("ADMIN"))
  if valid_578945 != nil:
    section.add "view", valid_578945
  var valid_578946 = query.getOrDefault("maxResults")
  valid_578946 = validateParameter(valid_578946, JInt, required = false, default = nil)
  if valid_578946 != nil:
    section.add "maxResults", valid_578946
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578947: Call_BloggerPagesList_578931; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the pages for a blog, optionally including non-LIVE statuses.
  ## 
  let valid = call_578947.validator(path, query, header, formData, body)
  let scheme = call_578947.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578947.url(scheme.get, call_578947.host, call_578947.base,
                         call_578947.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578947, url, valid)

proc call*(call_578948: Call_BloggerPagesList_578931; blogId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; status: JsonNode = nil; fetchBodies: bool = false;
          fields: string = ""; view: string = "ADMIN"; maxResults: int = 0): Recallable =
  ## bloggerPagesList
  ## Retrieves the pages for a blog, optionally including non-LIVE statuses.
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
  ##            : Continuation token if the request is paged.
  ##   blogId: string (required)
  ##         : ID of the blog to fetch Pages from.
  ##   status: JArray
  ##   fetchBodies: bool
  ##              : Whether to retrieve the Page bodies.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: string
  ##       : Access level with which to view the returned result. Note that some fields require elevated access.
  ##   maxResults: int
  ##             : Maximum number of Pages to fetch.
  var path_578949 = newJObject()
  var query_578950 = newJObject()
  add(query_578950, "key", newJString(key))
  add(query_578950, "prettyPrint", newJBool(prettyPrint))
  add(query_578950, "oauth_token", newJString(oauthToken))
  add(query_578950, "alt", newJString(alt))
  add(query_578950, "userIp", newJString(userIp))
  add(query_578950, "quotaUser", newJString(quotaUser))
  add(query_578950, "pageToken", newJString(pageToken))
  add(path_578949, "blogId", newJString(blogId))
  if status != nil:
    query_578950.add "status", status
  add(query_578950, "fetchBodies", newJBool(fetchBodies))
  add(query_578950, "fields", newJString(fields))
  add(query_578950, "view", newJString(view))
  add(query_578950, "maxResults", newJInt(maxResults))
  result = call_578948.call(path_578949, query_578950, nil, nil, nil)

var bloggerPagesList* = Call_BloggerPagesList_578931(name: "bloggerPagesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/blogs/{blogId}/pages", validator: validate_BloggerPagesList_578932,
    base: "/blogger/v3", url: url_BloggerPagesList_578933, schemes: {Scheme.Https})
type
  Call_BloggerPagesUpdate_578986 = ref object of OpenApiRestCall_578339
proc url_BloggerPagesUpdate_578988(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerPagesUpdate_578987(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Update a page.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blogId: JString (required)
  ##         : The ID of the Blog.
  ##   pageId: JString (required)
  ##         : The ID of the Page.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blogId` field"
  var valid_578989 = path.getOrDefault("blogId")
  valid_578989 = validateParameter(valid_578989, JString, required = true,
                                 default = nil)
  if valid_578989 != nil:
    section.add "blogId", valid_578989
  var valid_578990 = path.getOrDefault("pageId")
  valid_578990 = validateParameter(valid_578990, JString, required = true,
                                 default = nil)
  if valid_578990 != nil:
    section.add "pageId", valid_578990
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
  ##   publish: JBool
  ##          : Whether a publish action should be performed when the page is updated (default: false).
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   revert: JBool
  ##         : Whether a revert action should be performed when the page is updated (default: false).
  section = newJObject()
  var valid_578991 = query.getOrDefault("key")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "key", valid_578991
  var valid_578992 = query.getOrDefault("prettyPrint")
  valid_578992 = validateParameter(valid_578992, JBool, required = false,
                                 default = newJBool(true))
  if valid_578992 != nil:
    section.add "prettyPrint", valid_578992
  var valid_578993 = query.getOrDefault("oauth_token")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "oauth_token", valid_578993
  var valid_578994 = query.getOrDefault("alt")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = newJString("json"))
  if valid_578994 != nil:
    section.add "alt", valid_578994
  var valid_578995 = query.getOrDefault("userIp")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "userIp", valid_578995
  var valid_578996 = query.getOrDefault("quotaUser")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "quotaUser", valid_578996
  var valid_578997 = query.getOrDefault("publish")
  valid_578997 = validateParameter(valid_578997, JBool, required = false, default = nil)
  if valid_578997 != nil:
    section.add "publish", valid_578997
  var valid_578998 = query.getOrDefault("fields")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "fields", valid_578998
  var valid_578999 = query.getOrDefault("revert")
  valid_578999 = validateParameter(valid_578999, JBool, required = false, default = nil)
  if valid_578999 != nil:
    section.add "revert", valid_578999
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

proc call*(call_579001: Call_BloggerPagesUpdate_578986; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a page.
  ## 
  let valid = call_579001.validator(path, query, header, formData, body)
  let scheme = call_579001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579001.url(scheme.get, call_579001.host, call_579001.base,
                         call_579001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579001, url, valid)

proc call*(call_579002: Call_BloggerPagesUpdate_578986; blogId: string;
          pageId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; publish: bool = false; body: JsonNode = nil;
          fields: string = ""; revert: bool = false): Recallable =
  ## bloggerPagesUpdate
  ## Update a page.
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
  ##   publish: bool
  ##          : Whether a publish action should be performed when the page is updated (default: false).
  ##   blogId: string (required)
  ##         : The ID of the Blog.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageId: string (required)
  ##         : The ID of the Page.
  ##   revert: bool
  ##         : Whether a revert action should be performed when the page is updated (default: false).
  var path_579003 = newJObject()
  var query_579004 = newJObject()
  var body_579005 = newJObject()
  add(query_579004, "key", newJString(key))
  add(query_579004, "prettyPrint", newJBool(prettyPrint))
  add(query_579004, "oauth_token", newJString(oauthToken))
  add(query_579004, "alt", newJString(alt))
  add(query_579004, "userIp", newJString(userIp))
  add(query_579004, "quotaUser", newJString(quotaUser))
  add(query_579004, "publish", newJBool(publish))
  add(path_579003, "blogId", newJString(blogId))
  if body != nil:
    body_579005 = body
  add(query_579004, "fields", newJString(fields))
  add(path_579003, "pageId", newJString(pageId))
  add(query_579004, "revert", newJBool(revert))
  result = call_579002.call(path_579003, query_579004, nil, nil, body_579005)

var bloggerPagesUpdate* = Call_BloggerPagesUpdate_578986(
    name: "bloggerPagesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/blogs/{blogId}/pages/{pageId}",
    validator: validate_BloggerPagesUpdate_578987, base: "/blogger/v3",
    url: url_BloggerPagesUpdate_578988, schemes: {Scheme.Https})
type
  Call_BloggerPagesGet_578969 = ref object of OpenApiRestCall_578339
proc url_BloggerPagesGet_578971(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerPagesGet_578970(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets one blog page by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blogId: JString (required)
  ##         : ID of the blog containing the page.
  ##   pageId: JString (required)
  ##         : The ID of the page to get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blogId` field"
  var valid_578972 = path.getOrDefault("blogId")
  valid_578972 = validateParameter(valid_578972, JString, required = true,
                                 default = nil)
  if valid_578972 != nil:
    section.add "blogId", valid_578972
  var valid_578973 = path.getOrDefault("pageId")
  valid_578973 = validateParameter(valid_578973, JString, required = true,
                                 default = nil)
  if valid_578973 != nil:
    section.add "pageId", valid_578973
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
  ##   view: JString
  section = newJObject()
  var valid_578974 = query.getOrDefault("key")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "key", valid_578974
  var valid_578975 = query.getOrDefault("prettyPrint")
  valid_578975 = validateParameter(valid_578975, JBool, required = false,
                                 default = newJBool(true))
  if valid_578975 != nil:
    section.add "prettyPrint", valid_578975
  var valid_578976 = query.getOrDefault("oauth_token")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "oauth_token", valid_578976
  var valid_578977 = query.getOrDefault("alt")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = newJString("json"))
  if valid_578977 != nil:
    section.add "alt", valid_578977
  var valid_578978 = query.getOrDefault("userIp")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "userIp", valid_578978
  var valid_578979 = query.getOrDefault("quotaUser")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = nil)
  if valid_578979 != nil:
    section.add "quotaUser", valid_578979
  var valid_578980 = query.getOrDefault("fields")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = nil)
  if valid_578980 != nil:
    section.add "fields", valid_578980
  var valid_578981 = query.getOrDefault("view")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = newJString("ADMIN"))
  if valid_578981 != nil:
    section.add "view", valid_578981
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578982: Call_BloggerPagesGet_578969; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one blog page by ID.
  ## 
  let valid = call_578982.validator(path, query, header, formData, body)
  let scheme = call_578982.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578982.url(scheme.get, call_578982.host, call_578982.base,
                         call_578982.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578982, url, valid)

proc call*(call_578983: Call_BloggerPagesGet_578969; blogId: string; pageId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""; view: string = "ADMIN"): Recallable =
  ## bloggerPagesGet
  ## Gets one blog page by ID.
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
  ##   blogId: string (required)
  ##         : ID of the blog containing the page.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageId: string (required)
  ##         : The ID of the page to get.
  ##   view: string
  var path_578984 = newJObject()
  var query_578985 = newJObject()
  add(query_578985, "key", newJString(key))
  add(query_578985, "prettyPrint", newJBool(prettyPrint))
  add(query_578985, "oauth_token", newJString(oauthToken))
  add(query_578985, "alt", newJString(alt))
  add(query_578985, "userIp", newJString(userIp))
  add(query_578985, "quotaUser", newJString(quotaUser))
  add(path_578984, "blogId", newJString(blogId))
  add(query_578985, "fields", newJString(fields))
  add(path_578984, "pageId", newJString(pageId))
  add(query_578985, "view", newJString(view))
  result = call_578983.call(path_578984, query_578985, nil, nil, nil)

var bloggerPagesGet* = Call_BloggerPagesGet_578969(name: "bloggerPagesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/blogs/{blogId}/pages/{pageId}", validator: validate_BloggerPagesGet_578970,
    base: "/blogger/v3", url: url_BloggerPagesGet_578971, schemes: {Scheme.Https})
type
  Call_BloggerPagesPatch_579022 = ref object of OpenApiRestCall_578339
proc url_BloggerPagesPatch_579024(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerPagesPatch_579023(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Update a page. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blogId: JString (required)
  ##         : The ID of the Blog.
  ##   pageId: JString (required)
  ##         : The ID of the Page.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blogId` field"
  var valid_579025 = path.getOrDefault("blogId")
  valid_579025 = validateParameter(valid_579025, JString, required = true,
                                 default = nil)
  if valid_579025 != nil:
    section.add "blogId", valid_579025
  var valid_579026 = path.getOrDefault("pageId")
  valid_579026 = validateParameter(valid_579026, JString, required = true,
                                 default = nil)
  if valid_579026 != nil:
    section.add "pageId", valid_579026
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
  ##   publish: JBool
  ##          : Whether a publish action should be performed when the page is updated (default: false).
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   revert: JBool
  ##         : Whether a revert action should be performed when the page is updated (default: false).
  section = newJObject()
  var valid_579027 = query.getOrDefault("key")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "key", valid_579027
  var valid_579028 = query.getOrDefault("prettyPrint")
  valid_579028 = validateParameter(valid_579028, JBool, required = false,
                                 default = newJBool(true))
  if valid_579028 != nil:
    section.add "prettyPrint", valid_579028
  var valid_579029 = query.getOrDefault("oauth_token")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "oauth_token", valid_579029
  var valid_579030 = query.getOrDefault("alt")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = newJString("json"))
  if valid_579030 != nil:
    section.add "alt", valid_579030
  var valid_579031 = query.getOrDefault("userIp")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = nil)
  if valid_579031 != nil:
    section.add "userIp", valid_579031
  var valid_579032 = query.getOrDefault("quotaUser")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = nil)
  if valid_579032 != nil:
    section.add "quotaUser", valid_579032
  var valid_579033 = query.getOrDefault("publish")
  valid_579033 = validateParameter(valid_579033, JBool, required = false, default = nil)
  if valid_579033 != nil:
    section.add "publish", valid_579033
  var valid_579034 = query.getOrDefault("fields")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "fields", valid_579034
  var valid_579035 = query.getOrDefault("revert")
  valid_579035 = validateParameter(valid_579035, JBool, required = false, default = nil)
  if valid_579035 != nil:
    section.add "revert", valid_579035
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

proc call*(call_579037: Call_BloggerPagesPatch_579022; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a page. This method supports patch semantics.
  ## 
  let valid = call_579037.validator(path, query, header, formData, body)
  let scheme = call_579037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579037.url(scheme.get, call_579037.host, call_579037.base,
                         call_579037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579037, url, valid)

proc call*(call_579038: Call_BloggerPagesPatch_579022; blogId: string;
          pageId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; publish: bool = false; body: JsonNode = nil;
          fields: string = ""; revert: bool = false): Recallable =
  ## bloggerPagesPatch
  ## Update a page. This method supports patch semantics.
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
  ##   publish: bool
  ##          : Whether a publish action should be performed when the page is updated (default: false).
  ##   blogId: string (required)
  ##         : The ID of the Blog.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageId: string (required)
  ##         : The ID of the Page.
  ##   revert: bool
  ##         : Whether a revert action should be performed when the page is updated (default: false).
  var path_579039 = newJObject()
  var query_579040 = newJObject()
  var body_579041 = newJObject()
  add(query_579040, "key", newJString(key))
  add(query_579040, "prettyPrint", newJBool(prettyPrint))
  add(query_579040, "oauth_token", newJString(oauthToken))
  add(query_579040, "alt", newJString(alt))
  add(query_579040, "userIp", newJString(userIp))
  add(query_579040, "quotaUser", newJString(quotaUser))
  add(query_579040, "publish", newJBool(publish))
  add(path_579039, "blogId", newJString(blogId))
  if body != nil:
    body_579041 = body
  add(query_579040, "fields", newJString(fields))
  add(path_579039, "pageId", newJString(pageId))
  add(query_579040, "revert", newJBool(revert))
  result = call_579038.call(path_579039, query_579040, nil, nil, body_579041)

var bloggerPagesPatch* = Call_BloggerPagesPatch_579022(name: "bloggerPagesPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/blogs/{blogId}/pages/{pageId}",
    validator: validate_BloggerPagesPatch_579023, base: "/blogger/v3",
    url: url_BloggerPagesPatch_579024, schemes: {Scheme.Https})
type
  Call_BloggerPagesDelete_579006 = ref object of OpenApiRestCall_578339
proc url_BloggerPagesDelete_579008(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerPagesDelete_579007(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Delete a page by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blogId: JString (required)
  ##         : The ID of the Blog.
  ##   pageId: JString (required)
  ##         : The ID of the Page.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blogId` field"
  var valid_579009 = path.getOrDefault("blogId")
  valid_579009 = validateParameter(valid_579009, JString, required = true,
                                 default = nil)
  if valid_579009 != nil:
    section.add "blogId", valid_579009
  var valid_579010 = path.getOrDefault("pageId")
  valid_579010 = validateParameter(valid_579010, JString, required = true,
                                 default = nil)
  if valid_579010 != nil:
    section.add "pageId", valid_579010
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
  var valid_579011 = query.getOrDefault("key")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "key", valid_579011
  var valid_579012 = query.getOrDefault("prettyPrint")
  valid_579012 = validateParameter(valid_579012, JBool, required = false,
                                 default = newJBool(true))
  if valid_579012 != nil:
    section.add "prettyPrint", valid_579012
  var valid_579013 = query.getOrDefault("oauth_token")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "oauth_token", valid_579013
  var valid_579014 = query.getOrDefault("alt")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = newJString("json"))
  if valid_579014 != nil:
    section.add "alt", valid_579014
  var valid_579015 = query.getOrDefault("userIp")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "userIp", valid_579015
  var valid_579016 = query.getOrDefault("quotaUser")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "quotaUser", valid_579016
  var valid_579017 = query.getOrDefault("fields")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "fields", valid_579017
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579018: Call_BloggerPagesDelete_579006; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a page by ID.
  ## 
  let valid = call_579018.validator(path, query, header, formData, body)
  let scheme = call_579018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579018.url(scheme.get, call_579018.host, call_579018.base,
                         call_579018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579018, url, valid)

proc call*(call_579019: Call_BloggerPagesDelete_579006; blogId: string;
          pageId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## bloggerPagesDelete
  ## Delete a page by ID.
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
  ##   blogId: string (required)
  ##         : The ID of the Blog.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageId: string (required)
  ##         : The ID of the Page.
  var path_579020 = newJObject()
  var query_579021 = newJObject()
  add(query_579021, "key", newJString(key))
  add(query_579021, "prettyPrint", newJBool(prettyPrint))
  add(query_579021, "oauth_token", newJString(oauthToken))
  add(query_579021, "alt", newJString(alt))
  add(query_579021, "userIp", newJString(userIp))
  add(query_579021, "quotaUser", newJString(quotaUser))
  add(path_579020, "blogId", newJString(blogId))
  add(query_579021, "fields", newJString(fields))
  add(path_579020, "pageId", newJString(pageId))
  result = call_579019.call(path_579020, query_579021, nil, nil, nil)

var bloggerPagesDelete* = Call_BloggerPagesDelete_579006(
    name: "bloggerPagesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/blogs/{blogId}/pages/{pageId}",
    validator: validate_BloggerPagesDelete_579007, base: "/blogger/v3",
    url: url_BloggerPagesDelete_579008, schemes: {Scheme.Https})
type
  Call_BloggerPagesPublish_579042 = ref object of OpenApiRestCall_578339
proc url_BloggerPagesPublish_579044(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerPagesPublish_579043(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Publishes a draft page.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blogId: JString (required)
  ##         : The ID of the blog.
  ##   pageId: JString (required)
  ##         : The ID of the page.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blogId` field"
  var valid_579045 = path.getOrDefault("blogId")
  valid_579045 = validateParameter(valid_579045, JString, required = true,
                                 default = nil)
  if valid_579045 != nil:
    section.add "blogId", valid_579045
  var valid_579046 = path.getOrDefault("pageId")
  valid_579046 = validateParameter(valid_579046, JString, required = true,
                                 default = nil)
  if valid_579046 != nil:
    section.add "pageId", valid_579046
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
  var valid_579047 = query.getOrDefault("key")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "key", valid_579047
  var valid_579048 = query.getOrDefault("prettyPrint")
  valid_579048 = validateParameter(valid_579048, JBool, required = false,
                                 default = newJBool(true))
  if valid_579048 != nil:
    section.add "prettyPrint", valid_579048
  var valid_579049 = query.getOrDefault("oauth_token")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = nil)
  if valid_579049 != nil:
    section.add "oauth_token", valid_579049
  var valid_579050 = query.getOrDefault("alt")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = newJString("json"))
  if valid_579050 != nil:
    section.add "alt", valid_579050
  var valid_579051 = query.getOrDefault("userIp")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = nil)
  if valid_579051 != nil:
    section.add "userIp", valid_579051
  var valid_579052 = query.getOrDefault("quotaUser")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = nil)
  if valid_579052 != nil:
    section.add "quotaUser", valid_579052
  var valid_579053 = query.getOrDefault("fields")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = nil)
  if valid_579053 != nil:
    section.add "fields", valid_579053
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579054: Call_BloggerPagesPublish_579042; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Publishes a draft page.
  ## 
  let valid = call_579054.validator(path, query, header, formData, body)
  let scheme = call_579054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579054.url(scheme.get, call_579054.host, call_579054.base,
                         call_579054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579054, url, valid)

proc call*(call_579055: Call_BloggerPagesPublish_579042; blogId: string;
          pageId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## bloggerPagesPublish
  ## Publishes a draft page.
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
  ##   blogId: string (required)
  ##         : The ID of the blog.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageId: string (required)
  ##         : The ID of the page.
  var path_579056 = newJObject()
  var query_579057 = newJObject()
  add(query_579057, "key", newJString(key))
  add(query_579057, "prettyPrint", newJBool(prettyPrint))
  add(query_579057, "oauth_token", newJString(oauthToken))
  add(query_579057, "alt", newJString(alt))
  add(query_579057, "userIp", newJString(userIp))
  add(query_579057, "quotaUser", newJString(quotaUser))
  add(path_579056, "blogId", newJString(blogId))
  add(query_579057, "fields", newJString(fields))
  add(path_579056, "pageId", newJString(pageId))
  result = call_579055.call(path_579056, query_579057, nil, nil, nil)

var bloggerPagesPublish* = Call_BloggerPagesPublish_579042(
    name: "bloggerPagesPublish", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/blogs/{blogId}/pages/{pageId}/publish",
    validator: validate_BloggerPagesPublish_579043, base: "/blogger/v3",
    url: url_BloggerPagesPublish_579044, schemes: {Scheme.Https})
type
  Call_BloggerPagesRevert_579058 = ref object of OpenApiRestCall_578339
proc url_BloggerPagesRevert_579060(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerPagesRevert_579059(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Revert a published or scheduled page to draft state.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blogId: JString (required)
  ##         : The ID of the blog.
  ##   pageId: JString (required)
  ##         : The ID of the page.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blogId` field"
  var valid_579061 = path.getOrDefault("blogId")
  valid_579061 = validateParameter(valid_579061, JString, required = true,
                                 default = nil)
  if valid_579061 != nil:
    section.add "blogId", valid_579061
  var valid_579062 = path.getOrDefault("pageId")
  valid_579062 = validateParameter(valid_579062, JString, required = true,
                                 default = nil)
  if valid_579062 != nil:
    section.add "pageId", valid_579062
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
  var valid_579063 = query.getOrDefault("key")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = nil)
  if valid_579063 != nil:
    section.add "key", valid_579063
  var valid_579064 = query.getOrDefault("prettyPrint")
  valid_579064 = validateParameter(valid_579064, JBool, required = false,
                                 default = newJBool(true))
  if valid_579064 != nil:
    section.add "prettyPrint", valid_579064
  var valid_579065 = query.getOrDefault("oauth_token")
  valid_579065 = validateParameter(valid_579065, JString, required = false,
                                 default = nil)
  if valid_579065 != nil:
    section.add "oauth_token", valid_579065
  var valid_579066 = query.getOrDefault("alt")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = newJString("json"))
  if valid_579066 != nil:
    section.add "alt", valid_579066
  var valid_579067 = query.getOrDefault("userIp")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = nil)
  if valid_579067 != nil:
    section.add "userIp", valid_579067
  var valid_579068 = query.getOrDefault("quotaUser")
  valid_579068 = validateParameter(valid_579068, JString, required = false,
                                 default = nil)
  if valid_579068 != nil:
    section.add "quotaUser", valid_579068
  var valid_579069 = query.getOrDefault("fields")
  valid_579069 = validateParameter(valid_579069, JString, required = false,
                                 default = nil)
  if valid_579069 != nil:
    section.add "fields", valid_579069
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579070: Call_BloggerPagesRevert_579058; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Revert a published or scheduled page to draft state.
  ## 
  let valid = call_579070.validator(path, query, header, formData, body)
  let scheme = call_579070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579070.url(scheme.get, call_579070.host, call_579070.base,
                         call_579070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579070, url, valid)

proc call*(call_579071: Call_BloggerPagesRevert_579058; blogId: string;
          pageId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## bloggerPagesRevert
  ## Revert a published or scheduled page to draft state.
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
  ##   blogId: string (required)
  ##         : The ID of the blog.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageId: string (required)
  ##         : The ID of the page.
  var path_579072 = newJObject()
  var query_579073 = newJObject()
  add(query_579073, "key", newJString(key))
  add(query_579073, "prettyPrint", newJBool(prettyPrint))
  add(query_579073, "oauth_token", newJString(oauthToken))
  add(query_579073, "alt", newJString(alt))
  add(query_579073, "userIp", newJString(userIp))
  add(query_579073, "quotaUser", newJString(quotaUser))
  add(path_579072, "blogId", newJString(blogId))
  add(query_579073, "fields", newJString(fields))
  add(path_579072, "pageId", newJString(pageId))
  result = call_579071.call(path_579072, query_579073, nil, nil, nil)

var bloggerPagesRevert* = Call_BloggerPagesRevert_579058(
    name: "bloggerPagesRevert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/blogs/{blogId}/pages/{pageId}/revert",
    validator: validate_BloggerPagesRevert_579059, base: "/blogger/v3",
    url: url_BloggerPagesRevert_579060, schemes: {Scheme.Https})
type
  Call_BloggerPageViewsGet_579074 = ref object of OpenApiRestCall_578339
proc url_BloggerPageViewsGet_579076(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerPageViewsGet_579075(path: JsonNode; query: JsonNode;
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
  var valid_579077 = path.getOrDefault("blogId")
  valid_579077 = validateParameter(valid_579077, JString, required = true,
                                 default = nil)
  if valid_579077 != nil:
    section.add "blogId", valid_579077
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
  ##   range: JArray
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579078 = query.getOrDefault("key")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "key", valid_579078
  var valid_579079 = query.getOrDefault("prettyPrint")
  valid_579079 = validateParameter(valid_579079, JBool, required = false,
                                 default = newJBool(true))
  if valid_579079 != nil:
    section.add "prettyPrint", valid_579079
  var valid_579080 = query.getOrDefault("oauth_token")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "oauth_token", valid_579080
  var valid_579081 = query.getOrDefault("alt")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = newJString("json"))
  if valid_579081 != nil:
    section.add "alt", valid_579081
  var valid_579082 = query.getOrDefault("userIp")
  valid_579082 = validateParameter(valid_579082, JString, required = false,
                                 default = nil)
  if valid_579082 != nil:
    section.add "userIp", valid_579082
  var valid_579083 = query.getOrDefault("quotaUser")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = nil)
  if valid_579083 != nil:
    section.add "quotaUser", valid_579083
  var valid_579084 = query.getOrDefault("range")
  valid_579084 = validateParameter(valid_579084, JArray, required = false,
                                 default = nil)
  if valid_579084 != nil:
    section.add "range", valid_579084
  var valid_579085 = query.getOrDefault("fields")
  valid_579085 = validateParameter(valid_579085, JString, required = false,
                                 default = nil)
  if valid_579085 != nil:
    section.add "fields", valid_579085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579086: Call_BloggerPageViewsGet_579074; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve pageview stats for a Blog.
  ## 
  let valid = call_579086.validator(path, query, header, formData, body)
  let scheme = call_579086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579086.url(scheme.get, call_579086.host, call_579086.base,
                         call_579086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579086, url, valid)

proc call*(call_579087: Call_BloggerPageViewsGet_579074; blogId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          range: JsonNode = nil; fields: string = ""): Recallable =
  ## bloggerPageViewsGet
  ## Retrieve pageview stats for a Blog.
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
  ##   blogId: string (required)
  ##         : The ID of the blog to get.
  ##   range: JArray
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579088 = newJObject()
  var query_579089 = newJObject()
  add(query_579089, "key", newJString(key))
  add(query_579089, "prettyPrint", newJBool(prettyPrint))
  add(query_579089, "oauth_token", newJString(oauthToken))
  add(query_579089, "alt", newJString(alt))
  add(query_579089, "userIp", newJString(userIp))
  add(query_579089, "quotaUser", newJString(quotaUser))
  add(path_579088, "blogId", newJString(blogId))
  if range != nil:
    query_579089.add "range", range
  add(query_579089, "fields", newJString(fields))
  result = call_579087.call(path_579088, query_579089, nil, nil, nil)

var bloggerPageViewsGet* = Call_BloggerPageViewsGet_579074(
    name: "bloggerPageViewsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/blogs/{blogId}/pageviews",
    validator: validate_BloggerPageViewsGet_579075, base: "/blogger/v3",
    url: url_BloggerPageViewsGet_579076, schemes: {Scheme.Https})
type
  Call_BloggerPostsInsert_579115 = ref object of OpenApiRestCall_578339
proc url_BloggerPostsInsert_579117(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerPostsInsert_579116(path: JsonNode; query: JsonNode;
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
  var valid_579118 = path.getOrDefault("blogId")
  valid_579118 = validateParameter(valid_579118, JString, required = true,
                                 default = nil)
  if valid_579118 != nil:
    section.add "blogId", valid_579118
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   isDraft: JBool
  ##          : Whether to create the post as a draft (default: false).
  ##   fetchBody: JBool
  ##            : Whether the body content of the post is included with the result (default: true).
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fetchImages: JBool
  ##              : Whether image URL metadata for each post is included in the returned result (default: false).
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579119 = query.getOrDefault("key")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = nil)
  if valid_579119 != nil:
    section.add "key", valid_579119
  var valid_579120 = query.getOrDefault("prettyPrint")
  valid_579120 = validateParameter(valid_579120, JBool, required = false,
                                 default = newJBool(true))
  if valid_579120 != nil:
    section.add "prettyPrint", valid_579120
  var valid_579121 = query.getOrDefault("oauth_token")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = nil)
  if valid_579121 != nil:
    section.add "oauth_token", valid_579121
  var valid_579122 = query.getOrDefault("isDraft")
  valid_579122 = validateParameter(valid_579122, JBool, required = false, default = nil)
  if valid_579122 != nil:
    section.add "isDraft", valid_579122
  var valid_579123 = query.getOrDefault("fetchBody")
  valid_579123 = validateParameter(valid_579123, JBool, required = false,
                                 default = newJBool(true))
  if valid_579123 != nil:
    section.add "fetchBody", valid_579123
  var valid_579124 = query.getOrDefault("alt")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = newJString("json"))
  if valid_579124 != nil:
    section.add "alt", valid_579124
  var valid_579125 = query.getOrDefault("userIp")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = nil)
  if valid_579125 != nil:
    section.add "userIp", valid_579125
  var valid_579126 = query.getOrDefault("quotaUser")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "quotaUser", valid_579126
  var valid_579127 = query.getOrDefault("fetchImages")
  valid_579127 = validateParameter(valid_579127, JBool, required = false, default = nil)
  if valid_579127 != nil:
    section.add "fetchImages", valid_579127
  var valid_579128 = query.getOrDefault("fields")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = nil)
  if valid_579128 != nil:
    section.add "fields", valid_579128
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

proc call*(call_579130: Call_BloggerPostsInsert_579115; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a post.
  ## 
  let valid = call_579130.validator(path, query, header, formData, body)
  let scheme = call_579130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579130.url(scheme.get, call_579130.host, call_579130.base,
                         call_579130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579130, url, valid)

proc call*(call_579131: Call_BloggerPostsInsert_579115; blogId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          isDraft: bool = false; fetchBody: bool = true; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fetchImages: bool = false;
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## bloggerPostsInsert
  ## Add a post.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   isDraft: bool
  ##          : Whether to create the post as a draft (default: false).
  ##   fetchBody: bool
  ##            : Whether the body content of the post is included with the result (default: true).
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   blogId: string (required)
  ##         : ID of the blog to add the post to.
  ##   fetchImages: bool
  ##              : Whether image URL metadata for each post is included in the returned result (default: false).
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579132 = newJObject()
  var query_579133 = newJObject()
  var body_579134 = newJObject()
  add(query_579133, "key", newJString(key))
  add(query_579133, "prettyPrint", newJBool(prettyPrint))
  add(query_579133, "oauth_token", newJString(oauthToken))
  add(query_579133, "isDraft", newJBool(isDraft))
  add(query_579133, "fetchBody", newJBool(fetchBody))
  add(query_579133, "alt", newJString(alt))
  add(query_579133, "userIp", newJString(userIp))
  add(query_579133, "quotaUser", newJString(quotaUser))
  add(path_579132, "blogId", newJString(blogId))
  add(query_579133, "fetchImages", newJBool(fetchImages))
  if body != nil:
    body_579134 = body
  add(query_579133, "fields", newJString(fields))
  result = call_579131.call(path_579132, query_579133, nil, nil, body_579134)

var bloggerPostsInsert* = Call_BloggerPostsInsert_579115(
    name: "bloggerPostsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/blogs/{blogId}/posts",
    validator: validate_BloggerPostsInsert_579116, base: "/blogger/v3",
    url: url_BloggerPostsInsert_579117, schemes: {Scheme.Https})
type
  Call_BloggerPostsList_579090 = ref object of OpenApiRestCall_578339
proc url_BloggerPostsList_579092(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerPostsList_579091(path: JsonNode; query: JsonNode;
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
  var valid_579093 = path.getOrDefault("blogId")
  valid_579093 = validateParameter(valid_579093, JString, required = true,
                                 default = nil)
  if valid_579093 != nil:
    section.add "blogId", valid_579093
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   labels: JString
  ##         : Comma-separated list of labels to search for.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   endDate: JString
  ##          : Latest post date to fetch, a date-time with RFC 3339 formatting.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   orderBy: JString
  ##          : Sort search results
  ##   pageToken: JString
  ##            : Continuation token if the request is paged.
  ##   fetchImages: JBool
  ##              : Whether image URL metadata for each post is included.
  ##   status: JArray
  ##         : Statuses to include in the results.
  ##   fetchBodies: JBool
  ##              : Whether the body content of posts is included (default: true). This should be set to false when the post bodies are not required, to help minimize traffic.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   startDate: JString
  ##            : Earliest post date to fetch, a date-time with RFC 3339 formatting.
  ##   view: JString
  ##       : Access level with which to view the returned result. Note that some fields require escalated access.
  ##   maxResults: JInt
  ##             : Maximum number of posts to fetch.
  section = newJObject()
  var valid_579094 = query.getOrDefault("key")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = nil)
  if valid_579094 != nil:
    section.add "key", valid_579094
  var valid_579095 = query.getOrDefault("labels")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "labels", valid_579095
  var valid_579096 = query.getOrDefault("prettyPrint")
  valid_579096 = validateParameter(valid_579096, JBool, required = false,
                                 default = newJBool(true))
  if valid_579096 != nil:
    section.add "prettyPrint", valid_579096
  var valid_579097 = query.getOrDefault("oauth_token")
  valid_579097 = validateParameter(valid_579097, JString, required = false,
                                 default = nil)
  if valid_579097 != nil:
    section.add "oauth_token", valid_579097
  var valid_579098 = query.getOrDefault("alt")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = newJString("json"))
  if valid_579098 != nil:
    section.add "alt", valid_579098
  var valid_579099 = query.getOrDefault("userIp")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = nil)
  if valid_579099 != nil:
    section.add "userIp", valid_579099
  var valid_579100 = query.getOrDefault("endDate")
  valid_579100 = validateParameter(valid_579100, JString, required = false,
                                 default = nil)
  if valid_579100 != nil:
    section.add "endDate", valid_579100
  var valid_579101 = query.getOrDefault("quotaUser")
  valid_579101 = validateParameter(valid_579101, JString, required = false,
                                 default = nil)
  if valid_579101 != nil:
    section.add "quotaUser", valid_579101
  var valid_579102 = query.getOrDefault("orderBy")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = newJString("published"))
  if valid_579102 != nil:
    section.add "orderBy", valid_579102
  var valid_579103 = query.getOrDefault("pageToken")
  valid_579103 = validateParameter(valid_579103, JString, required = false,
                                 default = nil)
  if valid_579103 != nil:
    section.add "pageToken", valid_579103
  var valid_579104 = query.getOrDefault("fetchImages")
  valid_579104 = validateParameter(valid_579104, JBool, required = false, default = nil)
  if valid_579104 != nil:
    section.add "fetchImages", valid_579104
  var valid_579105 = query.getOrDefault("status")
  valid_579105 = validateParameter(valid_579105, JArray, required = false,
                                 default = nil)
  if valid_579105 != nil:
    section.add "status", valid_579105
  var valid_579106 = query.getOrDefault("fetchBodies")
  valid_579106 = validateParameter(valid_579106, JBool, required = false,
                                 default = newJBool(true))
  if valid_579106 != nil:
    section.add "fetchBodies", valid_579106
  var valid_579107 = query.getOrDefault("fields")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "fields", valid_579107
  var valid_579108 = query.getOrDefault("startDate")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = nil)
  if valid_579108 != nil:
    section.add "startDate", valid_579108
  var valid_579109 = query.getOrDefault("view")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = newJString("ADMIN"))
  if valid_579109 != nil:
    section.add "view", valid_579109
  var valid_579110 = query.getOrDefault("maxResults")
  valid_579110 = validateParameter(valid_579110, JInt, required = false, default = nil)
  if valid_579110 != nil:
    section.add "maxResults", valid_579110
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579111: Call_BloggerPostsList_579090; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of posts, possibly filtered.
  ## 
  let valid = call_579111.validator(path, query, header, formData, body)
  let scheme = call_579111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579111.url(scheme.get, call_579111.host, call_579111.base,
                         call_579111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579111, url, valid)

proc call*(call_579112: Call_BloggerPostsList_579090; blogId: string;
          key: string = ""; labels: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          endDate: string = ""; quotaUser: string = ""; orderBy: string = "published";
          pageToken: string = ""; fetchImages: bool = false; status: JsonNode = nil;
          fetchBodies: bool = true; fields: string = ""; startDate: string = "";
          view: string = "ADMIN"; maxResults: int = 0): Recallable =
  ## bloggerPostsList
  ## Retrieves a list of posts, possibly filtered.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   labels: string
  ##         : Comma-separated list of labels to search for.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   endDate: string
  ##          : Latest post date to fetch, a date-time with RFC 3339 formatting.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   orderBy: string
  ##          : Sort search results
  ##   pageToken: string
  ##            : Continuation token if the request is paged.
  ##   blogId: string (required)
  ##         : ID of the blog to fetch posts from.
  ##   fetchImages: bool
  ##              : Whether image URL metadata for each post is included.
  ##   status: JArray
  ##         : Statuses to include in the results.
  ##   fetchBodies: bool
  ##              : Whether the body content of posts is included (default: true). This should be set to false when the post bodies are not required, to help minimize traffic.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   startDate: string
  ##            : Earliest post date to fetch, a date-time with RFC 3339 formatting.
  ##   view: string
  ##       : Access level with which to view the returned result. Note that some fields require escalated access.
  ##   maxResults: int
  ##             : Maximum number of posts to fetch.
  var path_579113 = newJObject()
  var query_579114 = newJObject()
  add(query_579114, "key", newJString(key))
  add(query_579114, "labels", newJString(labels))
  add(query_579114, "prettyPrint", newJBool(prettyPrint))
  add(query_579114, "oauth_token", newJString(oauthToken))
  add(query_579114, "alt", newJString(alt))
  add(query_579114, "userIp", newJString(userIp))
  add(query_579114, "endDate", newJString(endDate))
  add(query_579114, "quotaUser", newJString(quotaUser))
  add(query_579114, "orderBy", newJString(orderBy))
  add(query_579114, "pageToken", newJString(pageToken))
  add(path_579113, "blogId", newJString(blogId))
  add(query_579114, "fetchImages", newJBool(fetchImages))
  if status != nil:
    query_579114.add "status", status
  add(query_579114, "fetchBodies", newJBool(fetchBodies))
  add(query_579114, "fields", newJString(fields))
  add(query_579114, "startDate", newJString(startDate))
  add(query_579114, "view", newJString(view))
  add(query_579114, "maxResults", newJInt(maxResults))
  result = call_579112.call(path_579113, query_579114, nil, nil, nil)

var bloggerPostsList* = Call_BloggerPostsList_579090(name: "bloggerPostsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/blogs/{blogId}/posts", validator: validate_BloggerPostsList_579091,
    base: "/blogger/v3", url: url_BloggerPostsList_579092, schemes: {Scheme.Https})
type
  Call_BloggerPostsGetByPath_579135 = ref object of OpenApiRestCall_578339
proc url_BloggerPostsGetByPath_579137(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerPostsGetByPath_579136(path: JsonNode; query: JsonNode;
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
  var valid_579138 = path.getOrDefault("blogId")
  valid_579138 = validateParameter(valid_579138, JString, required = true,
                                 default = nil)
  if valid_579138 != nil:
    section.add "blogId", valid_579138
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
  ##   path: JString (required)
  ##       : Path of the Post to retrieve.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxComments: JInt
  ##              : Maximum number of comments to pull back on a post.
  ##   view: JString
  ##       : Access level with which to view the returned result. Note that some fields require elevated access.
  section = newJObject()
  var valid_579139 = query.getOrDefault("key")
  valid_579139 = validateParameter(valid_579139, JString, required = false,
                                 default = nil)
  if valid_579139 != nil:
    section.add "key", valid_579139
  var valid_579140 = query.getOrDefault("prettyPrint")
  valid_579140 = validateParameter(valid_579140, JBool, required = false,
                                 default = newJBool(true))
  if valid_579140 != nil:
    section.add "prettyPrint", valid_579140
  var valid_579141 = query.getOrDefault("oauth_token")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = nil)
  if valid_579141 != nil:
    section.add "oauth_token", valid_579141
  var valid_579142 = query.getOrDefault("alt")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = newJString("json"))
  if valid_579142 != nil:
    section.add "alt", valid_579142
  var valid_579143 = query.getOrDefault("userIp")
  valid_579143 = validateParameter(valid_579143, JString, required = false,
                                 default = nil)
  if valid_579143 != nil:
    section.add "userIp", valid_579143
  var valid_579144 = query.getOrDefault("quotaUser")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = nil)
  if valid_579144 != nil:
    section.add "quotaUser", valid_579144
  assert query != nil, "query argument is necessary due to required `path` field"
  var valid_579145 = query.getOrDefault("path")
  valid_579145 = validateParameter(valid_579145, JString, required = true,
                                 default = nil)
  if valid_579145 != nil:
    section.add "path", valid_579145
  var valid_579146 = query.getOrDefault("fields")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = nil)
  if valid_579146 != nil:
    section.add "fields", valid_579146
  var valid_579147 = query.getOrDefault("maxComments")
  valid_579147 = validateParameter(valid_579147, JInt, required = false, default = nil)
  if valid_579147 != nil:
    section.add "maxComments", valid_579147
  var valid_579148 = query.getOrDefault("view")
  valid_579148 = validateParameter(valid_579148, JString, required = false,
                                 default = newJString("ADMIN"))
  if valid_579148 != nil:
    section.add "view", valid_579148
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579149: Call_BloggerPostsGetByPath_579135; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a Post by Path.
  ## 
  let valid = call_579149.validator(path, query, header, formData, body)
  let scheme = call_579149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579149.url(scheme.get, call_579149.host, call_579149.base,
                         call_579149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579149, url, valid)

proc call*(call_579150: Call_BloggerPostsGetByPath_579135; path: string;
          blogId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""; maxComments: int = 0;
          view: string = "ADMIN"): Recallable =
  ## bloggerPostsGetByPath
  ## Retrieve a Post by Path.
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
  ##   path: string (required)
  ##       : Path of the Post to retrieve.
  ##   blogId: string (required)
  ##         : ID of the blog to fetch the post from.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxComments: int
  ##              : Maximum number of comments to pull back on a post.
  ##   view: string
  ##       : Access level with which to view the returned result. Note that some fields require elevated access.
  var path_579151 = newJObject()
  var query_579152 = newJObject()
  add(query_579152, "key", newJString(key))
  add(query_579152, "prettyPrint", newJBool(prettyPrint))
  add(query_579152, "oauth_token", newJString(oauthToken))
  add(query_579152, "alt", newJString(alt))
  add(query_579152, "userIp", newJString(userIp))
  add(query_579152, "quotaUser", newJString(quotaUser))
  add(query_579152, "path", newJString(path))
  add(path_579151, "blogId", newJString(blogId))
  add(query_579152, "fields", newJString(fields))
  add(query_579152, "maxComments", newJInt(maxComments))
  add(query_579152, "view", newJString(view))
  result = call_579150.call(path_579151, query_579152, nil, nil, nil)

var bloggerPostsGetByPath* = Call_BloggerPostsGetByPath_579135(
    name: "bloggerPostsGetByPath", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/blogs/{blogId}/posts/bypath",
    validator: validate_BloggerPostsGetByPath_579136, base: "/blogger/v3",
    url: url_BloggerPostsGetByPath_579137, schemes: {Scheme.Https})
type
  Call_BloggerPostsSearch_579153 = ref object of OpenApiRestCall_578339
proc url_BloggerPostsSearch_579155(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerPostsSearch_579154(path: JsonNode; query: JsonNode;
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
  var valid_579156 = path.getOrDefault("blogId")
  valid_579156 = validateParameter(valid_579156, JString, required = true,
                                 default = nil)
  if valid_579156 != nil:
    section.add "blogId", valid_579156
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   q: JString (required)
  ##    : Query terms to search this blog for matching posts.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   orderBy: JString
  ##          : Sort search results
  ##   fetchBodies: JBool
  ##              : Whether the body content of posts is included (default: true). This should be set to false when the post bodies are not required, to help minimize traffic.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579157 = query.getOrDefault("key")
  valid_579157 = validateParameter(valid_579157, JString, required = false,
                                 default = nil)
  if valid_579157 != nil:
    section.add "key", valid_579157
  var valid_579158 = query.getOrDefault("prettyPrint")
  valid_579158 = validateParameter(valid_579158, JBool, required = false,
                                 default = newJBool(true))
  if valid_579158 != nil:
    section.add "prettyPrint", valid_579158
  var valid_579159 = query.getOrDefault("oauth_token")
  valid_579159 = validateParameter(valid_579159, JString, required = false,
                                 default = nil)
  if valid_579159 != nil:
    section.add "oauth_token", valid_579159
  assert query != nil, "query argument is necessary due to required `q` field"
  var valid_579160 = query.getOrDefault("q")
  valid_579160 = validateParameter(valid_579160, JString, required = true,
                                 default = nil)
  if valid_579160 != nil:
    section.add "q", valid_579160
  var valid_579161 = query.getOrDefault("alt")
  valid_579161 = validateParameter(valid_579161, JString, required = false,
                                 default = newJString("json"))
  if valid_579161 != nil:
    section.add "alt", valid_579161
  var valid_579162 = query.getOrDefault("userIp")
  valid_579162 = validateParameter(valid_579162, JString, required = false,
                                 default = nil)
  if valid_579162 != nil:
    section.add "userIp", valid_579162
  var valid_579163 = query.getOrDefault("quotaUser")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = nil)
  if valid_579163 != nil:
    section.add "quotaUser", valid_579163
  var valid_579164 = query.getOrDefault("orderBy")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = newJString("published"))
  if valid_579164 != nil:
    section.add "orderBy", valid_579164
  var valid_579165 = query.getOrDefault("fetchBodies")
  valid_579165 = validateParameter(valid_579165, JBool, required = false,
                                 default = newJBool(true))
  if valid_579165 != nil:
    section.add "fetchBodies", valid_579165
  var valid_579166 = query.getOrDefault("fields")
  valid_579166 = validateParameter(valid_579166, JString, required = false,
                                 default = nil)
  if valid_579166 != nil:
    section.add "fields", valid_579166
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579167: Call_BloggerPostsSearch_579153; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Search for a post.
  ## 
  let valid = call_579167.validator(path, query, header, formData, body)
  let scheme = call_579167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579167.url(scheme.get, call_579167.host, call_579167.base,
                         call_579167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579167, url, valid)

proc call*(call_579168: Call_BloggerPostsSearch_579153; q: string; blogId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          orderBy: string = "published"; fetchBodies: bool = true; fields: string = ""): Recallable =
  ## bloggerPostsSearch
  ## Search for a post.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   q: string (required)
  ##    : Query terms to search this blog for matching posts.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   orderBy: string
  ##          : Sort search results
  ##   blogId: string (required)
  ##         : ID of the blog to fetch the post from.
  ##   fetchBodies: bool
  ##              : Whether the body content of posts is included (default: true). This should be set to false when the post bodies are not required, to help minimize traffic.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579169 = newJObject()
  var query_579170 = newJObject()
  add(query_579170, "key", newJString(key))
  add(query_579170, "prettyPrint", newJBool(prettyPrint))
  add(query_579170, "oauth_token", newJString(oauthToken))
  add(query_579170, "q", newJString(q))
  add(query_579170, "alt", newJString(alt))
  add(query_579170, "userIp", newJString(userIp))
  add(query_579170, "quotaUser", newJString(quotaUser))
  add(query_579170, "orderBy", newJString(orderBy))
  add(path_579169, "blogId", newJString(blogId))
  add(query_579170, "fetchBodies", newJBool(fetchBodies))
  add(query_579170, "fields", newJString(fields))
  result = call_579168.call(path_579169, query_579170, nil, nil, nil)

var bloggerPostsSearch* = Call_BloggerPostsSearch_579153(
    name: "bloggerPostsSearch", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/blogs/{blogId}/posts/search",
    validator: validate_BloggerPostsSearch_579154, base: "/blogger/v3",
    url: url_BloggerPostsSearch_579155, schemes: {Scheme.Https})
type
  Call_BloggerPostsUpdate_579191 = ref object of OpenApiRestCall_578339
proc url_BloggerPostsUpdate_579193(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerPostsUpdate_579192(path: JsonNode; query: JsonNode;
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
  var valid_579194 = path.getOrDefault("postId")
  valid_579194 = validateParameter(valid_579194, JString, required = true,
                                 default = nil)
  if valid_579194 != nil:
    section.add "postId", valid_579194
  var valid_579195 = path.getOrDefault("blogId")
  valid_579195 = validateParameter(valid_579195, JString, required = true,
                                 default = nil)
  if valid_579195 != nil:
    section.add "blogId", valid_579195
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   fetchBody: JBool
  ##            : Whether the body content of the post is included with the result (default: true).
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   publish: JBool
  ##          : Whether a publish action should be performed when the post is updated (default: false).
  ##   fetchImages: JBool
  ##              : Whether image URL metadata for each post is included in the returned result (default: false).
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxComments: JInt
  ##              : Maximum number of comments to retrieve with the returned post.
  ##   revert: JBool
  ##         : Whether a revert action should be performed when the post is updated (default: false).
  section = newJObject()
  var valid_579196 = query.getOrDefault("key")
  valid_579196 = validateParameter(valid_579196, JString, required = false,
                                 default = nil)
  if valid_579196 != nil:
    section.add "key", valid_579196
  var valid_579197 = query.getOrDefault("prettyPrint")
  valid_579197 = validateParameter(valid_579197, JBool, required = false,
                                 default = newJBool(true))
  if valid_579197 != nil:
    section.add "prettyPrint", valid_579197
  var valid_579198 = query.getOrDefault("oauth_token")
  valid_579198 = validateParameter(valid_579198, JString, required = false,
                                 default = nil)
  if valid_579198 != nil:
    section.add "oauth_token", valid_579198
  var valid_579199 = query.getOrDefault("fetchBody")
  valid_579199 = validateParameter(valid_579199, JBool, required = false,
                                 default = newJBool(true))
  if valid_579199 != nil:
    section.add "fetchBody", valid_579199
  var valid_579200 = query.getOrDefault("alt")
  valid_579200 = validateParameter(valid_579200, JString, required = false,
                                 default = newJString("json"))
  if valid_579200 != nil:
    section.add "alt", valid_579200
  var valid_579201 = query.getOrDefault("userIp")
  valid_579201 = validateParameter(valid_579201, JString, required = false,
                                 default = nil)
  if valid_579201 != nil:
    section.add "userIp", valid_579201
  var valid_579202 = query.getOrDefault("quotaUser")
  valid_579202 = validateParameter(valid_579202, JString, required = false,
                                 default = nil)
  if valid_579202 != nil:
    section.add "quotaUser", valid_579202
  var valid_579203 = query.getOrDefault("publish")
  valid_579203 = validateParameter(valid_579203, JBool, required = false, default = nil)
  if valid_579203 != nil:
    section.add "publish", valid_579203
  var valid_579204 = query.getOrDefault("fetchImages")
  valid_579204 = validateParameter(valid_579204, JBool, required = false, default = nil)
  if valid_579204 != nil:
    section.add "fetchImages", valid_579204
  var valid_579205 = query.getOrDefault("fields")
  valid_579205 = validateParameter(valid_579205, JString, required = false,
                                 default = nil)
  if valid_579205 != nil:
    section.add "fields", valid_579205
  var valid_579206 = query.getOrDefault("maxComments")
  valid_579206 = validateParameter(valid_579206, JInt, required = false, default = nil)
  if valid_579206 != nil:
    section.add "maxComments", valid_579206
  var valid_579207 = query.getOrDefault("revert")
  valid_579207 = validateParameter(valid_579207, JBool, required = false, default = nil)
  if valid_579207 != nil:
    section.add "revert", valid_579207
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

proc call*(call_579209: Call_BloggerPostsUpdate_579191; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a post.
  ## 
  let valid = call_579209.validator(path, query, header, formData, body)
  let scheme = call_579209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579209.url(scheme.get, call_579209.host, call_579209.base,
                         call_579209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579209, url, valid)

proc call*(call_579210: Call_BloggerPostsUpdate_579191; postId: string;
          blogId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; fetchBody: bool = true; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; publish: bool = false;
          fetchImages: bool = false; body: JsonNode = nil; fields: string = "";
          maxComments: int = 0; revert: bool = false): Recallable =
  ## bloggerPostsUpdate
  ## Update a post.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   postId: string (required)
  ##         : The ID of the Post.
  ##   fetchBody: bool
  ##            : Whether the body content of the post is included with the result (default: true).
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   publish: bool
  ##          : Whether a publish action should be performed when the post is updated (default: false).
  ##   blogId: string (required)
  ##         : The ID of the Blog.
  ##   fetchImages: bool
  ##              : Whether image URL metadata for each post is included in the returned result (default: false).
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxComments: int
  ##              : Maximum number of comments to retrieve with the returned post.
  ##   revert: bool
  ##         : Whether a revert action should be performed when the post is updated (default: false).
  var path_579211 = newJObject()
  var query_579212 = newJObject()
  var body_579213 = newJObject()
  add(query_579212, "key", newJString(key))
  add(query_579212, "prettyPrint", newJBool(prettyPrint))
  add(query_579212, "oauth_token", newJString(oauthToken))
  add(path_579211, "postId", newJString(postId))
  add(query_579212, "fetchBody", newJBool(fetchBody))
  add(query_579212, "alt", newJString(alt))
  add(query_579212, "userIp", newJString(userIp))
  add(query_579212, "quotaUser", newJString(quotaUser))
  add(query_579212, "publish", newJBool(publish))
  add(path_579211, "blogId", newJString(blogId))
  add(query_579212, "fetchImages", newJBool(fetchImages))
  if body != nil:
    body_579213 = body
  add(query_579212, "fields", newJString(fields))
  add(query_579212, "maxComments", newJInt(maxComments))
  add(query_579212, "revert", newJBool(revert))
  result = call_579210.call(path_579211, query_579212, nil, nil, body_579213)

var bloggerPostsUpdate* = Call_BloggerPostsUpdate_579191(
    name: "bloggerPostsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/blogs/{blogId}/posts/{postId}",
    validator: validate_BloggerPostsUpdate_579192, base: "/blogger/v3",
    url: url_BloggerPostsUpdate_579193, schemes: {Scheme.Https})
type
  Call_BloggerPostsGet_579171 = ref object of OpenApiRestCall_578339
proc url_BloggerPostsGet_579173(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerPostsGet_579172(path: JsonNode; query: JsonNode;
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
  var valid_579174 = path.getOrDefault("postId")
  valid_579174 = validateParameter(valid_579174, JString, required = true,
                                 default = nil)
  if valid_579174 != nil:
    section.add "postId", valid_579174
  var valid_579175 = path.getOrDefault("blogId")
  valid_579175 = validateParameter(valid_579175, JString, required = true,
                                 default = nil)
  if valid_579175 != nil:
    section.add "blogId", valid_579175
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   fetchBody: JBool
  ##            : Whether the body content of the post is included (default: true). This should be set to false when the post bodies are not required, to help minimize traffic.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fetchImages: JBool
  ##              : Whether image URL metadata for each post is included (default: false).
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxComments: JInt
  ##              : Maximum number of comments to pull back on a post.
  ##   view: JString
  ##       : Access level with which to view the returned result. Note that some fields require elevated access.
  section = newJObject()
  var valid_579176 = query.getOrDefault("key")
  valid_579176 = validateParameter(valid_579176, JString, required = false,
                                 default = nil)
  if valid_579176 != nil:
    section.add "key", valid_579176
  var valid_579177 = query.getOrDefault("prettyPrint")
  valid_579177 = validateParameter(valid_579177, JBool, required = false,
                                 default = newJBool(true))
  if valid_579177 != nil:
    section.add "prettyPrint", valid_579177
  var valid_579178 = query.getOrDefault("oauth_token")
  valid_579178 = validateParameter(valid_579178, JString, required = false,
                                 default = nil)
  if valid_579178 != nil:
    section.add "oauth_token", valid_579178
  var valid_579179 = query.getOrDefault("fetchBody")
  valid_579179 = validateParameter(valid_579179, JBool, required = false,
                                 default = newJBool(true))
  if valid_579179 != nil:
    section.add "fetchBody", valid_579179
  var valid_579180 = query.getOrDefault("alt")
  valid_579180 = validateParameter(valid_579180, JString, required = false,
                                 default = newJString("json"))
  if valid_579180 != nil:
    section.add "alt", valid_579180
  var valid_579181 = query.getOrDefault("userIp")
  valid_579181 = validateParameter(valid_579181, JString, required = false,
                                 default = nil)
  if valid_579181 != nil:
    section.add "userIp", valid_579181
  var valid_579182 = query.getOrDefault("quotaUser")
  valid_579182 = validateParameter(valid_579182, JString, required = false,
                                 default = nil)
  if valid_579182 != nil:
    section.add "quotaUser", valid_579182
  var valid_579183 = query.getOrDefault("fetchImages")
  valid_579183 = validateParameter(valid_579183, JBool, required = false, default = nil)
  if valid_579183 != nil:
    section.add "fetchImages", valid_579183
  var valid_579184 = query.getOrDefault("fields")
  valid_579184 = validateParameter(valid_579184, JString, required = false,
                                 default = nil)
  if valid_579184 != nil:
    section.add "fields", valid_579184
  var valid_579185 = query.getOrDefault("maxComments")
  valid_579185 = validateParameter(valid_579185, JInt, required = false, default = nil)
  if valid_579185 != nil:
    section.add "maxComments", valid_579185
  var valid_579186 = query.getOrDefault("view")
  valid_579186 = validateParameter(valid_579186, JString, required = false,
                                 default = newJString("ADMIN"))
  if valid_579186 != nil:
    section.add "view", valid_579186
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579187: Call_BloggerPostsGet_579171; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a post by ID.
  ## 
  let valid = call_579187.validator(path, query, header, formData, body)
  let scheme = call_579187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579187.url(scheme.get, call_579187.host, call_579187.base,
                         call_579187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579187, url, valid)

proc call*(call_579188: Call_BloggerPostsGet_579171; postId: string; blogId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          fetchBody: bool = true; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fetchImages: bool = false; fields: string = "";
          maxComments: int = 0; view: string = "ADMIN"): Recallable =
  ## bloggerPostsGet
  ## Get a post by ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   postId: string (required)
  ##         : The ID of the post
  ##   fetchBody: bool
  ##            : Whether the body content of the post is included (default: true). This should be set to false when the post bodies are not required, to help minimize traffic.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   blogId: string (required)
  ##         : ID of the blog to fetch the post from.
  ##   fetchImages: bool
  ##              : Whether image URL metadata for each post is included (default: false).
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxComments: int
  ##              : Maximum number of comments to pull back on a post.
  ##   view: string
  ##       : Access level with which to view the returned result. Note that some fields require elevated access.
  var path_579189 = newJObject()
  var query_579190 = newJObject()
  add(query_579190, "key", newJString(key))
  add(query_579190, "prettyPrint", newJBool(prettyPrint))
  add(query_579190, "oauth_token", newJString(oauthToken))
  add(path_579189, "postId", newJString(postId))
  add(query_579190, "fetchBody", newJBool(fetchBody))
  add(query_579190, "alt", newJString(alt))
  add(query_579190, "userIp", newJString(userIp))
  add(query_579190, "quotaUser", newJString(quotaUser))
  add(path_579189, "blogId", newJString(blogId))
  add(query_579190, "fetchImages", newJBool(fetchImages))
  add(query_579190, "fields", newJString(fields))
  add(query_579190, "maxComments", newJInt(maxComments))
  add(query_579190, "view", newJString(view))
  result = call_579188.call(path_579189, query_579190, nil, nil, nil)

var bloggerPostsGet* = Call_BloggerPostsGet_579171(name: "bloggerPostsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/blogs/{blogId}/posts/{postId}", validator: validate_BloggerPostsGet_579172,
    base: "/blogger/v3", url: url_BloggerPostsGet_579173, schemes: {Scheme.Https})
type
  Call_BloggerPostsPatch_579230 = ref object of OpenApiRestCall_578339
proc url_BloggerPostsPatch_579232(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerPostsPatch_579231(path: JsonNode; query: JsonNode;
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
  var valid_579233 = path.getOrDefault("postId")
  valid_579233 = validateParameter(valid_579233, JString, required = true,
                                 default = nil)
  if valid_579233 != nil:
    section.add "postId", valid_579233
  var valid_579234 = path.getOrDefault("blogId")
  valid_579234 = validateParameter(valid_579234, JString, required = true,
                                 default = nil)
  if valid_579234 != nil:
    section.add "blogId", valid_579234
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   fetchBody: JBool
  ##            : Whether the body content of the post is included with the result (default: true).
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   publish: JBool
  ##          : Whether a publish action should be performed when the post is updated (default: false).
  ##   fetchImages: JBool
  ##              : Whether image URL metadata for each post is included in the returned result (default: false).
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxComments: JInt
  ##              : Maximum number of comments to retrieve with the returned post.
  ##   revert: JBool
  ##         : Whether a revert action should be performed when the post is updated (default: false).
  section = newJObject()
  var valid_579235 = query.getOrDefault("key")
  valid_579235 = validateParameter(valid_579235, JString, required = false,
                                 default = nil)
  if valid_579235 != nil:
    section.add "key", valid_579235
  var valid_579236 = query.getOrDefault("prettyPrint")
  valid_579236 = validateParameter(valid_579236, JBool, required = false,
                                 default = newJBool(true))
  if valid_579236 != nil:
    section.add "prettyPrint", valid_579236
  var valid_579237 = query.getOrDefault("oauth_token")
  valid_579237 = validateParameter(valid_579237, JString, required = false,
                                 default = nil)
  if valid_579237 != nil:
    section.add "oauth_token", valid_579237
  var valid_579238 = query.getOrDefault("fetchBody")
  valid_579238 = validateParameter(valid_579238, JBool, required = false,
                                 default = newJBool(true))
  if valid_579238 != nil:
    section.add "fetchBody", valid_579238
  var valid_579239 = query.getOrDefault("alt")
  valid_579239 = validateParameter(valid_579239, JString, required = false,
                                 default = newJString("json"))
  if valid_579239 != nil:
    section.add "alt", valid_579239
  var valid_579240 = query.getOrDefault("userIp")
  valid_579240 = validateParameter(valid_579240, JString, required = false,
                                 default = nil)
  if valid_579240 != nil:
    section.add "userIp", valid_579240
  var valid_579241 = query.getOrDefault("quotaUser")
  valid_579241 = validateParameter(valid_579241, JString, required = false,
                                 default = nil)
  if valid_579241 != nil:
    section.add "quotaUser", valid_579241
  var valid_579242 = query.getOrDefault("publish")
  valid_579242 = validateParameter(valid_579242, JBool, required = false, default = nil)
  if valid_579242 != nil:
    section.add "publish", valid_579242
  var valid_579243 = query.getOrDefault("fetchImages")
  valid_579243 = validateParameter(valid_579243, JBool, required = false, default = nil)
  if valid_579243 != nil:
    section.add "fetchImages", valid_579243
  var valid_579244 = query.getOrDefault("fields")
  valid_579244 = validateParameter(valid_579244, JString, required = false,
                                 default = nil)
  if valid_579244 != nil:
    section.add "fields", valid_579244
  var valid_579245 = query.getOrDefault("maxComments")
  valid_579245 = validateParameter(valid_579245, JInt, required = false, default = nil)
  if valid_579245 != nil:
    section.add "maxComments", valid_579245
  var valid_579246 = query.getOrDefault("revert")
  valid_579246 = validateParameter(valid_579246, JBool, required = false, default = nil)
  if valid_579246 != nil:
    section.add "revert", valid_579246
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

proc call*(call_579248: Call_BloggerPostsPatch_579230; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a post. This method supports patch semantics.
  ## 
  let valid = call_579248.validator(path, query, header, formData, body)
  let scheme = call_579248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579248.url(scheme.get, call_579248.host, call_579248.base,
                         call_579248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579248, url, valid)

proc call*(call_579249: Call_BloggerPostsPatch_579230; postId: string;
          blogId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; fetchBody: bool = true; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; publish: bool = false;
          fetchImages: bool = false; body: JsonNode = nil; fields: string = "";
          maxComments: int = 0; revert: bool = false): Recallable =
  ## bloggerPostsPatch
  ## Update a post. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   postId: string (required)
  ##         : The ID of the Post.
  ##   fetchBody: bool
  ##            : Whether the body content of the post is included with the result (default: true).
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   publish: bool
  ##          : Whether a publish action should be performed when the post is updated (default: false).
  ##   blogId: string (required)
  ##         : The ID of the Blog.
  ##   fetchImages: bool
  ##              : Whether image URL metadata for each post is included in the returned result (default: false).
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxComments: int
  ##              : Maximum number of comments to retrieve with the returned post.
  ##   revert: bool
  ##         : Whether a revert action should be performed when the post is updated (default: false).
  var path_579250 = newJObject()
  var query_579251 = newJObject()
  var body_579252 = newJObject()
  add(query_579251, "key", newJString(key))
  add(query_579251, "prettyPrint", newJBool(prettyPrint))
  add(query_579251, "oauth_token", newJString(oauthToken))
  add(path_579250, "postId", newJString(postId))
  add(query_579251, "fetchBody", newJBool(fetchBody))
  add(query_579251, "alt", newJString(alt))
  add(query_579251, "userIp", newJString(userIp))
  add(query_579251, "quotaUser", newJString(quotaUser))
  add(query_579251, "publish", newJBool(publish))
  add(path_579250, "blogId", newJString(blogId))
  add(query_579251, "fetchImages", newJBool(fetchImages))
  if body != nil:
    body_579252 = body
  add(query_579251, "fields", newJString(fields))
  add(query_579251, "maxComments", newJInt(maxComments))
  add(query_579251, "revert", newJBool(revert))
  result = call_579249.call(path_579250, query_579251, nil, nil, body_579252)

var bloggerPostsPatch* = Call_BloggerPostsPatch_579230(name: "bloggerPostsPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/blogs/{blogId}/posts/{postId}",
    validator: validate_BloggerPostsPatch_579231, base: "/blogger/v3",
    url: url_BloggerPostsPatch_579232, schemes: {Scheme.Https})
type
  Call_BloggerPostsDelete_579214 = ref object of OpenApiRestCall_578339
proc url_BloggerPostsDelete_579216(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerPostsDelete_579215(path: JsonNode; query: JsonNode;
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
  var valid_579217 = path.getOrDefault("postId")
  valid_579217 = validateParameter(valid_579217, JString, required = true,
                                 default = nil)
  if valid_579217 != nil:
    section.add "postId", valid_579217
  var valid_579218 = path.getOrDefault("blogId")
  valid_579218 = validateParameter(valid_579218, JString, required = true,
                                 default = nil)
  if valid_579218 != nil:
    section.add "blogId", valid_579218
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
  var valid_579219 = query.getOrDefault("key")
  valid_579219 = validateParameter(valid_579219, JString, required = false,
                                 default = nil)
  if valid_579219 != nil:
    section.add "key", valid_579219
  var valid_579220 = query.getOrDefault("prettyPrint")
  valid_579220 = validateParameter(valid_579220, JBool, required = false,
                                 default = newJBool(true))
  if valid_579220 != nil:
    section.add "prettyPrint", valid_579220
  var valid_579221 = query.getOrDefault("oauth_token")
  valid_579221 = validateParameter(valid_579221, JString, required = false,
                                 default = nil)
  if valid_579221 != nil:
    section.add "oauth_token", valid_579221
  var valid_579222 = query.getOrDefault("alt")
  valid_579222 = validateParameter(valid_579222, JString, required = false,
                                 default = newJString("json"))
  if valid_579222 != nil:
    section.add "alt", valid_579222
  var valid_579223 = query.getOrDefault("userIp")
  valid_579223 = validateParameter(valid_579223, JString, required = false,
                                 default = nil)
  if valid_579223 != nil:
    section.add "userIp", valid_579223
  var valid_579224 = query.getOrDefault("quotaUser")
  valid_579224 = validateParameter(valid_579224, JString, required = false,
                                 default = nil)
  if valid_579224 != nil:
    section.add "quotaUser", valid_579224
  var valid_579225 = query.getOrDefault("fields")
  valid_579225 = validateParameter(valid_579225, JString, required = false,
                                 default = nil)
  if valid_579225 != nil:
    section.add "fields", valid_579225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579226: Call_BloggerPostsDelete_579214; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a post by ID.
  ## 
  let valid = call_579226.validator(path, query, header, formData, body)
  let scheme = call_579226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579226.url(scheme.get, call_579226.host, call_579226.base,
                         call_579226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579226, url, valid)

proc call*(call_579227: Call_BloggerPostsDelete_579214; postId: string;
          blogId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## bloggerPostsDelete
  ## Delete a post by ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   postId: string (required)
  ##         : The ID of the Post.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   blogId: string (required)
  ##         : The ID of the Blog.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579228 = newJObject()
  var query_579229 = newJObject()
  add(query_579229, "key", newJString(key))
  add(query_579229, "prettyPrint", newJBool(prettyPrint))
  add(query_579229, "oauth_token", newJString(oauthToken))
  add(path_579228, "postId", newJString(postId))
  add(query_579229, "alt", newJString(alt))
  add(query_579229, "userIp", newJString(userIp))
  add(query_579229, "quotaUser", newJString(quotaUser))
  add(path_579228, "blogId", newJString(blogId))
  add(query_579229, "fields", newJString(fields))
  result = call_579227.call(path_579228, query_579229, nil, nil, nil)

var bloggerPostsDelete* = Call_BloggerPostsDelete_579214(
    name: "bloggerPostsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/blogs/{blogId}/posts/{postId}",
    validator: validate_BloggerPostsDelete_579215, base: "/blogger/v3",
    url: url_BloggerPostsDelete_579216, schemes: {Scheme.Https})
type
  Call_BloggerCommentsList_579253 = ref object of OpenApiRestCall_578339
proc url_BloggerCommentsList_579255(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerCommentsList_579254(path: JsonNode; query: JsonNode;
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
  var valid_579256 = path.getOrDefault("postId")
  valid_579256 = validateParameter(valid_579256, JString, required = true,
                                 default = nil)
  if valid_579256 != nil:
    section.add "postId", valid_579256
  var valid_579257 = path.getOrDefault("blogId")
  valid_579257 = validateParameter(valid_579257, JString, required = true,
                                 default = nil)
  if valid_579257 != nil:
    section.add "blogId", valid_579257
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
  ##   endDate: JString
  ##          : Latest date of comment to fetch, a date-time with RFC 3339 formatting.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : Continuation token if request is paged.
  ##   status: JArray
  ##   fetchBodies: JBool
  ##              : Whether the body content of the comments is included.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   startDate: JString
  ##            : Earliest date of comment to fetch, a date-time with RFC 3339 formatting.
  ##   view: JString
  ##       : Access level with which to view the returned result. Note that some fields require elevated access.
  ##   maxResults: JInt
  ##             : Maximum number of comments to include in the result.
  section = newJObject()
  var valid_579258 = query.getOrDefault("key")
  valid_579258 = validateParameter(valid_579258, JString, required = false,
                                 default = nil)
  if valid_579258 != nil:
    section.add "key", valid_579258
  var valid_579259 = query.getOrDefault("prettyPrint")
  valid_579259 = validateParameter(valid_579259, JBool, required = false,
                                 default = newJBool(true))
  if valid_579259 != nil:
    section.add "prettyPrint", valid_579259
  var valid_579260 = query.getOrDefault("oauth_token")
  valid_579260 = validateParameter(valid_579260, JString, required = false,
                                 default = nil)
  if valid_579260 != nil:
    section.add "oauth_token", valid_579260
  var valid_579261 = query.getOrDefault("alt")
  valid_579261 = validateParameter(valid_579261, JString, required = false,
                                 default = newJString("json"))
  if valid_579261 != nil:
    section.add "alt", valid_579261
  var valid_579262 = query.getOrDefault("userIp")
  valid_579262 = validateParameter(valid_579262, JString, required = false,
                                 default = nil)
  if valid_579262 != nil:
    section.add "userIp", valid_579262
  var valid_579263 = query.getOrDefault("endDate")
  valid_579263 = validateParameter(valid_579263, JString, required = false,
                                 default = nil)
  if valid_579263 != nil:
    section.add "endDate", valid_579263
  var valid_579264 = query.getOrDefault("quotaUser")
  valid_579264 = validateParameter(valid_579264, JString, required = false,
                                 default = nil)
  if valid_579264 != nil:
    section.add "quotaUser", valid_579264
  var valid_579265 = query.getOrDefault("pageToken")
  valid_579265 = validateParameter(valid_579265, JString, required = false,
                                 default = nil)
  if valid_579265 != nil:
    section.add "pageToken", valid_579265
  var valid_579266 = query.getOrDefault("status")
  valid_579266 = validateParameter(valid_579266, JArray, required = false,
                                 default = nil)
  if valid_579266 != nil:
    section.add "status", valid_579266
  var valid_579267 = query.getOrDefault("fetchBodies")
  valid_579267 = validateParameter(valid_579267, JBool, required = false, default = nil)
  if valid_579267 != nil:
    section.add "fetchBodies", valid_579267
  var valid_579268 = query.getOrDefault("fields")
  valid_579268 = validateParameter(valid_579268, JString, required = false,
                                 default = nil)
  if valid_579268 != nil:
    section.add "fields", valid_579268
  var valid_579269 = query.getOrDefault("startDate")
  valid_579269 = validateParameter(valid_579269, JString, required = false,
                                 default = nil)
  if valid_579269 != nil:
    section.add "startDate", valid_579269
  var valid_579270 = query.getOrDefault("view")
  valid_579270 = validateParameter(valid_579270, JString, required = false,
                                 default = newJString("ADMIN"))
  if valid_579270 != nil:
    section.add "view", valid_579270
  var valid_579271 = query.getOrDefault("maxResults")
  valid_579271 = validateParameter(valid_579271, JInt, required = false, default = nil)
  if valid_579271 != nil:
    section.add "maxResults", valid_579271
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579272: Call_BloggerCommentsList_579253; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the comments for a post, possibly filtered.
  ## 
  let valid = call_579272.validator(path, query, header, formData, body)
  let scheme = call_579272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579272.url(scheme.get, call_579272.host, call_579272.base,
                         call_579272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579272, url, valid)

proc call*(call_579273: Call_BloggerCommentsList_579253; postId: string;
          blogId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          endDate: string = ""; quotaUser: string = ""; pageToken: string = "";
          status: JsonNode = nil; fetchBodies: bool = false; fields: string = "";
          startDate: string = ""; view: string = "ADMIN"; maxResults: int = 0): Recallable =
  ## bloggerCommentsList
  ## Retrieves the comments for a post, possibly filtered.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   postId: string (required)
  ##         : ID of the post to fetch posts from.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   endDate: string
  ##          : Latest date of comment to fetch, a date-time with RFC 3339 formatting.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : Continuation token if request is paged.
  ##   blogId: string (required)
  ##         : ID of the blog to fetch comments from.
  ##   status: JArray
  ##   fetchBodies: bool
  ##              : Whether the body content of the comments is included.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   startDate: string
  ##            : Earliest date of comment to fetch, a date-time with RFC 3339 formatting.
  ##   view: string
  ##       : Access level with which to view the returned result. Note that some fields require elevated access.
  ##   maxResults: int
  ##             : Maximum number of comments to include in the result.
  var path_579274 = newJObject()
  var query_579275 = newJObject()
  add(query_579275, "key", newJString(key))
  add(query_579275, "prettyPrint", newJBool(prettyPrint))
  add(query_579275, "oauth_token", newJString(oauthToken))
  add(path_579274, "postId", newJString(postId))
  add(query_579275, "alt", newJString(alt))
  add(query_579275, "userIp", newJString(userIp))
  add(query_579275, "endDate", newJString(endDate))
  add(query_579275, "quotaUser", newJString(quotaUser))
  add(query_579275, "pageToken", newJString(pageToken))
  add(path_579274, "blogId", newJString(blogId))
  if status != nil:
    query_579275.add "status", status
  add(query_579275, "fetchBodies", newJBool(fetchBodies))
  add(query_579275, "fields", newJString(fields))
  add(query_579275, "startDate", newJString(startDate))
  add(query_579275, "view", newJString(view))
  add(query_579275, "maxResults", newJInt(maxResults))
  result = call_579273.call(path_579274, query_579275, nil, nil, nil)

var bloggerCommentsList* = Call_BloggerCommentsList_579253(
    name: "bloggerCommentsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/blogs/{blogId}/posts/{postId}/comments",
    validator: validate_BloggerCommentsList_579254, base: "/blogger/v3",
    url: url_BloggerCommentsList_579255, schemes: {Scheme.Https})
type
  Call_BloggerCommentsGet_579276 = ref object of OpenApiRestCall_578339
proc url_BloggerCommentsGet_579278(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerCommentsGet_579277(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets one comment by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   postId: JString (required)
  ##         : ID of the post to fetch posts from.
  ##   commentId: JString (required)
  ##            : The ID of the comment to get.
  ##   blogId: JString (required)
  ##         : ID of the blog to containing the comment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `postId` field"
  var valid_579279 = path.getOrDefault("postId")
  valid_579279 = validateParameter(valid_579279, JString, required = true,
                                 default = nil)
  if valid_579279 != nil:
    section.add "postId", valid_579279
  var valid_579280 = path.getOrDefault("commentId")
  valid_579280 = validateParameter(valid_579280, JString, required = true,
                                 default = nil)
  if valid_579280 != nil:
    section.add "commentId", valid_579280
  var valid_579281 = path.getOrDefault("blogId")
  valid_579281 = validateParameter(valid_579281, JString, required = true,
                                 default = nil)
  if valid_579281 != nil:
    section.add "blogId", valid_579281
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
  ##   view: JString
  ##       : Access level for the requested comment (default: READER). Note that some comments will require elevated permissions, for example comments where the parent posts which is in a draft state, or comments that are pending moderation.
  section = newJObject()
  var valid_579282 = query.getOrDefault("key")
  valid_579282 = validateParameter(valid_579282, JString, required = false,
                                 default = nil)
  if valid_579282 != nil:
    section.add "key", valid_579282
  var valid_579283 = query.getOrDefault("prettyPrint")
  valid_579283 = validateParameter(valid_579283, JBool, required = false,
                                 default = newJBool(true))
  if valid_579283 != nil:
    section.add "prettyPrint", valid_579283
  var valid_579284 = query.getOrDefault("oauth_token")
  valid_579284 = validateParameter(valid_579284, JString, required = false,
                                 default = nil)
  if valid_579284 != nil:
    section.add "oauth_token", valid_579284
  var valid_579285 = query.getOrDefault("alt")
  valid_579285 = validateParameter(valid_579285, JString, required = false,
                                 default = newJString("json"))
  if valid_579285 != nil:
    section.add "alt", valid_579285
  var valid_579286 = query.getOrDefault("userIp")
  valid_579286 = validateParameter(valid_579286, JString, required = false,
                                 default = nil)
  if valid_579286 != nil:
    section.add "userIp", valid_579286
  var valid_579287 = query.getOrDefault("quotaUser")
  valid_579287 = validateParameter(valid_579287, JString, required = false,
                                 default = nil)
  if valid_579287 != nil:
    section.add "quotaUser", valid_579287
  var valid_579288 = query.getOrDefault("fields")
  valid_579288 = validateParameter(valid_579288, JString, required = false,
                                 default = nil)
  if valid_579288 != nil:
    section.add "fields", valid_579288
  var valid_579289 = query.getOrDefault("view")
  valid_579289 = validateParameter(valid_579289, JString, required = false,
                                 default = newJString("ADMIN"))
  if valid_579289 != nil:
    section.add "view", valid_579289
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579290: Call_BloggerCommentsGet_579276; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one comment by ID.
  ## 
  let valid = call_579290.validator(path, query, header, formData, body)
  let scheme = call_579290.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579290.url(scheme.get, call_579290.host, call_579290.base,
                         call_579290.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579290, url, valid)

proc call*(call_579291: Call_BloggerCommentsGet_579276; postId: string;
          commentId: string; blogId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""; view: string = "ADMIN"): Recallable =
  ## bloggerCommentsGet
  ## Gets one comment by ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   postId: string (required)
  ##         : ID of the post to fetch posts from.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   commentId: string (required)
  ##            : The ID of the comment to get.
  ##   blogId: string (required)
  ##         : ID of the blog to containing the comment.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: string
  ##       : Access level for the requested comment (default: READER). Note that some comments will require elevated permissions, for example comments where the parent posts which is in a draft state, or comments that are pending moderation.
  var path_579292 = newJObject()
  var query_579293 = newJObject()
  add(query_579293, "key", newJString(key))
  add(query_579293, "prettyPrint", newJBool(prettyPrint))
  add(query_579293, "oauth_token", newJString(oauthToken))
  add(path_579292, "postId", newJString(postId))
  add(query_579293, "alt", newJString(alt))
  add(query_579293, "userIp", newJString(userIp))
  add(query_579293, "quotaUser", newJString(quotaUser))
  add(path_579292, "commentId", newJString(commentId))
  add(path_579292, "blogId", newJString(blogId))
  add(query_579293, "fields", newJString(fields))
  add(query_579293, "view", newJString(view))
  result = call_579291.call(path_579292, query_579293, nil, nil, nil)

var bloggerCommentsGet* = Call_BloggerCommentsGet_579276(
    name: "bloggerCommentsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/blogs/{blogId}/posts/{postId}/comments/{commentId}",
    validator: validate_BloggerCommentsGet_579277, base: "/blogger/v3",
    url: url_BloggerCommentsGet_579278, schemes: {Scheme.Https})
type
  Call_BloggerCommentsDelete_579294 = ref object of OpenApiRestCall_578339
proc url_BloggerCommentsDelete_579296(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerCommentsDelete_579295(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a comment by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   postId: JString (required)
  ##         : The ID of the Post.
  ##   commentId: JString (required)
  ##            : The ID of the comment to delete.
  ##   blogId: JString (required)
  ##         : The ID of the Blog.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `postId` field"
  var valid_579297 = path.getOrDefault("postId")
  valid_579297 = validateParameter(valid_579297, JString, required = true,
                                 default = nil)
  if valid_579297 != nil:
    section.add "postId", valid_579297
  var valid_579298 = path.getOrDefault("commentId")
  valid_579298 = validateParameter(valid_579298, JString, required = true,
                                 default = nil)
  if valid_579298 != nil:
    section.add "commentId", valid_579298
  var valid_579299 = path.getOrDefault("blogId")
  valid_579299 = validateParameter(valid_579299, JString, required = true,
                                 default = nil)
  if valid_579299 != nil:
    section.add "blogId", valid_579299
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
  var valid_579300 = query.getOrDefault("key")
  valid_579300 = validateParameter(valid_579300, JString, required = false,
                                 default = nil)
  if valid_579300 != nil:
    section.add "key", valid_579300
  var valid_579301 = query.getOrDefault("prettyPrint")
  valid_579301 = validateParameter(valid_579301, JBool, required = false,
                                 default = newJBool(true))
  if valid_579301 != nil:
    section.add "prettyPrint", valid_579301
  var valid_579302 = query.getOrDefault("oauth_token")
  valid_579302 = validateParameter(valid_579302, JString, required = false,
                                 default = nil)
  if valid_579302 != nil:
    section.add "oauth_token", valid_579302
  var valid_579303 = query.getOrDefault("alt")
  valid_579303 = validateParameter(valid_579303, JString, required = false,
                                 default = newJString("json"))
  if valid_579303 != nil:
    section.add "alt", valid_579303
  var valid_579304 = query.getOrDefault("userIp")
  valid_579304 = validateParameter(valid_579304, JString, required = false,
                                 default = nil)
  if valid_579304 != nil:
    section.add "userIp", valid_579304
  var valid_579305 = query.getOrDefault("quotaUser")
  valid_579305 = validateParameter(valid_579305, JString, required = false,
                                 default = nil)
  if valid_579305 != nil:
    section.add "quotaUser", valid_579305
  var valid_579306 = query.getOrDefault("fields")
  valid_579306 = validateParameter(valid_579306, JString, required = false,
                                 default = nil)
  if valid_579306 != nil:
    section.add "fields", valid_579306
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579307: Call_BloggerCommentsDelete_579294; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a comment by ID.
  ## 
  let valid = call_579307.validator(path, query, header, formData, body)
  let scheme = call_579307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579307.url(scheme.get, call_579307.host, call_579307.base,
                         call_579307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579307, url, valid)

proc call*(call_579308: Call_BloggerCommentsDelete_579294; postId: string;
          commentId: string; blogId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## bloggerCommentsDelete
  ## Delete a comment by ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   postId: string (required)
  ##         : The ID of the Post.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   commentId: string (required)
  ##            : The ID of the comment to delete.
  ##   blogId: string (required)
  ##         : The ID of the Blog.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579309 = newJObject()
  var query_579310 = newJObject()
  add(query_579310, "key", newJString(key))
  add(query_579310, "prettyPrint", newJBool(prettyPrint))
  add(query_579310, "oauth_token", newJString(oauthToken))
  add(path_579309, "postId", newJString(postId))
  add(query_579310, "alt", newJString(alt))
  add(query_579310, "userIp", newJString(userIp))
  add(query_579310, "quotaUser", newJString(quotaUser))
  add(path_579309, "commentId", newJString(commentId))
  add(path_579309, "blogId", newJString(blogId))
  add(query_579310, "fields", newJString(fields))
  result = call_579308.call(path_579309, query_579310, nil, nil, nil)

var bloggerCommentsDelete* = Call_BloggerCommentsDelete_579294(
    name: "bloggerCommentsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/blogs/{blogId}/posts/{postId}/comments/{commentId}",
    validator: validate_BloggerCommentsDelete_579295, base: "/blogger/v3",
    url: url_BloggerCommentsDelete_579296, schemes: {Scheme.Https})
type
  Call_BloggerCommentsApprove_579311 = ref object of OpenApiRestCall_578339
proc url_BloggerCommentsApprove_579313(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerCommentsApprove_579312(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Marks a comment as not spam.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   postId: JString (required)
  ##         : The ID of the Post.
  ##   commentId: JString (required)
  ##            : The ID of the comment to mark as not spam.
  ##   blogId: JString (required)
  ##         : The ID of the Blog.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `postId` field"
  var valid_579314 = path.getOrDefault("postId")
  valid_579314 = validateParameter(valid_579314, JString, required = true,
                                 default = nil)
  if valid_579314 != nil:
    section.add "postId", valid_579314
  var valid_579315 = path.getOrDefault("commentId")
  valid_579315 = validateParameter(valid_579315, JString, required = true,
                                 default = nil)
  if valid_579315 != nil:
    section.add "commentId", valid_579315
  var valid_579316 = path.getOrDefault("blogId")
  valid_579316 = validateParameter(valid_579316, JString, required = true,
                                 default = nil)
  if valid_579316 != nil:
    section.add "blogId", valid_579316
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
  var valid_579317 = query.getOrDefault("key")
  valid_579317 = validateParameter(valid_579317, JString, required = false,
                                 default = nil)
  if valid_579317 != nil:
    section.add "key", valid_579317
  var valid_579318 = query.getOrDefault("prettyPrint")
  valid_579318 = validateParameter(valid_579318, JBool, required = false,
                                 default = newJBool(true))
  if valid_579318 != nil:
    section.add "prettyPrint", valid_579318
  var valid_579319 = query.getOrDefault("oauth_token")
  valid_579319 = validateParameter(valid_579319, JString, required = false,
                                 default = nil)
  if valid_579319 != nil:
    section.add "oauth_token", valid_579319
  var valid_579320 = query.getOrDefault("alt")
  valid_579320 = validateParameter(valid_579320, JString, required = false,
                                 default = newJString("json"))
  if valid_579320 != nil:
    section.add "alt", valid_579320
  var valid_579321 = query.getOrDefault("userIp")
  valid_579321 = validateParameter(valid_579321, JString, required = false,
                                 default = nil)
  if valid_579321 != nil:
    section.add "userIp", valid_579321
  var valid_579322 = query.getOrDefault("quotaUser")
  valid_579322 = validateParameter(valid_579322, JString, required = false,
                                 default = nil)
  if valid_579322 != nil:
    section.add "quotaUser", valid_579322
  var valid_579323 = query.getOrDefault("fields")
  valid_579323 = validateParameter(valid_579323, JString, required = false,
                                 default = nil)
  if valid_579323 != nil:
    section.add "fields", valid_579323
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579324: Call_BloggerCommentsApprove_579311; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Marks a comment as not spam.
  ## 
  let valid = call_579324.validator(path, query, header, formData, body)
  let scheme = call_579324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579324.url(scheme.get, call_579324.host, call_579324.base,
                         call_579324.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579324, url, valid)

proc call*(call_579325: Call_BloggerCommentsApprove_579311; postId: string;
          commentId: string; blogId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## bloggerCommentsApprove
  ## Marks a comment as not spam.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   postId: string (required)
  ##         : The ID of the Post.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   commentId: string (required)
  ##            : The ID of the comment to mark as not spam.
  ##   blogId: string (required)
  ##         : The ID of the Blog.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579326 = newJObject()
  var query_579327 = newJObject()
  add(query_579327, "key", newJString(key))
  add(query_579327, "prettyPrint", newJBool(prettyPrint))
  add(query_579327, "oauth_token", newJString(oauthToken))
  add(path_579326, "postId", newJString(postId))
  add(query_579327, "alt", newJString(alt))
  add(query_579327, "userIp", newJString(userIp))
  add(query_579327, "quotaUser", newJString(quotaUser))
  add(path_579326, "commentId", newJString(commentId))
  add(path_579326, "blogId", newJString(blogId))
  add(query_579327, "fields", newJString(fields))
  result = call_579325.call(path_579326, query_579327, nil, nil, nil)

var bloggerCommentsApprove* = Call_BloggerCommentsApprove_579311(
    name: "bloggerCommentsApprove", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/blogs/{blogId}/posts/{postId}/comments/{commentId}/approve",
    validator: validate_BloggerCommentsApprove_579312, base: "/blogger/v3",
    url: url_BloggerCommentsApprove_579313, schemes: {Scheme.Https})
type
  Call_BloggerCommentsRemoveContent_579328 = ref object of OpenApiRestCall_578339
proc url_BloggerCommentsRemoveContent_579330(protocol: Scheme; host: string;
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

proc validate_BloggerCommentsRemoveContent_579329(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes the content of a comment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   postId: JString (required)
  ##         : The ID of the Post.
  ##   commentId: JString (required)
  ##            : The ID of the comment to delete content from.
  ##   blogId: JString (required)
  ##         : The ID of the Blog.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `postId` field"
  var valid_579331 = path.getOrDefault("postId")
  valid_579331 = validateParameter(valid_579331, JString, required = true,
                                 default = nil)
  if valid_579331 != nil:
    section.add "postId", valid_579331
  var valid_579332 = path.getOrDefault("commentId")
  valid_579332 = validateParameter(valid_579332, JString, required = true,
                                 default = nil)
  if valid_579332 != nil:
    section.add "commentId", valid_579332
  var valid_579333 = path.getOrDefault("blogId")
  valid_579333 = validateParameter(valid_579333, JString, required = true,
                                 default = nil)
  if valid_579333 != nil:
    section.add "blogId", valid_579333
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
  var valid_579334 = query.getOrDefault("key")
  valid_579334 = validateParameter(valid_579334, JString, required = false,
                                 default = nil)
  if valid_579334 != nil:
    section.add "key", valid_579334
  var valid_579335 = query.getOrDefault("prettyPrint")
  valid_579335 = validateParameter(valid_579335, JBool, required = false,
                                 default = newJBool(true))
  if valid_579335 != nil:
    section.add "prettyPrint", valid_579335
  var valid_579336 = query.getOrDefault("oauth_token")
  valid_579336 = validateParameter(valid_579336, JString, required = false,
                                 default = nil)
  if valid_579336 != nil:
    section.add "oauth_token", valid_579336
  var valid_579337 = query.getOrDefault("alt")
  valid_579337 = validateParameter(valid_579337, JString, required = false,
                                 default = newJString("json"))
  if valid_579337 != nil:
    section.add "alt", valid_579337
  var valid_579338 = query.getOrDefault("userIp")
  valid_579338 = validateParameter(valid_579338, JString, required = false,
                                 default = nil)
  if valid_579338 != nil:
    section.add "userIp", valid_579338
  var valid_579339 = query.getOrDefault("quotaUser")
  valid_579339 = validateParameter(valid_579339, JString, required = false,
                                 default = nil)
  if valid_579339 != nil:
    section.add "quotaUser", valid_579339
  var valid_579340 = query.getOrDefault("fields")
  valid_579340 = validateParameter(valid_579340, JString, required = false,
                                 default = nil)
  if valid_579340 != nil:
    section.add "fields", valid_579340
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579341: Call_BloggerCommentsRemoveContent_579328; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes the content of a comment.
  ## 
  let valid = call_579341.validator(path, query, header, formData, body)
  let scheme = call_579341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579341.url(scheme.get, call_579341.host, call_579341.base,
                         call_579341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579341, url, valid)

proc call*(call_579342: Call_BloggerCommentsRemoveContent_579328; postId: string;
          commentId: string; blogId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## bloggerCommentsRemoveContent
  ## Removes the content of a comment.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   postId: string (required)
  ##         : The ID of the Post.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   commentId: string (required)
  ##            : The ID of the comment to delete content from.
  ##   blogId: string (required)
  ##         : The ID of the Blog.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579343 = newJObject()
  var query_579344 = newJObject()
  add(query_579344, "key", newJString(key))
  add(query_579344, "prettyPrint", newJBool(prettyPrint))
  add(query_579344, "oauth_token", newJString(oauthToken))
  add(path_579343, "postId", newJString(postId))
  add(query_579344, "alt", newJString(alt))
  add(query_579344, "userIp", newJString(userIp))
  add(query_579344, "quotaUser", newJString(quotaUser))
  add(path_579343, "commentId", newJString(commentId))
  add(path_579343, "blogId", newJString(blogId))
  add(query_579344, "fields", newJString(fields))
  result = call_579342.call(path_579343, query_579344, nil, nil, nil)

var bloggerCommentsRemoveContent* = Call_BloggerCommentsRemoveContent_579328(
    name: "bloggerCommentsRemoveContent", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/blogs/{blogId}/posts/{postId}/comments/{commentId}/removecontent",
    validator: validate_BloggerCommentsRemoveContent_579329, base: "/blogger/v3",
    url: url_BloggerCommentsRemoveContent_579330, schemes: {Scheme.Https})
type
  Call_BloggerCommentsMarkAsSpam_579345 = ref object of OpenApiRestCall_578339
proc url_BloggerCommentsMarkAsSpam_579347(protocol: Scheme; host: string;
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

proc validate_BloggerCommentsMarkAsSpam_579346(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Marks a comment as spam.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   postId: JString (required)
  ##         : The ID of the Post.
  ##   commentId: JString (required)
  ##            : The ID of the comment to mark as spam.
  ##   blogId: JString (required)
  ##         : The ID of the Blog.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `postId` field"
  var valid_579348 = path.getOrDefault("postId")
  valid_579348 = validateParameter(valid_579348, JString, required = true,
                                 default = nil)
  if valid_579348 != nil:
    section.add "postId", valid_579348
  var valid_579349 = path.getOrDefault("commentId")
  valid_579349 = validateParameter(valid_579349, JString, required = true,
                                 default = nil)
  if valid_579349 != nil:
    section.add "commentId", valid_579349
  var valid_579350 = path.getOrDefault("blogId")
  valid_579350 = validateParameter(valid_579350, JString, required = true,
                                 default = nil)
  if valid_579350 != nil:
    section.add "blogId", valid_579350
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
  var valid_579351 = query.getOrDefault("key")
  valid_579351 = validateParameter(valid_579351, JString, required = false,
                                 default = nil)
  if valid_579351 != nil:
    section.add "key", valid_579351
  var valid_579352 = query.getOrDefault("prettyPrint")
  valid_579352 = validateParameter(valid_579352, JBool, required = false,
                                 default = newJBool(true))
  if valid_579352 != nil:
    section.add "prettyPrint", valid_579352
  var valid_579353 = query.getOrDefault("oauth_token")
  valid_579353 = validateParameter(valid_579353, JString, required = false,
                                 default = nil)
  if valid_579353 != nil:
    section.add "oauth_token", valid_579353
  var valid_579354 = query.getOrDefault("alt")
  valid_579354 = validateParameter(valid_579354, JString, required = false,
                                 default = newJString("json"))
  if valid_579354 != nil:
    section.add "alt", valid_579354
  var valid_579355 = query.getOrDefault("userIp")
  valid_579355 = validateParameter(valid_579355, JString, required = false,
                                 default = nil)
  if valid_579355 != nil:
    section.add "userIp", valid_579355
  var valid_579356 = query.getOrDefault("quotaUser")
  valid_579356 = validateParameter(valid_579356, JString, required = false,
                                 default = nil)
  if valid_579356 != nil:
    section.add "quotaUser", valid_579356
  var valid_579357 = query.getOrDefault("fields")
  valid_579357 = validateParameter(valid_579357, JString, required = false,
                                 default = nil)
  if valid_579357 != nil:
    section.add "fields", valid_579357
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579358: Call_BloggerCommentsMarkAsSpam_579345; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Marks a comment as spam.
  ## 
  let valid = call_579358.validator(path, query, header, formData, body)
  let scheme = call_579358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579358.url(scheme.get, call_579358.host, call_579358.base,
                         call_579358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579358, url, valid)

proc call*(call_579359: Call_BloggerCommentsMarkAsSpam_579345; postId: string;
          commentId: string; blogId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## bloggerCommentsMarkAsSpam
  ## Marks a comment as spam.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   postId: string (required)
  ##         : The ID of the Post.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   commentId: string (required)
  ##            : The ID of the comment to mark as spam.
  ##   blogId: string (required)
  ##         : The ID of the Blog.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579360 = newJObject()
  var query_579361 = newJObject()
  add(query_579361, "key", newJString(key))
  add(query_579361, "prettyPrint", newJBool(prettyPrint))
  add(query_579361, "oauth_token", newJString(oauthToken))
  add(path_579360, "postId", newJString(postId))
  add(query_579361, "alt", newJString(alt))
  add(query_579361, "userIp", newJString(userIp))
  add(query_579361, "quotaUser", newJString(quotaUser))
  add(path_579360, "commentId", newJString(commentId))
  add(path_579360, "blogId", newJString(blogId))
  add(query_579361, "fields", newJString(fields))
  result = call_579359.call(path_579360, query_579361, nil, nil, nil)

var bloggerCommentsMarkAsSpam* = Call_BloggerCommentsMarkAsSpam_579345(
    name: "bloggerCommentsMarkAsSpam", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/blogs/{blogId}/posts/{postId}/comments/{commentId}/spam",
    validator: validate_BloggerCommentsMarkAsSpam_579346, base: "/blogger/v3",
    url: url_BloggerCommentsMarkAsSpam_579347, schemes: {Scheme.Https})
type
  Call_BloggerPostsPublish_579362 = ref object of OpenApiRestCall_578339
proc url_BloggerPostsPublish_579364(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerPostsPublish_579363(path: JsonNode; query: JsonNode;
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
  var valid_579365 = path.getOrDefault("postId")
  valid_579365 = validateParameter(valid_579365, JString, required = true,
                                 default = nil)
  if valid_579365 != nil:
    section.add "postId", valid_579365
  var valid_579366 = path.getOrDefault("blogId")
  valid_579366 = validateParameter(valid_579366, JString, required = true,
                                 default = nil)
  if valid_579366 != nil:
    section.add "blogId", valid_579366
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
  ##   publishDate: JString
  ##              : Optional date and time to schedule the publishing of the Blog. If no publishDate parameter is given, the post is either published at the a previously saved schedule date (if present), or the current time. If a future date is given, the post will be scheduled to be published.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579367 = query.getOrDefault("key")
  valid_579367 = validateParameter(valid_579367, JString, required = false,
                                 default = nil)
  if valid_579367 != nil:
    section.add "key", valid_579367
  var valid_579368 = query.getOrDefault("prettyPrint")
  valid_579368 = validateParameter(valid_579368, JBool, required = false,
                                 default = newJBool(true))
  if valid_579368 != nil:
    section.add "prettyPrint", valid_579368
  var valid_579369 = query.getOrDefault("oauth_token")
  valid_579369 = validateParameter(valid_579369, JString, required = false,
                                 default = nil)
  if valid_579369 != nil:
    section.add "oauth_token", valid_579369
  var valid_579370 = query.getOrDefault("alt")
  valid_579370 = validateParameter(valid_579370, JString, required = false,
                                 default = newJString("json"))
  if valid_579370 != nil:
    section.add "alt", valid_579370
  var valid_579371 = query.getOrDefault("userIp")
  valid_579371 = validateParameter(valid_579371, JString, required = false,
                                 default = nil)
  if valid_579371 != nil:
    section.add "userIp", valid_579371
  var valid_579372 = query.getOrDefault("quotaUser")
  valid_579372 = validateParameter(valid_579372, JString, required = false,
                                 default = nil)
  if valid_579372 != nil:
    section.add "quotaUser", valid_579372
  var valid_579373 = query.getOrDefault("publishDate")
  valid_579373 = validateParameter(valid_579373, JString, required = false,
                                 default = nil)
  if valid_579373 != nil:
    section.add "publishDate", valid_579373
  var valid_579374 = query.getOrDefault("fields")
  valid_579374 = validateParameter(valid_579374, JString, required = false,
                                 default = nil)
  if valid_579374 != nil:
    section.add "fields", valid_579374
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579375: Call_BloggerPostsPublish_579362; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Publishes a draft post, optionally at the specific time of the given publishDate parameter.
  ## 
  let valid = call_579375.validator(path, query, header, formData, body)
  let scheme = call_579375.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579375.url(scheme.get, call_579375.host, call_579375.base,
                         call_579375.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579375, url, valid)

proc call*(call_579376: Call_BloggerPostsPublish_579362; postId: string;
          blogId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; publishDate: string = ""; fields: string = ""): Recallable =
  ## bloggerPostsPublish
  ## Publishes a draft post, optionally at the specific time of the given publishDate parameter.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   postId: string (required)
  ##         : The ID of the Post.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   publishDate: string
  ##              : Optional date and time to schedule the publishing of the Blog. If no publishDate parameter is given, the post is either published at the a previously saved schedule date (if present), or the current time. If a future date is given, the post will be scheduled to be published.
  ##   blogId: string (required)
  ##         : The ID of the Blog.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579377 = newJObject()
  var query_579378 = newJObject()
  add(query_579378, "key", newJString(key))
  add(query_579378, "prettyPrint", newJBool(prettyPrint))
  add(query_579378, "oauth_token", newJString(oauthToken))
  add(path_579377, "postId", newJString(postId))
  add(query_579378, "alt", newJString(alt))
  add(query_579378, "userIp", newJString(userIp))
  add(query_579378, "quotaUser", newJString(quotaUser))
  add(query_579378, "publishDate", newJString(publishDate))
  add(path_579377, "blogId", newJString(blogId))
  add(query_579378, "fields", newJString(fields))
  result = call_579376.call(path_579377, query_579378, nil, nil, nil)

var bloggerPostsPublish* = Call_BloggerPostsPublish_579362(
    name: "bloggerPostsPublish", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/blogs/{blogId}/posts/{postId}/publish",
    validator: validate_BloggerPostsPublish_579363, base: "/blogger/v3",
    url: url_BloggerPostsPublish_579364, schemes: {Scheme.Https})
type
  Call_BloggerPostsRevert_579379 = ref object of OpenApiRestCall_578339
proc url_BloggerPostsRevert_579381(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerPostsRevert_579380(path: JsonNode; query: JsonNode;
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
  var valid_579382 = path.getOrDefault("postId")
  valid_579382 = validateParameter(valid_579382, JString, required = true,
                                 default = nil)
  if valid_579382 != nil:
    section.add "postId", valid_579382
  var valid_579383 = path.getOrDefault("blogId")
  valid_579383 = validateParameter(valid_579383, JString, required = true,
                                 default = nil)
  if valid_579383 != nil:
    section.add "blogId", valid_579383
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
  var valid_579384 = query.getOrDefault("key")
  valid_579384 = validateParameter(valid_579384, JString, required = false,
                                 default = nil)
  if valid_579384 != nil:
    section.add "key", valid_579384
  var valid_579385 = query.getOrDefault("prettyPrint")
  valid_579385 = validateParameter(valid_579385, JBool, required = false,
                                 default = newJBool(true))
  if valid_579385 != nil:
    section.add "prettyPrint", valid_579385
  var valid_579386 = query.getOrDefault("oauth_token")
  valid_579386 = validateParameter(valid_579386, JString, required = false,
                                 default = nil)
  if valid_579386 != nil:
    section.add "oauth_token", valid_579386
  var valid_579387 = query.getOrDefault("alt")
  valid_579387 = validateParameter(valid_579387, JString, required = false,
                                 default = newJString("json"))
  if valid_579387 != nil:
    section.add "alt", valid_579387
  var valid_579388 = query.getOrDefault("userIp")
  valid_579388 = validateParameter(valid_579388, JString, required = false,
                                 default = nil)
  if valid_579388 != nil:
    section.add "userIp", valid_579388
  var valid_579389 = query.getOrDefault("quotaUser")
  valid_579389 = validateParameter(valid_579389, JString, required = false,
                                 default = nil)
  if valid_579389 != nil:
    section.add "quotaUser", valid_579389
  var valid_579390 = query.getOrDefault("fields")
  valid_579390 = validateParameter(valid_579390, JString, required = false,
                                 default = nil)
  if valid_579390 != nil:
    section.add "fields", valid_579390
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579391: Call_BloggerPostsRevert_579379; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Revert a published or scheduled post to draft state.
  ## 
  let valid = call_579391.validator(path, query, header, formData, body)
  let scheme = call_579391.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579391.url(scheme.get, call_579391.host, call_579391.base,
                         call_579391.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579391, url, valid)

proc call*(call_579392: Call_BloggerPostsRevert_579379; postId: string;
          blogId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## bloggerPostsRevert
  ## Revert a published or scheduled post to draft state.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   postId: string (required)
  ##         : The ID of the Post.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   blogId: string (required)
  ##         : The ID of the Blog.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579393 = newJObject()
  var query_579394 = newJObject()
  add(query_579394, "key", newJString(key))
  add(query_579394, "prettyPrint", newJBool(prettyPrint))
  add(query_579394, "oauth_token", newJString(oauthToken))
  add(path_579393, "postId", newJString(postId))
  add(query_579394, "alt", newJString(alt))
  add(query_579394, "userIp", newJString(userIp))
  add(query_579394, "quotaUser", newJString(quotaUser))
  add(path_579393, "blogId", newJString(blogId))
  add(query_579394, "fields", newJString(fields))
  result = call_579392.call(path_579393, query_579394, nil, nil, nil)

var bloggerPostsRevert* = Call_BloggerPostsRevert_579379(
    name: "bloggerPostsRevert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/blogs/{blogId}/posts/{postId}/revert",
    validator: validate_BloggerPostsRevert_579380, base: "/blogger/v3",
    url: url_BloggerPostsRevert_579381, schemes: {Scheme.Https})
type
  Call_BloggerUsersGet_579395 = ref object of OpenApiRestCall_578339
proc url_BloggerUsersGet_579397(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerUsersGet_579396(path: JsonNode; query: JsonNode;
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
  var valid_579398 = path.getOrDefault("userId")
  valid_579398 = validateParameter(valid_579398, JString, required = true,
                                 default = nil)
  if valid_579398 != nil:
    section.add "userId", valid_579398
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
  var valid_579399 = query.getOrDefault("key")
  valid_579399 = validateParameter(valid_579399, JString, required = false,
                                 default = nil)
  if valid_579399 != nil:
    section.add "key", valid_579399
  var valid_579400 = query.getOrDefault("prettyPrint")
  valid_579400 = validateParameter(valid_579400, JBool, required = false,
                                 default = newJBool(true))
  if valid_579400 != nil:
    section.add "prettyPrint", valid_579400
  var valid_579401 = query.getOrDefault("oauth_token")
  valid_579401 = validateParameter(valid_579401, JString, required = false,
                                 default = nil)
  if valid_579401 != nil:
    section.add "oauth_token", valid_579401
  var valid_579402 = query.getOrDefault("alt")
  valid_579402 = validateParameter(valid_579402, JString, required = false,
                                 default = newJString("json"))
  if valid_579402 != nil:
    section.add "alt", valid_579402
  var valid_579403 = query.getOrDefault("userIp")
  valid_579403 = validateParameter(valid_579403, JString, required = false,
                                 default = nil)
  if valid_579403 != nil:
    section.add "userIp", valid_579403
  var valid_579404 = query.getOrDefault("quotaUser")
  valid_579404 = validateParameter(valid_579404, JString, required = false,
                                 default = nil)
  if valid_579404 != nil:
    section.add "quotaUser", valid_579404
  var valid_579405 = query.getOrDefault("fields")
  valid_579405 = validateParameter(valid_579405, JString, required = false,
                                 default = nil)
  if valid_579405 != nil:
    section.add "fields", valid_579405
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579406: Call_BloggerUsersGet_579395; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one user by ID.
  ## 
  let valid = call_579406.validator(path, query, header, formData, body)
  let scheme = call_579406.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579406.url(scheme.get, call_579406.host, call_579406.base,
                         call_579406.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579406, url, valid)

proc call*(call_579407: Call_BloggerUsersGet_579395; userId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## bloggerUsersGet
  ## Gets one user by ID.
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
  ##         : The ID of the user to get.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579408 = newJObject()
  var query_579409 = newJObject()
  add(query_579409, "key", newJString(key))
  add(query_579409, "prettyPrint", newJBool(prettyPrint))
  add(query_579409, "oauth_token", newJString(oauthToken))
  add(query_579409, "alt", newJString(alt))
  add(query_579409, "userIp", newJString(userIp))
  add(query_579409, "quotaUser", newJString(quotaUser))
  add(path_579408, "userId", newJString(userId))
  add(query_579409, "fields", newJString(fields))
  result = call_579407.call(path_579408, query_579409, nil, nil, nil)

var bloggerUsersGet* = Call_BloggerUsersGet_579395(name: "bloggerUsersGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/users/{userId}",
    validator: validate_BloggerUsersGet_579396, base: "/blogger/v3",
    url: url_BloggerUsersGet_579397, schemes: {Scheme.Https})
type
  Call_BloggerBlogsListByUser_579410 = ref object of OpenApiRestCall_578339
proc url_BloggerBlogsListByUser_579412(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerBlogsListByUser_579411(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of blogs, possibly filtered.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : ID of the user whose blogs are to be fetched. Either the word 'self' or the user's profile identifier.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_579413 = path.getOrDefault("userId")
  valid_579413 = validateParameter(valid_579413, JString, required = true,
                                 default = nil)
  if valid_579413 != nil:
    section.add "userId", valid_579413
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   role: JArray
  ##       : User access types for blogs to include in the results, e.g. AUTHOR will return blogs where the user has author level access. If no roles are specified, defaults to ADMIN and AUTHOR roles.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fetchUserInfo: JBool
  ##                : Whether the response is a list of blogs with per-user information instead of just blogs.
  ##   status: JArray
  ##         : Blog statuses to include in the result (default: Live blogs only). Note that ADMIN access is required to view deleted blogs.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: JString
  ##       : Access level with which to view the blogs. Note that some fields require elevated access.
  section = newJObject()
  var valid_579414 = query.getOrDefault("key")
  valid_579414 = validateParameter(valid_579414, JString, required = false,
                                 default = nil)
  if valid_579414 != nil:
    section.add "key", valid_579414
  var valid_579415 = query.getOrDefault("prettyPrint")
  valid_579415 = validateParameter(valid_579415, JBool, required = false,
                                 default = newJBool(true))
  if valid_579415 != nil:
    section.add "prettyPrint", valid_579415
  var valid_579416 = query.getOrDefault("oauth_token")
  valid_579416 = validateParameter(valid_579416, JString, required = false,
                                 default = nil)
  if valid_579416 != nil:
    section.add "oauth_token", valid_579416
  var valid_579417 = query.getOrDefault("role")
  valid_579417 = validateParameter(valid_579417, JArray, required = false,
                                 default = nil)
  if valid_579417 != nil:
    section.add "role", valid_579417
  var valid_579418 = query.getOrDefault("alt")
  valid_579418 = validateParameter(valid_579418, JString, required = false,
                                 default = newJString("json"))
  if valid_579418 != nil:
    section.add "alt", valid_579418
  var valid_579419 = query.getOrDefault("userIp")
  valid_579419 = validateParameter(valid_579419, JString, required = false,
                                 default = nil)
  if valid_579419 != nil:
    section.add "userIp", valid_579419
  var valid_579420 = query.getOrDefault("quotaUser")
  valid_579420 = validateParameter(valid_579420, JString, required = false,
                                 default = nil)
  if valid_579420 != nil:
    section.add "quotaUser", valid_579420
  var valid_579421 = query.getOrDefault("fetchUserInfo")
  valid_579421 = validateParameter(valid_579421, JBool, required = false, default = nil)
  if valid_579421 != nil:
    section.add "fetchUserInfo", valid_579421
  var valid_579422 = query.getOrDefault("status")
  valid_579422 = validateParameter(valid_579422, JArray, required = false,
                                 default = nil)
  if valid_579422 != nil:
    section.add "status", valid_579422
  var valid_579423 = query.getOrDefault("fields")
  valid_579423 = validateParameter(valid_579423, JString, required = false,
                                 default = nil)
  if valid_579423 != nil:
    section.add "fields", valid_579423
  var valid_579424 = query.getOrDefault("view")
  valid_579424 = validateParameter(valid_579424, JString, required = false,
                                 default = newJString("ADMIN"))
  if valid_579424 != nil:
    section.add "view", valid_579424
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579425: Call_BloggerBlogsListByUser_579410; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of blogs, possibly filtered.
  ## 
  let valid = call_579425.validator(path, query, header, formData, body)
  let scheme = call_579425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579425.url(scheme.get, call_579425.host, call_579425.base,
                         call_579425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579425, url, valid)

proc call*(call_579426: Call_BloggerBlogsListByUser_579410; userId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          role: JsonNode = nil; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fetchUserInfo: bool = false; status: JsonNode = nil;
          fields: string = ""; view: string = "ADMIN"): Recallable =
  ## bloggerBlogsListByUser
  ## Retrieves a list of blogs, possibly filtered.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   role: JArray
  ##       : User access types for blogs to include in the results, e.g. AUTHOR will return blogs where the user has author level access. If no roles are specified, defaults to ADMIN and AUTHOR roles.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   userId: string (required)
  ##         : ID of the user whose blogs are to be fetched. Either the word 'self' or the user's profile identifier.
  ##   fetchUserInfo: bool
  ##                : Whether the response is a list of blogs with per-user information instead of just blogs.
  ##   status: JArray
  ##         : Blog statuses to include in the result (default: Live blogs only). Note that ADMIN access is required to view deleted blogs.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: string
  ##       : Access level with which to view the blogs. Note that some fields require elevated access.
  var path_579427 = newJObject()
  var query_579428 = newJObject()
  add(query_579428, "key", newJString(key))
  add(query_579428, "prettyPrint", newJBool(prettyPrint))
  add(query_579428, "oauth_token", newJString(oauthToken))
  if role != nil:
    query_579428.add "role", role
  add(query_579428, "alt", newJString(alt))
  add(query_579428, "userIp", newJString(userIp))
  add(query_579428, "quotaUser", newJString(quotaUser))
  add(path_579427, "userId", newJString(userId))
  add(query_579428, "fetchUserInfo", newJBool(fetchUserInfo))
  if status != nil:
    query_579428.add "status", status
  add(query_579428, "fields", newJString(fields))
  add(query_579428, "view", newJString(view))
  result = call_579426.call(path_579427, query_579428, nil, nil, nil)

var bloggerBlogsListByUser* = Call_BloggerBlogsListByUser_579410(
    name: "bloggerBlogsListByUser", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userId}/blogs",
    validator: validate_BloggerBlogsListByUser_579411, base: "/blogger/v3",
    url: url_BloggerBlogsListByUser_579412, schemes: {Scheme.Https})
type
  Call_BloggerBlogUserInfosGet_579429 = ref object of OpenApiRestCall_578339
proc url_BloggerBlogUserInfosGet_579431(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerBlogUserInfosGet_579430(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets one blog and user info pair by blogId and userId.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : ID of the user whose blogs are to be fetched. Either the word 'self' or the user's profile identifier.
  ##   blogId: JString (required)
  ##         : The ID of the blog to get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_579432 = path.getOrDefault("userId")
  valid_579432 = validateParameter(valid_579432, JString, required = true,
                                 default = nil)
  if valid_579432 != nil:
    section.add "userId", valid_579432
  var valid_579433 = path.getOrDefault("blogId")
  valid_579433 = validateParameter(valid_579433, JString, required = true,
                                 default = nil)
  if valid_579433 != nil:
    section.add "blogId", valid_579433
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
  ##   maxPosts: JInt
  ##           : Maximum number of posts to pull back with the blog.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579434 = query.getOrDefault("key")
  valid_579434 = validateParameter(valid_579434, JString, required = false,
                                 default = nil)
  if valid_579434 != nil:
    section.add "key", valid_579434
  var valid_579435 = query.getOrDefault("prettyPrint")
  valid_579435 = validateParameter(valid_579435, JBool, required = false,
                                 default = newJBool(true))
  if valid_579435 != nil:
    section.add "prettyPrint", valid_579435
  var valid_579436 = query.getOrDefault("oauth_token")
  valid_579436 = validateParameter(valid_579436, JString, required = false,
                                 default = nil)
  if valid_579436 != nil:
    section.add "oauth_token", valid_579436
  var valid_579437 = query.getOrDefault("alt")
  valid_579437 = validateParameter(valid_579437, JString, required = false,
                                 default = newJString("json"))
  if valid_579437 != nil:
    section.add "alt", valid_579437
  var valid_579438 = query.getOrDefault("userIp")
  valid_579438 = validateParameter(valid_579438, JString, required = false,
                                 default = nil)
  if valid_579438 != nil:
    section.add "userIp", valid_579438
  var valid_579439 = query.getOrDefault("quotaUser")
  valid_579439 = validateParameter(valid_579439, JString, required = false,
                                 default = nil)
  if valid_579439 != nil:
    section.add "quotaUser", valid_579439
  var valid_579440 = query.getOrDefault("maxPosts")
  valid_579440 = validateParameter(valid_579440, JInt, required = false, default = nil)
  if valid_579440 != nil:
    section.add "maxPosts", valid_579440
  var valid_579441 = query.getOrDefault("fields")
  valid_579441 = validateParameter(valid_579441, JString, required = false,
                                 default = nil)
  if valid_579441 != nil:
    section.add "fields", valid_579441
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579442: Call_BloggerBlogUserInfosGet_579429; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one blog and user info pair by blogId and userId.
  ## 
  let valid = call_579442.validator(path, query, header, formData, body)
  let scheme = call_579442.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579442.url(scheme.get, call_579442.host, call_579442.base,
                         call_579442.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579442, url, valid)

proc call*(call_579443: Call_BloggerBlogUserInfosGet_579429; userId: string;
          blogId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; maxPosts: int = 0; fields: string = ""): Recallable =
  ## bloggerBlogUserInfosGet
  ## Gets one blog and user info pair by blogId and userId.
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
  ##   maxPosts: int
  ##           : Maximum number of posts to pull back with the blog.
  ##   userId: string (required)
  ##         : ID of the user whose blogs are to be fetched. Either the word 'self' or the user's profile identifier.
  ##   blogId: string (required)
  ##         : The ID of the blog to get.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579444 = newJObject()
  var query_579445 = newJObject()
  add(query_579445, "key", newJString(key))
  add(query_579445, "prettyPrint", newJBool(prettyPrint))
  add(query_579445, "oauth_token", newJString(oauthToken))
  add(query_579445, "alt", newJString(alt))
  add(query_579445, "userIp", newJString(userIp))
  add(query_579445, "quotaUser", newJString(quotaUser))
  add(query_579445, "maxPosts", newJInt(maxPosts))
  add(path_579444, "userId", newJString(userId))
  add(path_579444, "blogId", newJString(blogId))
  add(query_579445, "fields", newJString(fields))
  result = call_579443.call(path_579444, query_579445, nil, nil, nil)

var bloggerBlogUserInfosGet* = Call_BloggerBlogUserInfosGet_579429(
    name: "bloggerBlogUserInfosGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userId}/blogs/{blogId}",
    validator: validate_BloggerBlogUserInfosGet_579430, base: "/blogger/v3",
    url: url_BloggerBlogUserInfosGet_579431, schemes: {Scheme.Https})
type
  Call_BloggerPostUserInfosList_579446 = ref object of OpenApiRestCall_578339
proc url_BloggerPostUserInfosList_579448(protocol: Scheme; host: string;
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

proc validate_BloggerPostUserInfosList_579447(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of post and post user info pairs, possibly filtered. The post user info contains per-user information about the post, such as access rights, specific to the user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : ID of the user for the per-user information to be fetched. Either the word 'self' or the user's profile identifier.
  ##   blogId: JString (required)
  ##         : ID of the blog to fetch posts from.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_579449 = path.getOrDefault("userId")
  valid_579449 = validateParameter(valid_579449, JString, required = true,
                                 default = nil)
  if valid_579449 != nil:
    section.add "userId", valid_579449
  var valid_579450 = path.getOrDefault("blogId")
  valid_579450 = validateParameter(valid_579450, JString, required = true,
                                 default = nil)
  if valid_579450 != nil:
    section.add "blogId", valid_579450
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   labels: JString
  ##         : Comma-separated list of labels to search for.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   endDate: JString
  ##          : Latest post date to fetch, a date-time with RFC 3339 formatting.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   orderBy: JString
  ##          : Sort order applied to search results. Default is published.
  ##   pageToken: JString
  ##            : Continuation token if the request is paged.
  ##   status: JArray
  ##   fetchBodies: JBool
  ##              : Whether the body content of posts is included. Default is false.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   startDate: JString
  ##            : Earliest post date to fetch, a date-time with RFC 3339 formatting.
  ##   view: JString
  ##       : Access level with which to view the returned result. Note that some fields require elevated access.
  ##   maxResults: JInt
  ##             : Maximum number of posts to fetch.
  section = newJObject()
  var valid_579451 = query.getOrDefault("key")
  valid_579451 = validateParameter(valid_579451, JString, required = false,
                                 default = nil)
  if valid_579451 != nil:
    section.add "key", valid_579451
  var valid_579452 = query.getOrDefault("labels")
  valid_579452 = validateParameter(valid_579452, JString, required = false,
                                 default = nil)
  if valid_579452 != nil:
    section.add "labels", valid_579452
  var valid_579453 = query.getOrDefault("prettyPrint")
  valid_579453 = validateParameter(valid_579453, JBool, required = false,
                                 default = newJBool(true))
  if valid_579453 != nil:
    section.add "prettyPrint", valid_579453
  var valid_579454 = query.getOrDefault("oauth_token")
  valid_579454 = validateParameter(valid_579454, JString, required = false,
                                 default = nil)
  if valid_579454 != nil:
    section.add "oauth_token", valid_579454
  var valid_579455 = query.getOrDefault("alt")
  valid_579455 = validateParameter(valid_579455, JString, required = false,
                                 default = newJString("json"))
  if valid_579455 != nil:
    section.add "alt", valid_579455
  var valid_579456 = query.getOrDefault("userIp")
  valid_579456 = validateParameter(valid_579456, JString, required = false,
                                 default = nil)
  if valid_579456 != nil:
    section.add "userIp", valid_579456
  var valid_579457 = query.getOrDefault("endDate")
  valid_579457 = validateParameter(valid_579457, JString, required = false,
                                 default = nil)
  if valid_579457 != nil:
    section.add "endDate", valid_579457
  var valid_579458 = query.getOrDefault("quotaUser")
  valid_579458 = validateParameter(valid_579458, JString, required = false,
                                 default = nil)
  if valid_579458 != nil:
    section.add "quotaUser", valid_579458
  var valid_579459 = query.getOrDefault("orderBy")
  valid_579459 = validateParameter(valid_579459, JString, required = false,
                                 default = newJString("published"))
  if valid_579459 != nil:
    section.add "orderBy", valid_579459
  var valid_579460 = query.getOrDefault("pageToken")
  valid_579460 = validateParameter(valid_579460, JString, required = false,
                                 default = nil)
  if valid_579460 != nil:
    section.add "pageToken", valid_579460
  var valid_579461 = query.getOrDefault("status")
  valid_579461 = validateParameter(valid_579461, JArray, required = false,
                                 default = nil)
  if valid_579461 != nil:
    section.add "status", valid_579461
  var valid_579462 = query.getOrDefault("fetchBodies")
  valid_579462 = validateParameter(valid_579462, JBool, required = false,
                                 default = newJBool(false))
  if valid_579462 != nil:
    section.add "fetchBodies", valid_579462
  var valid_579463 = query.getOrDefault("fields")
  valid_579463 = validateParameter(valid_579463, JString, required = false,
                                 default = nil)
  if valid_579463 != nil:
    section.add "fields", valid_579463
  var valid_579464 = query.getOrDefault("startDate")
  valid_579464 = validateParameter(valid_579464, JString, required = false,
                                 default = nil)
  if valid_579464 != nil:
    section.add "startDate", valid_579464
  var valid_579465 = query.getOrDefault("view")
  valid_579465 = validateParameter(valid_579465, JString, required = false,
                                 default = newJString("ADMIN"))
  if valid_579465 != nil:
    section.add "view", valid_579465
  var valid_579466 = query.getOrDefault("maxResults")
  valid_579466 = validateParameter(valid_579466, JInt, required = false, default = nil)
  if valid_579466 != nil:
    section.add "maxResults", valid_579466
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579467: Call_BloggerPostUserInfosList_579446; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of post and post user info pairs, possibly filtered. The post user info contains per-user information about the post, such as access rights, specific to the user.
  ## 
  let valid = call_579467.validator(path, query, header, formData, body)
  let scheme = call_579467.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579467.url(scheme.get, call_579467.host, call_579467.base,
                         call_579467.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579467, url, valid)

proc call*(call_579468: Call_BloggerPostUserInfosList_579446; userId: string;
          blogId: string; key: string = ""; labels: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          endDate: string = ""; quotaUser: string = ""; orderBy: string = "published";
          pageToken: string = ""; status: JsonNode = nil; fetchBodies: bool = false;
          fields: string = ""; startDate: string = ""; view: string = "ADMIN";
          maxResults: int = 0): Recallable =
  ## bloggerPostUserInfosList
  ## Retrieves a list of post and post user info pairs, possibly filtered. The post user info contains per-user information about the post, such as access rights, specific to the user.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   labels: string
  ##         : Comma-separated list of labels to search for.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   endDate: string
  ##          : Latest post date to fetch, a date-time with RFC 3339 formatting.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   orderBy: string
  ##          : Sort order applied to search results. Default is published.
  ##   pageToken: string
  ##            : Continuation token if the request is paged.
  ##   userId: string (required)
  ##         : ID of the user for the per-user information to be fetched. Either the word 'self' or the user's profile identifier.
  ##   blogId: string (required)
  ##         : ID of the blog to fetch posts from.
  ##   status: JArray
  ##   fetchBodies: bool
  ##              : Whether the body content of posts is included. Default is false.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   startDate: string
  ##            : Earliest post date to fetch, a date-time with RFC 3339 formatting.
  ##   view: string
  ##       : Access level with which to view the returned result. Note that some fields require elevated access.
  ##   maxResults: int
  ##             : Maximum number of posts to fetch.
  var path_579469 = newJObject()
  var query_579470 = newJObject()
  add(query_579470, "key", newJString(key))
  add(query_579470, "labels", newJString(labels))
  add(query_579470, "prettyPrint", newJBool(prettyPrint))
  add(query_579470, "oauth_token", newJString(oauthToken))
  add(query_579470, "alt", newJString(alt))
  add(query_579470, "userIp", newJString(userIp))
  add(query_579470, "endDate", newJString(endDate))
  add(query_579470, "quotaUser", newJString(quotaUser))
  add(query_579470, "orderBy", newJString(orderBy))
  add(query_579470, "pageToken", newJString(pageToken))
  add(path_579469, "userId", newJString(userId))
  add(path_579469, "blogId", newJString(blogId))
  if status != nil:
    query_579470.add "status", status
  add(query_579470, "fetchBodies", newJBool(fetchBodies))
  add(query_579470, "fields", newJString(fields))
  add(query_579470, "startDate", newJString(startDate))
  add(query_579470, "view", newJString(view))
  add(query_579470, "maxResults", newJInt(maxResults))
  result = call_579468.call(path_579469, query_579470, nil, nil, nil)

var bloggerPostUserInfosList* = Call_BloggerPostUserInfosList_579446(
    name: "bloggerPostUserInfosList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userId}/blogs/{blogId}/posts",
    validator: validate_BloggerPostUserInfosList_579447, base: "/blogger/v3",
    url: url_BloggerPostUserInfosList_579448, schemes: {Scheme.Https})
type
  Call_BloggerPostUserInfosGet_579471 = ref object of OpenApiRestCall_578339
proc url_BloggerPostUserInfosGet_579473(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerPostUserInfosGet_579472(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets one post and user info pair, by post ID and user ID. The post user info contains per-user information about the post, such as access rights, specific to the user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   postId: JString (required)
  ##         : The ID of the post to get.
  ##   userId: JString (required)
  ##         : ID of the user for the per-user information to be fetched. Either the word 'self' or the user's profile identifier.
  ##   blogId: JString (required)
  ##         : The ID of the blog.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `postId` field"
  var valid_579474 = path.getOrDefault("postId")
  valid_579474 = validateParameter(valid_579474, JString, required = true,
                                 default = nil)
  if valid_579474 != nil:
    section.add "postId", valid_579474
  var valid_579475 = path.getOrDefault("userId")
  valid_579475 = validateParameter(valid_579475, JString, required = true,
                                 default = nil)
  if valid_579475 != nil:
    section.add "userId", valid_579475
  var valid_579476 = path.getOrDefault("blogId")
  valid_579476 = validateParameter(valid_579476, JString, required = true,
                                 default = nil)
  if valid_579476 != nil:
    section.add "blogId", valid_579476
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
  ##   maxComments: JInt
  ##              : Maximum number of comments to pull back on a post.
  section = newJObject()
  var valid_579477 = query.getOrDefault("key")
  valid_579477 = validateParameter(valid_579477, JString, required = false,
                                 default = nil)
  if valid_579477 != nil:
    section.add "key", valid_579477
  var valid_579478 = query.getOrDefault("prettyPrint")
  valid_579478 = validateParameter(valid_579478, JBool, required = false,
                                 default = newJBool(true))
  if valid_579478 != nil:
    section.add "prettyPrint", valid_579478
  var valid_579479 = query.getOrDefault("oauth_token")
  valid_579479 = validateParameter(valid_579479, JString, required = false,
                                 default = nil)
  if valid_579479 != nil:
    section.add "oauth_token", valid_579479
  var valid_579480 = query.getOrDefault("alt")
  valid_579480 = validateParameter(valid_579480, JString, required = false,
                                 default = newJString("json"))
  if valid_579480 != nil:
    section.add "alt", valid_579480
  var valid_579481 = query.getOrDefault("userIp")
  valid_579481 = validateParameter(valid_579481, JString, required = false,
                                 default = nil)
  if valid_579481 != nil:
    section.add "userIp", valid_579481
  var valid_579482 = query.getOrDefault("quotaUser")
  valid_579482 = validateParameter(valid_579482, JString, required = false,
                                 default = nil)
  if valid_579482 != nil:
    section.add "quotaUser", valid_579482
  var valid_579483 = query.getOrDefault("fields")
  valid_579483 = validateParameter(valid_579483, JString, required = false,
                                 default = nil)
  if valid_579483 != nil:
    section.add "fields", valid_579483
  var valid_579484 = query.getOrDefault("maxComments")
  valid_579484 = validateParameter(valid_579484, JInt, required = false, default = nil)
  if valid_579484 != nil:
    section.add "maxComments", valid_579484
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579485: Call_BloggerPostUserInfosGet_579471; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one post and user info pair, by post ID and user ID. The post user info contains per-user information about the post, such as access rights, specific to the user.
  ## 
  let valid = call_579485.validator(path, query, header, formData, body)
  let scheme = call_579485.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579485.url(scheme.get, call_579485.host, call_579485.base,
                         call_579485.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579485, url, valid)

proc call*(call_579486: Call_BloggerPostUserInfosGet_579471; postId: string;
          userId: string; blogId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""; maxComments: int = 0): Recallable =
  ## bloggerPostUserInfosGet
  ## Gets one post and user info pair, by post ID and user ID. The post user info contains per-user information about the post, such as access rights, specific to the user.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   postId: string (required)
  ##         : The ID of the post to get.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   userId: string (required)
  ##         : ID of the user for the per-user information to be fetched. Either the word 'self' or the user's profile identifier.
  ##   blogId: string (required)
  ##         : The ID of the blog.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxComments: int
  ##              : Maximum number of comments to pull back on a post.
  var path_579487 = newJObject()
  var query_579488 = newJObject()
  add(query_579488, "key", newJString(key))
  add(query_579488, "prettyPrint", newJBool(prettyPrint))
  add(query_579488, "oauth_token", newJString(oauthToken))
  add(path_579487, "postId", newJString(postId))
  add(query_579488, "alt", newJString(alt))
  add(query_579488, "userIp", newJString(userIp))
  add(query_579488, "quotaUser", newJString(quotaUser))
  add(path_579487, "userId", newJString(userId))
  add(path_579487, "blogId", newJString(blogId))
  add(query_579488, "fields", newJString(fields))
  add(query_579488, "maxComments", newJInt(maxComments))
  result = call_579486.call(path_579487, query_579488, nil, nil, nil)

var bloggerPostUserInfosGet* = Call_BloggerPostUserInfosGet_579471(
    name: "bloggerPostUserInfosGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/users/{userId}/blogs/{blogId}/posts/{postId}",
    validator: validate_BloggerPostUserInfosGet_579472, base: "/blogger/v3",
    url: url_BloggerPostUserInfosGet_579473, schemes: {Scheme.Https})
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
