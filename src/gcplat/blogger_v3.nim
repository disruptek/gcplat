
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

  OpenApiRestCall_588441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588441): Option[Scheme] {.used.} =
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
  gcpServiceName = "blogger"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BloggerBlogsGetByUrl_588709 = ref object of OpenApiRestCall_588441
proc url_BloggerBlogsGetByUrl_588711(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_BloggerBlogsGetByUrl_588710(path: JsonNode; query: JsonNode;
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
  var valid_588823 = query.getOrDefault("fields")
  valid_588823 = validateParameter(valid_588823, JString, required = false,
                                 default = nil)
  if valid_588823 != nil:
    section.add "fields", valid_588823
  var valid_588837 = query.getOrDefault("view")
  valid_588837 = validateParameter(valid_588837, JString, required = false,
                                 default = newJString("ADMIN"))
  if valid_588837 != nil:
    section.add "view", valid_588837
  var valid_588838 = query.getOrDefault("quotaUser")
  valid_588838 = validateParameter(valid_588838, JString, required = false,
                                 default = nil)
  if valid_588838 != nil:
    section.add "quotaUser", valid_588838
  var valid_588839 = query.getOrDefault("alt")
  valid_588839 = validateParameter(valid_588839, JString, required = false,
                                 default = newJString("json"))
  if valid_588839 != nil:
    section.add "alt", valid_588839
  var valid_588840 = query.getOrDefault("oauth_token")
  valid_588840 = validateParameter(valid_588840, JString, required = false,
                                 default = nil)
  if valid_588840 != nil:
    section.add "oauth_token", valid_588840
  var valid_588841 = query.getOrDefault("userIp")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = nil)
  if valid_588841 != nil:
    section.add "userIp", valid_588841
  assert query != nil, "query argument is necessary due to required `url` field"
  var valid_588842 = query.getOrDefault("url")
  valid_588842 = validateParameter(valid_588842, JString, required = true,
                                 default = nil)
  if valid_588842 != nil:
    section.add "url", valid_588842
  var valid_588843 = query.getOrDefault("key")
  valid_588843 = validateParameter(valid_588843, JString, required = false,
                                 default = nil)
  if valid_588843 != nil:
    section.add "key", valid_588843
  var valid_588844 = query.getOrDefault("prettyPrint")
  valid_588844 = validateParameter(valid_588844, JBool, required = false,
                                 default = newJBool(true))
  if valid_588844 != nil:
    section.add "prettyPrint", valid_588844
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588867: Call_BloggerBlogsGetByUrl_588709; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a Blog by URL.
  ## 
  let valid = call_588867.validator(path, query, header, formData, body)
  let scheme = call_588867.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588867.url(scheme.get, call_588867.host, call_588867.base,
                         call_588867.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588867, url, valid)

proc call*(call_588938: Call_BloggerBlogsGetByUrl_588709; url: string;
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
  var query_588939 = newJObject()
  add(query_588939, "fields", newJString(fields))
  add(query_588939, "view", newJString(view))
  add(query_588939, "quotaUser", newJString(quotaUser))
  add(query_588939, "alt", newJString(alt))
  add(query_588939, "oauth_token", newJString(oauthToken))
  add(query_588939, "userIp", newJString(userIp))
  add(query_588939, "url", newJString(url))
  add(query_588939, "key", newJString(key))
  add(query_588939, "prettyPrint", newJBool(prettyPrint))
  result = call_588938.call(nil, query_588939, nil, nil, nil)

var bloggerBlogsGetByUrl* = Call_BloggerBlogsGetByUrl_588709(
    name: "bloggerBlogsGetByUrl", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/blogs/byurl",
    validator: validate_BloggerBlogsGetByUrl_588710, base: "/blogger/v3",
    url: url_BloggerBlogsGetByUrl_588711, schemes: {Scheme.Https})
type
  Call_BloggerBlogsGet_588979 = ref object of OpenApiRestCall_588441
proc url_BloggerBlogsGet_588981(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerBlogsGet_588980(path: JsonNode; query: JsonNode;
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
  var valid_588996 = path.getOrDefault("blogId")
  valid_588996 = validateParameter(valid_588996, JString, required = true,
                                 default = nil)
  if valid_588996 != nil:
    section.add "blogId", valid_588996
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
  var valid_588997 = query.getOrDefault("fields")
  valid_588997 = validateParameter(valid_588997, JString, required = false,
                                 default = nil)
  if valid_588997 != nil:
    section.add "fields", valid_588997
  var valid_588998 = query.getOrDefault("view")
  valid_588998 = validateParameter(valid_588998, JString, required = false,
                                 default = newJString("ADMIN"))
  if valid_588998 != nil:
    section.add "view", valid_588998
  var valid_588999 = query.getOrDefault("quotaUser")
  valid_588999 = validateParameter(valid_588999, JString, required = false,
                                 default = nil)
  if valid_588999 != nil:
    section.add "quotaUser", valid_588999
  var valid_589000 = query.getOrDefault("alt")
  valid_589000 = validateParameter(valid_589000, JString, required = false,
                                 default = newJString("json"))
  if valid_589000 != nil:
    section.add "alt", valid_589000
  var valid_589001 = query.getOrDefault("oauth_token")
  valid_589001 = validateParameter(valid_589001, JString, required = false,
                                 default = nil)
  if valid_589001 != nil:
    section.add "oauth_token", valid_589001
  var valid_589002 = query.getOrDefault("userIp")
  valid_589002 = validateParameter(valid_589002, JString, required = false,
                                 default = nil)
  if valid_589002 != nil:
    section.add "userIp", valid_589002
  var valid_589003 = query.getOrDefault("key")
  valid_589003 = validateParameter(valid_589003, JString, required = false,
                                 default = nil)
  if valid_589003 != nil:
    section.add "key", valid_589003
  var valid_589004 = query.getOrDefault("prettyPrint")
  valid_589004 = validateParameter(valid_589004, JBool, required = false,
                                 default = newJBool(true))
  if valid_589004 != nil:
    section.add "prettyPrint", valid_589004
  var valid_589005 = query.getOrDefault("maxPosts")
  valid_589005 = validateParameter(valid_589005, JInt, required = false, default = nil)
  if valid_589005 != nil:
    section.add "maxPosts", valid_589005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589006: Call_BloggerBlogsGet_588979; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one blog by ID.
  ## 
  let valid = call_589006.validator(path, query, header, formData, body)
  let scheme = call_589006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589006.url(scheme.get, call_589006.host, call_589006.base,
                         call_589006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589006, url, valid)

proc call*(call_589007: Call_BloggerBlogsGet_588979; blogId: string;
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
  var path_589008 = newJObject()
  var query_589009 = newJObject()
  add(query_589009, "fields", newJString(fields))
  add(query_589009, "view", newJString(view))
  add(query_589009, "quotaUser", newJString(quotaUser))
  add(query_589009, "alt", newJString(alt))
  add(query_589009, "oauth_token", newJString(oauthToken))
  add(query_589009, "userIp", newJString(userIp))
  add(query_589009, "key", newJString(key))
  add(path_589008, "blogId", newJString(blogId))
  add(query_589009, "prettyPrint", newJBool(prettyPrint))
  add(query_589009, "maxPosts", newJInt(maxPosts))
  result = call_589007.call(path_589008, query_589009, nil, nil, nil)

var bloggerBlogsGet* = Call_BloggerBlogsGet_588979(name: "bloggerBlogsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/blogs/{blogId}",
    validator: validate_BloggerBlogsGet_588980, base: "/blogger/v3",
    url: url_BloggerBlogsGet_588981, schemes: {Scheme.Https})
type
  Call_BloggerCommentsListByBlog_589010 = ref object of OpenApiRestCall_588441
proc url_BloggerCommentsListByBlog_589012(protocol: Scheme; host: string;
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

proc validate_BloggerCommentsListByBlog_589011(path: JsonNode; query: JsonNode;
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
  var valid_589013 = path.getOrDefault("blogId")
  valid_589013 = validateParameter(valid_589013, JString, required = true,
                                 default = nil)
  if valid_589013 != nil:
    section.add "blogId", valid_589013
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
  var valid_589014 = query.getOrDefault("fields")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "fields", valid_589014
  var valid_589015 = query.getOrDefault("pageToken")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "pageToken", valid_589015
  var valid_589016 = query.getOrDefault("quotaUser")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "quotaUser", valid_589016
  var valid_589017 = query.getOrDefault("alt")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = newJString("json"))
  if valid_589017 != nil:
    section.add "alt", valid_589017
  var valid_589018 = query.getOrDefault("endDate")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "endDate", valid_589018
  var valid_589019 = query.getOrDefault("startDate")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "startDate", valid_589019
  var valid_589020 = query.getOrDefault("oauth_token")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = nil)
  if valid_589020 != nil:
    section.add "oauth_token", valid_589020
  var valid_589021 = query.getOrDefault("userIp")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "userIp", valid_589021
  var valid_589022 = query.getOrDefault("maxResults")
  valid_589022 = validateParameter(valid_589022, JInt, required = false, default = nil)
  if valid_589022 != nil:
    section.add "maxResults", valid_589022
  var valid_589023 = query.getOrDefault("key")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = nil)
  if valid_589023 != nil:
    section.add "key", valid_589023
  var valid_589024 = query.getOrDefault("status")
  valid_589024 = validateParameter(valid_589024, JArray, required = false,
                                 default = nil)
  if valid_589024 != nil:
    section.add "status", valid_589024
  var valid_589025 = query.getOrDefault("fetchBodies")
  valid_589025 = validateParameter(valid_589025, JBool, required = false, default = nil)
  if valid_589025 != nil:
    section.add "fetchBodies", valid_589025
  var valid_589026 = query.getOrDefault("prettyPrint")
  valid_589026 = validateParameter(valid_589026, JBool, required = false,
                                 default = newJBool(true))
  if valid_589026 != nil:
    section.add "prettyPrint", valid_589026
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589027: Call_BloggerCommentsListByBlog_589010; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the comments for a blog, across all posts, possibly filtered.
  ## 
  let valid = call_589027.validator(path, query, header, formData, body)
  let scheme = call_589027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589027.url(scheme.get, call_589027.host, call_589027.base,
                         call_589027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589027, url, valid)

proc call*(call_589028: Call_BloggerCommentsListByBlog_589010; blogId: string;
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
  var path_589029 = newJObject()
  var query_589030 = newJObject()
  add(query_589030, "fields", newJString(fields))
  add(query_589030, "pageToken", newJString(pageToken))
  add(query_589030, "quotaUser", newJString(quotaUser))
  add(query_589030, "alt", newJString(alt))
  add(query_589030, "endDate", newJString(endDate))
  add(query_589030, "startDate", newJString(startDate))
  add(query_589030, "oauth_token", newJString(oauthToken))
  add(query_589030, "userIp", newJString(userIp))
  add(query_589030, "maxResults", newJInt(maxResults))
  add(query_589030, "key", newJString(key))
  if status != nil:
    query_589030.add "status", status
  add(query_589030, "fetchBodies", newJBool(fetchBodies))
  add(path_589029, "blogId", newJString(blogId))
  add(query_589030, "prettyPrint", newJBool(prettyPrint))
  result = call_589028.call(path_589029, query_589030, nil, nil, nil)

var bloggerCommentsListByBlog* = Call_BloggerCommentsListByBlog_589010(
    name: "bloggerCommentsListByBlog", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/blogs/{blogId}/comments",
    validator: validate_BloggerCommentsListByBlog_589011, base: "/blogger/v3",
    url: url_BloggerCommentsListByBlog_589012, schemes: {Scheme.Https})
type
  Call_BloggerPagesInsert_589051 = ref object of OpenApiRestCall_588441
proc url_BloggerPagesInsert_589053(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerPagesInsert_589052(path: JsonNode; query: JsonNode;
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
  var valid_589054 = path.getOrDefault("blogId")
  valid_589054 = validateParameter(valid_589054, JString, required = true,
                                 default = nil)
  if valid_589054 != nil:
    section.add "blogId", valid_589054
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
  var valid_589055 = query.getOrDefault("fields")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "fields", valid_589055
  var valid_589056 = query.getOrDefault("quotaUser")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "quotaUser", valid_589056
  var valid_589057 = query.getOrDefault("alt")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = newJString("json"))
  if valid_589057 != nil:
    section.add "alt", valid_589057
  var valid_589058 = query.getOrDefault("oauth_token")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "oauth_token", valid_589058
  var valid_589059 = query.getOrDefault("isDraft")
  valid_589059 = validateParameter(valid_589059, JBool, required = false, default = nil)
  if valid_589059 != nil:
    section.add "isDraft", valid_589059
  var valid_589060 = query.getOrDefault("userIp")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "userIp", valid_589060
  var valid_589061 = query.getOrDefault("key")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "key", valid_589061
  var valid_589062 = query.getOrDefault("prettyPrint")
  valid_589062 = validateParameter(valid_589062, JBool, required = false,
                                 default = newJBool(true))
  if valid_589062 != nil:
    section.add "prettyPrint", valid_589062
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

proc call*(call_589064: Call_BloggerPagesInsert_589051; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a page.
  ## 
  let valid = call_589064.validator(path, query, header, formData, body)
  let scheme = call_589064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589064.url(scheme.get, call_589064.host, call_589064.base,
                         call_589064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589064, url, valid)

proc call*(call_589065: Call_BloggerPagesInsert_589051; blogId: string;
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
  var path_589066 = newJObject()
  var query_589067 = newJObject()
  var body_589068 = newJObject()
  add(query_589067, "fields", newJString(fields))
  add(query_589067, "quotaUser", newJString(quotaUser))
  add(query_589067, "alt", newJString(alt))
  add(query_589067, "oauth_token", newJString(oauthToken))
  add(query_589067, "isDraft", newJBool(isDraft))
  add(query_589067, "userIp", newJString(userIp))
  add(query_589067, "key", newJString(key))
  add(path_589066, "blogId", newJString(blogId))
  if body != nil:
    body_589068 = body
  add(query_589067, "prettyPrint", newJBool(prettyPrint))
  result = call_589065.call(path_589066, query_589067, nil, nil, body_589068)

var bloggerPagesInsert* = Call_BloggerPagesInsert_589051(
    name: "bloggerPagesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/blogs/{blogId}/pages",
    validator: validate_BloggerPagesInsert_589052, base: "/blogger/v3",
    url: url_BloggerPagesInsert_589053, schemes: {Scheme.Https})
type
  Call_BloggerPagesList_589031 = ref object of OpenApiRestCall_588441
proc url_BloggerPagesList_589033(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerPagesList_589032(path: JsonNode; query: JsonNode;
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
  var valid_589034 = path.getOrDefault("blogId")
  valid_589034 = validateParameter(valid_589034, JString, required = true,
                                 default = nil)
  if valid_589034 != nil:
    section.add "blogId", valid_589034
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
  var valid_589035 = query.getOrDefault("fields")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "fields", valid_589035
  var valid_589036 = query.getOrDefault("pageToken")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "pageToken", valid_589036
  var valid_589037 = query.getOrDefault("quotaUser")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "quotaUser", valid_589037
  var valid_589038 = query.getOrDefault("view")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = newJString("ADMIN"))
  if valid_589038 != nil:
    section.add "view", valid_589038
  var valid_589039 = query.getOrDefault("alt")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = newJString("json"))
  if valid_589039 != nil:
    section.add "alt", valid_589039
  var valid_589040 = query.getOrDefault("oauth_token")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "oauth_token", valid_589040
  var valid_589041 = query.getOrDefault("userIp")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "userIp", valid_589041
  var valid_589042 = query.getOrDefault("maxResults")
  valid_589042 = validateParameter(valid_589042, JInt, required = false, default = nil)
  if valid_589042 != nil:
    section.add "maxResults", valid_589042
  var valid_589043 = query.getOrDefault("key")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "key", valid_589043
  var valid_589044 = query.getOrDefault("status")
  valid_589044 = validateParameter(valid_589044, JArray, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "status", valid_589044
  var valid_589045 = query.getOrDefault("fetchBodies")
  valid_589045 = validateParameter(valid_589045, JBool, required = false, default = nil)
  if valid_589045 != nil:
    section.add "fetchBodies", valid_589045
  var valid_589046 = query.getOrDefault("prettyPrint")
  valid_589046 = validateParameter(valid_589046, JBool, required = false,
                                 default = newJBool(true))
  if valid_589046 != nil:
    section.add "prettyPrint", valid_589046
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589047: Call_BloggerPagesList_589031; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the pages for a blog, optionally including non-LIVE statuses.
  ## 
  let valid = call_589047.validator(path, query, header, formData, body)
  let scheme = call_589047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589047.url(scheme.get, call_589047.host, call_589047.base,
                         call_589047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589047, url, valid)

proc call*(call_589048: Call_BloggerPagesList_589031; blogId: string;
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
  var path_589049 = newJObject()
  var query_589050 = newJObject()
  add(query_589050, "fields", newJString(fields))
  add(query_589050, "pageToken", newJString(pageToken))
  add(query_589050, "quotaUser", newJString(quotaUser))
  add(query_589050, "view", newJString(view))
  add(query_589050, "alt", newJString(alt))
  add(query_589050, "oauth_token", newJString(oauthToken))
  add(query_589050, "userIp", newJString(userIp))
  add(query_589050, "maxResults", newJInt(maxResults))
  add(query_589050, "key", newJString(key))
  if status != nil:
    query_589050.add "status", status
  add(query_589050, "fetchBodies", newJBool(fetchBodies))
  add(path_589049, "blogId", newJString(blogId))
  add(query_589050, "prettyPrint", newJBool(prettyPrint))
  result = call_589048.call(path_589049, query_589050, nil, nil, nil)

var bloggerPagesList* = Call_BloggerPagesList_589031(name: "bloggerPagesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/blogs/{blogId}/pages", validator: validate_BloggerPagesList_589032,
    base: "/blogger/v3", url: url_BloggerPagesList_589033, schemes: {Scheme.Https})
type
  Call_BloggerPagesUpdate_589086 = ref object of OpenApiRestCall_588441
proc url_BloggerPagesUpdate_589088(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerPagesUpdate_589087(path: JsonNode; query: JsonNode;
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
  var valid_589089 = path.getOrDefault("pageId")
  valid_589089 = validateParameter(valid_589089, JString, required = true,
                                 default = nil)
  if valid_589089 != nil:
    section.add "pageId", valid_589089
  var valid_589090 = path.getOrDefault("blogId")
  valid_589090 = validateParameter(valid_589090, JString, required = true,
                                 default = nil)
  if valid_589090 != nil:
    section.add "blogId", valid_589090
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
  var valid_589091 = query.getOrDefault("revert")
  valid_589091 = validateParameter(valid_589091, JBool, required = false, default = nil)
  if valid_589091 != nil:
    section.add "revert", valid_589091
  var valid_589092 = query.getOrDefault("fields")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "fields", valid_589092
  var valid_589093 = query.getOrDefault("quotaUser")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "quotaUser", valid_589093
  var valid_589094 = query.getOrDefault("alt")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = newJString("json"))
  if valid_589094 != nil:
    section.add "alt", valid_589094
  var valid_589095 = query.getOrDefault("oauth_token")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "oauth_token", valid_589095
  var valid_589096 = query.getOrDefault("userIp")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = nil)
  if valid_589096 != nil:
    section.add "userIp", valid_589096
  var valid_589097 = query.getOrDefault("key")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "key", valid_589097
  var valid_589098 = query.getOrDefault("publish")
  valid_589098 = validateParameter(valid_589098, JBool, required = false, default = nil)
  if valid_589098 != nil:
    section.add "publish", valid_589098
  var valid_589099 = query.getOrDefault("prettyPrint")
  valid_589099 = validateParameter(valid_589099, JBool, required = false,
                                 default = newJBool(true))
  if valid_589099 != nil:
    section.add "prettyPrint", valid_589099
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

proc call*(call_589101: Call_BloggerPagesUpdate_589086; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a page.
  ## 
  let valid = call_589101.validator(path, query, header, formData, body)
  let scheme = call_589101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589101.url(scheme.get, call_589101.host, call_589101.base,
                         call_589101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589101, url, valid)

proc call*(call_589102: Call_BloggerPagesUpdate_589086; pageId: string;
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
  var path_589103 = newJObject()
  var query_589104 = newJObject()
  var body_589105 = newJObject()
  add(query_589104, "revert", newJBool(revert))
  add(query_589104, "fields", newJString(fields))
  add(query_589104, "quotaUser", newJString(quotaUser))
  add(query_589104, "alt", newJString(alt))
  add(query_589104, "oauth_token", newJString(oauthToken))
  add(query_589104, "userIp", newJString(userIp))
  add(query_589104, "key", newJString(key))
  add(path_589103, "pageId", newJString(pageId))
  add(query_589104, "publish", newJBool(publish))
  add(path_589103, "blogId", newJString(blogId))
  if body != nil:
    body_589105 = body
  add(query_589104, "prettyPrint", newJBool(prettyPrint))
  result = call_589102.call(path_589103, query_589104, nil, nil, body_589105)

var bloggerPagesUpdate* = Call_BloggerPagesUpdate_589086(
    name: "bloggerPagesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/blogs/{blogId}/pages/{pageId}",
    validator: validate_BloggerPagesUpdate_589087, base: "/blogger/v3",
    url: url_BloggerPagesUpdate_589088, schemes: {Scheme.Https})
type
  Call_BloggerPagesGet_589069 = ref object of OpenApiRestCall_588441
proc url_BloggerPagesGet_589071(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerPagesGet_589070(path: JsonNode; query: JsonNode;
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
  var valid_589072 = path.getOrDefault("pageId")
  valid_589072 = validateParameter(valid_589072, JString, required = true,
                                 default = nil)
  if valid_589072 != nil:
    section.add "pageId", valid_589072
  var valid_589073 = path.getOrDefault("blogId")
  valid_589073 = validateParameter(valid_589073, JString, required = true,
                                 default = nil)
  if valid_589073 != nil:
    section.add "blogId", valid_589073
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
  var valid_589074 = query.getOrDefault("fields")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "fields", valid_589074
  var valid_589075 = query.getOrDefault("view")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = newJString("ADMIN"))
  if valid_589075 != nil:
    section.add "view", valid_589075
  var valid_589076 = query.getOrDefault("quotaUser")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "quotaUser", valid_589076
  var valid_589077 = query.getOrDefault("alt")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = newJString("json"))
  if valid_589077 != nil:
    section.add "alt", valid_589077
  var valid_589078 = query.getOrDefault("oauth_token")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = nil)
  if valid_589078 != nil:
    section.add "oauth_token", valid_589078
  var valid_589079 = query.getOrDefault("userIp")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = nil)
  if valid_589079 != nil:
    section.add "userIp", valid_589079
  var valid_589080 = query.getOrDefault("key")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "key", valid_589080
  var valid_589081 = query.getOrDefault("prettyPrint")
  valid_589081 = validateParameter(valid_589081, JBool, required = false,
                                 default = newJBool(true))
  if valid_589081 != nil:
    section.add "prettyPrint", valid_589081
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589082: Call_BloggerPagesGet_589069; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one blog page by ID.
  ## 
  let valid = call_589082.validator(path, query, header, formData, body)
  let scheme = call_589082.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589082.url(scheme.get, call_589082.host, call_589082.base,
                         call_589082.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589082, url, valid)

proc call*(call_589083: Call_BloggerPagesGet_589069; pageId: string; blogId: string;
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
  var path_589084 = newJObject()
  var query_589085 = newJObject()
  add(query_589085, "fields", newJString(fields))
  add(query_589085, "view", newJString(view))
  add(query_589085, "quotaUser", newJString(quotaUser))
  add(query_589085, "alt", newJString(alt))
  add(query_589085, "oauth_token", newJString(oauthToken))
  add(query_589085, "userIp", newJString(userIp))
  add(query_589085, "key", newJString(key))
  add(path_589084, "pageId", newJString(pageId))
  add(path_589084, "blogId", newJString(blogId))
  add(query_589085, "prettyPrint", newJBool(prettyPrint))
  result = call_589083.call(path_589084, query_589085, nil, nil, nil)

var bloggerPagesGet* = Call_BloggerPagesGet_589069(name: "bloggerPagesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/blogs/{blogId}/pages/{pageId}", validator: validate_BloggerPagesGet_589070,
    base: "/blogger/v3", url: url_BloggerPagesGet_589071, schemes: {Scheme.Https})
type
  Call_BloggerPagesPatch_589122 = ref object of OpenApiRestCall_588441
proc url_BloggerPagesPatch_589124(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerPagesPatch_589123(path: JsonNode; query: JsonNode;
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
  var valid_589125 = path.getOrDefault("pageId")
  valid_589125 = validateParameter(valid_589125, JString, required = true,
                                 default = nil)
  if valid_589125 != nil:
    section.add "pageId", valid_589125
  var valid_589126 = path.getOrDefault("blogId")
  valid_589126 = validateParameter(valid_589126, JString, required = true,
                                 default = nil)
  if valid_589126 != nil:
    section.add "blogId", valid_589126
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
  var valid_589127 = query.getOrDefault("revert")
  valid_589127 = validateParameter(valid_589127, JBool, required = false, default = nil)
  if valid_589127 != nil:
    section.add "revert", valid_589127
  var valid_589128 = query.getOrDefault("fields")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "fields", valid_589128
  var valid_589129 = query.getOrDefault("quotaUser")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = nil)
  if valid_589129 != nil:
    section.add "quotaUser", valid_589129
  var valid_589130 = query.getOrDefault("alt")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = newJString("json"))
  if valid_589130 != nil:
    section.add "alt", valid_589130
  var valid_589131 = query.getOrDefault("oauth_token")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "oauth_token", valid_589131
  var valid_589132 = query.getOrDefault("userIp")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "userIp", valid_589132
  var valid_589133 = query.getOrDefault("key")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = nil)
  if valid_589133 != nil:
    section.add "key", valid_589133
  var valid_589134 = query.getOrDefault("publish")
  valid_589134 = validateParameter(valid_589134, JBool, required = false, default = nil)
  if valid_589134 != nil:
    section.add "publish", valid_589134
  var valid_589135 = query.getOrDefault("prettyPrint")
  valid_589135 = validateParameter(valid_589135, JBool, required = false,
                                 default = newJBool(true))
  if valid_589135 != nil:
    section.add "prettyPrint", valid_589135
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

proc call*(call_589137: Call_BloggerPagesPatch_589122; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a page. This method supports patch semantics.
  ## 
  let valid = call_589137.validator(path, query, header, formData, body)
  let scheme = call_589137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589137.url(scheme.get, call_589137.host, call_589137.base,
                         call_589137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589137, url, valid)

proc call*(call_589138: Call_BloggerPagesPatch_589122; pageId: string;
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
  var path_589139 = newJObject()
  var query_589140 = newJObject()
  var body_589141 = newJObject()
  add(query_589140, "revert", newJBool(revert))
  add(query_589140, "fields", newJString(fields))
  add(query_589140, "quotaUser", newJString(quotaUser))
  add(query_589140, "alt", newJString(alt))
  add(query_589140, "oauth_token", newJString(oauthToken))
  add(query_589140, "userIp", newJString(userIp))
  add(query_589140, "key", newJString(key))
  add(path_589139, "pageId", newJString(pageId))
  add(query_589140, "publish", newJBool(publish))
  add(path_589139, "blogId", newJString(blogId))
  if body != nil:
    body_589141 = body
  add(query_589140, "prettyPrint", newJBool(prettyPrint))
  result = call_589138.call(path_589139, query_589140, nil, nil, body_589141)

var bloggerPagesPatch* = Call_BloggerPagesPatch_589122(name: "bloggerPagesPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/blogs/{blogId}/pages/{pageId}",
    validator: validate_BloggerPagesPatch_589123, base: "/blogger/v3",
    url: url_BloggerPagesPatch_589124, schemes: {Scheme.Https})
type
  Call_BloggerPagesDelete_589106 = ref object of OpenApiRestCall_588441
proc url_BloggerPagesDelete_589108(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerPagesDelete_589107(path: JsonNode; query: JsonNode;
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
  var valid_589109 = path.getOrDefault("pageId")
  valid_589109 = validateParameter(valid_589109, JString, required = true,
                                 default = nil)
  if valid_589109 != nil:
    section.add "pageId", valid_589109
  var valid_589110 = path.getOrDefault("blogId")
  valid_589110 = validateParameter(valid_589110, JString, required = true,
                                 default = nil)
  if valid_589110 != nil:
    section.add "blogId", valid_589110
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
  var valid_589111 = query.getOrDefault("fields")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = nil)
  if valid_589111 != nil:
    section.add "fields", valid_589111
  var valid_589112 = query.getOrDefault("quotaUser")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "quotaUser", valid_589112
  var valid_589113 = query.getOrDefault("alt")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = newJString("json"))
  if valid_589113 != nil:
    section.add "alt", valid_589113
  var valid_589114 = query.getOrDefault("oauth_token")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "oauth_token", valid_589114
  var valid_589115 = query.getOrDefault("userIp")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "userIp", valid_589115
  var valid_589116 = query.getOrDefault("key")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = nil)
  if valid_589116 != nil:
    section.add "key", valid_589116
  var valid_589117 = query.getOrDefault("prettyPrint")
  valid_589117 = validateParameter(valid_589117, JBool, required = false,
                                 default = newJBool(true))
  if valid_589117 != nil:
    section.add "prettyPrint", valid_589117
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589118: Call_BloggerPagesDelete_589106; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a page by ID.
  ## 
  let valid = call_589118.validator(path, query, header, formData, body)
  let scheme = call_589118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589118.url(scheme.get, call_589118.host, call_589118.base,
                         call_589118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589118, url, valid)

proc call*(call_589119: Call_BloggerPagesDelete_589106; pageId: string;
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
  var path_589120 = newJObject()
  var query_589121 = newJObject()
  add(query_589121, "fields", newJString(fields))
  add(query_589121, "quotaUser", newJString(quotaUser))
  add(query_589121, "alt", newJString(alt))
  add(query_589121, "oauth_token", newJString(oauthToken))
  add(query_589121, "userIp", newJString(userIp))
  add(query_589121, "key", newJString(key))
  add(path_589120, "pageId", newJString(pageId))
  add(path_589120, "blogId", newJString(blogId))
  add(query_589121, "prettyPrint", newJBool(prettyPrint))
  result = call_589119.call(path_589120, query_589121, nil, nil, nil)

var bloggerPagesDelete* = Call_BloggerPagesDelete_589106(
    name: "bloggerPagesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/blogs/{blogId}/pages/{pageId}",
    validator: validate_BloggerPagesDelete_589107, base: "/blogger/v3",
    url: url_BloggerPagesDelete_589108, schemes: {Scheme.Https})
type
  Call_BloggerPagesPublish_589142 = ref object of OpenApiRestCall_588441
proc url_BloggerPagesPublish_589144(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerPagesPublish_589143(path: JsonNode; query: JsonNode;
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
  var valid_589145 = path.getOrDefault("pageId")
  valid_589145 = validateParameter(valid_589145, JString, required = true,
                                 default = nil)
  if valid_589145 != nil:
    section.add "pageId", valid_589145
  var valid_589146 = path.getOrDefault("blogId")
  valid_589146 = validateParameter(valid_589146, JString, required = true,
                                 default = nil)
  if valid_589146 != nil:
    section.add "blogId", valid_589146
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
  var valid_589147 = query.getOrDefault("fields")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = nil)
  if valid_589147 != nil:
    section.add "fields", valid_589147
  var valid_589148 = query.getOrDefault("quotaUser")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "quotaUser", valid_589148
  var valid_589149 = query.getOrDefault("alt")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = newJString("json"))
  if valid_589149 != nil:
    section.add "alt", valid_589149
  var valid_589150 = query.getOrDefault("oauth_token")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = nil)
  if valid_589150 != nil:
    section.add "oauth_token", valid_589150
  var valid_589151 = query.getOrDefault("userIp")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = nil)
  if valid_589151 != nil:
    section.add "userIp", valid_589151
  var valid_589152 = query.getOrDefault("key")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "key", valid_589152
  var valid_589153 = query.getOrDefault("prettyPrint")
  valid_589153 = validateParameter(valid_589153, JBool, required = false,
                                 default = newJBool(true))
  if valid_589153 != nil:
    section.add "prettyPrint", valid_589153
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589154: Call_BloggerPagesPublish_589142; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Publishes a draft page.
  ## 
  let valid = call_589154.validator(path, query, header, formData, body)
  let scheme = call_589154.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589154.url(scheme.get, call_589154.host, call_589154.base,
                         call_589154.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589154, url, valid)

proc call*(call_589155: Call_BloggerPagesPublish_589142; pageId: string;
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
  var path_589156 = newJObject()
  var query_589157 = newJObject()
  add(query_589157, "fields", newJString(fields))
  add(query_589157, "quotaUser", newJString(quotaUser))
  add(query_589157, "alt", newJString(alt))
  add(query_589157, "oauth_token", newJString(oauthToken))
  add(query_589157, "userIp", newJString(userIp))
  add(query_589157, "key", newJString(key))
  add(path_589156, "pageId", newJString(pageId))
  add(path_589156, "blogId", newJString(blogId))
  add(query_589157, "prettyPrint", newJBool(prettyPrint))
  result = call_589155.call(path_589156, query_589157, nil, nil, nil)

var bloggerPagesPublish* = Call_BloggerPagesPublish_589142(
    name: "bloggerPagesPublish", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/blogs/{blogId}/pages/{pageId}/publish",
    validator: validate_BloggerPagesPublish_589143, base: "/blogger/v3",
    url: url_BloggerPagesPublish_589144, schemes: {Scheme.Https})
type
  Call_BloggerPagesRevert_589158 = ref object of OpenApiRestCall_588441
proc url_BloggerPagesRevert_589160(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerPagesRevert_589159(path: JsonNode; query: JsonNode;
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
  var valid_589161 = path.getOrDefault("pageId")
  valid_589161 = validateParameter(valid_589161, JString, required = true,
                                 default = nil)
  if valid_589161 != nil:
    section.add "pageId", valid_589161
  var valid_589162 = path.getOrDefault("blogId")
  valid_589162 = validateParameter(valid_589162, JString, required = true,
                                 default = nil)
  if valid_589162 != nil:
    section.add "blogId", valid_589162
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
  var valid_589163 = query.getOrDefault("fields")
  valid_589163 = validateParameter(valid_589163, JString, required = false,
                                 default = nil)
  if valid_589163 != nil:
    section.add "fields", valid_589163
  var valid_589164 = query.getOrDefault("quotaUser")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = nil)
  if valid_589164 != nil:
    section.add "quotaUser", valid_589164
  var valid_589165 = query.getOrDefault("alt")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = newJString("json"))
  if valid_589165 != nil:
    section.add "alt", valid_589165
  var valid_589166 = query.getOrDefault("oauth_token")
  valid_589166 = validateParameter(valid_589166, JString, required = false,
                                 default = nil)
  if valid_589166 != nil:
    section.add "oauth_token", valid_589166
  var valid_589167 = query.getOrDefault("userIp")
  valid_589167 = validateParameter(valid_589167, JString, required = false,
                                 default = nil)
  if valid_589167 != nil:
    section.add "userIp", valid_589167
  var valid_589168 = query.getOrDefault("key")
  valid_589168 = validateParameter(valid_589168, JString, required = false,
                                 default = nil)
  if valid_589168 != nil:
    section.add "key", valid_589168
  var valid_589169 = query.getOrDefault("prettyPrint")
  valid_589169 = validateParameter(valid_589169, JBool, required = false,
                                 default = newJBool(true))
  if valid_589169 != nil:
    section.add "prettyPrint", valid_589169
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589170: Call_BloggerPagesRevert_589158; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Revert a published or scheduled page to draft state.
  ## 
  let valid = call_589170.validator(path, query, header, formData, body)
  let scheme = call_589170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589170.url(scheme.get, call_589170.host, call_589170.base,
                         call_589170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589170, url, valid)

proc call*(call_589171: Call_BloggerPagesRevert_589158; pageId: string;
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
  var path_589172 = newJObject()
  var query_589173 = newJObject()
  add(query_589173, "fields", newJString(fields))
  add(query_589173, "quotaUser", newJString(quotaUser))
  add(query_589173, "alt", newJString(alt))
  add(query_589173, "oauth_token", newJString(oauthToken))
  add(query_589173, "userIp", newJString(userIp))
  add(query_589173, "key", newJString(key))
  add(path_589172, "pageId", newJString(pageId))
  add(path_589172, "blogId", newJString(blogId))
  add(query_589173, "prettyPrint", newJBool(prettyPrint))
  result = call_589171.call(path_589172, query_589173, nil, nil, nil)

var bloggerPagesRevert* = Call_BloggerPagesRevert_589158(
    name: "bloggerPagesRevert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/blogs/{blogId}/pages/{pageId}/revert",
    validator: validate_BloggerPagesRevert_589159, base: "/blogger/v3",
    url: url_BloggerPagesRevert_589160, schemes: {Scheme.Https})
type
  Call_BloggerPageViewsGet_589174 = ref object of OpenApiRestCall_588441
proc url_BloggerPageViewsGet_589176(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerPageViewsGet_589175(path: JsonNode; query: JsonNode;
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
  var valid_589177 = path.getOrDefault("blogId")
  valid_589177 = validateParameter(valid_589177, JString, required = true,
                                 default = nil)
  if valid_589177 != nil:
    section.add "blogId", valid_589177
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
  var valid_589178 = query.getOrDefault("fields")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "fields", valid_589178
  var valid_589179 = query.getOrDefault("quotaUser")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = nil)
  if valid_589179 != nil:
    section.add "quotaUser", valid_589179
  var valid_589180 = query.getOrDefault("alt")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = newJString("json"))
  if valid_589180 != nil:
    section.add "alt", valid_589180
  var valid_589181 = query.getOrDefault("range")
  valid_589181 = validateParameter(valid_589181, JArray, required = false,
                                 default = nil)
  if valid_589181 != nil:
    section.add "range", valid_589181
  var valid_589182 = query.getOrDefault("oauth_token")
  valid_589182 = validateParameter(valid_589182, JString, required = false,
                                 default = nil)
  if valid_589182 != nil:
    section.add "oauth_token", valid_589182
  var valid_589183 = query.getOrDefault("userIp")
  valid_589183 = validateParameter(valid_589183, JString, required = false,
                                 default = nil)
  if valid_589183 != nil:
    section.add "userIp", valid_589183
  var valid_589184 = query.getOrDefault("key")
  valid_589184 = validateParameter(valid_589184, JString, required = false,
                                 default = nil)
  if valid_589184 != nil:
    section.add "key", valid_589184
  var valid_589185 = query.getOrDefault("prettyPrint")
  valid_589185 = validateParameter(valid_589185, JBool, required = false,
                                 default = newJBool(true))
  if valid_589185 != nil:
    section.add "prettyPrint", valid_589185
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589186: Call_BloggerPageViewsGet_589174; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve pageview stats for a Blog.
  ## 
  let valid = call_589186.validator(path, query, header, formData, body)
  let scheme = call_589186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589186.url(scheme.get, call_589186.host, call_589186.base,
                         call_589186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589186, url, valid)

proc call*(call_589187: Call_BloggerPageViewsGet_589174; blogId: string;
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
  var path_589188 = newJObject()
  var query_589189 = newJObject()
  add(query_589189, "fields", newJString(fields))
  add(query_589189, "quotaUser", newJString(quotaUser))
  add(query_589189, "alt", newJString(alt))
  if range != nil:
    query_589189.add "range", range
  add(query_589189, "oauth_token", newJString(oauthToken))
  add(query_589189, "userIp", newJString(userIp))
  add(query_589189, "key", newJString(key))
  add(path_589188, "blogId", newJString(blogId))
  add(query_589189, "prettyPrint", newJBool(prettyPrint))
  result = call_589187.call(path_589188, query_589189, nil, nil, nil)

var bloggerPageViewsGet* = Call_BloggerPageViewsGet_589174(
    name: "bloggerPageViewsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/blogs/{blogId}/pageviews",
    validator: validate_BloggerPageViewsGet_589175, base: "/blogger/v3",
    url: url_BloggerPageViewsGet_589176, schemes: {Scheme.Https})
type
  Call_BloggerPostsInsert_589215 = ref object of OpenApiRestCall_588441
proc url_BloggerPostsInsert_589217(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerPostsInsert_589216(path: JsonNode; query: JsonNode;
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
  var valid_589218 = path.getOrDefault("blogId")
  valid_589218 = validateParameter(valid_589218, JString, required = true,
                                 default = nil)
  if valid_589218 != nil:
    section.add "blogId", valid_589218
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
  var valid_589219 = query.getOrDefault("fetchBody")
  valid_589219 = validateParameter(valid_589219, JBool, required = false,
                                 default = newJBool(true))
  if valid_589219 != nil:
    section.add "fetchBody", valid_589219
  var valid_589220 = query.getOrDefault("fields")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = nil)
  if valid_589220 != nil:
    section.add "fields", valid_589220
  var valid_589221 = query.getOrDefault("quotaUser")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = nil)
  if valid_589221 != nil:
    section.add "quotaUser", valid_589221
  var valid_589222 = query.getOrDefault("fetchImages")
  valid_589222 = validateParameter(valid_589222, JBool, required = false, default = nil)
  if valid_589222 != nil:
    section.add "fetchImages", valid_589222
  var valid_589223 = query.getOrDefault("alt")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = newJString("json"))
  if valid_589223 != nil:
    section.add "alt", valid_589223
  var valid_589224 = query.getOrDefault("oauth_token")
  valid_589224 = validateParameter(valid_589224, JString, required = false,
                                 default = nil)
  if valid_589224 != nil:
    section.add "oauth_token", valid_589224
  var valid_589225 = query.getOrDefault("isDraft")
  valid_589225 = validateParameter(valid_589225, JBool, required = false, default = nil)
  if valid_589225 != nil:
    section.add "isDraft", valid_589225
  var valid_589226 = query.getOrDefault("userIp")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = nil)
  if valid_589226 != nil:
    section.add "userIp", valid_589226
  var valid_589227 = query.getOrDefault("key")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = nil)
  if valid_589227 != nil:
    section.add "key", valid_589227
  var valid_589228 = query.getOrDefault("prettyPrint")
  valid_589228 = validateParameter(valid_589228, JBool, required = false,
                                 default = newJBool(true))
  if valid_589228 != nil:
    section.add "prettyPrint", valid_589228
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

proc call*(call_589230: Call_BloggerPostsInsert_589215; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a post.
  ## 
  let valid = call_589230.validator(path, query, header, formData, body)
  let scheme = call_589230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589230.url(scheme.get, call_589230.host, call_589230.base,
                         call_589230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589230, url, valid)

proc call*(call_589231: Call_BloggerPostsInsert_589215; blogId: string;
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
  var path_589232 = newJObject()
  var query_589233 = newJObject()
  var body_589234 = newJObject()
  add(query_589233, "fetchBody", newJBool(fetchBody))
  add(query_589233, "fields", newJString(fields))
  add(query_589233, "quotaUser", newJString(quotaUser))
  add(query_589233, "fetchImages", newJBool(fetchImages))
  add(query_589233, "alt", newJString(alt))
  add(query_589233, "oauth_token", newJString(oauthToken))
  add(query_589233, "isDraft", newJBool(isDraft))
  add(query_589233, "userIp", newJString(userIp))
  add(query_589233, "key", newJString(key))
  add(path_589232, "blogId", newJString(blogId))
  if body != nil:
    body_589234 = body
  add(query_589233, "prettyPrint", newJBool(prettyPrint))
  result = call_589231.call(path_589232, query_589233, nil, nil, body_589234)

var bloggerPostsInsert* = Call_BloggerPostsInsert_589215(
    name: "bloggerPostsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/blogs/{blogId}/posts",
    validator: validate_BloggerPostsInsert_589216, base: "/blogger/v3",
    url: url_BloggerPostsInsert_589217, schemes: {Scheme.Https})
type
  Call_BloggerPostsList_589190 = ref object of OpenApiRestCall_588441
proc url_BloggerPostsList_589192(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerPostsList_589191(path: JsonNode; query: JsonNode;
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
  var valid_589193 = path.getOrDefault("blogId")
  valid_589193 = validateParameter(valid_589193, JString, required = true,
                                 default = nil)
  if valid_589193 != nil:
    section.add "blogId", valid_589193
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
  var valid_589194 = query.getOrDefault("fields")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = nil)
  if valid_589194 != nil:
    section.add "fields", valid_589194
  var valid_589195 = query.getOrDefault("pageToken")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = nil)
  if valid_589195 != nil:
    section.add "pageToken", valid_589195
  var valid_589196 = query.getOrDefault("quotaUser")
  valid_589196 = validateParameter(valid_589196, JString, required = false,
                                 default = nil)
  if valid_589196 != nil:
    section.add "quotaUser", valid_589196
  var valid_589197 = query.getOrDefault("view")
  valid_589197 = validateParameter(valid_589197, JString, required = false,
                                 default = newJString("ADMIN"))
  if valid_589197 != nil:
    section.add "view", valid_589197
  var valid_589198 = query.getOrDefault("fetchImages")
  valid_589198 = validateParameter(valid_589198, JBool, required = false, default = nil)
  if valid_589198 != nil:
    section.add "fetchImages", valid_589198
  var valid_589199 = query.getOrDefault("alt")
  valid_589199 = validateParameter(valid_589199, JString, required = false,
                                 default = newJString("json"))
  if valid_589199 != nil:
    section.add "alt", valid_589199
  var valid_589200 = query.getOrDefault("endDate")
  valid_589200 = validateParameter(valid_589200, JString, required = false,
                                 default = nil)
  if valid_589200 != nil:
    section.add "endDate", valid_589200
  var valid_589201 = query.getOrDefault("startDate")
  valid_589201 = validateParameter(valid_589201, JString, required = false,
                                 default = nil)
  if valid_589201 != nil:
    section.add "startDate", valid_589201
  var valid_589202 = query.getOrDefault("oauth_token")
  valid_589202 = validateParameter(valid_589202, JString, required = false,
                                 default = nil)
  if valid_589202 != nil:
    section.add "oauth_token", valid_589202
  var valid_589203 = query.getOrDefault("userIp")
  valid_589203 = validateParameter(valid_589203, JString, required = false,
                                 default = nil)
  if valid_589203 != nil:
    section.add "userIp", valid_589203
  var valid_589204 = query.getOrDefault("maxResults")
  valid_589204 = validateParameter(valid_589204, JInt, required = false, default = nil)
  if valid_589204 != nil:
    section.add "maxResults", valid_589204
  var valid_589205 = query.getOrDefault("orderBy")
  valid_589205 = validateParameter(valid_589205, JString, required = false,
                                 default = newJString("published"))
  if valid_589205 != nil:
    section.add "orderBy", valid_589205
  var valid_589206 = query.getOrDefault("key")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = nil)
  if valid_589206 != nil:
    section.add "key", valid_589206
  var valid_589207 = query.getOrDefault("labels")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = nil)
  if valid_589207 != nil:
    section.add "labels", valid_589207
  var valid_589208 = query.getOrDefault("status")
  valid_589208 = validateParameter(valid_589208, JArray, required = false,
                                 default = nil)
  if valid_589208 != nil:
    section.add "status", valid_589208
  var valid_589209 = query.getOrDefault("fetchBodies")
  valid_589209 = validateParameter(valid_589209, JBool, required = false,
                                 default = newJBool(true))
  if valid_589209 != nil:
    section.add "fetchBodies", valid_589209
  var valid_589210 = query.getOrDefault("prettyPrint")
  valid_589210 = validateParameter(valid_589210, JBool, required = false,
                                 default = newJBool(true))
  if valid_589210 != nil:
    section.add "prettyPrint", valid_589210
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589211: Call_BloggerPostsList_589190; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of posts, possibly filtered.
  ## 
  let valid = call_589211.validator(path, query, header, formData, body)
  let scheme = call_589211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589211.url(scheme.get, call_589211.host, call_589211.base,
                         call_589211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589211, url, valid)

proc call*(call_589212: Call_BloggerPostsList_589190; blogId: string;
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
  var path_589213 = newJObject()
  var query_589214 = newJObject()
  add(query_589214, "fields", newJString(fields))
  add(query_589214, "pageToken", newJString(pageToken))
  add(query_589214, "quotaUser", newJString(quotaUser))
  add(query_589214, "view", newJString(view))
  add(query_589214, "fetchImages", newJBool(fetchImages))
  add(query_589214, "alt", newJString(alt))
  add(query_589214, "endDate", newJString(endDate))
  add(query_589214, "startDate", newJString(startDate))
  add(query_589214, "oauth_token", newJString(oauthToken))
  add(query_589214, "userIp", newJString(userIp))
  add(query_589214, "maxResults", newJInt(maxResults))
  add(query_589214, "orderBy", newJString(orderBy))
  add(query_589214, "key", newJString(key))
  add(query_589214, "labels", newJString(labels))
  if status != nil:
    query_589214.add "status", status
  add(query_589214, "fetchBodies", newJBool(fetchBodies))
  add(path_589213, "blogId", newJString(blogId))
  add(query_589214, "prettyPrint", newJBool(prettyPrint))
  result = call_589212.call(path_589213, query_589214, nil, nil, nil)

var bloggerPostsList* = Call_BloggerPostsList_589190(name: "bloggerPostsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/blogs/{blogId}/posts", validator: validate_BloggerPostsList_589191,
    base: "/blogger/v3", url: url_BloggerPostsList_589192, schemes: {Scheme.Https})
type
  Call_BloggerPostsGetByPath_589235 = ref object of OpenApiRestCall_588441
proc url_BloggerPostsGetByPath_589237(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerPostsGetByPath_589236(path: JsonNode; query: JsonNode;
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
  var valid_589238 = path.getOrDefault("blogId")
  valid_589238 = validateParameter(valid_589238, JString, required = true,
                                 default = nil)
  if valid_589238 != nil:
    section.add "blogId", valid_589238
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
  var valid_589239 = query.getOrDefault("fields")
  valid_589239 = validateParameter(valid_589239, JString, required = false,
                                 default = nil)
  if valid_589239 != nil:
    section.add "fields", valid_589239
  var valid_589240 = query.getOrDefault("view")
  valid_589240 = validateParameter(valid_589240, JString, required = false,
                                 default = newJString("ADMIN"))
  if valid_589240 != nil:
    section.add "view", valid_589240
  var valid_589241 = query.getOrDefault("quotaUser")
  valid_589241 = validateParameter(valid_589241, JString, required = false,
                                 default = nil)
  if valid_589241 != nil:
    section.add "quotaUser", valid_589241
  var valid_589242 = query.getOrDefault("alt")
  valid_589242 = validateParameter(valid_589242, JString, required = false,
                                 default = newJString("json"))
  if valid_589242 != nil:
    section.add "alt", valid_589242
  var valid_589243 = query.getOrDefault("oauth_token")
  valid_589243 = validateParameter(valid_589243, JString, required = false,
                                 default = nil)
  if valid_589243 != nil:
    section.add "oauth_token", valid_589243
  var valid_589244 = query.getOrDefault("userIp")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = nil)
  if valid_589244 != nil:
    section.add "userIp", valid_589244
  var valid_589245 = query.getOrDefault("maxComments")
  valid_589245 = validateParameter(valid_589245, JInt, required = false, default = nil)
  if valid_589245 != nil:
    section.add "maxComments", valid_589245
  assert query != nil, "query argument is necessary due to required `path` field"
  var valid_589246 = query.getOrDefault("path")
  valid_589246 = validateParameter(valid_589246, JString, required = true,
                                 default = nil)
  if valid_589246 != nil:
    section.add "path", valid_589246
  var valid_589247 = query.getOrDefault("key")
  valid_589247 = validateParameter(valid_589247, JString, required = false,
                                 default = nil)
  if valid_589247 != nil:
    section.add "key", valid_589247
  var valid_589248 = query.getOrDefault("prettyPrint")
  valid_589248 = validateParameter(valid_589248, JBool, required = false,
                                 default = newJBool(true))
  if valid_589248 != nil:
    section.add "prettyPrint", valid_589248
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589249: Call_BloggerPostsGetByPath_589235; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a Post by Path.
  ## 
  let valid = call_589249.validator(path, query, header, formData, body)
  let scheme = call_589249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589249.url(scheme.get, call_589249.host, call_589249.base,
                         call_589249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589249, url, valid)

proc call*(call_589250: Call_BloggerPostsGetByPath_589235; path: string;
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
  var path_589251 = newJObject()
  var query_589252 = newJObject()
  add(query_589252, "fields", newJString(fields))
  add(query_589252, "view", newJString(view))
  add(query_589252, "quotaUser", newJString(quotaUser))
  add(query_589252, "alt", newJString(alt))
  add(query_589252, "oauth_token", newJString(oauthToken))
  add(query_589252, "userIp", newJString(userIp))
  add(query_589252, "maxComments", newJInt(maxComments))
  add(query_589252, "path", newJString(path))
  add(query_589252, "key", newJString(key))
  add(path_589251, "blogId", newJString(blogId))
  add(query_589252, "prettyPrint", newJBool(prettyPrint))
  result = call_589250.call(path_589251, query_589252, nil, nil, nil)

var bloggerPostsGetByPath* = Call_BloggerPostsGetByPath_589235(
    name: "bloggerPostsGetByPath", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/blogs/{blogId}/posts/bypath",
    validator: validate_BloggerPostsGetByPath_589236, base: "/blogger/v3",
    url: url_BloggerPostsGetByPath_589237, schemes: {Scheme.Https})
type
  Call_BloggerPostsSearch_589253 = ref object of OpenApiRestCall_588441
proc url_BloggerPostsSearch_589255(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerPostsSearch_589254(path: JsonNode; query: JsonNode;
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
  var valid_589256 = path.getOrDefault("blogId")
  valid_589256 = validateParameter(valid_589256, JString, required = true,
                                 default = nil)
  if valid_589256 != nil:
    section.add "blogId", valid_589256
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
  var valid_589257 = query.getOrDefault("fields")
  valid_589257 = validateParameter(valid_589257, JString, required = false,
                                 default = nil)
  if valid_589257 != nil:
    section.add "fields", valid_589257
  var valid_589258 = query.getOrDefault("quotaUser")
  valid_589258 = validateParameter(valid_589258, JString, required = false,
                                 default = nil)
  if valid_589258 != nil:
    section.add "quotaUser", valid_589258
  var valid_589259 = query.getOrDefault("alt")
  valid_589259 = validateParameter(valid_589259, JString, required = false,
                                 default = newJString("json"))
  if valid_589259 != nil:
    section.add "alt", valid_589259
  var valid_589260 = query.getOrDefault("oauth_token")
  valid_589260 = validateParameter(valid_589260, JString, required = false,
                                 default = nil)
  if valid_589260 != nil:
    section.add "oauth_token", valid_589260
  var valid_589261 = query.getOrDefault("userIp")
  valid_589261 = validateParameter(valid_589261, JString, required = false,
                                 default = nil)
  if valid_589261 != nil:
    section.add "userIp", valid_589261
  var valid_589262 = query.getOrDefault("orderBy")
  valid_589262 = validateParameter(valid_589262, JString, required = false,
                                 default = newJString("published"))
  if valid_589262 != nil:
    section.add "orderBy", valid_589262
  assert query != nil, "query argument is necessary due to required `q` field"
  var valid_589263 = query.getOrDefault("q")
  valid_589263 = validateParameter(valid_589263, JString, required = true,
                                 default = nil)
  if valid_589263 != nil:
    section.add "q", valid_589263
  var valid_589264 = query.getOrDefault("key")
  valid_589264 = validateParameter(valid_589264, JString, required = false,
                                 default = nil)
  if valid_589264 != nil:
    section.add "key", valid_589264
  var valid_589265 = query.getOrDefault("fetchBodies")
  valid_589265 = validateParameter(valid_589265, JBool, required = false,
                                 default = newJBool(true))
  if valid_589265 != nil:
    section.add "fetchBodies", valid_589265
  var valid_589266 = query.getOrDefault("prettyPrint")
  valid_589266 = validateParameter(valid_589266, JBool, required = false,
                                 default = newJBool(true))
  if valid_589266 != nil:
    section.add "prettyPrint", valid_589266
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589267: Call_BloggerPostsSearch_589253; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Search for a post.
  ## 
  let valid = call_589267.validator(path, query, header, formData, body)
  let scheme = call_589267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589267.url(scheme.get, call_589267.host, call_589267.base,
                         call_589267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589267, url, valid)

proc call*(call_589268: Call_BloggerPostsSearch_589253; q: string; blogId: string;
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
  var path_589269 = newJObject()
  var query_589270 = newJObject()
  add(query_589270, "fields", newJString(fields))
  add(query_589270, "quotaUser", newJString(quotaUser))
  add(query_589270, "alt", newJString(alt))
  add(query_589270, "oauth_token", newJString(oauthToken))
  add(query_589270, "userIp", newJString(userIp))
  add(query_589270, "orderBy", newJString(orderBy))
  add(query_589270, "q", newJString(q))
  add(query_589270, "key", newJString(key))
  add(query_589270, "fetchBodies", newJBool(fetchBodies))
  add(path_589269, "blogId", newJString(blogId))
  add(query_589270, "prettyPrint", newJBool(prettyPrint))
  result = call_589268.call(path_589269, query_589270, nil, nil, nil)

var bloggerPostsSearch* = Call_BloggerPostsSearch_589253(
    name: "bloggerPostsSearch", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/blogs/{blogId}/posts/search",
    validator: validate_BloggerPostsSearch_589254, base: "/blogger/v3",
    url: url_BloggerPostsSearch_589255, schemes: {Scheme.Https})
type
  Call_BloggerPostsUpdate_589291 = ref object of OpenApiRestCall_588441
proc url_BloggerPostsUpdate_589293(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerPostsUpdate_589292(path: JsonNode; query: JsonNode;
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
  var valid_589294 = path.getOrDefault("postId")
  valid_589294 = validateParameter(valid_589294, JString, required = true,
                                 default = nil)
  if valid_589294 != nil:
    section.add "postId", valid_589294
  var valid_589295 = path.getOrDefault("blogId")
  valid_589295 = validateParameter(valid_589295, JString, required = true,
                                 default = nil)
  if valid_589295 != nil:
    section.add "blogId", valid_589295
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
  var valid_589296 = query.getOrDefault("revert")
  valid_589296 = validateParameter(valid_589296, JBool, required = false, default = nil)
  if valid_589296 != nil:
    section.add "revert", valid_589296
  var valid_589297 = query.getOrDefault("fetchBody")
  valid_589297 = validateParameter(valid_589297, JBool, required = false,
                                 default = newJBool(true))
  if valid_589297 != nil:
    section.add "fetchBody", valid_589297
  var valid_589298 = query.getOrDefault("fields")
  valid_589298 = validateParameter(valid_589298, JString, required = false,
                                 default = nil)
  if valid_589298 != nil:
    section.add "fields", valid_589298
  var valid_589299 = query.getOrDefault("quotaUser")
  valid_589299 = validateParameter(valid_589299, JString, required = false,
                                 default = nil)
  if valid_589299 != nil:
    section.add "quotaUser", valid_589299
  var valid_589300 = query.getOrDefault("fetchImages")
  valid_589300 = validateParameter(valid_589300, JBool, required = false, default = nil)
  if valid_589300 != nil:
    section.add "fetchImages", valid_589300
  var valid_589301 = query.getOrDefault("alt")
  valid_589301 = validateParameter(valid_589301, JString, required = false,
                                 default = newJString("json"))
  if valid_589301 != nil:
    section.add "alt", valid_589301
  var valid_589302 = query.getOrDefault("oauth_token")
  valid_589302 = validateParameter(valid_589302, JString, required = false,
                                 default = nil)
  if valid_589302 != nil:
    section.add "oauth_token", valid_589302
  var valid_589303 = query.getOrDefault("userIp")
  valid_589303 = validateParameter(valid_589303, JString, required = false,
                                 default = nil)
  if valid_589303 != nil:
    section.add "userIp", valid_589303
  var valid_589304 = query.getOrDefault("maxComments")
  valid_589304 = validateParameter(valid_589304, JInt, required = false, default = nil)
  if valid_589304 != nil:
    section.add "maxComments", valid_589304
  var valid_589305 = query.getOrDefault("key")
  valid_589305 = validateParameter(valid_589305, JString, required = false,
                                 default = nil)
  if valid_589305 != nil:
    section.add "key", valid_589305
  var valid_589306 = query.getOrDefault("publish")
  valid_589306 = validateParameter(valid_589306, JBool, required = false, default = nil)
  if valid_589306 != nil:
    section.add "publish", valid_589306
  var valid_589307 = query.getOrDefault("prettyPrint")
  valid_589307 = validateParameter(valid_589307, JBool, required = false,
                                 default = newJBool(true))
  if valid_589307 != nil:
    section.add "prettyPrint", valid_589307
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

proc call*(call_589309: Call_BloggerPostsUpdate_589291; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a post.
  ## 
  let valid = call_589309.validator(path, query, header, formData, body)
  let scheme = call_589309.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589309.url(scheme.get, call_589309.host, call_589309.base,
                         call_589309.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589309, url, valid)

proc call*(call_589310: Call_BloggerPostsUpdate_589291; postId: string;
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
  var path_589311 = newJObject()
  var query_589312 = newJObject()
  var body_589313 = newJObject()
  add(query_589312, "revert", newJBool(revert))
  add(query_589312, "fetchBody", newJBool(fetchBody))
  add(query_589312, "fields", newJString(fields))
  add(query_589312, "quotaUser", newJString(quotaUser))
  add(query_589312, "fetchImages", newJBool(fetchImages))
  add(query_589312, "alt", newJString(alt))
  add(query_589312, "oauth_token", newJString(oauthToken))
  add(query_589312, "userIp", newJString(userIp))
  add(query_589312, "maxComments", newJInt(maxComments))
  add(query_589312, "key", newJString(key))
  add(path_589311, "postId", newJString(postId))
  add(query_589312, "publish", newJBool(publish))
  add(path_589311, "blogId", newJString(blogId))
  if body != nil:
    body_589313 = body
  add(query_589312, "prettyPrint", newJBool(prettyPrint))
  result = call_589310.call(path_589311, query_589312, nil, nil, body_589313)

var bloggerPostsUpdate* = Call_BloggerPostsUpdate_589291(
    name: "bloggerPostsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/blogs/{blogId}/posts/{postId}",
    validator: validate_BloggerPostsUpdate_589292, base: "/blogger/v3",
    url: url_BloggerPostsUpdate_589293, schemes: {Scheme.Https})
type
  Call_BloggerPostsGet_589271 = ref object of OpenApiRestCall_588441
proc url_BloggerPostsGet_589273(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerPostsGet_589272(path: JsonNode; query: JsonNode;
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
  var valid_589274 = path.getOrDefault("postId")
  valid_589274 = validateParameter(valid_589274, JString, required = true,
                                 default = nil)
  if valid_589274 != nil:
    section.add "postId", valid_589274
  var valid_589275 = path.getOrDefault("blogId")
  valid_589275 = validateParameter(valid_589275, JString, required = true,
                                 default = nil)
  if valid_589275 != nil:
    section.add "blogId", valid_589275
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
  var valid_589276 = query.getOrDefault("fetchBody")
  valid_589276 = validateParameter(valid_589276, JBool, required = false,
                                 default = newJBool(true))
  if valid_589276 != nil:
    section.add "fetchBody", valid_589276
  var valid_589277 = query.getOrDefault("fields")
  valid_589277 = validateParameter(valid_589277, JString, required = false,
                                 default = nil)
  if valid_589277 != nil:
    section.add "fields", valid_589277
  var valid_589278 = query.getOrDefault("view")
  valid_589278 = validateParameter(valid_589278, JString, required = false,
                                 default = newJString("ADMIN"))
  if valid_589278 != nil:
    section.add "view", valid_589278
  var valid_589279 = query.getOrDefault("quotaUser")
  valid_589279 = validateParameter(valid_589279, JString, required = false,
                                 default = nil)
  if valid_589279 != nil:
    section.add "quotaUser", valid_589279
  var valid_589280 = query.getOrDefault("fetchImages")
  valid_589280 = validateParameter(valid_589280, JBool, required = false, default = nil)
  if valid_589280 != nil:
    section.add "fetchImages", valid_589280
  var valid_589281 = query.getOrDefault("alt")
  valid_589281 = validateParameter(valid_589281, JString, required = false,
                                 default = newJString("json"))
  if valid_589281 != nil:
    section.add "alt", valid_589281
  var valid_589282 = query.getOrDefault("oauth_token")
  valid_589282 = validateParameter(valid_589282, JString, required = false,
                                 default = nil)
  if valid_589282 != nil:
    section.add "oauth_token", valid_589282
  var valid_589283 = query.getOrDefault("userIp")
  valid_589283 = validateParameter(valid_589283, JString, required = false,
                                 default = nil)
  if valid_589283 != nil:
    section.add "userIp", valid_589283
  var valid_589284 = query.getOrDefault("maxComments")
  valid_589284 = validateParameter(valid_589284, JInt, required = false, default = nil)
  if valid_589284 != nil:
    section.add "maxComments", valid_589284
  var valid_589285 = query.getOrDefault("key")
  valid_589285 = validateParameter(valid_589285, JString, required = false,
                                 default = nil)
  if valid_589285 != nil:
    section.add "key", valid_589285
  var valid_589286 = query.getOrDefault("prettyPrint")
  valid_589286 = validateParameter(valid_589286, JBool, required = false,
                                 default = newJBool(true))
  if valid_589286 != nil:
    section.add "prettyPrint", valid_589286
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589287: Call_BloggerPostsGet_589271; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a post by ID.
  ## 
  let valid = call_589287.validator(path, query, header, formData, body)
  let scheme = call_589287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589287.url(scheme.get, call_589287.host, call_589287.base,
                         call_589287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589287, url, valid)

proc call*(call_589288: Call_BloggerPostsGet_589271; postId: string; blogId: string;
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
  var path_589289 = newJObject()
  var query_589290 = newJObject()
  add(query_589290, "fetchBody", newJBool(fetchBody))
  add(query_589290, "fields", newJString(fields))
  add(query_589290, "view", newJString(view))
  add(query_589290, "quotaUser", newJString(quotaUser))
  add(query_589290, "fetchImages", newJBool(fetchImages))
  add(query_589290, "alt", newJString(alt))
  add(query_589290, "oauth_token", newJString(oauthToken))
  add(query_589290, "userIp", newJString(userIp))
  add(query_589290, "maxComments", newJInt(maxComments))
  add(query_589290, "key", newJString(key))
  add(path_589289, "postId", newJString(postId))
  add(path_589289, "blogId", newJString(blogId))
  add(query_589290, "prettyPrint", newJBool(prettyPrint))
  result = call_589288.call(path_589289, query_589290, nil, nil, nil)

var bloggerPostsGet* = Call_BloggerPostsGet_589271(name: "bloggerPostsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/blogs/{blogId}/posts/{postId}", validator: validate_BloggerPostsGet_589272,
    base: "/blogger/v3", url: url_BloggerPostsGet_589273, schemes: {Scheme.Https})
type
  Call_BloggerPostsPatch_589330 = ref object of OpenApiRestCall_588441
proc url_BloggerPostsPatch_589332(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerPostsPatch_589331(path: JsonNode; query: JsonNode;
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
  var valid_589333 = path.getOrDefault("postId")
  valid_589333 = validateParameter(valid_589333, JString, required = true,
                                 default = nil)
  if valid_589333 != nil:
    section.add "postId", valid_589333
  var valid_589334 = path.getOrDefault("blogId")
  valid_589334 = validateParameter(valid_589334, JString, required = true,
                                 default = nil)
  if valid_589334 != nil:
    section.add "blogId", valid_589334
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
  var valid_589335 = query.getOrDefault("revert")
  valid_589335 = validateParameter(valid_589335, JBool, required = false, default = nil)
  if valid_589335 != nil:
    section.add "revert", valid_589335
  var valid_589336 = query.getOrDefault("fetchBody")
  valid_589336 = validateParameter(valid_589336, JBool, required = false,
                                 default = newJBool(true))
  if valid_589336 != nil:
    section.add "fetchBody", valid_589336
  var valid_589337 = query.getOrDefault("fields")
  valid_589337 = validateParameter(valid_589337, JString, required = false,
                                 default = nil)
  if valid_589337 != nil:
    section.add "fields", valid_589337
  var valid_589338 = query.getOrDefault("quotaUser")
  valid_589338 = validateParameter(valid_589338, JString, required = false,
                                 default = nil)
  if valid_589338 != nil:
    section.add "quotaUser", valid_589338
  var valid_589339 = query.getOrDefault("fetchImages")
  valid_589339 = validateParameter(valid_589339, JBool, required = false, default = nil)
  if valid_589339 != nil:
    section.add "fetchImages", valid_589339
  var valid_589340 = query.getOrDefault("alt")
  valid_589340 = validateParameter(valid_589340, JString, required = false,
                                 default = newJString("json"))
  if valid_589340 != nil:
    section.add "alt", valid_589340
  var valid_589341 = query.getOrDefault("oauth_token")
  valid_589341 = validateParameter(valid_589341, JString, required = false,
                                 default = nil)
  if valid_589341 != nil:
    section.add "oauth_token", valid_589341
  var valid_589342 = query.getOrDefault("userIp")
  valid_589342 = validateParameter(valid_589342, JString, required = false,
                                 default = nil)
  if valid_589342 != nil:
    section.add "userIp", valid_589342
  var valid_589343 = query.getOrDefault("maxComments")
  valid_589343 = validateParameter(valid_589343, JInt, required = false, default = nil)
  if valid_589343 != nil:
    section.add "maxComments", valid_589343
  var valid_589344 = query.getOrDefault("key")
  valid_589344 = validateParameter(valid_589344, JString, required = false,
                                 default = nil)
  if valid_589344 != nil:
    section.add "key", valid_589344
  var valid_589345 = query.getOrDefault("publish")
  valid_589345 = validateParameter(valid_589345, JBool, required = false, default = nil)
  if valid_589345 != nil:
    section.add "publish", valid_589345
  var valid_589346 = query.getOrDefault("prettyPrint")
  valid_589346 = validateParameter(valid_589346, JBool, required = false,
                                 default = newJBool(true))
  if valid_589346 != nil:
    section.add "prettyPrint", valid_589346
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

proc call*(call_589348: Call_BloggerPostsPatch_589330; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a post. This method supports patch semantics.
  ## 
  let valid = call_589348.validator(path, query, header, formData, body)
  let scheme = call_589348.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589348.url(scheme.get, call_589348.host, call_589348.base,
                         call_589348.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589348, url, valid)

proc call*(call_589349: Call_BloggerPostsPatch_589330; postId: string;
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
  var path_589350 = newJObject()
  var query_589351 = newJObject()
  var body_589352 = newJObject()
  add(query_589351, "revert", newJBool(revert))
  add(query_589351, "fetchBody", newJBool(fetchBody))
  add(query_589351, "fields", newJString(fields))
  add(query_589351, "quotaUser", newJString(quotaUser))
  add(query_589351, "fetchImages", newJBool(fetchImages))
  add(query_589351, "alt", newJString(alt))
  add(query_589351, "oauth_token", newJString(oauthToken))
  add(query_589351, "userIp", newJString(userIp))
  add(query_589351, "maxComments", newJInt(maxComments))
  add(query_589351, "key", newJString(key))
  add(path_589350, "postId", newJString(postId))
  add(query_589351, "publish", newJBool(publish))
  add(path_589350, "blogId", newJString(blogId))
  if body != nil:
    body_589352 = body
  add(query_589351, "prettyPrint", newJBool(prettyPrint))
  result = call_589349.call(path_589350, query_589351, nil, nil, body_589352)

var bloggerPostsPatch* = Call_BloggerPostsPatch_589330(name: "bloggerPostsPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com",
    route: "/blogs/{blogId}/posts/{postId}",
    validator: validate_BloggerPostsPatch_589331, base: "/blogger/v3",
    url: url_BloggerPostsPatch_589332, schemes: {Scheme.Https})
type
  Call_BloggerPostsDelete_589314 = ref object of OpenApiRestCall_588441
proc url_BloggerPostsDelete_589316(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerPostsDelete_589315(path: JsonNode; query: JsonNode;
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
  var valid_589317 = path.getOrDefault("postId")
  valid_589317 = validateParameter(valid_589317, JString, required = true,
                                 default = nil)
  if valid_589317 != nil:
    section.add "postId", valid_589317
  var valid_589318 = path.getOrDefault("blogId")
  valid_589318 = validateParameter(valid_589318, JString, required = true,
                                 default = nil)
  if valid_589318 != nil:
    section.add "blogId", valid_589318
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
  var valid_589319 = query.getOrDefault("fields")
  valid_589319 = validateParameter(valid_589319, JString, required = false,
                                 default = nil)
  if valid_589319 != nil:
    section.add "fields", valid_589319
  var valid_589320 = query.getOrDefault("quotaUser")
  valid_589320 = validateParameter(valid_589320, JString, required = false,
                                 default = nil)
  if valid_589320 != nil:
    section.add "quotaUser", valid_589320
  var valid_589321 = query.getOrDefault("alt")
  valid_589321 = validateParameter(valid_589321, JString, required = false,
                                 default = newJString("json"))
  if valid_589321 != nil:
    section.add "alt", valid_589321
  var valid_589322 = query.getOrDefault("oauth_token")
  valid_589322 = validateParameter(valid_589322, JString, required = false,
                                 default = nil)
  if valid_589322 != nil:
    section.add "oauth_token", valid_589322
  var valid_589323 = query.getOrDefault("userIp")
  valid_589323 = validateParameter(valid_589323, JString, required = false,
                                 default = nil)
  if valid_589323 != nil:
    section.add "userIp", valid_589323
  var valid_589324 = query.getOrDefault("key")
  valid_589324 = validateParameter(valid_589324, JString, required = false,
                                 default = nil)
  if valid_589324 != nil:
    section.add "key", valid_589324
  var valid_589325 = query.getOrDefault("prettyPrint")
  valid_589325 = validateParameter(valid_589325, JBool, required = false,
                                 default = newJBool(true))
  if valid_589325 != nil:
    section.add "prettyPrint", valid_589325
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589326: Call_BloggerPostsDelete_589314; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a post by ID.
  ## 
  let valid = call_589326.validator(path, query, header, formData, body)
  let scheme = call_589326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589326.url(scheme.get, call_589326.host, call_589326.base,
                         call_589326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589326, url, valid)

proc call*(call_589327: Call_BloggerPostsDelete_589314; postId: string;
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
  var path_589328 = newJObject()
  var query_589329 = newJObject()
  add(query_589329, "fields", newJString(fields))
  add(query_589329, "quotaUser", newJString(quotaUser))
  add(query_589329, "alt", newJString(alt))
  add(query_589329, "oauth_token", newJString(oauthToken))
  add(query_589329, "userIp", newJString(userIp))
  add(query_589329, "key", newJString(key))
  add(path_589328, "postId", newJString(postId))
  add(path_589328, "blogId", newJString(blogId))
  add(query_589329, "prettyPrint", newJBool(prettyPrint))
  result = call_589327.call(path_589328, query_589329, nil, nil, nil)

var bloggerPostsDelete* = Call_BloggerPostsDelete_589314(
    name: "bloggerPostsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/blogs/{blogId}/posts/{postId}",
    validator: validate_BloggerPostsDelete_589315, base: "/blogger/v3",
    url: url_BloggerPostsDelete_589316, schemes: {Scheme.Https})
type
  Call_BloggerCommentsList_589353 = ref object of OpenApiRestCall_588441
proc url_BloggerCommentsList_589355(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerCommentsList_589354(path: JsonNode; query: JsonNode;
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
  var valid_589356 = path.getOrDefault("postId")
  valid_589356 = validateParameter(valid_589356, JString, required = true,
                                 default = nil)
  if valid_589356 != nil:
    section.add "postId", valid_589356
  var valid_589357 = path.getOrDefault("blogId")
  valid_589357 = validateParameter(valid_589357, JString, required = true,
                                 default = nil)
  if valid_589357 != nil:
    section.add "blogId", valid_589357
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
  var valid_589358 = query.getOrDefault("fields")
  valid_589358 = validateParameter(valid_589358, JString, required = false,
                                 default = nil)
  if valid_589358 != nil:
    section.add "fields", valid_589358
  var valid_589359 = query.getOrDefault("pageToken")
  valid_589359 = validateParameter(valid_589359, JString, required = false,
                                 default = nil)
  if valid_589359 != nil:
    section.add "pageToken", valid_589359
  var valid_589360 = query.getOrDefault("quotaUser")
  valid_589360 = validateParameter(valid_589360, JString, required = false,
                                 default = nil)
  if valid_589360 != nil:
    section.add "quotaUser", valid_589360
  var valid_589361 = query.getOrDefault("view")
  valid_589361 = validateParameter(valid_589361, JString, required = false,
                                 default = newJString("ADMIN"))
  if valid_589361 != nil:
    section.add "view", valid_589361
  var valid_589362 = query.getOrDefault("alt")
  valid_589362 = validateParameter(valid_589362, JString, required = false,
                                 default = newJString("json"))
  if valid_589362 != nil:
    section.add "alt", valid_589362
  var valid_589363 = query.getOrDefault("endDate")
  valid_589363 = validateParameter(valid_589363, JString, required = false,
                                 default = nil)
  if valid_589363 != nil:
    section.add "endDate", valid_589363
  var valid_589364 = query.getOrDefault("startDate")
  valid_589364 = validateParameter(valid_589364, JString, required = false,
                                 default = nil)
  if valid_589364 != nil:
    section.add "startDate", valid_589364
  var valid_589365 = query.getOrDefault("oauth_token")
  valid_589365 = validateParameter(valid_589365, JString, required = false,
                                 default = nil)
  if valid_589365 != nil:
    section.add "oauth_token", valid_589365
  var valid_589366 = query.getOrDefault("userIp")
  valid_589366 = validateParameter(valid_589366, JString, required = false,
                                 default = nil)
  if valid_589366 != nil:
    section.add "userIp", valid_589366
  var valid_589367 = query.getOrDefault("maxResults")
  valid_589367 = validateParameter(valid_589367, JInt, required = false, default = nil)
  if valid_589367 != nil:
    section.add "maxResults", valid_589367
  var valid_589368 = query.getOrDefault("key")
  valid_589368 = validateParameter(valid_589368, JString, required = false,
                                 default = nil)
  if valid_589368 != nil:
    section.add "key", valid_589368
  var valid_589369 = query.getOrDefault("status")
  valid_589369 = validateParameter(valid_589369, JArray, required = false,
                                 default = nil)
  if valid_589369 != nil:
    section.add "status", valid_589369
  var valid_589370 = query.getOrDefault("fetchBodies")
  valid_589370 = validateParameter(valid_589370, JBool, required = false, default = nil)
  if valid_589370 != nil:
    section.add "fetchBodies", valid_589370
  var valid_589371 = query.getOrDefault("prettyPrint")
  valid_589371 = validateParameter(valid_589371, JBool, required = false,
                                 default = newJBool(true))
  if valid_589371 != nil:
    section.add "prettyPrint", valid_589371
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589372: Call_BloggerCommentsList_589353; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the comments for a post, possibly filtered.
  ## 
  let valid = call_589372.validator(path, query, header, formData, body)
  let scheme = call_589372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589372.url(scheme.get, call_589372.host, call_589372.base,
                         call_589372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589372, url, valid)

proc call*(call_589373: Call_BloggerCommentsList_589353; postId: string;
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
  var path_589374 = newJObject()
  var query_589375 = newJObject()
  add(query_589375, "fields", newJString(fields))
  add(query_589375, "pageToken", newJString(pageToken))
  add(query_589375, "quotaUser", newJString(quotaUser))
  add(query_589375, "view", newJString(view))
  add(query_589375, "alt", newJString(alt))
  add(query_589375, "endDate", newJString(endDate))
  add(query_589375, "startDate", newJString(startDate))
  add(query_589375, "oauth_token", newJString(oauthToken))
  add(query_589375, "userIp", newJString(userIp))
  add(query_589375, "maxResults", newJInt(maxResults))
  add(query_589375, "key", newJString(key))
  add(path_589374, "postId", newJString(postId))
  if status != nil:
    query_589375.add "status", status
  add(query_589375, "fetchBodies", newJBool(fetchBodies))
  add(path_589374, "blogId", newJString(blogId))
  add(query_589375, "prettyPrint", newJBool(prettyPrint))
  result = call_589373.call(path_589374, query_589375, nil, nil, nil)

var bloggerCommentsList* = Call_BloggerCommentsList_589353(
    name: "bloggerCommentsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/blogs/{blogId}/posts/{postId}/comments",
    validator: validate_BloggerCommentsList_589354, base: "/blogger/v3",
    url: url_BloggerCommentsList_589355, schemes: {Scheme.Https})
type
  Call_BloggerCommentsGet_589376 = ref object of OpenApiRestCall_588441
proc url_BloggerCommentsGet_589378(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerCommentsGet_589377(path: JsonNode; query: JsonNode;
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
  var valid_589379 = path.getOrDefault("commentId")
  valid_589379 = validateParameter(valid_589379, JString, required = true,
                                 default = nil)
  if valid_589379 != nil:
    section.add "commentId", valid_589379
  var valid_589380 = path.getOrDefault("postId")
  valid_589380 = validateParameter(valid_589380, JString, required = true,
                                 default = nil)
  if valid_589380 != nil:
    section.add "postId", valid_589380
  var valid_589381 = path.getOrDefault("blogId")
  valid_589381 = validateParameter(valid_589381, JString, required = true,
                                 default = nil)
  if valid_589381 != nil:
    section.add "blogId", valid_589381
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
  var valid_589382 = query.getOrDefault("fields")
  valid_589382 = validateParameter(valid_589382, JString, required = false,
                                 default = nil)
  if valid_589382 != nil:
    section.add "fields", valid_589382
  var valid_589383 = query.getOrDefault("view")
  valid_589383 = validateParameter(valid_589383, JString, required = false,
                                 default = newJString("ADMIN"))
  if valid_589383 != nil:
    section.add "view", valid_589383
  var valid_589384 = query.getOrDefault("quotaUser")
  valid_589384 = validateParameter(valid_589384, JString, required = false,
                                 default = nil)
  if valid_589384 != nil:
    section.add "quotaUser", valid_589384
  var valid_589385 = query.getOrDefault("alt")
  valid_589385 = validateParameter(valid_589385, JString, required = false,
                                 default = newJString("json"))
  if valid_589385 != nil:
    section.add "alt", valid_589385
  var valid_589386 = query.getOrDefault("oauth_token")
  valid_589386 = validateParameter(valid_589386, JString, required = false,
                                 default = nil)
  if valid_589386 != nil:
    section.add "oauth_token", valid_589386
  var valid_589387 = query.getOrDefault("userIp")
  valid_589387 = validateParameter(valid_589387, JString, required = false,
                                 default = nil)
  if valid_589387 != nil:
    section.add "userIp", valid_589387
  var valid_589388 = query.getOrDefault("key")
  valid_589388 = validateParameter(valid_589388, JString, required = false,
                                 default = nil)
  if valid_589388 != nil:
    section.add "key", valid_589388
  var valid_589389 = query.getOrDefault("prettyPrint")
  valid_589389 = validateParameter(valid_589389, JBool, required = false,
                                 default = newJBool(true))
  if valid_589389 != nil:
    section.add "prettyPrint", valid_589389
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589390: Call_BloggerCommentsGet_589376; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one comment by ID.
  ## 
  let valid = call_589390.validator(path, query, header, formData, body)
  let scheme = call_589390.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589390.url(scheme.get, call_589390.host, call_589390.base,
                         call_589390.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589390, url, valid)

proc call*(call_589391: Call_BloggerCommentsGet_589376; commentId: string;
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
  var path_589392 = newJObject()
  var query_589393 = newJObject()
  add(query_589393, "fields", newJString(fields))
  add(query_589393, "view", newJString(view))
  add(query_589393, "quotaUser", newJString(quotaUser))
  add(query_589393, "alt", newJString(alt))
  add(query_589393, "oauth_token", newJString(oauthToken))
  add(query_589393, "userIp", newJString(userIp))
  add(query_589393, "key", newJString(key))
  add(path_589392, "commentId", newJString(commentId))
  add(path_589392, "postId", newJString(postId))
  add(path_589392, "blogId", newJString(blogId))
  add(query_589393, "prettyPrint", newJBool(prettyPrint))
  result = call_589391.call(path_589392, query_589393, nil, nil, nil)

var bloggerCommentsGet* = Call_BloggerCommentsGet_589376(
    name: "bloggerCommentsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/blogs/{blogId}/posts/{postId}/comments/{commentId}",
    validator: validate_BloggerCommentsGet_589377, base: "/blogger/v3",
    url: url_BloggerCommentsGet_589378, schemes: {Scheme.Https})
type
  Call_BloggerCommentsDelete_589394 = ref object of OpenApiRestCall_588441
proc url_BloggerCommentsDelete_589396(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerCommentsDelete_589395(path: JsonNode; query: JsonNode;
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
  var valid_589397 = path.getOrDefault("commentId")
  valid_589397 = validateParameter(valid_589397, JString, required = true,
                                 default = nil)
  if valid_589397 != nil:
    section.add "commentId", valid_589397
  var valid_589398 = path.getOrDefault("postId")
  valid_589398 = validateParameter(valid_589398, JString, required = true,
                                 default = nil)
  if valid_589398 != nil:
    section.add "postId", valid_589398
  var valid_589399 = path.getOrDefault("blogId")
  valid_589399 = validateParameter(valid_589399, JString, required = true,
                                 default = nil)
  if valid_589399 != nil:
    section.add "blogId", valid_589399
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
  var valid_589400 = query.getOrDefault("fields")
  valid_589400 = validateParameter(valid_589400, JString, required = false,
                                 default = nil)
  if valid_589400 != nil:
    section.add "fields", valid_589400
  var valid_589401 = query.getOrDefault("quotaUser")
  valid_589401 = validateParameter(valid_589401, JString, required = false,
                                 default = nil)
  if valid_589401 != nil:
    section.add "quotaUser", valid_589401
  var valid_589402 = query.getOrDefault("alt")
  valid_589402 = validateParameter(valid_589402, JString, required = false,
                                 default = newJString("json"))
  if valid_589402 != nil:
    section.add "alt", valid_589402
  var valid_589403 = query.getOrDefault("oauth_token")
  valid_589403 = validateParameter(valid_589403, JString, required = false,
                                 default = nil)
  if valid_589403 != nil:
    section.add "oauth_token", valid_589403
  var valid_589404 = query.getOrDefault("userIp")
  valid_589404 = validateParameter(valid_589404, JString, required = false,
                                 default = nil)
  if valid_589404 != nil:
    section.add "userIp", valid_589404
  var valid_589405 = query.getOrDefault("key")
  valid_589405 = validateParameter(valid_589405, JString, required = false,
                                 default = nil)
  if valid_589405 != nil:
    section.add "key", valid_589405
  var valid_589406 = query.getOrDefault("prettyPrint")
  valid_589406 = validateParameter(valid_589406, JBool, required = false,
                                 default = newJBool(true))
  if valid_589406 != nil:
    section.add "prettyPrint", valid_589406
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589407: Call_BloggerCommentsDelete_589394; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a comment by ID.
  ## 
  let valid = call_589407.validator(path, query, header, formData, body)
  let scheme = call_589407.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589407.url(scheme.get, call_589407.host, call_589407.base,
                         call_589407.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589407, url, valid)

proc call*(call_589408: Call_BloggerCommentsDelete_589394; commentId: string;
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
  var path_589409 = newJObject()
  var query_589410 = newJObject()
  add(query_589410, "fields", newJString(fields))
  add(query_589410, "quotaUser", newJString(quotaUser))
  add(query_589410, "alt", newJString(alt))
  add(query_589410, "oauth_token", newJString(oauthToken))
  add(query_589410, "userIp", newJString(userIp))
  add(query_589410, "key", newJString(key))
  add(path_589409, "commentId", newJString(commentId))
  add(path_589409, "postId", newJString(postId))
  add(path_589409, "blogId", newJString(blogId))
  add(query_589410, "prettyPrint", newJBool(prettyPrint))
  result = call_589408.call(path_589409, query_589410, nil, nil, nil)

var bloggerCommentsDelete* = Call_BloggerCommentsDelete_589394(
    name: "bloggerCommentsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/blogs/{blogId}/posts/{postId}/comments/{commentId}",
    validator: validate_BloggerCommentsDelete_589395, base: "/blogger/v3",
    url: url_BloggerCommentsDelete_589396, schemes: {Scheme.Https})
type
  Call_BloggerCommentsApprove_589411 = ref object of OpenApiRestCall_588441
proc url_BloggerCommentsApprove_589413(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerCommentsApprove_589412(path: JsonNode; query: JsonNode;
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
  var valid_589414 = path.getOrDefault("commentId")
  valid_589414 = validateParameter(valid_589414, JString, required = true,
                                 default = nil)
  if valid_589414 != nil:
    section.add "commentId", valid_589414
  var valid_589415 = path.getOrDefault("postId")
  valid_589415 = validateParameter(valid_589415, JString, required = true,
                                 default = nil)
  if valid_589415 != nil:
    section.add "postId", valid_589415
  var valid_589416 = path.getOrDefault("blogId")
  valid_589416 = validateParameter(valid_589416, JString, required = true,
                                 default = nil)
  if valid_589416 != nil:
    section.add "blogId", valid_589416
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
  var valid_589417 = query.getOrDefault("fields")
  valid_589417 = validateParameter(valid_589417, JString, required = false,
                                 default = nil)
  if valid_589417 != nil:
    section.add "fields", valid_589417
  var valid_589418 = query.getOrDefault("quotaUser")
  valid_589418 = validateParameter(valid_589418, JString, required = false,
                                 default = nil)
  if valid_589418 != nil:
    section.add "quotaUser", valid_589418
  var valid_589419 = query.getOrDefault("alt")
  valid_589419 = validateParameter(valid_589419, JString, required = false,
                                 default = newJString("json"))
  if valid_589419 != nil:
    section.add "alt", valid_589419
  var valid_589420 = query.getOrDefault("oauth_token")
  valid_589420 = validateParameter(valid_589420, JString, required = false,
                                 default = nil)
  if valid_589420 != nil:
    section.add "oauth_token", valid_589420
  var valid_589421 = query.getOrDefault("userIp")
  valid_589421 = validateParameter(valid_589421, JString, required = false,
                                 default = nil)
  if valid_589421 != nil:
    section.add "userIp", valid_589421
  var valid_589422 = query.getOrDefault("key")
  valid_589422 = validateParameter(valid_589422, JString, required = false,
                                 default = nil)
  if valid_589422 != nil:
    section.add "key", valid_589422
  var valid_589423 = query.getOrDefault("prettyPrint")
  valid_589423 = validateParameter(valid_589423, JBool, required = false,
                                 default = newJBool(true))
  if valid_589423 != nil:
    section.add "prettyPrint", valid_589423
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589424: Call_BloggerCommentsApprove_589411; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Marks a comment as not spam.
  ## 
  let valid = call_589424.validator(path, query, header, formData, body)
  let scheme = call_589424.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589424.url(scheme.get, call_589424.host, call_589424.base,
                         call_589424.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589424, url, valid)

proc call*(call_589425: Call_BloggerCommentsApprove_589411; commentId: string;
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
  var path_589426 = newJObject()
  var query_589427 = newJObject()
  add(query_589427, "fields", newJString(fields))
  add(query_589427, "quotaUser", newJString(quotaUser))
  add(query_589427, "alt", newJString(alt))
  add(query_589427, "oauth_token", newJString(oauthToken))
  add(query_589427, "userIp", newJString(userIp))
  add(query_589427, "key", newJString(key))
  add(path_589426, "commentId", newJString(commentId))
  add(path_589426, "postId", newJString(postId))
  add(path_589426, "blogId", newJString(blogId))
  add(query_589427, "prettyPrint", newJBool(prettyPrint))
  result = call_589425.call(path_589426, query_589427, nil, nil, nil)

var bloggerCommentsApprove* = Call_BloggerCommentsApprove_589411(
    name: "bloggerCommentsApprove", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/blogs/{blogId}/posts/{postId}/comments/{commentId}/approve",
    validator: validate_BloggerCommentsApprove_589412, base: "/blogger/v3",
    url: url_BloggerCommentsApprove_589413, schemes: {Scheme.Https})
type
  Call_BloggerCommentsRemoveContent_589428 = ref object of OpenApiRestCall_588441
proc url_BloggerCommentsRemoveContent_589430(protocol: Scheme; host: string;
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

proc validate_BloggerCommentsRemoveContent_589429(path: JsonNode; query: JsonNode;
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
  var valid_589431 = path.getOrDefault("commentId")
  valid_589431 = validateParameter(valid_589431, JString, required = true,
                                 default = nil)
  if valid_589431 != nil:
    section.add "commentId", valid_589431
  var valid_589432 = path.getOrDefault("postId")
  valid_589432 = validateParameter(valid_589432, JString, required = true,
                                 default = nil)
  if valid_589432 != nil:
    section.add "postId", valid_589432
  var valid_589433 = path.getOrDefault("blogId")
  valid_589433 = validateParameter(valid_589433, JString, required = true,
                                 default = nil)
  if valid_589433 != nil:
    section.add "blogId", valid_589433
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
  var valid_589434 = query.getOrDefault("fields")
  valid_589434 = validateParameter(valid_589434, JString, required = false,
                                 default = nil)
  if valid_589434 != nil:
    section.add "fields", valid_589434
  var valid_589435 = query.getOrDefault("quotaUser")
  valid_589435 = validateParameter(valid_589435, JString, required = false,
                                 default = nil)
  if valid_589435 != nil:
    section.add "quotaUser", valid_589435
  var valid_589436 = query.getOrDefault("alt")
  valid_589436 = validateParameter(valid_589436, JString, required = false,
                                 default = newJString("json"))
  if valid_589436 != nil:
    section.add "alt", valid_589436
  var valid_589437 = query.getOrDefault("oauth_token")
  valid_589437 = validateParameter(valid_589437, JString, required = false,
                                 default = nil)
  if valid_589437 != nil:
    section.add "oauth_token", valid_589437
  var valid_589438 = query.getOrDefault("userIp")
  valid_589438 = validateParameter(valid_589438, JString, required = false,
                                 default = nil)
  if valid_589438 != nil:
    section.add "userIp", valid_589438
  var valid_589439 = query.getOrDefault("key")
  valid_589439 = validateParameter(valid_589439, JString, required = false,
                                 default = nil)
  if valid_589439 != nil:
    section.add "key", valid_589439
  var valid_589440 = query.getOrDefault("prettyPrint")
  valid_589440 = validateParameter(valid_589440, JBool, required = false,
                                 default = newJBool(true))
  if valid_589440 != nil:
    section.add "prettyPrint", valid_589440
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589441: Call_BloggerCommentsRemoveContent_589428; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes the content of a comment.
  ## 
  let valid = call_589441.validator(path, query, header, formData, body)
  let scheme = call_589441.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589441.url(scheme.get, call_589441.host, call_589441.base,
                         call_589441.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589441, url, valid)

proc call*(call_589442: Call_BloggerCommentsRemoveContent_589428;
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
  var path_589443 = newJObject()
  var query_589444 = newJObject()
  add(query_589444, "fields", newJString(fields))
  add(query_589444, "quotaUser", newJString(quotaUser))
  add(query_589444, "alt", newJString(alt))
  add(query_589444, "oauth_token", newJString(oauthToken))
  add(query_589444, "userIp", newJString(userIp))
  add(query_589444, "key", newJString(key))
  add(path_589443, "commentId", newJString(commentId))
  add(path_589443, "postId", newJString(postId))
  add(path_589443, "blogId", newJString(blogId))
  add(query_589444, "prettyPrint", newJBool(prettyPrint))
  result = call_589442.call(path_589443, query_589444, nil, nil, nil)

var bloggerCommentsRemoveContent* = Call_BloggerCommentsRemoveContent_589428(
    name: "bloggerCommentsRemoveContent", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/blogs/{blogId}/posts/{postId}/comments/{commentId}/removecontent",
    validator: validate_BloggerCommentsRemoveContent_589429, base: "/blogger/v3",
    url: url_BloggerCommentsRemoveContent_589430, schemes: {Scheme.Https})
type
  Call_BloggerCommentsMarkAsSpam_589445 = ref object of OpenApiRestCall_588441
proc url_BloggerCommentsMarkAsSpam_589447(protocol: Scheme; host: string;
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

proc validate_BloggerCommentsMarkAsSpam_589446(path: JsonNode; query: JsonNode;
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
  var valid_589448 = path.getOrDefault("commentId")
  valid_589448 = validateParameter(valid_589448, JString, required = true,
                                 default = nil)
  if valid_589448 != nil:
    section.add "commentId", valid_589448
  var valid_589449 = path.getOrDefault("postId")
  valid_589449 = validateParameter(valid_589449, JString, required = true,
                                 default = nil)
  if valid_589449 != nil:
    section.add "postId", valid_589449
  var valid_589450 = path.getOrDefault("blogId")
  valid_589450 = validateParameter(valid_589450, JString, required = true,
                                 default = nil)
  if valid_589450 != nil:
    section.add "blogId", valid_589450
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
  var valid_589451 = query.getOrDefault("fields")
  valid_589451 = validateParameter(valid_589451, JString, required = false,
                                 default = nil)
  if valid_589451 != nil:
    section.add "fields", valid_589451
  var valid_589452 = query.getOrDefault("quotaUser")
  valid_589452 = validateParameter(valid_589452, JString, required = false,
                                 default = nil)
  if valid_589452 != nil:
    section.add "quotaUser", valid_589452
  var valid_589453 = query.getOrDefault("alt")
  valid_589453 = validateParameter(valid_589453, JString, required = false,
                                 default = newJString("json"))
  if valid_589453 != nil:
    section.add "alt", valid_589453
  var valid_589454 = query.getOrDefault("oauth_token")
  valid_589454 = validateParameter(valid_589454, JString, required = false,
                                 default = nil)
  if valid_589454 != nil:
    section.add "oauth_token", valid_589454
  var valid_589455 = query.getOrDefault("userIp")
  valid_589455 = validateParameter(valid_589455, JString, required = false,
                                 default = nil)
  if valid_589455 != nil:
    section.add "userIp", valid_589455
  var valid_589456 = query.getOrDefault("key")
  valid_589456 = validateParameter(valid_589456, JString, required = false,
                                 default = nil)
  if valid_589456 != nil:
    section.add "key", valid_589456
  var valid_589457 = query.getOrDefault("prettyPrint")
  valid_589457 = validateParameter(valid_589457, JBool, required = false,
                                 default = newJBool(true))
  if valid_589457 != nil:
    section.add "prettyPrint", valid_589457
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589458: Call_BloggerCommentsMarkAsSpam_589445; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Marks a comment as spam.
  ## 
  let valid = call_589458.validator(path, query, header, formData, body)
  let scheme = call_589458.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589458.url(scheme.get, call_589458.host, call_589458.base,
                         call_589458.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589458, url, valid)

proc call*(call_589459: Call_BloggerCommentsMarkAsSpam_589445; commentId: string;
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
  var path_589460 = newJObject()
  var query_589461 = newJObject()
  add(query_589461, "fields", newJString(fields))
  add(query_589461, "quotaUser", newJString(quotaUser))
  add(query_589461, "alt", newJString(alt))
  add(query_589461, "oauth_token", newJString(oauthToken))
  add(query_589461, "userIp", newJString(userIp))
  add(query_589461, "key", newJString(key))
  add(path_589460, "commentId", newJString(commentId))
  add(path_589460, "postId", newJString(postId))
  add(path_589460, "blogId", newJString(blogId))
  add(query_589461, "prettyPrint", newJBool(prettyPrint))
  result = call_589459.call(path_589460, query_589461, nil, nil, nil)

var bloggerCommentsMarkAsSpam* = Call_BloggerCommentsMarkAsSpam_589445(
    name: "bloggerCommentsMarkAsSpam", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/blogs/{blogId}/posts/{postId}/comments/{commentId}/spam",
    validator: validate_BloggerCommentsMarkAsSpam_589446, base: "/blogger/v3",
    url: url_BloggerCommentsMarkAsSpam_589447, schemes: {Scheme.Https})
type
  Call_BloggerPostsPublish_589462 = ref object of OpenApiRestCall_588441
proc url_BloggerPostsPublish_589464(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerPostsPublish_589463(path: JsonNode; query: JsonNode;
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
  var valid_589465 = path.getOrDefault("postId")
  valid_589465 = validateParameter(valid_589465, JString, required = true,
                                 default = nil)
  if valid_589465 != nil:
    section.add "postId", valid_589465
  var valid_589466 = path.getOrDefault("blogId")
  valid_589466 = validateParameter(valid_589466, JString, required = true,
                                 default = nil)
  if valid_589466 != nil:
    section.add "blogId", valid_589466
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
  var valid_589467 = query.getOrDefault("fields")
  valid_589467 = validateParameter(valid_589467, JString, required = false,
                                 default = nil)
  if valid_589467 != nil:
    section.add "fields", valid_589467
  var valid_589468 = query.getOrDefault("quotaUser")
  valid_589468 = validateParameter(valid_589468, JString, required = false,
                                 default = nil)
  if valid_589468 != nil:
    section.add "quotaUser", valid_589468
  var valid_589469 = query.getOrDefault("alt")
  valid_589469 = validateParameter(valid_589469, JString, required = false,
                                 default = newJString("json"))
  if valid_589469 != nil:
    section.add "alt", valid_589469
  var valid_589470 = query.getOrDefault("publishDate")
  valid_589470 = validateParameter(valid_589470, JString, required = false,
                                 default = nil)
  if valid_589470 != nil:
    section.add "publishDate", valid_589470
  var valid_589471 = query.getOrDefault("oauth_token")
  valid_589471 = validateParameter(valid_589471, JString, required = false,
                                 default = nil)
  if valid_589471 != nil:
    section.add "oauth_token", valid_589471
  var valid_589472 = query.getOrDefault("userIp")
  valid_589472 = validateParameter(valid_589472, JString, required = false,
                                 default = nil)
  if valid_589472 != nil:
    section.add "userIp", valid_589472
  var valid_589473 = query.getOrDefault("key")
  valid_589473 = validateParameter(valid_589473, JString, required = false,
                                 default = nil)
  if valid_589473 != nil:
    section.add "key", valid_589473
  var valid_589474 = query.getOrDefault("prettyPrint")
  valid_589474 = validateParameter(valid_589474, JBool, required = false,
                                 default = newJBool(true))
  if valid_589474 != nil:
    section.add "prettyPrint", valid_589474
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589475: Call_BloggerPostsPublish_589462; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Publishes a draft post, optionally at the specific time of the given publishDate parameter.
  ## 
  let valid = call_589475.validator(path, query, header, formData, body)
  let scheme = call_589475.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589475.url(scheme.get, call_589475.host, call_589475.base,
                         call_589475.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589475, url, valid)

proc call*(call_589476: Call_BloggerPostsPublish_589462; postId: string;
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
  var path_589477 = newJObject()
  var query_589478 = newJObject()
  add(query_589478, "fields", newJString(fields))
  add(query_589478, "quotaUser", newJString(quotaUser))
  add(query_589478, "alt", newJString(alt))
  add(query_589478, "publishDate", newJString(publishDate))
  add(query_589478, "oauth_token", newJString(oauthToken))
  add(query_589478, "userIp", newJString(userIp))
  add(query_589478, "key", newJString(key))
  add(path_589477, "postId", newJString(postId))
  add(path_589477, "blogId", newJString(blogId))
  add(query_589478, "prettyPrint", newJBool(prettyPrint))
  result = call_589476.call(path_589477, query_589478, nil, nil, nil)

var bloggerPostsPublish* = Call_BloggerPostsPublish_589462(
    name: "bloggerPostsPublish", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/blogs/{blogId}/posts/{postId}/publish",
    validator: validate_BloggerPostsPublish_589463, base: "/blogger/v3",
    url: url_BloggerPostsPublish_589464, schemes: {Scheme.Https})
type
  Call_BloggerPostsRevert_589479 = ref object of OpenApiRestCall_588441
proc url_BloggerPostsRevert_589481(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerPostsRevert_589480(path: JsonNode; query: JsonNode;
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
  var valid_589482 = path.getOrDefault("postId")
  valid_589482 = validateParameter(valid_589482, JString, required = true,
                                 default = nil)
  if valid_589482 != nil:
    section.add "postId", valid_589482
  var valid_589483 = path.getOrDefault("blogId")
  valid_589483 = validateParameter(valid_589483, JString, required = true,
                                 default = nil)
  if valid_589483 != nil:
    section.add "blogId", valid_589483
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
  var valid_589484 = query.getOrDefault("fields")
  valid_589484 = validateParameter(valid_589484, JString, required = false,
                                 default = nil)
  if valid_589484 != nil:
    section.add "fields", valid_589484
  var valid_589485 = query.getOrDefault("quotaUser")
  valid_589485 = validateParameter(valid_589485, JString, required = false,
                                 default = nil)
  if valid_589485 != nil:
    section.add "quotaUser", valid_589485
  var valid_589486 = query.getOrDefault("alt")
  valid_589486 = validateParameter(valid_589486, JString, required = false,
                                 default = newJString("json"))
  if valid_589486 != nil:
    section.add "alt", valid_589486
  var valid_589487 = query.getOrDefault("oauth_token")
  valid_589487 = validateParameter(valid_589487, JString, required = false,
                                 default = nil)
  if valid_589487 != nil:
    section.add "oauth_token", valid_589487
  var valid_589488 = query.getOrDefault("userIp")
  valid_589488 = validateParameter(valid_589488, JString, required = false,
                                 default = nil)
  if valid_589488 != nil:
    section.add "userIp", valid_589488
  var valid_589489 = query.getOrDefault("key")
  valid_589489 = validateParameter(valid_589489, JString, required = false,
                                 default = nil)
  if valid_589489 != nil:
    section.add "key", valid_589489
  var valid_589490 = query.getOrDefault("prettyPrint")
  valid_589490 = validateParameter(valid_589490, JBool, required = false,
                                 default = newJBool(true))
  if valid_589490 != nil:
    section.add "prettyPrint", valid_589490
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589491: Call_BloggerPostsRevert_589479; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Revert a published or scheduled post to draft state.
  ## 
  let valid = call_589491.validator(path, query, header, formData, body)
  let scheme = call_589491.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589491.url(scheme.get, call_589491.host, call_589491.base,
                         call_589491.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589491, url, valid)

proc call*(call_589492: Call_BloggerPostsRevert_589479; postId: string;
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
  var path_589493 = newJObject()
  var query_589494 = newJObject()
  add(query_589494, "fields", newJString(fields))
  add(query_589494, "quotaUser", newJString(quotaUser))
  add(query_589494, "alt", newJString(alt))
  add(query_589494, "oauth_token", newJString(oauthToken))
  add(query_589494, "userIp", newJString(userIp))
  add(query_589494, "key", newJString(key))
  add(path_589493, "postId", newJString(postId))
  add(path_589493, "blogId", newJString(blogId))
  add(query_589494, "prettyPrint", newJBool(prettyPrint))
  result = call_589492.call(path_589493, query_589494, nil, nil, nil)

var bloggerPostsRevert* = Call_BloggerPostsRevert_589479(
    name: "bloggerPostsRevert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/blogs/{blogId}/posts/{postId}/revert",
    validator: validate_BloggerPostsRevert_589480, base: "/blogger/v3",
    url: url_BloggerPostsRevert_589481, schemes: {Scheme.Https})
type
  Call_BloggerUsersGet_589495 = ref object of OpenApiRestCall_588441
proc url_BloggerUsersGet_589497(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerUsersGet_589496(path: JsonNode; query: JsonNode;
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
  var valid_589498 = path.getOrDefault("userId")
  valid_589498 = validateParameter(valid_589498, JString, required = true,
                                 default = nil)
  if valid_589498 != nil:
    section.add "userId", valid_589498
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
  var valid_589499 = query.getOrDefault("fields")
  valid_589499 = validateParameter(valid_589499, JString, required = false,
                                 default = nil)
  if valid_589499 != nil:
    section.add "fields", valid_589499
  var valid_589500 = query.getOrDefault("quotaUser")
  valid_589500 = validateParameter(valid_589500, JString, required = false,
                                 default = nil)
  if valid_589500 != nil:
    section.add "quotaUser", valid_589500
  var valid_589501 = query.getOrDefault("alt")
  valid_589501 = validateParameter(valid_589501, JString, required = false,
                                 default = newJString("json"))
  if valid_589501 != nil:
    section.add "alt", valid_589501
  var valid_589502 = query.getOrDefault("oauth_token")
  valid_589502 = validateParameter(valid_589502, JString, required = false,
                                 default = nil)
  if valid_589502 != nil:
    section.add "oauth_token", valid_589502
  var valid_589503 = query.getOrDefault("userIp")
  valid_589503 = validateParameter(valid_589503, JString, required = false,
                                 default = nil)
  if valid_589503 != nil:
    section.add "userIp", valid_589503
  var valid_589504 = query.getOrDefault("key")
  valid_589504 = validateParameter(valid_589504, JString, required = false,
                                 default = nil)
  if valid_589504 != nil:
    section.add "key", valid_589504
  var valid_589505 = query.getOrDefault("prettyPrint")
  valid_589505 = validateParameter(valid_589505, JBool, required = false,
                                 default = newJBool(true))
  if valid_589505 != nil:
    section.add "prettyPrint", valid_589505
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589506: Call_BloggerUsersGet_589495; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one user by ID.
  ## 
  let valid = call_589506.validator(path, query, header, formData, body)
  let scheme = call_589506.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589506.url(scheme.get, call_589506.host, call_589506.base,
                         call_589506.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589506, url, valid)

proc call*(call_589507: Call_BloggerUsersGet_589495; userId: string;
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
  var path_589508 = newJObject()
  var query_589509 = newJObject()
  add(query_589509, "fields", newJString(fields))
  add(query_589509, "quotaUser", newJString(quotaUser))
  add(query_589509, "alt", newJString(alt))
  add(query_589509, "oauth_token", newJString(oauthToken))
  add(query_589509, "userIp", newJString(userIp))
  add(query_589509, "key", newJString(key))
  add(query_589509, "prettyPrint", newJBool(prettyPrint))
  add(path_589508, "userId", newJString(userId))
  result = call_589507.call(path_589508, query_589509, nil, nil, nil)

var bloggerUsersGet* = Call_BloggerUsersGet_589495(name: "bloggerUsersGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/users/{userId}",
    validator: validate_BloggerUsersGet_589496, base: "/blogger/v3",
    url: url_BloggerUsersGet_589497, schemes: {Scheme.Https})
type
  Call_BloggerBlogsListByUser_589510 = ref object of OpenApiRestCall_588441
proc url_BloggerBlogsListByUser_589512(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerBlogsListByUser_589511(path: JsonNode; query: JsonNode;
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
  var valid_589513 = path.getOrDefault("userId")
  valid_589513 = validateParameter(valid_589513, JString, required = true,
                                 default = nil)
  if valid_589513 != nil:
    section.add "userId", valid_589513
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
  var valid_589514 = query.getOrDefault("fields")
  valid_589514 = validateParameter(valid_589514, JString, required = false,
                                 default = nil)
  if valid_589514 != nil:
    section.add "fields", valid_589514
  var valid_589515 = query.getOrDefault("view")
  valid_589515 = validateParameter(valid_589515, JString, required = false,
                                 default = newJString("ADMIN"))
  if valid_589515 != nil:
    section.add "view", valid_589515
  var valid_589516 = query.getOrDefault("quotaUser")
  valid_589516 = validateParameter(valid_589516, JString, required = false,
                                 default = nil)
  if valid_589516 != nil:
    section.add "quotaUser", valid_589516
  var valid_589517 = query.getOrDefault("alt")
  valid_589517 = validateParameter(valid_589517, JString, required = false,
                                 default = newJString("json"))
  if valid_589517 != nil:
    section.add "alt", valid_589517
  var valid_589518 = query.getOrDefault("oauth_token")
  valid_589518 = validateParameter(valid_589518, JString, required = false,
                                 default = nil)
  if valid_589518 != nil:
    section.add "oauth_token", valid_589518
  var valid_589519 = query.getOrDefault("fetchUserInfo")
  valid_589519 = validateParameter(valid_589519, JBool, required = false, default = nil)
  if valid_589519 != nil:
    section.add "fetchUserInfo", valid_589519
  var valid_589520 = query.getOrDefault("userIp")
  valid_589520 = validateParameter(valid_589520, JString, required = false,
                                 default = nil)
  if valid_589520 != nil:
    section.add "userIp", valid_589520
  var valid_589521 = query.getOrDefault("key")
  valid_589521 = validateParameter(valid_589521, JString, required = false,
                                 default = nil)
  if valid_589521 != nil:
    section.add "key", valid_589521
  var valid_589522 = query.getOrDefault("role")
  valid_589522 = validateParameter(valid_589522, JArray, required = false,
                                 default = nil)
  if valid_589522 != nil:
    section.add "role", valid_589522
  var valid_589523 = query.getOrDefault("status")
  valid_589523 = validateParameter(valid_589523, JArray, required = false,
                                 default = nil)
  if valid_589523 != nil:
    section.add "status", valid_589523
  var valid_589524 = query.getOrDefault("prettyPrint")
  valid_589524 = validateParameter(valid_589524, JBool, required = false,
                                 default = newJBool(true))
  if valid_589524 != nil:
    section.add "prettyPrint", valid_589524
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589525: Call_BloggerBlogsListByUser_589510; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of blogs, possibly filtered.
  ## 
  let valid = call_589525.validator(path, query, header, formData, body)
  let scheme = call_589525.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589525.url(scheme.get, call_589525.host, call_589525.base,
                         call_589525.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589525, url, valid)

proc call*(call_589526: Call_BloggerBlogsListByUser_589510; userId: string;
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
  ##         : ID of the user whose blogs are to be fetched. Either the word 'self' or the user's profile identifier.
  var path_589527 = newJObject()
  var query_589528 = newJObject()
  add(query_589528, "fields", newJString(fields))
  add(query_589528, "view", newJString(view))
  add(query_589528, "quotaUser", newJString(quotaUser))
  add(query_589528, "alt", newJString(alt))
  add(query_589528, "oauth_token", newJString(oauthToken))
  add(query_589528, "fetchUserInfo", newJBool(fetchUserInfo))
  add(query_589528, "userIp", newJString(userIp))
  add(query_589528, "key", newJString(key))
  if role != nil:
    query_589528.add "role", role
  if status != nil:
    query_589528.add "status", status
  add(query_589528, "prettyPrint", newJBool(prettyPrint))
  add(path_589527, "userId", newJString(userId))
  result = call_589526.call(path_589527, query_589528, nil, nil, nil)

var bloggerBlogsListByUser* = Call_BloggerBlogsListByUser_589510(
    name: "bloggerBlogsListByUser", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userId}/blogs",
    validator: validate_BloggerBlogsListByUser_589511, base: "/blogger/v3",
    url: url_BloggerBlogsListByUser_589512, schemes: {Scheme.Https})
type
  Call_BloggerBlogUserInfosGet_589529 = ref object of OpenApiRestCall_588441
proc url_BloggerBlogUserInfosGet_589531(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerBlogUserInfosGet_589530(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets one blog and user info pair by blogId and userId.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blogId: JString (required)
  ##         : The ID of the blog to get.
  ##   userId: JString (required)
  ##         : ID of the user whose blogs are to be fetched. Either the word 'self' or the user's profile identifier.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blogId` field"
  var valid_589532 = path.getOrDefault("blogId")
  valid_589532 = validateParameter(valid_589532, JString, required = true,
                                 default = nil)
  if valid_589532 != nil:
    section.add "blogId", valid_589532
  var valid_589533 = path.getOrDefault("userId")
  valid_589533 = validateParameter(valid_589533, JString, required = true,
                                 default = nil)
  if valid_589533 != nil:
    section.add "userId", valid_589533
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
  var valid_589534 = query.getOrDefault("fields")
  valid_589534 = validateParameter(valid_589534, JString, required = false,
                                 default = nil)
  if valid_589534 != nil:
    section.add "fields", valid_589534
  var valid_589535 = query.getOrDefault("quotaUser")
  valid_589535 = validateParameter(valid_589535, JString, required = false,
                                 default = nil)
  if valid_589535 != nil:
    section.add "quotaUser", valid_589535
  var valid_589536 = query.getOrDefault("alt")
  valid_589536 = validateParameter(valid_589536, JString, required = false,
                                 default = newJString("json"))
  if valid_589536 != nil:
    section.add "alt", valid_589536
  var valid_589537 = query.getOrDefault("oauth_token")
  valid_589537 = validateParameter(valid_589537, JString, required = false,
                                 default = nil)
  if valid_589537 != nil:
    section.add "oauth_token", valid_589537
  var valid_589538 = query.getOrDefault("userIp")
  valid_589538 = validateParameter(valid_589538, JString, required = false,
                                 default = nil)
  if valid_589538 != nil:
    section.add "userIp", valid_589538
  var valid_589539 = query.getOrDefault("key")
  valid_589539 = validateParameter(valid_589539, JString, required = false,
                                 default = nil)
  if valid_589539 != nil:
    section.add "key", valid_589539
  var valid_589540 = query.getOrDefault("prettyPrint")
  valid_589540 = validateParameter(valid_589540, JBool, required = false,
                                 default = newJBool(true))
  if valid_589540 != nil:
    section.add "prettyPrint", valid_589540
  var valid_589541 = query.getOrDefault("maxPosts")
  valid_589541 = validateParameter(valid_589541, JInt, required = false, default = nil)
  if valid_589541 != nil:
    section.add "maxPosts", valid_589541
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589542: Call_BloggerBlogUserInfosGet_589529; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one blog and user info pair by blogId and userId.
  ## 
  let valid = call_589542.validator(path, query, header, formData, body)
  let scheme = call_589542.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589542.url(scheme.get, call_589542.host, call_589542.base,
                         call_589542.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589542, url, valid)

proc call*(call_589543: Call_BloggerBlogUserInfosGet_589529; blogId: string;
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
  ##         : ID of the user whose blogs are to be fetched. Either the word 'self' or the user's profile identifier.
  var path_589544 = newJObject()
  var query_589545 = newJObject()
  add(query_589545, "fields", newJString(fields))
  add(query_589545, "quotaUser", newJString(quotaUser))
  add(query_589545, "alt", newJString(alt))
  add(query_589545, "oauth_token", newJString(oauthToken))
  add(query_589545, "userIp", newJString(userIp))
  add(query_589545, "key", newJString(key))
  add(path_589544, "blogId", newJString(blogId))
  add(query_589545, "prettyPrint", newJBool(prettyPrint))
  add(query_589545, "maxPosts", newJInt(maxPosts))
  add(path_589544, "userId", newJString(userId))
  result = call_589543.call(path_589544, query_589545, nil, nil, nil)

var bloggerBlogUserInfosGet* = Call_BloggerBlogUserInfosGet_589529(
    name: "bloggerBlogUserInfosGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userId}/blogs/{blogId}",
    validator: validate_BloggerBlogUserInfosGet_589530, base: "/blogger/v3",
    url: url_BloggerBlogUserInfosGet_589531, schemes: {Scheme.Https})
type
  Call_BloggerPostUserInfosList_589546 = ref object of OpenApiRestCall_588441
proc url_BloggerPostUserInfosList_589548(protocol: Scheme; host: string;
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

proc validate_BloggerPostUserInfosList_589547(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of post and post user info pairs, possibly filtered. The post user info contains per-user information about the post, such as access rights, specific to the user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blogId: JString (required)
  ##         : ID of the blog to fetch posts from.
  ##   userId: JString (required)
  ##         : ID of the user for the per-user information to be fetched. Either the word 'self' or the user's profile identifier.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blogId` field"
  var valid_589549 = path.getOrDefault("blogId")
  valid_589549 = validateParameter(valid_589549, JString, required = true,
                                 default = nil)
  if valid_589549 != nil:
    section.add "blogId", valid_589549
  var valid_589550 = path.getOrDefault("userId")
  valid_589550 = validateParameter(valid_589550, JString, required = true,
                                 default = nil)
  if valid_589550 != nil:
    section.add "userId", valid_589550
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
  var valid_589551 = query.getOrDefault("fields")
  valid_589551 = validateParameter(valid_589551, JString, required = false,
                                 default = nil)
  if valid_589551 != nil:
    section.add "fields", valid_589551
  var valid_589552 = query.getOrDefault("pageToken")
  valid_589552 = validateParameter(valid_589552, JString, required = false,
                                 default = nil)
  if valid_589552 != nil:
    section.add "pageToken", valid_589552
  var valid_589553 = query.getOrDefault("quotaUser")
  valid_589553 = validateParameter(valid_589553, JString, required = false,
                                 default = nil)
  if valid_589553 != nil:
    section.add "quotaUser", valid_589553
  var valid_589554 = query.getOrDefault("view")
  valid_589554 = validateParameter(valid_589554, JString, required = false,
                                 default = newJString("ADMIN"))
  if valid_589554 != nil:
    section.add "view", valid_589554
  var valid_589555 = query.getOrDefault("alt")
  valid_589555 = validateParameter(valid_589555, JString, required = false,
                                 default = newJString("json"))
  if valid_589555 != nil:
    section.add "alt", valid_589555
  var valid_589556 = query.getOrDefault("endDate")
  valid_589556 = validateParameter(valid_589556, JString, required = false,
                                 default = nil)
  if valid_589556 != nil:
    section.add "endDate", valid_589556
  var valid_589557 = query.getOrDefault("startDate")
  valid_589557 = validateParameter(valid_589557, JString, required = false,
                                 default = nil)
  if valid_589557 != nil:
    section.add "startDate", valid_589557
  var valid_589558 = query.getOrDefault("oauth_token")
  valid_589558 = validateParameter(valid_589558, JString, required = false,
                                 default = nil)
  if valid_589558 != nil:
    section.add "oauth_token", valid_589558
  var valid_589559 = query.getOrDefault("userIp")
  valid_589559 = validateParameter(valid_589559, JString, required = false,
                                 default = nil)
  if valid_589559 != nil:
    section.add "userIp", valid_589559
  var valid_589560 = query.getOrDefault("maxResults")
  valid_589560 = validateParameter(valid_589560, JInt, required = false, default = nil)
  if valid_589560 != nil:
    section.add "maxResults", valid_589560
  var valid_589561 = query.getOrDefault("orderBy")
  valid_589561 = validateParameter(valid_589561, JString, required = false,
                                 default = newJString("published"))
  if valid_589561 != nil:
    section.add "orderBy", valid_589561
  var valid_589562 = query.getOrDefault("key")
  valid_589562 = validateParameter(valid_589562, JString, required = false,
                                 default = nil)
  if valid_589562 != nil:
    section.add "key", valid_589562
  var valid_589563 = query.getOrDefault("labels")
  valid_589563 = validateParameter(valid_589563, JString, required = false,
                                 default = nil)
  if valid_589563 != nil:
    section.add "labels", valid_589563
  var valid_589564 = query.getOrDefault("status")
  valid_589564 = validateParameter(valid_589564, JArray, required = false,
                                 default = nil)
  if valid_589564 != nil:
    section.add "status", valid_589564
  var valid_589565 = query.getOrDefault("fetchBodies")
  valid_589565 = validateParameter(valid_589565, JBool, required = false,
                                 default = newJBool(false))
  if valid_589565 != nil:
    section.add "fetchBodies", valid_589565
  var valid_589566 = query.getOrDefault("prettyPrint")
  valid_589566 = validateParameter(valid_589566, JBool, required = false,
                                 default = newJBool(true))
  if valid_589566 != nil:
    section.add "prettyPrint", valid_589566
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589567: Call_BloggerPostUserInfosList_589546; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of post and post user info pairs, possibly filtered. The post user info contains per-user information about the post, such as access rights, specific to the user.
  ## 
  let valid = call_589567.validator(path, query, header, formData, body)
  let scheme = call_589567.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589567.url(scheme.get, call_589567.host, call_589567.base,
                         call_589567.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589567, url, valid)

proc call*(call_589568: Call_BloggerPostUserInfosList_589546; blogId: string;
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
  ##         : ID of the user for the per-user information to be fetched. Either the word 'self' or the user's profile identifier.
  var path_589569 = newJObject()
  var query_589570 = newJObject()
  add(query_589570, "fields", newJString(fields))
  add(query_589570, "pageToken", newJString(pageToken))
  add(query_589570, "quotaUser", newJString(quotaUser))
  add(query_589570, "view", newJString(view))
  add(query_589570, "alt", newJString(alt))
  add(query_589570, "endDate", newJString(endDate))
  add(query_589570, "startDate", newJString(startDate))
  add(query_589570, "oauth_token", newJString(oauthToken))
  add(query_589570, "userIp", newJString(userIp))
  add(query_589570, "maxResults", newJInt(maxResults))
  add(query_589570, "orderBy", newJString(orderBy))
  add(query_589570, "key", newJString(key))
  add(query_589570, "labels", newJString(labels))
  if status != nil:
    query_589570.add "status", status
  add(query_589570, "fetchBodies", newJBool(fetchBodies))
  add(path_589569, "blogId", newJString(blogId))
  add(query_589570, "prettyPrint", newJBool(prettyPrint))
  add(path_589569, "userId", newJString(userId))
  result = call_589568.call(path_589569, query_589570, nil, nil, nil)

var bloggerPostUserInfosList* = Call_BloggerPostUserInfosList_589546(
    name: "bloggerPostUserInfosList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userId}/blogs/{blogId}/posts",
    validator: validate_BloggerPostUserInfosList_589547, base: "/blogger/v3",
    url: url_BloggerPostUserInfosList_589548, schemes: {Scheme.Https})
type
  Call_BloggerPostUserInfosGet_589571 = ref object of OpenApiRestCall_588441
proc url_BloggerPostUserInfosGet_589573(protocol: Scheme; host: string; base: string;
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

proc validate_BloggerPostUserInfosGet_589572(path: JsonNode; query: JsonNode;
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
  ##         : ID of the user for the per-user information to be fetched. Either the word 'self' or the user's profile identifier.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `postId` field"
  var valid_589574 = path.getOrDefault("postId")
  valid_589574 = validateParameter(valid_589574, JString, required = true,
                                 default = nil)
  if valid_589574 != nil:
    section.add "postId", valid_589574
  var valid_589575 = path.getOrDefault("blogId")
  valid_589575 = validateParameter(valid_589575, JString, required = true,
                                 default = nil)
  if valid_589575 != nil:
    section.add "blogId", valid_589575
  var valid_589576 = path.getOrDefault("userId")
  valid_589576 = validateParameter(valid_589576, JString, required = true,
                                 default = nil)
  if valid_589576 != nil:
    section.add "userId", valid_589576
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
  var valid_589577 = query.getOrDefault("fields")
  valid_589577 = validateParameter(valid_589577, JString, required = false,
                                 default = nil)
  if valid_589577 != nil:
    section.add "fields", valid_589577
  var valid_589578 = query.getOrDefault("quotaUser")
  valid_589578 = validateParameter(valid_589578, JString, required = false,
                                 default = nil)
  if valid_589578 != nil:
    section.add "quotaUser", valid_589578
  var valid_589579 = query.getOrDefault("alt")
  valid_589579 = validateParameter(valid_589579, JString, required = false,
                                 default = newJString("json"))
  if valid_589579 != nil:
    section.add "alt", valid_589579
  var valid_589580 = query.getOrDefault("oauth_token")
  valid_589580 = validateParameter(valid_589580, JString, required = false,
                                 default = nil)
  if valid_589580 != nil:
    section.add "oauth_token", valid_589580
  var valid_589581 = query.getOrDefault("userIp")
  valid_589581 = validateParameter(valid_589581, JString, required = false,
                                 default = nil)
  if valid_589581 != nil:
    section.add "userIp", valid_589581
  var valid_589582 = query.getOrDefault("maxComments")
  valid_589582 = validateParameter(valid_589582, JInt, required = false, default = nil)
  if valid_589582 != nil:
    section.add "maxComments", valid_589582
  var valid_589583 = query.getOrDefault("key")
  valid_589583 = validateParameter(valid_589583, JString, required = false,
                                 default = nil)
  if valid_589583 != nil:
    section.add "key", valid_589583
  var valid_589584 = query.getOrDefault("prettyPrint")
  valid_589584 = validateParameter(valid_589584, JBool, required = false,
                                 default = newJBool(true))
  if valid_589584 != nil:
    section.add "prettyPrint", valid_589584
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589585: Call_BloggerPostUserInfosGet_589571; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one post and user info pair, by post ID and user ID. The post user info contains per-user information about the post, such as access rights, specific to the user.
  ## 
  let valid = call_589585.validator(path, query, header, formData, body)
  let scheme = call_589585.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589585.url(scheme.get, call_589585.host, call_589585.base,
                         call_589585.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589585, url, valid)

proc call*(call_589586: Call_BloggerPostUserInfosGet_589571; postId: string;
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
  ##         : ID of the user for the per-user information to be fetched. Either the word 'self' or the user's profile identifier.
  var path_589587 = newJObject()
  var query_589588 = newJObject()
  add(query_589588, "fields", newJString(fields))
  add(query_589588, "quotaUser", newJString(quotaUser))
  add(query_589588, "alt", newJString(alt))
  add(query_589588, "oauth_token", newJString(oauthToken))
  add(query_589588, "userIp", newJString(userIp))
  add(query_589588, "maxComments", newJInt(maxComments))
  add(query_589588, "key", newJString(key))
  add(path_589587, "postId", newJString(postId))
  add(path_589587, "blogId", newJString(blogId))
  add(query_589588, "prettyPrint", newJBool(prettyPrint))
  add(path_589587, "userId", newJString(userId))
  result = call_589586.call(path_589587, query_589588, nil, nil, nil)

var bloggerPostUserInfosGet* = Call_BloggerPostUserInfosGet_589571(
    name: "bloggerPostUserInfosGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/users/{userId}/blogs/{blogId}/posts/{postId}",
    validator: validate_BloggerPostUserInfosGet_589572, base: "/blogger/v3",
    url: url_BloggerPostUserInfosGet_589573, schemes: {Scheme.Https})
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
