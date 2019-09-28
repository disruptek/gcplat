
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: YouTube Data
## version: v3
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Supports core YouTube features, such as uploading videos, creating and managing playlists, searching for content, and much more.
## 
## https://developers.google.com/youtube/v3
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

  OpenApiRestCall_579437 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579437](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579437): Option[Scheme] {.used.} =
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
  gcpServiceName = "youtube"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_YoutubeActivitiesInsert_579983 = ref object of OpenApiRestCall_579437
proc url_YoutubeActivitiesInsert_579985(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeActivitiesInsert_579984(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Posts a bulletin for a specific channel. (The user submitting the request must be authorized to act on the channel's behalf.)
  ## 
  ## Note: Even though an activity resource can contain information about actions like a user rating a video or marking a video as a favorite, you need to use other API methods to generate those activity resources. For example, you would use the API's videos.rate() method to rate a video and the playlistItems.insert() method to mark a video as a favorite.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579986 = query.getOrDefault("fields")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "fields", valid_579986
  var valid_579987 = query.getOrDefault("quotaUser")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "quotaUser", valid_579987
  var valid_579988 = query.getOrDefault("alt")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = newJString("json"))
  if valid_579988 != nil:
    section.add "alt", valid_579988
  var valid_579989 = query.getOrDefault("oauth_token")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "oauth_token", valid_579989
  var valid_579990 = query.getOrDefault("userIp")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "userIp", valid_579990
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_579991 = query.getOrDefault("part")
  valid_579991 = validateParameter(valid_579991, JString, required = true,
                                 default = nil)
  if valid_579991 != nil:
    section.add "part", valid_579991
  var valid_579992 = query.getOrDefault("key")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "key", valid_579992
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
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579995: Call_YoutubeActivitiesInsert_579983; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Posts a bulletin for a specific channel. (The user submitting the request must be authorized to act on the channel's behalf.)
  ## 
  ## Note: Even though an activity resource can contain information about actions like a user rating a video or marking a video as a favorite, you need to use other API methods to generate those activity resources. For example, you would use the API's videos.rate() method to rate a video and the playlistItems.insert() method to mark a video as a favorite.
  ## 
  let valid = call_579995.validator(path, query, header, formData, body)
  let scheme = call_579995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579995.url(scheme.get, call_579995.host, call_579995.base,
                         call_579995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579995, url, valid)

proc call*(call_579996: Call_YoutubeActivitiesInsert_579983; part: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## youtubeActivitiesInsert
  ## Posts a bulletin for a specific channel. (The user submitting the request must be authorized to act on the channel's behalf.)
  ## 
  ## Note: Even though an activity resource can contain information about actions like a user rating a video or marking a video as a favorite, you need to use other API methods to generate those activity resources. For example, you would use the API's videos.rate() method to rate a video and the playlistItems.insert() method to mark a video as a favorite.
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
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_579997 = newJObject()
  var body_579998 = newJObject()
  add(query_579997, "fields", newJString(fields))
  add(query_579997, "quotaUser", newJString(quotaUser))
  add(query_579997, "alt", newJString(alt))
  add(query_579997, "oauth_token", newJString(oauthToken))
  add(query_579997, "userIp", newJString(userIp))
  add(query_579997, "part", newJString(part))
  add(query_579997, "key", newJString(key))
  if body != nil:
    body_579998 = body
  add(query_579997, "prettyPrint", newJBool(prettyPrint))
  result = call_579996.call(nil, query_579997, nil, nil, body_579998)

var youtubeActivitiesInsert* = Call_YoutubeActivitiesInsert_579983(
    name: "youtubeActivitiesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/activities",
    validator: validate_YoutubeActivitiesInsert_579984, base: "/youtube/v3",
    url: url_YoutubeActivitiesInsert_579985, schemes: {Scheme.Https})
type
  Call_YoutubeActivitiesList_579705 = ref object of OpenApiRestCall_579437
proc url_YoutubeActivitiesList_579707(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeActivitiesList_579706(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of channel activity events that match the request criteria. For example, you can retrieve events associated with a particular channel, events associated with the user's subscriptions and Google+ friends, or the YouTube home page feed, which is customized for each user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   mine: JBool
  ##       : Set this parameter's value to true to retrieve a feed of the authenticated user's activities.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   publishedAfter: JString
  ##                 : The publishedAfter parameter specifies the earliest date and time that an activity could have occurred for that activity to be included in the API response. If the parameter value specifies a day, but not a time, then any activities that occurred that day will be included in the result set. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   alt: JString
  ##      : Data format for the response.
  ##   home: JBool
  ##       : Set this parameter's value to true to retrieve the activity feed that displays on the YouTube home page for the currently authenticated user.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more activity resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in an activity resource, the snippet property contains other properties that identify the type of activity, a display title for the activity, and so forth. If you set part=snippet, the API response will also contain all of those nested properties.
  ##   channelId: JString
  ##            : The channelId parameter specifies a unique YouTube channel ID. The API will then return a list of that channel's activities.
  ##   regionCode: JString
  ##             : The regionCode parameter instructs the API to return results for the specified country. The parameter value is an ISO 3166-1 alpha-2 country code. YouTube uses this value when the authorized user's previous activity on YouTube does not provide enough information to generate the activity feed.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   publishedBefore: JString
  ##                  : The publishedBefore parameter specifies the date and time before which an activity must have occurred for that activity to be included in the API response. If the parameter value specifies a day, but not a time, then any activities that occurred that day will be excluded from the result set. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579819 = query.getOrDefault("mine")
  valid_579819 = validateParameter(valid_579819, JBool, required = false, default = nil)
  if valid_579819 != nil:
    section.add "mine", valid_579819
  var valid_579820 = query.getOrDefault("fields")
  valid_579820 = validateParameter(valid_579820, JString, required = false,
                                 default = nil)
  if valid_579820 != nil:
    section.add "fields", valid_579820
  var valid_579821 = query.getOrDefault("publishedAfter")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = nil)
  if valid_579821 != nil:
    section.add "publishedAfter", valid_579821
  var valid_579822 = query.getOrDefault("quotaUser")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = nil)
  if valid_579822 != nil:
    section.add "quotaUser", valid_579822
  var valid_579823 = query.getOrDefault("pageToken")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "pageToken", valid_579823
  var valid_579837 = query.getOrDefault("alt")
  valid_579837 = validateParameter(valid_579837, JString, required = false,
                                 default = newJString("json"))
  if valid_579837 != nil:
    section.add "alt", valid_579837
  var valid_579838 = query.getOrDefault("home")
  valid_579838 = validateParameter(valid_579838, JBool, required = false, default = nil)
  if valid_579838 != nil:
    section.add "home", valid_579838
  var valid_579839 = query.getOrDefault("oauth_token")
  valid_579839 = validateParameter(valid_579839, JString, required = false,
                                 default = nil)
  if valid_579839 != nil:
    section.add "oauth_token", valid_579839
  var valid_579840 = query.getOrDefault("userIp")
  valid_579840 = validateParameter(valid_579840, JString, required = false,
                                 default = nil)
  if valid_579840 != nil:
    section.add "userIp", valid_579840
  var valid_579842 = query.getOrDefault("maxResults")
  valid_579842 = validateParameter(valid_579842, JInt, required = false,
                                 default = newJInt(5))
  if valid_579842 != nil:
    section.add "maxResults", valid_579842
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_579843 = query.getOrDefault("part")
  valid_579843 = validateParameter(valid_579843, JString, required = true,
                                 default = nil)
  if valid_579843 != nil:
    section.add "part", valid_579843
  var valid_579844 = query.getOrDefault("channelId")
  valid_579844 = validateParameter(valid_579844, JString, required = false,
                                 default = nil)
  if valid_579844 != nil:
    section.add "channelId", valid_579844
  var valid_579845 = query.getOrDefault("regionCode")
  valid_579845 = validateParameter(valid_579845, JString, required = false,
                                 default = nil)
  if valid_579845 != nil:
    section.add "regionCode", valid_579845
  var valid_579846 = query.getOrDefault("key")
  valid_579846 = validateParameter(valid_579846, JString, required = false,
                                 default = nil)
  if valid_579846 != nil:
    section.add "key", valid_579846
  var valid_579847 = query.getOrDefault("publishedBefore")
  valid_579847 = validateParameter(valid_579847, JString, required = false,
                                 default = nil)
  if valid_579847 != nil:
    section.add "publishedBefore", valid_579847
  var valid_579848 = query.getOrDefault("prettyPrint")
  valid_579848 = validateParameter(valid_579848, JBool, required = false,
                                 default = newJBool(true))
  if valid_579848 != nil:
    section.add "prettyPrint", valid_579848
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579871: Call_YoutubeActivitiesList_579705; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of channel activity events that match the request criteria. For example, you can retrieve events associated with a particular channel, events associated with the user's subscriptions and Google+ friends, or the YouTube home page feed, which is customized for each user.
  ## 
  let valid = call_579871.validator(path, query, header, formData, body)
  let scheme = call_579871.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579871.url(scheme.get, call_579871.host, call_579871.base,
                         call_579871.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579871, url, valid)

proc call*(call_579942: Call_YoutubeActivitiesList_579705; part: string;
          mine: bool = false; fields: string = ""; publishedAfter: string = "";
          quotaUser: string = ""; pageToken: string = ""; alt: string = "json";
          home: bool = false; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 5; channelId: string = ""; regionCode: string = "";
          key: string = ""; publishedBefore: string = ""; prettyPrint: bool = true): Recallable =
  ## youtubeActivitiesList
  ## Returns a list of channel activity events that match the request criteria. For example, you can retrieve events associated with a particular channel, events associated with the user's subscriptions and Google+ friends, or the YouTube home page feed, which is customized for each user.
  ##   mine: bool
  ##       : Set this parameter's value to true to retrieve a feed of the authenticated user's activities.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   publishedAfter: string
  ##                 : The publishedAfter parameter specifies the earliest date and time that an activity could have occurred for that activity to be included in the API response. If the parameter value specifies a day, but not a time, then any activities that occurred that day will be included in the result set. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   alt: string
  ##      : Data format for the response.
  ##   home: bool
  ##       : Set this parameter's value to true to retrieve the activity feed that displays on the YouTube home page for the currently authenticated user.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more activity resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in an activity resource, the snippet property contains other properties that identify the type of activity, a display title for the activity, and so forth. If you set part=snippet, the API response will also contain all of those nested properties.
  ##   channelId: string
  ##            : The channelId parameter specifies a unique YouTube channel ID. The API will then return a list of that channel's activities.
  ##   regionCode: string
  ##             : The regionCode parameter instructs the API to return results for the specified country. The parameter value is an ISO 3166-1 alpha-2 country code. YouTube uses this value when the authorized user's previous activity on YouTube does not provide enough information to generate the activity feed.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   publishedBefore: string
  ##                  : The publishedBefore parameter specifies the date and time before which an activity must have occurred for that activity to be included in the API response. If the parameter value specifies a day, but not a time, then any activities that occurred that day will be excluded from the result set. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sZ) format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_579943 = newJObject()
  add(query_579943, "mine", newJBool(mine))
  add(query_579943, "fields", newJString(fields))
  add(query_579943, "publishedAfter", newJString(publishedAfter))
  add(query_579943, "quotaUser", newJString(quotaUser))
  add(query_579943, "pageToken", newJString(pageToken))
  add(query_579943, "alt", newJString(alt))
  add(query_579943, "home", newJBool(home))
  add(query_579943, "oauth_token", newJString(oauthToken))
  add(query_579943, "userIp", newJString(userIp))
  add(query_579943, "maxResults", newJInt(maxResults))
  add(query_579943, "part", newJString(part))
  add(query_579943, "channelId", newJString(channelId))
  add(query_579943, "regionCode", newJString(regionCode))
  add(query_579943, "key", newJString(key))
  add(query_579943, "publishedBefore", newJString(publishedBefore))
  add(query_579943, "prettyPrint", newJBool(prettyPrint))
  result = call_579942.call(nil, query_579943, nil, nil, nil)

var youtubeActivitiesList* = Call_YoutubeActivitiesList_579705(
    name: "youtubeActivitiesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/activities",
    validator: validate_YoutubeActivitiesList_579706, base: "/youtube/v3",
    url: url_YoutubeActivitiesList_579707, schemes: {Scheme.Https})
type
  Call_YoutubeCaptionsUpdate_580017 = ref object of OpenApiRestCall_579437
proc url_YoutubeCaptionsUpdate_580019(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeCaptionsUpdate_580018(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a caption track. When updating a caption track, you can change the track's draft status, upload a new caption file for the track, or both.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   sync: JBool
  ##       : Note: The API server only processes the parameter value if the request contains an updated caption file.
  ## 
  ## The sync parameter indicates whether YouTube should automatically synchronize the caption file with the audio track of the video. If you set the value to true, YouTube will automatically synchronize the caption track with the audio track.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   onBehalfOf: JString
  ##             : ID of the Google+ Page for the channel that the request is be on behalf of
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include. Set the property value to snippet if you are updating the track's draft status. Otherwise, set the property value to id.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580020 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "onBehalfOfContentOwner", valid_580020
  var valid_580021 = query.getOrDefault("fields")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "fields", valid_580021
  var valid_580022 = query.getOrDefault("quotaUser")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "quotaUser", valid_580022
  var valid_580023 = query.getOrDefault("sync")
  valid_580023 = validateParameter(valid_580023, JBool, required = false, default = nil)
  if valid_580023 != nil:
    section.add "sync", valid_580023
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
  var valid_580026 = query.getOrDefault("userIp")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "userIp", valid_580026
  var valid_580027 = query.getOrDefault("onBehalfOf")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "onBehalfOf", valid_580027
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_580028 = query.getOrDefault("part")
  valid_580028 = validateParameter(valid_580028, JString, required = true,
                                 default = nil)
  if valid_580028 != nil:
    section.add "part", valid_580028
  var valid_580029 = query.getOrDefault("key")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "key", valid_580029
  var valid_580030 = query.getOrDefault("prettyPrint")
  valid_580030 = validateParameter(valid_580030, JBool, required = false,
                                 default = newJBool(true))
  if valid_580030 != nil:
    section.add "prettyPrint", valid_580030
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

proc call*(call_580032: Call_YoutubeCaptionsUpdate_580017; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a caption track. When updating a caption track, you can change the track's draft status, upload a new caption file for the track, or both.
  ## 
  let valid = call_580032.validator(path, query, header, formData, body)
  let scheme = call_580032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580032.url(scheme.get, call_580032.host, call_580032.base,
                         call_580032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580032, url, valid)

proc call*(call_580033: Call_YoutubeCaptionsUpdate_580017; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; sync: bool = false; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; onBehalfOf: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## youtubeCaptionsUpdate
  ## Updates a caption track. When updating a caption track, you can change the track's draft status, upload a new caption file for the track, or both.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   sync: bool
  ##       : Note: The API server only processes the parameter value if the request contains an updated caption file.
  ## 
  ## The sync parameter indicates whether YouTube should automatically synchronize the caption file with the audio track of the video. If you set the value to true, YouTube will automatically synchronize the caption track with the audio track.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   onBehalfOf: string
  ##             : ID of the Google+ Page for the channel that the request is be on behalf of
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include. Set the property value to snippet if you are updating the track's draft status. Otherwise, set the property value to id.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580034 = newJObject()
  var body_580035 = newJObject()
  add(query_580034, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580034, "fields", newJString(fields))
  add(query_580034, "quotaUser", newJString(quotaUser))
  add(query_580034, "sync", newJBool(sync))
  add(query_580034, "alt", newJString(alt))
  add(query_580034, "oauth_token", newJString(oauthToken))
  add(query_580034, "userIp", newJString(userIp))
  add(query_580034, "onBehalfOf", newJString(onBehalfOf))
  add(query_580034, "part", newJString(part))
  add(query_580034, "key", newJString(key))
  if body != nil:
    body_580035 = body
  add(query_580034, "prettyPrint", newJBool(prettyPrint))
  result = call_580033.call(nil, query_580034, nil, nil, body_580035)

var youtubeCaptionsUpdate* = Call_YoutubeCaptionsUpdate_580017(
    name: "youtubeCaptionsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/captions",
    validator: validate_YoutubeCaptionsUpdate_580018, base: "/youtube/v3",
    url: url_YoutubeCaptionsUpdate_580019, schemes: {Scheme.Https})
type
  Call_YoutubeCaptionsInsert_580036 = ref object of OpenApiRestCall_579437
proc url_YoutubeCaptionsInsert_580038(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeCaptionsInsert_580037(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Uploads a caption track.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   sync: JBool
  ##       : The sync parameter indicates whether YouTube should automatically synchronize the caption file with the audio track of the video. If you set the value to true, YouTube will disregard any time codes that are in the uploaded caption file and generate new time codes for the captions.
  ## 
  ## You should set the sync parameter to true if you are uploading a transcript, which has no time codes, or if you suspect the time codes in your file are incorrect and want YouTube to try to fix them.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   onBehalfOf: JString
  ##             : ID of the Google+ Page for the channel that the request is be on behalf of
  ##   part: JString (required)
  ##       : The part parameter specifies the caption resource parts that the API response will include. Set the parameter value to snippet.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580039 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "onBehalfOfContentOwner", valid_580039
  var valid_580040 = query.getOrDefault("fields")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "fields", valid_580040
  var valid_580041 = query.getOrDefault("quotaUser")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "quotaUser", valid_580041
  var valid_580042 = query.getOrDefault("sync")
  valid_580042 = validateParameter(valid_580042, JBool, required = false, default = nil)
  if valid_580042 != nil:
    section.add "sync", valid_580042
  var valid_580043 = query.getOrDefault("alt")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = newJString("json"))
  if valid_580043 != nil:
    section.add "alt", valid_580043
  var valid_580044 = query.getOrDefault("oauth_token")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "oauth_token", valid_580044
  var valid_580045 = query.getOrDefault("userIp")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "userIp", valid_580045
  var valid_580046 = query.getOrDefault("onBehalfOf")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "onBehalfOf", valid_580046
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_580047 = query.getOrDefault("part")
  valid_580047 = validateParameter(valid_580047, JString, required = true,
                                 default = nil)
  if valid_580047 != nil:
    section.add "part", valid_580047
  var valid_580048 = query.getOrDefault("key")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "key", valid_580048
  var valid_580049 = query.getOrDefault("prettyPrint")
  valid_580049 = validateParameter(valid_580049, JBool, required = false,
                                 default = newJBool(true))
  if valid_580049 != nil:
    section.add "prettyPrint", valid_580049
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

proc call*(call_580051: Call_YoutubeCaptionsInsert_580036; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Uploads a caption track.
  ## 
  let valid = call_580051.validator(path, query, header, formData, body)
  let scheme = call_580051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580051.url(scheme.get, call_580051.host, call_580051.base,
                         call_580051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580051, url, valid)

proc call*(call_580052: Call_YoutubeCaptionsInsert_580036; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; sync: bool = false; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; onBehalfOf: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## youtubeCaptionsInsert
  ## Uploads a caption track.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   sync: bool
  ##       : The sync parameter indicates whether YouTube should automatically synchronize the caption file with the audio track of the video. If you set the value to true, YouTube will disregard any time codes that are in the uploaded caption file and generate new time codes for the captions.
  ## 
  ## You should set the sync parameter to true if you are uploading a transcript, which has no time codes, or if you suspect the time codes in your file are incorrect and want YouTube to try to fix them.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   onBehalfOf: string
  ##             : ID of the Google+ Page for the channel that the request is be on behalf of
  ##   part: string (required)
  ##       : The part parameter specifies the caption resource parts that the API response will include. Set the parameter value to snippet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580053 = newJObject()
  var body_580054 = newJObject()
  add(query_580053, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580053, "fields", newJString(fields))
  add(query_580053, "quotaUser", newJString(quotaUser))
  add(query_580053, "sync", newJBool(sync))
  add(query_580053, "alt", newJString(alt))
  add(query_580053, "oauth_token", newJString(oauthToken))
  add(query_580053, "userIp", newJString(userIp))
  add(query_580053, "onBehalfOf", newJString(onBehalfOf))
  add(query_580053, "part", newJString(part))
  add(query_580053, "key", newJString(key))
  if body != nil:
    body_580054 = body
  add(query_580053, "prettyPrint", newJBool(prettyPrint))
  result = call_580052.call(nil, query_580053, nil, nil, body_580054)

var youtubeCaptionsInsert* = Call_YoutubeCaptionsInsert_580036(
    name: "youtubeCaptionsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/captions",
    validator: validate_YoutubeCaptionsInsert_580037, base: "/youtube/v3",
    url: url_YoutubeCaptionsInsert_580038, schemes: {Scheme.Https})
type
  Call_YoutubeCaptionsList_579999 = ref object of OpenApiRestCall_579437
proc url_YoutubeCaptionsList_580001(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeCaptionsList_580000(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Returns a list of caption tracks that are associated with a specified video. Note that the API response does not contain the actual captions and that the captions.download method provides the ability to retrieve a caption track.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of IDs that identify the caption resources that should be retrieved. Each ID must identify a caption track associated with the specified video.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   onBehalfOf: JString
  ##             : ID of the Google+ Page for the channel that the request is on behalf of.
  ##   videoId: JString (required)
  ##          : The videoId parameter specifies the YouTube video ID of the video for which the API should return caption tracks.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more caption resource parts that the API response will include. The part names that you can include in the parameter value are id and snippet.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580002 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "onBehalfOfContentOwner", valid_580002
  var valid_580003 = query.getOrDefault("fields")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "fields", valid_580003
  var valid_580004 = query.getOrDefault("quotaUser")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "quotaUser", valid_580004
  var valid_580005 = query.getOrDefault("id")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "id", valid_580005
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
  var valid_580009 = query.getOrDefault("onBehalfOf")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "onBehalfOf", valid_580009
  assert query != nil, "query argument is necessary due to required `videoId` field"
  var valid_580010 = query.getOrDefault("videoId")
  valid_580010 = validateParameter(valid_580010, JString, required = true,
                                 default = nil)
  if valid_580010 != nil:
    section.add "videoId", valid_580010
  var valid_580011 = query.getOrDefault("part")
  valid_580011 = validateParameter(valid_580011, JString, required = true,
                                 default = nil)
  if valid_580011 != nil:
    section.add "part", valid_580011
  var valid_580012 = query.getOrDefault("key")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "key", valid_580012
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

proc call*(call_580014: Call_YoutubeCaptionsList_579999; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of caption tracks that are associated with a specified video. Note that the API response does not contain the actual captions and that the captions.download method provides the ability to retrieve a caption track.
  ## 
  let valid = call_580014.validator(path, query, header, formData, body)
  let scheme = call_580014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580014.url(scheme.get, call_580014.host, call_580014.base,
                         call_580014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580014, url, valid)

proc call*(call_580015: Call_YoutubeCaptionsList_579999; videoId: string;
          part: string; onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; id: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; onBehalfOf: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## youtubeCaptionsList
  ## Returns a list of caption tracks that are associated with a specified video. Note that the API response does not contain the actual captions and that the captions.download method provides the ability to retrieve a caption track.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of IDs that identify the caption resources that should be retrieved. Each ID must identify a caption track associated with the specified video.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   onBehalfOf: string
  ##             : ID of the Google+ Page for the channel that the request is on behalf of.
  ##   videoId: string (required)
  ##          : The videoId parameter specifies the YouTube video ID of the video for which the API should return caption tracks.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more caption resource parts that the API response will include. The part names that you can include in the parameter value are id and snippet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580016 = newJObject()
  add(query_580016, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580016, "fields", newJString(fields))
  add(query_580016, "quotaUser", newJString(quotaUser))
  add(query_580016, "id", newJString(id))
  add(query_580016, "alt", newJString(alt))
  add(query_580016, "oauth_token", newJString(oauthToken))
  add(query_580016, "userIp", newJString(userIp))
  add(query_580016, "onBehalfOf", newJString(onBehalfOf))
  add(query_580016, "videoId", newJString(videoId))
  add(query_580016, "part", newJString(part))
  add(query_580016, "key", newJString(key))
  add(query_580016, "prettyPrint", newJBool(prettyPrint))
  result = call_580015.call(nil, query_580016, nil, nil, nil)

var youtubeCaptionsList* = Call_YoutubeCaptionsList_579999(
    name: "youtubeCaptionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/captions",
    validator: validate_YoutubeCaptionsList_580000, base: "/youtube/v3",
    url: url_YoutubeCaptionsList_580001, schemes: {Scheme.Https})
type
  Call_YoutubeCaptionsDelete_580055 = ref object of OpenApiRestCall_579437
proc url_YoutubeCaptionsDelete_580057(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeCaptionsDelete_580056(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a specified caption track.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter identifies the caption track that is being deleted. The value is a caption track ID as identified by the id property in a caption resource.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   onBehalfOf: JString
  ##             : ID of the Google+ Page for the channel that the request is be on behalf of
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580058 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "onBehalfOfContentOwner", valid_580058
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
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_580061 = query.getOrDefault("id")
  valid_580061 = validateParameter(valid_580061, JString, required = true,
                                 default = nil)
  if valid_580061 != nil:
    section.add "id", valid_580061
  var valid_580062 = query.getOrDefault("alt")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = newJString("json"))
  if valid_580062 != nil:
    section.add "alt", valid_580062
  var valid_580063 = query.getOrDefault("oauth_token")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "oauth_token", valid_580063
  var valid_580064 = query.getOrDefault("userIp")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "userIp", valid_580064
  var valid_580065 = query.getOrDefault("onBehalfOf")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "onBehalfOf", valid_580065
  var valid_580066 = query.getOrDefault("key")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "key", valid_580066
  var valid_580067 = query.getOrDefault("prettyPrint")
  valid_580067 = validateParameter(valid_580067, JBool, required = false,
                                 default = newJBool(true))
  if valid_580067 != nil:
    section.add "prettyPrint", valid_580067
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580068: Call_YoutubeCaptionsDelete_580055; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a specified caption track.
  ## 
  let valid = call_580068.validator(path, query, header, formData, body)
  let scheme = call_580068.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580068.url(scheme.get, call_580068.host, call_580068.base,
                         call_580068.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580068, url, valid)

proc call*(call_580069: Call_YoutubeCaptionsDelete_580055; id: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; onBehalfOf: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## youtubeCaptionsDelete
  ## Deletes a specified caption track.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter identifies the caption track that is being deleted. The value is a caption track ID as identified by the id property in a caption resource.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   onBehalfOf: string
  ##             : ID of the Google+ Page for the channel that the request is be on behalf of
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580070 = newJObject()
  add(query_580070, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580070, "fields", newJString(fields))
  add(query_580070, "quotaUser", newJString(quotaUser))
  add(query_580070, "id", newJString(id))
  add(query_580070, "alt", newJString(alt))
  add(query_580070, "oauth_token", newJString(oauthToken))
  add(query_580070, "userIp", newJString(userIp))
  add(query_580070, "onBehalfOf", newJString(onBehalfOf))
  add(query_580070, "key", newJString(key))
  add(query_580070, "prettyPrint", newJBool(prettyPrint))
  result = call_580069.call(nil, query_580070, nil, nil, nil)

var youtubeCaptionsDelete* = Call_YoutubeCaptionsDelete_580055(
    name: "youtubeCaptionsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/captions",
    validator: validate_YoutubeCaptionsDelete_580056, base: "/youtube/v3",
    url: url_YoutubeCaptionsDelete_580057, schemes: {Scheme.Https})
type
  Call_YoutubeCaptionsDownload_580071 = ref object of OpenApiRestCall_579437
proc url_YoutubeCaptionsDownload_580073(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/captions/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_YoutubeCaptionsDownload_580072(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Downloads a caption track. The caption track is returned in its original format unless the request specifies a value for the tfmt parameter and in its original language unless the request specifies a value for the tlang parameter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The id parameter identifies the caption track that is being retrieved. The value is a caption track ID as identified by the id property in a caption resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_580088 = path.getOrDefault("id")
  valid_580088 = validateParameter(valid_580088, JString, required = true,
                                 default = nil)
  if valid_580088 != nil:
    section.add "id", valid_580088
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   tfmt: JString
  ##       : The tfmt parameter specifies that the caption track should be returned in a specific format. If the parameter is not included in the request, the track is returned in its original format.
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
  ##   onBehalfOf: JString
  ##             : ID of the Google+ Page for the channel that the request is be on behalf of
  ##   tlang: JString
  ##        : The tlang parameter specifies that the API response should return a translation of the specified caption track. The parameter value is an ISO 639-1 two-letter language code that identifies the desired caption language. The translation is generated by using machine translation, such as Google Translate.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580089 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "onBehalfOfContentOwner", valid_580089
  var valid_580090 = query.getOrDefault("tfmt")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = newJString("sbv"))
  if valid_580090 != nil:
    section.add "tfmt", valid_580090
  var valid_580091 = query.getOrDefault("fields")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "fields", valid_580091
  var valid_580092 = query.getOrDefault("quotaUser")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "quotaUser", valid_580092
  var valid_580093 = query.getOrDefault("alt")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = newJString("json"))
  if valid_580093 != nil:
    section.add "alt", valid_580093
  var valid_580094 = query.getOrDefault("oauth_token")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "oauth_token", valid_580094
  var valid_580095 = query.getOrDefault("userIp")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "userIp", valid_580095
  var valid_580096 = query.getOrDefault("onBehalfOf")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "onBehalfOf", valid_580096
  var valid_580097 = query.getOrDefault("tlang")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "tlang", valid_580097
  var valid_580098 = query.getOrDefault("key")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "key", valid_580098
  var valid_580099 = query.getOrDefault("prettyPrint")
  valid_580099 = validateParameter(valid_580099, JBool, required = false,
                                 default = newJBool(true))
  if valid_580099 != nil:
    section.add "prettyPrint", valid_580099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580100: Call_YoutubeCaptionsDownload_580071; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Downloads a caption track. The caption track is returned in its original format unless the request specifies a value for the tfmt parameter and in its original language unless the request specifies a value for the tlang parameter.
  ## 
  let valid = call_580100.validator(path, query, header, formData, body)
  let scheme = call_580100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580100.url(scheme.get, call_580100.host, call_580100.base,
                         call_580100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580100, url, valid)

proc call*(call_580101: Call_YoutubeCaptionsDownload_580071; id: string;
          onBehalfOfContentOwner: string = ""; tfmt: string = "sbv";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; onBehalfOf: string = "";
          tlang: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## youtubeCaptionsDownload
  ## Downloads a caption track. The caption track is returned in its original format unless the request specifies a value for the tfmt parameter and in its original language unless the request specifies a value for the tlang parameter.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   tfmt: string
  ##       : The tfmt parameter specifies that the caption track should be returned in a specific format. If the parameter is not included in the request, the track is returned in its original format.
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
  ##   onBehalfOf: string
  ##             : ID of the Google+ Page for the channel that the request is be on behalf of
  ##   tlang: string
  ##        : The tlang parameter specifies that the API response should return a translation of the specified caption track. The parameter value is an ISO 639-1 two-letter language code that identifies the desired caption language. The translation is generated by using machine translation, such as Google Translate.
  ##   id: string (required)
  ##     : The id parameter identifies the caption track that is being retrieved. The value is a caption track ID as identified by the id property in a caption resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580102 = newJObject()
  var query_580103 = newJObject()
  add(query_580103, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580103, "tfmt", newJString(tfmt))
  add(query_580103, "fields", newJString(fields))
  add(query_580103, "quotaUser", newJString(quotaUser))
  add(query_580103, "alt", newJString(alt))
  add(query_580103, "oauth_token", newJString(oauthToken))
  add(query_580103, "userIp", newJString(userIp))
  add(query_580103, "onBehalfOf", newJString(onBehalfOf))
  add(query_580103, "tlang", newJString(tlang))
  add(path_580102, "id", newJString(id))
  add(query_580103, "key", newJString(key))
  add(query_580103, "prettyPrint", newJBool(prettyPrint))
  result = call_580101.call(path_580102, query_580103, nil, nil, nil)

var youtubeCaptionsDownload* = Call_YoutubeCaptionsDownload_580071(
    name: "youtubeCaptionsDownload", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/captions/{id}",
    validator: validate_YoutubeCaptionsDownload_580072, base: "/youtube/v3",
    url: url_YoutubeCaptionsDownload_580073, schemes: {Scheme.Https})
type
  Call_YoutubeChannelBannersInsert_580104 = ref object of OpenApiRestCall_579437
proc url_YoutubeChannelBannersInsert_580106(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeChannelBannersInsert_580105(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Uploads a channel banner image to YouTube. This method represents the first two steps in a three-step process to update the banner image for a channel:
  ## 
  ## - Call the channelBanners.insert method to upload the binary image data to YouTube. The image must have a 16:9 aspect ratio and be at least 2120x1192 pixels.
  ## - Extract the url property's value from the response that the API returns for step 1.
  ## - Call the channels.update method to update the channel's branding settings. Set the brandingSettings.image.bannerExternalUrl property's value to the URL obtained in step 2.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   channelId: JString
  ##            : The channelId parameter identifies the YouTube channel to which the banner is uploaded. The channelId parameter was introduced as a required parameter in May 2017. As this was a backward-incompatible change, channelBanners.insert requests that do not specify this parameter will not return an error until six months have passed from the time that the parameter was introduced. Please see the API Terms of Service for the official policy regarding backward incompatible changes and the API revision history for the exact date that the parameter was introduced.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580107 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "onBehalfOfContentOwner", valid_580107
  var valid_580108 = query.getOrDefault("fields")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "fields", valid_580108
  var valid_580109 = query.getOrDefault("quotaUser")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "quotaUser", valid_580109
  var valid_580110 = query.getOrDefault("alt")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = newJString("json"))
  if valid_580110 != nil:
    section.add "alt", valid_580110
  var valid_580111 = query.getOrDefault("oauth_token")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "oauth_token", valid_580111
  var valid_580112 = query.getOrDefault("userIp")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "userIp", valid_580112
  var valid_580113 = query.getOrDefault("channelId")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "channelId", valid_580113
  var valid_580114 = query.getOrDefault("key")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "key", valid_580114
  var valid_580115 = query.getOrDefault("prettyPrint")
  valid_580115 = validateParameter(valid_580115, JBool, required = false,
                                 default = newJBool(true))
  if valid_580115 != nil:
    section.add "prettyPrint", valid_580115
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

proc call*(call_580117: Call_YoutubeChannelBannersInsert_580104; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Uploads a channel banner image to YouTube. This method represents the first two steps in a three-step process to update the banner image for a channel:
  ## 
  ## - Call the channelBanners.insert method to upload the binary image data to YouTube. The image must have a 16:9 aspect ratio and be at least 2120x1192 pixels.
  ## - Extract the url property's value from the response that the API returns for step 1.
  ## - Call the channels.update method to update the channel's branding settings. Set the brandingSettings.image.bannerExternalUrl property's value to the URL obtained in step 2.
  ## 
  let valid = call_580117.validator(path, query, header, formData, body)
  let scheme = call_580117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580117.url(scheme.get, call_580117.host, call_580117.base,
                         call_580117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580117, url, valid)

proc call*(call_580118: Call_YoutubeChannelBannersInsert_580104;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; channelId: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## youtubeChannelBannersInsert
  ## Uploads a channel banner image to YouTube. This method represents the first two steps in a three-step process to update the banner image for a channel:
  ## 
  ## - Call the channelBanners.insert method to upload the binary image data to YouTube. The image must have a 16:9 aspect ratio and be at least 2120x1192 pixels.
  ## - Extract the url property's value from the response that the API returns for step 1.
  ## - Call the channels.update method to update the channel's branding settings. Set the brandingSettings.image.bannerExternalUrl property's value to the URL obtained in step 2.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   channelId: string
  ##            : The channelId parameter identifies the YouTube channel to which the banner is uploaded. The channelId parameter was introduced as a required parameter in May 2017. As this was a backward-incompatible change, channelBanners.insert requests that do not specify this parameter will not return an error until six months have passed from the time that the parameter was introduced. Please see the API Terms of Service for the official policy regarding backward incompatible changes and the API revision history for the exact date that the parameter was introduced.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580119 = newJObject()
  var body_580120 = newJObject()
  add(query_580119, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580119, "fields", newJString(fields))
  add(query_580119, "quotaUser", newJString(quotaUser))
  add(query_580119, "alt", newJString(alt))
  add(query_580119, "oauth_token", newJString(oauthToken))
  add(query_580119, "userIp", newJString(userIp))
  add(query_580119, "channelId", newJString(channelId))
  add(query_580119, "key", newJString(key))
  if body != nil:
    body_580120 = body
  add(query_580119, "prettyPrint", newJBool(prettyPrint))
  result = call_580118.call(nil, query_580119, nil, nil, body_580120)

var youtubeChannelBannersInsert* = Call_YoutubeChannelBannersInsert_580104(
    name: "youtubeChannelBannersInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/channelBanners/insert",
    validator: validate_YoutubeChannelBannersInsert_580105, base: "/youtube/v3",
    url: url_YoutubeChannelBannersInsert_580106, schemes: {Scheme.Https})
type
  Call_YoutubeChannelSectionsUpdate_580140 = ref object of OpenApiRestCall_579437
proc url_YoutubeChannelSectionsUpdate_580142(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeChannelSectionsUpdate_580141(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a channelSection.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part names that you can include in the parameter value are snippet and contentDetails.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580143 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "onBehalfOfContentOwner", valid_580143
  var valid_580144 = query.getOrDefault("fields")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "fields", valid_580144
  var valid_580145 = query.getOrDefault("quotaUser")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "quotaUser", valid_580145
  var valid_580146 = query.getOrDefault("alt")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = newJString("json"))
  if valid_580146 != nil:
    section.add "alt", valid_580146
  var valid_580147 = query.getOrDefault("oauth_token")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "oauth_token", valid_580147
  var valid_580148 = query.getOrDefault("userIp")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "userIp", valid_580148
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_580149 = query.getOrDefault("part")
  valid_580149 = validateParameter(valid_580149, JString, required = true,
                                 default = nil)
  if valid_580149 != nil:
    section.add "part", valid_580149
  var valid_580150 = query.getOrDefault("key")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "key", valid_580150
  var valid_580151 = query.getOrDefault("prettyPrint")
  valid_580151 = validateParameter(valid_580151, JBool, required = false,
                                 default = newJBool(true))
  if valid_580151 != nil:
    section.add "prettyPrint", valid_580151
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

proc call*(call_580153: Call_YoutubeChannelSectionsUpdate_580140; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a channelSection.
  ## 
  let valid = call_580153.validator(path, query, header, formData, body)
  let scheme = call_580153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580153.url(scheme.get, call_580153.host, call_580153.base,
                         call_580153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580153, url, valid)

proc call*(call_580154: Call_YoutubeChannelSectionsUpdate_580140; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## youtubeChannelSectionsUpdate
  ## Update a channelSection.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part names that you can include in the parameter value are snippet and contentDetails.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580155 = newJObject()
  var body_580156 = newJObject()
  add(query_580155, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580155, "fields", newJString(fields))
  add(query_580155, "quotaUser", newJString(quotaUser))
  add(query_580155, "alt", newJString(alt))
  add(query_580155, "oauth_token", newJString(oauthToken))
  add(query_580155, "userIp", newJString(userIp))
  add(query_580155, "part", newJString(part))
  add(query_580155, "key", newJString(key))
  if body != nil:
    body_580156 = body
  add(query_580155, "prettyPrint", newJBool(prettyPrint))
  result = call_580154.call(nil, query_580155, nil, nil, body_580156)

var youtubeChannelSectionsUpdate* = Call_YoutubeChannelSectionsUpdate_580140(
    name: "youtubeChannelSectionsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/channelSections",
    validator: validate_YoutubeChannelSectionsUpdate_580141, base: "/youtube/v3",
    url: url_YoutubeChannelSectionsUpdate_580142, schemes: {Scheme.Https})
type
  Call_YoutubeChannelSectionsInsert_580157 = ref object of OpenApiRestCall_579437
proc url_YoutubeChannelSectionsInsert_580159(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeChannelSectionsInsert_580158(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a channelSection for the authenticated user's channel.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part names that you can include in the parameter value are snippet and contentDetails.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  section = newJObject()
  var valid_580160 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "onBehalfOfContentOwner", valid_580160
  var valid_580161 = query.getOrDefault("fields")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "fields", valid_580161
  var valid_580162 = query.getOrDefault("quotaUser")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = nil)
  if valid_580162 != nil:
    section.add "quotaUser", valid_580162
  var valid_580163 = query.getOrDefault("alt")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = newJString("json"))
  if valid_580163 != nil:
    section.add "alt", valid_580163
  var valid_580164 = query.getOrDefault("oauth_token")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = nil)
  if valid_580164 != nil:
    section.add "oauth_token", valid_580164
  var valid_580165 = query.getOrDefault("userIp")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = nil)
  if valid_580165 != nil:
    section.add "userIp", valid_580165
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_580166 = query.getOrDefault("part")
  valid_580166 = validateParameter(valid_580166, JString, required = true,
                                 default = nil)
  if valid_580166 != nil:
    section.add "part", valid_580166
  var valid_580167 = query.getOrDefault("key")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "key", valid_580167
  var valid_580168 = query.getOrDefault("prettyPrint")
  valid_580168 = validateParameter(valid_580168, JBool, required = false,
                                 default = newJBool(true))
  if valid_580168 != nil:
    section.add "prettyPrint", valid_580168
  var valid_580169 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_580169
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

proc call*(call_580171: Call_YoutubeChannelSectionsInsert_580157; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a channelSection for the authenticated user's channel.
  ## 
  let valid = call_580171.validator(path, query, header, formData, body)
  let scheme = call_580171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580171.url(scheme.get, call_580171.host, call_580171.base,
                         call_580171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580171, url, valid)

proc call*(call_580172: Call_YoutubeChannelSectionsInsert_580157; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; onBehalfOfContentOwnerChannel: string = ""): Recallable =
  ## youtubeChannelSectionsInsert
  ## Adds a channelSection for the authenticated user's channel.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part names that you can include in the parameter value are snippet and contentDetails.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  var query_580173 = newJObject()
  var body_580174 = newJObject()
  add(query_580173, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580173, "fields", newJString(fields))
  add(query_580173, "quotaUser", newJString(quotaUser))
  add(query_580173, "alt", newJString(alt))
  add(query_580173, "oauth_token", newJString(oauthToken))
  add(query_580173, "userIp", newJString(userIp))
  add(query_580173, "part", newJString(part))
  add(query_580173, "key", newJString(key))
  if body != nil:
    body_580174 = body
  add(query_580173, "prettyPrint", newJBool(prettyPrint))
  add(query_580173, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  result = call_580172.call(nil, query_580173, nil, nil, body_580174)

var youtubeChannelSectionsInsert* = Call_YoutubeChannelSectionsInsert_580157(
    name: "youtubeChannelSectionsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/channelSections",
    validator: validate_YoutubeChannelSectionsInsert_580158, base: "/youtube/v3",
    url: url_YoutubeChannelSectionsInsert_580159, schemes: {Scheme.Https})
type
  Call_YoutubeChannelSectionsList_580121 = ref object of OpenApiRestCall_579437
proc url_YoutubeChannelSectionsList_580123(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeChannelSectionsList_580122(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns channelSection resources that match the API request criteria.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   mine: JBool
  ##       : Set this parameter's value to true to retrieve a feed of the authenticated user's channelSections.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of the YouTube channelSection ID(s) for the resource(s) that are being retrieved. In a channelSection resource, the id property specifies the YouTube channelSection ID.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more channelSection resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, and contentDetails.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a channelSection resource, the snippet property contains other properties, such as a display title for the channelSection. If you set part=snippet, the API response will also contain all of those nested properties.
  ##   channelId: JString
  ##            : The channelId parameter specifies a YouTube channel ID. The API will only return that channel's channelSections.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   hl: JString
  ##     : The hl parameter indicates that the snippet.localized property values in the returned channelSection resources should be in the specified language if localized values for that language are available. For example, if the API request specifies hl=de, the snippet.localized properties in the API response will contain German titles if German titles are available. Channel owners can provide localized channel section titles using either the channelSections.insert or channelSections.update method.
  section = newJObject()
  var valid_580124 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "onBehalfOfContentOwner", valid_580124
  var valid_580125 = query.getOrDefault("mine")
  valid_580125 = validateParameter(valid_580125, JBool, required = false, default = nil)
  if valid_580125 != nil:
    section.add "mine", valid_580125
  var valid_580126 = query.getOrDefault("fields")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "fields", valid_580126
  var valid_580127 = query.getOrDefault("quotaUser")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "quotaUser", valid_580127
  var valid_580128 = query.getOrDefault("id")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "id", valid_580128
  var valid_580129 = query.getOrDefault("alt")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = newJString("json"))
  if valid_580129 != nil:
    section.add "alt", valid_580129
  var valid_580130 = query.getOrDefault("oauth_token")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "oauth_token", valid_580130
  var valid_580131 = query.getOrDefault("userIp")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "userIp", valid_580131
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_580132 = query.getOrDefault("part")
  valid_580132 = validateParameter(valid_580132, JString, required = true,
                                 default = nil)
  if valid_580132 != nil:
    section.add "part", valid_580132
  var valid_580133 = query.getOrDefault("channelId")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "channelId", valid_580133
  var valid_580134 = query.getOrDefault("key")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "key", valid_580134
  var valid_580135 = query.getOrDefault("prettyPrint")
  valid_580135 = validateParameter(valid_580135, JBool, required = false,
                                 default = newJBool(true))
  if valid_580135 != nil:
    section.add "prettyPrint", valid_580135
  var valid_580136 = query.getOrDefault("hl")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "hl", valid_580136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580137: Call_YoutubeChannelSectionsList_580121; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns channelSection resources that match the API request criteria.
  ## 
  let valid = call_580137.validator(path, query, header, formData, body)
  let scheme = call_580137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580137.url(scheme.get, call_580137.host, call_580137.base,
                         call_580137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580137, url, valid)

proc call*(call_580138: Call_YoutubeChannelSectionsList_580121; part: string;
          onBehalfOfContentOwner: string = ""; mine: bool = false; fields: string = "";
          quotaUser: string = ""; id: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; channelId: string = "";
          key: string = ""; prettyPrint: bool = true; hl: string = ""): Recallable =
  ## youtubeChannelSectionsList
  ## Returns channelSection resources that match the API request criteria.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   mine: bool
  ##       : Set this parameter's value to true to retrieve a feed of the authenticated user's channelSections.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of the YouTube channelSection ID(s) for the resource(s) that are being retrieved. In a channelSection resource, the id property specifies the YouTube channelSection ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more channelSection resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, and contentDetails.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a channelSection resource, the snippet property contains other properties, such as a display title for the channelSection. If you set part=snippet, the API response will also contain all of those nested properties.
  ##   channelId: string
  ##            : The channelId parameter specifies a YouTube channel ID. The API will only return that channel's channelSections.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   hl: string
  ##     : The hl parameter indicates that the snippet.localized property values in the returned channelSection resources should be in the specified language if localized values for that language are available. For example, if the API request specifies hl=de, the snippet.localized properties in the API response will contain German titles if German titles are available. Channel owners can provide localized channel section titles using either the channelSections.insert or channelSections.update method.
  var query_580139 = newJObject()
  add(query_580139, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580139, "mine", newJBool(mine))
  add(query_580139, "fields", newJString(fields))
  add(query_580139, "quotaUser", newJString(quotaUser))
  add(query_580139, "id", newJString(id))
  add(query_580139, "alt", newJString(alt))
  add(query_580139, "oauth_token", newJString(oauthToken))
  add(query_580139, "userIp", newJString(userIp))
  add(query_580139, "part", newJString(part))
  add(query_580139, "channelId", newJString(channelId))
  add(query_580139, "key", newJString(key))
  add(query_580139, "prettyPrint", newJBool(prettyPrint))
  add(query_580139, "hl", newJString(hl))
  result = call_580138.call(nil, query_580139, nil, nil, nil)

var youtubeChannelSectionsList* = Call_YoutubeChannelSectionsList_580121(
    name: "youtubeChannelSectionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/channelSections",
    validator: validate_YoutubeChannelSectionsList_580122, base: "/youtube/v3",
    url: url_YoutubeChannelSectionsList_580123, schemes: {Scheme.Https})
type
  Call_YoutubeChannelSectionsDelete_580175 = ref object of OpenApiRestCall_579437
proc url_YoutubeChannelSectionsDelete_580177(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeChannelSectionsDelete_580176(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a channelSection.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the YouTube channelSection ID for the resource that is being deleted. In a channelSection resource, the id property specifies the YouTube channelSection ID.
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
  var valid_580178 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "onBehalfOfContentOwner", valid_580178
  var valid_580179 = query.getOrDefault("fields")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = nil)
  if valid_580179 != nil:
    section.add "fields", valid_580179
  var valid_580180 = query.getOrDefault("quotaUser")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = nil)
  if valid_580180 != nil:
    section.add "quotaUser", valid_580180
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_580181 = query.getOrDefault("id")
  valid_580181 = validateParameter(valid_580181, JString, required = true,
                                 default = nil)
  if valid_580181 != nil:
    section.add "id", valid_580181
  var valid_580182 = query.getOrDefault("alt")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = newJString("json"))
  if valid_580182 != nil:
    section.add "alt", valid_580182
  var valid_580183 = query.getOrDefault("oauth_token")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = nil)
  if valid_580183 != nil:
    section.add "oauth_token", valid_580183
  var valid_580184 = query.getOrDefault("userIp")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "userIp", valid_580184
  var valid_580185 = query.getOrDefault("key")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "key", valid_580185
  var valid_580186 = query.getOrDefault("prettyPrint")
  valid_580186 = validateParameter(valid_580186, JBool, required = false,
                                 default = newJBool(true))
  if valid_580186 != nil:
    section.add "prettyPrint", valid_580186
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580187: Call_YoutubeChannelSectionsDelete_580175; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a channelSection.
  ## 
  let valid = call_580187.validator(path, query, header, formData, body)
  let scheme = call_580187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580187.url(scheme.get, call_580187.host, call_580187.base,
                         call_580187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580187, url, valid)

proc call*(call_580188: Call_YoutubeChannelSectionsDelete_580175; id: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## youtubeChannelSectionsDelete
  ## Deletes a channelSection.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the YouTube channelSection ID for the resource that is being deleted. In a channelSection resource, the id property specifies the YouTube channelSection ID.
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
  var query_580189 = newJObject()
  add(query_580189, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580189, "fields", newJString(fields))
  add(query_580189, "quotaUser", newJString(quotaUser))
  add(query_580189, "id", newJString(id))
  add(query_580189, "alt", newJString(alt))
  add(query_580189, "oauth_token", newJString(oauthToken))
  add(query_580189, "userIp", newJString(userIp))
  add(query_580189, "key", newJString(key))
  add(query_580189, "prettyPrint", newJBool(prettyPrint))
  result = call_580188.call(nil, query_580189, nil, nil, nil)

var youtubeChannelSectionsDelete* = Call_YoutubeChannelSectionsDelete_580175(
    name: "youtubeChannelSectionsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/channelSections",
    validator: validate_YoutubeChannelSectionsDelete_580176, base: "/youtube/v3",
    url: url_YoutubeChannelSectionsDelete_580177, schemes: {Scheme.Https})
type
  Call_YoutubeChannelsUpdate_580214 = ref object of OpenApiRestCall_579437
proc url_YoutubeChannelsUpdate_580216(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeChannelsUpdate_580215(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a channel's metadata. Note that this method currently only supports updates to the channel resource's brandingSettings and invideoPromotion objects and their child properties.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : The onBehalfOfContentOwner parameter indicates that the authenticated user is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with needs to be linked to the specified YouTube content owner.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The API currently only allows the parameter value to be set to either brandingSettings or invideoPromotion. (You cannot update both of those parts with a single request.)
  ## 
  ## Note that this method overrides the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580217 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = nil)
  if valid_580217 != nil:
    section.add "onBehalfOfContentOwner", valid_580217
  var valid_580218 = query.getOrDefault("fields")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = nil)
  if valid_580218 != nil:
    section.add "fields", valid_580218
  var valid_580219 = query.getOrDefault("quotaUser")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = nil)
  if valid_580219 != nil:
    section.add "quotaUser", valid_580219
  var valid_580220 = query.getOrDefault("alt")
  valid_580220 = validateParameter(valid_580220, JString, required = false,
                                 default = newJString("json"))
  if valid_580220 != nil:
    section.add "alt", valid_580220
  var valid_580221 = query.getOrDefault("oauth_token")
  valid_580221 = validateParameter(valid_580221, JString, required = false,
                                 default = nil)
  if valid_580221 != nil:
    section.add "oauth_token", valid_580221
  var valid_580222 = query.getOrDefault("userIp")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = nil)
  if valid_580222 != nil:
    section.add "userIp", valid_580222
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_580223 = query.getOrDefault("part")
  valid_580223 = validateParameter(valid_580223, JString, required = true,
                                 default = nil)
  if valid_580223 != nil:
    section.add "part", valid_580223
  var valid_580224 = query.getOrDefault("key")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = nil)
  if valid_580224 != nil:
    section.add "key", valid_580224
  var valid_580225 = query.getOrDefault("prettyPrint")
  valid_580225 = validateParameter(valid_580225, JBool, required = false,
                                 default = newJBool(true))
  if valid_580225 != nil:
    section.add "prettyPrint", valid_580225
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

proc call*(call_580227: Call_YoutubeChannelsUpdate_580214; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a channel's metadata. Note that this method currently only supports updates to the channel resource's brandingSettings and invideoPromotion objects and their child properties.
  ## 
  let valid = call_580227.validator(path, query, header, formData, body)
  let scheme = call_580227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580227.url(scheme.get, call_580227.host, call_580227.base,
                         call_580227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580227, url, valid)

proc call*(call_580228: Call_YoutubeChannelsUpdate_580214; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## youtubeChannelsUpdate
  ## Updates a channel's metadata. Note that this method currently only supports updates to the channel resource's brandingSettings and invideoPromotion objects and their child properties.
  ##   onBehalfOfContentOwner: string
  ##                         : The onBehalfOfContentOwner parameter indicates that the authenticated user is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with needs to be linked to the specified YouTube content owner.
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
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The API currently only allows the parameter value to be set to either brandingSettings or invideoPromotion. (You cannot update both of those parts with a single request.)
  ## 
  ## Note that this method overrides the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580229 = newJObject()
  var body_580230 = newJObject()
  add(query_580229, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580229, "fields", newJString(fields))
  add(query_580229, "quotaUser", newJString(quotaUser))
  add(query_580229, "alt", newJString(alt))
  add(query_580229, "oauth_token", newJString(oauthToken))
  add(query_580229, "userIp", newJString(userIp))
  add(query_580229, "part", newJString(part))
  add(query_580229, "key", newJString(key))
  if body != nil:
    body_580230 = body
  add(query_580229, "prettyPrint", newJBool(prettyPrint))
  result = call_580228.call(nil, query_580229, nil, nil, body_580230)

var youtubeChannelsUpdate* = Call_YoutubeChannelsUpdate_580214(
    name: "youtubeChannelsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/channels",
    validator: validate_YoutubeChannelsUpdate_580215, base: "/youtube/v3",
    url: url_YoutubeChannelsUpdate_580216, schemes: {Scheme.Https})
type
  Call_YoutubeChannelsList_580190 = ref object of OpenApiRestCall_579437
proc url_YoutubeChannelsList_580192(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeChannelsList_580191(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Returns a collection of zero or more channel resources that match the request criteria.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   mine: JBool
  ##       : Set this parameter's value to true to instruct the API to only return channels owned by the authenticated user.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of the YouTube channel ID(s) for the resource(s) that are being retrieved. In a channel resource, the id property specifies the channel's YouTube channel ID.
  ##   alt: JString
  ##      : Data format for the response.
  ##   mySubscribers: JBool
  ##                : Use the subscriptions.list method and its mySubscribers parameter to retrieve a list of subscribers to the authenticated user's channel.
  ##   forUsername: JString
  ##              : The forUsername parameter specifies a YouTube username, thereby requesting the channel associated with that username.
  ##   categoryId: JString
  ##             : The categoryId parameter specifies a YouTube guide category, thereby requesting YouTube channels associated with that category.
  ##   managedByMe: JBool
  ##              : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## Set this parameter's value to true to instruct the API to only return channels managed by the content owner that the onBehalfOfContentOwner parameter specifies. The user must be authenticated as a CMS account linked to the specified content owner and onBehalfOfContentOwner must be provided.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more channel resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a channel resource, the contentDetails property contains other properties, such as the uploads properties. As such, if you set part=contentDetails, the API response will also contain all of those nested properties.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   hl: JString
  ##     : The hl parameter should be used for filter out the properties that are not in the given language. Used for the brandingSettings part.
  section = newJObject()
  var valid_580193 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = nil)
  if valid_580193 != nil:
    section.add "onBehalfOfContentOwner", valid_580193
  var valid_580194 = query.getOrDefault("mine")
  valid_580194 = validateParameter(valid_580194, JBool, required = false, default = nil)
  if valid_580194 != nil:
    section.add "mine", valid_580194
  var valid_580195 = query.getOrDefault("fields")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "fields", valid_580195
  var valid_580196 = query.getOrDefault("pageToken")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = nil)
  if valid_580196 != nil:
    section.add "pageToken", valid_580196
  var valid_580197 = query.getOrDefault("quotaUser")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = nil)
  if valid_580197 != nil:
    section.add "quotaUser", valid_580197
  var valid_580198 = query.getOrDefault("id")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = nil)
  if valid_580198 != nil:
    section.add "id", valid_580198
  var valid_580199 = query.getOrDefault("alt")
  valid_580199 = validateParameter(valid_580199, JString, required = false,
                                 default = newJString("json"))
  if valid_580199 != nil:
    section.add "alt", valid_580199
  var valid_580200 = query.getOrDefault("mySubscribers")
  valid_580200 = validateParameter(valid_580200, JBool, required = false, default = nil)
  if valid_580200 != nil:
    section.add "mySubscribers", valid_580200
  var valid_580201 = query.getOrDefault("forUsername")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = nil)
  if valid_580201 != nil:
    section.add "forUsername", valid_580201
  var valid_580202 = query.getOrDefault("categoryId")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = nil)
  if valid_580202 != nil:
    section.add "categoryId", valid_580202
  var valid_580203 = query.getOrDefault("managedByMe")
  valid_580203 = validateParameter(valid_580203, JBool, required = false, default = nil)
  if valid_580203 != nil:
    section.add "managedByMe", valid_580203
  var valid_580204 = query.getOrDefault("oauth_token")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = nil)
  if valid_580204 != nil:
    section.add "oauth_token", valid_580204
  var valid_580205 = query.getOrDefault("userIp")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "userIp", valid_580205
  var valid_580206 = query.getOrDefault("maxResults")
  valid_580206 = validateParameter(valid_580206, JInt, required = false,
                                 default = newJInt(5))
  if valid_580206 != nil:
    section.add "maxResults", valid_580206
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_580207 = query.getOrDefault("part")
  valid_580207 = validateParameter(valid_580207, JString, required = true,
                                 default = nil)
  if valid_580207 != nil:
    section.add "part", valid_580207
  var valid_580208 = query.getOrDefault("key")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "key", valid_580208
  var valid_580209 = query.getOrDefault("prettyPrint")
  valid_580209 = validateParameter(valid_580209, JBool, required = false,
                                 default = newJBool(true))
  if valid_580209 != nil:
    section.add "prettyPrint", valid_580209
  var valid_580210 = query.getOrDefault("hl")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "hl", valid_580210
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580211: Call_YoutubeChannelsList_580190; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of zero or more channel resources that match the request criteria.
  ## 
  let valid = call_580211.validator(path, query, header, formData, body)
  let scheme = call_580211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580211.url(scheme.get, call_580211.host, call_580211.base,
                         call_580211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580211, url, valid)

proc call*(call_580212: Call_YoutubeChannelsList_580190; part: string;
          onBehalfOfContentOwner: string = ""; mine: bool = false; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; id: string = "";
          alt: string = "json"; mySubscribers: bool = false; forUsername: string = "";
          categoryId: string = ""; managedByMe: bool = false; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 5; key: string = "";
          prettyPrint: bool = true; hl: string = ""): Recallable =
  ## youtubeChannelsList
  ## Returns a collection of zero or more channel resources that match the request criteria.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   mine: bool
  ##       : Set this parameter's value to true to instruct the API to only return channels owned by the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of the YouTube channel ID(s) for the resource(s) that are being retrieved. In a channel resource, the id property specifies the channel's YouTube channel ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   mySubscribers: bool
  ##                : Use the subscriptions.list method and its mySubscribers parameter to retrieve a list of subscribers to the authenticated user's channel.
  ##   forUsername: string
  ##              : The forUsername parameter specifies a YouTube username, thereby requesting the channel associated with that username.
  ##   categoryId: string
  ##             : The categoryId parameter specifies a YouTube guide category, thereby requesting YouTube channels associated with that category.
  ##   managedByMe: bool
  ##              : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## Set this parameter's value to true to instruct the API to only return channels managed by the content owner that the onBehalfOfContentOwner parameter specifies. The user must be authenticated as a CMS account linked to the specified content owner and onBehalfOfContentOwner must be provided.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more channel resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a channel resource, the contentDetails property contains other properties, such as the uploads properties. As such, if you set part=contentDetails, the API response will also contain all of those nested properties.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   hl: string
  ##     : The hl parameter should be used for filter out the properties that are not in the given language. Used for the brandingSettings part.
  var query_580213 = newJObject()
  add(query_580213, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580213, "mine", newJBool(mine))
  add(query_580213, "fields", newJString(fields))
  add(query_580213, "pageToken", newJString(pageToken))
  add(query_580213, "quotaUser", newJString(quotaUser))
  add(query_580213, "id", newJString(id))
  add(query_580213, "alt", newJString(alt))
  add(query_580213, "mySubscribers", newJBool(mySubscribers))
  add(query_580213, "forUsername", newJString(forUsername))
  add(query_580213, "categoryId", newJString(categoryId))
  add(query_580213, "managedByMe", newJBool(managedByMe))
  add(query_580213, "oauth_token", newJString(oauthToken))
  add(query_580213, "userIp", newJString(userIp))
  add(query_580213, "maxResults", newJInt(maxResults))
  add(query_580213, "part", newJString(part))
  add(query_580213, "key", newJString(key))
  add(query_580213, "prettyPrint", newJBool(prettyPrint))
  add(query_580213, "hl", newJString(hl))
  result = call_580212.call(nil, query_580213, nil, nil, nil)

var youtubeChannelsList* = Call_YoutubeChannelsList_580190(
    name: "youtubeChannelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/channels",
    validator: validate_YoutubeChannelsList_580191, base: "/youtube/v3",
    url: url_YoutubeChannelsList_580192, schemes: {Scheme.Https})
type
  Call_YoutubeCommentThreadsUpdate_580255 = ref object of OpenApiRestCall_579437
proc url_YoutubeCommentThreadsUpdate_580257(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeCommentThreadsUpdate_580256(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modifies the top-level comment in a comment thread.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of commentThread resource properties that the API response will include. You must at least include the snippet part in the parameter value since that part contains all of the properties that the API request can update.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580258 = query.getOrDefault("fields")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = nil)
  if valid_580258 != nil:
    section.add "fields", valid_580258
  var valid_580259 = query.getOrDefault("quotaUser")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = nil)
  if valid_580259 != nil:
    section.add "quotaUser", valid_580259
  var valid_580260 = query.getOrDefault("alt")
  valid_580260 = validateParameter(valid_580260, JString, required = false,
                                 default = newJString("json"))
  if valid_580260 != nil:
    section.add "alt", valid_580260
  var valid_580261 = query.getOrDefault("oauth_token")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = nil)
  if valid_580261 != nil:
    section.add "oauth_token", valid_580261
  var valid_580262 = query.getOrDefault("userIp")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = nil)
  if valid_580262 != nil:
    section.add "userIp", valid_580262
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_580263 = query.getOrDefault("part")
  valid_580263 = validateParameter(valid_580263, JString, required = true,
                                 default = nil)
  if valid_580263 != nil:
    section.add "part", valid_580263
  var valid_580264 = query.getOrDefault("key")
  valid_580264 = validateParameter(valid_580264, JString, required = false,
                                 default = nil)
  if valid_580264 != nil:
    section.add "key", valid_580264
  var valid_580265 = query.getOrDefault("prettyPrint")
  valid_580265 = validateParameter(valid_580265, JBool, required = false,
                                 default = newJBool(true))
  if valid_580265 != nil:
    section.add "prettyPrint", valid_580265
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

proc call*(call_580267: Call_YoutubeCommentThreadsUpdate_580255; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies the top-level comment in a comment thread.
  ## 
  let valid = call_580267.validator(path, query, header, formData, body)
  let scheme = call_580267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580267.url(scheme.get, call_580267.host, call_580267.base,
                         call_580267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580267, url, valid)

proc call*(call_580268: Call_YoutubeCommentThreadsUpdate_580255; part: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## youtubeCommentThreadsUpdate
  ## Modifies the top-level comment in a comment thread.
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
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of commentThread resource properties that the API response will include. You must at least include the snippet part in the parameter value since that part contains all of the properties that the API request can update.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580269 = newJObject()
  var body_580270 = newJObject()
  add(query_580269, "fields", newJString(fields))
  add(query_580269, "quotaUser", newJString(quotaUser))
  add(query_580269, "alt", newJString(alt))
  add(query_580269, "oauth_token", newJString(oauthToken))
  add(query_580269, "userIp", newJString(userIp))
  add(query_580269, "part", newJString(part))
  add(query_580269, "key", newJString(key))
  if body != nil:
    body_580270 = body
  add(query_580269, "prettyPrint", newJBool(prettyPrint))
  result = call_580268.call(nil, query_580269, nil, nil, body_580270)

var youtubeCommentThreadsUpdate* = Call_YoutubeCommentThreadsUpdate_580255(
    name: "youtubeCommentThreadsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/commentThreads",
    validator: validate_YoutubeCommentThreadsUpdate_580256, base: "/youtube/v3",
    url: url_YoutubeCommentThreadsUpdate_580257, schemes: {Scheme.Https})
type
  Call_YoutubeCommentThreadsInsert_580271 = ref object of OpenApiRestCall_579437
proc url_YoutubeCommentThreadsInsert_580273(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeCommentThreadsInsert_580272(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new top-level comment. To add a reply to an existing comment, use the comments.insert method instead.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  ##   part: JString (required)
  ##       : The part parameter identifies the properties that the API response will include. Set the parameter value to snippet. The snippet part has a quota cost of 2 units.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580274 = query.getOrDefault("fields")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = nil)
  if valid_580274 != nil:
    section.add "fields", valid_580274
  var valid_580275 = query.getOrDefault("quotaUser")
  valid_580275 = validateParameter(valid_580275, JString, required = false,
                                 default = nil)
  if valid_580275 != nil:
    section.add "quotaUser", valid_580275
  var valid_580276 = query.getOrDefault("alt")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = newJString("json"))
  if valid_580276 != nil:
    section.add "alt", valid_580276
  var valid_580277 = query.getOrDefault("oauth_token")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = nil)
  if valid_580277 != nil:
    section.add "oauth_token", valid_580277
  var valid_580278 = query.getOrDefault("userIp")
  valid_580278 = validateParameter(valid_580278, JString, required = false,
                                 default = nil)
  if valid_580278 != nil:
    section.add "userIp", valid_580278
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_580279 = query.getOrDefault("part")
  valid_580279 = validateParameter(valid_580279, JString, required = true,
                                 default = nil)
  if valid_580279 != nil:
    section.add "part", valid_580279
  var valid_580280 = query.getOrDefault("key")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = nil)
  if valid_580280 != nil:
    section.add "key", valid_580280
  var valid_580281 = query.getOrDefault("prettyPrint")
  valid_580281 = validateParameter(valid_580281, JBool, required = false,
                                 default = newJBool(true))
  if valid_580281 != nil:
    section.add "prettyPrint", valid_580281
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

proc call*(call_580283: Call_YoutubeCommentThreadsInsert_580271; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new top-level comment. To add a reply to an existing comment, use the comments.insert method instead.
  ## 
  let valid = call_580283.validator(path, query, header, formData, body)
  let scheme = call_580283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580283.url(scheme.get, call_580283.host, call_580283.base,
                         call_580283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580283, url, valid)

proc call*(call_580284: Call_YoutubeCommentThreadsInsert_580271; part: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## youtubeCommentThreadsInsert
  ## Creates a new top-level comment. To add a reply to an existing comment, use the comments.insert method instead.
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
  ##   part: string (required)
  ##       : The part parameter identifies the properties that the API response will include. Set the parameter value to snippet. The snippet part has a quota cost of 2 units.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580285 = newJObject()
  var body_580286 = newJObject()
  add(query_580285, "fields", newJString(fields))
  add(query_580285, "quotaUser", newJString(quotaUser))
  add(query_580285, "alt", newJString(alt))
  add(query_580285, "oauth_token", newJString(oauthToken))
  add(query_580285, "userIp", newJString(userIp))
  add(query_580285, "part", newJString(part))
  add(query_580285, "key", newJString(key))
  if body != nil:
    body_580286 = body
  add(query_580285, "prettyPrint", newJBool(prettyPrint))
  result = call_580284.call(nil, query_580285, nil, nil, body_580286)

var youtubeCommentThreadsInsert* = Call_YoutubeCommentThreadsInsert_580271(
    name: "youtubeCommentThreadsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/commentThreads",
    validator: validate_YoutubeCommentThreadsInsert_580272, base: "/youtube/v3",
    url: url_YoutubeCommentThreadsInsert_580273, schemes: {Scheme.Https})
type
  Call_YoutubeCommentThreadsList_580231 = ref object of OpenApiRestCall_579437
proc url_YoutubeCommentThreadsList_580233(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeCommentThreadsList_580232(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of comment threads that match the API request parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   textFormat: JString
  ##             : Set this parameter's value to html or plainText to instruct the API to return the comments left by users in html formatted or in plain text.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken property identifies the next page of the result that can be retrieved.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of comment thread IDs for the resources that should be retrieved.
  ##   alt: JString
  ##      : Data format for the response.
  ##   order: JString
  ##        : The order parameter specifies the order in which the API response should list comment threads. Valid values are: 
  ## - time - Comment threads are ordered by time. This is the default behavior.
  ## - relevance - Comment threads are ordered by relevance.Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   videoId: JString
  ##          : The videoId parameter instructs the API to return comment threads associated with the specified video ID.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more commentThread resource properties that the API response will include.
  ##   channelId: JString
  ##            : The channelId parameter instructs the API to return comment threads containing comments about the specified channel. (The response will not include comments left on videos that the channel uploaded.)
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   moderationStatus: JString
  ##                   : Set this parameter to limit the returned comment threads to a particular moderation state.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   allThreadsRelatedToChannelId: JString
  ##                               : The allThreadsRelatedToChannelId parameter instructs the API to return all comment threads associated with the specified channel. The response can include comments about the channel or about the channel's videos.
  ##   searchTerms: JString
  ##              : The searchTerms parameter instructs the API to limit the API response to only contain comments that contain the specified search terms.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  section = newJObject()
  var valid_580234 = query.getOrDefault("textFormat")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = newJString("html"))
  if valid_580234 != nil:
    section.add "textFormat", valid_580234
  var valid_580235 = query.getOrDefault("fields")
  valid_580235 = validateParameter(valid_580235, JString, required = false,
                                 default = nil)
  if valid_580235 != nil:
    section.add "fields", valid_580235
  var valid_580236 = query.getOrDefault("pageToken")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = nil)
  if valid_580236 != nil:
    section.add "pageToken", valid_580236
  var valid_580237 = query.getOrDefault("quotaUser")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = nil)
  if valid_580237 != nil:
    section.add "quotaUser", valid_580237
  var valid_580238 = query.getOrDefault("id")
  valid_580238 = validateParameter(valid_580238, JString, required = false,
                                 default = nil)
  if valid_580238 != nil:
    section.add "id", valid_580238
  var valid_580239 = query.getOrDefault("alt")
  valid_580239 = validateParameter(valid_580239, JString, required = false,
                                 default = newJString("json"))
  if valid_580239 != nil:
    section.add "alt", valid_580239
  var valid_580240 = query.getOrDefault("order")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = newJString("relevance"))
  if valid_580240 != nil:
    section.add "order", valid_580240
  var valid_580241 = query.getOrDefault("oauth_token")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = nil)
  if valid_580241 != nil:
    section.add "oauth_token", valid_580241
  var valid_580242 = query.getOrDefault("userIp")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = nil)
  if valid_580242 != nil:
    section.add "userIp", valid_580242
  var valid_580243 = query.getOrDefault("videoId")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = nil)
  if valid_580243 != nil:
    section.add "videoId", valid_580243
  var valid_580244 = query.getOrDefault("maxResults")
  valid_580244 = validateParameter(valid_580244, JInt, required = false,
                                 default = newJInt(20))
  if valid_580244 != nil:
    section.add "maxResults", valid_580244
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_580245 = query.getOrDefault("part")
  valid_580245 = validateParameter(valid_580245, JString, required = true,
                                 default = nil)
  if valid_580245 != nil:
    section.add "part", valid_580245
  var valid_580246 = query.getOrDefault("channelId")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "channelId", valid_580246
  var valid_580247 = query.getOrDefault("key")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = nil)
  if valid_580247 != nil:
    section.add "key", valid_580247
  var valid_580248 = query.getOrDefault("moderationStatus")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = newJString("published"))
  if valid_580248 != nil:
    section.add "moderationStatus", valid_580248
  var valid_580249 = query.getOrDefault("prettyPrint")
  valid_580249 = validateParameter(valid_580249, JBool, required = false,
                                 default = newJBool(true))
  if valid_580249 != nil:
    section.add "prettyPrint", valid_580249
  var valid_580250 = query.getOrDefault("allThreadsRelatedToChannelId")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = nil)
  if valid_580250 != nil:
    section.add "allThreadsRelatedToChannelId", valid_580250
  var valid_580251 = query.getOrDefault("searchTerms")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = nil)
  if valid_580251 != nil:
    section.add "searchTerms", valid_580251
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580252: Call_YoutubeCommentThreadsList_580231; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of comment threads that match the API request parameters.
  ## 
  let valid = call_580252.validator(path, query, header, formData, body)
  let scheme = call_580252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580252.url(scheme.get, call_580252.host, call_580252.base,
                         call_580252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580252, url, valid)

proc call*(call_580253: Call_YoutubeCommentThreadsList_580231; part: string;
          textFormat: string = "html"; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; id: string = ""; alt: string = "json";
          order: string = "relevance"; oauthToken: string = ""; userIp: string = "";
          videoId: string = ""; maxResults: int = 20; channelId: string = "";
          key: string = ""; moderationStatus: string = "published";
          prettyPrint: bool = true; allThreadsRelatedToChannelId: string = "";
          searchTerms: string = ""): Recallable =
  ## youtubeCommentThreadsList
  ## Returns a list of comment threads that match the API request parameters.
  ##   textFormat: string
  ##             : Set this parameter's value to html or plainText to instruct the API to return the comments left by users in html formatted or in plain text.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken property identifies the next page of the result that can be retrieved.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of comment thread IDs for the resources that should be retrieved.
  ##   alt: string
  ##      : Data format for the response.
  ##   order: string
  ##        : The order parameter specifies the order in which the API response should list comment threads. Valid values are: 
  ## - time - Comment threads are ordered by time. This is the default behavior.
  ## - relevance - Comment threads are ordered by relevance.Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   videoId: string
  ##          : The videoId parameter instructs the API to return comment threads associated with the specified video ID.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more commentThread resource properties that the API response will include.
  ##   channelId: string
  ##            : The channelId parameter instructs the API to return comment threads containing comments about the specified channel. (The response will not include comments left on videos that the channel uploaded.)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   moderationStatus: string
  ##                   : Set this parameter to limit the returned comment threads to a particular moderation state.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   allThreadsRelatedToChannelId: string
  ##                               : The allThreadsRelatedToChannelId parameter instructs the API to return all comment threads associated with the specified channel. The response can include comments about the channel or about the channel's videos.
  ##   searchTerms: string
  ##              : The searchTerms parameter instructs the API to limit the API response to only contain comments that contain the specified search terms.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  var query_580254 = newJObject()
  add(query_580254, "textFormat", newJString(textFormat))
  add(query_580254, "fields", newJString(fields))
  add(query_580254, "pageToken", newJString(pageToken))
  add(query_580254, "quotaUser", newJString(quotaUser))
  add(query_580254, "id", newJString(id))
  add(query_580254, "alt", newJString(alt))
  add(query_580254, "order", newJString(order))
  add(query_580254, "oauth_token", newJString(oauthToken))
  add(query_580254, "userIp", newJString(userIp))
  add(query_580254, "videoId", newJString(videoId))
  add(query_580254, "maxResults", newJInt(maxResults))
  add(query_580254, "part", newJString(part))
  add(query_580254, "channelId", newJString(channelId))
  add(query_580254, "key", newJString(key))
  add(query_580254, "moderationStatus", newJString(moderationStatus))
  add(query_580254, "prettyPrint", newJBool(prettyPrint))
  add(query_580254, "allThreadsRelatedToChannelId",
      newJString(allThreadsRelatedToChannelId))
  add(query_580254, "searchTerms", newJString(searchTerms))
  result = call_580253.call(nil, query_580254, nil, nil, nil)

var youtubeCommentThreadsList* = Call_YoutubeCommentThreadsList_580231(
    name: "youtubeCommentThreadsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/commentThreads",
    validator: validate_YoutubeCommentThreadsList_580232, base: "/youtube/v3",
    url: url_YoutubeCommentThreadsList_580233, schemes: {Scheme.Https})
type
  Call_YoutubeCommentsUpdate_580306 = ref object of OpenApiRestCall_579437
proc url_YoutubeCommentsUpdate_580308(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeCommentsUpdate_580307(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modifies a comment.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  ##   part: JString (required)
  ##       : The part parameter identifies the properties that the API response will include. You must at least include the snippet part in the parameter value since that part contains all of the properties that the API request can update.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580309 = query.getOrDefault("fields")
  valid_580309 = validateParameter(valid_580309, JString, required = false,
                                 default = nil)
  if valid_580309 != nil:
    section.add "fields", valid_580309
  var valid_580310 = query.getOrDefault("quotaUser")
  valid_580310 = validateParameter(valid_580310, JString, required = false,
                                 default = nil)
  if valid_580310 != nil:
    section.add "quotaUser", valid_580310
  var valid_580311 = query.getOrDefault("alt")
  valid_580311 = validateParameter(valid_580311, JString, required = false,
                                 default = newJString("json"))
  if valid_580311 != nil:
    section.add "alt", valid_580311
  var valid_580312 = query.getOrDefault("oauth_token")
  valid_580312 = validateParameter(valid_580312, JString, required = false,
                                 default = nil)
  if valid_580312 != nil:
    section.add "oauth_token", valid_580312
  var valid_580313 = query.getOrDefault("userIp")
  valid_580313 = validateParameter(valid_580313, JString, required = false,
                                 default = nil)
  if valid_580313 != nil:
    section.add "userIp", valid_580313
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_580314 = query.getOrDefault("part")
  valid_580314 = validateParameter(valid_580314, JString, required = true,
                                 default = nil)
  if valid_580314 != nil:
    section.add "part", valid_580314
  var valid_580315 = query.getOrDefault("key")
  valid_580315 = validateParameter(valid_580315, JString, required = false,
                                 default = nil)
  if valid_580315 != nil:
    section.add "key", valid_580315
  var valid_580316 = query.getOrDefault("prettyPrint")
  valid_580316 = validateParameter(valid_580316, JBool, required = false,
                                 default = newJBool(true))
  if valid_580316 != nil:
    section.add "prettyPrint", valid_580316
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

proc call*(call_580318: Call_YoutubeCommentsUpdate_580306; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies a comment.
  ## 
  let valid = call_580318.validator(path, query, header, formData, body)
  let scheme = call_580318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580318.url(scheme.get, call_580318.host, call_580318.base,
                         call_580318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580318, url, valid)

proc call*(call_580319: Call_YoutubeCommentsUpdate_580306; part: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## youtubeCommentsUpdate
  ## Modifies a comment.
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
  ##   part: string (required)
  ##       : The part parameter identifies the properties that the API response will include. You must at least include the snippet part in the parameter value since that part contains all of the properties that the API request can update.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580320 = newJObject()
  var body_580321 = newJObject()
  add(query_580320, "fields", newJString(fields))
  add(query_580320, "quotaUser", newJString(quotaUser))
  add(query_580320, "alt", newJString(alt))
  add(query_580320, "oauth_token", newJString(oauthToken))
  add(query_580320, "userIp", newJString(userIp))
  add(query_580320, "part", newJString(part))
  add(query_580320, "key", newJString(key))
  if body != nil:
    body_580321 = body
  add(query_580320, "prettyPrint", newJBool(prettyPrint))
  result = call_580319.call(nil, query_580320, nil, nil, body_580321)

var youtubeCommentsUpdate* = Call_YoutubeCommentsUpdate_580306(
    name: "youtubeCommentsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/comments",
    validator: validate_YoutubeCommentsUpdate_580307, base: "/youtube/v3",
    url: url_YoutubeCommentsUpdate_580308, schemes: {Scheme.Https})
type
  Call_YoutubeCommentsInsert_580322 = ref object of OpenApiRestCall_579437
proc url_YoutubeCommentsInsert_580324(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeCommentsInsert_580323(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a reply to an existing comment. Note: To create a top-level comment, use the commentThreads.insert method.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  ##   part: JString (required)
  ##       : The part parameter identifies the properties that the API response will include. Set the parameter value to snippet. The snippet part has a quota cost of 2 units.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580325 = query.getOrDefault("fields")
  valid_580325 = validateParameter(valid_580325, JString, required = false,
                                 default = nil)
  if valid_580325 != nil:
    section.add "fields", valid_580325
  var valid_580326 = query.getOrDefault("quotaUser")
  valid_580326 = validateParameter(valid_580326, JString, required = false,
                                 default = nil)
  if valid_580326 != nil:
    section.add "quotaUser", valid_580326
  var valid_580327 = query.getOrDefault("alt")
  valid_580327 = validateParameter(valid_580327, JString, required = false,
                                 default = newJString("json"))
  if valid_580327 != nil:
    section.add "alt", valid_580327
  var valid_580328 = query.getOrDefault("oauth_token")
  valid_580328 = validateParameter(valid_580328, JString, required = false,
                                 default = nil)
  if valid_580328 != nil:
    section.add "oauth_token", valid_580328
  var valid_580329 = query.getOrDefault("userIp")
  valid_580329 = validateParameter(valid_580329, JString, required = false,
                                 default = nil)
  if valid_580329 != nil:
    section.add "userIp", valid_580329
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_580330 = query.getOrDefault("part")
  valid_580330 = validateParameter(valid_580330, JString, required = true,
                                 default = nil)
  if valid_580330 != nil:
    section.add "part", valid_580330
  var valid_580331 = query.getOrDefault("key")
  valid_580331 = validateParameter(valid_580331, JString, required = false,
                                 default = nil)
  if valid_580331 != nil:
    section.add "key", valid_580331
  var valid_580332 = query.getOrDefault("prettyPrint")
  valid_580332 = validateParameter(valid_580332, JBool, required = false,
                                 default = newJBool(true))
  if valid_580332 != nil:
    section.add "prettyPrint", valid_580332
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

proc call*(call_580334: Call_YoutubeCommentsInsert_580322; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a reply to an existing comment. Note: To create a top-level comment, use the commentThreads.insert method.
  ## 
  let valid = call_580334.validator(path, query, header, formData, body)
  let scheme = call_580334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580334.url(scheme.get, call_580334.host, call_580334.base,
                         call_580334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580334, url, valid)

proc call*(call_580335: Call_YoutubeCommentsInsert_580322; part: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## youtubeCommentsInsert
  ## Creates a reply to an existing comment. Note: To create a top-level comment, use the commentThreads.insert method.
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
  ##   part: string (required)
  ##       : The part parameter identifies the properties that the API response will include. Set the parameter value to snippet. The snippet part has a quota cost of 2 units.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580336 = newJObject()
  var body_580337 = newJObject()
  add(query_580336, "fields", newJString(fields))
  add(query_580336, "quotaUser", newJString(quotaUser))
  add(query_580336, "alt", newJString(alt))
  add(query_580336, "oauth_token", newJString(oauthToken))
  add(query_580336, "userIp", newJString(userIp))
  add(query_580336, "part", newJString(part))
  add(query_580336, "key", newJString(key))
  if body != nil:
    body_580337 = body
  add(query_580336, "prettyPrint", newJBool(prettyPrint))
  result = call_580335.call(nil, query_580336, nil, nil, body_580337)

var youtubeCommentsInsert* = Call_YoutubeCommentsInsert_580322(
    name: "youtubeCommentsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/comments",
    validator: validate_YoutubeCommentsInsert_580323, base: "/youtube/v3",
    url: url_YoutubeCommentsInsert_580324, schemes: {Scheme.Https})
type
  Call_YoutubeCommentsList_580287 = ref object of OpenApiRestCall_579437
proc url_YoutubeCommentsList_580289(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeCommentsList_580288(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Returns a list of comments that match the API request parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   textFormat: JString
  ##             : This parameter indicates whether the API should return comments formatted as HTML or as plain text.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken property identifies the next page of the result that can be retrieved.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of comment IDs for the resources that are being retrieved. In a comment resource, the id property specifies the comment's ID.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more comment resource properties that the API response will include.
  ##   parentId: JString
  ##           : The parentId parameter specifies the ID of the comment for which replies should be retrieved.
  ## 
  ## Note: YouTube currently supports replies only for top-level comments. However, replies to replies may be supported in the future.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580290 = query.getOrDefault("textFormat")
  valid_580290 = validateParameter(valid_580290, JString, required = false,
                                 default = newJString("html"))
  if valid_580290 != nil:
    section.add "textFormat", valid_580290
  var valid_580291 = query.getOrDefault("fields")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = nil)
  if valid_580291 != nil:
    section.add "fields", valid_580291
  var valid_580292 = query.getOrDefault("pageToken")
  valid_580292 = validateParameter(valid_580292, JString, required = false,
                                 default = nil)
  if valid_580292 != nil:
    section.add "pageToken", valid_580292
  var valid_580293 = query.getOrDefault("quotaUser")
  valid_580293 = validateParameter(valid_580293, JString, required = false,
                                 default = nil)
  if valid_580293 != nil:
    section.add "quotaUser", valid_580293
  var valid_580294 = query.getOrDefault("id")
  valid_580294 = validateParameter(valid_580294, JString, required = false,
                                 default = nil)
  if valid_580294 != nil:
    section.add "id", valid_580294
  var valid_580295 = query.getOrDefault("alt")
  valid_580295 = validateParameter(valid_580295, JString, required = false,
                                 default = newJString("json"))
  if valid_580295 != nil:
    section.add "alt", valid_580295
  var valid_580296 = query.getOrDefault("oauth_token")
  valid_580296 = validateParameter(valid_580296, JString, required = false,
                                 default = nil)
  if valid_580296 != nil:
    section.add "oauth_token", valid_580296
  var valid_580297 = query.getOrDefault("userIp")
  valid_580297 = validateParameter(valid_580297, JString, required = false,
                                 default = nil)
  if valid_580297 != nil:
    section.add "userIp", valid_580297
  var valid_580298 = query.getOrDefault("maxResults")
  valid_580298 = validateParameter(valid_580298, JInt, required = false,
                                 default = newJInt(20))
  if valid_580298 != nil:
    section.add "maxResults", valid_580298
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_580299 = query.getOrDefault("part")
  valid_580299 = validateParameter(valid_580299, JString, required = true,
                                 default = nil)
  if valid_580299 != nil:
    section.add "part", valid_580299
  var valid_580300 = query.getOrDefault("parentId")
  valid_580300 = validateParameter(valid_580300, JString, required = false,
                                 default = nil)
  if valid_580300 != nil:
    section.add "parentId", valid_580300
  var valid_580301 = query.getOrDefault("key")
  valid_580301 = validateParameter(valid_580301, JString, required = false,
                                 default = nil)
  if valid_580301 != nil:
    section.add "key", valid_580301
  var valid_580302 = query.getOrDefault("prettyPrint")
  valid_580302 = validateParameter(valid_580302, JBool, required = false,
                                 default = newJBool(true))
  if valid_580302 != nil:
    section.add "prettyPrint", valid_580302
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580303: Call_YoutubeCommentsList_580287; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of comments that match the API request parameters.
  ## 
  let valid = call_580303.validator(path, query, header, formData, body)
  let scheme = call_580303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580303.url(scheme.get, call_580303.host, call_580303.base,
                         call_580303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580303, url, valid)

proc call*(call_580304: Call_YoutubeCommentsList_580287; part: string;
          textFormat: string = "html"; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; id: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 20;
          parentId: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## youtubeCommentsList
  ## Returns a list of comments that match the API request parameters.
  ##   textFormat: string
  ##             : This parameter indicates whether the API should return comments formatted as HTML or as plain text.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken property identifies the next page of the result that can be retrieved.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of comment IDs for the resources that are being retrieved. In a comment resource, the id property specifies the comment's ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ## 
  ## Note: This parameter is not supported for use in conjunction with the id parameter.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more comment resource properties that the API response will include.
  ##   parentId: string
  ##           : The parentId parameter specifies the ID of the comment for which replies should be retrieved.
  ## 
  ## Note: YouTube currently supports replies only for top-level comments. However, replies to replies may be supported in the future.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580305 = newJObject()
  add(query_580305, "textFormat", newJString(textFormat))
  add(query_580305, "fields", newJString(fields))
  add(query_580305, "pageToken", newJString(pageToken))
  add(query_580305, "quotaUser", newJString(quotaUser))
  add(query_580305, "id", newJString(id))
  add(query_580305, "alt", newJString(alt))
  add(query_580305, "oauth_token", newJString(oauthToken))
  add(query_580305, "userIp", newJString(userIp))
  add(query_580305, "maxResults", newJInt(maxResults))
  add(query_580305, "part", newJString(part))
  add(query_580305, "parentId", newJString(parentId))
  add(query_580305, "key", newJString(key))
  add(query_580305, "prettyPrint", newJBool(prettyPrint))
  result = call_580304.call(nil, query_580305, nil, nil, nil)

var youtubeCommentsList* = Call_YoutubeCommentsList_580287(
    name: "youtubeCommentsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/comments",
    validator: validate_YoutubeCommentsList_580288, base: "/youtube/v3",
    url: url_YoutubeCommentsList_580289, schemes: {Scheme.Https})
type
  Call_YoutubeCommentsDelete_580338 = ref object of OpenApiRestCall_579437
proc url_YoutubeCommentsDelete_580340(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeCommentsDelete_580339(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a comment.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the comment ID for the resource that is being deleted.
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
  var valid_580341 = query.getOrDefault("fields")
  valid_580341 = validateParameter(valid_580341, JString, required = false,
                                 default = nil)
  if valid_580341 != nil:
    section.add "fields", valid_580341
  var valid_580342 = query.getOrDefault("quotaUser")
  valid_580342 = validateParameter(valid_580342, JString, required = false,
                                 default = nil)
  if valid_580342 != nil:
    section.add "quotaUser", valid_580342
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_580343 = query.getOrDefault("id")
  valid_580343 = validateParameter(valid_580343, JString, required = true,
                                 default = nil)
  if valid_580343 != nil:
    section.add "id", valid_580343
  var valid_580344 = query.getOrDefault("alt")
  valid_580344 = validateParameter(valid_580344, JString, required = false,
                                 default = newJString("json"))
  if valid_580344 != nil:
    section.add "alt", valid_580344
  var valid_580345 = query.getOrDefault("oauth_token")
  valid_580345 = validateParameter(valid_580345, JString, required = false,
                                 default = nil)
  if valid_580345 != nil:
    section.add "oauth_token", valid_580345
  var valid_580346 = query.getOrDefault("userIp")
  valid_580346 = validateParameter(valid_580346, JString, required = false,
                                 default = nil)
  if valid_580346 != nil:
    section.add "userIp", valid_580346
  var valid_580347 = query.getOrDefault("key")
  valid_580347 = validateParameter(valid_580347, JString, required = false,
                                 default = nil)
  if valid_580347 != nil:
    section.add "key", valid_580347
  var valid_580348 = query.getOrDefault("prettyPrint")
  valid_580348 = validateParameter(valid_580348, JBool, required = false,
                                 default = newJBool(true))
  if valid_580348 != nil:
    section.add "prettyPrint", valid_580348
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580349: Call_YoutubeCommentsDelete_580338; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a comment.
  ## 
  let valid = call_580349.validator(path, query, header, formData, body)
  let scheme = call_580349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580349.url(scheme.get, call_580349.host, call_580349.base,
                         call_580349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580349, url, valid)

proc call*(call_580350: Call_YoutubeCommentsDelete_580338; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## youtubeCommentsDelete
  ## Deletes a comment.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the comment ID for the resource that is being deleted.
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
  var query_580351 = newJObject()
  add(query_580351, "fields", newJString(fields))
  add(query_580351, "quotaUser", newJString(quotaUser))
  add(query_580351, "id", newJString(id))
  add(query_580351, "alt", newJString(alt))
  add(query_580351, "oauth_token", newJString(oauthToken))
  add(query_580351, "userIp", newJString(userIp))
  add(query_580351, "key", newJString(key))
  add(query_580351, "prettyPrint", newJBool(prettyPrint))
  result = call_580350.call(nil, query_580351, nil, nil, nil)

var youtubeCommentsDelete* = Call_YoutubeCommentsDelete_580338(
    name: "youtubeCommentsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/comments",
    validator: validate_YoutubeCommentsDelete_580339, base: "/youtube/v3",
    url: url_YoutubeCommentsDelete_580340, schemes: {Scheme.Https})
type
  Call_YoutubeCommentsMarkAsSpam_580352 = ref object of OpenApiRestCall_579437
proc url_YoutubeCommentsMarkAsSpam_580354(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeCommentsMarkAsSpam_580353(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Expresses the caller's opinion that one or more comments should be flagged as spam.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies a comma-separated list of IDs of comments that the caller believes should be classified as spam.
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
  var valid_580355 = query.getOrDefault("fields")
  valid_580355 = validateParameter(valid_580355, JString, required = false,
                                 default = nil)
  if valid_580355 != nil:
    section.add "fields", valid_580355
  var valid_580356 = query.getOrDefault("quotaUser")
  valid_580356 = validateParameter(valid_580356, JString, required = false,
                                 default = nil)
  if valid_580356 != nil:
    section.add "quotaUser", valid_580356
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_580357 = query.getOrDefault("id")
  valid_580357 = validateParameter(valid_580357, JString, required = true,
                                 default = nil)
  if valid_580357 != nil:
    section.add "id", valid_580357
  var valid_580358 = query.getOrDefault("alt")
  valid_580358 = validateParameter(valid_580358, JString, required = false,
                                 default = newJString("json"))
  if valid_580358 != nil:
    section.add "alt", valid_580358
  var valid_580359 = query.getOrDefault("oauth_token")
  valid_580359 = validateParameter(valid_580359, JString, required = false,
                                 default = nil)
  if valid_580359 != nil:
    section.add "oauth_token", valid_580359
  var valid_580360 = query.getOrDefault("userIp")
  valid_580360 = validateParameter(valid_580360, JString, required = false,
                                 default = nil)
  if valid_580360 != nil:
    section.add "userIp", valid_580360
  var valid_580361 = query.getOrDefault("key")
  valid_580361 = validateParameter(valid_580361, JString, required = false,
                                 default = nil)
  if valid_580361 != nil:
    section.add "key", valid_580361
  var valid_580362 = query.getOrDefault("prettyPrint")
  valid_580362 = validateParameter(valid_580362, JBool, required = false,
                                 default = newJBool(true))
  if valid_580362 != nil:
    section.add "prettyPrint", valid_580362
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580363: Call_YoutubeCommentsMarkAsSpam_580352; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Expresses the caller's opinion that one or more comments should be flagged as spam.
  ## 
  let valid = call_580363.validator(path, query, header, formData, body)
  let scheme = call_580363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580363.url(scheme.get, call_580363.host, call_580363.base,
                         call_580363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580363, url, valid)

proc call*(call_580364: Call_YoutubeCommentsMarkAsSpam_580352; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## youtubeCommentsMarkAsSpam
  ## Expresses the caller's opinion that one or more comments should be flagged as spam.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies a comma-separated list of IDs of comments that the caller believes should be classified as spam.
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
  var query_580365 = newJObject()
  add(query_580365, "fields", newJString(fields))
  add(query_580365, "quotaUser", newJString(quotaUser))
  add(query_580365, "id", newJString(id))
  add(query_580365, "alt", newJString(alt))
  add(query_580365, "oauth_token", newJString(oauthToken))
  add(query_580365, "userIp", newJString(userIp))
  add(query_580365, "key", newJString(key))
  add(query_580365, "prettyPrint", newJBool(prettyPrint))
  result = call_580364.call(nil, query_580365, nil, nil, nil)

var youtubeCommentsMarkAsSpam* = Call_YoutubeCommentsMarkAsSpam_580352(
    name: "youtubeCommentsMarkAsSpam", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/comments/markAsSpam",
    validator: validate_YoutubeCommentsMarkAsSpam_580353, base: "/youtube/v3",
    url: url_YoutubeCommentsMarkAsSpam_580354, schemes: {Scheme.Https})
type
  Call_YoutubeCommentsSetModerationStatus_580366 = ref object of OpenApiRestCall_579437
proc url_YoutubeCommentsSetModerationStatus_580368(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeCommentsSetModerationStatus_580367(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the moderation status of one or more comments. The API request must be authorized by the owner of the channel or video associated with the comments.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies a comma-separated list of IDs that identify the comments for which you are updating the moderation status.
  ##   alt: JString
  ##      : Data format for the response.
  ##   banAuthor: JBool
  ##            : The banAuthor parameter lets you indicate that you want to automatically reject any additional comments written by the comment's author. Set the parameter value to true to ban the author.
  ## 
  ## Note: This parameter is only valid if the moderationStatus parameter is also set to rejected.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   moderationStatus: JString (required)
  ##                   : Identifies the new moderation status of the specified comments.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580369 = query.getOrDefault("fields")
  valid_580369 = validateParameter(valid_580369, JString, required = false,
                                 default = nil)
  if valid_580369 != nil:
    section.add "fields", valid_580369
  var valid_580370 = query.getOrDefault("quotaUser")
  valid_580370 = validateParameter(valid_580370, JString, required = false,
                                 default = nil)
  if valid_580370 != nil:
    section.add "quotaUser", valid_580370
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_580371 = query.getOrDefault("id")
  valid_580371 = validateParameter(valid_580371, JString, required = true,
                                 default = nil)
  if valid_580371 != nil:
    section.add "id", valid_580371
  var valid_580372 = query.getOrDefault("alt")
  valid_580372 = validateParameter(valid_580372, JString, required = false,
                                 default = newJString("json"))
  if valid_580372 != nil:
    section.add "alt", valid_580372
  var valid_580373 = query.getOrDefault("banAuthor")
  valid_580373 = validateParameter(valid_580373, JBool, required = false,
                                 default = newJBool(false))
  if valid_580373 != nil:
    section.add "banAuthor", valid_580373
  var valid_580374 = query.getOrDefault("oauth_token")
  valid_580374 = validateParameter(valid_580374, JString, required = false,
                                 default = nil)
  if valid_580374 != nil:
    section.add "oauth_token", valid_580374
  var valid_580375 = query.getOrDefault("userIp")
  valid_580375 = validateParameter(valid_580375, JString, required = false,
                                 default = nil)
  if valid_580375 != nil:
    section.add "userIp", valid_580375
  var valid_580376 = query.getOrDefault("key")
  valid_580376 = validateParameter(valid_580376, JString, required = false,
                                 default = nil)
  if valid_580376 != nil:
    section.add "key", valid_580376
  var valid_580377 = query.getOrDefault("moderationStatus")
  valid_580377 = validateParameter(valid_580377, JString, required = true,
                                 default = newJString("heldForReview"))
  if valid_580377 != nil:
    section.add "moderationStatus", valid_580377
  var valid_580378 = query.getOrDefault("prettyPrint")
  valid_580378 = validateParameter(valid_580378, JBool, required = false,
                                 default = newJBool(true))
  if valid_580378 != nil:
    section.add "prettyPrint", valid_580378
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580379: Call_YoutubeCommentsSetModerationStatus_580366;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the moderation status of one or more comments. The API request must be authorized by the owner of the channel or video associated with the comments.
  ## 
  let valid = call_580379.validator(path, query, header, formData, body)
  let scheme = call_580379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580379.url(scheme.get, call_580379.host, call_580379.base,
                         call_580379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580379, url, valid)

proc call*(call_580380: Call_YoutubeCommentsSetModerationStatus_580366; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          banAuthor: bool = false; oauthToken: string = ""; userIp: string = "";
          key: string = ""; moderationStatus: string = "heldForReview";
          prettyPrint: bool = true): Recallable =
  ## youtubeCommentsSetModerationStatus
  ## Sets the moderation status of one or more comments. The API request must be authorized by the owner of the channel or video associated with the comments.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies a comma-separated list of IDs that identify the comments for which you are updating the moderation status.
  ##   alt: string
  ##      : Data format for the response.
  ##   banAuthor: bool
  ##            : The banAuthor parameter lets you indicate that you want to automatically reject any additional comments written by the comment's author. Set the parameter value to true to ban the author.
  ## 
  ## Note: This parameter is only valid if the moderationStatus parameter is also set to rejected.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   moderationStatus: string (required)
  ##                   : Identifies the new moderation status of the specified comments.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580381 = newJObject()
  add(query_580381, "fields", newJString(fields))
  add(query_580381, "quotaUser", newJString(quotaUser))
  add(query_580381, "id", newJString(id))
  add(query_580381, "alt", newJString(alt))
  add(query_580381, "banAuthor", newJBool(banAuthor))
  add(query_580381, "oauth_token", newJString(oauthToken))
  add(query_580381, "userIp", newJString(userIp))
  add(query_580381, "key", newJString(key))
  add(query_580381, "moderationStatus", newJString(moderationStatus))
  add(query_580381, "prettyPrint", newJBool(prettyPrint))
  result = call_580380.call(nil, query_580381, nil, nil, nil)

var youtubeCommentsSetModerationStatus* = Call_YoutubeCommentsSetModerationStatus_580366(
    name: "youtubeCommentsSetModerationStatus", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/comments/setModerationStatus",
    validator: validate_YoutubeCommentsSetModerationStatus_580367,
    base: "/youtube/v3", url: url_YoutubeCommentsSetModerationStatus_580368,
    schemes: {Scheme.Https})
type
  Call_YoutubeGuideCategoriesList_580382 = ref object of OpenApiRestCall_579437
proc url_YoutubeGuideCategoriesList_580384(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeGuideCategoriesList_580383(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of categories that can be associated with YouTube channels.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of the YouTube channel category ID(s) for the resource(s) that are being retrieved. In a guideCategory resource, the id property specifies the YouTube channel category ID.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter specifies the guideCategory resource properties that the API response will include. Set the parameter value to snippet.
  ##   regionCode: JString
  ##             : The regionCode parameter instructs the API to return the list of guide categories available in the specified country. The parameter value is an ISO 3166-1 alpha-2 country code.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   hl: JString
  ##     : The hl parameter specifies the language that will be used for text values in the API response.
  section = newJObject()
  var valid_580385 = query.getOrDefault("fields")
  valid_580385 = validateParameter(valid_580385, JString, required = false,
                                 default = nil)
  if valid_580385 != nil:
    section.add "fields", valid_580385
  var valid_580386 = query.getOrDefault("quotaUser")
  valid_580386 = validateParameter(valid_580386, JString, required = false,
                                 default = nil)
  if valid_580386 != nil:
    section.add "quotaUser", valid_580386
  var valid_580387 = query.getOrDefault("id")
  valid_580387 = validateParameter(valid_580387, JString, required = false,
                                 default = nil)
  if valid_580387 != nil:
    section.add "id", valid_580387
  var valid_580388 = query.getOrDefault("alt")
  valid_580388 = validateParameter(valid_580388, JString, required = false,
                                 default = newJString("json"))
  if valid_580388 != nil:
    section.add "alt", valid_580388
  var valid_580389 = query.getOrDefault("oauth_token")
  valid_580389 = validateParameter(valid_580389, JString, required = false,
                                 default = nil)
  if valid_580389 != nil:
    section.add "oauth_token", valid_580389
  var valid_580390 = query.getOrDefault("userIp")
  valid_580390 = validateParameter(valid_580390, JString, required = false,
                                 default = nil)
  if valid_580390 != nil:
    section.add "userIp", valid_580390
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_580391 = query.getOrDefault("part")
  valid_580391 = validateParameter(valid_580391, JString, required = true,
                                 default = nil)
  if valid_580391 != nil:
    section.add "part", valid_580391
  var valid_580392 = query.getOrDefault("regionCode")
  valid_580392 = validateParameter(valid_580392, JString, required = false,
                                 default = nil)
  if valid_580392 != nil:
    section.add "regionCode", valid_580392
  var valid_580393 = query.getOrDefault("key")
  valid_580393 = validateParameter(valid_580393, JString, required = false,
                                 default = nil)
  if valid_580393 != nil:
    section.add "key", valid_580393
  var valid_580394 = query.getOrDefault("prettyPrint")
  valid_580394 = validateParameter(valid_580394, JBool, required = false,
                                 default = newJBool(true))
  if valid_580394 != nil:
    section.add "prettyPrint", valid_580394
  var valid_580395 = query.getOrDefault("hl")
  valid_580395 = validateParameter(valid_580395, JString, required = false,
                                 default = newJString("en-US"))
  if valid_580395 != nil:
    section.add "hl", valid_580395
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580396: Call_YoutubeGuideCategoriesList_580382; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of categories that can be associated with YouTube channels.
  ## 
  let valid = call_580396.validator(path, query, header, formData, body)
  let scheme = call_580396.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580396.url(scheme.get, call_580396.host, call_580396.base,
                         call_580396.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580396, url, valid)

proc call*(call_580397: Call_YoutubeGuideCategoriesList_580382; part: string;
          fields: string = ""; quotaUser: string = ""; id: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          regionCode: string = ""; key: string = ""; prettyPrint: bool = true;
          hl: string = "en-US"): Recallable =
  ## youtubeGuideCategoriesList
  ## Returns a list of categories that can be associated with YouTube channels.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of the YouTube channel category ID(s) for the resource(s) that are being retrieved. In a guideCategory resource, the id property specifies the YouTube channel category ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter specifies the guideCategory resource properties that the API response will include. Set the parameter value to snippet.
  ##   regionCode: string
  ##             : The regionCode parameter instructs the API to return the list of guide categories available in the specified country. The parameter value is an ISO 3166-1 alpha-2 country code.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   hl: string
  ##     : The hl parameter specifies the language that will be used for text values in the API response.
  var query_580398 = newJObject()
  add(query_580398, "fields", newJString(fields))
  add(query_580398, "quotaUser", newJString(quotaUser))
  add(query_580398, "id", newJString(id))
  add(query_580398, "alt", newJString(alt))
  add(query_580398, "oauth_token", newJString(oauthToken))
  add(query_580398, "userIp", newJString(userIp))
  add(query_580398, "part", newJString(part))
  add(query_580398, "regionCode", newJString(regionCode))
  add(query_580398, "key", newJString(key))
  add(query_580398, "prettyPrint", newJBool(prettyPrint))
  add(query_580398, "hl", newJString(hl))
  result = call_580397.call(nil, query_580398, nil, nil, nil)

var youtubeGuideCategoriesList* = Call_YoutubeGuideCategoriesList_580382(
    name: "youtubeGuideCategoriesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/guideCategories",
    validator: validate_YoutubeGuideCategoriesList_580383, base: "/youtube/v3",
    url: url_YoutubeGuideCategoriesList_580384, schemes: {Scheme.Https})
type
  Call_YoutubeI18nLanguagesList_580399 = ref object of OpenApiRestCall_579437
proc url_YoutubeI18nLanguagesList_580401(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeI18nLanguagesList_580400(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of application languages that the YouTube website supports.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  ##   part: JString (required)
  ##       : The part parameter specifies the i18nLanguage resource properties that the API response will include. Set the parameter value to snippet.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   hl: JString
  ##     : The hl parameter specifies the language that should be used for text values in the API response.
  section = newJObject()
  var valid_580402 = query.getOrDefault("fields")
  valid_580402 = validateParameter(valid_580402, JString, required = false,
                                 default = nil)
  if valid_580402 != nil:
    section.add "fields", valid_580402
  var valid_580403 = query.getOrDefault("quotaUser")
  valid_580403 = validateParameter(valid_580403, JString, required = false,
                                 default = nil)
  if valid_580403 != nil:
    section.add "quotaUser", valid_580403
  var valid_580404 = query.getOrDefault("alt")
  valid_580404 = validateParameter(valid_580404, JString, required = false,
                                 default = newJString("json"))
  if valid_580404 != nil:
    section.add "alt", valid_580404
  var valid_580405 = query.getOrDefault("oauth_token")
  valid_580405 = validateParameter(valid_580405, JString, required = false,
                                 default = nil)
  if valid_580405 != nil:
    section.add "oauth_token", valid_580405
  var valid_580406 = query.getOrDefault("userIp")
  valid_580406 = validateParameter(valid_580406, JString, required = false,
                                 default = nil)
  if valid_580406 != nil:
    section.add "userIp", valid_580406
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_580407 = query.getOrDefault("part")
  valid_580407 = validateParameter(valid_580407, JString, required = true,
                                 default = nil)
  if valid_580407 != nil:
    section.add "part", valid_580407
  var valid_580408 = query.getOrDefault("key")
  valid_580408 = validateParameter(valid_580408, JString, required = false,
                                 default = nil)
  if valid_580408 != nil:
    section.add "key", valid_580408
  var valid_580409 = query.getOrDefault("prettyPrint")
  valid_580409 = validateParameter(valid_580409, JBool, required = false,
                                 default = newJBool(true))
  if valid_580409 != nil:
    section.add "prettyPrint", valid_580409
  var valid_580410 = query.getOrDefault("hl")
  valid_580410 = validateParameter(valid_580410, JString, required = false,
                                 default = newJString("en_US"))
  if valid_580410 != nil:
    section.add "hl", valid_580410
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580411: Call_YoutubeI18nLanguagesList_580399; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of application languages that the YouTube website supports.
  ## 
  let valid = call_580411.validator(path, query, header, formData, body)
  let scheme = call_580411.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580411.url(scheme.get, call_580411.host, call_580411.base,
                         call_580411.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580411, url, valid)

proc call*(call_580412: Call_YoutubeI18nLanguagesList_580399; part: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true; hl: string = "en_US"): Recallable =
  ## youtubeI18nLanguagesList
  ## Returns a list of application languages that the YouTube website supports.
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
  ##   part: string (required)
  ##       : The part parameter specifies the i18nLanguage resource properties that the API response will include. Set the parameter value to snippet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   hl: string
  ##     : The hl parameter specifies the language that should be used for text values in the API response.
  var query_580413 = newJObject()
  add(query_580413, "fields", newJString(fields))
  add(query_580413, "quotaUser", newJString(quotaUser))
  add(query_580413, "alt", newJString(alt))
  add(query_580413, "oauth_token", newJString(oauthToken))
  add(query_580413, "userIp", newJString(userIp))
  add(query_580413, "part", newJString(part))
  add(query_580413, "key", newJString(key))
  add(query_580413, "prettyPrint", newJBool(prettyPrint))
  add(query_580413, "hl", newJString(hl))
  result = call_580412.call(nil, query_580413, nil, nil, nil)

var youtubeI18nLanguagesList* = Call_YoutubeI18nLanguagesList_580399(
    name: "youtubeI18nLanguagesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/i18nLanguages",
    validator: validate_YoutubeI18nLanguagesList_580400, base: "/youtube/v3",
    url: url_YoutubeI18nLanguagesList_580401, schemes: {Scheme.Https})
type
  Call_YoutubeI18nRegionsList_580414 = ref object of OpenApiRestCall_579437
proc url_YoutubeI18nRegionsList_580416(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeI18nRegionsList_580415(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of content regions that the YouTube website supports.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  ##   part: JString (required)
  ##       : The part parameter specifies the i18nRegion resource properties that the API response will include. Set the parameter value to snippet.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   hl: JString
  ##     : The hl parameter specifies the language that should be used for text values in the API response.
  section = newJObject()
  var valid_580417 = query.getOrDefault("fields")
  valid_580417 = validateParameter(valid_580417, JString, required = false,
                                 default = nil)
  if valid_580417 != nil:
    section.add "fields", valid_580417
  var valid_580418 = query.getOrDefault("quotaUser")
  valid_580418 = validateParameter(valid_580418, JString, required = false,
                                 default = nil)
  if valid_580418 != nil:
    section.add "quotaUser", valid_580418
  var valid_580419 = query.getOrDefault("alt")
  valid_580419 = validateParameter(valid_580419, JString, required = false,
                                 default = newJString("json"))
  if valid_580419 != nil:
    section.add "alt", valid_580419
  var valid_580420 = query.getOrDefault("oauth_token")
  valid_580420 = validateParameter(valid_580420, JString, required = false,
                                 default = nil)
  if valid_580420 != nil:
    section.add "oauth_token", valid_580420
  var valid_580421 = query.getOrDefault("userIp")
  valid_580421 = validateParameter(valid_580421, JString, required = false,
                                 default = nil)
  if valid_580421 != nil:
    section.add "userIp", valid_580421
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_580422 = query.getOrDefault("part")
  valid_580422 = validateParameter(valid_580422, JString, required = true,
                                 default = nil)
  if valid_580422 != nil:
    section.add "part", valid_580422
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
  var valid_580425 = query.getOrDefault("hl")
  valid_580425 = validateParameter(valid_580425, JString, required = false,
                                 default = newJString("en_US"))
  if valid_580425 != nil:
    section.add "hl", valid_580425
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580426: Call_YoutubeI18nRegionsList_580414; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of content regions that the YouTube website supports.
  ## 
  let valid = call_580426.validator(path, query, header, formData, body)
  let scheme = call_580426.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580426.url(scheme.get, call_580426.host, call_580426.base,
                         call_580426.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580426, url, valid)

proc call*(call_580427: Call_YoutubeI18nRegionsList_580414; part: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true; hl: string = "en_US"): Recallable =
  ## youtubeI18nRegionsList
  ## Returns a list of content regions that the YouTube website supports.
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
  ##   part: string (required)
  ##       : The part parameter specifies the i18nRegion resource properties that the API response will include. Set the parameter value to snippet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   hl: string
  ##     : The hl parameter specifies the language that should be used for text values in the API response.
  var query_580428 = newJObject()
  add(query_580428, "fields", newJString(fields))
  add(query_580428, "quotaUser", newJString(quotaUser))
  add(query_580428, "alt", newJString(alt))
  add(query_580428, "oauth_token", newJString(oauthToken))
  add(query_580428, "userIp", newJString(userIp))
  add(query_580428, "part", newJString(part))
  add(query_580428, "key", newJString(key))
  add(query_580428, "prettyPrint", newJBool(prettyPrint))
  add(query_580428, "hl", newJString(hl))
  result = call_580427.call(nil, query_580428, nil, nil, nil)

var youtubeI18nRegionsList* = Call_YoutubeI18nRegionsList_580414(
    name: "youtubeI18nRegionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/i18nRegions",
    validator: validate_YoutubeI18nRegionsList_580415, base: "/youtube/v3",
    url: url_YoutubeI18nRegionsList_580416, schemes: {Scheme.Https})
type
  Call_YoutubeLiveBroadcastsUpdate_580451 = ref object of OpenApiRestCall_579437
proc url_YoutubeLiveBroadcastsUpdate_580453(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveBroadcastsUpdate_580452(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a broadcast. For example, you could modify the broadcast settings defined in the liveBroadcast resource's contentDetails object.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part properties that you can include in the parameter value are id, snippet, contentDetails, and status.
  ## 
  ## Note that this method will override the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies. For example, a broadcast's privacy status is defined in the status part. As such, if your request is updating a private or unlisted broadcast, and the request's part parameter value includes the status part, the broadcast's privacy setting will be updated to whatever value the request body specifies. If the request body does not specify a value, the existing privacy setting will be removed and the broadcast will revert to the default privacy setting.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  section = newJObject()
  var valid_580454 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580454 = validateParameter(valid_580454, JString, required = false,
                                 default = nil)
  if valid_580454 != nil:
    section.add "onBehalfOfContentOwner", valid_580454
  var valid_580455 = query.getOrDefault("fields")
  valid_580455 = validateParameter(valid_580455, JString, required = false,
                                 default = nil)
  if valid_580455 != nil:
    section.add "fields", valid_580455
  var valid_580456 = query.getOrDefault("quotaUser")
  valid_580456 = validateParameter(valid_580456, JString, required = false,
                                 default = nil)
  if valid_580456 != nil:
    section.add "quotaUser", valid_580456
  var valid_580457 = query.getOrDefault("alt")
  valid_580457 = validateParameter(valid_580457, JString, required = false,
                                 default = newJString("json"))
  if valid_580457 != nil:
    section.add "alt", valid_580457
  var valid_580458 = query.getOrDefault("oauth_token")
  valid_580458 = validateParameter(valid_580458, JString, required = false,
                                 default = nil)
  if valid_580458 != nil:
    section.add "oauth_token", valid_580458
  var valid_580459 = query.getOrDefault("userIp")
  valid_580459 = validateParameter(valid_580459, JString, required = false,
                                 default = nil)
  if valid_580459 != nil:
    section.add "userIp", valid_580459
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_580460 = query.getOrDefault("part")
  valid_580460 = validateParameter(valid_580460, JString, required = true,
                                 default = nil)
  if valid_580460 != nil:
    section.add "part", valid_580460
  var valid_580461 = query.getOrDefault("key")
  valid_580461 = validateParameter(valid_580461, JString, required = false,
                                 default = nil)
  if valid_580461 != nil:
    section.add "key", valid_580461
  var valid_580462 = query.getOrDefault("prettyPrint")
  valid_580462 = validateParameter(valid_580462, JBool, required = false,
                                 default = newJBool(true))
  if valid_580462 != nil:
    section.add "prettyPrint", valid_580462
  var valid_580463 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_580463 = validateParameter(valid_580463, JString, required = false,
                                 default = nil)
  if valid_580463 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_580463
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

proc call*(call_580465: Call_YoutubeLiveBroadcastsUpdate_580451; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a broadcast. For example, you could modify the broadcast settings defined in the liveBroadcast resource's contentDetails object.
  ## 
  let valid = call_580465.validator(path, query, header, formData, body)
  let scheme = call_580465.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580465.url(scheme.get, call_580465.host, call_580465.base,
                         call_580465.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580465, url, valid)

proc call*(call_580466: Call_YoutubeLiveBroadcastsUpdate_580451; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; onBehalfOfContentOwnerChannel: string = ""): Recallable =
  ## youtubeLiveBroadcastsUpdate
  ## Updates a broadcast. For example, you could modify the broadcast settings defined in the liveBroadcast resource's contentDetails object.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part properties that you can include in the parameter value are id, snippet, contentDetails, and status.
  ## 
  ## Note that this method will override the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies. For example, a broadcast's privacy status is defined in the status part. As such, if your request is updating a private or unlisted broadcast, and the request's part parameter value includes the status part, the broadcast's privacy setting will be updated to whatever value the request body specifies. If the request body does not specify a value, the existing privacy setting will be removed and the broadcast will revert to the default privacy setting.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  var query_580467 = newJObject()
  var body_580468 = newJObject()
  add(query_580467, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580467, "fields", newJString(fields))
  add(query_580467, "quotaUser", newJString(quotaUser))
  add(query_580467, "alt", newJString(alt))
  add(query_580467, "oauth_token", newJString(oauthToken))
  add(query_580467, "userIp", newJString(userIp))
  add(query_580467, "part", newJString(part))
  add(query_580467, "key", newJString(key))
  if body != nil:
    body_580468 = body
  add(query_580467, "prettyPrint", newJBool(prettyPrint))
  add(query_580467, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  result = call_580466.call(nil, query_580467, nil, nil, body_580468)

var youtubeLiveBroadcastsUpdate* = Call_YoutubeLiveBroadcastsUpdate_580451(
    name: "youtubeLiveBroadcastsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/liveBroadcasts",
    validator: validate_YoutubeLiveBroadcastsUpdate_580452, base: "/youtube/v3",
    url: url_YoutubeLiveBroadcastsUpdate_580453, schemes: {Scheme.Https})
type
  Call_YoutubeLiveBroadcastsInsert_580469 = ref object of OpenApiRestCall_579437
proc url_YoutubeLiveBroadcastsInsert_580471(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveBroadcastsInsert_580470(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a broadcast.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part properties that you can include in the parameter value are id, snippet, contentDetails, and status.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  section = newJObject()
  var valid_580472 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580472 = validateParameter(valid_580472, JString, required = false,
                                 default = nil)
  if valid_580472 != nil:
    section.add "onBehalfOfContentOwner", valid_580472
  var valid_580473 = query.getOrDefault("fields")
  valid_580473 = validateParameter(valid_580473, JString, required = false,
                                 default = nil)
  if valid_580473 != nil:
    section.add "fields", valid_580473
  var valid_580474 = query.getOrDefault("quotaUser")
  valid_580474 = validateParameter(valid_580474, JString, required = false,
                                 default = nil)
  if valid_580474 != nil:
    section.add "quotaUser", valid_580474
  var valid_580475 = query.getOrDefault("alt")
  valid_580475 = validateParameter(valid_580475, JString, required = false,
                                 default = newJString("json"))
  if valid_580475 != nil:
    section.add "alt", valid_580475
  var valid_580476 = query.getOrDefault("oauth_token")
  valid_580476 = validateParameter(valid_580476, JString, required = false,
                                 default = nil)
  if valid_580476 != nil:
    section.add "oauth_token", valid_580476
  var valid_580477 = query.getOrDefault("userIp")
  valid_580477 = validateParameter(valid_580477, JString, required = false,
                                 default = nil)
  if valid_580477 != nil:
    section.add "userIp", valid_580477
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_580478 = query.getOrDefault("part")
  valid_580478 = validateParameter(valid_580478, JString, required = true,
                                 default = nil)
  if valid_580478 != nil:
    section.add "part", valid_580478
  var valid_580479 = query.getOrDefault("key")
  valid_580479 = validateParameter(valid_580479, JString, required = false,
                                 default = nil)
  if valid_580479 != nil:
    section.add "key", valid_580479
  var valid_580480 = query.getOrDefault("prettyPrint")
  valid_580480 = validateParameter(valid_580480, JBool, required = false,
                                 default = newJBool(true))
  if valid_580480 != nil:
    section.add "prettyPrint", valid_580480
  var valid_580481 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_580481 = validateParameter(valid_580481, JString, required = false,
                                 default = nil)
  if valid_580481 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_580481
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

proc call*(call_580483: Call_YoutubeLiveBroadcastsInsert_580469; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a broadcast.
  ## 
  let valid = call_580483.validator(path, query, header, formData, body)
  let scheme = call_580483.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580483.url(scheme.get, call_580483.host, call_580483.base,
                         call_580483.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580483, url, valid)

proc call*(call_580484: Call_YoutubeLiveBroadcastsInsert_580469; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; onBehalfOfContentOwnerChannel: string = ""): Recallable =
  ## youtubeLiveBroadcastsInsert
  ## Creates a broadcast.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part properties that you can include in the parameter value are id, snippet, contentDetails, and status.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  var query_580485 = newJObject()
  var body_580486 = newJObject()
  add(query_580485, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580485, "fields", newJString(fields))
  add(query_580485, "quotaUser", newJString(quotaUser))
  add(query_580485, "alt", newJString(alt))
  add(query_580485, "oauth_token", newJString(oauthToken))
  add(query_580485, "userIp", newJString(userIp))
  add(query_580485, "part", newJString(part))
  add(query_580485, "key", newJString(key))
  if body != nil:
    body_580486 = body
  add(query_580485, "prettyPrint", newJBool(prettyPrint))
  add(query_580485, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  result = call_580484.call(nil, query_580485, nil, nil, body_580486)

var youtubeLiveBroadcastsInsert* = Call_YoutubeLiveBroadcastsInsert_580469(
    name: "youtubeLiveBroadcastsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/liveBroadcasts",
    validator: validate_YoutubeLiveBroadcastsInsert_580470, base: "/youtube/v3",
    url: url_YoutubeLiveBroadcastsInsert_580471, schemes: {Scheme.Https})
type
  Call_YoutubeLiveBroadcastsList_580429 = ref object of OpenApiRestCall_579437
proc url_YoutubeLiveBroadcastsList_580431(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveBroadcastsList_580430(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of YouTube broadcasts that match the API request parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   mine: JBool
  ##       : The mine parameter can be used to instruct the API to only return broadcasts owned by the authenticated user. Set the parameter value to true to only retrieve your own broadcasts.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of YouTube broadcast IDs that identify the broadcasts being retrieved. In a liveBroadcast resource, the id property specifies the broadcast's ID.
  ##   alt: JString
  ##      : Data format for the response.
  ##   broadcastType: JString
  ##                : The broadcastType parameter filters the API response to only include broadcasts with the specified type. This is only compatible with the mine filter for now.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more liveBroadcast resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, contentDetails, and status.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   broadcastStatus: JString
  ##                  : The broadcastStatus parameter filters the API response to only include broadcasts with the specified status.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  section = newJObject()
  var valid_580432 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580432 = validateParameter(valid_580432, JString, required = false,
                                 default = nil)
  if valid_580432 != nil:
    section.add "onBehalfOfContentOwner", valid_580432
  var valid_580433 = query.getOrDefault("mine")
  valid_580433 = validateParameter(valid_580433, JBool, required = false, default = nil)
  if valid_580433 != nil:
    section.add "mine", valid_580433
  var valid_580434 = query.getOrDefault("fields")
  valid_580434 = validateParameter(valid_580434, JString, required = false,
                                 default = nil)
  if valid_580434 != nil:
    section.add "fields", valid_580434
  var valid_580435 = query.getOrDefault("pageToken")
  valid_580435 = validateParameter(valid_580435, JString, required = false,
                                 default = nil)
  if valid_580435 != nil:
    section.add "pageToken", valid_580435
  var valid_580436 = query.getOrDefault("quotaUser")
  valid_580436 = validateParameter(valid_580436, JString, required = false,
                                 default = nil)
  if valid_580436 != nil:
    section.add "quotaUser", valid_580436
  var valid_580437 = query.getOrDefault("id")
  valid_580437 = validateParameter(valid_580437, JString, required = false,
                                 default = nil)
  if valid_580437 != nil:
    section.add "id", valid_580437
  var valid_580438 = query.getOrDefault("alt")
  valid_580438 = validateParameter(valid_580438, JString, required = false,
                                 default = newJString("json"))
  if valid_580438 != nil:
    section.add "alt", valid_580438
  var valid_580439 = query.getOrDefault("broadcastType")
  valid_580439 = validateParameter(valid_580439, JString, required = false,
                                 default = newJString("event"))
  if valid_580439 != nil:
    section.add "broadcastType", valid_580439
  var valid_580440 = query.getOrDefault("oauth_token")
  valid_580440 = validateParameter(valid_580440, JString, required = false,
                                 default = nil)
  if valid_580440 != nil:
    section.add "oauth_token", valid_580440
  var valid_580441 = query.getOrDefault("userIp")
  valid_580441 = validateParameter(valid_580441, JString, required = false,
                                 default = nil)
  if valid_580441 != nil:
    section.add "userIp", valid_580441
  var valid_580442 = query.getOrDefault("maxResults")
  valid_580442 = validateParameter(valid_580442, JInt, required = false,
                                 default = newJInt(5))
  if valid_580442 != nil:
    section.add "maxResults", valid_580442
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_580443 = query.getOrDefault("part")
  valid_580443 = validateParameter(valid_580443, JString, required = true,
                                 default = nil)
  if valid_580443 != nil:
    section.add "part", valid_580443
  var valid_580444 = query.getOrDefault("key")
  valid_580444 = validateParameter(valid_580444, JString, required = false,
                                 default = nil)
  if valid_580444 != nil:
    section.add "key", valid_580444
  var valid_580445 = query.getOrDefault("broadcastStatus")
  valid_580445 = validateParameter(valid_580445, JString, required = false,
                                 default = newJString("active"))
  if valid_580445 != nil:
    section.add "broadcastStatus", valid_580445
  var valid_580446 = query.getOrDefault("prettyPrint")
  valid_580446 = validateParameter(valid_580446, JBool, required = false,
                                 default = newJBool(true))
  if valid_580446 != nil:
    section.add "prettyPrint", valid_580446
  var valid_580447 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_580447 = validateParameter(valid_580447, JString, required = false,
                                 default = nil)
  if valid_580447 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_580447
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580448: Call_YoutubeLiveBroadcastsList_580429; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of YouTube broadcasts that match the API request parameters.
  ## 
  let valid = call_580448.validator(path, query, header, formData, body)
  let scheme = call_580448.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580448.url(scheme.get, call_580448.host, call_580448.base,
                         call_580448.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580448, url, valid)

proc call*(call_580449: Call_YoutubeLiveBroadcastsList_580429; part: string;
          onBehalfOfContentOwner: string = ""; mine: bool = false; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; id: string = "";
          alt: string = "json"; broadcastType: string = "event";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 5;
          key: string = ""; broadcastStatus: string = "active";
          prettyPrint: bool = true; onBehalfOfContentOwnerChannel: string = ""): Recallable =
  ## youtubeLiveBroadcastsList
  ## Returns a list of YouTube broadcasts that match the API request parameters.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   mine: bool
  ##       : The mine parameter can be used to instruct the API to only return broadcasts owned by the authenticated user. Set the parameter value to true to only retrieve your own broadcasts.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of YouTube broadcast IDs that identify the broadcasts being retrieved. In a liveBroadcast resource, the id property specifies the broadcast's ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   broadcastType: string
  ##                : The broadcastType parameter filters the API response to only include broadcasts with the specified type. This is only compatible with the mine filter for now.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more liveBroadcast resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, contentDetails, and status.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   broadcastStatus: string
  ##                  : The broadcastStatus parameter filters the API response to only include broadcasts with the specified status.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  var query_580450 = newJObject()
  add(query_580450, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580450, "mine", newJBool(mine))
  add(query_580450, "fields", newJString(fields))
  add(query_580450, "pageToken", newJString(pageToken))
  add(query_580450, "quotaUser", newJString(quotaUser))
  add(query_580450, "id", newJString(id))
  add(query_580450, "alt", newJString(alt))
  add(query_580450, "broadcastType", newJString(broadcastType))
  add(query_580450, "oauth_token", newJString(oauthToken))
  add(query_580450, "userIp", newJString(userIp))
  add(query_580450, "maxResults", newJInt(maxResults))
  add(query_580450, "part", newJString(part))
  add(query_580450, "key", newJString(key))
  add(query_580450, "broadcastStatus", newJString(broadcastStatus))
  add(query_580450, "prettyPrint", newJBool(prettyPrint))
  add(query_580450, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  result = call_580449.call(nil, query_580450, nil, nil, nil)

var youtubeLiveBroadcastsList* = Call_YoutubeLiveBroadcastsList_580429(
    name: "youtubeLiveBroadcastsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/liveBroadcasts",
    validator: validate_YoutubeLiveBroadcastsList_580430, base: "/youtube/v3",
    url: url_YoutubeLiveBroadcastsList_580431, schemes: {Scheme.Https})
type
  Call_YoutubeLiveBroadcastsDelete_580487 = ref object of OpenApiRestCall_579437
proc url_YoutubeLiveBroadcastsDelete_580489(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveBroadcastsDelete_580488(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a broadcast.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the YouTube live broadcast ID for the resource that is being deleted.
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
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  section = newJObject()
  var valid_580490 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580490 = validateParameter(valid_580490, JString, required = false,
                                 default = nil)
  if valid_580490 != nil:
    section.add "onBehalfOfContentOwner", valid_580490
  var valid_580491 = query.getOrDefault("fields")
  valid_580491 = validateParameter(valid_580491, JString, required = false,
                                 default = nil)
  if valid_580491 != nil:
    section.add "fields", valid_580491
  var valid_580492 = query.getOrDefault("quotaUser")
  valid_580492 = validateParameter(valid_580492, JString, required = false,
                                 default = nil)
  if valid_580492 != nil:
    section.add "quotaUser", valid_580492
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_580493 = query.getOrDefault("id")
  valid_580493 = validateParameter(valid_580493, JString, required = true,
                                 default = nil)
  if valid_580493 != nil:
    section.add "id", valid_580493
  var valid_580494 = query.getOrDefault("alt")
  valid_580494 = validateParameter(valid_580494, JString, required = false,
                                 default = newJString("json"))
  if valid_580494 != nil:
    section.add "alt", valid_580494
  var valid_580495 = query.getOrDefault("oauth_token")
  valid_580495 = validateParameter(valid_580495, JString, required = false,
                                 default = nil)
  if valid_580495 != nil:
    section.add "oauth_token", valid_580495
  var valid_580496 = query.getOrDefault("userIp")
  valid_580496 = validateParameter(valid_580496, JString, required = false,
                                 default = nil)
  if valid_580496 != nil:
    section.add "userIp", valid_580496
  var valid_580497 = query.getOrDefault("key")
  valid_580497 = validateParameter(valid_580497, JString, required = false,
                                 default = nil)
  if valid_580497 != nil:
    section.add "key", valid_580497
  var valid_580498 = query.getOrDefault("prettyPrint")
  valid_580498 = validateParameter(valid_580498, JBool, required = false,
                                 default = newJBool(true))
  if valid_580498 != nil:
    section.add "prettyPrint", valid_580498
  var valid_580499 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_580499 = validateParameter(valid_580499, JString, required = false,
                                 default = nil)
  if valid_580499 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_580499
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580500: Call_YoutubeLiveBroadcastsDelete_580487; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a broadcast.
  ## 
  let valid = call_580500.validator(path, query, header, formData, body)
  let scheme = call_580500.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580500.url(scheme.get, call_580500.host, call_580500.base,
                         call_580500.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580500, url, valid)

proc call*(call_580501: Call_YoutubeLiveBroadcastsDelete_580487; id: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true;
          onBehalfOfContentOwnerChannel: string = ""): Recallable =
  ## youtubeLiveBroadcastsDelete
  ## Deletes a broadcast.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the YouTube live broadcast ID for the resource that is being deleted.
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
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  var query_580502 = newJObject()
  add(query_580502, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580502, "fields", newJString(fields))
  add(query_580502, "quotaUser", newJString(quotaUser))
  add(query_580502, "id", newJString(id))
  add(query_580502, "alt", newJString(alt))
  add(query_580502, "oauth_token", newJString(oauthToken))
  add(query_580502, "userIp", newJString(userIp))
  add(query_580502, "key", newJString(key))
  add(query_580502, "prettyPrint", newJBool(prettyPrint))
  add(query_580502, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  result = call_580501.call(nil, query_580502, nil, nil, nil)

var youtubeLiveBroadcastsDelete* = Call_YoutubeLiveBroadcastsDelete_580487(
    name: "youtubeLiveBroadcastsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/liveBroadcasts",
    validator: validate_YoutubeLiveBroadcastsDelete_580488, base: "/youtube/v3",
    url: url_YoutubeLiveBroadcastsDelete_580489, schemes: {Scheme.Https})
type
  Call_YoutubeLiveBroadcastsBind_580503 = ref object of OpenApiRestCall_579437
proc url_YoutubeLiveBroadcastsBind_580505(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveBroadcastsBind_580504(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Binds a YouTube broadcast to a stream or removes an existing binding between a broadcast and a stream. A broadcast can only be bound to one video stream, though a video stream may be bound to more than one broadcast.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the unique ID of the broadcast that is being bound to a video stream.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more liveBroadcast resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, contentDetails, and status.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   streamId: JString
  ##           : The streamId parameter specifies the unique ID of the video stream that is being bound to a broadcast. If this parameter is omitted, the API will remove any existing binding between the broadcast and a video stream.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  section = newJObject()
  var valid_580506 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580506 = validateParameter(valid_580506, JString, required = false,
                                 default = nil)
  if valid_580506 != nil:
    section.add "onBehalfOfContentOwner", valid_580506
  var valid_580507 = query.getOrDefault("fields")
  valid_580507 = validateParameter(valid_580507, JString, required = false,
                                 default = nil)
  if valid_580507 != nil:
    section.add "fields", valid_580507
  var valid_580508 = query.getOrDefault("quotaUser")
  valid_580508 = validateParameter(valid_580508, JString, required = false,
                                 default = nil)
  if valid_580508 != nil:
    section.add "quotaUser", valid_580508
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_580509 = query.getOrDefault("id")
  valid_580509 = validateParameter(valid_580509, JString, required = true,
                                 default = nil)
  if valid_580509 != nil:
    section.add "id", valid_580509
  var valid_580510 = query.getOrDefault("alt")
  valid_580510 = validateParameter(valid_580510, JString, required = false,
                                 default = newJString("json"))
  if valid_580510 != nil:
    section.add "alt", valid_580510
  var valid_580511 = query.getOrDefault("oauth_token")
  valid_580511 = validateParameter(valid_580511, JString, required = false,
                                 default = nil)
  if valid_580511 != nil:
    section.add "oauth_token", valid_580511
  var valid_580512 = query.getOrDefault("userIp")
  valid_580512 = validateParameter(valid_580512, JString, required = false,
                                 default = nil)
  if valid_580512 != nil:
    section.add "userIp", valid_580512
  var valid_580513 = query.getOrDefault("part")
  valid_580513 = validateParameter(valid_580513, JString, required = true,
                                 default = nil)
  if valid_580513 != nil:
    section.add "part", valid_580513
  var valid_580514 = query.getOrDefault("key")
  valid_580514 = validateParameter(valid_580514, JString, required = false,
                                 default = nil)
  if valid_580514 != nil:
    section.add "key", valid_580514
  var valid_580515 = query.getOrDefault("streamId")
  valid_580515 = validateParameter(valid_580515, JString, required = false,
                                 default = nil)
  if valid_580515 != nil:
    section.add "streamId", valid_580515
  var valid_580516 = query.getOrDefault("prettyPrint")
  valid_580516 = validateParameter(valid_580516, JBool, required = false,
                                 default = newJBool(true))
  if valid_580516 != nil:
    section.add "prettyPrint", valid_580516
  var valid_580517 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_580517 = validateParameter(valid_580517, JString, required = false,
                                 default = nil)
  if valid_580517 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_580517
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580518: Call_YoutubeLiveBroadcastsBind_580503; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Binds a YouTube broadcast to a stream or removes an existing binding between a broadcast and a stream. A broadcast can only be bound to one video stream, though a video stream may be bound to more than one broadcast.
  ## 
  let valid = call_580518.validator(path, query, header, formData, body)
  let scheme = call_580518.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580518.url(scheme.get, call_580518.host, call_580518.base,
                         call_580518.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580518, url, valid)

proc call*(call_580519: Call_YoutubeLiveBroadcastsBind_580503; id: string;
          part: string; onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; streamId: string = "";
          prettyPrint: bool = true; onBehalfOfContentOwnerChannel: string = ""): Recallable =
  ## youtubeLiveBroadcastsBind
  ## Binds a YouTube broadcast to a stream or removes an existing binding between a broadcast and a stream. A broadcast can only be bound to one video stream, though a video stream may be bound to more than one broadcast.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the unique ID of the broadcast that is being bound to a video stream.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more liveBroadcast resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, contentDetails, and status.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   streamId: string
  ##           : The streamId parameter specifies the unique ID of the video stream that is being bound to a broadcast. If this parameter is omitted, the API will remove any existing binding between the broadcast and a video stream.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  var query_580520 = newJObject()
  add(query_580520, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580520, "fields", newJString(fields))
  add(query_580520, "quotaUser", newJString(quotaUser))
  add(query_580520, "id", newJString(id))
  add(query_580520, "alt", newJString(alt))
  add(query_580520, "oauth_token", newJString(oauthToken))
  add(query_580520, "userIp", newJString(userIp))
  add(query_580520, "part", newJString(part))
  add(query_580520, "key", newJString(key))
  add(query_580520, "streamId", newJString(streamId))
  add(query_580520, "prettyPrint", newJBool(prettyPrint))
  add(query_580520, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  result = call_580519.call(nil, query_580520, nil, nil, nil)

var youtubeLiveBroadcastsBind* = Call_YoutubeLiveBroadcastsBind_580503(
    name: "youtubeLiveBroadcastsBind", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/liveBroadcasts/bind",
    validator: validate_YoutubeLiveBroadcastsBind_580504, base: "/youtube/v3",
    url: url_YoutubeLiveBroadcastsBind_580505, schemes: {Scheme.Https})
type
  Call_YoutubeLiveBroadcastsControl_580521 = ref object of OpenApiRestCall_579437
proc url_YoutubeLiveBroadcastsControl_580523(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveBroadcastsControl_580522(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Controls the settings for a slate that can be displayed in the broadcast stream.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   offsetTimeMs: JString
  ##               : The offsetTimeMs parameter specifies a positive time offset when the specified slate change will occur. The value is measured in milliseconds from the beginning of the broadcast's monitor stream, which is the time that the testing phase for the broadcast began. Even though it is specified in milliseconds, the value is actually an approximation, and YouTube completes the requested action as closely as possible to that time.
  ## 
  ## If you do not specify a value for this parameter, then YouTube performs the action as soon as possible. See the Getting started guide for more details.
  ## 
  ## Important: You should only specify a value for this parameter if your broadcast stream is delayed.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the YouTube live broadcast ID that uniquely identifies the broadcast in which the slate is being updated.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more liveBroadcast resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, contentDetails, and status.
  ##   walltime: JString
  ##           : The walltime parameter specifies the wall clock time at which the specified slate change will occur. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sssZ) format.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   displaySlate: JBool
  ##               : The displaySlate parameter specifies whether the slate is being enabled or disabled.
  section = newJObject()
  var valid_580524 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580524 = validateParameter(valid_580524, JString, required = false,
                                 default = nil)
  if valid_580524 != nil:
    section.add "onBehalfOfContentOwner", valid_580524
  var valid_580525 = query.getOrDefault("offsetTimeMs")
  valid_580525 = validateParameter(valid_580525, JString, required = false,
                                 default = nil)
  if valid_580525 != nil:
    section.add "offsetTimeMs", valid_580525
  var valid_580526 = query.getOrDefault("fields")
  valid_580526 = validateParameter(valid_580526, JString, required = false,
                                 default = nil)
  if valid_580526 != nil:
    section.add "fields", valid_580526
  var valid_580527 = query.getOrDefault("quotaUser")
  valid_580527 = validateParameter(valid_580527, JString, required = false,
                                 default = nil)
  if valid_580527 != nil:
    section.add "quotaUser", valid_580527
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_580528 = query.getOrDefault("id")
  valid_580528 = validateParameter(valid_580528, JString, required = true,
                                 default = nil)
  if valid_580528 != nil:
    section.add "id", valid_580528
  var valid_580529 = query.getOrDefault("alt")
  valid_580529 = validateParameter(valid_580529, JString, required = false,
                                 default = newJString("json"))
  if valid_580529 != nil:
    section.add "alt", valid_580529
  var valid_580530 = query.getOrDefault("oauth_token")
  valid_580530 = validateParameter(valid_580530, JString, required = false,
                                 default = nil)
  if valid_580530 != nil:
    section.add "oauth_token", valid_580530
  var valid_580531 = query.getOrDefault("userIp")
  valid_580531 = validateParameter(valid_580531, JString, required = false,
                                 default = nil)
  if valid_580531 != nil:
    section.add "userIp", valid_580531
  var valid_580532 = query.getOrDefault("part")
  valid_580532 = validateParameter(valid_580532, JString, required = true,
                                 default = nil)
  if valid_580532 != nil:
    section.add "part", valid_580532
  var valid_580533 = query.getOrDefault("walltime")
  valid_580533 = validateParameter(valid_580533, JString, required = false,
                                 default = nil)
  if valid_580533 != nil:
    section.add "walltime", valid_580533
  var valid_580534 = query.getOrDefault("key")
  valid_580534 = validateParameter(valid_580534, JString, required = false,
                                 default = nil)
  if valid_580534 != nil:
    section.add "key", valid_580534
  var valid_580535 = query.getOrDefault("prettyPrint")
  valid_580535 = validateParameter(valid_580535, JBool, required = false,
                                 default = newJBool(true))
  if valid_580535 != nil:
    section.add "prettyPrint", valid_580535
  var valid_580536 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_580536 = validateParameter(valid_580536, JString, required = false,
                                 default = nil)
  if valid_580536 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_580536
  var valid_580537 = query.getOrDefault("displaySlate")
  valid_580537 = validateParameter(valid_580537, JBool, required = false, default = nil)
  if valid_580537 != nil:
    section.add "displaySlate", valid_580537
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580538: Call_YoutubeLiveBroadcastsControl_580521; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Controls the settings for a slate that can be displayed in the broadcast stream.
  ## 
  let valid = call_580538.validator(path, query, header, formData, body)
  let scheme = call_580538.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580538.url(scheme.get, call_580538.host, call_580538.base,
                         call_580538.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580538, url, valid)

proc call*(call_580539: Call_YoutubeLiveBroadcastsControl_580521; id: string;
          part: string; onBehalfOfContentOwner: string = "";
          offsetTimeMs: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          walltime: string = ""; key: string = ""; prettyPrint: bool = true;
          onBehalfOfContentOwnerChannel: string = ""; displaySlate: bool = false): Recallable =
  ## youtubeLiveBroadcastsControl
  ## Controls the settings for a slate that can be displayed in the broadcast stream.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   offsetTimeMs: string
  ##               : The offsetTimeMs parameter specifies a positive time offset when the specified slate change will occur. The value is measured in milliseconds from the beginning of the broadcast's monitor stream, which is the time that the testing phase for the broadcast began. Even though it is specified in milliseconds, the value is actually an approximation, and YouTube completes the requested action as closely as possible to that time.
  ## 
  ## If you do not specify a value for this parameter, then YouTube performs the action as soon as possible. See the Getting started guide for more details.
  ## 
  ## Important: You should only specify a value for this parameter if your broadcast stream is delayed.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the YouTube live broadcast ID that uniquely identifies the broadcast in which the slate is being updated.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more liveBroadcast resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, contentDetails, and status.
  ##   walltime: string
  ##           : The walltime parameter specifies the wall clock time at which the specified slate change will occur. The value is specified in ISO 8601 (YYYY-MM-DDThh:mm:ss.sssZ) format.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   displaySlate: bool
  ##               : The displaySlate parameter specifies whether the slate is being enabled or disabled.
  var query_580540 = newJObject()
  add(query_580540, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580540, "offsetTimeMs", newJString(offsetTimeMs))
  add(query_580540, "fields", newJString(fields))
  add(query_580540, "quotaUser", newJString(quotaUser))
  add(query_580540, "id", newJString(id))
  add(query_580540, "alt", newJString(alt))
  add(query_580540, "oauth_token", newJString(oauthToken))
  add(query_580540, "userIp", newJString(userIp))
  add(query_580540, "part", newJString(part))
  add(query_580540, "walltime", newJString(walltime))
  add(query_580540, "key", newJString(key))
  add(query_580540, "prettyPrint", newJBool(prettyPrint))
  add(query_580540, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  add(query_580540, "displaySlate", newJBool(displaySlate))
  result = call_580539.call(nil, query_580540, nil, nil, nil)

var youtubeLiveBroadcastsControl* = Call_YoutubeLiveBroadcastsControl_580521(
    name: "youtubeLiveBroadcastsControl", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/liveBroadcasts/control",
    validator: validate_YoutubeLiveBroadcastsControl_580522, base: "/youtube/v3",
    url: url_YoutubeLiveBroadcastsControl_580523, schemes: {Scheme.Https})
type
  Call_YoutubeLiveBroadcastsTransition_580541 = ref object of OpenApiRestCall_579437
proc url_YoutubeLiveBroadcastsTransition_580543(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveBroadcastsTransition_580542(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Changes the status of a YouTube live broadcast and initiates any processes associated with the new status. For example, when you transition a broadcast's status to testing, YouTube starts to transmit video to that broadcast's monitor stream. Before calling this method, you should confirm that the value of the status.streamStatus property for the stream bound to your broadcast is active.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the unique ID of the broadcast that is transitioning to another status.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more liveBroadcast resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, contentDetails, and status.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   broadcastStatus: JString (required)
  ##                  : The broadcastStatus parameter identifies the state to which the broadcast is changing. Note that to transition a broadcast to either the testing or live state, the status.streamStatus must be active for the stream that the broadcast is bound to.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  section = newJObject()
  var valid_580544 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580544 = validateParameter(valid_580544, JString, required = false,
                                 default = nil)
  if valid_580544 != nil:
    section.add "onBehalfOfContentOwner", valid_580544
  var valid_580545 = query.getOrDefault("fields")
  valid_580545 = validateParameter(valid_580545, JString, required = false,
                                 default = nil)
  if valid_580545 != nil:
    section.add "fields", valid_580545
  var valid_580546 = query.getOrDefault("quotaUser")
  valid_580546 = validateParameter(valid_580546, JString, required = false,
                                 default = nil)
  if valid_580546 != nil:
    section.add "quotaUser", valid_580546
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_580547 = query.getOrDefault("id")
  valid_580547 = validateParameter(valid_580547, JString, required = true,
                                 default = nil)
  if valid_580547 != nil:
    section.add "id", valid_580547
  var valid_580548 = query.getOrDefault("alt")
  valid_580548 = validateParameter(valid_580548, JString, required = false,
                                 default = newJString("json"))
  if valid_580548 != nil:
    section.add "alt", valid_580548
  var valid_580549 = query.getOrDefault("oauth_token")
  valid_580549 = validateParameter(valid_580549, JString, required = false,
                                 default = nil)
  if valid_580549 != nil:
    section.add "oauth_token", valid_580549
  var valid_580550 = query.getOrDefault("userIp")
  valid_580550 = validateParameter(valid_580550, JString, required = false,
                                 default = nil)
  if valid_580550 != nil:
    section.add "userIp", valid_580550
  var valid_580551 = query.getOrDefault("part")
  valid_580551 = validateParameter(valid_580551, JString, required = true,
                                 default = nil)
  if valid_580551 != nil:
    section.add "part", valid_580551
  var valid_580552 = query.getOrDefault("key")
  valid_580552 = validateParameter(valid_580552, JString, required = false,
                                 default = nil)
  if valid_580552 != nil:
    section.add "key", valid_580552
  var valid_580553 = query.getOrDefault("broadcastStatus")
  valid_580553 = validateParameter(valid_580553, JString, required = true,
                                 default = newJString("complete"))
  if valid_580553 != nil:
    section.add "broadcastStatus", valid_580553
  var valid_580554 = query.getOrDefault("prettyPrint")
  valid_580554 = validateParameter(valid_580554, JBool, required = false,
                                 default = newJBool(true))
  if valid_580554 != nil:
    section.add "prettyPrint", valid_580554
  var valid_580555 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_580555 = validateParameter(valid_580555, JString, required = false,
                                 default = nil)
  if valid_580555 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_580555
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580556: Call_YoutubeLiveBroadcastsTransition_580541;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Changes the status of a YouTube live broadcast and initiates any processes associated with the new status. For example, when you transition a broadcast's status to testing, YouTube starts to transmit video to that broadcast's monitor stream. Before calling this method, you should confirm that the value of the status.streamStatus property for the stream bound to your broadcast is active.
  ## 
  let valid = call_580556.validator(path, query, header, formData, body)
  let scheme = call_580556.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580556.url(scheme.get, call_580556.host, call_580556.base,
                         call_580556.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580556, url, valid)

proc call*(call_580557: Call_YoutubeLiveBroadcastsTransition_580541; id: string;
          part: string; onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; broadcastStatus: string = "complete";
          prettyPrint: bool = true; onBehalfOfContentOwnerChannel: string = ""): Recallable =
  ## youtubeLiveBroadcastsTransition
  ## Changes the status of a YouTube live broadcast and initiates any processes associated with the new status. For example, when you transition a broadcast's status to testing, YouTube starts to transmit video to that broadcast's monitor stream. Before calling this method, you should confirm that the value of the status.streamStatus property for the stream bound to your broadcast is active.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the unique ID of the broadcast that is transitioning to another status.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more liveBroadcast resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, contentDetails, and status.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   broadcastStatus: string (required)
  ##                  : The broadcastStatus parameter identifies the state to which the broadcast is changing. Note that to transition a broadcast to either the testing or live state, the status.streamStatus must be active for the stream that the broadcast is bound to.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  var query_580558 = newJObject()
  add(query_580558, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580558, "fields", newJString(fields))
  add(query_580558, "quotaUser", newJString(quotaUser))
  add(query_580558, "id", newJString(id))
  add(query_580558, "alt", newJString(alt))
  add(query_580558, "oauth_token", newJString(oauthToken))
  add(query_580558, "userIp", newJString(userIp))
  add(query_580558, "part", newJString(part))
  add(query_580558, "key", newJString(key))
  add(query_580558, "broadcastStatus", newJString(broadcastStatus))
  add(query_580558, "prettyPrint", newJBool(prettyPrint))
  add(query_580558, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  result = call_580557.call(nil, query_580558, nil, nil, nil)

var youtubeLiveBroadcastsTransition* = Call_YoutubeLiveBroadcastsTransition_580541(
    name: "youtubeLiveBroadcastsTransition", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/liveBroadcasts/transition",
    validator: validate_YoutubeLiveBroadcastsTransition_580542,
    base: "/youtube/v3", url: url_YoutubeLiveBroadcastsTransition_580543,
    schemes: {Scheme.Https})
type
  Call_YoutubeLiveChatBansInsert_580559 = ref object of OpenApiRestCall_579437
proc url_YoutubeLiveChatBansInsert_580561(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveChatBansInsert_580560(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a new ban to the chat.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response returns. Set the parameter value to snippet.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580562 = query.getOrDefault("fields")
  valid_580562 = validateParameter(valid_580562, JString, required = false,
                                 default = nil)
  if valid_580562 != nil:
    section.add "fields", valid_580562
  var valid_580563 = query.getOrDefault("quotaUser")
  valid_580563 = validateParameter(valid_580563, JString, required = false,
                                 default = nil)
  if valid_580563 != nil:
    section.add "quotaUser", valid_580563
  var valid_580564 = query.getOrDefault("alt")
  valid_580564 = validateParameter(valid_580564, JString, required = false,
                                 default = newJString("json"))
  if valid_580564 != nil:
    section.add "alt", valid_580564
  var valid_580565 = query.getOrDefault("oauth_token")
  valid_580565 = validateParameter(valid_580565, JString, required = false,
                                 default = nil)
  if valid_580565 != nil:
    section.add "oauth_token", valid_580565
  var valid_580566 = query.getOrDefault("userIp")
  valid_580566 = validateParameter(valid_580566, JString, required = false,
                                 default = nil)
  if valid_580566 != nil:
    section.add "userIp", valid_580566
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_580567 = query.getOrDefault("part")
  valid_580567 = validateParameter(valid_580567, JString, required = true,
                                 default = nil)
  if valid_580567 != nil:
    section.add "part", valid_580567
  var valid_580568 = query.getOrDefault("key")
  valid_580568 = validateParameter(valid_580568, JString, required = false,
                                 default = nil)
  if valid_580568 != nil:
    section.add "key", valid_580568
  var valid_580569 = query.getOrDefault("prettyPrint")
  valid_580569 = validateParameter(valid_580569, JBool, required = false,
                                 default = newJBool(true))
  if valid_580569 != nil:
    section.add "prettyPrint", valid_580569
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

proc call*(call_580571: Call_YoutubeLiveChatBansInsert_580559; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a new ban to the chat.
  ## 
  let valid = call_580571.validator(path, query, header, formData, body)
  let scheme = call_580571.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580571.url(scheme.get, call_580571.host, call_580571.base,
                         call_580571.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580571, url, valid)

proc call*(call_580572: Call_YoutubeLiveChatBansInsert_580559; part: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## youtubeLiveChatBansInsert
  ## Adds a new ban to the chat.
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
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response returns. Set the parameter value to snippet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580573 = newJObject()
  var body_580574 = newJObject()
  add(query_580573, "fields", newJString(fields))
  add(query_580573, "quotaUser", newJString(quotaUser))
  add(query_580573, "alt", newJString(alt))
  add(query_580573, "oauth_token", newJString(oauthToken))
  add(query_580573, "userIp", newJString(userIp))
  add(query_580573, "part", newJString(part))
  add(query_580573, "key", newJString(key))
  if body != nil:
    body_580574 = body
  add(query_580573, "prettyPrint", newJBool(prettyPrint))
  result = call_580572.call(nil, query_580573, nil, nil, body_580574)

var youtubeLiveChatBansInsert* = Call_YoutubeLiveChatBansInsert_580559(
    name: "youtubeLiveChatBansInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/liveChat/bans",
    validator: validate_YoutubeLiveChatBansInsert_580560, base: "/youtube/v3",
    url: url_YoutubeLiveChatBansInsert_580561, schemes: {Scheme.Https})
type
  Call_YoutubeLiveChatBansDelete_580575 = ref object of OpenApiRestCall_579437
proc url_YoutubeLiveChatBansDelete_580577(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveChatBansDelete_580576(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes a chat ban.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter identifies the chat ban to remove. The value uniquely identifies both the ban and the chat.
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
  var valid_580578 = query.getOrDefault("fields")
  valid_580578 = validateParameter(valid_580578, JString, required = false,
                                 default = nil)
  if valid_580578 != nil:
    section.add "fields", valid_580578
  var valid_580579 = query.getOrDefault("quotaUser")
  valid_580579 = validateParameter(valid_580579, JString, required = false,
                                 default = nil)
  if valid_580579 != nil:
    section.add "quotaUser", valid_580579
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_580580 = query.getOrDefault("id")
  valid_580580 = validateParameter(valid_580580, JString, required = true,
                                 default = nil)
  if valid_580580 != nil:
    section.add "id", valid_580580
  var valid_580581 = query.getOrDefault("alt")
  valid_580581 = validateParameter(valid_580581, JString, required = false,
                                 default = newJString("json"))
  if valid_580581 != nil:
    section.add "alt", valid_580581
  var valid_580582 = query.getOrDefault("oauth_token")
  valid_580582 = validateParameter(valid_580582, JString, required = false,
                                 default = nil)
  if valid_580582 != nil:
    section.add "oauth_token", valid_580582
  var valid_580583 = query.getOrDefault("userIp")
  valid_580583 = validateParameter(valid_580583, JString, required = false,
                                 default = nil)
  if valid_580583 != nil:
    section.add "userIp", valid_580583
  var valid_580584 = query.getOrDefault("key")
  valid_580584 = validateParameter(valid_580584, JString, required = false,
                                 default = nil)
  if valid_580584 != nil:
    section.add "key", valid_580584
  var valid_580585 = query.getOrDefault("prettyPrint")
  valid_580585 = validateParameter(valid_580585, JBool, required = false,
                                 default = newJBool(true))
  if valid_580585 != nil:
    section.add "prettyPrint", valid_580585
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580586: Call_YoutubeLiveChatBansDelete_580575; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a chat ban.
  ## 
  let valid = call_580586.validator(path, query, header, formData, body)
  let scheme = call_580586.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580586.url(scheme.get, call_580586.host, call_580586.base,
                         call_580586.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580586, url, valid)

proc call*(call_580587: Call_YoutubeLiveChatBansDelete_580575; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## youtubeLiveChatBansDelete
  ## Removes a chat ban.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter identifies the chat ban to remove. The value uniquely identifies both the ban and the chat.
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
  var query_580588 = newJObject()
  add(query_580588, "fields", newJString(fields))
  add(query_580588, "quotaUser", newJString(quotaUser))
  add(query_580588, "id", newJString(id))
  add(query_580588, "alt", newJString(alt))
  add(query_580588, "oauth_token", newJString(oauthToken))
  add(query_580588, "userIp", newJString(userIp))
  add(query_580588, "key", newJString(key))
  add(query_580588, "prettyPrint", newJBool(prettyPrint))
  result = call_580587.call(nil, query_580588, nil, nil, nil)

var youtubeLiveChatBansDelete* = Call_YoutubeLiveChatBansDelete_580575(
    name: "youtubeLiveChatBansDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/liveChat/bans",
    validator: validate_YoutubeLiveChatBansDelete_580576, base: "/youtube/v3",
    url: url_YoutubeLiveChatBansDelete_580577, schemes: {Scheme.Https})
type
  Call_YoutubeLiveChatMessagesInsert_580608 = ref object of OpenApiRestCall_579437
proc url_YoutubeLiveChatMessagesInsert_580610(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveChatMessagesInsert_580609(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a message to a live chat.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes. It identifies the properties that the write operation will set as well as the properties that the API response will include. Set the parameter value to snippet.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580611 = query.getOrDefault("fields")
  valid_580611 = validateParameter(valid_580611, JString, required = false,
                                 default = nil)
  if valid_580611 != nil:
    section.add "fields", valid_580611
  var valid_580612 = query.getOrDefault("quotaUser")
  valid_580612 = validateParameter(valid_580612, JString, required = false,
                                 default = nil)
  if valid_580612 != nil:
    section.add "quotaUser", valid_580612
  var valid_580613 = query.getOrDefault("alt")
  valid_580613 = validateParameter(valid_580613, JString, required = false,
                                 default = newJString("json"))
  if valid_580613 != nil:
    section.add "alt", valid_580613
  var valid_580614 = query.getOrDefault("oauth_token")
  valid_580614 = validateParameter(valid_580614, JString, required = false,
                                 default = nil)
  if valid_580614 != nil:
    section.add "oauth_token", valid_580614
  var valid_580615 = query.getOrDefault("userIp")
  valid_580615 = validateParameter(valid_580615, JString, required = false,
                                 default = nil)
  if valid_580615 != nil:
    section.add "userIp", valid_580615
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_580616 = query.getOrDefault("part")
  valid_580616 = validateParameter(valid_580616, JString, required = true,
                                 default = nil)
  if valid_580616 != nil:
    section.add "part", valid_580616
  var valid_580617 = query.getOrDefault("key")
  valid_580617 = validateParameter(valid_580617, JString, required = false,
                                 default = nil)
  if valid_580617 != nil:
    section.add "key", valid_580617
  var valid_580618 = query.getOrDefault("prettyPrint")
  valid_580618 = validateParameter(valid_580618, JBool, required = false,
                                 default = newJBool(true))
  if valid_580618 != nil:
    section.add "prettyPrint", valid_580618
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

proc call*(call_580620: Call_YoutubeLiveChatMessagesInsert_580608; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a message to a live chat.
  ## 
  let valid = call_580620.validator(path, query, header, formData, body)
  let scheme = call_580620.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580620.url(scheme.get, call_580620.host, call_580620.base,
                         call_580620.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580620, url, valid)

proc call*(call_580621: Call_YoutubeLiveChatMessagesInsert_580608; part: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## youtubeLiveChatMessagesInsert
  ## Adds a message to a live chat.
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
  ##   part: string (required)
  ##       : The part parameter serves two purposes. It identifies the properties that the write operation will set as well as the properties that the API response will include. Set the parameter value to snippet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580622 = newJObject()
  var body_580623 = newJObject()
  add(query_580622, "fields", newJString(fields))
  add(query_580622, "quotaUser", newJString(quotaUser))
  add(query_580622, "alt", newJString(alt))
  add(query_580622, "oauth_token", newJString(oauthToken))
  add(query_580622, "userIp", newJString(userIp))
  add(query_580622, "part", newJString(part))
  add(query_580622, "key", newJString(key))
  if body != nil:
    body_580623 = body
  add(query_580622, "prettyPrint", newJBool(prettyPrint))
  result = call_580621.call(nil, query_580622, nil, nil, body_580623)

var youtubeLiveChatMessagesInsert* = Call_YoutubeLiveChatMessagesInsert_580608(
    name: "youtubeLiveChatMessagesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/liveChat/messages",
    validator: validate_YoutubeLiveChatMessagesInsert_580609, base: "/youtube/v3",
    url: url_YoutubeLiveChatMessagesInsert_580610, schemes: {Scheme.Https})
type
  Call_YoutubeLiveChatMessagesList_580589 = ref object of OpenApiRestCall_579437
proc url_YoutubeLiveChatMessagesList_580591(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveChatMessagesList_580590(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists live chat messages for a specific chat.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken property identify other pages that could be retrieved.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of messages that should be returned in the result set.
  ##   part: JString (required)
  ##       : The part parameter specifies the liveChatComment resource parts that the API response will include. Supported values are id and snippet.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   liveChatId: JString (required)
  ##             : The liveChatId parameter specifies the ID of the chat whose messages will be returned.
  ##   profileImageSize: JInt
  ##                   : The profileImageSize parameter specifies the size of the user profile pictures that should be returned in the result set. Default: 88.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   hl: JString
  ##     : The hl parameter instructs the API to retrieve localized resource metadata for a specific application language that the YouTube website supports. The parameter value must be a language code included in the list returned by the i18nLanguages.list method.
  ## 
  ## If localized resource details are available in that language, the resource's snippet.localized object will contain the localized values. However, if localized details are not available, the snippet.localized object will contain resource details in the resource's default language.
  section = newJObject()
  var valid_580592 = query.getOrDefault("fields")
  valid_580592 = validateParameter(valid_580592, JString, required = false,
                                 default = nil)
  if valid_580592 != nil:
    section.add "fields", valid_580592
  var valid_580593 = query.getOrDefault("pageToken")
  valid_580593 = validateParameter(valid_580593, JString, required = false,
                                 default = nil)
  if valid_580593 != nil:
    section.add "pageToken", valid_580593
  var valid_580594 = query.getOrDefault("quotaUser")
  valid_580594 = validateParameter(valid_580594, JString, required = false,
                                 default = nil)
  if valid_580594 != nil:
    section.add "quotaUser", valid_580594
  var valid_580595 = query.getOrDefault("alt")
  valid_580595 = validateParameter(valid_580595, JString, required = false,
                                 default = newJString("json"))
  if valid_580595 != nil:
    section.add "alt", valid_580595
  var valid_580596 = query.getOrDefault("oauth_token")
  valid_580596 = validateParameter(valid_580596, JString, required = false,
                                 default = nil)
  if valid_580596 != nil:
    section.add "oauth_token", valid_580596
  var valid_580597 = query.getOrDefault("userIp")
  valid_580597 = validateParameter(valid_580597, JString, required = false,
                                 default = nil)
  if valid_580597 != nil:
    section.add "userIp", valid_580597
  var valid_580598 = query.getOrDefault("maxResults")
  valid_580598 = validateParameter(valid_580598, JInt, required = false,
                                 default = newJInt(500))
  if valid_580598 != nil:
    section.add "maxResults", valid_580598
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_580599 = query.getOrDefault("part")
  valid_580599 = validateParameter(valid_580599, JString, required = true,
                                 default = nil)
  if valid_580599 != nil:
    section.add "part", valid_580599
  var valid_580600 = query.getOrDefault("key")
  valid_580600 = validateParameter(valid_580600, JString, required = false,
                                 default = nil)
  if valid_580600 != nil:
    section.add "key", valid_580600
  var valid_580601 = query.getOrDefault("liveChatId")
  valid_580601 = validateParameter(valid_580601, JString, required = true,
                                 default = nil)
  if valid_580601 != nil:
    section.add "liveChatId", valid_580601
  var valid_580602 = query.getOrDefault("profileImageSize")
  valid_580602 = validateParameter(valid_580602, JInt, required = false, default = nil)
  if valid_580602 != nil:
    section.add "profileImageSize", valid_580602
  var valid_580603 = query.getOrDefault("prettyPrint")
  valid_580603 = validateParameter(valid_580603, JBool, required = false,
                                 default = newJBool(true))
  if valid_580603 != nil:
    section.add "prettyPrint", valid_580603
  var valid_580604 = query.getOrDefault("hl")
  valid_580604 = validateParameter(valid_580604, JString, required = false,
                                 default = nil)
  if valid_580604 != nil:
    section.add "hl", valid_580604
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580605: Call_YoutubeLiveChatMessagesList_580589; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists live chat messages for a specific chat.
  ## 
  let valid = call_580605.validator(path, query, header, formData, body)
  let scheme = call_580605.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580605.url(scheme.get, call_580605.host, call_580605.base,
                         call_580605.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580605, url, valid)

proc call*(call_580606: Call_YoutubeLiveChatMessagesList_580589; part: string;
          liveChatId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 500; key: string = "";
          profileImageSize: int = 0; prettyPrint: bool = true; hl: string = ""): Recallable =
  ## youtubeLiveChatMessagesList
  ## Lists live chat messages for a specific chat.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken property identify other pages that could be retrieved.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of messages that should be returned in the result set.
  ##   part: string (required)
  ##       : The part parameter specifies the liveChatComment resource parts that the API response will include. Supported values are id and snippet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   liveChatId: string (required)
  ##             : The liveChatId parameter specifies the ID of the chat whose messages will be returned.
  ##   profileImageSize: int
  ##                   : The profileImageSize parameter specifies the size of the user profile pictures that should be returned in the result set. Default: 88.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   hl: string
  ##     : The hl parameter instructs the API to retrieve localized resource metadata for a specific application language that the YouTube website supports. The parameter value must be a language code included in the list returned by the i18nLanguages.list method.
  ## 
  ## If localized resource details are available in that language, the resource's snippet.localized object will contain the localized values. However, if localized details are not available, the snippet.localized object will contain resource details in the resource's default language.
  var query_580607 = newJObject()
  add(query_580607, "fields", newJString(fields))
  add(query_580607, "pageToken", newJString(pageToken))
  add(query_580607, "quotaUser", newJString(quotaUser))
  add(query_580607, "alt", newJString(alt))
  add(query_580607, "oauth_token", newJString(oauthToken))
  add(query_580607, "userIp", newJString(userIp))
  add(query_580607, "maxResults", newJInt(maxResults))
  add(query_580607, "part", newJString(part))
  add(query_580607, "key", newJString(key))
  add(query_580607, "liveChatId", newJString(liveChatId))
  add(query_580607, "profileImageSize", newJInt(profileImageSize))
  add(query_580607, "prettyPrint", newJBool(prettyPrint))
  add(query_580607, "hl", newJString(hl))
  result = call_580606.call(nil, query_580607, nil, nil, nil)

var youtubeLiveChatMessagesList* = Call_YoutubeLiveChatMessagesList_580589(
    name: "youtubeLiveChatMessagesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/liveChat/messages",
    validator: validate_YoutubeLiveChatMessagesList_580590, base: "/youtube/v3",
    url: url_YoutubeLiveChatMessagesList_580591, schemes: {Scheme.Https})
type
  Call_YoutubeLiveChatMessagesDelete_580624 = ref object of OpenApiRestCall_579437
proc url_YoutubeLiveChatMessagesDelete_580626(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveChatMessagesDelete_580625(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a chat message.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the YouTube chat message ID of the resource that is being deleted.
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
  var valid_580627 = query.getOrDefault("fields")
  valid_580627 = validateParameter(valid_580627, JString, required = false,
                                 default = nil)
  if valid_580627 != nil:
    section.add "fields", valid_580627
  var valid_580628 = query.getOrDefault("quotaUser")
  valid_580628 = validateParameter(valid_580628, JString, required = false,
                                 default = nil)
  if valid_580628 != nil:
    section.add "quotaUser", valid_580628
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_580629 = query.getOrDefault("id")
  valid_580629 = validateParameter(valid_580629, JString, required = true,
                                 default = nil)
  if valid_580629 != nil:
    section.add "id", valid_580629
  var valid_580630 = query.getOrDefault("alt")
  valid_580630 = validateParameter(valid_580630, JString, required = false,
                                 default = newJString("json"))
  if valid_580630 != nil:
    section.add "alt", valid_580630
  var valid_580631 = query.getOrDefault("oauth_token")
  valid_580631 = validateParameter(valid_580631, JString, required = false,
                                 default = nil)
  if valid_580631 != nil:
    section.add "oauth_token", valid_580631
  var valid_580632 = query.getOrDefault("userIp")
  valid_580632 = validateParameter(valid_580632, JString, required = false,
                                 default = nil)
  if valid_580632 != nil:
    section.add "userIp", valid_580632
  var valid_580633 = query.getOrDefault("key")
  valid_580633 = validateParameter(valid_580633, JString, required = false,
                                 default = nil)
  if valid_580633 != nil:
    section.add "key", valid_580633
  var valid_580634 = query.getOrDefault("prettyPrint")
  valid_580634 = validateParameter(valid_580634, JBool, required = false,
                                 default = newJBool(true))
  if valid_580634 != nil:
    section.add "prettyPrint", valid_580634
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580635: Call_YoutubeLiveChatMessagesDelete_580624; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a chat message.
  ## 
  let valid = call_580635.validator(path, query, header, formData, body)
  let scheme = call_580635.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580635.url(scheme.get, call_580635.host, call_580635.base,
                         call_580635.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580635, url, valid)

proc call*(call_580636: Call_YoutubeLiveChatMessagesDelete_580624; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## youtubeLiveChatMessagesDelete
  ## Deletes a chat message.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the YouTube chat message ID of the resource that is being deleted.
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
  var query_580637 = newJObject()
  add(query_580637, "fields", newJString(fields))
  add(query_580637, "quotaUser", newJString(quotaUser))
  add(query_580637, "id", newJString(id))
  add(query_580637, "alt", newJString(alt))
  add(query_580637, "oauth_token", newJString(oauthToken))
  add(query_580637, "userIp", newJString(userIp))
  add(query_580637, "key", newJString(key))
  add(query_580637, "prettyPrint", newJBool(prettyPrint))
  result = call_580636.call(nil, query_580637, nil, nil, nil)

var youtubeLiveChatMessagesDelete* = Call_YoutubeLiveChatMessagesDelete_580624(
    name: "youtubeLiveChatMessagesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/liveChat/messages",
    validator: validate_YoutubeLiveChatMessagesDelete_580625, base: "/youtube/v3",
    url: url_YoutubeLiveChatMessagesDelete_580626, schemes: {Scheme.Https})
type
  Call_YoutubeLiveChatModeratorsInsert_580655 = ref object of OpenApiRestCall_579437
proc url_YoutubeLiveChatModeratorsInsert_580657(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveChatModeratorsInsert_580656(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a new moderator for the chat.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response returns. Set the parameter value to snippet.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580658 = query.getOrDefault("fields")
  valid_580658 = validateParameter(valid_580658, JString, required = false,
                                 default = nil)
  if valid_580658 != nil:
    section.add "fields", valid_580658
  var valid_580659 = query.getOrDefault("quotaUser")
  valid_580659 = validateParameter(valid_580659, JString, required = false,
                                 default = nil)
  if valid_580659 != nil:
    section.add "quotaUser", valid_580659
  var valid_580660 = query.getOrDefault("alt")
  valid_580660 = validateParameter(valid_580660, JString, required = false,
                                 default = newJString("json"))
  if valid_580660 != nil:
    section.add "alt", valid_580660
  var valid_580661 = query.getOrDefault("oauth_token")
  valid_580661 = validateParameter(valid_580661, JString, required = false,
                                 default = nil)
  if valid_580661 != nil:
    section.add "oauth_token", valid_580661
  var valid_580662 = query.getOrDefault("userIp")
  valid_580662 = validateParameter(valid_580662, JString, required = false,
                                 default = nil)
  if valid_580662 != nil:
    section.add "userIp", valid_580662
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_580663 = query.getOrDefault("part")
  valid_580663 = validateParameter(valid_580663, JString, required = true,
                                 default = nil)
  if valid_580663 != nil:
    section.add "part", valid_580663
  var valid_580664 = query.getOrDefault("key")
  valid_580664 = validateParameter(valid_580664, JString, required = false,
                                 default = nil)
  if valid_580664 != nil:
    section.add "key", valid_580664
  var valid_580665 = query.getOrDefault("prettyPrint")
  valid_580665 = validateParameter(valid_580665, JBool, required = false,
                                 default = newJBool(true))
  if valid_580665 != nil:
    section.add "prettyPrint", valid_580665
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

proc call*(call_580667: Call_YoutubeLiveChatModeratorsInsert_580655;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds a new moderator for the chat.
  ## 
  let valid = call_580667.validator(path, query, header, formData, body)
  let scheme = call_580667.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580667.url(scheme.get, call_580667.host, call_580667.base,
                         call_580667.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580667, url, valid)

proc call*(call_580668: Call_YoutubeLiveChatModeratorsInsert_580655; part: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## youtubeLiveChatModeratorsInsert
  ## Adds a new moderator for the chat.
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
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response returns. Set the parameter value to snippet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580669 = newJObject()
  var body_580670 = newJObject()
  add(query_580669, "fields", newJString(fields))
  add(query_580669, "quotaUser", newJString(quotaUser))
  add(query_580669, "alt", newJString(alt))
  add(query_580669, "oauth_token", newJString(oauthToken))
  add(query_580669, "userIp", newJString(userIp))
  add(query_580669, "part", newJString(part))
  add(query_580669, "key", newJString(key))
  if body != nil:
    body_580670 = body
  add(query_580669, "prettyPrint", newJBool(prettyPrint))
  result = call_580668.call(nil, query_580669, nil, nil, body_580670)

var youtubeLiveChatModeratorsInsert* = Call_YoutubeLiveChatModeratorsInsert_580655(
    name: "youtubeLiveChatModeratorsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/liveChat/moderators",
    validator: validate_YoutubeLiveChatModeratorsInsert_580656,
    base: "/youtube/v3", url: url_YoutubeLiveChatModeratorsInsert_580657,
    schemes: {Scheme.Https})
type
  Call_YoutubeLiveChatModeratorsList_580638 = ref object of OpenApiRestCall_579437
proc url_YoutubeLiveChatModeratorsList_580640(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveChatModeratorsList_580639(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists moderators for a live chat.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: JString (required)
  ##       : The part parameter specifies the liveChatModerator resource parts that the API response will include. Supported values are id and snippet.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   liveChatId: JString (required)
  ##             : The liveChatId parameter specifies the YouTube live chat for which the API should return moderators.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580641 = query.getOrDefault("fields")
  valid_580641 = validateParameter(valid_580641, JString, required = false,
                                 default = nil)
  if valid_580641 != nil:
    section.add "fields", valid_580641
  var valid_580642 = query.getOrDefault("pageToken")
  valid_580642 = validateParameter(valid_580642, JString, required = false,
                                 default = nil)
  if valid_580642 != nil:
    section.add "pageToken", valid_580642
  var valid_580643 = query.getOrDefault("quotaUser")
  valid_580643 = validateParameter(valid_580643, JString, required = false,
                                 default = nil)
  if valid_580643 != nil:
    section.add "quotaUser", valid_580643
  var valid_580644 = query.getOrDefault("alt")
  valid_580644 = validateParameter(valid_580644, JString, required = false,
                                 default = newJString("json"))
  if valid_580644 != nil:
    section.add "alt", valid_580644
  var valid_580645 = query.getOrDefault("oauth_token")
  valid_580645 = validateParameter(valid_580645, JString, required = false,
                                 default = nil)
  if valid_580645 != nil:
    section.add "oauth_token", valid_580645
  var valid_580646 = query.getOrDefault("userIp")
  valid_580646 = validateParameter(valid_580646, JString, required = false,
                                 default = nil)
  if valid_580646 != nil:
    section.add "userIp", valid_580646
  var valid_580647 = query.getOrDefault("maxResults")
  valid_580647 = validateParameter(valid_580647, JInt, required = false,
                                 default = newJInt(5))
  if valid_580647 != nil:
    section.add "maxResults", valid_580647
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_580648 = query.getOrDefault("part")
  valid_580648 = validateParameter(valid_580648, JString, required = true,
                                 default = nil)
  if valid_580648 != nil:
    section.add "part", valid_580648
  var valid_580649 = query.getOrDefault("key")
  valid_580649 = validateParameter(valid_580649, JString, required = false,
                                 default = nil)
  if valid_580649 != nil:
    section.add "key", valid_580649
  var valid_580650 = query.getOrDefault("liveChatId")
  valid_580650 = validateParameter(valid_580650, JString, required = true,
                                 default = nil)
  if valid_580650 != nil:
    section.add "liveChatId", valid_580650
  var valid_580651 = query.getOrDefault("prettyPrint")
  valid_580651 = validateParameter(valid_580651, JBool, required = false,
                                 default = newJBool(true))
  if valid_580651 != nil:
    section.add "prettyPrint", valid_580651
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580652: Call_YoutubeLiveChatModeratorsList_580638; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists moderators for a live chat.
  ## 
  let valid = call_580652.validator(path, query, header, formData, body)
  let scheme = call_580652.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580652.url(scheme.get, call_580652.host, call_580652.base,
                         call_580652.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580652, url, valid)

proc call*(call_580653: Call_YoutubeLiveChatModeratorsList_580638; part: string;
          liveChatId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 5; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## youtubeLiveChatModeratorsList
  ## Lists moderators for a live chat.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: string (required)
  ##       : The part parameter specifies the liveChatModerator resource parts that the API response will include. Supported values are id and snippet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   liveChatId: string (required)
  ##             : The liveChatId parameter specifies the YouTube live chat for which the API should return moderators.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580654 = newJObject()
  add(query_580654, "fields", newJString(fields))
  add(query_580654, "pageToken", newJString(pageToken))
  add(query_580654, "quotaUser", newJString(quotaUser))
  add(query_580654, "alt", newJString(alt))
  add(query_580654, "oauth_token", newJString(oauthToken))
  add(query_580654, "userIp", newJString(userIp))
  add(query_580654, "maxResults", newJInt(maxResults))
  add(query_580654, "part", newJString(part))
  add(query_580654, "key", newJString(key))
  add(query_580654, "liveChatId", newJString(liveChatId))
  add(query_580654, "prettyPrint", newJBool(prettyPrint))
  result = call_580653.call(nil, query_580654, nil, nil, nil)

var youtubeLiveChatModeratorsList* = Call_YoutubeLiveChatModeratorsList_580638(
    name: "youtubeLiveChatModeratorsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/liveChat/moderators",
    validator: validate_YoutubeLiveChatModeratorsList_580639, base: "/youtube/v3",
    url: url_YoutubeLiveChatModeratorsList_580640, schemes: {Scheme.Https})
type
  Call_YoutubeLiveChatModeratorsDelete_580671 = ref object of OpenApiRestCall_579437
proc url_YoutubeLiveChatModeratorsDelete_580673(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveChatModeratorsDelete_580672(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes a chat moderator.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter identifies the chat moderator to remove. The value uniquely identifies both the moderator and the chat.
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
  var valid_580674 = query.getOrDefault("fields")
  valid_580674 = validateParameter(valid_580674, JString, required = false,
                                 default = nil)
  if valid_580674 != nil:
    section.add "fields", valid_580674
  var valid_580675 = query.getOrDefault("quotaUser")
  valid_580675 = validateParameter(valid_580675, JString, required = false,
                                 default = nil)
  if valid_580675 != nil:
    section.add "quotaUser", valid_580675
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_580676 = query.getOrDefault("id")
  valid_580676 = validateParameter(valid_580676, JString, required = true,
                                 default = nil)
  if valid_580676 != nil:
    section.add "id", valid_580676
  var valid_580677 = query.getOrDefault("alt")
  valid_580677 = validateParameter(valid_580677, JString, required = false,
                                 default = newJString("json"))
  if valid_580677 != nil:
    section.add "alt", valid_580677
  var valid_580678 = query.getOrDefault("oauth_token")
  valid_580678 = validateParameter(valid_580678, JString, required = false,
                                 default = nil)
  if valid_580678 != nil:
    section.add "oauth_token", valid_580678
  var valid_580679 = query.getOrDefault("userIp")
  valid_580679 = validateParameter(valid_580679, JString, required = false,
                                 default = nil)
  if valid_580679 != nil:
    section.add "userIp", valid_580679
  var valid_580680 = query.getOrDefault("key")
  valid_580680 = validateParameter(valid_580680, JString, required = false,
                                 default = nil)
  if valid_580680 != nil:
    section.add "key", valid_580680
  var valid_580681 = query.getOrDefault("prettyPrint")
  valid_580681 = validateParameter(valid_580681, JBool, required = false,
                                 default = newJBool(true))
  if valid_580681 != nil:
    section.add "prettyPrint", valid_580681
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580682: Call_YoutubeLiveChatModeratorsDelete_580671;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a chat moderator.
  ## 
  let valid = call_580682.validator(path, query, header, formData, body)
  let scheme = call_580682.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580682.url(scheme.get, call_580682.host, call_580682.base,
                         call_580682.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580682, url, valid)

proc call*(call_580683: Call_YoutubeLiveChatModeratorsDelete_580671; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## youtubeLiveChatModeratorsDelete
  ## Removes a chat moderator.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter identifies the chat moderator to remove. The value uniquely identifies both the moderator and the chat.
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
  var query_580684 = newJObject()
  add(query_580684, "fields", newJString(fields))
  add(query_580684, "quotaUser", newJString(quotaUser))
  add(query_580684, "id", newJString(id))
  add(query_580684, "alt", newJString(alt))
  add(query_580684, "oauth_token", newJString(oauthToken))
  add(query_580684, "userIp", newJString(userIp))
  add(query_580684, "key", newJString(key))
  add(query_580684, "prettyPrint", newJBool(prettyPrint))
  result = call_580683.call(nil, query_580684, nil, nil, nil)

var youtubeLiveChatModeratorsDelete* = Call_YoutubeLiveChatModeratorsDelete_580671(
    name: "youtubeLiveChatModeratorsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/liveChat/moderators",
    validator: validate_YoutubeLiveChatModeratorsDelete_580672,
    base: "/youtube/v3", url: url_YoutubeLiveChatModeratorsDelete_580673,
    schemes: {Scheme.Https})
type
  Call_YoutubeLiveStreamsUpdate_580705 = ref object of OpenApiRestCall_579437
proc url_YoutubeLiveStreamsUpdate_580707(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveStreamsUpdate_580706(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a video stream. If the properties that you want to change cannot be updated, then you need to create a new stream with the proper settings.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part properties that you can include in the parameter value are id, snippet, cdn, and status.
  ## 
  ## Note that this method will override the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies. If the request body does not specify a value for a mutable property, the existing value for that property will be removed.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  section = newJObject()
  var valid_580708 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580708 = validateParameter(valid_580708, JString, required = false,
                                 default = nil)
  if valid_580708 != nil:
    section.add "onBehalfOfContentOwner", valid_580708
  var valid_580709 = query.getOrDefault("fields")
  valid_580709 = validateParameter(valid_580709, JString, required = false,
                                 default = nil)
  if valid_580709 != nil:
    section.add "fields", valid_580709
  var valid_580710 = query.getOrDefault("quotaUser")
  valid_580710 = validateParameter(valid_580710, JString, required = false,
                                 default = nil)
  if valid_580710 != nil:
    section.add "quotaUser", valid_580710
  var valid_580711 = query.getOrDefault("alt")
  valid_580711 = validateParameter(valid_580711, JString, required = false,
                                 default = newJString("json"))
  if valid_580711 != nil:
    section.add "alt", valid_580711
  var valid_580712 = query.getOrDefault("oauth_token")
  valid_580712 = validateParameter(valid_580712, JString, required = false,
                                 default = nil)
  if valid_580712 != nil:
    section.add "oauth_token", valid_580712
  var valid_580713 = query.getOrDefault("userIp")
  valid_580713 = validateParameter(valid_580713, JString, required = false,
                                 default = nil)
  if valid_580713 != nil:
    section.add "userIp", valid_580713
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_580714 = query.getOrDefault("part")
  valid_580714 = validateParameter(valid_580714, JString, required = true,
                                 default = nil)
  if valid_580714 != nil:
    section.add "part", valid_580714
  var valid_580715 = query.getOrDefault("key")
  valid_580715 = validateParameter(valid_580715, JString, required = false,
                                 default = nil)
  if valid_580715 != nil:
    section.add "key", valid_580715
  var valid_580716 = query.getOrDefault("prettyPrint")
  valid_580716 = validateParameter(valid_580716, JBool, required = false,
                                 default = newJBool(true))
  if valid_580716 != nil:
    section.add "prettyPrint", valid_580716
  var valid_580717 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_580717 = validateParameter(valid_580717, JString, required = false,
                                 default = nil)
  if valid_580717 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_580717
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

proc call*(call_580719: Call_YoutubeLiveStreamsUpdate_580705; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a video stream. If the properties that you want to change cannot be updated, then you need to create a new stream with the proper settings.
  ## 
  let valid = call_580719.validator(path, query, header, formData, body)
  let scheme = call_580719.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580719.url(scheme.get, call_580719.host, call_580719.base,
                         call_580719.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580719, url, valid)

proc call*(call_580720: Call_YoutubeLiveStreamsUpdate_580705; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; onBehalfOfContentOwnerChannel: string = ""): Recallable =
  ## youtubeLiveStreamsUpdate
  ## Updates a video stream. If the properties that you want to change cannot be updated, then you need to create a new stream with the proper settings.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part properties that you can include in the parameter value are id, snippet, cdn, and status.
  ## 
  ## Note that this method will override the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies. If the request body does not specify a value for a mutable property, the existing value for that property will be removed.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  var query_580721 = newJObject()
  var body_580722 = newJObject()
  add(query_580721, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580721, "fields", newJString(fields))
  add(query_580721, "quotaUser", newJString(quotaUser))
  add(query_580721, "alt", newJString(alt))
  add(query_580721, "oauth_token", newJString(oauthToken))
  add(query_580721, "userIp", newJString(userIp))
  add(query_580721, "part", newJString(part))
  add(query_580721, "key", newJString(key))
  if body != nil:
    body_580722 = body
  add(query_580721, "prettyPrint", newJBool(prettyPrint))
  add(query_580721, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  result = call_580720.call(nil, query_580721, nil, nil, body_580722)

var youtubeLiveStreamsUpdate* = Call_YoutubeLiveStreamsUpdate_580705(
    name: "youtubeLiveStreamsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/liveStreams",
    validator: validate_YoutubeLiveStreamsUpdate_580706, base: "/youtube/v3",
    url: url_YoutubeLiveStreamsUpdate_580707, schemes: {Scheme.Https})
type
  Call_YoutubeLiveStreamsInsert_580723 = ref object of OpenApiRestCall_579437
proc url_YoutubeLiveStreamsInsert_580725(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveStreamsInsert_580724(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a video stream. The stream enables you to send your video to YouTube, which can then broadcast the video to your audience.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part properties that you can include in the parameter value are id, snippet, cdn, and status.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  section = newJObject()
  var valid_580726 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580726 = validateParameter(valid_580726, JString, required = false,
                                 default = nil)
  if valid_580726 != nil:
    section.add "onBehalfOfContentOwner", valid_580726
  var valid_580727 = query.getOrDefault("fields")
  valid_580727 = validateParameter(valid_580727, JString, required = false,
                                 default = nil)
  if valid_580727 != nil:
    section.add "fields", valid_580727
  var valid_580728 = query.getOrDefault("quotaUser")
  valid_580728 = validateParameter(valid_580728, JString, required = false,
                                 default = nil)
  if valid_580728 != nil:
    section.add "quotaUser", valid_580728
  var valid_580729 = query.getOrDefault("alt")
  valid_580729 = validateParameter(valid_580729, JString, required = false,
                                 default = newJString("json"))
  if valid_580729 != nil:
    section.add "alt", valid_580729
  var valid_580730 = query.getOrDefault("oauth_token")
  valid_580730 = validateParameter(valid_580730, JString, required = false,
                                 default = nil)
  if valid_580730 != nil:
    section.add "oauth_token", valid_580730
  var valid_580731 = query.getOrDefault("userIp")
  valid_580731 = validateParameter(valid_580731, JString, required = false,
                                 default = nil)
  if valid_580731 != nil:
    section.add "userIp", valid_580731
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_580732 = query.getOrDefault("part")
  valid_580732 = validateParameter(valid_580732, JString, required = true,
                                 default = nil)
  if valid_580732 != nil:
    section.add "part", valid_580732
  var valid_580733 = query.getOrDefault("key")
  valid_580733 = validateParameter(valid_580733, JString, required = false,
                                 default = nil)
  if valid_580733 != nil:
    section.add "key", valid_580733
  var valid_580734 = query.getOrDefault("prettyPrint")
  valid_580734 = validateParameter(valid_580734, JBool, required = false,
                                 default = newJBool(true))
  if valid_580734 != nil:
    section.add "prettyPrint", valid_580734
  var valid_580735 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_580735 = validateParameter(valid_580735, JString, required = false,
                                 default = nil)
  if valid_580735 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_580735
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

proc call*(call_580737: Call_YoutubeLiveStreamsInsert_580723; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a video stream. The stream enables you to send your video to YouTube, which can then broadcast the video to your audience.
  ## 
  let valid = call_580737.validator(path, query, header, formData, body)
  let scheme = call_580737.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580737.url(scheme.get, call_580737.host, call_580737.base,
                         call_580737.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580737, url, valid)

proc call*(call_580738: Call_YoutubeLiveStreamsInsert_580723; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; onBehalfOfContentOwnerChannel: string = ""): Recallable =
  ## youtubeLiveStreamsInsert
  ## Creates a video stream. The stream enables you to send your video to YouTube, which can then broadcast the video to your audience.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## The part properties that you can include in the parameter value are id, snippet, cdn, and status.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  var query_580739 = newJObject()
  var body_580740 = newJObject()
  add(query_580739, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580739, "fields", newJString(fields))
  add(query_580739, "quotaUser", newJString(quotaUser))
  add(query_580739, "alt", newJString(alt))
  add(query_580739, "oauth_token", newJString(oauthToken))
  add(query_580739, "userIp", newJString(userIp))
  add(query_580739, "part", newJString(part))
  add(query_580739, "key", newJString(key))
  if body != nil:
    body_580740 = body
  add(query_580739, "prettyPrint", newJBool(prettyPrint))
  add(query_580739, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  result = call_580738.call(nil, query_580739, nil, nil, body_580740)

var youtubeLiveStreamsInsert* = Call_YoutubeLiveStreamsInsert_580723(
    name: "youtubeLiveStreamsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/liveStreams",
    validator: validate_YoutubeLiveStreamsInsert_580724, base: "/youtube/v3",
    url: url_YoutubeLiveStreamsInsert_580725, schemes: {Scheme.Https})
type
  Call_YoutubeLiveStreamsList_580685 = ref object of OpenApiRestCall_579437
proc url_YoutubeLiveStreamsList_580687(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveStreamsList_580686(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of video streams that match the API request parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   mine: JBool
  ##       : The mine parameter can be used to instruct the API to only return streams owned by the authenticated user. Set the parameter value to true to only retrieve your own streams.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of YouTube stream IDs that identify the streams being retrieved. In a liveStream resource, the id property specifies the stream's ID.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more liveStream resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, cdn, and status.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  section = newJObject()
  var valid_580688 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580688 = validateParameter(valid_580688, JString, required = false,
                                 default = nil)
  if valid_580688 != nil:
    section.add "onBehalfOfContentOwner", valid_580688
  var valid_580689 = query.getOrDefault("mine")
  valid_580689 = validateParameter(valid_580689, JBool, required = false, default = nil)
  if valid_580689 != nil:
    section.add "mine", valid_580689
  var valid_580690 = query.getOrDefault("fields")
  valid_580690 = validateParameter(valid_580690, JString, required = false,
                                 default = nil)
  if valid_580690 != nil:
    section.add "fields", valid_580690
  var valid_580691 = query.getOrDefault("pageToken")
  valid_580691 = validateParameter(valid_580691, JString, required = false,
                                 default = nil)
  if valid_580691 != nil:
    section.add "pageToken", valid_580691
  var valid_580692 = query.getOrDefault("quotaUser")
  valid_580692 = validateParameter(valid_580692, JString, required = false,
                                 default = nil)
  if valid_580692 != nil:
    section.add "quotaUser", valid_580692
  var valid_580693 = query.getOrDefault("id")
  valid_580693 = validateParameter(valid_580693, JString, required = false,
                                 default = nil)
  if valid_580693 != nil:
    section.add "id", valid_580693
  var valid_580694 = query.getOrDefault("alt")
  valid_580694 = validateParameter(valid_580694, JString, required = false,
                                 default = newJString("json"))
  if valid_580694 != nil:
    section.add "alt", valid_580694
  var valid_580695 = query.getOrDefault("oauth_token")
  valid_580695 = validateParameter(valid_580695, JString, required = false,
                                 default = nil)
  if valid_580695 != nil:
    section.add "oauth_token", valid_580695
  var valid_580696 = query.getOrDefault("userIp")
  valid_580696 = validateParameter(valid_580696, JString, required = false,
                                 default = nil)
  if valid_580696 != nil:
    section.add "userIp", valid_580696
  var valid_580697 = query.getOrDefault("maxResults")
  valid_580697 = validateParameter(valid_580697, JInt, required = false,
                                 default = newJInt(5))
  if valid_580697 != nil:
    section.add "maxResults", valid_580697
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_580698 = query.getOrDefault("part")
  valid_580698 = validateParameter(valid_580698, JString, required = true,
                                 default = nil)
  if valid_580698 != nil:
    section.add "part", valid_580698
  var valid_580699 = query.getOrDefault("key")
  valid_580699 = validateParameter(valid_580699, JString, required = false,
                                 default = nil)
  if valid_580699 != nil:
    section.add "key", valid_580699
  var valid_580700 = query.getOrDefault("prettyPrint")
  valid_580700 = validateParameter(valid_580700, JBool, required = false,
                                 default = newJBool(true))
  if valid_580700 != nil:
    section.add "prettyPrint", valid_580700
  var valid_580701 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_580701 = validateParameter(valid_580701, JString, required = false,
                                 default = nil)
  if valid_580701 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_580701
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580702: Call_YoutubeLiveStreamsList_580685; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of video streams that match the API request parameters.
  ## 
  let valid = call_580702.validator(path, query, header, formData, body)
  let scheme = call_580702.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580702.url(scheme.get, call_580702.host, call_580702.base,
                         call_580702.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580702, url, valid)

proc call*(call_580703: Call_YoutubeLiveStreamsList_580685; part: string;
          onBehalfOfContentOwner: string = ""; mine: bool = false; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; id: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 5; key: string = ""; prettyPrint: bool = true;
          onBehalfOfContentOwnerChannel: string = ""): Recallable =
  ## youtubeLiveStreamsList
  ## Returns a list of video streams that match the API request parameters.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   mine: bool
  ##       : The mine parameter can be used to instruct the API to only return streams owned by the authenticated user. Set the parameter value to true to only retrieve your own streams.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of YouTube stream IDs that identify the streams being retrieved. In a liveStream resource, the id property specifies the stream's ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more liveStream resource properties that the API response will include. The part names that you can include in the parameter value are id, snippet, cdn, and status.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  var query_580704 = newJObject()
  add(query_580704, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580704, "mine", newJBool(mine))
  add(query_580704, "fields", newJString(fields))
  add(query_580704, "pageToken", newJString(pageToken))
  add(query_580704, "quotaUser", newJString(quotaUser))
  add(query_580704, "id", newJString(id))
  add(query_580704, "alt", newJString(alt))
  add(query_580704, "oauth_token", newJString(oauthToken))
  add(query_580704, "userIp", newJString(userIp))
  add(query_580704, "maxResults", newJInt(maxResults))
  add(query_580704, "part", newJString(part))
  add(query_580704, "key", newJString(key))
  add(query_580704, "prettyPrint", newJBool(prettyPrint))
  add(query_580704, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  result = call_580703.call(nil, query_580704, nil, nil, nil)

var youtubeLiveStreamsList* = Call_YoutubeLiveStreamsList_580685(
    name: "youtubeLiveStreamsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/liveStreams",
    validator: validate_YoutubeLiveStreamsList_580686, base: "/youtube/v3",
    url: url_YoutubeLiveStreamsList_580687, schemes: {Scheme.Https})
type
  Call_YoutubeLiveStreamsDelete_580741 = ref object of OpenApiRestCall_579437
proc url_YoutubeLiveStreamsDelete_580743(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeLiveStreamsDelete_580742(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a video stream.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the YouTube live stream ID for the resource that is being deleted.
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
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  section = newJObject()
  var valid_580744 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580744 = validateParameter(valid_580744, JString, required = false,
                                 default = nil)
  if valid_580744 != nil:
    section.add "onBehalfOfContentOwner", valid_580744
  var valid_580745 = query.getOrDefault("fields")
  valid_580745 = validateParameter(valid_580745, JString, required = false,
                                 default = nil)
  if valid_580745 != nil:
    section.add "fields", valid_580745
  var valid_580746 = query.getOrDefault("quotaUser")
  valid_580746 = validateParameter(valid_580746, JString, required = false,
                                 default = nil)
  if valid_580746 != nil:
    section.add "quotaUser", valid_580746
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_580747 = query.getOrDefault("id")
  valid_580747 = validateParameter(valid_580747, JString, required = true,
                                 default = nil)
  if valid_580747 != nil:
    section.add "id", valid_580747
  var valid_580748 = query.getOrDefault("alt")
  valid_580748 = validateParameter(valid_580748, JString, required = false,
                                 default = newJString("json"))
  if valid_580748 != nil:
    section.add "alt", valid_580748
  var valid_580749 = query.getOrDefault("oauth_token")
  valid_580749 = validateParameter(valid_580749, JString, required = false,
                                 default = nil)
  if valid_580749 != nil:
    section.add "oauth_token", valid_580749
  var valid_580750 = query.getOrDefault("userIp")
  valid_580750 = validateParameter(valid_580750, JString, required = false,
                                 default = nil)
  if valid_580750 != nil:
    section.add "userIp", valid_580750
  var valid_580751 = query.getOrDefault("key")
  valid_580751 = validateParameter(valid_580751, JString, required = false,
                                 default = nil)
  if valid_580751 != nil:
    section.add "key", valid_580751
  var valid_580752 = query.getOrDefault("prettyPrint")
  valid_580752 = validateParameter(valid_580752, JBool, required = false,
                                 default = newJBool(true))
  if valid_580752 != nil:
    section.add "prettyPrint", valid_580752
  var valid_580753 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_580753 = validateParameter(valid_580753, JString, required = false,
                                 default = nil)
  if valid_580753 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_580753
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580754: Call_YoutubeLiveStreamsDelete_580741; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a video stream.
  ## 
  let valid = call_580754.validator(path, query, header, formData, body)
  let scheme = call_580754.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580754.url(scheme.get, call_580754.host, call_580754.base,
                         call_580754.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580754, url, valid)

proc call*(call_580755: Call_YoutubeLiveStreamsDelete_580741; id: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true;
          onBehalfOfContentOwnerChannel: string = ""): Recallable =
  ## youtubeLiveStreamsDelete
  ## Deletes a video stream.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the YouTube live stream ID for the resource that is being deleted.
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
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  var query_580756 = newJObject()
  add(query_580756, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580756, "fields", newJString(fields))
  add(query_580756, "quotaUser", newJString(quotaUser))
  add(query_580756, "id", newJString(id))
  add(query_580756, "alt", newJString(alt))
  add(query_580756, "oauth_token", newJString(oauthToken))
  add(query_580756, "userIp", newJString(userIp))
  add(query_580756, "key", newJString(key))
  add(query_580756, "prettyPrint", newJBool(prettyPrint))
  add(query_580756, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  result = call_580755.call(nil, query_580756, nil, nil, nil)

var youtubeLiveStreamsDelete* = Call_YoutubeLiveStreamsDelete_580741(
    name: "youtubeLiveStreamsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/liveStreams",
    validator: validate_YoutubeLiveStreamsDelete_580742, base: "/youtube/v3",
    url: url_YoutubeLiveStreamsDelete_580743, schemes: {Scheme.Https})
type
  Call_YoutubeMembersList_580757 = ref object of OpenApiRestCall_579437
proc url_YoutubeMembersList_580759(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeMembersList_580758(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists members for a channel.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   mode: JString
  ##       : The mode parameter specifies which channel members to return.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   hasAccessToLevel: JString
  ##                   : The hasAccessToLevel parameter specifies, when set, the ID of a pricing level that members from the results set should have access to. When not set, all members will be considered, regardless of their active pricing level.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: JString (required)
  ##       : The part parameter specifies the member resource parts that the API response will include. Supported values are id and snippet.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580760 = query.getOrDefault("fields")
  valid_580760 = validateParameter(valid_580760, JString, required = false,
                                 default = nil)
  if valid_580760 != nil:
    section.add "fields", valid_580760
  var valid_580761 = query.getOrDefault("pageToken")
  valid_580761 = validateParameter(valid_580761, JString, required = false,
                                 default = nil)
  if valid_580761 != nil:
    section.add "pageToken", valid_580761
  var valid_580762 = query.getOrDefault("quotaUser")
  valid_580762 = validateParameter(valid_580762, JString, required = false,
                                 default = nil)
  if valid_580762 != nil:
    section.add "quotaUser", valid_580762
  var valid_580763 = query.getOrDefault("alt")
  valid_580763 = validateParameter(valid_580763, JString, required = false,
                                 default = newJString("json"))
  if valid_580763 != nil:
    section.add "alt", valid_580763
  var valid_580764 = query.getOrDefault("oauth_token")
  valid_580764 = validateParameter(valid_580764, JString, required = false,
                                 default = nil)
  if valid_580764 != nil:
    section.add "oauth_token", valid_580764
  var valid_580765 = query.getOrDefault("mode")
  valid_580765 = validateParameter(valid_580765, JString, required = false,
                                 default = newJString("all_current"))
  if valid_580765 != nil:
    section.add "mode", valid_580765
  var valid_580766 = query.getOrDefault("userIp")
  valid_580766 = validateParameter(valid_580766, JString, required = false,
                                 default = nil)
  if valid_580766 != nil:
    section.add "userIp", valid_580766
  var valid_580767 = query.getOrDefault("hasAccessToLevel")
  valid_580767 = validateParameter(valid_580767, JString, required = false,
                                 default = nil)
  if valid_580767 != nil:
    section.add "hasAccessToLevel", valid_580767
  var valid_580768 = query.getOrDefault("maxResults")
  valid_580768 = validateParameter(valid_580768, JInt, required = false,
                                 default = newJInt(5))
  if valid_580768 != nil:
    section.add "maxResults", valid_580768
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_580769 = query.getOrDefault("part")
  valid_580769 = validateParameter(valid_580769, JString, required = true,
                                 default = nil)
  if valid_580769 != nil:
    section.add "part", valid_580769
  var valid_580770 = query.getOrDefault("key")
  valid_580770 = validateParameter(valid_580770, JString, required = false,
                                 default = nil)
  if valid_580770 != nil:
    section.add "key", valid_580770
  var valid_580771 = query.getOrDefault("prettyPrint")
  valid_580771 = validateParameter(valid_580771, JBool, required = false,
                                 default = newJBool(true))
  if valid_580771 != nil:
    section.add "prettyPrint", valid_580771
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580772: Call_YoutubeMembersList_580757; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists members for a channel.
  ## 
  let valid = call_580772.validator(path, query, header, formData, body)
  let scheme = call_580772.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580772.url(scheme.get, call_580772.host, call_580772.base,
                         call_580772.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580772, url, valid)

proc call*(call_580773: Call_YoutubeMembersList_580757; part: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; mode: string = "all_current";
          userIp: string = ""; hasAccessToLevel: string = ""; maxResults: int = 5;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## youtubeMembersList
  ## Lists members for a channel.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   mode: string
  ##       : The mode parameter specifies which channel members to return.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   hasAccessToLevel: string
  ##                   : The hasAccessToLevel parameter specifies, when set, the ID of a pricing level that members from the results set should have access to. When not set, all members will be considered, regardless of their active pricing level.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: string (required)
  ##       : The part parameter specifies the member resource parts that the API response will include. Supported values are id and snippet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580774 = newJObject()
  add(query_580774, "fields", newJString(fields))
  add(query_580774, "pageToken", newJString(pageToken))
  add(query_580774, "quotaUser", newJString(quotaUser))
  add(query_580774, "alt", newJString(alt))
  add(query_580774, "oauth_token", newJString(oauthToken))
  add(query_580774, "mode", newJString(mode))
  add(query_580774, "userIp", newJString(userIp))
  add(query_580774, "hasAccessToLevel", newJString(hasAccessToLevel))
  add(query_580774, "maxResults", newJInt(maxResults))
  add(query_580774, "part", newJString(part))
  add(query_580774, "key", newJString(key))
  add(query_580774, "prettyPrint", newJBool(prettyPrint))
  result = call_580773.call(nil, query_580774, nil, nil, nil)

var youtubeMembersList* = Call_YoutubeMembersList_580757(
    name: "youtubeMembersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/members",
    validator: validate_YoutubeMembersList_580758, base: "/youtube/v3",
    url: url_YoutubeMembersList_580759, schemes: {Scheme.Https})
type
  Call_YoutubeMembershipsLevelsList_580775 = ref object of OpenApiRestCall_579437
proc url_YoutubeMembershipsLevelsList_580777(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeMembershipsLevelsList_580776(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists pricing levels for a channel.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  ##   part: JString (required)
  ##       : The part parameter specifies the membershipsLevel resource parts that the API response will include. Supported values are id and snippet.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580778 = query.getOrDefault("fields")
  valid_580778 = validateParameter(valid_580778, JString, required = false,
                                 default = nil)
  if valid_580778 != nil:
    section.add "fields", valid_580778
  var valid_580779 = query.getOrDefault("quotaUser")
  valid_580779 = validateParameter(valid_580779, JString, required = false,
                                 default = nil)
  if valid_580779 != nil:
    section.add "quotaUser", valid_580779
  var valid_580780 = query.getOrDefault("alt")
  valid_580780 = validateParameter(valid_580780, JString, required = false,
                                 default = newJString("json"))
  if valid_580780 != nil:
    section.add "alt", valid_580780
  var valid_580781 = query.getOrDefault("oauth_token")
  valid_580781 = validateParameter(valid_580781, JString, required = false,
                                 default = nil)
  if valid_580781 != nil:
    section.add "oauth_token", valid_580781
  var valid_580782 = query.getOrDefault("userIp")
  valid_580782 = validateParameter(valid_580782, JString, required = false,
                                 default = nil)
  if valid_580782 != nil:
    section.add "userIp", valid_580782
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_580783 = query.getOrDefault("part")
  valid_580783 = validateParameter(valid_580783, JString, required = true,
                                 default = nil)
  if valid_580783 != nil:
    section.add "part", valid_580783
  var valid_580784 = query.getOrDefault("key")
  valid_580784 = validateParameter(valid_580784, JString, required = false,
                                 default = nil)
  if valid_580784 != nil:
    section.add "key", valid_580784
  var valid_580785 = query.getOrDefault("prettyPrint")
  valid_580785 = validateParameter(valid_580785, JBool, required = false,
                                 default = newJBool(true))
  if valid_580785 != nil:
    section.add "prettyPrint", valid_580785
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580786: Call_YoutubeMembershipsLevelsList_580775; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists pricing levels for a channel.
  ## 
  let valid = call_580786.validator(path, query, header, formData, body)
  let scheme = call_580786.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580786.url(scheme.get, call_580786.host, call_580786.base,
                         call_580786.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580786, url, valid)

proc call*(call_580787: Call_YoutubeMembershipsLevelsList_580775; part: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## youtubeMembershipsLevelsList
  ## Lists pricing levels for a channel.
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
  ##   part: string (required)
  ##       : The part parameter specifies the membershipsLevel resource parts that the API response will include. Supported values are id and snippet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580788 = newJObject()
  add(query_580788, "fields", newJString(fields))
  add(query_580788, "quotaUser", newJString(quotaUser))
  add(query_580788, "alt", newJString(alt))
  add(query_580788, "oauth_token", newJString(oauthToken))
  add(query_580788, "userIp", newJString(userIp))
  add(query_580788, "part", newJString(part))
  add(query_580788, "key", newJString(key))
  add(query_580788, "prettyPrint", newJBool(prettyPrint))
  result = call_580787.call(nil, query_580788, nil, nil, nil)

var youtubeMembershipsLevelsList* = Call_YoutubeMembershipsLevelsList_580775(
    name: "youtubeMembershipsLevelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/membershipsLevels",
    validator: validate_YoutubeMembershipsLevelsList_580776, base: "/youtube/v3",
    url: url_YoutubeMembershipsLevelsList_580777, schemes: {Scheme.Https})
type
  Call_YoutubePlaylistItemsUpdate_580809 = ref object of OpenApiRestCall_579437
proc url_YoutubePlaylistItemsUpdate_580811(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubePlaylistItemsUpdate_580810(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modifies a playlist item. For example, you could update the item's position in the playlist.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## Note that this method will override the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies. For example, a playlist item can specify a start time and end time, which identify the times portion of the video that should play when users watch the video in the playlist. If your request is updating a playlist item that sets these values, and the request's part parameter value includes the contentDetails part, the playlist item's start and end times will be updated to whatever value the request body specifies. If the request body does not specify values, the existing start and end times will be removed and replaced with the default settings.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580812 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580812 = validateParameter(valid_580812, JString, required = false,
                                 default = nil)
  if valid_580812 != nil:
    section.add "onBehalfOfContentOwner", valid_580812
  var valid_580813 = query.getOrDefault("fields")
  valid_580813 = validateParameter(valid_580813, JString, required = false,
                                 default = nil)
  if valid_580813 != nil:
    section.add "fields", valid_580813
  var valid_580814 = query.getOrDefault("quotaUser")
  valid_580814 = validateParameter(valid_580814, JString, required = false,
                                 default = nil)
  if valid_580814 != nil:
    section.add "quotaUser", valid_580814
  var valid_580815 = query.getOrDefault("alt")
  valid_580815 = validateParameter(valid_580815, JString, required = false,
                                 default = newJString("json"))
  if valid_580815 != nil:
    section.add "alt", valid_580815
  var valid_580816 = query.getOrDefault("oauth_token")
  valid_580816 = validateParameter(valid_580816, JString, required = false,
                                 default = nil)
  if valid_580816 != nil:
    section.add "oauth_token", valid_580816
  var valid_580817 = query.getOrDefault("userIp")
  valid_580817 = validateParameter(valid_580817, JString, required = false,
                                 default = nil)
  if valid_580817 != nil:
    section.add "userIp", valid_580817
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_580818 = query.getOrDefault("part")
  valid_580818 = validateParameter(valid_580818, JString, required = true,
                                 default = nil)
  if valid_580818 != nil:
    section.add "part", valid_580818
  var valid_580819 = query.getOrDefault("key")
  valid_580819 = validateParameter(valid_580819, JString, required = false,
                                 default = nil)
  if valid_580819 != nil:
    section.add "key", valid_580819
  var valid_580820 = query.getOrDefault("prettyPrint")
  valid_580820 = validateParameter(valid_580820, JBool, required = false,
                                 default = newJBool(true))
  if valid_580820 != nil:
    section.add "prettyPrint", valid_580820
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

proc call*(call_580822: Call_YoutubePlaylistItemsUpdate_580809; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies a playlist item. For example, you could update the item's position in the playlist.
  ## 
  let valid = call_580822.validator(path, query, header, formData, body)
  let scheme = call_580822.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580822.url(scheme.get, call_580822.host, call_580822.base,
                         call_580822.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580822, url, valid)

proc call*(call_580823: Call_YoutubePlaylistItemsUpdate_580809; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## youtubePlaylistItemsUpdate
  ## Modifies a playlist item. For example, you could update the item's position in the playlist.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## Note that this method will override the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies. For example, a playlist item can specify a start time and end time, which identify the times portion of the video that should play when users watch the video in the playlist. If your request is updating a playlist item that sets these values, and the request's part parameter value includes the contentDetails part, the playlist item's start and end times will be updated to whatever value the request body specifies. If the request body does not specify values, the existing start and end times will be removed and replaced with the default settings.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580824 = newJObject()
  var body_580825 = newJObject()
  add(query_580824, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580824, "fields", newJString(fields))
  add(query_580824, "quotaUser", newJString(quotaUser))
  add(query_580824, "alt", newJString(alt))
  add(query_580824, "oauth_token", newJString(oauthToken))
  add(query_580824, "userIp", newJString(userIp))
  add(query_580824, "part", newJString(part))
  add(query_580824, "key", newJString(key))
  if body != nil:
    body_580825 = body
  add(query_580824, "prettyPrint", newJBool(prettyPrint))
  result = call_580823.call(nil, query_580824, nil, nil, body_580825)

var youtubePlaylistItemsUpdate* = Call_YoutubePlaylistItemsUpdate_580809(
    name: "youtubePlaylistItemsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/playlistItems",
    validator: validate_YoutubePlaylistItemsUpdate_580810, base: "/youtube/v3",
    url: url_YoutubePlaylistItemsUpdate_580811, schemes: {Scheme.Https})
type
  Call_YoutubePlaylistItemsInsert_580826 = ref object of OpenApiRestCall_579437
proc url_YoutubePlaylistItemsInsert_580828(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubePlaylistItemsInsert_580827(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a resource to a playlist.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580829 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580829 = validateParameter(valid_580829, JString, required = false,
                                 default = nil)
  if valid_580829 != nil:
    section.add "onBehalfOfContentOwner", valid_580829
  var valid_580830 = query.getOrDefault("fields")
  valid_580830 = validateParameter(valid_580830, JString, required = false,
                                 default = nil)
  if valid_580830 != nil:
    section.add "fields", valid_580830
  var valid_580831 = query.getOrDefault("quotaUser")
  valid_580831 = validateParameter(valid_580831, JString, required = false,
                                 default = nil)
  if valid_580831 != nil:
    section.add "quotaUser", valid_580831
  var valid_580832 = query.getOrDefault("alt")
  valid_580832 = validateParameter(valid_580832, JString, required = false,
                                 default = newJString("json"))
  if valid_580832 != nil:
    section.add "alt", valid_580832
  var valid_580833 = query.getOrDefault("oauth_token")
  valid_580833 = validateParameter(valid_580833, JString, required = false,
                                 default = nil)
  if valid_580833 != nil:
    section.add "oauth_token", valid_580833
  var valid_580834 = query.getOrDefault("userIp")
  valid_580834 = validateParameter(valid_580834, JString, required = false,
                                 default = nil)
  if valid_580834 != nil:
    section.add "userIp", valid_580834
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_580835 = query.getOrDefault("part")
  valid_580835 = validateParameter(valid_580835, JString, required = true,
                                 default = nil)
  if valid_580835 != nil:
    section.add "part", valid_580835
  var valid_580836 = query.getOrDefault("key")
  valid_580836 = validateParameter(valid_580836, JString, required = false,
                                 default = nil)
  if valid_580836 != nil:
    section.add "key", valid_580836
  var valid_580837 = query.getOrDefault("prettyPrint")
  valid_580837 = validateParameter(valid_580837, JBool, required = false,
                                 default = newJBool(true))
  if valid_580837 != nil:
    section.add "prettyPrint", valid_580837
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

proc call*(call_580839: Call_YoutubePlaylistItemsInsert_580826; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a resource to a playlist.
  ## 
  let valid = call_580839.validator(path, query, header, formData, body)
  let scheme = call_580839.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580839.url(scheme.get, call_580839.host, call_580839.base,
                         call_580839.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580839, url, valid)

proc call*(call_580840: Call_YoutubePlaylistItemsInsert_580826; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## youtubePlaylistItemsInsert
  ## Adds a resource to a playlist.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580841 = newJObject()
  var body_580842 = newJObject()
  add(query_580841, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580841, "fields", newJString(fields))
  add(query_580841, "quotaUser", newJString(quotaUser))
  add(query_580841, "alt", newJString(alt))
  add(query_580841, "oauth_token", newJString(oauthToken))
  add(query_580841, "userIp", newJString(userIp))
  add(query_580841, "part", newJString(part))
  add(query_580841, "key", newJString(key))
  if body != nil:
    body_580842 = body
  add(query_580841, "prettyPrint", newJBool(prettyPrint))
  result = call_580840.call(nil, query_580841, nil, nil, body_580842)

var youtubePlaylistItemsInsert* = Call_YoutubePlaylistItemsInsert_580826(
    name: "youtubePlaylistItemsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/playlistItems",
    validator: validate_YoutubePlaylistItemsInsert_580827, base: "/youtube/v3",
    url: url_YoutubePlaylistItemsInsert_580828, schemes: {Scheme.Https})
type
  Call_YoutubePlaylistItemsList_580789 = ref object of OpenApiRestCall_579437
proc url_YoutubePlaylistItemsList_580791(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubePlaylistItemsList_580790(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a collection of playlist items that match the API request parameters. You can retrieve all of the playlist items in a specified playlist or retrieve one or more playlist items by their unique IDs.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   playlistId: JString
  ##             : The playlistId parameter specifies the unique ID of the playlist for which you want to retrieve playlist items. Note that even though this is an optional parameter, every request to retrieve playlist items must specify a value for either the id parameter or the playlistId parameter.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of one or more unique playlist item IDs.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   videoId: JString
  ##          : The videoId parameter specifies that the request should return only the playlist items that contain the specified video.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more playlistItem resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a playlistItem resource, the snippet property contains numerous fields, including the title, description, position, and resourceId properties. As such, if you set part=snippet, the API response will contain all of those properties.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580792 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580792 = validateParameter(valid_580792, JString, required = false,
                                 default = nil)
  if valid_580792 != nil:
    section.add "onBehalfOfContentOwner", valid_580792
  var valid_580793 = query.getOrDefault("playlistId")
  valid_580793 = validateParameter(valid_580793, JString, required = false,
                                 default = nil)
  if valid_580793 != nil:
    section.add "playlistId", valid_580793
  var valid_580794 = query.getOrDefault("fields")
  valid_580794 = validateParameter(valid_580794, JString, required = false,
                                 default = nil)
  if valid_580794 != nil:
    section.add "fields", valid_580794
  var valid_580795 = query.getOrDefault("pageToken")
  valid_580795 = validateParameter(valid_580795, JString, required = false,
                                 default = nil)
  if valid_580795 != nil:
    section.add "pageToken", valid_580795
  var valid_580796 = query.getOrDefault("quotaUser")
  valid_580796 = validateParameter(valid_580796, JString, required = false,
                                 default = nil)
  if valid_580796 != nil:
    section.add "quotaUser", valid_580796
  var valid_580797 = query.getOrDefault("id")
  valid_580797 = validateParameter(valid_580797, JString, required = false,
                                 default = nil)
  if valid_580797 != nil:
    section.add "id", valid_580797
  var valid_580798 = query.getOrDefault("alt")
  valid_580798 = validateParameter(valid_580798, JString, required = false,
                                 default = newJString("json"))
  if valid_580798 != nil:
    section.add "alt", valid_580798
  var valid_580799 = query.getOrDefault("oauth_token")
  valid_580799 = validateParameter(valid_580799, JString, required = false,
                                 default = nil)
  if valid_580799 != nil:
    section.add "oauth_token", valid_580799
  var valid_580800 = query.getOrDefault("userIp")
  valid_580800 = validateParameter(valid_580800, JString, required = false,
                                 default = nil)
  if valid_580800 != nil:
    section.add "userIp", valid_580800
  var valid_580801 = query.getOrDefault("videoId")
  valid_580801 = validateParameter(valid_580801, JString, required = false,
                                 default = nil)
  if valid_580801 != nil:
    section.add "videoId", valid_580801
  var valid_580802 = query.getOrDefault("maxResults")
  valid_580802 = validateParameter(valid_580802, JInt, required = false,
                                 default = newJInt(5))
  if valid_580802 != nil:
    section.add "maxResults", valid_580802
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_580803 = query.getOrDefault("part")
  valid_580803 = validateParameter(valid_580803, JString, required = true,
                                 default = nil)
  if valid_580803 != nil:
    section.add "part", valid_580803
  var valid_580804 = query.getOrDefault("key")
  valid_580804 = validateParameter(valid_580804, JString, required = false,
                                 default = nil)
  if valid_580804 != nil:
    section.add "key", valid_580804
  var valid_580805 = query.getOrDefault("prettyPrint")
  valid_580805 = validateParameter(valid_580805, JBool, required = false,
                                 default = newJBool(true))
  if valid_580805 != nil:
    section.add "prettyPrint", valid_580805
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580806: Call_YoutubePlaylistItemsList_580789; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of playlist items that match the API request parameters. You can retrieve all of the playlist items in a specified playlist or retrieve one or more playlist items by their unique IDs.
  ## 
  let valid = call_580806.validator(path, query, header, formData, body)
  let scheme = call_580806.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580806.url(scheme.get, call_580806.host, call_580806.base,
                         call_580806.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580806, url, valid)

proc call*(call_580807: Call_YoutubePlaylistItemsList_580789; part: string;
          onBehalfOfContentOwner: string = ""; playlistId: string = "";
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          id: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; videoId: string = ""; maxResults: int = 5; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## youtubePlaylistItemsList
  ## Returns a collection of playlist items that match the API request parameters. You can retrieve all of the playlist items in a specified playlist or retrieve one or more playlist items by their unique IDs.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   playlistId: string
  ##             : The playlistId parameter specifies the unique ID of the playlist for which you want to retrieve playlist items. Note that even though this is an optional parameter, every request to retrieve playlist items must specify a value for either the id parameter or the playlistId parameter.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of one or more unique playlist item IDs.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   videoId: string
  ##          : The videoId parameter specifies that the request should return only the playlist items that contain the specified video.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more playlistItem resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a playlistItem resource, the snippet property contains numerous fields, including the title, description, position, and resourceId properties. As such, if you set part=snippet, the API response will contain all of those properties.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580808 = newJObject()
  add(query_580808, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580808, "playlistId", newJString(playlistId))
  add(query_580808, "fields", newJString(fields))
  add(query_580808, "pageToken", newJString(pageToken))
  add(query_580808, "quotaUser", newJString(quotaUser))
  add(query_580808, "id", newJString(id))
  add(query_580808, "alt", newJString(alt))
  add(query_580808, "oauth_token", newJString(oauthToken))
  add(query_580808, "userIp", newJString(userIp))
  add(query_580808, "videoId", newJString(videoId))
  add(query_580808, "maxResults", newJInt(maxResults))
  add(query_580808, "part", newJString(part))
  add(query_580808, "key", newJString(key))
  add(query_580808, "prettyPrint", newJBool(prettyPrint))
  result = call_580807.call(nil, query_580808, nil, nil, nil)

var youtubePlaylistItemsList* = Call_YoutubePlaylistItemsList_580789(
    name: "youtubePlaylistItemsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/playlistItems",
    validator: validate_YoutubePlaylistItemsList_580790, base: "/youtube/v3",
    url: url_YoutubePlaylistItemsList_580791, schemes: {Scheme.Https})
type
  Call_YoutubePlaylistItemsDelete_580843 = ref object of OpenApiRestCall_579437
proc url_YoutubePlaylistItemsDelete_580845(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubePlaylistItemsDelete_580844(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a playlist item.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the YouTube playlist item ID for the playlist item that is being deleted. In a playlistItem resource, the id property specifies the playlist item's ID.
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
  var valid_580846 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580846 = validateParameter(valid_580846, JString, required = false,
                                 default = nil)
  if valid_580846 != nil:
    section.add "onBehalfOfContentOwner", valid_580846
  var valid_580847 = query.getOrDefault("fields")
  valid_580847 = validateParameter(valid_580847, JString, required = false,
                                 default = nil)
  if valid_580847 != nil:
    section.add "fields", valid_580847
  var valid_580848 = query.getOrDefault("quotaUser")
  valid_580848 = validateParameter(valid_580848, JString, required = false,
                                 default = nil)
  if valid_580848 != nil:
    section.add "quotaUser", valid_580848
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_580849 = query.getOrDefault("id")
  valid_580849 = validateParameter(valid_580849, JString, required = true,
                                 default = nil)
  if valid_580849 != nil:
    section.add "id", valid_580849
  var valid_580850 = query.getOrDefault("alt")
  valid_580850 = validateParameter(valid_580850, JString, required = false,
                                 default = newJString("json"))
  if valid_580850 != nil:
    section.add "alt", valid_580850
  var valid_580851 = query.getOrDefault("oauth_token")
  valid_580851 = validateParameter(valid_580851, JString, required = false,
                                 default = nil)
  if valid_580851 != nil:
    section.add "oauth_token", valid_580851
  var valid_580852 = query.getOrDefault("userIp")
  valid_580852 = validateParameter(valid_580852, JString, required = false,
                                 default = nil)
  if valid_580852 != nil:
    section.add "userIp", valid_580852
  var valid_580853 = query.getOrDefault("key")
  valid_580853 = validateParameter(valid_580853, JString, required = false,
                                 default = nil)
  if valid_580853 != nil:
    section.add "key", valid_580853
  var valid_580854 = query.getOrDefault("prettyPrint")
  valid_580854 = validateParameter(valid_580854, JBool, required = false,
                                 default = newJBool(true))
  if valid_580854 != nil:
    section.add "prettyPrint", valid_580854
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580855: Call_YoutubePlaylistItemsDelete_580843; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a playlist item.
  ## 
  let valid = call_580855.validator(path, query, header, formData, body)
  let scheme = call_580855.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580855.url(scheme.get, call_580855.host, call_580855.base,
                         call_580855.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580855, url, valid)

proc call*(call_580856: Call_YoutubePlaylistItemsDelete_580843; id: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## youtubePlaylistItemsDelete
  ## Deletes a playlist item.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the YouTube playlist item ID for the playlist item that is being deleted. In a playlistItem resource, the id property specifies the playlist item's ID.
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
  var query_580857 = newJObject()
  add(query_580857, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580857, "fields", newJString(fields))
  add(query_580857, "quotaUser", newJString(quotaUser))
  add(query_580857, "id", newJString(id))
  add(query_580857, "alt", newJString(alt))
  add(query_580857, "oauth_token", newJString(oauthToken))
  add(query_580857, "userIp", newJString(userIp))
  add(query_580857, "key", newJString(key))
  add(query_580857, "prettyPrint", newJBool(prettyPrint))
  result = call_580856.call(nil, query_580857, nil, nil, nil)

var youtubePlaylistItemsDelete* = Call_YoutubePlaylistItemsDelete_580843(
    name: "youtubePlaylistItemsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/playlistItems",
    validator: validate_YoutubePlaylistItemsDelete_580844, base: "/youtube/v3",
    url: url_YoutubePlaylistItemsDelete_580845, schemes: {Scheme.Https})
type
  Call_YoutubePlaylistsUpdate_580880 = ref object of OpenApiRestCall_579437
proc url_YoutubePlaylistsUpdate_580882(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubePlaylistsUpdate_580881(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modifies a playlist. For example, you could change a playlist's title, description, or privacy status.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## Note that this method will override the existing values for mutable properties that are contained in any parts that the request body specifies. For example, a playlist's description is contained in the snippet part, which must be included in the request body. If the request does not specify a value for the snippet.description property, the playlist's existing description will be deleted.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580883 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580883 = validateParameter(valid_580883, JString, required = false,
                                 default = nil)
  if valid_580883 != nil:
    section.add "onBehalfOfContentOwner", valid_580883
  var valid_580884 = query.getOrDefault("fields")
  valid_580884 = validateParameter(valid_580884, JString, required = false,
                                 default = nil)
  if valid_580884 != nil:
    section.add "fields", valid_580884
  var valid_580885 = query.getOrDefault("quotaUser")
  valid_580885 = validateParameter(valid_580885, JString, required = false,
                                 default = nil)
  if valid_580885 != nil:
    section.add "quotaUser", valid_580885
  var valid_580886 = query.getOrDefault("alt")
  valid_580886 = validateParameter(valid_580886, JString, required = false,
                                 default = newJString("json"))
  if valid_580886 != nil:
    section.add "alt", valid_580886
  var valid_580887 = query.getOrDefault("oauth_token")
  valid_580887 = validateParameter(valid_580887, JString, required = false,
                                 default = nil)
  if valid_580887 != nil:
    section.add "oauth_token", valid_580887
  var valid_580888 = query.getOrDefault("userIp")
  valid_580888 = validateParameter(valid_580888, JString, required = false,
                                 default = nil)
  if valid_580888 != nil:
    section.add "userIp", valid_580888
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_580889 = query.getOrDefault("part")
  valid_580889 = validateParameter(valid_580889, JString, required = true,
                                 default = nil)
  if valid_580889 != nil:
    section.add "part", valid_580889
  var valid_580890 = query.getOrDefault("key")
  valid_580890 = validateParameter(valid_580890, JString, required = false,
                                 default = nil)
  if valid_580890 != nil:
    section.add "key", valid_580890
  var valid_580891 = query.getOrDefault("prettyPrint")
  valid_580891 = validateParameter(valid_580891, JBool, required = false,
                                 default = newJBool(true))
  if valid_580891 != nil:
    section.add "prettyPrint", valid_580891
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

proc call*(call_580893: Call_YoutubePlaylistsUpdate_580880; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies a playlist. For example, you could change a playlist's title, description, or privacy status.
  ## 
  let valid = call_580893.validator(path, query, header, formData, body)
  let scheme = call_580893.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580893.url(scheme.get, call_580893.host, call_580893.base,
                         call_580893.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580893, url, valid)

proc call*(call_580894: Call_YoutubePlaylistsUpdate_580880; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## youtubePlaylistsUpdate
  ## Modifies a playlist. For example, you could change a playlist's title, description, or privacy status.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## Note that this method will override the existing values for mutable properties that are contained in any parts that the request body specifies. For example, a playlist's description is contained in the snippet part, which must be included in the request body. If the request does not specify a value for the snippet.description property, the playlist's existing description will be deleted.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580895 = newJObject()
  var body_580896 = newJObject()
  add(query_580895, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580895, "fields", newJString(fields))
  add(query_580895, "quotaUser", newJString(quotaUser))
  add(query_580895, "alt", newJString(alt))
  add(query_580895, "oauth_token", newJString(oauthToken))
  add(query_580895, "userIp", newJString(userIp))
  add(query_580895, "part", newJString(part))
  add(query_580895, "key", newJString(key))
  if body != nil:
    body_580896 = body
  add(query_580895, "prettyPrint", newJBool(prettyPrint))
  result = call_580894.call(nil, query_580895, nil, nil, body_580896)

var youtubePlaylistsUpdate* = Call_YoutubePlaylistsUpdate_580880(
    name: "youtubePlaylistsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/playlists",
    validator: validate_YoutubePlaylistsUpdate_580881, base: "/youtube/v3",
    url: url_YoutubePlaylistsUpdate_580882, schemes: {Scheme.Https})
type
  Call_YoutubePlaylistsInsert_580897 = ref object of OpenApiRestCall_579437
proc url_YoutubePlaylistsInsert_580899(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubePlaylistsInsert_580898(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a playlist.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  section = newJObject()
  var valid_580900 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580900 = validateParameter(valid_580900, JString, required = false,
                                 default = nil)
  if valid_580900 != nil:
    section.add "onBehalfOfContentOwner", valid_580900
  var valid_580901 = query.getOrDefault("fields")
  valid_580901 = validateParameter(valid_580901, JString, required = false,
                                 default = nil)
  if valid_580901 != nil:
    section.add "fields", valid_580901
  var valid_580902 = query.getOrDefault("quotaUser")
  valid_580902 = validateParameter(valid_580902, JString, required = false,
                                 default = nil)
  if valid_580902 != nil:
    section.add "quotaUser", valid_580902
  var valid_580903 = query.getOrDefault("alt")
  valid_580903 = validateParameter(valid_580903, JString, required = false,
                                 default = newJString("json"))
  if valid_580903 != nil:
    section.add "alt", valid_580903
  var valid_580904 = query.getOrDefault("oauth_token")
  valid_580904 = validateParameter(valid_580904, JString, required = false,
                                 default = nil)
  if valid_580904 != nil:
    section.add "oauth_token", valid_580904
  var valid_580905 = query.getOrDefault("userIp")
  valid_580905 = validateParameter(valid_580905, JString, required = false,
                                 default = nil)
  if valid_580905 != nil:
    section.add "userIp", valid_580905
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_580906 = query.getOrDefault("part")
  valid_580906 = validateParameter(valid_580906, JString, required = true,
                                 default = nil)
  if valid_580906 != nil:
    section.add "part", valid_580906
  var valid_580907 = query.getOrDefault("key")
  valid_580907 = validateParameter(valid_580907, JString, required = false,
                                 default = nil)
  if valid_580907 != nil:
    section.add "key", valid_580907
  var valid_580908 = query.getOrDefault("prettyPrint")
  valid_580908 = validateParameter(valid_580908, JBool, required = false,
                                 default = newJBool(true))
  if valid_580908 != nil:
    section.add "prettyPrint", valid_580908
  var valid_580909 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_580909 = validateParameter(valid_580909, JString, required = false,
                                 default = nil)
  if valid_580909 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_580909
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

proc call*(call_580911: Call_YoutubePlaylistsInsert_580897; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a playlist.
  ## 
  let valid = call_580911.validator(path, query, header, formData, body)
  let scheme = call_580911.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580911.url(scheme.get, call_580911.host, call_580911.base,
                         call_580911.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580911, url, valid)

proc call*(call_580912: Call_YoutubePlaylistsInsert_580897; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; onBehalfOfContentOwnerChannel: string = ""): Recallable =
  ## youtubePlaylistsInsert
  ## Creates a playlist.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  var query_580913 = newJObject()
  var body_580914 = newJObject()
  add(query_580913, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580913, "fields", newJString(fields))
  add(query_580913, "quotaUser", newJString(quotaUser))
  add(query_580913, "alt", newJString(alt))
  add(query_580913, "oauth_token", newJString(oauthToken))
  add(query_580913, "userIp", newJString(userIp))
  add(query_580913, "part", newJString(part))
  add(query_580913, "key", newJString(key))
  if body != nil:
    body_580914 = body
  add(query_580913, "prettyPrint", newJBool(prettyPrint))
  add(query_580913, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  result = call_580912.call(nil, query_580913, nil, nil, body_580914)

var youtubePlaylistsInsert* = Call_YoutubePlaylistsInsert_580897(
    name: "youtubePlaylistsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/playlists",
    validator: validate_YoutubePlaylistsInsert_580898, base: "/youtube/v3",
    url: url_YoutubePlaylistsInsert_580899, schemes: {Scheme.Https})
type
  Call_YoutubePlaylistsList_580858 = ref object of OpenApiRestCall_579437
proc url_YoutubePlaylistsList_580860(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubePlaylistsList_580859(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a collection of playlists that match the API request parameters. For example, you can retrieve all playlists that the authenticated user owns, or you can retrieve one or more playlists by their unique IDs.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   mine: JBool
  ##       : Set this parameter's value to true to instruct the API to only return playlists owned by the authenticated user.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of the YouTube playlist ID(s) for the resource(s) that are being retrieved. In a playlist resource, the id property specifies the playlist's YouTube playlist ID.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more playlist resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a playlist resource, the snippet property contains properties like author, title, description, tags, and timeCreated. As such, if you set part=snippet, the API response will contain all of those properties.
  ##   channelId: JString
  ##            : This value indicates that the API should only return the specified channel's playlists.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   hl: JString
  ##     : The hl parameter should be used for filter out the properties that are not in the given language. Used for the snippet part.
  section = newJObject()
  var valid_580861 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580861 = validateParameter(valid_580861, JString, required = false,
                                 default = nil)
  if valid_580861 != nil:
    section.add "onBehalfOfContentOwner", valid_580861
  var valid_580862 = query.getOrDefault("mine")
  valid_580862 = validateParameter(valid_580862, JBool, required = false, default = nil)
  if valid_580862 != nil:
    section.add "mine", valid_580862
  var valid_580863 = query.getOrDefault("fields")
  valid_580863 = validateParameter(valid_580863, JString, required = false,
                                 default = nil)
  if valid_580863 != nil:
    section.add "fields", valid_580863
  var valid_580864 = query.getOrDefault("pageToken")
  valid_580864 = validateParameter(valid_580864, JString, required = false,
                                 default = nil)
  if valid_580864 != nil:
    section.add "pageToken", valid_580864
  var valid_580865 = query.getOrDefault("quotaUser")
  valid_580865 = validateParameter(valid_580865, JString, required = false,
                                 default = nil)
  if valid_580865 != nil:
    section.add "quotaUser", valid_580865
  var valid_580866 = query.getOrDefault("id")
  valid_580866 = validateParameter(valid_580866, JString, required = false,
                                 default = nil)
  if valid_580866 != nil:
    section.add "id", valid_580866
  var valid_580867 = query.getOrDefault("alt")
  valid_580867 = validateParameter(valid_580867, JString, required = false,
                                 default = newJString("json"))
  if valid_580867 != nil:
    section.add "alt", valid_580867
  var valid_580868 = query.getOrDefault("oauth_token")
  valid_580868 = validateParameter(valid_580868, JString, required = false,
                                 default = nil)
  if valid_580868 != nil:
    section.add "oauth_token", valid_580868
  var valid_580869 = query.getOrDefault("userIp")
  valid_580869 = validateParameter(valid_580869, JString, required = false,
                                 default = nil)
  if valid_580869 != nil:
    section.add "userIp", valid_580869
  var valid_580870 = query.getOrDefault("maxResults")
  valid_580870 = validateParameter(valid_580870, JInt, required = false,
                                 default = newJInt(5))
  if valid_580870 != nil:
    section.add "maxResults", valid_580870
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_580871 = query.getOrDefault("part")
  valid_580871 = validateParameter(valid_580871, JString, required = true,
                                 default = nil)
  if valid_580871 != nil:
    section.add "part", valid_580871
  var valid_580872 = query.getOrDefault("channelId")
  valid_580872 = validateParameter(valid_580872, JString, required = false,
                                 default = nil)
  if valid_580872 != nil:
    section.add "channelId", valid_580872
  var valid_580873 = query.getOrDefault("key")
  valid_580873 = validateParameter(valid_580873, JString, required = false,
                                 default = nil)
  if valid_580873 != nil:
    section.add "key", valid_580873
  var valid_580874 = query.getOrDefault("prettyPrint")
  valid_580874 = validateParameter(valid_580874, JBool, required = false,
                                 default = newJBool(true))
  if valid_580874 != nil:
    section.add "prettyPrint", valid_580874
  var valid_580875 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_580875 = validateParameter(valid_580875, JString, required = false,
                                 default = nil)
  if valid_580875 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_580875
  var valid_580876 = query.getOrDefault("hl")
  valid_580876 = validateParameter(valid_580876, JString, required = false,
                                 default = nil)
  if valid_580876 != nil:
    section.add "hl", valid_580876
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580877: Call_YoutubePlaylistsList_580858; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of playlists that match the API request parameters. For example, you can retrieve all playlists that the authenticated user owns, or you can retrieve one or more playlists by their unique IDs.
  ## 
  let valid = call_580877.validator(path, query, header, formData, body)
  let scheme = call_580877.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580877.url(scheme.get, call_580877.host, call_580877.base,
                         call_580877.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580877, url, valid)

proc call*(call_580878: Call_YoutubePlaylistsList_580858; part: string;
          onBehalfOfContentOwner: string = ""; mine: bool = false; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; id: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 5; channelId: string = ""; key: string = "";
          prettyPrint: bool = true; onBehalfOfContentOwnerChannel: string = "";
          hl: string = ""): Recallable =
  ## youtubePlaylistsList
  ## Returns a collection of playlists that match the API request parameters. For example, you can retrieve all playlists that the authenticated user owns, or you can retrieve one or more playlists by their unique IDs.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   mine: bool
  ##       : Set this parameter's value to true to instruct the API to only return playlists owned by the authenticated user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of the YouTube playlist ID(s) for the resource(s) that are being retrieved. In a playlist resource, the id property specifies the playlist's YouTube playlist ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more playlist resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a playlist resource, the snippet property contains properties like author, title, description, tags, and timeCreated. As such, if you set part=snippet, the API response will contain all of those properties.
  ##   channelId: string
  ##            : This value indicates that the API should only return the specified channel's playlists.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   hl: string
  ##     : The hl parameter should be used for filter out the properties that are not in the given language. Used for the snippet part.
  var query_580879 = newJObject()
  add(query_580879, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580879, "mine", newJBool(mine))
  add(query_580879, "fields", newJString(fields))
  add(query_580879, "pageToken", newJString(pageToken))
  add(query_580879, "quotaUser", newJString(quotaUser))
  add(query_580879, "id", newJString(id))
  add(query_580879, "alt", newJString(alt))
  add(query_580879, "oauth_token", newJString(oauthToken))
  add(query_580879, "userIp", newJString(userIp))
  add(query_580879, "maxResults", newJInt(maxResults))
  add(query_580879, "part", newJString(part))
  add(query_580879, "channelId", newJString(channelId))
  add(query_580879, "key", newJString(key))
  add(query_580879, "prettyPrint", newJBool(prettyPrint))
  add(query_580879, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  add(query_580879, "hl", newJString(hl))
  result = call_580878.call(nil, query_580879, nil, nil, nil)

var youtubePlaylistsList* = Call_YoutubePlaylistsList_580858(
    name: "youtubePlaylistsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/playlists",
    validator: validate_YoutubePlaylistsList_580859, base: "/youtube/v3",
    url: url_YoutubePlaylistsList_580860, schemes: {Scheme.Https})
type
  Call_YoutubePlaylistsDelete_580915 = ref object of OpenApiRestCall_579437
proc url_YoutubePlaylistsDelete_580917(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubePlaylistsDelete_580916(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a playlist.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the YouTube playlist ID for the playlist that is being deleted. In a playlist resource, the id property specifies the playlist's ID.
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
  var valid_580918 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580918 = validateParameter(valid_580918, JString, required = false,
                                 default = nil)
  if valid_580918 != nil:
    section.add "onBehalfOfContentOwner", valid_580918
  var valid_580919 = query.getOrDefault("fields")
  valid_580919 = validateParameter(valid_580919, JString, required = false,
                                 default = nil)
  if valid_580919 != nil:
    section.add "fields", valid_580919
  var valid_580920 = query.getOrDefault("quotaUser")
  valid_580920 = validateParameter(valid_580920, JString, required = false,
                                 default = nil)
  if valid_580920 != nil:
    section.add "quotaUser", valid_580920
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_580921 = query.getOrDefault("id")
  valid_580921 = validateParameter(valid_580921, JString, required = true,
                                 default = nil)
  if valid_580921 != nil:
    section.add "id", valid_580921
  var valid_580922 = query.getOrDefault("alt")
  valid_580922 = validateParameter(valid_580922, JString, required = false,
                                 default = newJString("json"))
  if valid_580922 != nil:
    section.add "alt", valid_580922
  var valid_580923 = query.getOrDefault("oauth_token")
  valid_580923 = validateParameter(valid_580923, JString, required = false,
                                 default = nil)
  if valid_580923 != nil:
    section.add "oauth_token", valid_580923
  var valid_580924 = query.getOrDefault("userIp")
  valid_580924 = validateParameter(valid_580924, JString, required = false,
                                 default = nil)
  if valid_580924 != nil:
    section.add "userIp", valid_580924
  var valid_580925 = query.getOrDefault("key")
  valid_580925 = validateParameter(valid_580925, JString, required = false,
                                 default = nil)
  if valid_580925 != nil:
    section.add "key", valid_580925
  var valid_580926 = query.getOrDefault("prettyPrint")
  valid_580926 = validateParameter(valid_580926, JBool, required = false,
                                 default = newJBool(true))
  if valid_580926 != nil:
    section.add "prettyPrint", valid_580926
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580927: Call_YoutubePlaylistsDelete_580915; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a playlist.
  ## 
  let valid = call_580927.validator(path, query, header, formData, body)
  let scheme = call_580927.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580927.url(scheme.get, call_580927.host, call_580927.base,
                         call_580927.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580927, url, valid)

proc call*(call_580928: Call_YoutubePlaylistsDelete_580915; id: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## youtubePlaylistsDelete
  ## Deletes a playlist.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the YouTube playlist ID for the playlist that is being deleted. In a playlist resource, the id property specifies the playlist's ID.
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
  var query_580929 = newJObject()
  add(query_580929, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580929, "fields", newJString(fields))
  add(query_580929, "quotaUser", newJString(quotaUser))
  add(query_580929, "id", newJString(id))
  add(query_580929, "alt", newJString(alt))
  add(query_580929, "oauth_token", newJString(oauthToken))
  add(query_580929, "userIp", newJString(userIp))
  add(query_580929, "key", newJString(key))
  add(query_580929, "prettyPrint", newJBool(prettyPrint))
  result = call_580928.call(nil, query_580929, nil, nil, nil)

var youtubePlaylistsDelete* = Call_YoutubePlaylistsDelete_580915(
    name: "youtubePlaylistsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/playlists",
    validator: validate_YoutubePlaylistsDelete_580916, base: "/youtube/v3",
    url: url_YoutubePlaylistsDelete_580917, schemes: {Scheme.Https})
type
  Call_YoutubeSearchList_580930 = ref object of OpenApiRestCall_579437
proc url_YoutubeSearchList_580932(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeSearchList_580931(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Returns a collection of search results that match the query parameters specified in the API request. By default, a search result set identifies matching video, channel, and playlist resources, but you can also configure queries to only retrieve a specific type of resource.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   safeSearch: JString
  ##             : The safeSearch parameter indicates whether the search results should include restricted content as well as standard content.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   publishedAfter: JString
  ##                 : The publishedAfter parameter indicates that the API response should only contain resources created after the specified time. The value is an RFC 3339 formatted date-time value (1970-01-01T00:00:00Z).
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   relevanceLanguage: JString
  ##                    : The relevanceLanguage parameter instructs the API to return search results that are most relevant to the specified language. The parameter value is typically an ISO 639-1 two-letter language code. However, you should use the values zh-Hans for simplified Chinese and zh-Hant for traditional Chinese. Please note that results in other languages will still be returned if they are highly relevant to the search query term.
  ##   alt: JString
  ##      : Data format for the response.
  ##   forContentOwner: JBool
  ##                  : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The forContentOwner parameter restricts the search to only retrieve resources owned by the content owner specified by the onBehalfOfContentOwner parameter. The user must be authenticated using a CMS account linked to the specified content owner and onBehalfOfContentOwner must be provided.
  ##   forMine: JBool
  ##          : The forMine parameter restricts the search to only retrieve videos owned by the authenticated user. If you set this parameter to true, then the type parameter's value must also be set to video.
  ##   videoCaption: JString
  ##               : The videoCaption parameter indicates whether the API should filter video search results based on whether they have captions. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   videoDefinition: JString
  ##                  : The videoDefinition parameter lets you restrict a search to only include either high definition (HD) or standard definition (SD) videos. HD videos are available for playback in at least 720p, though higher resolutions, like 1080p, might also be available. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   topicId: JString
  ##          : The topicId parameter indicates that the API response should only contain resources associated with the specified topic. The value identifies a Freebase topic ID.
  ##   type: JString
  ##       : The type parameter restricts a search query to only retrieve a particular type of resource. The value is a comma-separated list of resource types.
  ##   order: JString
  ##        : The order parameter specifies the method that will be used to order resources in the API response.
  ##   videoDuration: JString
  ##                : The videoDuration parameter filters video search results based on their duration. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   locationRadius: JString
  ##                 : The locationRadius parameter, in conjunction with the location parameter, defines a circular geographic area.
  ## 
  ## The parameter value must be a floating point number followed by a measurement unit. Valid measurement units are m, km, ft, and mi. For example, valid parameter values include 1500m, 5km, 10000ft, and 0.75mi. The API does not support locationRadius parameter values larger than 1000 kilometers.
  ## 
  ## Note: See the definition of the location parameter for more information.
  ##   forDeveloper: JBool
  ##               : The forDeveloper parameter restricts the search to only retrieve videos uploaded via the developer's application or website. The API server uses the request's authorization credentials to identify the developer. Therefore, a developer can restrict results to videos uploaded through the developer's own app or website but not to videos uploaded through other apps or sites.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   videoType: JString
  ##            : The videoType parameter lets you restrict a search to a particular type of videos. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   eventType: JString
  ##            : The eventType parameter restricts a search to broadcast events. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   location: JString
  ##           : The location parameter, in conjunction with the locationRadius parameter, defines a circular geographic area and also restricts a search to videos that specify, in their metadata, a geographic location that falls within that area. The parameter value is a string that specifies latitude/longitude coordinates e.g. (37.42307,-122.08427).
  ## 
  ## 
  ## - The location parameter value identifies the point at the center of the area.
  ## - The locationRadius parameter specifies the maximum distance that the location associated with a video can be from that point for the video to still be included in the search results.The API returns an error if your request specifies a value for the location parameter but does not also specify a value for the locationRadius parameter.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more search resource properties that the API response will include. Set the parameter value to snippet.
  ##   q: JString
  ##    : The q parameter specifies the query term to search for.
  ## 
  ## Your request can also use the Boolean NOT (-) and OR (|) operators to exclude videos or to find videos that are associated with one of several search terms. For example, to search for videos matching either "boating" or "sailing", set the q parameter value to boating|sailing. Similarly, to search for videos matching either "boating" or "sailing" but not "fishing", set the q parameter value to boating|sailing -fishing. Note that the pipe character must be URL-escaped when it is sent in your API request. The URL-escaped value for the pipe character is %7C.
  ##   channelId: JString
  ##            : The channelId parameter indicates that the API response should only contain resources created by the channel
  ##   regionCode: JString
  ##             : The regionCode parameter instructs the API to return search results for the specified country. The parameter value is an ISO 3166-1 alpha-2 country code.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   relatedToVideoId: JString
  ##                   : The relatedToVideoId parameter retrieves a list of videos that are related to the video that the parameter value identifies. The parameter value must be set to a YouTube video ID and, if you are using this parameter, the type parameter must be set to video.
  ##   videoDimension: JString
  ##                 : The videoDimension parameter lets you restrict a search to only retrieve 2D or 3D videos. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   videoLicense: JString
  ##               : The videoLicense parameter filters search results to only include videos with a particular license. YouTube lets video uploaders choose to attach either the Creative Commons license or the standard YouTube license to each of their videos. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   videoSyndicated: JString
  ##                  : The videoSyndicated parameter lets you to restrict a search to only videos that can be played outside youtube.com. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   publishedBefore: JString
  ##                  : The publishedBefore parameter indicates that the API response should only contain resources created before the specified time. The value is an RFC 3339 formatted date-time value (1970-01-01T00:00:00Z).
  ##   channelType: JString
  ##              : The channelType parameter lets you restrict a search to a particular type of channel.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   videoEmbeddable: JString
  ##                  : The videoEmbeddable parameter lets you to restrict a search to only videos that can be embedded into a webpage. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   videoCategoryId: JString
  ##                  : The videoCategoryId parameter filters video search results based on their category. If you specify a value for this parameter, you must also set the type parameter's value to video.
  section = newJObject()
  var valid_580933 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580933 = validateParameter(valid_580933, JString, required = false,
                                 default = nil)
  if valid_580933 != nil:
    section.add "onBehalfOfContentOwner", valid_580933
  var valid_580934 = query.getOrDefault("safeSearch")
  valid_580934 = validateParameter(valid_580934, JString, required = false,
                                 default = newJString("moderate"))
  if valid_580934 != nil:
    section.add "safeSearch", valid_580934
  var valid_580935 = query.getOrDefault("fields")
  valid_580935 = validateParameter(valid_580935, JString, required = false,
                                 default = nil)
  if valid_580935 != nil:
    section.add "fields", valid_580935
  var valid_580936 = query.getOrDefault("publishedAfter")
  valid_580936 = validateParameter(valid_580936, JString, required = false,
                                 default = nil)
  if valid_580936 != nil:
    section.add "publishedAfter", valid_580936
  var valid_580937 = query.getOrDefault("quotaUser")
  valid_580937 = validateParameter(valid_580937, JString, required = false,
                                 default = nil)
  if valid_580937 != nil:
    section.add "quotaUser", valid_580937
  var valid_580938 = query.getOrDefault("pageToken")
  valid_580938 = validateParameter(valid_580938, JString, required = false,
                                 default = nil)
  if valid_580938 != nil:
    section.add "pageToken", valid_580938
  var valid_580939 = query.getOrDefault("relevanceLanguage")
  valid_580939 = validateParameter(valid_580939, JString, required = false,
                                 default = nil)
  if valid_580939 != nil:
    section.add "relevanceLanguage", valid_580939
  var valid_580940 = query.getOrDefault("alt")
  valid_580940 = validateParameter(valid_580940, JString, required = false,
                                 default = newJString("json"))
  if valid_580940 != nil:
    section.add "alt", valid_580940
  var valid_580941 = query.getOrDefault("forContentOwner")
  valid_580941 = validateParameter(valid_580941, JBool, required = false, default = nil)
  if valid_580941 != nil:
    section.add "forContentOwner", valid_580941
  var valid_580942 = query.getOrDefault("forMine")
  valid_580942 = validateParameter(valid_580942, JBool, required = false, default = nil)
  if valid_580942 != nil:
    section.add "forMine", valid_580942
  var valid_580943 = query.getOrDefault("videoCaption")
  valid_580943 = validateParameter(valid_580943, JString, required = false,
                                 default = newJString("any"))
  if valid_580943 != nil:
    section.add "videoCaption", valid_580943
  var valid_580944 = query.getOrDefault("videoDefinition")
  valid_580944 = validateParameter(valid_580944, JString, required = false,
                                 default = newJString("any"))
  if valid_580944 != nil:
    section.add "videoDefinition", valid_580944
  var valid_580945 = query.getOrDefault("topicId")
  valid_580945 = validateParameter(valid_580945, JString, required = false,
                                 default = nil)
  if valid_580945 != nil:
    section.add "topicId", valid_580945
  var valid_580946 = query.getOrDefault("type")
  valid_580946 = validateParameter(valid_580946, JString, required = false,
                                 default = newJString("video,channel,playlist"))
  if valid_580946 != nil:
    section.add "type", valid_580946
  var valid_580947 = query.getOrDefault("order")
  valid_580947 = validateParameter(valid_580947, JString, required = false,
                                 default = newJString("relevance"))
  if valid_580947 != nil:
    section.add "order", valid_580947
  var valid_580948 = query.getOrDefault("videoDuration")
  valid_580948 = validateParameter(valid_580948, JString, required = false,
                                 default = newJString("any"))
  if valid_580948 != nil:
    section.add "videoDuration", valid_580948
  var valid_580949 = query.getOrDefault("oauth_token")
  valid_580949 = validateParameter(valid_580949, JString, required = false,
                                 default = nil)
  if valid_580949 != nil:
    section.add "oauth_token", valid_580949
  var valid_580950 = query.getOrDefault("locationRadius")
  valid_580950 = validateParameter(valid_580950, JString, required = false,
                                 default = nil)
  if valid_580950 != nil:
    section.add "locationRadius", valid_580950
  var valid_580951 = query.getOrDefault("forDeveloper")
  valid_580951 = validateParameter(valid_580951, JBool, required = false, default = nil)
  if valid_580951 != nil:
    section.add "forDeveloper", valid_580951
  var valid_580952 = query.getOrDefault("userIp")
  valid_580952 = validateParameter(valid_580952, JString, required = false,
                                 default = nil)
  if valid_580952 != nil:
    section.add "userIp", valid_580952
  var valid_580953 = query.getOrDefault("videoType")
  valid_580953 = validateParameter(valid_580953, JString, required = false,
                                 default = newJString("any"))
  if valid_580953 != nil:
    section.add "videoType", valid_580953
  var valid_580954 = query.getOrDefault("eventType")
  valid_580954 = validateParameter(valid_580954, JString, required = false,
                                 default = newJString("completed"))
  if valid_580954 != nil:
    section.add "eventType", valid_580954
  var valid_580955 = query.getOrDefault("location")
  valid_580955 = validateParameter(valid_580955, JString, required = false,
                                 default = nil)
  if valid_580955 != nil:
    section.add "location", valid_580955
  var valid_580956 = query.getOrDefault("maxResults")
  valid_580956 = validateParameter(valid_580956, JInt, required = false,
                                 default = newJInt(5))
  if valid_580956 != nil:
    section.add "maxResults", valid_580956
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_580957 = query.getOrDefault("part")
  valid_580957 = validateParameter(valid_580957, JString, required = true,
                                 default = nil)
  if valid_580957 != nil:
    section.add "part", valid_580957
  var valid_580958 = query.getOrDefault("q")
  valid_580958 = validateParameter(valid_580958, JString, required = false,
                                 default = nil)
  if valid_580958 != nil:
    section.add "q", valid_580958
  var valid_580959 = query.getOrDefault("channelId")
  valid_580959 = validateParameter(valid_580959, JString, required = false,
                                 default = nil)
  if valid_580959 != nil:
    section.add "channelId", valid_580959
  var valid_580960 = query.getOrDefault("regionCode")
  valid_580960 = validateParameter(valid_580960, JString, required = false,
                                 default = nil)
  if valid_580960 != nil:
    section.add "regionCode", valid_580960
  var valid_580961 = query.getOrDefault("key")
  valid_580961 = validateParameter(valid_580961, JString, required = false,
                                 default = nil)
  if valid_580961 != nil:
    section.add "key", valid_580961
  var valid_580962 = query.getOrDefault("relatedToVideoId")
  valid_580962 = validateParameter(valid_580962, JString, required = false,
                                 default = nil)
  if valid_580962 != nil:
    section.add "relatedToVideoId", valid_580962
  var valid_580963 = query.getOrDefault("videoDimension")
  valid_580963 = validateParameter(valid_580963, JString, required = false,
                                 default = newJString("2d"))
  if valid_580963 != nil:
    section.add "videoDimension", valid_580963
  var valid_580964 = query.getOrDefault("videoLicense")
  valid_580964 = validateParameter(valid_580964, JString, required = false,
                                 default = newJString("any"))
  if valid_580964 != nil:
    section.add "videoLicense", valid_580964
  var valid_580965 = query.getOrDefault("videoSyndicated")
  valid_580965 = validateParameter(valid_580965, JString, required = false,
                                 default = newJString("any"))
  if valid_580965 != nil:
    section.add "videoSyndicated", valid_580965
  var valid_580966 = query.getOrDefault("publishedBefore")
  valid_580966 = validateParameter(valid_580966, JString, required = false,
                                 default = nil)
  if valid_580966 != nil:
    section.add "publishedBefore", valid_580966
  var valid_580967 = query.getOrDefault("channelType")
  valid_580967 = validateParameter(valid_580967, JString, required = false,
                                 default = newJString("any"))
  if valid_580967 != nil:
    section.add "channelType", valid_580967
  var valid_580968 = query.getOrDefault("prettyPrint")
  valid_580968 = validateParameter(valid_580968, JBool, required = false,
                                 default = newJBool(true))
  if valid_580968 != nil:
    section.add "prettyPrint", valid_580968
  var valid_580969 = query.getOrDefault("videoEmbeddable")
  valid_580969 = validateParameter(valid_580969, JString, required = false,
                                 default = newJString("any"))
  if valid_580969 != nil:
    section.add "videoEmbeddable", valid_580969
  var valid_580970 = query.getOrDefault("videoCategoryId")
  valid_580970 = validateParameter(valid_580970, JString, required = false,
                                 default = nil)
  if valid_580970 != nil:
    section.add "videoCategoryId", valid_580970
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580971: Call_YoutubeSearchList_580930; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of search results that match the query parameters specified in the API request. By default, a search result set identifies matching video, channel, and playlist resources, but you can also configure queries to only retrieve a specific type of resource.
  ## 
  let valid = call_580971.validator(path, query, header, formData, body)
  let scheme = call_580971.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580971.url(scheme.get, call_580971.host, call_580971.base,
                         call_580971.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580971, url, valid)

proc call*(call_580972: Call_YoutubeSearchList_580930; part: string;
          onBehalfOfContentOwner: string = ""; safeSearch: string = "moderate";
          fields: string = ""; publishedAfter: string = ""; quotaUser: string = "";
          pageToken: string = ""; relevanceLanguage: string = ""; alt: string = "json";
          forContentOwner: bool = false; forMine: bool = false;
          videoCaption: string = "any"; videoDefinition: string = "any";
          topicId: string = ""; `type`: string = "video,channel,playlist";
          order: string = "relevance"; videoDuration: string = "any";
          oauthToken: string = ""; locationRadius: string = "";
          forDeveloper: bool = false; userIp: string = ""; videoType: string = "any";
          eventType: string = "completed"; location: string = ""; maxResults: int = 5;
          q: string = ""; channelId: string = ""; regionCode: string = ""; key: string = "";
          relatedToVideoId: string = ""; videoDimension: string = "2d";
          videoLicense: string = "any"; videoSyndicated: string = "any";
          publishedBefore: string = ""; channelType: string = "any";
          prettyPrint: bool = true; videoEmbeddable: string = "any";
          videoCategoryId: string = ""): Recallable =
  ## youtubeSearchList
  ## Returns a collection of search results that match the query parameters specified in the API request. By default, a search result set identifies matching video, channel, and playlist resources, but you can also configure queries to only retrieve a specific type of resource.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   safeSearch: string
  ##             : The safeSearch parameter indicates whether the search results should include restricted content as well as standard content.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   publishedAfter: string
  ##                 : The publishedAfter parameter indicates that the API response should only contain resources created after the specified time. The value is an RFC 3339 formatted date-time value (1970-01-01T00:00:00Z).
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   relevanceLanguage: string
  ##                    : The relevanceLanguage parameter instructs the API to return search results that are most relevant to the specified language. The parameter value is typically an ISO 639-1 two-letter language code. However, you should use the values zh-Hans for simplified Chinese and zh-Hant for traditional Chinese. Please note that results in other languages will still be returned if they are highly relevant to the search query term.
  ##   alt: string
  ##      : Data format for the response.
  ##   forContentOwner: bool
  ##                  : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The forContentOwner parameter restricts the search to only retrieve resources owned by the content owner specified by the onBehalfOfContentOwner parameter. The user must be authenticated using a CMS account linked to the specified content owner and onBehalfOfContentOwner must be provided.
  ##   forMine: bool
  ##          : The forMine parameter restricts the search to only retrieve videos owned by the authenticated user. If you set this parameter to true, then the type parameter's value must also be set to video.
  ##   videoCaption: string
  ##               : The videoCaption parameter indicates whether the API should filter video search results based on whether they have captions. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   videoDefinition: string
  ##                  : The videoDefinition parameter lets you restrict a search to only include either high definition (HD) or standard definition (SD) videos. HD videos are available for playback in at least 720p, though higher resolutions, like 1080p, might also be available. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   topicId: string
  ##          : The topicId parameter indicates that the API response should only contain resources associated with the specified topic. The value identifies a Freebase topic ID.
  ##   type: string
  ##       : The type parameter restricts a search query to only retrieve a particular type of resource. The value is a comma-separated list of resource types.
  ##   order: string
  ##        : The order parameter specifies the method that will be used to order resources in the API response.
  ##   videoDuration: string
  ##                : The videoDuration parameter filters video search results based on their duration. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   locationRadius: string
  ##                 : The locationRadius parameter, in conjunction with the location parameter, defines a circular geographic area.
  ## 
  ## The parameter value must be a floating point number followed by a measurement unit. Valid measurement units are m, km, ft, and mi. For example, valid parameter values include 1500m, 5km, 10000ft, and 0.75mi. The API does not support locationRadius parameter values larger than 1000 kilometers.
  ## 
  ## Note: See the definition of the location parameter for more information.
  ##   forDeveloper: bool
  ##               : The forDeveloper parameter restricts the search to only retrieve videos uploaded via the developer's application or website. The API server uses the request's authorization credentials to identify the developer. Therefore, a developer can restrict results to videos uploaded through the developer's own app or website but not to videos uploaded through other apps or sites.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   videoType: string
  ##            : The videoType parameter lets you restrict a search to a particular type of videos. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   eventType: string
  ##            : The eventType parameter restricts a search to broadcast events. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   location: string
  ##           : The location parameter, in conjunction with the locationRadius parameter, defines a circular geographic area and also restricts a search to videos that specify, in their metadata, a geographic location that falls within that area. The parameter value is a string that specifies latitude/longitude coordinates e.g. (37.42307,-122.08427).
  ## 
  ## 
  ## - The location parameter value identifies the point at the center of the area.
  ## - The locationRadius parameter specifies the maximum distance that the location associated with a video can be from that point for the video to still be included in the search results.The API returns an error if your request specifies a value for the location parameter but does not also specify a value for the locationRadius parameter.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more search resource properties that the API response will include. Set the parameter value to snippet.
  ##   q: string
  ##    : The q parameter specifies the query term to search for.
  ## 
  ## Your request can also use the Boolean NOT (-) and OR (|) operators to exclude videos or to find videos that are associated with one of several search terms. For example, to search for videos matching either "boating" or "sailing", set the q parameter value to boating|sailing. Similarly, to search for videos matching either "boating" or "sailing" but not "fishing", set the q parameter value to boating|sailing -fishing. Note that the pipe character must be URL-escaped when it is sent in your API request. The URL-escaped value for the pipe character is %7C.
  ##   channelId: string
  ##            : The channelId parameter indicates that the API response should only contain resources created by the channel
  ##   regionCode: string
  ##             : The regionCode parameter instructs the API to return search results for the specified country. The parameter value is an ISO 3166-1 alpha-2 country code.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   relatedToVideoId: string
  ##                   : The relatedToVideoId parameter retrieves a list of videos that are related to the video that the parameter value identifies. The parameter value must be set to a YouTube video ID and, if you are using this parameter, the type parameter must be set to video.
  ##   videoDimension: string
  ##                 : The videoDimension parameter lets you restrict a search to only retrieve 2D or 3D videos. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   videoLicense: string
  ##               : The videoLicense parameter filters search results to only include videos with a particular license. YouTube lets video uploaders choose to attach either the Creative Commons license or the standard YouTube license to each of their videos. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   videoSyndicated: string
  ##                  : The videoSyndicated parameter lets you to restrict a search to only videos that can be played outside youtube.com. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   publishedBefore: string
  ##                  : The publishedBefore parameter indicates that the API response should only contain resources created before the specified time. The value is an RFC 3339 formatted date-time value (1970-01-01T00:00:00Z).
  ##   channelType: string
  ##              : The channelType parameter lets you restrict a search to a particular type of channel.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   videoEmbeddable: string
  ##                  : The videoEmbeddable parameter lets you to restrict a search to only videos that can be embedded into a webpage. If you specify a value for this parameter, you must also set the type parameter's value to video.
  ##   videoCategoryId: string
  ##                  : The videoCategoryId parameter filters video search results based on their category. If you specify a value for this parameter, you must also set the type parameter's value to video.
  var query_580973 = newJObject()
  add(query_580973, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580973, "safeSearch", newJString(safeSearch))
  add(query_580973, "fields", newJString(fields))
  add(query_580973, "publishedAfter", newJString(publishedAfter))
  add(query_580973, "quotaUser", newJString(quotaUser))
  add(query_580973, "pageToken", newJString(pageToken))
  add(query_580973, "relevanceLanguage", newJString(relevanceLanguage))
  add(query_580973, "alt", newJString(alt))
  add(query_580973, "forContentOwner", newJBool(forContentOwner))
  add(query_580973, "forMine", newJBool(forMine))
  add(query_580973, "videoCaption", newJString(videoCaption))
  add(query_580973, "videoDefinition", newJString(videoDefinition))
  add(query_580973, "topicId", newJString(topicId))
  add(query_580973, "type", newJString(`type`))
  add(query_580973, "order", newJString(order))
  add(query_580973, "videoDuration", newJString(videoDuration))
  add(query_580973, "oauth_token", newJString(oauthToken))
  add(query_580973, "locationRadius", newJString(locationRadius))
  add(query_580973, "forDeveloper", newJBool(forDeveloper))
  add(query_580973, "userIp", newJString(userIp))
  add(query_580973, "videoType", newJString(videoType))
  add(query_580973, "eventType", newJString(eventType))
  add(query_580973, "location", newJString(location))
  add(query_580973, "maxResults", newJInt(maxResults))
  add(query_580973, "part", newJString(part))
  add(query_580973, "q", newJString(q))
  add(query_580973, "channelId", newJString(channelId))
  add(query_580973, "regionCode", newJString(regionCode))
  add(query_580973, "key", newJString(key))
  add(query_580973, "relatedToVideoId", newJString(relatedToVideoId))
  add(query_580973, "videoDimension", newJString(videoDimension))
  add(query_580973, "videoLicense", newJString(videoLicense))
  add(query_580973, "videoSyndicated", newJString(videoSyndicated))
  add(query_580973, "publishedBefore", newJString(publishedBefore))
  add(query_580973, "channelType", newJString(channelType))
  add(query_580973, "prettyPrint", newJBool(prettyPrint))
  add(query_580973, "videoEmbeddable", newJString(videoEmbeddable))
  add(query_580973, "videoCategoryId", newJString(videoCategoryId))
  result = call_580972.call(nil, query_580973, nil, nil, nil)

var youtubeSearchList* = Call_YoutubeSearchList_580930(name: "youtubeSearchList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/search",
    validator: validate_YoutubeSearchList_580931, base: "/youtube/v3",
    url: url_YoutubeSearchList_580932, schemes: {Scheme.Https})
type
  Call_YoutubeSponsorsList_580974 = ref object of OpenApiRestCall_579437
proc url_YoutubeSponsorsList_580976(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeSponsorsList_580975(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Lists sponsors for a channel.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: JString (required)
  ##       : The part parameter specifies the sponsor resource parts that the API response will include. Supported values are id and snippet.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The filter parameter specifies which channel sponsors to return.
  section = newJObject()
  var valid_580977 = query.getOrDefault("fields")
  valid_580977 = validateParameter(valid_580977, JString, required = false,
                                 default = nil)
  if valid_580977 != nil:
    section.add "fields", valid_580977
  var valid_580978 = query.getOrDefault("pageToken")
  valid_580978 = validateParameter(valid_580978, JString, required = false,
                                 default = nil)
  if valid_580978 != nil:
    section.add "pageToken", valid_580978
  var valid_580979 = query.getOrDefault("quotaUser")
  valid_580979 = validateParameter(valid_580979, JString, required = false,
                                 default = nil)
  if valid_580979 != nil:
    section.add "quotaUser", valid_580979
  var valid_580980 = query.getOrDefault("alt")
  valid_580980 = validateParameter(valid_580980, JString, required = false,
                                 default = newJString("json"))
  if valid_580980 != nil:
    section.add "alt", valid_580980
  var valid_580981 = query.getOrDefault("oauth_token")
  valid_580981 = validateParameter(valid_580981, JString, required = false,
                                 default = nil)
  if valid_580981 != nil:
    section.add "oauth_token", valid_580981
  var valid_580982 = query.getOrDefault("userIp")
  valid_580982 = validateParameter(valid_580982, JString, required = false,
                                 default = nil)
  if valid_580982 != nil:
    section.add "userIp", valid_580982
  var valid_580983 = query.getOrDefault("maxResults")
  valid_580983 = validateParameter(valid_580983, JInt, required = false,
                                 default = newJInt(5))
  if valid_580983 != nil:
    section.add "maxResults", valid_580983
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_580984 = query.getOrDefault("part")
  valid_580984 = validateParameter(valid_580984, JString, required = true,
                                 default = nil)
  if valid_580984 != nil:
    section.add "part", valid_580984
  var valid_580985 = query.getOrDefault("key")
  valid_580985 = validateParameter(valid_580985, JString, required = false,
                                 default = nil)
  if valid_580985 != nil:
    section.add "key", valid_580985
  var valid_580986 = query.getOrDefault("prettyPrint")
  valid_580986 = validateParameter(valid_580986, JBool, required = false,
                                 default = newJBool(true))
  if valid_580986 != nil:
    section.add "prettyPrint", valid_580986
  var valid_580987 = query.getOrDefault("filter")
  valid_580987 = validateParameter(valid_580987, JString, required = false,
                                 default = newJString("newest"))
  if valid_580987 != nil:
    section.add "filter", valid_580987
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580988: Call_YoutubeSponsorsList_580974; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists sponsors for a channel.
  ## 
  let valid = call_580988.validator(path, query, header, formData, body)
  let scheme = call_580988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580988.url(scheme.get, call_580988.host, call_580988.base,
                         call_580988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580988, url, valid)

proc call*(call_580989: Call_YoutubeSponsorsList_580974; part: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 5; key: string = ""; prettyPrint: bool = true;
          filter: string = "newest"): Recallable =
  ## youtubeSponsorsList
  ## Lists sponsors for a channel.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: string (required)
  ##       : The part parameter specifies the sponsor resource parts that the API response will include. Supported values are id and snippet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The filter parameter specifies which channel sponsors to return.
  var query_580990 = newJObject()
  add(query_580990, "fields", newJString(fields))
  add(query_580990, "pageToken", newJString(pageToken))
  add(query_580990, "quotaUser", newJString(quotaUser))
  add(query_580990, "alt", newJString(alt))
  add(query_580990, "oauth_token", newJString(oauthToken))
  add(query_580990, "userIp", newJString(userIp))
  add(query_580990, "maxResults", newJInt(maxResults))
  add(query_580990, "part", newJString(part))
  add(query_580990, "key", newJString(key))
  add(query_580990, "prettyPrint", newJBool(prettyPrint))
  add(query_580990, "filter", newJString(filter))
  result = call_580989.call(nil, query_580990, nil, nil, nil)

var youtubeSponsorsList* = Call_YoutubeSponsorsList_580974(
    name: "youtubeSponsorsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/sponsors",
    validator: validate_YoutubeSponsorsList_580975, base: "/youtube/v3",
    url: url_YoutubeSponsorsList_580976, schemes: {Scheme.Https})
type
  Call_YoutubeSubscriptionsInsert_581016 = ref object of OpenApiRestCall_579437
proc url_YoutubeSubscriptionsInsert_581018(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeSubscriptionsInsert_581017(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a subscription for the authenticated user's channel.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_581019 = query.getOrDefault("fields")
  valid_581019 = validateParameter(valid_581019, JString, required = false,
                                 default = nil)
  if valid_581019 != nil:
    section.add "fields", valid_581019
  var valid_581020 = query.getOrDefault("quotaUser")
  valid_581020 = validateParameter(valid_581020, JString, required = false,
                                 default = nil)
  if valid_581020 != nil:
    section.add "quotaUser", valid_581020
  var valid_581021 = query.getOrDefault("alt")
  valid_581021 = validateParameter(valid_581021, JString, required = false,
                                 default = newJString("json"))
  if valid_581021 != nil:
    section.add "alt", valid_581021
  var valid_581022 = query.getOrDefault("oauth_token")
  valid_581022 = validateParameter(valid_581022, JString, required = false,
                                 default = nil)
  if valid_581022 != nil:
    section.add "oauth_token", valid_581022
  var valid_581023 = query.getOrDefault("userIp")
  valid_581023 = validateParameter(valid_581023, JString, required = false,
                                 default = nil)
  if valid_581023 != nil:
    section.add "userIp", valid_581023
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_581024 = query.getOrDefault("part")
  valid_581024 = validateParameter(valid_581024, JString, required = true,
                                 default = nil)
  if valid_581024 != nil:
    section.add "part", valid_581024
  var valid_581025 = query.getOrDefault("key")
  valid_581025 = validateParameter(valid_581025, JString, required = false,
                                 default = nil)
  if valid_581025 != nil:
    section.add "key", valid_581025
  var valid_581026 = query.getOrDefault("prettyPrint")
  valid_581026 = validateParameter(valid_581026, JBool, required = false,
                                 default = newJBool(true))
  if valid_581026 != nil:
    section.add "prettyPrint", valid_581026
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

proc call*(call_581028: Call_YoutubeSubscriptionsInsert_581016; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a subscription for the authenticated user's channel.
  ## 
  let valid = call_581028.validator(path, query, header, formData, body)
  let scheme = call_581028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581028.url(scheme.get, call_581028.host, call_581028.base,
                         call_581028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581028, url, valid)

proc call*(call_581029: Call_YoutubeSubscriptionsInsert_581016; part: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## youtubeSubscriptionsInsert
  ## Adds a subscription for the authenticated user's channel.
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
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_581030 = newJObject()
  var body_581031 = newJObject()
  add(query_581030, "fields", newJString(fields))
  add(query_581030, "quotaUser", newJString(quotaUser))
  add(query_581030, "alt", newJString(alt))
  add(query_581030, "oauth_token", newJString(oauthToken))
  add(query_581030, "userIp", newJString(userIp))
  add(query_581030, "part", newJString(part))
  add(query_581030, "key", newJString(key))
  if body != nil:
    body_581031 = body
  add(query_581030, "prettyPrint", newJBool(prettyPrint))
  result = call_581029.call(nil, query_581030, nil, nil, body_581031)

var youtubeSubscriptionsInsert* = Call_YoutubeSubscriptionsInsert_581016(
    name: "youtubeSubscriptionsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/subscriptions",
    validator: validate_YoutubeSubscriptionsInsert_581017, base: "/youtube/v3",
    url: url_YoutubeSubscriptionsInsert_581018, schemes: {Scheme.Https})
type
  Call_YoutubeSubscriptionsList_580991 = ref object of OpenApiRestCall_579437
proc url_YoutubeSubscriptionsList_580993(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeSubscriptionsList_580992(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns subscription resources that match the API request criteria.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   mine: JBool
  ##       : Set this parameter's value to true to retrieve a feed of the authenticated user's subscriptions.
  ##   forChannelId: JString
  ##               : The forChannelId parameter specifies a comma-separated list of channel IDs. The API response will then only contain subscriptions matching those channels.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of the YouTube subscription ID(s) for the resource(s) that are being retrieved. In a subscription resource, the id property specifies the YouTube subscription ID.
  ##   alt: JString
  ##      : Data format for the response.
  ##   mySubscribers: JBool
  ##                : Set this parameter's value to true to retrieve a feed of the subscribers of the authenticated user in no particular order.
  ##   order: JString
  ##        : The order parameter specifies the method that will be used to sort resources in the API response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more subscription resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a subscription resource, the snippet property contains other properties, such as a display title for the subscription. If you set part=snippet, the API response will also contain all of those nested properties.
  ##   channelId: JString
  ##            : The channelId parameter specifies a YouTube channel ID. The API will only return that channel's subscriptions.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   myRecentSubscribers: JBool
  ##                      : Set this parameter's value to true to retrieve a feed of the subscribers of the authenticated user in reverse chronological order (newest first).
  section = newJObject()
  var valid_580994 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580994 = validateParameter(valid_580994, JString, required = false,
                                 default = nil)
  if valid_580994 != nil:
    section.add "onBehalfOfContentOwner", valid_580994
  var valid_580995 = query.getOrDefault("mine")
  valid_580995 = validateParameter(valid_580995, JBool, required = false, default = nil)
  if valid_580995 != nil:
    section.add "mine", valid_580995
  var valid_580996 = query.getOrDefault("forChannelId")
  valid_580996 = validateParameter(valid_580996, JString, required = false,
                                 default = nil)
  if valid_580996 != nil:
    section.add "forChannelId", valid_580996
  var valid_580997 = query.getOrDefault("fields")
  valid_580997 = validateParameter(valid_580997, JString, required = false,
                                 default = nil)
  if valid_580997 != nil:
    section.add "fields", valid_580997
  var valid_580998 = query.getOrDefault("pageToken")
  valid_580998 = validateParameter(valid_580998, JString, required = false,
                                 default = nil)
  if valid_580998 != nil:
    section.add "pageToken", valid_580998
  var valid_580999 = query.getOrDefault("quotaUser")
  valid_580999 = validateParameter(valid_580999, JString, required = false,
                                 default = nil)
  if valid_580999 != nil:
    section.add "quotaUser", valid_580999
  var valid_581000 = query.getOrDefault("id")
  valid_581000 = validateParameter(valid_581000, JString, required = false,
                                 default = nil)
  if valid_581000 != nil:
    section.add "id", valid_581000
  var valid_581001 = query.getOrDefault("alt")
  valid_581001 = validateParameter(valid_581001, JString, required = false,
                                 default = newJString("json"))
  if valid_581001 != nil:
    section.add "alt", valid_581001
  var valid_581002 = query.getOrDefault("mySubscribers")
  valid_581002 = validateParameter(valid_581002, JBool, required = false, default = nil)
  if valid_581002 != nil:
    section.add "mySubscribers", valid_581002
  var valid_581003 = query.getOrDefault("order")
  valid_581003 = validateParameter(valid_581003, JString, required = false,
                                 default = newJString("relevance"))
  if valid_581003 != nil:
    section.add "order", valid_581003
  var valid_581004 = query.getOrDefault("oauth_token")
  valid_581004 = validateParameter(valid_581004, JString, required = false,
                                 default = nil)
  if valid_581004 != nil:
    section.add "oauth_token", valid_581004
  var valid_581005 = query.getOrDefault("userIp")
  valid_581005 = validateParameter(valid_581005, JString, required = false,
                                 default = nil)
  if valid_581005 != nil:
    section.add "userIp", valid_581005
  var valid_581006 = query.getOrDefault("maxResults")
  valid_581006 = validateParameter(valid_581006, JInt, required = false,
                                 default = newJInt(5))
  if valid_581006 != nil:
    section.add "maxResults", valid_581006
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_581007 = query.getOrDefault("part")
  valid_581007 = validateParameter(valid_581007, JString, required = true,
                                 default = nil)
  if valid_581007 != nil:
    section.add "part", valid_581007
  var valid_581008 = query.getOrDefault("channelId")
  valid_581008 = validateParameter(valid_581008, JString, required = false,
                                 default = nil)
  if valid_581008 != nil:
    section.add "channelId", valid_581008
  var valid_581009 = query.getOrDefault("key")
  valid_581009 = validateParameter(valid_581009, JString, required = false,
                                 default = nil)
  if valid_581009 != nil:
    section.add "key", valid_581009
  var valid_581010 = query.getOrDefault("prettyPrint")
  valid_581010 = validateParameter(valid_581010, JBool, required = false,
                                 default = newJBool(true))
  if valid_581010 != nil:
    section.add "prettyPrint", valid_581010
  var valid_581011 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_581011 = validateParameter(valid_581011, JString, required = false,
                                 default = nil)
  if valid_581011 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_581011
  var valid_581012 = query.getOrDefault("myRecentSubscribers")
  valid_581012 = validateParameter(valid_581012, JBool, required = false, default = nil)
  if valid_581012 != nil:
    section.add "myRecentSubscribers", valid_581012
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581013: Call_YoutubeSubscriptionsList_580991; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns subscription resources that match the API request criteria.
  ## 
  let valid = call_581013.validator(path, query, header, formData, body)
  let scheme = call_581013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581013.url(scheme.get, call_581013.host, call_581013.base,
                         call_581013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581013, url, valid)

proc call*(call_581014: Call_YoutubeSubscriptionsList_580991; part: string;
          onBehalfOfContentOwner: string = ""; mine: bool = false;
          forChannelId: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; id: string = ""; alt: string = "json";
          mySubscribers: bool = false; order: string = "relevance";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 5;
          channelId: string = ""; key: string = ""; prettyPrint: bool = true;
          onBehalfOfContentOwnerChannel: string = "";
          myRecentSubscribers: bool = false): Recallable =
  ## youtubeSubscriptionsList
  ## Returns subscription resources that match the API request criteria.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   mine: bool
  ##       : Set this parameter's value to true to retrieve a feed of the authenticated user's subscriptions.
  ##   forChannelId: string
  ##               : The forChannelId parameter specifies a comma-separated list of channel IDs. The API response will then only contain subscriptions matching those channels.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of the YouTube subscription ID(s) for the resource(s) that are being retrieved. In a subscription resource, the id property specifies the YouTube subscription ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   mySubscribers: bool
  ##                : Set this parameter's value to true to retrieve a feed of the subscribers of the authenticated user in no particular order.
  ##   order: string
  ##        : The order parameter specifies the method that will be used to sort resources in the API response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more subscription resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a subscription resource, the snippet property contains other properties, such as a display title for the subscription. If you set part=snippet, the API response will also contain all of those nested properties.
  ##   channelId: string
  ##            : The channelId parameter specifies a YouTube channel ID. The API will only return that channel's subscriptions.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   myRecentSubscribers: bool
  ##                      : Set this parameter's value to true to retrieve a feed of the subscribers of the authenticated user in reverse chronological order (newest first).
  var query_581015 = newJObject()
  add(query_581015, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_581015, "mine", newJBool(mine))
  add(query_581015, "forChannelId", newJString(forChannelId))
  add(query_581015, "fields", newJString(fields))
  add(query_581015, "pageToken", newJString(pageToken))
  add(query_581015, "quotaUser", newJString(quotaUser))
  add(query_581015, "id", newJString(id))
  add(query_581015, "alt", newJString(alt))
  add(query_581015, "mySubscribers", newJBool(mySubscribers))
  add(query_581015, "order", newJString(order))
  add(query_581015, "oauth_token", newJString(oauthToken))
  add(query_581015, "userIp", newJString(userIp))
  add(query_581015, "maxResults", newJInt(maxResults))
  add(query_581015, "part", newJString(part))
  add(query_581015, "channelId", newJString(channelId))
  add(query_581015, "key", newJString(key))
  add(query_581015, "prettyPrint", newJBool(prettyPrint))
  add(query_581015, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  add(query_581015, "myRecentSubscribers", newJBool(myRecentSubscribers))
  result = call_581014.call(nil, query_581015, nil, nil, nil)

var youtubeSubscriptionsList* = Call_YoutubeSubscriptionsList_580991(
    name: "youtubeSubscriptionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/subscriptions",
    validator: validate_YoutubeSubscriptionsList_580992, base: "/youtube/v3",
    url: url_YoutubeSubscriptionsList_580993, schemes: {Scheme.Https})
type
  Call_YoutubeSubscriptionsDelete_581032 = ref object of OpenApiRestCall_579437
proc url_YoutubeSubscriptionsDelete_581034(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeSubscriptionsDelete_581033(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the YouTube subscription ID for the resource that is being deleted. In a subscription resource, the id property specifies the YouTube subscription ID.
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
  var valid_581035 = query.getOrDefault("fields")
  valid_581035 = validateParameter(valid_581035, JString, required = false,
                                 default = nil)
  if valid_581035 != nil:
    section.add "fields", valid_581035
  var valid_581036 = query.getOrDefault("quotaUser")
  valid_581036 = validateParameter(valid_581036, JString, required = false,
                                 default = nil)
  if valid_581036 != nil:
    section.add "quotaUser", valid_581036
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_581037 = query.getOrDefault("id")
  valid_581037 = validateParameter(valid_581037, JString, required = true,
                                 default = nil)
  if valid_581037 != nil:
    section.add "id", valid_581037
  var valid_581038 = query.getOrDefault("alt")
  valid_581038 = validateParameter(valid_581038, JString, required = false,
                                 default = newJString("json"))
  if valid_581038 != nil:
    section.add "alt", valid_581038
  var valid_581039 = query.getOrDefault("oauth_token")
  valid_581039 = validateParameter(valid_581039, JString, required = false,
                                 default = nil)
  if valid_581039 != nil:
    section.add "oauth_token", valid_581039
  var valid_581040 = query.getOrDefault("userIp")
  valid_581040 = validateParameter(valid_581040, JString, required = false,
                                 default = nil)
  if valid_581040 != nil:
    section.add "userIp", valid_581040
  var valid_581041 = query.getOrDefault("key")
  valid_581041 = validateParameter(valid_581041, JString, required = false,
                                 default = nil)
  if valid_581041 != nil:
    section.add "key", valid_581041
  var valid_581042 = query.getOrDefault("prettyPrint")
  valid_581042 = validateParameter(valid_581042, JBool, required = false,
                                 default = newJBool(true))
  if valid_581042 != nil:
    section.add "prettyPrint", valid_581042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581043: Call_YoutubeSubscriptionsDelete_581032; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a subscription.
  ## 
  let valid = call_581043.validator(path, query, header, formData, body)
  let scheme = call_581043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581043.url(scheme.get, call_581043.host, call_581043.base,
                         call_581043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581043, url, valid)

proc call*(call_581044: Call_YoutubeSubscriptionsDelete_581032; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## youtubeSubscriptionsDelete
  ## Deletes a subscription.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the YouTube subscription ID for the resource that is being deleted. In a subscription resource, the id property specifies the YouTube subscription ID.
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
  var query_581045 = newJObject()
  add(query_581045, "fields", newJString(fields))
  add(query_581045, "quotaUser", newJString(quotaUser))
  add(query_581045, "id", newJString(id))
  add(query_581045, "alt", newJString(alt))
  add(query_581045, "oauth_token", newJString(oauthToken))
  add(query_581045, "userIp", newJString(userIp))
  add(query_581045, "key", newJString(key))
  add(query_581045, "prettyPrint", newJBool(prettyPrint))
  result = call_581044.call(nil, query_581045, nil, nil, nil)

var youtubeSubscriptionsDelete* = Call_YoutubeSubscriptionsDelete_581032(
    name: "youtubeSubscriptionsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/subscriptions",
    validator: validate_YoutubeSubscriptionsDelete_581033, base: "/youtube/v3",
    url: url_YoutubeSubscriptionsDelete_581034, schemes: {Scheme.Https})
type
  Call_YoutubeSuperChatEventsList_581046 = ref object of OpenApiRestCall_579437
proc url_YoutubeSuperChatEventsList_581048(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeSuperChatEventsList_581047(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists Super Chat events for a channel.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: JString (required)
  ##       : The part parameter specifies the superChatEvent resource parts that the API response will include. Supported values are id and snippet.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   hl: JString
  ##     : The hl parameter instructs the API to retrieve localized resource metadata for a specific application language that the YouTube website supports. The parameter value must be a language code included in the list returned by the i18nLanguages.list method.
  ## 
  ## If localized resource details are available in that language, the resource's snippet.localized object will contain the localized values. However, if localized details are not available, the snippet.localized object will contain resource details in the resource's default language.
  section = newJObject()
  var valid_581049 = query.getOrDefault("fields")
  valid_581049 = validateParameter(valid_581049, JString, required = false,
                                 default = nil)
  if valid_581049 != nil:
    section.add "fields", valid_581049
  var valid_581050 = query.getOrDefault("pageToken")
  valid_581050 = validateParameter(valid_581050, JString, required = false,
                                 default = nil)
  if valid_581050 != nil:
    section.add "pageToken", valid_581050
  var valid_581051 = query.getOrDefault("quotaUser")
  valid_581051 = validateParameter(valid_581051, JString, required = false,
                                 default = nil)
  if valid_581051 != nil:
    section.add "quotaUser", valid_581051
  var valid_581052 = query.getOrDefault("alt")
  valid_581052 = validateParameter(valid_581052, JString, required = false,
                                 default = newJString("json"))
  if valid_581052 != nil:
    section.add "alt", valid_581052
  var valid_581053 = query.getOrDefault("oauth_token")
  valid_581053 = validateParameter(valid_581053, JString, required = false,
                                 default = nil)
  if valid_581053 != nil:
    section.add "oauth_token", valid_581053
  var valid_581054 = query.getOrDefault("userIp")
  valid_581054 = validateParameter(valid_581054, JString, required = false,
                                 default = nil)
  if valid_581054 != nil:
    section.add "userIp", valid_581054
  var valid_581055 = query.getOrDefault("maxResults")
  valid_581055 = validateParameter(valid_581055, JInt, required = false,
                                 default = newJInt(5))
  if valid_581055 != nil:
    section.add "maxResults", valid_581055
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_581056 = query.getOrDefault("part")
  valid_581056 = validateParameter(valid_581056, JString, required = true,
                                 default = nil)
  if valid_581056 != nil:
    section.add "part", valid_581056
  var valid_581057 = query.getOrDefault("key")
  valid_581057 = validateParameter(valid_581057, JString, required = false,
                                 default = nil)
  if valid_581057 != nil:
    section.add "key", valid_581057
  var valid_581058 = query.getOrDefault("prettyPrint")
  valid_581058 = validateParameter(valid_581058, JBool, required = false,
                                 default = newJBool(true))
  if valid_581058 != nil:
    section.add "prettyPrint", valid_581058
  var valid_581059 = query.getOrDefault("hl")
  valid_581059 = validateParameter(valid_581059, JString, required = false,
                                 default = nil)
  if valid_581059 != nil:
    section.add "hl", valid_581059
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581060: Call_YoutubeSuperChatEventsList_581046; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists Super Chat events for a channel.
  ## 
  let valid = call_581060.validator(path, query, header, formData, body)
  let scheme = call_581060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581060.url(scheme.get, call_581060.host, call_581060.base,
                         call_581060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581060, url, valid)

proc call*(call_581061: Call_YoutubeSuperChatEventsList_581046; part: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 5; key: string = ""; prettyPrint: bool = true; hl: string = ""): Recallable =
  ## youtubeSuperChatEventsList
  ## Lists Super Chat events for a channel.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ##   part: string (required)
  ##       : The part parameter specifies the superChatEvent resource parts that the API response will include. Supported values are id and snippet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   hl: string
  ##     : The hl parameter instructs the API to retrieve localized resource metadata for a specific application language that the YouTube website supports. The parameter value must be a language code included in the list returned by the i18nLanguages.list method.
  ## 
  ## If localized resource details are available in that language, the resource's snippet.localized object will contain the localized values. However, if localized details are not available, the snippet.localized object will contain resource details in the resource's default language.
  var query_581062 = newJObject()
  add(query_581062, "fields", newJString(fields))
  add(query_581062, "pageToken", newJString(pageToken))
  add(query_581062, "quotaUser", newJString(quotaUser))
  add(query_581062, "alt", newJString(alt))
  add(query_581062, "oauth_token", newJString(oauthToken))
  add(query_581062, "userIp", newJString(userIp))
  add(query_581062, "maxResults", newJInt(maxResults))
  add(query_581062, "part", newJString(part))
  add(query_581062, "key", newJString(key))
  add(query_581062, "prettyPrint", newJBool(prettyPrint))
  add(query_581062, "hl", newJString(hl))
  result = call_581061.call(nil, query_581062, nil, nil, nil)

var youtubeSuperChatEventsList* = Call_YoutubeSuperChatEventsList_581046(
    name: "youtubeSuperChatEventsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/superChatEvents",
    validator: validate_YoutubeSuperChatEventsList_581047, base: "/youtube/v3",
    url: url_YoutubeSuperChatEventsList_581048, schemes: {Scheme.Https})
type
  Call_YoutubeThumbnailsSet_581063 = ref object of OpenApiRestCall_579437
proc url_YoutubeThumbnailsSet_581065(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeThumbnailsSet_581064(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Uploads a custom video thumbnail to YouTube and sets it for a video.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   videoId: JString (required)
  ##          : The videoId parameter specifies a YouTube video ID for which the custom video thumbnail is being provided.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_581066 = query.getOrDefault("onBehalfOfContentOwner")
  valid_581066 = validateParameter(valid_581066, JString, required = false,
                                 default = nil)
  if valid_581066 != nil:
    section.add "onBehalfOfContentOwner", valid_581066
  var valid_581067 = query.getOrDefault("fields")
  valid_581067 = validateParameter(valid_581067, JString, required = false,
                                 default = nil)
  if valid_581067 != nil:
    section.add "fields", valid_581067
  var valid_581068 = query.getOrDefault("quotaUser")
  valid_581068 = validateParameter(valid_581068, JString, required = false,
                                 default = nil)
  if valid_581068 != nil:
    section.add "quotaUser", valid_581068
  var valid_581069 = query.getOrDefault("alt")
  valid_581069 = validateParameter(valid_581069, JString, required = false,
                                 default = newJString("json"))
  if valid_581069 != nil:
    section.add "alt", valid_581069
  var valid_581070 = query.getOrDefault("oauth_token")
  valid_581070 = validateParameter(valid_581070, JString, required = false,
                                 default = nil)
  if valid_581070 != nil:
    section.add "oauth_token", valid_581070
  var valid_581071 = query.getOrDefault("userIp")
  valid_581071 = validateParameter(valid_581071, JString, required = false,
                                 default = nil)
  if valid_581071 != nil:
    section.add "userIp", valid_581071
  assert query != nil, "query argument is necessary due to required `videoId` field"
  var valid_581072 = query.getOrDefault("videoId")
  valid_581072 = validateParameter(valid_581072, JString, required = true,
                                 default = nil)
  if valid_581072 != nil:
    section.add "videoId", valid_581072
  var valid_581073 = query.getOrDefault("key")
  valid_581073 = validateParameter(valid_581073, JString, required = false,
                                 default = nil)
  if valid_581073 != nil:
    section.add "key", valid_581073
  var valid_581074 = query.getOrDefault("prettyPrint")
  valid_581074 = validateParameter(valid_581074, JBool, required = false,
                                 default = newJBool(true))
  if valid_581074 != nil:
    section.add "prettyPrint", valid_581074
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581075: Call_YoutubeThumbnailsSet_581063; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Uploads a custom video thumbnail to YouTube and sets it for a video.
  ## 
  let valid = call_581075.validator(path, query, header, formData, body)
  let scheme = call_581075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581075.url(scheme.get, call_581075.host, call_581075.base,
                         call_581075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581075, url, valid)

proc call*(call_581076: Call_YoutubeThumbnailsSet_581063; videoId: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## youtubeThumbnailsSet
  ## Uploads a custom video thumbnail to YouTube and sets it for a video.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   videoId: string (required)
  ##          : The videoId parameter specifies a YouTube video ID for which the custom video thumbnail is being provided.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_581077 = newJObject()
  add(query_581077, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_581077, "fields", newJString(fields))
  add(query_581077, "quotaUser", newJString(quotaUser))
  add(query_581077, "alt", newJString(alt))
  add(query_581077, "oauth_token", newJString(oauthToken))
  add(query_581077, "userIp", newJString(userIp))
  add(query_581077, "videoId", newJString(videoId))
  add(query_581077, "key", newJString(key))
  add(query_581077, "prettyPrint", newJBool(prettyPrint))
  result = call_581076.call(nil, query_581077, nil, nil, nil)

var youtubeThumbnailsSet* = Call_YoutubeThumbnailsSet_581063(
    name: "youtubeThumbnailsSet", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/thumbnails/set",
    validator: validate_YoutubeThumbnailsSet_581064, base: "/youtube/v3",
    url: url_YoutubeThumbnailsSet_581065, schemes: {Scheme.Https})
type
  Call_YoutubeVideoAbuseReportReasonsList_581078 = ref object of OpenApiRestCall_579437
proc url_YoutubeVideoAbuseReportReasonsList_581080(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeVideoAbuseReportReasonsList_581079(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of abuse reasons that can be used for reporting abusive videos.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  ##   part: JString (required)
  ##       : The part parameter specifies the videoCategory resource parts that the API response will include. Supported values are id and snippet.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   hl: JString
  ##     : The hl parameter specifies the language that should be used for text values in the API response.
  section = newJObject()
  var valid_581081 = query.getOrDefault("fields")
  valid_581081 = validateParameter(valid_581081, JString, required = false,
                                 default = nil)
  if valid_581081 != nil:
    section.add "fields", valid_581081
  var valid_581082 = query.getOrDefault("quotaUser")
  valid_581082 = validateParameter(valid_581082, JString, required = false,
                                 default = nil)
  if valid_581082 != nil:
    section.add "quotaUser", valid_581082
  var valid_581083 = query.getOrDefault("alt")
  valid_581083 = validateParameter(valid_581083, JString, required = false,
                                 default = newJString("json"))
  if valid_581083 != nil:
    section.add "alt", valid_581083
  var valid_581084 = query.getOrDefault("oauth_token")
  valid_581084 = validateParameter(valid_581084, JString, required = false,
                                 default = nil)
  if valid_581084 != nil:
    section.add "oauth_token", valid_581084
  var valid_581085 = query.getOrDefault("userIp")
  valid_581085 = validateParameter(valid_581085, JString, required = false,
                                 default = nil)
  if valid_581085 != nil:
    section.add "userIp", valid_581085
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_581086 = query.getOrDefault("part")
  valid_581086 = validateParameter(valid_581086, JString, required = true,
                                 default = nil)
  if valid_581086 != nil:
    section.add "part", valid_581086
  var valid_581087 = query.getOrDefault("key")
  valid_581087 = validateParameter(valid_581087, JString, required = false,
                                 default = nil)
  if valid_581087 != nil:
    section.add "key", valid_581087
  var valid_581088 = query.getOrDefault("prettyPrint")
  valid_581088 = validateParameter(valid_581088, JBool, required = false,
                                 default = newJBool(true))
  if valid_581088 != nil:
    section.add "prettyPrint", valid_581088
  var valid_581089 = query.getOrDefault("hl")
  valid_581089 = validateParameter(valid_581089, JString, required = false,
                                 default = newJString("en_US"))
  if valid_581089 != nil:
    section.add "hl", valid_581089
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581090: Call_YoutubeVideoAbuseReportReasonsList_581078;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a list of abuse reasons that can be used for reporting abusive videos.
  ## 
  let valid = call_581090.validator(path, query, header, formData, body)
  let scheme = call_581090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581090.url(scheme.get, call_581090.host, call_581090.base,
                         call_581090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581090, url, valid)

proc call*(call_581091: Call_YoutubeVideoAbuseReportReasonsList_581078;
          part: string; fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true; hl: string = "en_US"): Recallable =
  ## youtubeVideoAbuseReportReasonsList
  ## Returns a list of abuse reasons that can be used for reporting abusive videos.
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
  ##   part: string (required)
  ##       : The part parameter specifies the videoCategory resource parts that the API response will include. Supported values are id and snippet.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   hl: string
  ##     : The hl parameter specifies the language that should be used for text values in the API response.
  var query_581092 = newJObject()
  add(query_581092, "fields", newJString(fields))
  add(query_581092, "quotaUser", newJString(quotaUser))
  add(query_581092, "alt", newJString(alt))
  add(query_581092, "oauth_token", newJString(oauthToken))
  add(query_581092, "userIp", newJString(userIp))
  add(query_581092, "part", newJString(part))
  add(query_581092, "key", newJString(key))
  add(query_581092, "prettyPrint", newJBool(prettyPrint))
  add(query_581092, "hl", newJString(hl))
  result = call_581091.call(nil, query_581092, nil, nil, nil)

var youtubeVideoAbuseReportReasonsList* = Call_YoutubeVideoAbuseReportReasonsList_581078(
    name: "youtubeVideoAbuseReportReasonsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/videoAbuseReportReasons",
    validator: validate_YoutubeVideoAbuseReportReasonsList_581079,
    base: "/youtube/v3", url: url_YoutubeVideoAbuseReportReasonsList_581080,
    schemes: {Scheme.Https})
type
  Call_YoutubeVideoCategoriesList_581093 = ref object of OpenApiRestCall_579437
proc url_YoutubeVideoCategoriesList_581095(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeVideoCategoriesList_581094(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of categories that can be associated with YouTube videos.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of video category IDs for the resources that you are retrieving.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter specifies the videoCategory resource properties that the API response will include. Set the parameter value to snippet.
  ##   regionCode: JString
  ##             : The regionCode parameter instructs the API to return the list of video categories available in the specified country. The parameter value is an ISO 3166-1 alpha-2 country code.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   hl: JString
  ##     : The hl parameter specifies the language that should be used for text values in the API response.
  section = newJObject()
  var valid_581096 = query.getOrDefault("fields")
  valid_581096 = validateParameter(valid_581096, JString, required = false,
                                 default = nil)
  if valid_581096 != nil:
    section.add "fields", valid_581096
  var valid_581097 = query.getOrDefault("quotaUser")
  valid_581097 = validateParameter(valid_581097, JString, required = false,
                                 default = nil)
  if valid_581097 != nil:
    section.add "quotaUser", valid_581097
  var valid_581098 = query.getOrDefault("id")
  valid_581098 = validateParameter(valid_581098, JString, required = false,
                                 default = nil)
  if valid_581098 != nil:
    section.add "id", valid_581098
  var valid_581099 = query.getOrDefault("alt")
  valid_581099 = validateParameter(valid_581099, JString, required = false,
                                 default = newJString("json"))
  if valid_581099 != nil:
    section.add "alt", valid_581099
  var valid_581100 = query.getOrDefault("oauth_token")
  valid_581100 = validateParameter(valid_581100, JString, required = false,
                                 default = nil)
  if valid_581100 != nil:
    section.add "oauth_token", valid_581100
  var valid_581101 = query.getOrDefault("userIp")
  valid_581101 = validateParameter(valid_581101, JString, required = false,
                                 default = nil)
  if valid_581101 != nil:
    section.add "userIp", valid_581101
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_581102 = query.getOrDefault("part")
  valid_581102 = validateParameter(valid_581102, JString, required = true,
                                 default = nil)
  if valid_581102 != nil:
    section.add "part", valid_581102
  var valid_581103 = query.getOrDefault("regionCode")
  valid_581103 = validateParameter(valid_581103, JString, required = false,
                                 default = nil)
  if valid_581103 != nil:
    section.add "regionCode", valid_581103
  var valid_581104 = query.getOrDefault("key")
  valid_581104 = validateParameter(valid_581104, JString, required = false,
                                 default = nil)
  if valid_581104 != nil:
    section.add "key", valid_581104
  var valid_581105 = query.getOrDefault("prettyPrint")
  valid_581105 = validateParameter(valid_581105, JBool, required = false,
                                 default = newJBool(true))
  if valid_581105 != nil:
    section.add "prettyPrint", valid_581105
  var valid_581106 = query.getOrDefault("hl")
  valid_581106 = validateParameter(valid_581106, JString, required = false,
                                 default = newJString("en_US"))
  if valid_581106 != nil:
    section.add "hl", valid_581106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581107: Call_YoutubeVideoCategoriesList_581093; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of categories that can be associated with YouTube videos.
  ## 
  let valid = call_581107.validator(path, query, header, formData, body)
  let scheme = call_581107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581107.url(scheme.get, call_581107.host, call_581107.base,
                         call_581107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581107, url, valid)

proc call*(call_581108: Call_YoutubeVideoCategoriesList_581093; part: string;
          fields: string = ""; quotaUser: string = ""; id: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          regionCode: string = ""; key: string = ""; prettyPrint: bool = true;
          hl: string = "en_US"): Recallable =
  ## youtubeVideoCategoriesList
  ## Returns a list of categories that can be associated with YouTube videos.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of video category IDs for the resources that you are retrieving.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter specifies the videoCategory resource properties that the API response will include. Set the parameter value to snippet.
  ##   regionCode: string
  ##             : The regionCode parameter instructs the API to return the list of video categories available in the specified country. The parameter value is an ISO 3166-1 alpha-2 country code.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   hl: string
  ##     : The hl parameter specifies the language that should be used for text values in the API response.
  var query_581109 = newJObject()
  add(query_581109, "fields", newJString(fields))
  add(query_581109, "quotaUser", newJString(quotaUser))
  add(query_581109, "id", newJString(id))
  add(query_581109, "alt", newJString(alt))
  add(query_581109, "oauth_token", newJString(oauthToken))
  add(query_581109, "userIp", newJString(userIp))
  add(query_581109, "part", newJString(part))
  add(query_581109, "regionCode", newJString(regionCode))
  add(query_581109, "key", newJString(key))
  add(query_581109, "prettyPrint", newJBool(prettyPrint))
  add(query_581109, "hl", newJString(hl))
  result = call_581108.call(nil, query_581109, nil, nil, nil)

var youtubeVideoCategoriesList* = Call_YoutubeVideoCategoriesList_581093(
    name: "youtubeVideoCategoriesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/videoCategories",
    validator: validate_YoutubeVideoCategoriesList_581094, base: "/youtube/v3",
    url: url_YoutubeVideoCategoriesList_581095, schemes: {Scheme.Https})
type
  Call_YoutubeVideosUpdate_581136 = ref object of OpenApiRestCall_579437
proc url_YoutubeVideosUpdate_581138(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeVideosUpdate_581137(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates a video's metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## Note that this method will override the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies. For example, a video's privacy setting is contained in the status part. As such, if your request is updating a private video, and the request's part parameter value includes the status part, the video's privacy setting will be updated to whatever value the request body specifies. If the request body does not specify a value, the existing privacy setting will be removed and the video will revert to the default privacy setting.
  ## 
  ## In addition, not all parts contain properties that can be set when inserting or updating a video. For example, the statistics object encapsulates statistics that YouTube calculates for a video and does not contain values that you can set or modify. If the parameter value specifies a part that does not contain mutable values, that part will still be included in the API response.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_581139 = query.getOrDefault("onBehalfOfContentOwner")
  valid_581139 = validateParameter(valid_581139, JString, required = false,
                                 default = nil)
  if valid_581139 != nil:
    section.add "onBehalfOfContentOwner", valid_581139
  var valid_581140 = query.getOrDefault("fields")
  valid_581140 = validateParameter(valid_581140, JString, required = false,
                                 default = nil)
  if valid_581140 != nil:
    section.add "fields", valid_581140
  var valid_581141 = query.getOrDefault("quotaUser")
  valid_581141 = validateParameter(valid_581141, JString, required = false,
                                 default = nil)
  if valid_581141 != nil:
    section.add "quotaUser", valid_581141
  var valid_581142 = query.getOrDefault("alt")
  valid_581142 = validateParameter(valid_581142, JString, required = false,
                                 default = newJString("json"))
  if valid_581142 != nil:
    section.add "alt", valid_581142
  var valid_581143 = query.getOrDefault("oauth_token")
  valid_581143 = validateParameter(valid_581143, JString, required = false,
                                 default = nil)
  if valid_581143 != nil:
    section.add "oauth_token", valid_581143
  var valid_581144 = query.getOrDefault("userIp")
  valid_581144 = validateParameter(valid_581144, JString, required = false,
                                 default = nil)
  if valid_581144 != nil:
    section.add "userIp", valid_581144
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_581145 = query.getOrDefault("part")
  valid_581145 = validateParameter(valid_581145, JString, required = true,
                                 default = nil)
  if valid_581145 != nil:
    section.add "part", valid_581145
  var valid_581146 = query.getOrDefault("key")
  valid_581146 = validateParameter(valid_581146, JString, required = false,
                                 default = nil)
  if valid_581146 != nil:
    section.add "key", valid_581146
  var valid_581147 = query.getOrDefault("prettyPrint")
  valid_581147 = validateParameter(valid_581147, JBool, required = false,
                                 default = newJBool(true))
  if valid_581147 != nil:
    section.add "prettyPrint", valid_581147
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

proc call*(call_581149: Call_YoutubeVideosUpdate_581136; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a video's metadata.
  ## 
  let valid = call_581149.validator(path, query, header, formData, body)
  let scheme = call_581149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581149.url(scheme.get, call_581149.host, call_581149.base,
                         call_581149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581149, url, valid)

proc call*(call_581150: Call_YoutubeVideosUpdate_581136; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## youtubeVideosUpdate
  ## Updates a video's metadata.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## Note that this method will override the existing values for all of the mutable properties that are contained in any parts that the parameter value specifies. For example, a video's privacy setting is contained in the status part. As such, if your request is updating a private video, and the request's part parameter value includes the status part, the video's privacy setting will be updated to whatever value the request body specifies. If the request body does not specify a value, the existing privacy setting will be removed and the video will revert to the default privacy setting.
  ## 
  ## In addition, not all parts contain properties that can be set when inserting or updating a video. For example, the statistics object encapsulates statistics that YouTube calculates for a video and does not contain values that you can set or modify. If the parameter value specifies a part that does not contain mutable values, that part will still be included in the API response.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_581151 = newJObject()
  var body_581152 = newJObject()
  add(query_581151, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_581151, "fields", newJString(fields))
  add(query_581151, "quotaUser", newJString(quotaUser))
  add(query_581151, "alt", newJString(alt))
  add(query_581151, "oauth_token", newJString(oauthToken))
  add(query_581151, "userIp", newJString(userIp))
  add(query_581151, "part", newJString(part))
  add(query_581151, "key", newJString(key))
  if body != nil:
    body_581152 = body
  add(query_581151, "prettyPrint", newJBool(prettyPrint))
  result = call_581150.call(nil, query_581151, nil, nil, body_581152)

var youtubeVideosUpdate* = Call_YoutubeVideosUpdate_581136(
    name: "youtubeVideosUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/videos",
    validator: validate_YoutubeVideosUpdate_581137, base: "/youtube/v3",
    url: url_YoutubeVideosUpdate_581138, schemes: {Scheme.Https})
type
  Call_YoutubeVideosInsert_581153 = ref object of OpenApiRestCall_579437
proc url_YoutubeVideosInsert_581155(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeVideosInsert_581154(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Uploads a video to YouTube and optionally sets the video's metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   notifySubscribers: JBool
  ##                    : The notifySubscribers parameter indicates whether YouTube should send a notification about the new video to users who subscribe to the video's channel. A parameter value of True indicates that subscribers will be notified of newly uploaded videos. However, a channel owner who is uploading many videos might prefer to set the value to False to avoid sending a notification about each new video to the channel's subscribers.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   autoLevels: JBool
  ##             : The autoLevels parameter indicates whether YouTube should automatically enhance the video's lighting and color.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: JString (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## Note that not all parts contain properties that can be set when inserting or updating a video. For example, the statistics object encapsulates statistics that YouTube calculates for a video and does not contain values that you can set or modify. If the parameter value specifies a part that does not contain mutable values, that part will still be included in the API response.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: JString
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   stabilize: JBool
  ##            : The stabilize parameter indicates whether YouTube should adjust the video to remove shaky camera motions.
  section = newJObject()
  var valid_581156 = query.getOrDefault("onBehalfOfContentOwner")
  valid_581156 = validateParameter(valid_581156, JString, required = false,
                                 default = nil)
  if valid_581156 != nil:
    section.add "onBehalfOfContentOwner", valid_581156
  var valid_581157 = query.getOrDefault("fields")
  valid_581157 = validateParameter(valid_581157, JString, required = false,
                                 default = nil)
  if valid_581157 != nil:
    section.add "fields", valid_581157
  var valid_581158 = query.getOrDefault("notifySubscribers")
  valid_581158 = validateParameter(valid_581158, JBool, required = false,
                                 default = newJBool(true))
  if valid_581158 != nil:
    section.add "notifySubscribers", valid_581158
  var valid_581159 = query.getOrDefault("quotaUser")
  valid_581159 = validateParameter(valid_581159, JString, required = false,
                                 default = nil)
  if valid_581159 != nil:
    section.add "quotaUser", valid_581159
  var valid_581160 = query.getOrDefault("alt")
  valid_581160 = validateParameter(valid_581160, JString, required = false,
                                 default = newJString("json"))
  if valid_581160 != nil:
    section.add "alt", valid_581160
  var valid_581161 = query.getOrDefault("autoLevels")
  valid_581161 = validateParameter(valid_581161, JBool, required = false, default = nil)
  if valid_581161 != nil:
    section.add "autoLevels", valid_581161
  var valid_581162 = query.getOrDefault("oauth_token")
  valid_581162 = validateParameter(valid_581162, JString, required = false,
                                 default = nil)
  if valid_581162 != nil:
    section.add "oauth_token", valid_581162
  var valid_581163 = query.getOrDefault("userIp")
  valid_581163 = validateParameter(valid_581163, JString, required = false,
                                 default = nil)
  if valid_581163 != nil:
    section.add "userIp", valid_581163
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_581164 = query.getOrDefault("part")
  valid_581164 = validateParameter(valid_581164, JString, required = true,
                                 default = nil)
  if valid_581164 != nil:
    section.add "part", valid_581164
  var valid_581165 = query.getOrDefault("key")
  valid_581165 = validateParameter(valid_581165, JString, required = false,
                                 default = nil)
  if valid_581165 != nil:
    section.add "key", valid_581165
  var valid_581166 = query.getOrDefault("prettyPrint")
  valid_581166 = validateParameter(valid_581166, JBool, required = false,
                                 default = newJBool(true))
  if valid_581166 != nil:
    section.add "prettyPrint", valid_581166
  var valid_581167 = query.getOrDefault("onBehalfOfContentOwnerChannel")
  valid_581167 = validateParameter(valid_581167, JString, required = false,
                                 default = nil)
  if valid_581167 != nil:
    section.add "onBehalfOfContentOwnerChannel", valid_581167
  var valid_581168 = query.getOrDefault("stabilize")
  valid_581168 = validateParameter(valid_581168, JBool, required = false, default = nil)
  if valid_581168 != nil:
    section.add "stabilize", valid_581168
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

proc call*(call_581170: Call_YoutubeVideosInsert_581153; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Uploads a video to YouTube and optionally sets the video's metadata.
  ## 
  let valid = call_581170.validator(path, query, header, formData, body)
  let scheme = call_581170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581170.url(scheme.get, call_581170.host, call_581170.base,
                         call_581170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581170, url, valid)

proc call*(call_581171: Call_YoutubeVideosInsert_581153; part: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          notifySubscribers: bool = true; quotaUser: string = ""; alt: string = "json";
          autoLevels: bool = false; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true;
          onBehalfOfContentOwnerChannel: string = ""; stabilize: bool = false): Recallable =
  ## youtubeVideosInsert
  ## Uploads a video to YouTube and optionally sets the video's metadata.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   notifySubscribers: bool
  ##                    : The notifySubscribers parameter indicates whether YouTube should send a notification about the new video to users who subscribe to the video's channel. A parameter value of True indicates that subscribers will be notified of newly uploaded videos. However, a channel owner who is uploading many videos might prefer to set the value to False to avoid sending a notification about each new video to the channel's subscribers.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   autoLevels: bool
  ##             : The autoLevels parameter indicates whether YouTube should automatically enhance the video's lighting and color.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   part: string (required)
  ##       : The part parameter serves two purposes in this operation. It identifies the properties that the write operation will set as well as the properties that the API response will include.
  ## 
  ## Note that not all parts contain properties that can be set when inserting or updating a video. For example, the statistics object encapsulates statistics that YouTube calculates for a video and does not contain values that you can set or modify. If the parameter value specifies a part that does not contain mutable values, that part will still be included in the API response.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   onBehalfOfContentOwnerChannel: string
  ##                                : This parameter can only be used in a properly authorized request. Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwnerChannel parameter specifies the YouTube channel ID of the channel to which a video is being added. This parameter is required when a request specifies a value for the onBehalfOfContentOwner parameter, and it can only be used in conjunction with that parameter. In addition, the request must be authorized using a CMS account that is linked to the content owner that the onBehalfOfContentOwner parameter specifies. Finally, the channel that the onBehalfOfContentOwnerChannel parameter value specifies must be linked to the content owner that the onBehalfOfContentOwner parameter specifies.
  ## 
  ## This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and perform actions on behalf of the channel specified in the parameter value, without having to provide authentication credentials for each separate channel.
  ##   stabilize: bool
  ##            : The stabilize parameter indicates whether YouTube should adjust the video to remove shaky camera motions.
  var query_581172 = newJObject()
  var body_581173 = newJObject()
  add(query_581172, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_581172, "fields", newJString(fields))
  add(query_581172, "notifySubscribers", newJBool(notifySubscribers))
  add(query_581172, "quotaUser", newJString(quotaUser))
  add(query_581172, "alt", newJString(alt))
  add(query_581172, "autoLevels", newJBool(autoLevels))
  add(query_581172, "oauth_token", newJString(oauthToken))
  add(query_581172, "userIp", newJString(userIp))
  add(query_581172, "part", newJString(part))
  add(query_581172, "key", newJString(key))
  if body != nil:
    body_581173 = body
  add(query_581172, "prettyPrint", newJBool(prettyPrint))
  add(query_581172, "onBehalfOfContentOwnerChannel",
      newJString(onBehalfOfContentOwnerChannel))
  add(query_581172, "stabilize", newJBool(stabilize))
  result = call_581171.call(nil, query_581172, nil, nil, body_581173)

var youtubeVideosInsert* = Call_YoutubeVideosInsert_581153(
    name: "youtubeVideosInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/videos",
    validator: validate_YoutubeVideosInsert_581154, base: "/youtube/v3",
    url: url_YoutubeVideosInsert_581155, schemes: {Scheme.Https})
type
  Call_YoutubeVideosList_581110 = ref object of OpenApiRestCall_579437
proc url_YoutubeVideosList_581112(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeVideosList_581111(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Returns a list of videos that match the API request parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   locale: JString
  ##         : DEPRECATED
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ## 
  ## Note: This parameter is supported for use in conjunction with the myRating and chart parameters, but it is not supported for use in conjunction with the id parameter.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   maxHeight: JInt
  ##            : The maxHeight parameter specifies a maximum height of the embedded player. If maxWidth is provided, maxHeight may not be reached in order to not violate the width request.
  ##   id: JString
  ##     : The id parameter specifies a comma-separated list of the YouTube video ID(s) for the resource(s) that are being retrieved. In a video resource, the id property specifies the video's ID.
  ##   alt: JString
  ##      : Data format for the response.
  ##   maxWidth: JInt
  ##           : The maxWidth parameter specifies a maximum width of the embedded player. If maxHeight is provided, maxWidth may not be reached in order to not violate the height request.
  ##   myRating: JString
  ##           : Set this parameter's value to like or dislike to instruct the API to only return videos liked or disliked by the authenticated user.
  ##   chart: JString
  ##        : The chart parameter identifies the chart that you want to retrieve.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ## 
  ## Note: This parameter is supported for use in conjunction with the myRating and chart parameters, but it is not supported for use in conjunction with the id parameter.
  ##   part: JString (required)
  ##       : The part parameter specifies a comma-separated list of one or more video resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a video resource, the snippet property contains the channelId, title, description, tags, and categoryId properties. As such, if you set part=snippet, the API response will contain all of those properties.
  ##   regionCode: JString
  ##             : The regionCode parameter instructs the API to select a video chart available in the specified region. This parameter can only be used in conjunction with the chart parameter. The parameter value is an ISO 3166-1 alpha-2 country code.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   hl: JString
  ##     : The hl parameter instructs the API to retrieve localized resource metadata for a specific application language that the YouTube website supports. The parameter value must be a language code included in the list returned by the i18nLanguages.list method.
  ## 
  ## If localized resource details are available in that language, the resource's snippet.localized object will contain the localized values. However, if localized details are not available, the snippet.localized object will contain resource details in the resource's default language.
  ##   videoCategoryId: JString
  ##                  : The videoCategoryId parameter identifies the video category for which the chart should be retrieved. This parameter can only be used in conjunction with the chart parameter. By default, charts are not restricted to a particular category.
  section = newJObject()
  var valid_581113 = query.getOrDefault("onBehalfOfContentOwner")
  valid_581113 = validateParameter(valid_581113, JString, required = false,
                                 default = nil)
  if valid_581113 != nil:
    section.add "onBehalfOfContentOwner", valid_581113
  var valid_581114 = query.getOrDefault("locale")
  valid_581114 = validateParameter(valid_581114, JString, required = false,
                                 default = nil)
  if valid_581114 != nil:
    section.add "locale", valid_581114
  var valid_581115 = query.getOrDefault("fields")
  valid_581115 = validateParameter(valid_581115, JString, required = false,
                                 default = nil)
  if valid_581115 != nil:
    section.add "fields", valid_581115
  var valid_581116 = query.getOrDefault("pageToken")
  valid_581116 = validateParameter(valid_581116, JString, required = false,
                                 default = nil)
  if valid_581116 != nil:
    section.add "pageToken", valid_581116
  var valid_581117 = query.getOrDefault("quotaUser")
  valid_581117 = validateParameter(valid_581117, JString, required = false,
                                 default = nil)
  if valid_581117 != nil:
    section.add "quotaUser", valid_581117
  var valid_581118 = query.getOrDefault("maxHeight")
  valid_581118 = validateParameter(valid_581118, JInt, required = false, default = nil)
  if valid_581118 != nil:
    section.add "maxHeight", valid_581118
  var valid_581119 = query.getOrDefault("id")
  valid_581119 = validateParameter(valid_581119, JString, required = false,
                                 default = nil)
  if valid_581119 != nil:
    section.add "id", valid_581119
  var valid_581120 = query.getOrDefault("alt")
  valid_581120 = validateParameter(valid_581120, JString, required = false,
                                 default = newJString("json"))
  if valid_581120 != nil:
    section.add "alt", valid_581120
  var valid_581121 = query.getOrDefault("maxWidth")
  valid_581121 = validateParameter(valid_581121, JInt, required = false, default = nil)
  if valid_581121 != nil:
    section.add "maxWidth", valid_581121
  var valid_581122 = query.getOrDefault("myRating")
  valid_581122 = validateParameter(valid_581122, JString, required = false,
                                 default = newJString("dislike"))
  if valid_581122 != nil:
    section.add "myRating", valid_581122
  var valid_581123 = query.getOrDefault("chart")
  valid_581123 = validateParameter(valid_581123, JString, required = false,
                                 default = newJString("mostPopular"))
  if valid_581123 != nil:
    section.add "chart", valid_581123
  var valid_581124 = query.getOrDefault("oauth_token")
  valid_581124 = validateParameter(valid_581124, JString, required = false,
                                 default = nil)
  if valid_581124 != nil:
    section.add "oauth_token", valid_581124
  var valid_581125 = query.getOrDefault("userIp")
  valid_581125 = validateParameter(valid_581125, JString, required = false,
                                 default = nil)
  if valid_581125 != nil:
    section.add "userIp", valid_581125
  var valid_581126 = query.getOrDefault("maxResults")
  valid_581126 = validateParameter(valid_581126, JInt, required = false,
                                 default = newJInt(5))
  if valid_581126 != nil:
    section.add "maxResults", valid_581126
  assert query != nil, "query argument is necessary due to required `part` field"
  var valid_581127 = query.getOrDefault("part")
  valid_581127 = validateParameter(valid_581127, JString, required = true,
                                 default = nil)
  if valid_581127 != nil:
    section.add "part", valid_581127
  var valid_581128 = query.getOrDefault("regionCode")
  valid_581128 = validateParameter(valid_581128, JString, required = false,
                                 default = nil)
  if valid_581128 != nil:
    section.add "regionCode", valid_581128
  var valid_581129 = query.getOrDefault("key")
  valid_581129 = validateParameter(valid_581129, JString, required = false,
                                 default = nil)
  if valid_581129 != nil:
    section.add "key", valid_581129
  var valid_581130 = query.getOrDefault("prettyPrint")
  valid_581130 = validateParameter(valid_581130, JBool, required = false,
                                 default = newJBool(true))
  if valid_581130 != nil:
    section.add "prettyPrint", valid_581130
  var valid_581131 = query.getOrDefault("hl")
  valid_581131 = validateParameter(valid_581131, JString, required = false,
                                 default = nil)
  if valid_581131 != nil:
    section.add "hl", valid_581131
  var valid_581132 = query.getOrDefault("videoCategoryId")
  valid_581132 = validateParameter(valid_581132, JString, required = false,
                                 default = newJString("0"))
  if valid_581132 != nil:
    section.add "videoCategoryId", valid_581132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581133: Call_YoutubeVideosList_581110; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of videos that match the API request parameters.
  ## 
  let valid = call_581133.validator(path, query, header, formData, body)
  let scheme = call_581133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581133.url(scheme.get, call_581133.host, call_581133.base,
                         call_581133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581133, url, valid)

proc call*(call_581134: Call_YoutubeVideosList_581110; part: string;
          onBehalfOfContentOwner: string = ""; locale: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; maxHeight: int = 0;
          id: string = ""; alt: string = "json"; maxWidth: int = 0;
          myRating: string = "dislike"; chart: string = "mostPopular";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 5;
          regionCode: string = ""; key: string = ""; prettyPrint: bool = true;
          hl: string = ""; videoCategoryId: string = "0"): Recallable =
  ## youtubeVideosList
  ## Returns a list of videos that match the API request parameters.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   locale: string
  ##         : DEPRECATED
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The pageToken parameter identifies a specific page in the result set that should be returned. In an API response, the nextPageToken and prevPageToken properties identify other pages that could be retrieved.
  ## 
  ## Note: This parameter is supported for use in conjunction with the myRating and chart parameters, but it is not supported for use in conjunction with the id parameter.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   maxHeight: int
  ##            : The maxHeight parameter specifies a maximum height of the embedded player. If maxWidth is provided, maxHeight may not be reached in order to not violate the width request.
  ##   id: string
  ##     : The id parameter specifies a comma-separated list of the YouTube video ID(s) for the resource(s) that are being retrieved. In a video resource, the id property specifies the video's ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   maxWidth: int
  ##           : The maxWidth parameter specifies a maximum width of the embedded player. If maxHeight is provided, maxWidth may not be reached in order to not violate the height request.
  ##   myRating: string
  ##           : Set this parameter's value to like or dislike to instruct the API to only return videos liked or disliked by the authenticated user.
  ##   chart: string
  ##        : The chart parameter identifies the chart that you want to retrieve.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : The maxResults parameter specifies the maximum number of items that should be returned in the result set.
  ## 
  ## Note: This parameter is supported for use in conjunction with the myRating and chart parameters, but it is not supported for use in conjunction with the id parameter.
  ##   part: string (required)
  ##       : The part parameter specifies a comma-separated list of one or more video resource properties that the API response will include.
  ## 
  ## If the parameter identifies a property that contains child properties, the child properties will be included in the response. For example, in a video resource, the snippet property contains the channelId, title, description, tags, and categoryId properties. As such, if you set part=snippet, the API response will contain all of those properties.
  ##   regionCode: string
  ##             : The regionCode parameter instructs the API to select a video chart available in the specified region. This parameter can only be used in conjunction with the chart parameter. The parameter value is an ISO 3166-1 alpha-2 country code.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   hl: string
  ##     : The hl parameter instructs the API to retrieve localized resource metadata for a specific application language that the YouTube website supports. The parameter value must be a language code included in the list returned by the i18nLanguages.list method.
  ## 
  ## If localized resource details are available in that language, the resource's snippet.localized object will contain the localized values. However, if localized details are not available, the snippet.localized object will contain resource details in the resource's default language.
  ##   videoCategoryId: string
  ##                  : The videoCategoryId parameter identifies the video category for which the chart should be retrieved. This parameter can only be used in conjunction with the chart parameter. By default, charts are not restricted to a particular category.
  var query_581135 = newJObject()
  add(query_581135, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_581135, "locale", newJString(locale))
  add(query_581135, "fields", newJString(fields))
  add(query_581135, "pageToken", newJString(pageToken))
  add(query_581135, "quotaUser", newJString(quotaUser))
  add(query_581135, "maxHeight", newJInt(maxHeight))
  add(query_581135, "id", newJString(id))
  add(query_581135, "alt", newJString(alt))
  add(query_581135, "maxWidth", newJInt(maxWidth))
  add(query_581135, "myRating", newJString(myRating))
  add(query_581135, "chart", newJString(chart))
  add(query_581135, "oauth_token", newJString(oauthToken))
  add(query_581135, "userIp", newJString(userIp))
  add(query_581135, "maxResults", newJInt(maxResults))
  add(query_581135, "part", newJString(part))
  add(query_581135, "regionCode", newJString(regionCode))
  add(query_581135, "key", newJString(key))
  add(query_581135, "prettyPrint", newJBool(prettyPrint))
  add(query_581135, "hl", newJString(hl))
  add(query_581135, "videoCategoryId", newJString(videoCategoryId))
  result = call_581134.call(nil, query_581135, nil, nil, nil)

var youtubeVideosList* = Call_YoutubeVideosList_581110(name: "youtubeVideosList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/videos",
    validator: validate_YoutubeVideosList_581111, base: "/youtube/v3",
    url: url_YoutubeVideosList_581112, schemes: {Scheme.Https})
type
  Call_YoutubeVideosDelete_581174 = ref object of OpenApiRestCall_579437
proc url_YoutubeVideosDelete_581176(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeVideosDelete_581175(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes a YouTube video.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the YouTube video ID for the resource that is being deleted. In a video resource, the id property specifies the video's ID.
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
  var valid_581177 = query.getOrDefault("onBehalfOfContentOwner")
  valid_581177 = validateParameter(valid_581177, JString, required = false,
                                 default = nil)
  if valid_581177 != nil:
    section.add "onBehalfOfContentOwner", valid_581177
  var valid_581178 = query.getOrDefault("fields")
  valid_581178 = validateParameter(valid_581178, JString, required = false,
                                 default = nil)
  if valid_581178 != nil:
    section.add "fields", valid_581178
  var valid_581179 = query.getOrDefault("quotaUser")
  valid_581179 = validateParameter(valid_581179, JString, required = false,
                                 default = nil)
  if valid_581179 != nil:
    section.add "quotaUser", valid_581179
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_581180 = query.getOrDefault("id")
  valid_581180 = validateParameter(valid_581180, JString, required = true,
                                 default = nil)
  if valid_581180 != nil:
    section.add "id", valid_581180
  var valid_581181 = query.getOrDefault("alt")
  valid_581181 = validateParameter(valid_581181, JString, required = false,
                                 default = newJString("json"))
  if valid_581181 != nil:
    section.add "alt", valid_581181
  var valid_581182 = query.getOrDefault("oauth_token")
  valid_581182 = validateParameter(valid_581182, JString, required = false,
                                 default = nil)
  if valid_581182 != nil:
    section.add "oauth_token", valid_581182
  var valid_581183 = query.getOrDefault("userIp")
  valid_581183 = validateParameter(valid_581183, JString, required = false,
                                 default = nil)
  if valid_581183 != nil:
    section.add "userIp", valid_581183
  var valid_581184 = query.getOrDefault("key")
  valid_581184 = validateParameter(valid_581184, JString, required = false,
                                 default = nil)
  if valid_581184 != nil:
    section.add "key", valid_581184
  var valid_581185 = query.getOrDefault("prettyPrint")
  valid_581185 = validateParameter(valid_581185, JBool, required = false,
                                 default = newJBool(true))
  if valid_581185 != nil:
    section.add "prettyPrint", valid_581185
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581186: Call_YoutubeVideosDelete_581174; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a YouTube video.
  ## 
  let valid = call_581186.validator(path, query, header, formData, body)
  let scheme = call_581186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581186.url(scheme.get, call_581186.host, call_581186.base,
                         call_581186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581186, url, valid)

proc call*(call_581187: Call_YoutubeVideosDelete_581174; id: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## youtubeVideosDelete
  ## Deletes a YouTube video.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The actual CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the YouTube video ID for the resource that is being deleted. In a video resource, the id property specifies the video's ID.
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
  var query_581188 = newJObject()
  add(query_581188, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_581188, "fields", newJString(fields))
  add(query_581188, "quotaUser", newJString(quotaUser))
  add(query_581188, "id", newJString(id))
  add(query_581188, "alt", newJString(alt))
  add(query_581188, "oauth_token", newJString(oauthToken))
  add(query_581188, "userIp", newJString(userIp))
  add(query_581188, "key", newJString(key))
  add(query_581188, "prettyPrint", newJBool(prettyPrint))
  result = call_581187.call(nil, query_581188, nil, nil, nil)

var youtubeVideosDelete* = Call_YoutubeVideosDelete_581174(
    name: "youtubeVideosDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/videos",
    validator: validate_YoutubeVideosDelete_581175, base: "/youtube/v3",
    url: url_YoutubeVideosDelete_581176, schemes: {Scheme.Https})
type
  Call_YoutubeVideosGetRating_581189 = ref object of OpenApiRestCall_579437
proc url_YoutubeVideosGetRating_581191(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeVideosGetRating_581190(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the ratings that the authorized user gave to a list of specified videos.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies a comma-separated list of the YouTube video ID(s) for the resource(s) for which you are retrieving rating data. In a video resource, the id property specifies the video's ID.
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
  var valid_581192 = query.getOrDefault("onBehalfOfContentOwner")
  valid_581192 = validateParameter(valid_581192, JString, required = false,
                                 default = nil)
  if valid_581192 != nil:
    section.add "onBehalfOfContentOwner", valid_581192
  var valid_581193 = query.getOrDefault("fields")
  valid_581193 = validateParameter(valid_581193, JString, required = false,
                                 default = nil)
  if valid_581193 != nil:
    section.add "fields", valid_581193
  var valid_581194 = query.getOrDefault("quotaUser")
  valid_581194 = validateParameter(valid_581194, JString, required = false,
                                 default = nil)
  if valid_581194 != nil:
    section.add "quotaUser", valid_581194
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_581195 = query.getOrDefault("id")
  valid_581195 = validateParameter(valid_581195, JString, required = true,
                                 default = nil)
  if valid_581195 != nil:
    section.add "id", valid_581195
  var valid_581196 = query.getOrDefault("alt")
  valid_581196 = validateParameter(valid_581196, JString, required = false,
                                 default = newJString("json"))
  if valid_581196 != nil:
    section.add "alt", valid_581196
  var valid_581197 = query.getOrDefault("oauth_token")
  valid_581197 = validateParameter(valid_581197, JString, required = false,
                                 default = nil)
  if valid_581197 != nil:
    section.add "oauth_token", valid_581197
  var valid_581198 = query.getOrDefault("userIp")
  valid_581198 = validateParameter(valid_581198, JString, required = false,
                                 default = nil)
  if valid_581198 != nil:
    section.add "userIp", valid_581198
  var valid_581199 = query.getOrDefault("key")
  valid_581199 = validateParameter(valid_581199, JString, required = false,
                                 default = nil)
  if valid_581199 != nil:
    section.add "key", valid_581199
  var valid_581200 = query.getOrDefault("prettyPrint")
  valid_581200 = validateParameter(valid_581200, JBool, required = false,
                                 default = newJBool(true))
  if valid_581200 != nil:
    section.add "prettyPrint", valid_581200
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581201: Call_YoutubeVideosGetRating_581189; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the ratings that the authorized user gave to a list of specified videos.
  ## 
  let valid = call_581201.validator(path, query, header, formData, body)
  let scheme = call_581201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581201.url(scheme.get, call_581201.host, call_581201.base,
                         call_581201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581201, url, valid)

proc call*(call_581202: Call_YoutubeVideosGetRating_581189; id: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## youtubeVideosGetRating
  ## Retrieves the ratings that the authorized user gave to a list of specified videos.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies a comma-separated list of the YouTube video ID(s) for the resource(s) for which you are retrieving rating data. In a video resource, the id property specifies the video's ID.
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
  var query_581203 = newJObject()
  add(query_581203, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_581203, "fields", newJString(fields))
  add(query_581203, "quotaUser", newJString(quotaUser))
  add(query_581203, "id", newJString(id))
  add(query_581203, "alt", newJString(alt))
  add(query_581203, "oauth_token", newJString(oauthToken))
  add(query_581203, "userIp", newJString(userIp))
  add(query_581203, "key", newJString(key))
  add(query_581203, "prettyPrint", newJBool(prettyPrint))
  result = call_581202.call(nil, query_581203, nil, nil, nil)

var youtubeVideosGetRating* = Call_YoutubeVideosGetRating_581189(
    name: "youtubeVideosGetRating", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/videos/getRating",
    validator: validate_YoutubeVideosGetRating_581190, base: "/youtube/v3",
    url: url_YoutubeVideosGetRating_581191, schemes: {Scheme.Https})
type
  Call_YoutubeVideosRate_581204 = ref object of OpenApiRestCall_579437
proc url_YoutubeVideosRate_581206(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeVideosRate_581205(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Add a like or dislike rating to a video or remove a rating from a video.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: JString (required)
  ##     : The id parameter specifies the YouTube video ID of the video that is being rated or having its rating removed.
  ##   alt: JString
  ##      : Data format for the response.
  ##   rating: JString (required)
  ##         : Specifies the rating to record.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_581207 = query.getOrDefault("fields")
  valid_581207 = validateParameter(valid_581207, JString, required = false,
                                 default = nil)
  if valid_581207 != nil:
    section.add "fields", valid_581207
  var valid_581208 = query.getOrDefault("quotaUser")
  valid_581208 = validateParameter(valid_581208, JString, required = false,
                                 default = nil)
  if valid_581208 != nil:
    section.add "quotaUser", valid_581208
  assert query != nil, "query argument is necessary due to required `id` field"
  var valid_581209 = query.getOrDefault("id")
  valid_581209 = validateParameter(valid_581209, JString, required = true,
                                 default = nil)
  if valid_581209 != nil:
    section.add "id", valid_581209
  var valid_581210 = query.getOrDefault("alt")
  valid_581210 = validateParameter(valid_581210, JString, required = false,
                                 default = newJString("json"))
  if valid_581210 != nil:
    section.add "alt", valid_581210
  var valid_581211 = query.getOrDefault("rating")
  valid_581211 = validateParameter(valid_581211, JString, required = true,
                                 default = newJString("dislike"))
  if valid_581211 != nil:
    section.add "rating", valid_581211
  var valid_581212 = query.getOrDefault("oauth_token")
  valid_581212 = validateParameter(valid_581212, JString, required = false,
                                 default = nil)
  if valid_581212 != nil:
    section.add "oauth_token", valid_581212
  var valid_581213 = query.getOrDefault("userIp")
  valid_581213 = validateParameter(valid_581213, JString, required = false,
                                 default = nil)
  if valid_581213 != nil:
    section.add "userIp", valid_581213
  var valid_581214 = query.getOrDefault("key")
  valid_581214 = validateParameter(valid_581214, JString, required = false,
                                 default = nil)
  if valid_581214 != nil:
    section.add "key", valid_581214
  var valid_581215 = query.getOrDefault("prettyPrint")
  valid_581215 = validateParameter(valid_581215, JBool, required = false,
                                 default = newJBool(true))
  if valid_581215 != nil:
    section.add "prettyPrint", valid_581215
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581216: Call_YoutubeVideosRate_581204; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a like or dislike rating to a video or remove a rating from a video.
  ## 
  let valid = call_581216.validator(path, query, header, formData, body)
  let scheme = call_581216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581216.url(scheme.get, call_581216.host, call_581216.base,
                         call_581216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581216, url, valid)

proc call*(call_581217: Call_YoutubeVideosRate_581204; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          rating: string = "dislike"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## youtubeVideosRate
  ## Add a like or dislike rating to a video or remove a rating from a video.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   id: string (required)
  ##     : The id parameter specifies the YouTube video ID of the video that is being rated or having its rating removed.
  ##   alt: string
  ##      : Data format for the response.
  ##   rating: string (required)
  ##         : Specifies the rating to record.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_581218 = newJObject()
  add(query_581218, "fields", newJString(fields))
  add(query_581218, "quotaUser", newJString(quotaUser))
  add(query_581218, "id", newJString(id))
  add(query_581218, "alt", newJString(alt))
  add(query_581218, "rating", newJString(rating))
  add(query_581218, "oauth_token", newJString(oauthToken))
  add(query_581218, "userIp", newJString(userIp))
  add(query_581218, "key", newJString(key))
  add(query_581218, "prettyPrint", newJBool(prettyPrint))
  result = call_581217.call(nil, query_581218, nil, nil, nil)

var youtubeVideosRate* = Call_YoutubeVideosRate_581204(name: "youtubeVideosRate",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/videos/rate",
    validator: validate_YoutubeVideosRate_581205, base: "/youtube/v3",
    url: url_YoutubeVideosRate_581206, schemes: {Scheme.Https})
type
  Call_YoutubeVideosReportAbuse_581219 = ref object of OpenApiRestCall_579437
proc url_YoutubeVideosReportAbuse_581221(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeVideosReportAbuse_581220(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Report abuse for a video.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  var valid_581222 = query.getOrDefault("onBehalfOfContentOwner")
  valid_581222 = validateParameter(valid_581222, JString, required = false,
                                 default = nil)
  if valid_581222 != nil:
    section.add "onBehalfOfContentOwner", valid_581222
  var valid_581223 = query.getOrDefault("fields")
  valid_581223 = validateParameter(valid_581223, JString, required = false,
                                 default = nil)
  if valid_581223 != nil:
    section.add "fields", valid_581223
  var valid_581224 = query.getOrDefault("quotaUser")
  valid_581224 = validateParameter(valid_581224, JString, required = false,
                                 default = nil)
  if valid_581224 != nil:
    section.add "quotaUser", valid_581224
  var valid_581225 = query.getOrDefault("alt")
  valid_581225 = validateParameter(valid_581225, JString, required = false,
                                 default = newJString("json"))
  if valid_581225 != nil:
    section.add "alt", valid_581225
  var valid_581226 = query.getOrDefault("oauth_token")
  valid_581226 = validateParameter(valid_581226, JString, required = false,
                                 default = nil)
  if valid_581226 != nil:
    section.add "oauth_token", valid_581226
  var valid_581227 = query.getOrDefault("userIp")
  valid_581227 = validateParameter(valid_581227, JString, required = false,
                                 default = nil)
  if valid_581227 != nil:
    section.add "userIp", valid_581227
  var valid_581228 = query.getOrDefault("key")
  valid_581228 = validateParameter(valid_581228, JString, required = false,
                                 default = nil)
  if valid_581228 != nil:
    section.add "key", valid_581228
  var valid_581229 = query.getOrDefault("prettyPrint")
  valid_581229 = validateParameter(valid_581229, JBool, required = false,
                                 default = newJBool(true))
  if valid_581229 != nil:
    section.add "prettyPrint", valid_581229
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

proc call*(call_581231: Call_YoutubeVideosReportAbuse_581219; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Report abuse for a video.
  ## 
  let valid = call_581231.validator(path, query, header, formData, body)
  let scheme = call_581231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581231.url(scheme.get, call_581231.host, call_581231.base,
                         call_581231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581231, url, valid)

proc call*(call_581232: Call_YoutubeVideosReportAbuse_581219;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## youtubeVideosReportAbuse
  ## Report abuse for a video.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_581233 = newJObject()
  var body_581234 = newJObject()
  add(query_581233, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_581233, "fields", newJString(fields))
  add(query_581233, "quotaUser", newJString(quotaUser))
  add(query_581233, "alt", newJString(alt))
  add(query_581233, "oauth_token", newJString(oauthToken))
  add(query_581233, "userIp", newJString(userIp))
  add(query_581233, "key", newJString(key))
  if body != nil:
    body_581234 = body
  add(query_581233, "prettyPrint", newJBool(prettyPrint))
  result = call_581232.call(nil, query_581233, nil, nil, body_581234)

var youtubeVideosReportAbuse* = Call_YoutubeVideosReportAbuse_581219(
    name: "youtubeVideosReportAbuse", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/videos/reportAbuse",
    validator: validate_YoutubeVideosReportAbuse_581220, base: "/youtube/v3",
    url: url_YoutubeVideosReportAbuse_581221, schemes: {Scheme.Https})
type
  Call_YoutubeWatermarksSet_581235 = ref object of OpenApiRestCall_579437
proc url_YoutubeWatermarksSet_581237(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeWatermarksSet_581236(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Uploads a watermark image to YouTube and sets it for a channel.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   channelId: JString (required)
  ##            : The channelId parameter specifies the YouTube channel ID for which the watermark is being provided.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_581238 = query.getOrDefault("onBehalfOfContentOwner")
  valid_581238 = validateParameter(valid_581238, JString, required = false,
                                 default = nil)
  if valid_581238 != nil:
    section.add "onBehalfOfContentOwner", valid_581238
  var valid_581239 = query.getOrDefault("fields")
  valid_581239 = validateParameter(valid_581239, JString, required = false,
                                 default = nil)
  if valid_581239 != nil:
    section.add "fields", valid_581239
  var valid_581240 = query.getOrDefault("quotaUser")
  valid_581240 = validateParameter(valid_581240, JString, required = false,
                                 default = nil)
  if valid_581240 != nil:
    section.add "quotaUser", valid_581240
  var valid_581241 = query.getOrDefault("alt")
  valid_581241 = validateParameter(valid_581241, JString, required = false,
                                 default = newJString("json"))
  if valid_581241 != nil:
    section.add "alt", valid_581241
  var valid_581242 = query.getOrDefault("oauth_token")
  valid_581242 = validateParameter(valid_581242, JString, required = false,
                                 default = nil)
  if valid_581242 != nil:
    section.add "oauth_token", valid_581242
  var valid_581243 = query.getOrDefault("userIp")
  valid_581243 = validateParameter(valid_581243, JString, required = false,
                                 default = nil)
  if valid_581243 != nil:
    section.add "userIp", valid_581243
  assert query != nil,
        "query argument is necessary due to required `channelId` field"
  var valid_581244 = query.getOrDefault("channelId")
  valid_581244 = validateParameter(valid_581244, JString, required = true,
                                 default = nil)
  if valid_581244 != nil:
    section.add "channelId", valid_581244
  var valid_581245 = query.getOrDefault("key")
  valid_581245 = validateParameter(valid_581245, JString, required = false,
                                 default = nil)
  if valid_581245 != nil:
    section.add "key", valid_581245
  var valid_581246 = query.getOrDefault("prettyPrint")
  valid_581246 = validateParameter(valid_581246, JBool, required = false,
                                 default = newJBool(true))
  if valid_581246 != nil:
    section.add "prettyPrint", valid_581246
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

proc call*(call_581248: Call_YoutubeWatermarksSet_581235; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Uploads a watermark image to YouTube and sets it for a channel.
  ## 
  let valid = call_581248.validator(path, query, header, formData, body)
  let scheme = call_581248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581248.url(scheme.get, call_581248.host, call_581248.base,
                         call_581248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581248, url, valid)

proc call*(call_581249: Call_YoutubeWatermarksSet_581235; channelId: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## youtubeWatermarksSet
  ## Uploads a watermark image to YouTube and sets it for a channel.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   channelId: string (required)
  ##            : The channelId parameter specifies the YouTube channel ID for which the watermark is being provided.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_581250 = newJObject()
  var body_581251 = newJObject()
  add(query_581250, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_581250, "fields", newJString(fields))
  add(query_581250, "quotaUser", newJString(quotaUser))
  add(query_581250, "alt", newJString(alt))
  add(query_581250, "oauth_token", newJString(oauthToken))
  add(query_581250, "userIp", newJString(userIp))
  add(query_581250, "channelId", newJString(channelId))
  add(query_581250, "key", newJString(key))
  if body != nil:
    body_581251 = body
  add(query_581250, "prettyPrint", newJBool(prettyPrint))
  result = call_581249.call(nil, query_581250, nil, nil, body_581251)

var youtubeWatermarksSet* = Call_YoutubeWatermarksSet_581235(
    name: "youtubeWatermarksSet", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/watermarks/set",
    validator: validate_YoutubeWatermarksSet_581236, base: "/youtube/v3",
    url: url_YoutubeWatermarksSet_581237, schemes: {Scheme.Https})
type
  Call_YoutubeWatermarksUnset_581252 = ref object of OpenApiRestCall_579437
proc url_YoutubeWatermarksUnset_581254(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeWatermarksUnset_581253(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a channel's watermark image.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   channelId: JString (required)
  ##            : The channelId parameter specifies the YouTube channel ID for which the watermark is being unset.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_581255 = query.getOrDefault("onBehalfOfContentOwner")
  valid_581255 = validateParameter(valid_581255, JString, required = false,
                                 default = nil)
  if valid_581255 != nil:
    section.add "onBehalfOfContentOwner", valid_581255
  var valid_581256 = query.getOrDefault("fields")
  valid_581256 = validateParameter(valid_581256, JString, required = false,
                                 default = nil)
  if valid_581256 != nil:
    section.add "fields", valid_581256
  var valid_581257 = query.getOrDefault("quotaUser")
  valid_581257 = validateParameter(valid_581257, JString, required = false,
                                 default = nil)
  if valid_581257 != nil:
    section.add "quotaUser", valid_581257
  var valid_581258 = query.getOrDefault("alt")
  valid_581258 = validateParameter(valid_581258, JString, required = false,
                                 default = newJString("json"))
  if valid_581258 != nil:
    section.add "alt", valid_581258
  var valid_581259 = query.getOrDefault("oauth_token")
  valid_581259 = validateParameter(valid_581259, JString, required = false,
                                 default = nil)
  if valid_581259 != nil:
    section.add "oauth_token", valid_581259
  var valid_581260 = query.getOrDefault("userIp")
  valid_581260 = validateParameter(valid_581260, JString, required = false,
                                 default = nil)
  if valid_581260 != nil:
    section.add "userIp", valid_581260
  assert query != nil,
        "query argument is necessary due to required `channelId` field"
  var valid_581261 = query.getOrDefault("channelId")
  valid_581261 = validateParameter(valid_581261, JString, required = true,
                                 default = nil)
  if valid_581261 != nil:
    section.add "channelId", valid_581261
  var valid_581262 = query.getOrDefault("key")
  valid_581262 = validateParameter(valid_581262, JString, required = false,
                                 default = nil)
  if valid_581262 != nil:
    section.add "key", valid_581262
  var valid_581263 = query.getOrDefault("prettyPrint")
  valid_581263 = validateParameter(valid_581263, JBool, required = false,
                                 default = newJBool(true))
  if valid_581263 != nil:
    section.add "prettyPrint", valid_581263
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581264: Call_YoutubeWatermarksUnset_581252; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a channel's watermark image.
  ## 
  let valid = call_581264.validator(path, query, header, formData, body)
  let scheme = call_581264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581264.url(scheme.get, call_581264.host, call_581264.base,
                         call_581264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581264, url, valid)

proc call*(call_581265: Call_YoutubeWatermarksUnset_581252; channelId: string;
          onBehalfOfContentOwner: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## youtubeWatermarksUnset
  ## Deletes a channel's watermark image.
  ##   onBehalfOfContentOwner: string
  ##                         : Note: This parameter is intended exclusively for YouTube content partners.
  ## 
  ## The onBehalfOfContentOwner parameter indicates that the request's authorization credentials identify a YouTube CMS user who is acting on behalf of the content owner specified in the parameter value. This parameter is intended for YouTube content partners that own and manage many different YouTube channels. It allows content owners to authenticate once and get access to all their video and channel data, without having to provide authentication credentials for each individual channel. The CMS account that the user authenticates with must be linked to the specified YouTube content owner.
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
  ##   channelId: string (required)
  ##            : The channelId parameter specifies the YouTube channel ID for which the watermark is being unset.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_581266 = newJObject()
  add(query_581266, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_581266, "fields", newJString(fields))
  add(query_581266, "quotaUser", newJString(quotaUser))
  add(query_581266, "alt", newJString(alt))
  add(query_581266, "oauth_token", newJString(oauthToken))
  add(query_581266, "userIp", newJString(userIp))
  add(query_581266, "channelId", newJString(channelId))
  add(query_581266, "key", newJString(key))
  add(query_581266, "prettyPrint", newJBool(prettyPrint))
  result = call_581265.call(nil, query_581266, nil, nil, nil)

var youtubeWatermarksUnset* = Call_YoutubeWatermarksUnset_581252(
    name: "youtubeWatermarksUnset", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/watermarks/unset",
    validator: validate_YoutubeWatermarksUnset_581253, base: "/youtube/v3",
    url: url_YoutubeWatermarksUnset_581254, schemes: {Scheme.Https})
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
